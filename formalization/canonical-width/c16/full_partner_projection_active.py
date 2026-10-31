#!/usr/bin/env python3
"""Active-column775-equality primal master with complete historical archives.

First matches the previous primal master on the same column cohort, then drops
only zero nonbasic columns. Basis columns and the two latest pricing batches stay
active; any historical column can be reactivated by exact pricing.
"""
from pathlib import Path
import argparse,hashlib,json,resource,sys,time
import highspy
import numpy as np
from scipy.sparse import csc_matrix,coo_matrix
from full_partner_projection import mask_universe,support_all,sha,read,LAYOUT
from full_partner_basis_oracle import FullPartnerBasisOracle
from full_partner_projection_features import FEATURES,moment_target
from verify_projected_profile_moment_rows import point_vector
ROOT=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--point',type=Path,required=True);ap.add_argument('--seed-report',type=Path,required=True)
    ap.add_argument('--seconds',type=float,default=600);ap.add_argument('--max-rounds',type=int,default=300)
    ap.add_argument('--pricing-scale',type=int,default=65536);ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args();assert 0<a.seconds<=600 and not a.output.exists()
    start=time.monotonic();seed=read(a.seed_report);seed_path=Path(seed['columns_artifact'])
    if not seed_path.is_absolute():seed_path=ROOT/seed_path
    assert sha(seed_path)==seed['columns_sha256'] and sha(a.point)==seed['point_sha256']
    old=next(r for r in reversed(seed['rounds']) if r['model_status']=='HighsModelStatus.kOptimal')
    initial_count=old['master_columns'];saved=np.load(seed_path)
    assert saved['features'].shape[1]==775 and saved['selected_Z_indices'].shape[1]==128
    assert len(saved['features'])==seed['feature_columns']>=initial_count
    target=moment_target(point_vector(a.point));allowed,reps=mask_universe(32)
    paths=['full_partner_projection_active.py','full_partner_projection.py','full_partner_projection_features.py',
           'full_partner_basis_oracle.py','verify_projected_profile_moment_rows.py','projected_profile_moment_matrix.py',
           'physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt',
           'algebraic-results/orbit-rank-profiles.json.gz','algebraic-results/hulls-16-rank.json.gz',
           'moment-resumption-results/symmetry-bridge-independent.json','coupling-results/full-partner-orbit32-independent.json']
    sources={p:sha(ROOT/p) for p in paths}
    frozen={'status':'FROZEN_BEFORE_ACTIVE_FULL_PARTNER_PROJECTION','source_C16_answered':False,
            'point_sha256':sha(a.point),'source_hashes':sources,'orbit':32,'feature_layout':LAYOUT,
            'allowed_masks':len(allowed),'representatives':reps,'highspy_version':highspy.Highs().version(),
            'allowed_mask_list_sha256':hashlib.sha256(json.dumps(allowed,separators=(',',':')).encode()).hexdigest(),
            'seed_report_sha256':sha(a.seed_report),'seed_columns_sha256':sha(seed_path),
            'initial_matched_columns':initial_count,'prior_primal_master_objective':old['numeric_restricted_distance'],
            'prior_primal_master_seconds':old['LP_seconds'],'seconds':a.seconds,'pricing_scale':a.pricing_scale,
            'scope':'Primal L1 restricted master with775 equalities and exact full-partner pricing. Numerical feasibility still requires exact mixture recovery.'}
    fp=a.output.with_suffix('.frozen.json');assert not fp.exists();fp.write_text(json.dumps(frozen,indent=2)+'\n')
    oracle=FullPartnerBasisOracle();domains=[(p,oracle.prepare(32,p)) for p in reps]
    H=highspy.Highs()
    for k,v in [('output_flag',False),('threads',1),('solver','simplex'),('simplex_strategy',0),
                ('primal_feasibility_tolerance',1e-9),('dual_feasibility_tolerance',1e-9)]:
        assert H.setOptionValue(k,v)==highspy.HighsStatus.kOk
    b=np.asarray(list(map(float,target)))
    assert H.addRows(FEATURES,b,b,0,np.zeros(FEATURES+1,dtype=np.int32),np.array([],dtype=np.int32),np.array([],dtype=float))==highspy.HighsStatus.kOk
    errors=2*(FEATURES-1)
    E=coo_matrix((np.r_[np.ones(FEATURES-1),-np.ones(FEATURES-1)],
                  (np.tile(np.arange(1,FEATURES),2),np.arange(errors))),shape=(FEATURES,errors)).tocsc()
    assert H.addCols(errors,np.ones(errors),np.zeros(errors),np.full(errors,highspy.kHighsInf),
                     E.nnz,E.indptr.astype(np.int32),E.indices.astype(np.int32),E.data)==highspy.HighsStatus.kOk
    features=[];masks=[];witnesses=[];lookup={};active_ids=[];active_set=set();recent_batches=[]
    def add_columns(columns,records):
        fresh=[];new_ids=[]
        for column,record in zip(columns,records):
            packed=np.asarray(column,dtype=np.int16);key=packed.tobytes()
            gid=lookup.get(key)
            if gid is None:
                gid=len(features);lookup[key]=gid;features.append(packed)
                masks.append(int(record['mask']));witnesses.append(np.asarray(record['selected_Z_indices'],dtype=np.uint16))
            if gid in active_set:continue
            active_set.add(gid);active_ids.append(gid);new_ids.append(gid);fresh.append(features[gid])
        if fresh:
            M=csc_matrix(np.stack(fresh).T,dtype=float);n=len(fresh)
            assert H.addCols(n,np.zeros(n),np.zeros(n),np.full(n,highspy.kHighsInf),M.nnz,
                             M.indptr.astype(np.int32),M.indices.astype(np.int32),M.data)==highspy.HighsStatus.kOk
        return new_ids

    def save_solution():
        sol=H.getSolution();weights=np.zeros(len(features))
        assert len(sol.col_value)==errors+len(active_ids)
        weights[np.asarray(active_ids,dtype=np.int64)]=sol.col_value[errors:]
        return np.asarray(sol.row_dual),weights,np.asarray(sol.col_value[:errors])

    def prune_nonbasic():
        basis=H.getBasis();sol=H.getSolution();protected=set().union(*recent_batches[-2:]) if recent_batches else set()
        drop=[j for j,gid in enumerate(active_ids) if gid not in protected
              and basis.col_status[errors+j]!=highspy.HighsBasisStatus.kBasic
              and abs(sol.col_value[errors+j])<=1e-10]
        if drop:
            remove=np.asarray([errors+j for j in drop],dtype=np.int32)
            assert H.deleteCols(len(remove),remove)==highspy.HighsStatus.kOk
            drop_set=set(drop);retained=[gid for j,gid in enumerate(active_ids) if j not in drop_set]
            active_ids[:]=retained;active_set.clear();active_set.update(retained)
        return len(drop)
    seed_records=[{'mask':m,'selected_Z_indices':z} for m,z in zip(saved['masks'],saved['selected_Z_indices'])]
    add_columns(saved['features'][:initial_count],seed_records[:initial_count])
    rounds=[];cuts=[];last_weights=np.zeros(initial_count);last_dual=np.zeros(FEATURES);last_errors=np.zeros(errors)
    result={**frozen,'status':'RUNNING','frozen_sha256':sha(fp),'rounds':rounds,'cuts':cuts};reason='ROUND_LIMIT'
    for iteration in range(a.max_rounds):
        remaining=a.seconds-(time.monotonic()-start)
        if remaining<=0:reason='TIME_LIMIT';break
        H.setOptionValue('time_limit',H.getRunTime()+remaining)
        basis=bool(H.getBasis().valid);before=time.monotonic();H.run();elapsed=time.monotonic()-before
        info=H.getInfo();status=H.getModelStatus();peak=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss/(1024**2 if sys.platform=='darwin' else 1024)
        rec={'round':iteration,'master_columns':len(active_ids),'historical_columns':len(features),'master_equalities':775,'model_status':str(status),
             'LP_seconds':elapsed,'basis_valid_before_solve':basis,'simplex_iterations':info.simplex_iteration_count,
             'peak_RSS_MiB':peak,'numeric_restricted_distance':float(info.objective_function_value)}
        rounds.append(rec)
        if status!=highspy.HighsModelStatus.kOptimal:reason='MASTER_NOT_OPTIMAL';break
        last_dual,last_weights,last_errors=save_solution()
        if iteration==0:
            difference=abs(info.objective_function_value-old['numeric_restricted_distance'])
            assert difference<1e-6,('matched prior master objective mismatch',difference)
            rec['matched_cohort_objective_difference']=difference
            rec['prior_primal_LP_seconds']=old['LP_seconds']
        old_objective=float(info.objective_function_value)
        rec['zero_nonbasic_columns_pruned']=prune_nonbasic()
        rec['active_columns_after_prune']=len(active_ids)
        if iteration==0:
            before=time.monotonic();H.run();rec['first_pruned_resolve_seconds']=time.monotonic()-before
            assert H.getModelStatus()==highspy.HighsModelStatus.kOptimal
            rec['first_pruned_objective_difference']=abs(H.getInfo().objective_function_value-old_objective)
            assert rec['first_pruned_objective_difference']<1e-6
            last_dual,last_weights,last_errors=save_solution()
        c=(0,*(int(np.rint(v*a.pricing_scale)) for v in last_dual[1:]))
        before=time.monotonic();bound,records,columns=support_all(oracle,domains,c)
        value=sum(x*y for x,y in zip(c,target));gap=value-bound
        new_ids=add_columns(columns,records)
        if iteration==0:new_ids+=add_columns(saved['features'][initial_count:],seed_records[initial_count:])
        recent_batches.append(set(new_ids));added=len(new_ids)
        rec.update(pricing_seconds=time.monotonic()-before,columns_added=added,
                   exact_integer_support=bound,exact_target_value=str(value),exact_violation=str(gap),
                   scaled_violation=float(gap/a.pricing_scale),numeric_master_bound=-float(last_dual[0]),
                   rounded_global_bound=bound/a.pricing_scale,numeric_mixture_mass=float(last_weights.sum()),
                   numeric_positive_mixture_columns=int(np.count_nonzero(last_weights>1e-10)))
        print(json.dumps(rec),flush=True)
        if gap>0:
            cuts.append({'coefficients':list(c),'upper_bound':bound,'exact_target_value':str(value),
                         'exact_violation':str(gap),'pricing_scale':a.pricing_scale,'support_records':records})
            reason='EXACT_POSITIVE_SUPPORT_GAP_REQUIRES_INDEPENDENT_REPLAY';break
        result.update(elapsed_seconds=time.monotonic()-start,feature_columns=len(features));a.output.write_text(json.dumps(result,indent=2)+'\n')
        if peak>1500:reason='MEMORY_LIMIT_1500_MiB';break
        if info.objective_function_value<=1e-9:reason='NUMERIC_MIXTURE_FOUND_REQUIRES_EXACT_RECOVERY';break
        if added==0:reason='NO_NEW_COLUMNS_NUMERICAL_STALL';break
        if bound/a.pricing_scale<=-float(last_dual[0])+1e-8:reason='NO_EXACT_SEPARATOR_AT_NUMERICAL_STOP';break
    padded=np.pad(last_weights,(0,len(features)-len(last_weights)));column_path=a.output.with_suffix('.columns.npz')
    np.savez_compressed(column_path,features=np.stack(features),masks=np.asarray(masks,dtype=np.uint16),
                        selected_Z_indices=np.stack(witnesses),master_mixture_weights=padded,
                        master_dual_coefficients=last_dual[1:],master_bound=-last_dual[0],master_errors=last_errors,
                        active_column_ids=np.asarray(active_ids,dtype=np.int32))
    mixture=padded@np.asarray(features,dtype=float)
    unchanged={p:sha(ROOT/p)==digest for p,digest in sources.items()};assert all(unchanged.values())
    result.update(status='EXACT_SUPPORT_CUT_CANDIDATE' if cuts else 'NO_EXACT_SEPARATOR_FOUND',
                  stopping_reason=reason,elapsed_seconds=time.monotonic()-start,feature_columns=len(features),
                  columns_artifact=str(column_path),columns_sha256=sha(column_path),
                  numeric_mixture_max_feature_residual=float(np.max(abs(mixture-b))),
                  numeric_mixture_min_weight=float(padded.min(initial=0)),source_files_unchanged=unchanged,
                  scope='Initial cohort and first zero-nonbasic pruning controlled against prior optimal objectives. All historical columns and numerical mixture weights are preserved; exact global pricing governs support cuts. No exact mixture or source acceptance is inferred.')
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:result[k] for k in ('status','stopping_reason','elapsed_seconds','feature_columns','numeric_mixture_max_feature_residual')}),flush=True)


if __name__=='__main__':main()
