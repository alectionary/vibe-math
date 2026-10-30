"""Post-inspection exploratory adequacy diagnostic; frozen windows and estimator."""
import pathlib,json,sys,time,resource,hashlib
import numpy as np
from scipy.special import xlogy
from scipy.stats import beta
R=pathlib.Path(__file__).resolve().parent;sys.path.insert(0,str(R.parent/'expansion'))
from refit_families import fit
resource.setrlimit(resource.RLIMIT_AS,(2*1024**3,2*1024**3));resource.setrlimit(resource.RLIMIT_CPU,(2400,2410))
plan=json.loads((R/'quadratic-adequacy-plan.json').read_text())
def predictions(rows,f):
 t,nu,a,b,c=f['parameters'];x=np.array([(r['p']-t)/f['scale']*(r['L']/6)**(1/nu) for r in rows]);return a+b*x+c*x*x

def deviance(k,n,mu):
 y=k/n;return float(np.sum(2*n*(xlogy(y,y/mu)+xlogy(1-y,(1-y)/(1-mu)))))
def valid(f,mu):return f['success'] and not f['boundary'] and not f['nonmonotone'] and bool(np.all((mu>0)&(mu<1)))
def cp(k,n):return [float(beta.ppf(.025,k,n-k+1)) if k else 0.,float(beta.ppf(.975,k+1,n-k)) if k<n else 1.]
pilot='--pilot' in sys.argv
for index,name in enumerate(plan['families']):
 dest=R/(name+('-quadratic-pilot.json' if pilot else '-quadratic-adequacy.json'));data=json.loads((R/(name+'-analysis.json')).read_text());rows=data['rows'];f=fit(rows);mu=predictions(rows,f);assert valid(f,mu);n=np.array([r['shots'] for r in rows]);k=np.array([r['failures'] for r in rows]);observed=deviance(k,n,mu);N=plan['pilot_draws_per_family'] if pilot else plan['draws_per_family'];seed=plan['pilot_seeds'][index] if pilot else plan['seeds'][index];rng=np.random.default_rng(seed);records=[];start=time.perf_counter()
 for draw in range(N):
  sample=rng.binomial(n,mu);rr=[dict(r,failures=int(v)) for r,v in zip(rows,sample)];ff=fit(rr);pred=predictions(rr,ff);ok=valid(ff,pred);stat=deviance(sample,n,pred) if ok else None;records.append(dict(draw=draw,valid=ok,deviance=stat,boundary=ff['boundary'],nonmonotone=ff['nonmonotone'],threshold=ff['threshold'],success=ff['success']))
  if (draw+1)%100==0:print(name,draw+1,flush=True)
 exceed=sum(x['valid'] and x['deviance']>=observed for x in records);bad=sum(not x['valid'] for x in records);bounds=[(exceed+1)/(N+1),(exceed+bad+1)/(N+1)];mc=[cp(exceed,N)[0],cp(exceed+bad,N)[1]];result=dict(family=name,pilot=pilot,plan_sha256=hashlib.sha256((R/'quadratic-adequacy-plan.json').read_bytes()).hexdigest(),analysis_sha256=hashlib.sha256((R/(name+'-analysis.json')).read_bytes()).hexdigest(),seed=seed,draws=N,observed_deviance=observed,exceedances=exceed,unresolved_draws=bad,add_one_p_bounds=bounds,mc95_conservative_bounds=mc,seconds=time.perf_counter()-start,maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,records=records,limit=plan['calibration']);dest.write_text(json.dumps(result,indent=2)+'\n');print({k:v for k,v in result.items() if k!='records'},flush=True)
