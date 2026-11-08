#!/usr/bin/env python3
"""Multi-orbit batched Wolfe pilot with independently checked physical seeds.

Physical source orbits except12 use separate profile universes and owner target indices.
The frozen original orbit32 producers remain unchanged.

QR affine minimization and simplex-boundary minor cycles maintain a numerical
convex combination. Exact integer global pricing alone can produce a separating
candidate. Small residuals require a separate exact physical-mixture consumer.
"""
from pathlib import Path
import argparse,hashlib,json,resource,sys,time,math
import numpy as np
from scipy.linalg import lstsq
from full_partner_projection import mask_universe,sha,read,LAYOUT
from full_partner_safe_pricing import support_all
from full_partner_batched_weights import IntegerPhaseWeightBatch
from full_partner_projection_features import FEATURES, moment_target
from verify_projected_profile_moment_rows import point_vector
from fractions import Fraction
from full_partner_basis_oracle import FullPartnerBasisOracle
ROOT=Path(__file__).resolve().parent


def exact_seed(point,archive,orbit):
    target=moment_target(point_vector(point),orbit);z=np.load(archive)
    assert int(z['orbit'])==orbit
    all_weights=z['master_mixture_weights'];assert all_weights.min()>=0
    selected=np.flatnonzero(all_weights>0)
    weights=[Fraction(float(all_weights[i])) for i in selected]
    denominator=math.lcm(*(w.denominator for w in weights))
    integers=[w.numerator*(denominator//w.denominator) for w in weights]
    total=sum(integers);assert total>0
    F=z['features'][selected].astype(object)
    sums=np.asarray(integers,dtype=object)@F;sums2=np.asarray(integers,dtype=object)@(F*F)
    mixture=[Fraction(int(v),total) for v in sums]
    variance=[Fraction(int(v),total)-m*m for v,m in zip(sums2,mixture)]
    assert all(v>=0 for v in variance) and target[0]==mixture[0]==1
    return target,mixture,[b-m for b,m in zip(target,mixture)],variance,selected,integers,total


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--point',type=Path,required=True);ap.add_argument('--archive',type=Path,required=True)
    ap.add_argument('--orbit',type=int,choices=tuple(o for o in range(45) if o!=12),required=True)
    ap.add_argument('--seed-report',type=Path,required=True);ap.add_argument('--seed-replay',type=Path,required=True)
    ap.add_argument('--audit',type=Path,default=ROOT/'coupling-results/full-partner-projection-independent-audit.json')
    ap.add_argument('--metric',choices=['raw','target_relative','variance'],default='raw')
    ap.add_argument('--seconds',type=float,default=180);ap.add_argument('--max-rounds',type=int,default=1000)
    ap.add_argument('--pricing-scale',type=int,default=1<<24);ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--max-cuts',type=int,default=8);ap.add_argument('--stop-after-cuts',action='store_true')
    a=ap.parse_args();assert 0<a.seconds<=180 and a.pricing_scale>0 and a.max_cuts>0 and not a.output.exists()
    start=time.monotonic();audit=read(a.audit);assert audit['status'].startswith('PASS')
    seed=read(a.seed_report);replay=read(a.seed_replay)
    assert replay['status']=='PASS' and seed['orbit']==replay['orbit']==a.orbit
    assert seed['columns_sha256']==replay['seed_archive_sha256']==sha(a.archive)
    assert replay['seed_columns_physically_checked']==seed['feature_columns']
    assert replay['consumer_sha256']==sha(ROOT/'verify_full_partner_projection_multi_orbit.py')
    assert all(sha(ROOT/p)==s for p,s in replay['source_hashes'].items())
    target,seed_mixture,residual,variance,selected,numerators,denominator=exact_seed(a.point,a.archive,a.orbit)
    from fractions import Fraction
    diagonal=([Fraction(1)]*775 if a.metric=='raw' else
              [1/max(Fraction(1,16),abs(v))**2 for v in target] if a.metric=='target_relative' else
              [1/max(Fraction(1,256),v) for v in variance])
    D=np.asarray(list(map(float,diagonal)));sqrtD=np.sqrt(D[1:]);b=np.asarray(list(map(float,target)));scale=a.pricing_scale
    saved=np.load(a.archive);F0=saved['features'][selected];features=[r for r in F0]
    masks=list(map(int,saved['masks'][selected]));witnesses=[r for r in saved['selected_Z_indices'][selected]]
    lookup={f.tobytes():i for i,f in enumerate(features)};assert len(lookup)==len(features)
    active=list(range(len(selected)));weights=np.asarray([float(Fraction(n,denominator)) for n in numerators]);weights/=weights.sum()
    allowed,reps=mask_universe(a.orbit);oracle=FullPartnerBasisOracle();domains=[(p,oracle.prepare(a.orbit,p)) for p in reps];batch=IntegerPhaseWeightBatch(reps)
    paths=['full_partner_projection_wolfe_multi_orbit.py','verify_full_partner_projection_multi_orbit.py','full_partner_safe_pricing.py','full_partner_batched_weights.py','full_partner_projection.py',
        'full_partner_projection_features.py','full_partner_basis_oracle.py','verify_projected_profile_moment_rows.py',
        'projected_profile_moment_matrix.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt',
        'algebraic-results/orbit-rank-profiles.json.gz','algebraic-results/hulls-16-rank.json.gz',
        'moment-resumption-results/symmetry-bridge-independent.json',str(a.seed_report.resolve().relative_to(ROOT.resolve())),str(a.seed_replay.resolve().relative_to(ROOT.resolve())),
        str(a.audit.resolve().relative_to(ROOT.resolve())),
        'coupling-results/full-partner-projection-independent-audit.py']
    hashes={p:sha(ROOT/p) for p in paths}
    frozen={'status':'FROZEN_BEFORE_BATCHED_WOLFE_RESTART','source_C16_answered':False,'point_sha256':sha(a.point),
        'archive_sha256':sha(a.archive),'seed_report_sha256':sha(a.seed_report),'seed_replay_sha256':sha(a.seed_replay),'mapping_audit_sha256':sha(a.audit),'source_hashes':hashes,
        'orbit':a.orbit,'feature_layout':LAYOUT,'allowed_masks':len(allowed),'representatives':reps,
        'allowed_mask_list_sha256':hashlib.sha256(json.dumps(allowed,separators=(',',':')).encode()).hexdigest(),
        'metric':a.metric,'metric_diagonal':list(map(str,diagonal)),'initial_active_columns':active,
        'initial_source_archive_column_ids':selected.tolist(),'restart_subset':'all strictlypositive input mixture columns',
        'maximum_retained_cuts':a.max_cuts,'stop_after_cuts':a.stop_after_cuts,
        'initial_exact_weight_numerators':list(map(str,numerators)),'initial_exact_weight_denominator':str(denominator),
        'seconds':a.seconds,'pricing_scale':scale,'max_rounds':a.max_rounds,
        'controls':'QR affine rank, feasible minor-cycle weights, objective decrease, corral stationarity, true-gradient witness scores and quantization-aware Wolfe bound.',
        'scope':'Batched numerical Wolfe restart; retains strongest normalized exactgap candidates within the fixedtime cap. All positive directions are logged; only retained cuts receive fullcertificate export and require independent acceptance.'}
    fp=a.output.with_suffix('.frozen.json');assert not fp.exists();fp.write_text(json.dumps(frozen,indent=2)+'\n')

    def point(ids,w):return w@np.asarray([features[i] for i in ids],dtype=float)
    def objective(x):return .5*float(np.dot(D*(x-b),x-b))
    def correction(ids,w):
        ids=list(ids);w=w.copy();minor=[];before=time.monotonic()
        for step in range(1000):
            if time.monotonic()-start>=a.seconds:return ids,w,minor,'TIME_LIMIT_DURING_CORRECTION'
            oldx=point(ids,w);oldobj=objective(oldx);V=np.asarray([features[i][1:] for i in ids],dtype=float)
            if len(ids)==1:alpha=np.ones(1);rank=0
            else:
                U=(V[1:]-V[0]).T*sqrtD[:,None];rhs=(b[1:]-V[0])*sqrtD
                eta,_,rank,_=lstsq(U,rhs,cond=1e-12,lapack_driver='gelsy')
                if rank!=len(ids)-1:return ids,w,minor,'AFFINE_RANK_FAILURE'
                alpha=np.r_[1-eta.sum(),eta]
            if alpha.min()>=-1e-11:
                candidate=np.maximum(alpha,0);candidate/=candidate.sum();keep=candidate>0
                ids=[i for i,k in zip(ids,keep) if k];candidate=candidate[keep]
                newobj=objective(point(ids,candidate));assert newobj<=oldobj+1e-9*max(1.,oldobj)
                minor.append({'step':step,'active_columns':len(ids),'objective_before':oldobj,'objective_after':newobj,
                              'affine_rank':int(rank),'completed_corral':True})
                return ids,candidate,minor,None
            bad=np.flatnonzero(alpha<0);ratios=w[bad]/(w[bad]-alpha[bad]);hit=int(bad[int(np.argmin(ratios))]);theta=float(np.min(ratios))
            assert -1e-12<=theta<=1+1e-12
            candidate=(1-theta)*w+theta*alpha;candidate[hit]=0
            assert candidate.min()>=-1e-10
            candidate=np.maximum(candidate,0);candidate/=candidate.sum();keep=candidate>0
            newids=[i for i,k in zip(ids,keep) if k];candidate=candidate[keep];newobj=objective(point(newids,candidate))
            assert newobj<=oldobj+1e-9*max(1.,oldobj) and abs(candidate.sum()-1)<1e-10
            minor.append({'step':step,'active_before':len(ids),'active_after':len(newids),
                          'objective_before':oldobj,'objective_after':newobj,'theta':theta,'affine_rank':int(rank)})
            ids,w=newids,candidate
        return ids,w,minor,'MINOR_CYCLE_LIMIT'

    rounds=[];cuts=[];positive_proposals=[];seen_cuts=set();reason='ROUND_LIMIT';last_direction=np.zeros(775);last_bound=0
    result={**frozen,'status':'RUNNING','frozen_sha256':sha(fp),'rounds':rounds,'cuts':cuts,'positive_proposals':positive_proposals}
    for iteration in range(a.max_rounds):
        if time.monotonic()-start>=a.seconds:reason='TIME_LIMIT';break
        before=time.monotonic();active,weights,minor,failure=correction(active,weights)
        x=point(active,weights);r=b-x;raw=D*r;raw[0]=0;norm=max(abs(raw));obj=objective(x)
        rec={'round':iteration,'active_columns':len(active),'historical_columns':len(features),
             'correction_seconds':time.monotonic()-before,'minor_cycles':minor,'weighted_objective':obj,
             'max_feature_residual':float(max(abs(r))),'weight_mass':float(weights.sum()),
             'minimum_weight':float(weights.min()),'correction_failure':failure}
        rounds.append(rec)
        if failure:reason=failure;break
        V=np.asarray([features[i] for i in active],dtype=float)
        stationarity=float(np.max(abs((V-x)@raw)));rec['corral_stationarity_residual']=stationarity
        if stationarity>1e-7*max(1.,norm):reason='CORRAL_STATIONARITY_FAILURE';break
        if max(abs(r))<=1e-9:reason='NUMERICAL_MIXTURE_REQUIRES_EXACT_RECOVERY';break
        assert norm>0;direction=raw/norm;last_direction=direction
        c=[int(np.rint(v*scale)) for v in direction];c[0]=0
        before=time.monotonic();bound,records,columns=support_all(oracle,domains,c,batch);last_bound=bound/scale
        value=sum(a0*b0 for a0,b0 in zip(c,target));gap=value-bound
        scores=np.asarray([np.dot(direction,f) for f in columns]);best=int(np.argmax(scores));xscore=float(np.dot(direction,x))
        sample_gap=float(scores[best]-xscore);quantization=32*float(np.sum(abs(direction-np.asarray(c)/scale)))
        wolfe_upper=sample_gap+quantization
        rec.update(pricing_seconds=time.monotonic()-before,exact_integer_support=bound,
            exact_target_value=str(value),exact_violation=str(gap),scaled_violation=float(gap/scale),
            true_gradient_best_sample_gap=sample_gap,quantization_additive_bound=quantization,
            numerical_Wolfe_upper_with_rounding=wolfe_upper,best_mask=records[best]['mask'],
            peak_RSS_MiB=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss/(1024**2 if sys.platform=='darwin' else 1024))
        if gap>0:
            divisor=math.gcd(*[abs(v) for v in [*c,bound]]) or 1
            key=(tuple(v//divisor for v in c),bound//divisor)
            proposal={'round':iteration,'coefficients':c,'upper_bound':bound,'exact_target_value':str(value),
                      'exact_violation':str(gap),'pricing_scale':scale}
            positive_proposals.append(proposal)
            if key not in seen_cuts:
                seen_cuts.add(key);cuts.append({**proposal,'support_records':records})
                cuts.sort(key=lambda item:Fraction(item['exact_violation'])/item['pricing_scale'],reverse=True)
                del cuts[a.max_cuts:]
            rec['retained_cuts']=len(cuts);rec['positive_proposals_seen']=len(positive_proposals)
        print(json.dumps({k:v for k,v in rec.items() if k!='minor_cycles'}),flush=True)
        if a.stop_after_cuts and len(cuts)>=a.max_cuts:
            reason='EXACT_CUT_COLLECTION_LIMIT';break
        if wolfe_upper<=1e-10:reason='NUMERICAL_WOLFE_STOP_WITHOUT_EXACT_CERTIFICATE';break
        if sample_gap<=1e-12:reason='NO_TRUE_GRADIENT_IMPROVEMENT_FROM_ROUNDED_PRICING';break
        # Archive all queried physical witnesses, but add only the strongest
        # actual-gradient improvement to the corral.
        chosen=None
        for j,(feature,record) in enumerate(zip(columns,records)):
            f=np.asarray(feature,dtype=np.int16);key=f.tobytes();gid=lookup.get(key)
            if gid is None:
                gid=len(features);lookup[key]=gid;features.append(f);masks.append(record['mask'])
                witnesses.append(np.asarray(record['selected_Z_indices'],dtype=np.uint16))
            if j==best:chosen=gid
        if chosen in active:reason='PRICED_VERTEX_ALREADY_IN_CORRAL';break
        active.append(chosen);weights=np.r_[weights,0.]
        result.update(elapsed_seconds=time.monotonic()-start,feature_columns=len(features))
        if iteration % 20 == 0: a.output.write_text(json.dumps(result,indent=2)+'\n')
    global_weights=np.zeros(len(features));global_weights[np.asarray(active,dtype=np.int64)]=weights
    colpath=a.output.with_suffix('.columns.npz')
    np.savez_compressed(colpath,features=np.stack(features),masks=np.asarray(masks,dtype=np.uint16),
        selected_Z_indices=np.stack(witnesses),master_mixture_weights=global_weights,
        active_column_ids=np.asarray(active,dtype=np.int32),search_direction=last_direction,
        priced_bound=last_bound,metric_diagonal=D,orbit=a.orbit)
    x=point(active,weights);assert all(sha(ROOT/p)==digest for p,digest in hashes.items())
    result.update(status='EXACT_SUPPORT_CUT_CANDIDATE' if cuts else 'NO_EXACT_SEPARATOR_FOUND',
        stopping_reason=reason,elapsed_seconds=time.monotonic()-start,feature_columns=len(features),
        columns_artifact=str(colpath),columns_sha256=sha(colpath),numeric_mixture_max_feature_residual=float(max(abs(x-b))),
        numeric_mixture_weight_mass=float(weights.sum()),numeric_mixture_minimum_weight=float(weights.min()),
        positive_proposal_count=len(positive_proposals),retained_cut_count=len(cuts),
        scope='Batched Wolfe restart and bounded strongest-cut collection. Old archives remain immutable; new archive contains restartedpositive columns and new queriedwitnesses. Only independently replayed retainedcuts or exactmixture recovery establish auxiliary results; no source resolution is claimed.')
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:result[k] for k in ('status','stopping_reason','elapsed_seconds','feature_columns','numeric_mixture_max_feature_residual')}),flush=True)


if __name__=='__main__':main()
