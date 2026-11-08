"""One bounded LP outer-approximation step with independently valid dense rows.

All inherited canonical data remain numerical. Only the added integer-form
halfspaces have a separate exact semantic receipt. A source contradiction
requires a further exact dual for every row used, not a solver status.
"""
from pathlib import Path
import argparse, hashlib, json, subprocess, sys, time
import numpy as np
from scipy.sparse import load_npz, csr_matrix, vstack
import highspy
from verify_dense_integer_forms import matrix as dense_matrix

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def worker(a):
    prior=json.loads(a.model_prefix.with_suffix('.json').read_text())
    A=load_npz(a.model_prefix.with_suffix('.linear-A.npz')).tocsr()
    data=np.load(a.model_prefix.with_suffix('.linear-data.npz'));b=data['rhs'];z=prior['equalities']
    mapping=data['owner_to_canonical'];M,rhs,meta=dense_matrix(a.banks,a.receipts)
    mapped=csr_matrix((M.data.copy(),mapping[M.indices],M.indptr.copy()),shape=(M.shape[0],A.shape[1]))
    mapped.sum_duplicates();mapped.eliminate_zeros()
    assert np.max(abs(mapped.data),initial=0)<2**52
    A=vstack([A,mapped],format='csr');b=np.r_[b,rhs]
    maximum=np.asarray(abs(A).max(axis=1).toarray()).ravel()
    exponents=np.ceil(np.log2(np.maximum(maximum,1.0))).astype(np.int64)
    scale=np.exp2(-exponents.astype(float));B=A.multiply(scale[:,None]).tocsr();right=b*scale
    low=right.copy();low[z:]=-highspy.kHighsInf
    H=highspy.Highs();settings={'output_flag':True,'threads':1,'solver':'ipm','presolve':'on',
        'run_crossover':'off','time_limit':a.seconds,'primal_feasibility_tolerance':1e-9,
        'dual_feasibility_tolerance':1e-9,'ipm_optimality_tolerance':1e-9,'small_matrix_value':1e-12}
    for k,v in settings.items():assert H.setOptionValue(k,v)==highspy.HighsStatus.kOk
    n=A.shape[1];assert H.addVars(n,np.zeros(n),np.ones(n))==highspy.HighsStatus.kOk
    assert H.addRows(B.shape[0],low,right,B.nnz,B.indptr.astype(np.int32),B.indices.astype(np.int32),B.data)==highspy.HighsStatus.kOk
    start=time.monotonic();H.run();elapsed=time.monotonic()-start;sol=H.getSolution();info=H.getInfo()
    out={'status':'NUMERICAL_DENSE_OUTER_APPROXIMATION_ONLY','source_C16_answered':False,'source_anchor_excluded':False,
       'model_status':str(H.getModelStatus()),'solver_seconds':elapsed,'settings':settings,
       'variables':n,'rows':A.shape[0],'dense_integer_rows':M.shape[0],
       'dense_compiled_nonzeros':mapped.nnz,'ipm_iterations':int(info.ipm_iteration_count),
       'value_valid':bool(sol.value_valid),'dual_valid':bool(sol.dual_valid),
       'scope':'Source-valid added integer forms in a numerical necessary-case LP. A numerical endpoint is not an exact primal or obstruction.'}
    arrays={'row_exponents':exponents}
    if len(sol.col_value)==n:
        x=np.array(sol.col_value);r=A@x-b;sr=B@x-right
        out['original_numeric_residuals']={'equalities':float(abs(r[:z]).max(initial=0)),
          'inequalities':float(r[z:].max(initial=0)),'lower':float(max(0,-x.min())),'upper':float(max(0,x.max()-1))}
        out['scaled_numeric_residuals']={'equalities':float(abs(sr[:z]).max(initial=0)),
          'inequalities':float(sr[z:].max(initial=0))}
        arrays.update(x=x,row_dual=np.array(sol.row_dual)*scale,col_dual=np.array(sol.col_dual))
    np.savez_compressed(a.output.with_suffix('.npz'),**arrays)
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)

def main():
    p=argparse.ArgumentParser();p.add_argument('--model-prefix',type=Path,required=True)
    p.add_argument('--banks',type=Path,nargs='+',required=True);p.add_argument('--receipts',type=Path,nargs='+',required=True)
    p.add_argument('--output',type=Path,required=True);p.add_argument('--seconds',type=float,default=120)
    p.add_argument('--worker',action='store_true');a=p.parse_args();assert 0<a.seconds<=120
    if a.worker:return worker(a)
    assert not a.output.exists() and len(a.banks)==len(a.receipts)
    paths=[Path(__file__),Path('verify_dense_integer_forms.py'),a.model_prefix.with_suffix('.json'),
      a.model_prefix.with_suffix('.linear-A.npz'),a.model_prefix.with_suffix('.linear-data.npz'),*a.banks,*a.receipts]
    sources={str(p):sha(p) for p in paths};cmd=[sys.executable,'-u',Path(__file__).name,*sys.argv[1:],'--worker']
    frozen={'status':'FROZEN_DENSE_OUTER_LP_GATE','command':cmd,'source_hashes':sources,
      'internal_cap_seconds':a.seconds,'external_cap_seconds':180,'source_C16_answered':False,'source_anchor_excluded':False}
    a.output.with_suffix('.frozen.json').write_text(json.dumps(frozen,indent=2)+'\n');start=time.monotonic()
    with a.output.with_suffix('.log').open('w') as log:
        try:code=subprocess.run(cmd,cwd=ROOT,stdout=log,stderr=subprocess.STDOUT,timeout=180).returncode;timed=False
        except subprocess.TimeoutExpired:code=None;timed=True
    assert all(sha(p)==h for p,h in sources.items())
    result={'returncode':code,'external_timeout':timed,'elapsed_seconds':time.monotonic()-start}
    a.output.with_suffix('.exit.json').write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
