#!/usr/bin/env python3
"""Bounded warm-started HiGHS master with exact full-partner pricing.

Retains every integer feature column and its physical128-vector witness. Saved
master row-dual weights are numerical membership recovery candidates only.
"""
from pathlib import Path
import argparse
import hashlib
import json
import resource
import sys
import time

import highspy
import numpy as np
from scipy.sparse import csr_matrix, hstack

from full_partner_projection import mask_universe, support_all, sha, read, LAYOUT
from full_partner_basis_oracle import FullPartnerBasisOracle
from full_partner_projection_features import FEATURES, moment_target
from verify_projected_profile_moment_rows import point_vector

ROOT=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--point',type=Path,required=True)
    ap.add_argument('--seconds',type=float,default=600)
    ap.add_argument('--max-rounds',type=int,default=200)
    ap.add_argument('--pricing-scale',type=int,default=65536)
    ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args();assert 0<a.seconds<=600 and a.pricing_scale>0
    assert not a.output.exists() and not a.output.with_suffix('.frozen.json').exists()
    a.output.parent.mkdir(parents=True,exist_ok=True);start=time.monotonic()
    allowed,reps=mask_universe(32);target=moment_target(point_vector(a.point))
    paths=['full_partner_projection_incremental.py','full_partner_projection.py','full_partner_projection_features.py',
           'full_partner_basis_oracle.py','verify_projected_profile_moment_rows.py','projected_profile_moment_matrix.py',
           'physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt',
           'algebraic-results/orbit-rank-profiles.json.gz','algebraic-results/hulls-16-rank.json.gz',
           'moment-resumption-results/symmetry-bridge-independent.json','coupling-results/full-partner-orbit32-independent.json']
    sources={p:sha(ROOT/p) for p in paths}
    frozen={'status':'FROZEN_BEFORE_INCREMENTAL_FULL_PARTNER_PROJECTION','source_C16_answered':False,
            'point_sha256':sha(a.point),'source_hashes':sources,'orbit':32,'feature_layout':LAYOUT,
            'allowed_masks':len(allowed),'representatives':reps,
            'allowed_mask_list_sha256':hashlib.sha256(json.dumps(allowed,separators=(',',':')).encode()).hexdigest(),
            'highspy_version':highspy.Highs().version(),'seconds':a.seconds,'max_rounds':a.max_rounds,
            'pricing_scale':a.pricing_scale,'dual_coefficient_box':[-1,1],
            'master':'Persistent HiGHS simplex model; addRows retains/extends current basis. All columns and witnesses retained.',
            'scope':'Numerical separation/membership search only; exact support cuts and exact mixture recovery require independent replay.'}
    fp=a.output.with_suffix('.frozen.json');fp.write_text(json.dumps(frozen,indent=2)+'\n')
    oracle=FullPartnerBasisOracle();domains=[(p,oracle.prepare(32,p)) for p in reps]
    H=highspy.Highs()
    for name,value in [('output_flag',False),('threads',1),('solver','simplex'),
                       ('primal_feasibility_tolerance',1e-9),('dual_feasibility_tolerance',1e-9)]:
        assert H.setOptionValue(name,value)==highspy.HighsStatus.kOk
    lower=np.r_[-np.ones(FEATURES-1),-highspy.kHighsInf]
    upper=np.r_[np.ones(FEATURES-1),highspy.kHighsInf]
    assert H.addVars(FEATURES,lower,upper)==highspy.HighsStatus.kOk
    cost=np.r_[-np.asarray(list(map(float,target[1:]))),1.0]
    assert H.changeColsCost(FEATURES,np.arange(FEATURES,dtype=np.int32),cost)==highspy.HighsStatus.kOk
    features=[];masks=[];witnesses=[];seen=set()

    def add_columns(columns,records):
        fresh=[]
        for column,record in zip(columns,records):
            packed=np.asarray(column,dtype=np.int16);key=packed.tobytes()
            if key in seen:continue
            seen.add(key);features.append(packed);fresh.append(packed[1:])
            masks.append(record['mask']);witnesses.append(record['selected_Z_indices'])
        if fresh:
            A=hstack([csr_matrix(np.stack(fresh)),-np.ones((len(fresh),1))],format='csr')
            assert H.addRows(len(fresh),np.full(len(fresh),-highspy.kHighsInf),np.zeros(len(fresh)),
                             A.nnz,A.indptr.astype(np.int32),A.indices.astype(np.int32),A.data.astype(float))==highspy.HighsStatus.kOk
        return len(fresh)

    _,initial_records,initial=support_all(oracle,domains,(0,)*FEATURES);add_columns(initial,initial_records)
    rounds=[];cuts=[];last_weights=np.zeros(len(features));last_solution=np.zeros(FEATURES)
    result={**frozen,'status':'RUNNING','frozen_sha256':sha(fp),'rounds':rounds,'cuts':cuts}
    reason='ROUND_LIMIT'
    for iteration in range(a.max_rounds):
        remaining=a.seconds-(time.monotonic()-start)
        if remaining<=0:reason='TIME_LIMIT';break
        # HiGHS getRunTime is cumulative over incremental runs. Add only the
        # remaining wall budget to its current solver clock.
        H.setOptionValue('time_limit',H.getRunTime()+remaining)
        basis_before=bool(H.getBasis().valid)
        before=time.monotonic();H.run();LP_seconds=time.monotonic()-before
        status=H.getModelStatus();info=H.getInfo()
        peak=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss/(1024**2 if sys.platform=='darwin' else 1024)
        rec={'round':iteration,'master_columns':len(features),'model_status':str(status),
             'LP_seconds':LP_seconds,'basis_valid_before_solve':basis_before,
             'simplex_iterations':info.simplex_iteration_count,'peak_RSS_MiB':peak,
             'numeric_restricted_separation':-float(info.objective_function_value)}
        rounds.append(rec)
        if status!=highspy.HighsModelStatus.kOptimal:
            reason='MASTER_NOT_OPTIMAL';break
        sol=H.getSolution();last_solution=np.asarray(sol.col_value);last_weights=-np.asarray(sol.row_dual)
        assert len(last_weights)==len(features)
        coefficients=(0,*(int(np.rint(v*a.pricing_scale)) for v in last_solution[:-1]))
        before=time.monotonic();bound,records,columns=support_all(oracle,domains,coefficients)
        value=sum(c*t for c,t in zip(coefficients,target));gap=value-bound
        added=add_columns(columns,records)
        rec.update(pricing_seconds=time.monotonic()-before,columns_added=added,
                   exact_integer_support=bound,exact_target_value=str(value),exact_violation=str(gap),
                   scaled_violation=float(gap/a.pricing_scale),numeric_master_bound=float(last_solution[-1]),
                   rounded_global_bound=bound/a.pricing_scale,
                   numeric_mixture_mass=float(last_weights.sum()),
                   numeric_positive_mixture_columns=int(np.count_nonzero(last_weights>1e-10)))
        print(json.dumps(rec),flush=True)
        if gap>0:
            cuts.append({'coefficients':list(coefficients),'upper_bound':bound,'exact_target_value':str(value),
                         'exact_violation':str(gap),'pricing_scale':a.pricing_scale,'support_records':records})
            reason='EXACT_POSITIVE_SUPPORT_GAP_REQUIRES_INDEPENDENT_REPLAY';break
        result.update(elapsed_seconds=time.monotonic()-start,feature_columns=len(features))
        a.output.write_text(json.dumps(result,indent=2)+'\n')
        if peak>1500:reason='MEMORY_LIMIT_1500_MiB';break
        if added==0:reason='NO_NEW_COLUMNS_NUMERICAL_STALL';break
        if bound/a.pricing_scale<=float(last_solution[-1])+1e-8:
            reason='NO_EXACT_SEPARATOR_AT_NUMERICAL_STOP';break
    padded=np.pad(last_weights,(0,len(features)-len(last_weights)))
    column_path=a.output.with_suffix('.columns.npz')
    np.savez_compressed(column_path,features=np.stack(features),masks=np.asarray(masks,dtype=np.uint16),
                        selected_Z_indices=np.asarray(witnesses,dtype=np.uint16),
                        master_mixture_weights=padded,master_dual_coefficients=last_solution[:-1],
                        master_bound=last_solution[-1])
    numeric_mixture=np.asarray(padded)@np.asarray(features,dtype=float)
    unchanged={p:sha(ROOT/p)==digest for p,digest in sources.items()};assert all(unchanged.values())
    result.update(status='EXACT_SUPPORT_CUT_CANDIDATE' if cuts else 'NO_EXACT_SEPARATOR_FOUND',
                  stopping_reason=reason,elapsed_seconds=time.monotonic()-start,feature_columns=len(features),
                  columns_artifact=str(column_path),columns_sha256=sha(column_path),
                  numeric_mixture_max_feature_residual=float(np.max(np.abs(numeric_mixture-np.asarray(list(map(float,target)))))),
                  numeric_mixture_min_weight=float(padded.min(initial=0)),source_files_unchanged=unchanged,
                  scope='All integer feature columns and their physical128-index witnesses are preserved. Master mixture weights are numerical candidates only. No-separation is not membership; positive exact support candidates require independent physical replay. No full source anchor is excluded.')
    a.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('status','stopping_reason','elapsed_seconds','feature_columns','numeric_mixture_max_feature_residual')}),flush=True)


if __name__=='__main__':main()
