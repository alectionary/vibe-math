#!/usr/bin/env python3
"""Bounded exploratory perturbations within table rounding cells; not bootstrap.
Uniform perturbations are a supplied diagnostic design, not a distribution
for the unknown original correlations. Ranges are not confidence intervals.
"""
import argparse,json,time
from pathlib import Path
import numpy as np
import pandas as pd
from fit_sem import Model,ROOT

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--replicates',type=int,default=200);a=ap.parse_args()
 seed=201005; rng=np.random.default_rng(seed)
 R=pd.read_csv(ROOT/'sources/table_3_2.csv',index_col=0)
 base=json.loads((ROOT/'outputs/sem_fits.json').read_text())['models']
 models=[(Model(z['model'],z['external']),np.array(z['solution'])) for z in base]
 out=[]; rejected=0; failures=[]; t=time.perf_counter()
 for b in range(a.replicates):
  jitter=np.zeros(R.shape); idx=np.tril_indices(len(R),-1);jitter[idx]=rng.uniform(-.005,.005,len(idx[0]));jitter+=jitter.T
  Sfull=R.to_numpy()+jitter
  if np.linalg.eigvalsh(Sfull).min()<=0:rejected+=1;continue
  frame=pd.DataFrame(Sfull,index=R.index,columns=R.columns)
  fits=[]
  for m,x in models:
   S=frame.loc[m.names,m.names].to_numpy(); r=m.fit(S,start=x)
   if not r.success:failures.append({'replicate':b,'model':m.kind,'external':m.external,'message':str(r.message)})
   fits.append((m,r))
  refined=next(r for m,r in fits if m.kind=='refined' and not m.external)
  ref_ext=next((m,r) for m,r in fits if m.kind=='refined' and m.external)
  phi=models[1][0].matrices(refined.x)[3]
  row={'replicate':b,'ctse_cpse':float(phi[1,0])}
  for n in [296,308]:
   for m,r in fits:
    if m.external and m.kind!='refined':
     row[f'delta_AIC_{m.kind}_n{n}']=n*(r.fun-ref_ext[1].fun)-2*(m.df-ref_ext[0].df)
   g=next(r for m,r in fits if m.kind=='general')
   row[f'delta_AIC_general_n{n}']=n*(g.fun-refined.fun)-2
  out.append(row)
  if b==9:print(f'10-draw benchmark {time.perf_counter()-t:.3f}s; projected {a.replicates/10*(time.perf_counter()-t):.2f}s',flush=True)
 frame=pd.DataFrame(out);frame.to_csv(ROOT/'outputs/rounding_sensitivity.csv',index=False)
 summary={'design':'Independent Uniform[-.005,.005] lower-triangle perturbations, diagonal1, reflected symmetry. Not sampling uncertainty, not an exhaustive worst-case bound.','seed':seed,'requested':a.replicates,'completed':len(out),'non_positive_definite_rejected':rejected,'optimizer_failures':failures,'elapsed_seconds':time.perf_counter()-t,'ranges':{c:{'min':float(frame[c].min()),'max':float(frame[c].max()),'median':float(frame[c].median())} for c in frame.columns if c!='replicate'},'ranking_reversals':{c:int((frame[c]<=0).sum()) for c in frame.columns if c.startswith('delta')}}
 (ROOT/'outputs/rounding_sensitivity.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps(summary,indent=2))
if __name__=='__main__':main()
