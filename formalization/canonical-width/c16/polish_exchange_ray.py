#!/usr/bin/env python3
"""Numerical LP repair of linear multipliers with a fixed stored PSD dual.

Only a producer: any result must pass rational source-row and PSD consumers.
The LP maximizes the fixed PSD pairing on the linear moment polytope. Its
dual can replace loose independent box correction by all linear constraints.
"""
from pathlib import Path
import argparse
import hashlib
import json
import time
import numpy as np
from scipy.sparse import load_npz
from scipy.optimize import linprog


def main():
    ap=argparse.ArgumentParser();ap.add_argument('prefix',type=Path);ap.add_argument('--ray',type=Path,required=True)
    ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=120)
    ap.add_argument('--active-only',action='store_true')
    ap.add_argument('--rounds',type=int,default=1);ap.add_argument('--batch',type=int,default=200);a=ap.parse_args()
    assert a.rounds>=1 and (a.rounds==1 or a.active_only)
    start=time.monotonic();meta=json.loads(a.prefix.with_suffix('.canonical.json').read_text())
    A=load_npz(a.prefix.with_suffix('.A.npz')).tocsr();b=np.load(a.prefix.with_suffix('.bc.npz'))['b']
    old=np.load(a.ray);y=old['y'].copy();z=meta['zero'];end=z+meta['nonneg'];assert len(y)==A.shape[0]
    keep=[];cut=0
    for lo,hi in [(0,z),(z,end)]:
        seen=set()
        for i in range(lo,hi):
            if a.active_only and lo==z and abs(y[i])<1e-7:continue
            l,r=A.indptr[i:i+2];key=(A.indices[l:r].tobytes(),A.data[l:r].tobytes(),float(b[i]))
            if key not in seen:seen.add(key);keep.append(i)
        if lo==0:cut=len(keep)
    keep=np.array(keep);d=np.asarray(A[end:].T@y[end:]).reshape(-1)
    constant=float(b[end:]@y[end:])
    print('LP_REPAIR',A.shape,'retained_linear_rows',len(keep),'constant',constant,flush=True)
    rounds=[]
    def rowkey(i):
        l,r=A.indptr[i:i+2]
        return A.indices[l:r].tobytes(),A.data[l:r].tobytes(),float(b[i])
    retained_keys={rowkey(i) for i in keep[cut:]}
    for step in range(a.rounds):
        remaining=a.seconds-(time.monotonic()-start)
        if remaining<=0:break
        fitted_keep=keep.copy()
        fit=linprog(d,A_ub=A[keep[cut:]],b_ub=b[keep[cut:]],A_eq=A[keep[:cut]],b_eq=b[keep[:cut]],
                    bounds=(0,1) if a.active_only else (None,None),method='highs',options={'time_limit':remaining,'dual_feasibility_tolerance':1e-8,'primal_feasibility_tolerance':1e-8})
        detail={'round':step,'rows':len(keep),'status':int(fit.status)}
        if fit.fun is not None:detail['maximum_PSD_pairing']=constant-float(fit.fun)
        rounds.append(detail);print('REPAIR_ROUND',json.dumps(detail),flush=True)
        if fit.status!=0 or step==a.rounds-1 or constant-float(fit.fun)<-.005:break
        violation=np.asarray(A[z:end]@fit.x-b[z:end]);detail['maximum_source_row_violation']=float(violation.max(initial=0))
        additions=[]
        for k in np.argsort(violation)[::-1]:
            if violation[k]<=1e-8:break
            i=z+int(k);key=rowkey(i)
            if key not in retained_keys:
                retained_keys.add(key);additions.append(i)
                if len(additions)==a.batch:break
        detail['added_rows']=len(additions)
        if not additions:break
        # Do not change the row set unless another solve will actually run.
        if a.seconds-(time.monotonic()-start)<=0:break
        keep=np.r_[keep,np.array(additions,dtype=np.int64)]
    keep=fitted_keep
    result={'status':'NUMERICAL_REPAIR_ONLY','source_C16_answered':False,'linprog_status':int(fit.status),
            'message':fit.message,'total_seconds':time.monotonic()-start,'active_only':a.active_only,
            'retained_linear_rows':len(keep),'box_bounds_used':a.active_only,
            'cut_generation_rounds':rounds,
            'original_ray_sha256':hashlib.sha256(a.ray.read_bytes()).hexdigest()}
    if fit.fun is not None:result['maximum_fixed_PSD_pairing']=constant-float(fit.fun)
    if fit.eqlin.marginals is not None and fit.ineqlin.marginals is not None:
        dual=np.r_[-fit.eqlin.marginals,-fit.ineqlin.marginals]
        assert np.isfinite(dual).all();y[:end]=0;y[keep]=dual
        np.savez_compressed(a.output.with_suffix('.scs.npz'),y=y)
        result['dual_saved']=True
    else:result['dual_saved']=False
    a.output.write_text(json.dumps(result,indent=2,allow_nan=False)+'\n');print(json.dumps(result),flush=True)


if __name__=='__main__':main()
