"""Checkpointed family fits with separately labeled conditional uncertainty."""
import argparse,json,pathlib,time,math,resource
import numpy as np
from scipy.optimize import least_squares
from scipy.stats import norm
R=pathlib.Path(__file__).resolve().parent

def combine(raw):
 rows=[]
 for key in sorted(set((r['L'],r['deformed'],r['p']) for r in raw)):
  a=[r for r in raw if (r['L'],r['deformed'],r['p'])==key];assert len(a)==2
  r=dict(a[0]);r.pop('seed');r.update(generator='combined',seeds=[x['seed'] for x in a])
  for f in ['shots','failures','point_failures','loop_failures','invalid','point_osd','loop_osd','seconds']:
   if f in r:r[f]=sum(x[f] for x in a)
  rows.append(r)
 return rows

def fit(rows,start=None):
 ps=np.array([r['p'] for r in rows]);L=np.array([r['L'] for r in rows]);y=np.array([r['failures']/r['shots'] for r in rows]);center=np.median(ps)
 bounds=([max(.00001,min(ps)*.5),.25,0,0,-100],[min(.4999,max(ps)*1.5),8,1,100,100])
 def residual(v):
  t,nu,A,B,C=v;x=(ps-t)*L**(1/nu);return A+B*x+C*x*x-y
 starts=[start] if start else [[center,nu,.3,2,0] for nu in [.5,1,2]]
 fits=[least_squares(residual,v,bounds=bounds,max_nfev=1500) for v in starts];f=min(fits,key=lambda f:f.cost)
 return dict(threshold=float(f.x[0]),parameters=f.x.tolist(),success=bool(f.success),boundary=bool(np.any(np.isclose(f.x,bounds[0],atol=1e-5)) or np.any(np.isclose(f.x,bounds[1],atol=1e-5))),sse=float(2*f.cost))

def analyze(data,seed):
 rows=combine(data['rows']);fits=[fit([r for r in rows if r['deformed']==d]) for d in [False,True]];rng=np.random.default_rng(seed);samples=[];failed=boundaries=0
 for _ in range(400):
  estimates=[]
  for d in [False,True]:
   sub=[dict(r) for r in rows if r['deformed']==d]
   for r in sub:r['failures']=int(rng.binomial(r['shots'],r['failures']/r['shots']))
   f=fit(sub,start=fits[int(d)]['parameters']);failed+=not f['success'];boundaries+=f['boundary'];estimates.append(f['threshold'])
  samples.append(estimates)
 samples=np.array(samples);samples=np.column_stack([samples,samples[:,1]-samples[:,0]]);ours=[f['threshold'] for f in fits]+[fits[1]['threshold']-fits[0]['threshold']];se=samples.std(axis=0,ddof=1)
 sensitivity={}
 for d in [False,True]:
  sub=[r for r in rows if r['deformed']==d];rates=sorted({r['p'] for r in sub});sensitivity[str(d)]={k:fit(v) for k,v in [('drop_low_p',[r for r in sub if r['p']!=rates[0]]),('drop_high_p',[r for r in sub if r['p']!=rates[-1]]),('drop_L4',[r for r in sub if r['L']!=4]),('drop_L10',[r for r in sub if r['L']!=10])]}
 return dict(config_sha256=data['config_sha256'],rows=rows,fits=fits,thresholds_and_D_minus_U=ours,standard_errors=se.tolist(),conditional_interval95=np.quantile(samples,[.025,.975],axis=0).T.tolist(),bootstrap=dict(draws=400,arm_fits=800,failed=int(failed),boundaries=int(boundaries),seed=seed),sensitivity=sensitivity,uncertainty_limit='Bootstrap conditional on grid, supplied decoder settings and fitted model; missing source Monte Carlo error and systematic/model differences excluded. Boundary or failed fits require investigation before inferential claims.')

def main():
 p=argparse.ArgumentParser();p.add_argument('--wait',action='store_true');a=p.parse_args();resource.setrlimit(resource.RLIMIT_CPU,(3600,3610));resource.setrlimit(resource.RLIMIT_AS,(2*1024**3,2*1024**3));plan=json.loads((R/'families-plan.json').read_text());pending=list(enumerate(plan['configs']))
 while pending:
  progressed=False
  for i,name in list(pending):
   output=R/name.replace('-config.json','-analysis.json');path=R/name.replace('-config.json','.json')
   if output.exists():pending.remove((i,name));continue
   if not path.exists():continue
   d=json.loads(path.read_text())
   if not d['complete']:continue
   result=analyze(d,202630000+i);output.write_text(json.dumps(result,indent=2)+'\n');pending.remove((i,name));progressed=True;print(name,result['thresholds_and_D_minus_U'],result['bootstrap'],flush=True)
  if not pending or not a.wait:break
  if not progressed:time.sleep(5)
if __name__=='__main__':main()
