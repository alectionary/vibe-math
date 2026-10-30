"""Finite-size scaling and explicitly conditional uncertainty, both arms."""
import json,pathlib,sys,math
from statistics import NormalDist
import numpy as np
from scipy.optimize import least_squares,minimize
from scipy.special import xlogy
from scipy.stats import norm
ROOT=pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT.parents[1]/'.agents/skills/replication-paper/scripts'))
from contrast_checks import contrast,source_band,validate_inventory,validate_contrast_coverage


def fit(rows,method='mse',start=None):
    L=np.array([r['L'] for r in rows]);p=np.array([r['p'] for r in rows]);y=np.array([r['failures']/r['shots'] for r in rows]);n=np.array([r['shots'] for r in rows])
    deform=rows[0]['deformed'];bounds=([.03 if deform else .005,.25,0,0,-100],[.12 if deform else .065,5,1,100,100])
    def predict(v):
        threshold,nu,A,B,C=v;x=(p-threshold)*L**(1/nu);return A+B*x+C*x*x
    def residual(v): return predict(v)-y
    starts=[start] if start is not None else [[.074 if deform else .029,nu,.3,2,0] for nu in (.5,1,2)]
    fits=[least_squares(residual,s,bounds=bounds,max_nfev=1000,xtol=1e-9,gtol=1e-9,ftol=1e-9) for s in starts]
    best=min(fits,key=lambda x:x.cost)
    if method=='binomial':
        def objective(v):
            z=predict(v)
            if np.any(z<=0) or np.any(z>=1): return 1e10+np.sum(np.maximum(-z,0)**2+np.maximum(z-1,0)**2)*1e10
            return float(-np.sum(n*(xlogy(y,z)+xlogy(1-y,1-z))))
        opt=minimize(objective,best.x,method='Nelder-Mead',bounds=list(zip(*bounds)),options={'maxiter':10000,'xatol':1e-8})
        v=opt.x;success=bool(opt.success);cost=float(opt.fun)
    else:v=best.x;success=bool(best.success);cost=float(best.cost*2)
    return dict(threshold=float(v[0]),nu=float(v[1]),parameters=v.tolist(),success=success,objective=cost,boundary=bool(np.any(np.isclose(v,bounds[0],atol=1e-5)) or np.any(np.isclose(v,bounds[1],atol=1e-5))))


