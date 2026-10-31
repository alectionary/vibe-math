#!/usr/bin/env python3
"""Independent physical/matrix/strict-start and final-pricing batch-IPM replay."""
from fractions import Fraction as Q
from pathlib import Path
from two_basis_replay_paths import RecordedRoot
import argparse
import json
import time
import numpy as np
from scipy.sparse import csc_matrix
from verify_two_sided_full_basis_oracle import ROOT, sha, read, physical_source, domains, target, check_sector
from audit_two_sided_full_basis_endpoint import check_basis


def rows(m,B):return list(B)+[720*(i+1)+j for i in range(4) if m>>i&1 for j in B]


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--report',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--recorded-root',type=Path,required=True)
    a=ap.parse_args();paths=RecordedRoot(ROOT,a.recorded_root);assert sha(ROOT/'verify_two_basis_batch_ipm.py')=='effc7262a5657c0e19df051471d0b0eb2a96111346b4fad031642ec89071390a';assert not a.output.exists();start=time.monotonic();report=read(a.report);stem=a.report.with_suffix('')
    frozen_path=Path(str(stem)+'.frozen.json');frozen=read(frozen_path)
    assert report['frozen_sha256']==sha(frozen_path)
    for k,v in frozen.items():
        if k!='status':assert report[k]==v,k
    assert all(sha(ROOT/p)==h for p,h in report['source_hashes'].items())
    point=ROOT/'coupling-results/integer-witness15-rational.json.gz';assert report['point_sha256']==sha(point)
    initial_path=paths.resolve(report['exact_initial_witness']);initial=read(initial_path)
    matrix_path=Path(str(stem)+'.lp-data.npz');data=np.load(matrix_path,allow_pickle=False)
    assert initial['status']=='EXACT_STRICT_PHASE_I_FEASIBLE_WITNESS_CANDIDATE'
    assert sha(initial_path)==report['exact_initial_witness_sha256'] and initial['frozen_sha256']==sha(frozen_path)
    assert initial['lp_data_sha256']==report['lp_data_sha256']==sha(matrix_path)
    assert initial['source_hashes']==report['source_hashes'] and initial['point_sha256']==sha(point)
    xx,zz,side=report['X_anchors'],report['Z_anchors'],report['side'];assert side=='X'
    assert xx==initial['X_anchors'] and zz==initial['Z_anchors'] and initial['side']==side
    lam=list(map(Q,report['lambda_masses']));assert lam==list(map(Q,initial['lambda_masses'])) and len(lam)==16 and min(lam)>=0 and sum(lam)==1
    positive=[m for m,v in enumerate(lam) if v];assert positive==report['positive_patterns']==data['positive_patterns'].tolist()
    assert report['deleted_zero_patterns']==[m for m,v in enumerate(lam) if not v]
    X,Z,bridge=physical_source();dd=domains(X,Z,xx,zz);full=target(point,xx,zz)
    wanted=full[11:731]+[full[1451+1440*i+j] for i in range(4) for j in range(720)]
    assert wanted==list(map(Q,report['sector_target']))==list(map(Q,initial['sector_target']))
    for k in range(11):
        def low(m):
            bits=[m>>i&1 for i in range(4)];return [1,*bits,*[bits[i]*bits[j] for i in range(4) for j in range(i+1,4)]][k]
        assert sum(lam[m]*low(m) for m in range(16))==full[k]
    masks,B,sourceids=data['masks'],data['selected_indices'],data['original_archive_column_ids'];N=len(masks);K=len(positive)
    assert B.shape==(N,128) and sourceids.shape==(N,) and N==report['physical_columns']
    assert data['shape'].tolist()==[K+3600,N+7200] and report['mass_rows']==K and report['feature_rows']==3600
    assert N+7200==report['variable_count'] and all(d['feasible'] for d in dd)
    oldpath=ROOT/report['initial_archive'];assert sha(oldpath)==report['initial_archive_sha256'];old=np.load(oldpath,allow_pickle=False)
    expected=[];seen=set()
    for i,(m,bb) in enumerate(zip(old['masks'],old['selected_X_indices'])):
        key=(int(m),tuple(map(int,bb)))
        if not lam[int(m)] or key in seen:continue
        seen.add(key);expected.append(i)
    assert expected==sourceids.tolist()
    massrow={m:i for i,m in enumerate(positive)};counts={m:0 for m in positive};featurecounts={m:np.zeros(3600,dtype=np.int64) for m in positive}
    ptr,ri,values=data['column_starts'],data['row_indices'],data['values']
    assert ptr.shape==(N+7201,) and int(ptr[0])==0 and int(ptr[-1])==len(ri)==len(values)==report['nonzeros'] and np.all(np.diff(ptr)>0)
    for i,(m,bb,sourceid) in enumerate(zip(masks,B,sourceids)):
        m=int(m);basis=list(map(int,bb));assert m in positive and old['masks'][sourceid]==m and np.array_equal(old['selected_X_indices'][sourceid],bb)
        check_basis(X,dd[m]['X'],basis);counts[m]+=1;rr=rows(m,basis);featurecounts[m][rr]+=1
        assert ri[ptr[i]:ptr[i+1]].tolist()==[massrow[m],*[K+j for j in rr]]
        assert np.all(values[ptr[i]:ptr[i+1]]==1)
    for sign,base in [(1,N),(-1,N+3600)]:
        for j in range(3600):
            i=base+j;assert ptr[i+1]-ptr[i]==1 and ri[ptr[i]]==K+j and values[ptr[i]]==sign
    assert initial['pattern_records']==[dict(mask=m,basis_count=counts[m],weight_per_basis=str(lam[m]/counts[m])) for m in positive]
    actual=[sum(lam[m]*int(featurecounts[m][j])/counts[m] for m in positive) for j in range(3600)]
    ep,en=list(map(Q,initial['positive_feature_errors'])),list(map(Q,initial['negative_feature_errors']))
    assert len(ep)==len(en)==3600 and min(ep+en)>0 and all(lam[m]/counts[m]>0 for m in positive)
    assert all(p==1+max(t-x,Q(0)) and n==1+max(x-t,Q(0)) and x+p-n==t for x,p,n,t in zip(actual,ep,en,wanted))
    exactobj=sum(ep)+sum(en);assert exactobj==Q(initial['phase_I_objective']) and initial['all_model_variables_strictly_positive']
    exactrhs=[*[lam[m] for m in positive],*wanted];assert np.array_equal(data['rhs'],np.asarray(list(map(float,exactrhs))))
    A=csc_matrix((values,ri,ptr),shape=tuple(data['shape']));solution_path=paths.resolve(report['solution_artifact']);assert sha(solution_path)==report['solution_sha256']
    sol=np.load(solution_path,allow_pickle=False);x,y,cd,rv=sol['column_values'],sol['row_dual'],sol['column_dual'],sol['row_values']
    assert x.shape==(N+7200,) and y.shape==rv.shape==(K+3600,) and cd.shape==x.shape and all(np.isfinite(v).all() for v in [x,y,cd,rv])
    lhs=A@x;found=np.asarray(A[K:,:N]@x[:N]);targetfloat=data['rhs'][K:]
    numerical=dict(minimum_variable=float(min(x)),maximum_mass_residual=float(max(abs(lhs[:K]-data['rhs'][:K]))),maximum_phase_I_equality_residual=float(max(abs(lhs[K:]-targetfloat))),maximum_feature_residual=float(max(abs(found-targetfloat))),feature_L1_residual=float(sum(abs(found-targetfloat))))
    for k,v in numerical.items():assert abs(v-report['numerical_residual'][k])<1e-10,k
    objective=float(sum(x[N:]));assert abs(objective-report['solver_objective'])<1e-8
    assert max(abs(rv-lhs))<1e-10
    costs=np.r_[np.zeros(N),np.ones(7200)];reduced=costs-A.T@y
    dualres=float(max(abs(reduced-cd)));dualineq=float(max(0,-min(reduced)));dualitygap=objective-float(data['rhs']@y)
    assert dualres<1e-7
    pricing=report['priced_direction'];assert pricing and pricing['dual_source_is_discovery_only']
    scale=2**24;raw=y[K:];norm=max(abs(raw));assert norm>0
    c=[int(np.rint(v*scale/norm)) for v in raw];assert c==pricing['coefficients']
    assert pricing['lambda_masses']==report['lambda_masses']
    records=pricing['support_records'];assert [r['mask'] for r in records]==list(range(16))
    bounds=[];prefix=0
    for m,r in enumerate(records):
        w=[c[j]+sum(c[720*(i+1)+j] for i in range(4) if m>>i&1) for j in range(720)]
        value,count=check_sector(X,128,dd[m]['X'],w,r['selected_indices']);prefix+=count
        assert value==Q(r['value']);bounds.append(value)
        sd=dd[m]['X'];basis=r['selected_indices']
        assert sorted(r['zero_basis_indices'])==sorted(j for j in basis if not sd['signatures'][j])
        assert r['owner_indices']==[next(j for j in basis if sd['signatures'][j]==(o,)) for o in sd['opposite']]
    left=sum(v*t for v,t in zip(c,wanted));right=sum(v*t for v,t in zip(bounds,lam));gap=left-right
    assert bounds==pricing['pattern_bounds'] and left==Q(pricing['exact_left']) and right==Q(pricing['exact_right_at_lambda']) and gap==Q(pricing['exact_violation'])<=0
    assert report['status']=='BOUNDED_BATCH_IPM_INCONCLUSIVE' and not report['cuts'] and not report['exact_target_membership_proved'] and not report['global_moment_cut_proved']
    out=dict(portable_replay=paths.evidence(),frozen_consumer_sha256=sha(ROOT/'verify_two_basis_batch_ipm.py'),status='PASS_EXACT_STRICT_PHASE_I_AND_FINAL_PRICING_INCONCLUSIVE',source_C16_answered=False,consumer_sha256=sha(__file__),
      report_sha256=sha(a.report),frozen_sha256=sha(frozen_path),initial_witness_sha256=sha(initial_path),lp_data_sha256=sha(matrix_path),solution_sha256=sha(solution_path),
      point_sha256=sha(point),source_hashes=report['source_hashes'],physical_symmetry_bridge=bridge,
      physical_basis_columns_checked=N,archived_basis_deduplication_and_order_replayed=True,positive_patterns=positive,deleted_zero_patterns=report['deleted_zero_patterns'],
      exact_matrix_columns_checked=N+7200,exact_feature_equations=3600,exact_pattern_mass_equations=K,exact_anchor_moment_equations=11,
      exact_all_variables_strictly_positive_start=True,exact_initial_phase_I_objective=str(exactobj),
      numeric_residuals_recomputed=numerical,numeric_objective=objective,numeric_dual_reduced_cost_error=dualres,numeric_dual_inequality_violation=dualineq,numeric_primal_dual_gap=dualitygap,
      final_support_patterns_checked=16,final_signed_prefix_rank_checks=prefix,exact_final_left=str(left),exact_final_right=str(right),exact_final_gap=str(gap),normalized_final_gap=float(gap/scale),
      solver_status=report['solver_status'],reported_solve_seconds=report['solve_seconds'],elapsed_seconds=time.monotonic()-start,
      exact_restricted_optimum_proved=False,exact_target_membership_proved=False,global_moment_cut_proved=False,
      dependencies={p:sha(ROOT/p) for p in ['verify_two_sided_full_basis_oracle.py','audit_two_sided_full_basis_endpoint.py']},
      scope='All restricted physical columns, exact signed-error matrix and strictly positive phase-I start replayed. Final dual-derived direction has independently exact sixteen-pattern physical support and negative gap. Numerical restricted optimality is not an exact optimum certificate. No target sector allocation, joint law, source frame or case exclusion follows.')
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='source_hashes'},indent=2))

if __name__=='__main__':main()
