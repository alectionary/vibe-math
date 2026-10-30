"""All-size pure-Z analysis; never force an unresolved source bound into a point."""
import json,pathlib
import numpy as np
from scipy.optimize import least_squares
from scipy.stats import beta
R=pathlib.Path(__file__).resolve().parent

def fit(rows,field='failures',start=None):
 p=np.array([r['p'] for r in rows]);L=np.array([r['L'] for r in rows]);y=np.array([r[field]/r['shots'] for r in rows]);d=rows[0]['deformed']
 bounds=([.15 if not d else .25,.2,0,0,-100],[.30 if not d else .50,8,1,100,100])
 def residual(v):
  t,nu,A,B,C=v;x=(p-t)*L**(1/nu);return A+B*x+C*x*x-y
 starts=[start] if start else [[.217 if not d else .36,nu,.6,1,0] for nu in [.5,1,2,4]]
 opts=[least_squares(residual,v,bounds=bounds,max_nfev=3000) for v in starts];o=min(opts,key=lambda o:o.cost)
 return dict(threshold=float(o.x[0]),parameters=o.x.tolist(),success=bool(o.success),sse=float(2*o.cost),boundary=bool(np.any(np.isclose(o.x,bounds[0],atol=1e-5)) or np.any(np.isclose(o.x,bounds[1],atol=1e-5))))

def main():
 datasets=[json.loads((R/f'pure-z-L{L}.json').read_text()) for L in [4,6,8,10]];assert all(x['complete'] for x in datasets)
 raw=[r for x in datasets for r in x['rows']];rows=[]
 for L in [4,6,8,10]:
  for d in [False,True]:
   for p in sorted({r['p'] for r in raw if r['L']==L and r['deformed']==d}):
    a=[r for r in raw if (r['L'],r['deformed'],r['p'])==(L,d,p)];assert len(a)==2
    r=dict(a[0]);r.pop('seed');r.update(generator='combined',seeds=[x['seed'] for x in a])
    for f in ['shots','failures','point_failures','loop_failures','invalid','point_osd','loop_osd','seconds']:r[f]=sum(x[f] for x in a)
    for f,m in [('failures',44),('point_failures',88),('loop_failures',88)]:
     k=r[f];n=r['shots'];alpha=.05/m;r[f+'_interval']=[float(beta.ppf(alpha/2,k,n-k+1)) if k else 0.,float(beta.ppf(1-alpha/2,k+1,n-k)) if k<n else 1.]
    rows.append(r)
 out={'rows':rows,'trials':sum(r['shots'] for r in rows),'invalid':sum(r['invalid'] for r in rows),'families':{'total_cells':44,'sector_cells':88,'alpha':.05,'method':'Bonferroni Clopper-Pearson exact binomial intervals'},'fits':{},'source_deformed':'Only >36% bound/unresolved crossing, not an exact threshold. Saturating total/sector curves make polynomial fits exploratory.'}
 for d in [False,True]:
  subset=[r for r in rows if r['deformed']==d];rates=sorted({r['p'] for r in subset});fields=['failures'] if not d else ['failures','loop_failures','point_failures']
  for field in fields:
   key=f'{d}:{field}';primary=fit(subset,field);out['fits'][key]={'primary':primary,'drop_low_p':fit([r for r in subset if r['p']!=rates[0]],field),'drop_high_p':fit([r for r in subset if r['p']!=rates[-1]],field),'drop_L4':fit([r for r in subset if r['L']!=4],field),'drop_L10':fit([r for r in subset if r['L']!=10],field),'interpretation':'exploratory, no precise-source numerical verdict' if d else 'limited reconstruction; original trial uncertainty unknown'}
  if not d:
   rng=np.random.default_rng(202611131);estimates=[];fail=boundary=0
   for _ in range(400):
    b=[dict(r) for r in subset]
    for row in b:row['failures']=int(rng.binomial(row['shots'],row['failures']/row['shots']))
    f=fit(b,start=out['fits']['False:failures']['primary']['parameters']);fail+=not f['success'];boundary+=f['boundary'];estimates.append(f['threshold'])
   out['undeformed_bootstrap']={'requested':400,'failed':int(fail),'boundaries':int(boundary),'standard_error':float(np.std(estimates,ddof=1)),'percentile95':np.quantile(estimates,[.025,.975]).tolist(),'seed':202611131}
 (R/'pure-z-analysis.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='rows'},indent=2))
if __name__=='__main__':main()