def main():
 data=json.loads((ROOT/'results/primary.json').read_text());assert data['complete']
 rows=data['rows'];combined=[];generator=[]
 for L in (4,6,8,10):
  for deform in (False,True):
   for p in sorted({r['p'] for r in rows if r['deformed']==deform}):
    arms=[r for r in rows if r['L']==L and r['deformed']==deform and r['p']==p];assert len(arms)==2
    row=dict(arms[0]);row.pop('seed');row.update(generator='combined',seeds=[r['seed'] for r in arms])
    for field in ('shots','failures','point_failures','loop_failures','point_osd','loop_osd','invalid','seconds'):row[field]=sum(r[field] for r in arms)
    combined.append(row)
    a,b=arms;pa=a['failures']/a['shots'];pb=b['failures']/b['shots'];se=math.sqrt(pa*(1-pa)/a['shots']+pb*(1-pb)/b['shots'])
    generator.append(dict(L=L,deformed=deform,p=p,difference=pa-pb,se=se,z=(pa-pb)/se if se else 0,bonferroni_significant=abs(pa-pb)>norm.ppf(1-.05/64)*se))
 fits=[fit([r for r in combined if r['deformed']==d]) for d in (False,True)]
 rng=np.random.default_rng(87531);samples=[];failed=0;boundaries=0
 for i in range(400):
    estimates=[]
    for d in (False,True):
        subset=[dict(r) for r in combined if r['deformed']==d]
        for r in subset:r['failures']=int(rng.binomial(r['shots'],r['failures']/r['shots']))
        f=fit(subset,start=fits[int(d)]['parameters']);failed+=not f['success'];boundaries+=f['boundary'];estimates.append(f['threshold'])
    samples.append(estimates)
 assert failed==0, 'Bootstrap fit failures require investigation before uncertainty reporting'
 samples=np.array(samples);samples=np.column_stack([samples,samples[:,1]-samples[:,0]])
 ours=np.array([f['threshold'] for f in fits]+[fits[1]['threshold']-fits[0]['threshold']]);source=np.array([.029,.074,.045]);se=samples.std(axis=0,ddof=1)
 definition='deformed minus undeformed threshold, percentage points; positive favors deformation'
 direction=contrast(4.5,100*ours[2],definition)
 comparisons=[];inventory=[]
 from decimal import Decimal,ROUND_HALF_UP
 for i,label in enumerate(['undeformed threshold','deformed threshold','deformed minus undeformed threshold']):
    observed=Decimal(str(100*ours[i])).quantize(Decimal('.1'),rounding=ROUND_HALF_UP);printed=Decimal(str(100*source[i])).quantize(Decimal('.1'))
    distance=abs(observed-printed);verdict='match' if distance==0 else 'close' if distance==Decimal('.1') else 'mismatch'
    band=source_band(ours[i]-source[i],se[i],.0005 if i<2 else .001,3)
    comparisons.append(dict(claim=label,source=float(source[i]),ours=float(ours[i]),deviation=float(ours[i]-source[i]),se=float(se[i]),numerical=verdict,band=band,bootstrap_interval=np.quantile(samples[:,i],[.025,.975]).tolist()))
    record=dict(role='headline',claim=label,kind='contrast' if i==2 else 'parameter',numerical=verdict,scope='limited',numerical_criterion='rounding_one_unit',uncertainty_decision='conditional '+band['adjusted_status'])
    if i==2:record.update(source_contrast=4.5,ours_contrast=100*ours[2],**direction)
    inventory.append(record)
 sensitivity={}
 for d in (False,True):
    subset=[r for r in combined if r['deformed']==d]
    rates=sorted({r['p'] for r in subset})
    sensitivity[str(d)]={'drop_high_p':fit([r for r in subset if r['p']<rates[-1]]),'drop_low_p':fit([r for r in subset if r['p']>rates[0]]),'binomial':fit(subset,'binomial'),'drop_L4':fit([r for r in subset if r['L']!=4]),'drop_L10':fit([r for r in subset if r['L']!=10]),'generators':{g:fit([r for r in rows if r['deformed']==d and r['generator']==g]) for g in ('numpy','stdlib')}}
 coverage=[dict(analysis='threshold',condition='pure-X',**direction)]
 for L in (4,6,8,10):
    c=contrast(0,0,'deformed minus undeformed physical qubits; positive means higher resource cost')
    inventory.append(dict(role='supporting',claim=f'qubit-cost change L={L}',kind='contrast',source_contrast=0,ours_contrast=0,numerical='match',scope='exact',uncertainty_decision='deterministic count',**c))
    coverage.append(dict(analysis='qubits',condition=str(L),**c))
 assert not validate_inventory(inventory)
 assert not validate_contrast_coverage(coverage,[('threshold','pure-X')]+[('qubits',str(L)) for L in (4,6,8,10)])
 result=dict(comparisons=comparisons,fits=fits,sensitivity=sensitivity,generator_comparisons=generator,inventory=inventory,coverage=coverage,bootstrap=dict(requested=400,arm_fits=800,failed=failed,boundaries=boundaries,seed=87531),data=combined)
 (ROOT/'results/analysis.json').write_text(json.dumps(result,indent=2,default=lambda x:x.item())+'\n');np.savetxt(ROOT/'results/bootstrap.csv',samples,delimiter=',',header='undeformed,deformed,difference',comments='')
 print(json.dumps({k:result[k] for k in ['comparisons','fits','sensitivity','bootstrap']},indent=2,default=lambda x:x.item()))
if __name__=='__main__':main()
