"""Bounded numerical algorithm comparison on an archived necessary-case LP.

Every row is scaled by a positive power of two. This is only discovery data:
no source exclusion or exact dual follows from a canonical floating matrix.
"""
from pathlib import Path
import argparse, hashlib, json, subprocess, sys, time
import numpy as np
from scipy.sparse import load_npz
import highspy

ROOT=Path(__file__).resolve().parent
def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def worker(prefix, output, seconds):
    prior=json.loads(prefix.with_suffix('.json').read_text())
    A=load_npz(prefix.with_suffix('.linear-A.npz')).tocsr()
    saved=np.load(prefix.with_suffix('.linear-data.npz'))
    b=saved['rhs']; z=prior['equalities']; assert A.shape==(z+prior['inequalities'],prior['variables'])
    maximum=np.asarray(abs(A).max(axis=1).toarray()).ravel()
    exponents=np.ceil(np.log2(np.maximum(maximum,1.0))).astype(np.int64)
    scale=np.exp2(-exponents.astype(float)); B=A.multiply(scale[:,None]).tocsr(); rhs=b*scale
    assert np.array_equal(B.data, A.data*np.repeat(scale,np.diff(A.indptr)))
    low=rhs.copy(); low[z:]=-highspy.kHighsInf
    H=highspy.Highs()
    settings={'output_flag':True,'threads':1,'solver':'ipm','presolve':'on','run_crossover':'off',
              'time_limit':seconds,'primal_feasibility_tolerance':1e-9,
              'dual_feasibility_tolerance':1e-9,'ipm_optimality_tolerance':1e-9,
              'small_matrix_value':1e-12}
    for k,v in settings.items(): assert H.setOptionValue(k,v)==highspy.HighsStatus.kOk
    n=A.shape[1]
    assert H.addVars(n,np.zeros(n),np.ones(n))==highspy.HighsStatus.kOk
    assert H.addRows(B.shape[0],low,rhs,B.nnz,B.indptr.astype(np.int32),B.indices.astype(np.int32),B.data)==highspy.HighsStatus.kOk
    start=time.monotonic(); H.run(); elapsed=time.monotonic()-start
    sol=H.getSolution(); info=H.getInfo()
    out={'status':'NUMERICAL_ALGORITHM_COMPARISON_ONLY','source_C16_answered':False,
         'source_anchor_excluded':False,'model_status':str(H.getModelStatus()),
         'solver_seconds':elapsed,'settings':settings,'variables':n,'rows':A.shape[0],
         'row_scale':'positive exact binary power, maximum coefficient at most1',
         'scale_exponent_range':[int(exponents.min()),int(exponents.max())],
         'scaled_coefficient_minimum':float(abs(B.data).min()),
         'ipm_iterations':int(info.ipm_iteration_count),'value_valid':bool(sol.value_valid),
         'dual_valid':bool(sol.dual_valid),
         'scope':'Archived zero-margin linear necessary model; all PSD cones omitted. No exact semantic primal or dual accepted.'}
    arrays={'row_exponents':exponents}
    if len(sol.col_value)==n:
        x=np.array(sol.col_value); r=A@x-b; sr=B@x-rhs
        out['original_numeric_residuals']={'equalities':float(abs(r[:z]).max(initial=0)),
          'inequalities':float(r[z:].max(initial=0)),'lower':float(max(0,-x.min())),
          'upper':float(max(0,x.max()-1))}
        out['scaled_numeric_residuals']={'equalities':float(abs(sr[:z]).max(initial=0)),
          'inequalities':float(sr[z:].max(initial=0))}
        arrays.update(x=x,row_dual=np.array(sol.row_dual)*scale,col_dual=np.array(sol.col_dual))
    if H.getModelStatus()==highspy.HighsModelStatus.kInfeasible:
        # Do not ask HiGHS to launch an uncapped simplex ray recovery.
        out['infeasibility_ray_requested']=False
    np.savez_compressed(output.with_suffix('.npz'),**arrays)
    output.write_text(json.dumps(out,indent=2)+'\n'); print(out,flush=True)

def main():
    p=argparse.ArgumentParser();p.add_argument('--prefix',type=Path,required=True)
    p.add_argument('--output',type=Path,required=True);p.add_argument('--seconds',type=float,default=120)
    p.add_argument('--worker',action='store_true');a=p.parse_args()
    assert 0<a.seconds<=120
    if a.worker:return worker(a.prefix,a.output,a.seconds)
    assert not a.output.exists()
    sources=[Path(__file__),a.prefix.with_suffix('.json'),a.prefix.with_suffix('.linear-A.npz'),a.prefix.with_suffix('.linear-data.npz')]
    cmd=[sys.executable,'-u',str(Path(__file__).name),'--worker','--prefix',str(a.prefix),'--output',str(a.output),'--seconds',str(a.seconds)]
    frozen={'status':'FROZEN_LINEAR_IPM_ALGORITHM_GATE','command':cmd,'source_hashes':{str(f):sha(f) for f in sources},
            'external_cap_seconds':180,'source_C16_answered':False,'source_anchor_excluded':False}
    a.output.with_suffix('.frozen.json').write_text(json.dumps(frozen,indent=2)+'\n')
    start=time.monotonic()
    with a.output.with_suffix('.log').open('w') as log:
        try: code=subprocess.run(cmd,cwd=ROOT,stdout=log,stderr=subprocess.STDOUT,timeout=180).returncode; timed=False
        except subprocess.TimeoutExpired:code=None;timed=True
    assert all(sha(f)==h for f,h in frozen['source_hashes'].items())
    result={'returncode':code,'external_timeout':timed,'elapsed_seconds':time.monotonic()-start}
    a.output.with_suffix('.exit.json').write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
