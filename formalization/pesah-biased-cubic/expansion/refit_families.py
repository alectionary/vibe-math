"""Preserve initial fits; diagnose coefficient bounds using equivalent scaled x.

This refinement is exploratory, triggered by recorded bootstrap boundary hits.
Source polynomial family remains unchanged; arbitrary coefficient bounds change.
"""
import json,pathlib,resource
import numpy as np
from scipy.optimize import least_squares
import analyze_families as original
R=pathlib.Path(__file__).resolve().parent

def fit(rows,start=None):
 p=np.array([r['p'] for r in rows]);L=np.array([r['L'] for r in rows]);y=np.array([r['failures']/r['shots'] for r in rows]);scale=float(np.median(p));low=[max(.00001,min(p)*.5),.1,-1,-100,-100];high=[min(.4999,max(p)*1.5),20,2,100,100]
 def residual(v):
  t,nu,A,B,C=v;x=(p-t)/scale*(L/6)**(1/nu);return A+B*x+C*x*x-y
 starts=[start] if start is not None else [[scale,nu,.4,.5,0] for nu in [.5,1,2,4,8]]
 options=[least_squares(residual,v,bounds=(low,high),max_nfev=3000,xtol=1e-9,ftol=1e-9,gtol=1e-9) for v in starts];f=min(options,key=lambda f:f.cost);v=f.x;x=(p-v[0])/scale*(L/6)**(1/v[1]);prediction=residual(v)+y
 hits=[name for i,name in enumerate(['threshold','nu','A','B','C']) if np.isclose(v[i],low[i],atol=1e-5) or np.isclose(v[i],high[i],atol=1e-5)]
 return dict(threshold=float(v[0]),parameters=v.tolist(),success=bool(f.success),boundary=bool(hits),boundary_parameters=hits,sse=float(2*f.cost),outside_prediction_range=bool(np.any(prediction<0)|np.any(prediction>1)),nonmonotone=bool(np.any(v[3]+2*v[4]*x<0)),inside_sampled_probability_window=bool(min(p)<=v[0]<=max(p)),scale=scale)

if __name__=='__main__':
 resource.setrlimit(resource.RLIMIT_CPU,(3600,3610));resource.setrlimit(resource.RLIMIT_AS,(2*1024**3,2*1024**3));original.fit=fit
 for i,name in enumerate(json.loads((R/'families-plan.json').read_text())['configs']):
  out=R/name.replace('-config.json','-normalized-analysis.json')
  if out.exists():continue
  data=json.loads((R/name.replace('-config.json','.json')).read_text());assert data['complete'];result=original.analyze(data,202660000+i);result['refinement']='Exploratory normalized-x reparameterization and relaxed coefficient/exponent bounds after initial bound hits; original analysis retained separately. No new simulation or replacement of stage1.';out.write_text(json.dumps(result,indent=2)+'\n');print(name,result['thresholds_and_D_minus_U'],[f['boundary_parameters'] for f in result['fits']],result['bootstrap'],flush=True)
