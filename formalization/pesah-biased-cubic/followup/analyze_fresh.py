"""Frozen fresh-run diagnostics; source values are never fitting inputs."""
import pathlib,json,sys,itertools
import numpy as np
from scipy.optimize import least_squares
from scipy.special import expit,xlogy,logit
from scipy.stats import chi2,beta
R=pathlib.Path(__file__).resolve().parent;sys.path.insert(0,str(R.parent/'expansion'))
from analyze_families import combine
from refit_families import fit as quadratic

def logistic(rows,fixed_t=None,start=None):
 p=np.array([r['p'] for r in rows]);L=np.array([r['L'] for r in rows]);n=np.array([r['shots'] for r in rows]);k=np.array([r['failures'] for r in rows]);y=k/n;scale=float(np.median(p));low=[float(min(p)),.1,-8,.001];high=[float(max(p)),20,8,30]
 def unpack(v):return v if fixed_t is None else np.r_[fixed_t,v]
 def residual(v):
  t,nu,a,b=unpack(v);mu=np.clip(expit(a+b*(p-t)/scale*(L/6)**(1/nu)),1e-12,1-1e-12);dev=2*n*(xlogy(y,y/mu)+xlogy(1-y,(1-y)/(1-mu)));return np.sign(y-mu)*np.sqrt(np.maximum(0,dev))
 starts=([[start[0],start[1],start[2],start[3]]] if start is not None else [])+[[scale,nu,float(logit(np.clip(y.mean(),.001,.999))),1.] for nu in [.5,1,2,4,8]]
 if fixed_t is not None:starts=[list(v[1:]) for v in starts];low=low[1:];high=high[1:]
 options=[least_squares(residual,v,bounds=(low,high),max_nfev=3000,xtol=1e-10,ftol=1e-10,gtol=1e-10) for v in starts];f=min(options,key=lambda f:f.cost);pars=unpack(f.x);bounds=['threshold','nu','a','b'] if fixed_t is None else ['nu','a','b'];hits=[name for j,name in enumerate(bounds) if np.isclose(f.x[j],low[j],atol=1e-6) or np.isclose(f.x[j],high[j],atol=1e-6)];df=len(rows)-(4 if fixed_t is None else 3)
 return dict(threshold=float(pars[0]),parameters=pars.tolist(),deviance=float(2*f.cost),df=df,gof_approx_p=float(chi2.sf(2*f.cost,df)),boundaries=hits,success=bool(f.success))

def roots(p,delta):
 found=[]
 for i in range(len(p)-1):
  if delta[i]<=0<=delta[i+1] and delta[i+1]>delta[i]:found.append(float(p[i]-delta[i]*(p[i+1]-p[i])/(delta[i+1]-delta[i])))
 return sorted(set(round(x,12) for x in found))

def crossings(rows,seed):
 rates=sorted({r['p'] for r in rows});lookup={(r['L'],r['p']):r for r in rows};rng=np.random.default_rng(seed);out=[]
 for lo,hi in itertools.combinations([4,6,8,10],2):
  a=[lookup[lo,p] for p in rates];b=[lookup[hi,p] for p in rates];ya=np.array([x['failures']/x['shots'] for x in a]);yb=np.array([x['failures']/x['shots'] for x in b]);point=roots(rates,yb-ya);down=roots(rates,ya-yb);endpoint_ok=bool(yb[0]<ya[0] and yb[-1]>ya[-1]);sa=rng.binomial(np.array([x['shots'] for x in a]),ya,size=(10000,len(rates)))/np.array([x['shots'] for x in a]);sb=rng.binomial(np.array([x['shots'] for x in b]),yb,size=(10000,len(rates)))/np.array([x['shots'] for x in b]);unique=[];missing=multiple=0
  for delta in sb-sa:
   rs=roots(rates,delta)
   if len(rs)==1 and not roots(rates,-delta) and delta[0]<0<delta[-1]:unique.append(rs[0])
   elif not rs:missing+=1
   else:multiple+=1
  unresolved=(missing+multiple)>500 or len(point)!=1 or bool(down) or not endpoint_ok
  out.append(dict(smaller_L=lo,larger_L=hi,rates=rates,difference=(yb-ya).tolist(),upward_roots=point,downward_roots=down,endpoint_orientation_ok=endpoint_ok,draws=10000,missing=missing,multiple=multiple,unique_samples=len(unique),conditional_percentile95=np.quantile(unique,[.025,.975]).tolist() if unique else None,conditional_percentile_adjusted=np.quantile(unique,[.05/24,1-.05/24]).tolist() if unique else None,inference='withheld: no unique/stable crossing' if unresolved else 'Finite-grid interpolation only; nominal bootstrap approximation, not asymptotic threshold or equivalence.'))
 return out

