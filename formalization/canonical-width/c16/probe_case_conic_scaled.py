"""Bounded conic feasibility diagnostic with cone-preserving binary scaling.

Every scalar cone row has its own positive power-of-two scale. Each PSD cone
has one common positive scale. No numerical dual or status is a source proof.
"""
from pathlib import Path
import argparse, hashlib, json, subprocess, sys, time
import numpy as np
from scipy.sparse import load_npz
import scs

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def worker(a):
    prior=json.loads(a.model_prefix.with_suffix('.json').read_text());cone=prior['full_cone_dimensions']
    A=load_npz(a.model_prefix.with_suffix('.full-A.npz')).tocsr();data=np.load(a.model_prefix.with_suffix('.full-data.npz'))
    b=data['b'];c=data['c'];assert np.all(c==0) and prior['zero_artificial_margins']
    warm=np.load(a.warm_solution)['x'];assert len(warm)==A.shape[1]
    maximum=np.asarray(abs(A).max(axis=1).toarray()).ravel();stop=cone['z']+cone['l']
    exponents=np.zeros(A.shape[0],dtype=np.int64)
    exponents[:stop]=np.ceil(np.log2(np.maximum(maximum[:stop],1.0))).astype(np.int64)
    psd_scales=[]
    for n in cone['s']:
        end=stop+n*(n+1)//2;e=int(np.ceil(np.log2(max(1.0,float(maximum[stop:end].max())))))
        exponents[stop:end]=e;psd_scales.append(e);stop=end
    assert stop==len(b)
    scale=np.exp2(-exponents.astype(float));B=A.multiply(scale[:,None]).tocsc();right=b*scale
    settings=dict(max_iters=100000,eps_abs=1e-7,eps_rel=1e-7,time_limit_secs=a.seconds,
        verbose=True,normalize=True,scale=.1,adaptive_scale=True,use_indirect=False)
    start=time.monotonic()
    result=scs.solve({'A':B,'b':right,'c':c,'x':warm,'y':np.zeros(len(b)),'s':right-B@warm},cone,**settings)
    elapsed=time.monotonic()-start;info=result['info']
    out={'status':'NUMERICAL_CONE_SCALED_DIAGNOSTIC_ONLY','source_C16_answered':False,'source_anchor_excluded':False,
       'solver_info':info,'solver_wall_seconds':elapsed,'settings':settings,
       'PSD_cone_common_binary_exponents':psd_scales,'scalar_row_binary_exponent_range':[int(exponents[:cone['z']+cone['l']].min()),int(exponents[:cone['z']+cone['l']].max())],
       'scope':'Positive binary scaling preserves each original necessary cone. Numerical endpoint only; exact semantic primal or dual remains required.'}
    x=result.get('x');arrays={k:v for k,v in result.items() if isinstance(v,np.ndarray)};arrays['row_exponents']=exponents
    if x is not None and np.all(np.isfinite(x)):
        r=A@x-b;z=cone['z'];l=cone['l'];out['original_linear_residuals']={
          'equalities':float(abs(r[:z]).max(initial=0)),'inequalities':float(r[z:z+l].max(initial=0)),
          'lower_box':float(max(0,-x.min())),'upper_box':float(max(0,x.max()-1))}
        owner=x[data['owner_to_canonical']];out['case_moment']=float(owner[prior['case_condition']['owner_coordinate']])
    np.savez_compressed(a.output.with_suffix('.npz'),**arrays)
    def clean(v):
        if isinstance(v,dict):return {k:clean(w)for k,w in v.items()}
        if isinstance(v,(list,tuple)):return list(map(clean,v))
        if isinstance(v,float)and not np.isfinite(v):return None
        return v
    out=clean(out);a.output.write_text(json.dumps(out,indent=2,allow_nan=False)+'\n');print(out,flush=True)

def main():
    p=argparse.ArgumentParser();p.add_argument('--model-prefix',type=Path,required=True)
    p.add_argument('--warm-solution',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--seconds',type=float,default=120);p.add_argument('--worker',action='store_true');a=p.parse_args();assert 0<a.seconds<=120
    if a.worker:return worker(a)
    assert not a.output.exists();paths=[Path(__file__),a.model_prefix.with_suffix('.json'),a.model_prefix.with_suffix('.full-A.npz'),a.model_prefix.with_suffix('.full-data.npz'),a.warm_solution]
    sources={str(p):sha(p)for p in paths};cmd=[sys.executable,'-u',Path(__file__).name,*sys.argv[1:],'--worker']
    a.output.with_suffix('.frozen.json').write_text(json.dumps({'status':'FROZEN_CONE_SCALED_CASE_GATE','command':cmd,'source_hashes':sources,'internal_seconds':a.seconds,'external_seconds':180,'source_C16_answered':False},indent=2)+'\n')
    start=time.monotonic()
    with a.output.with_suffix('.log').open('w')as log:
        try:code=subprocess.run(cmd,cwd=ROOT,stdout=log,stderr=subprocess.STDOUT,timeout=180).returncode;timed=False
        except subprocess.TimeoutExpired:code=None;timed=True
    assert all(sha(p)==h for p,h in sources.items())
    out={'returncode':code,'external_timeout':timed,'elapsed_seconds':time.monotonic()-start}
    a.output.with_suffix('.exit.json').write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':main()
