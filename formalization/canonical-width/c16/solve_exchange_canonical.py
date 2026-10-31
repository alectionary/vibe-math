#!/usr/bin/env python3
"""Bounded indirect follow-up on stored canonical data, dropping duplicate rows.

This is a numerical producer only. Deleting a linear constraint weakens the
model; any putative dual is lifted back to its retained original rows before
independent exact source verification. No mathematical result is inferred here.
"""
from pathlib import Path
import argparse
import json
import time
import numpy as np
from scipy.sparse import load_npz
import scs


def main():
    ap=argparse.ArgumentParser();ap.add_argument('prefix',type=Path)
    ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=180)
    a=ap.parse_args();start=time.monotonic()
    meta=json.loads(a.prefix.with_suffix('.canonical.json').read_text())
    A=load_npz(a.prefix.with_suffix('.A.npz')).tocsr()
    bc=np.load(a.prefix.with_suffix('.bc.npz'));b=bc['b'];c=bc['c']
    z=meta['zero'];end=z+meta['nonneg'];keep=[];seen=set();newz=0
    for lo,hi in [(0,z),(z,end)]:
        seen=set()
        for i in range(lo,hi):
            l,r=A.indptr[i:i+2]
            key=(A.indices[l:r].tobytes(),A.data[l:r].tobytes(),float(b[i]))
            if key not in seen:seen.add(key);keep.append(i)
        if lo==0:newz=len(keep)
    newend=len(keep);keep.extend(range(end,A.shape[0]));keep=np.array(keep,dtype=np.int64)
    reduced=A[keep].tocsc();cone={'z':newz,'l':newend-newz,'s':meta['psd']}
    print('ROW_REDUCTION',A.shape,reduced.shape,'build_seconds',time.monotonic()-start,flush=True)
    out=scs.solve({'A':reduced,'b':b[keep],'c':c},cone,linear_solver='cpu_indirect',
                  eps_abs=1e-6,eps_rel=1e-6,rho_x=.01,max_iters=20000,
                  time_limit_secs=a.seconds,verbose=True)
    y=np.zeros(A.shape[0]);y[keep]=out['y']
    np.savez_compressed(a.output.with_suffix('.scs.npz'),x=out['x'],y=y,s=out['s'])
    def safe(v):
        if isinstance(v,float) and not np.isfinite(v):return None
        if isinstance(v,dict):return {k:safe(x) for k,x in v.items()}
        return v
    result=safe({'status':'NUMERICAL_ONLY','source_C16_answered':False,
        'solver_info':out['info'],'original_rows':A.shape[0],'retained_rows':len(keep),
        'retained_equalities':newz,'retained_inequalities':newend-newz,
        'total_seconds':time.monotonic()-start,
        'scope':'Stored source model; exact-byte duplicate linear rows removed. PSD rows unchanged. Dual lifted to original canonical rows; exact source consumer still required.'})
    a.output.write_text(json.dumps(result,indent=2,allow_nan=False)+'\n')
    print(json.dumps(result),flush=True)


if __name__=='__main__':main()