def local_family(name,seed):
 data=json.loads((R/(name+'.json')).read_text());assert data['complete'];rows=combine(data['rows']);base=logistic(rows);profile=[]
 for t in np.linspace(min(r['p'] for r in rows),max(r['p'] for r in rows),101):profile.append(logistic(rows,fixed_t=float(t),start=base['parameters']))
 accepted=[x['threshold'] for x in profile if x['deviance']-base['deviance']<=3.841459];result=dict(config_sha256=data['config_sha256'],rows=rows,quadratic=quadratic(rows),logistic=base,profile=profile,approx_profile95=[min(accepted),max(accepted)] if accepted else None,profile_reaches_grid_boundary=bool(accepted and (min(accepted)==min(r['p'] for r in rows) or max(accepted)==max(r['p'] for r in rows))),size_sensitivity={str(L):logistic([r for r in rows if r['L']!=L]) for L in [4,10]},crossings=crossings(rows,seed),threshold_inference='withheld: scaling model rejected or parameter boundary' if base['gof_approx_p']<.01 or base['boundaries'] else 'Conditional model estimate only; assess profile and pairwise size dependence before asymptotic interpretation.',limitations='Fresh diagnostics preserve previous primary estimates. Unknown source MC/configuration error excluded. Logistic model differs from source quadratic FSS. Crossing intervals condition on unique roots and are withheld when ambiguity exceeds5%.');(R/(name+'-analysis.json')).write_text(json.dumps(result,indent=2)+'\n');print(name,base,result['approx_profile95'],result['threshold_inference'],flush=True)

def cp(k,n,alpha):return [float(beta.ppf(alpha/2,k,n-k+1)) if k else 0.,float(beta.ppf(1-alpha/2,k+1,n-k)) if k<n else 1.]
def plateau():
 name='cubic-Z-eta100-D';data=json.loads((R/(name+'.json')).read_text());assert data['complete'];rows=combine(data['rows']);lookup={(r['L'],r['p']):r for r in rows};out=[]
 for r in rows:
  assert r['invalid']==0;r['joint_failures']=r['point_failures']+r['loop_failures']-r['failures'];assert 0<=r['joint_failures']<=min(r['point_failures'],r['loop_failures']);r['joint_minus_product']=r['joint_failures']/r['shots']-r['point_failures']*r['loop_failures']/r['shots']**2
 for p in sorted({r['p'] for r in rows}):
  for lo,hi in [(4,6),(6,8),(8,10)]:
   a,b=lookup[lo,p],lookup[hi,p]
   for sector in ['failures','point_failures','loop_failures']:
    aa,bb=cp(a[sector],a['shots'],.05/(2*72)),cp(b[sector],b['shots'],.05/(2*72));au,bu=cp(a[sector],a['shots'],.025),cp(b[sector],b['shots'],.025);out.append(dict(p=p,smaller_L=lo,larger_L=hi,sector=sector,difference=b[sector]/b['shots']-a[sector]/a['shots'],adjusted_interval=[bb[0]-aa[1],bb[1]-aa[0]],unadjusted_interval=[bu[0]-au[1],bu[1]-au[0]]))
 (R/(name+'-analysis.json')).write_text(json.dumps(dict(config_sha256=data['config_sha256'],rows=rows,contrasts=out,family_size=72,alpha=.05,method='Larger minus smaller failure, conservative difference of exact binomial intervals; each component alpha=.05/(2*72). No forced threshold fit.',limit='Finite-size sector description, not asymptotic or causal proof; joint sectors share each trial.'),indent=2)+'\n');print(name,'72 sector comparisons',flush=True)
if __name__=='__main__':
 for i,n in enumerate(['cubic-Z-eta5-U','rhombic-X-eta100-U']):
  p=R/(n+'.json')
  if p.exists() and json.loads(p.read_text()).get('complete'):local_family(n,304000000+i)
 p=R/'cubic-Z-eta100-D.json'
 if p.exists() and json.loads(p.read_text()).get('complete'):plateau()
