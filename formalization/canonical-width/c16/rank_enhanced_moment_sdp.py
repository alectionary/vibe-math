import sys,json,time,argparse,os
from pathlib import Path
import numpy as np
from scipy.sparse import csc_matrix
import cvxpy as cp
ROOT=Path(__file__).parent
sys.path.insert(0,str(ROOT))
from rectangular_moment_sdp import source_patterns,model
ap=argparse.ArgumentParser();ap.add_argument('--rank-X',type=Path,default=ROOT/'inverse-four-hour-results/rank-rectangle-X.json');ap.add_argument('--rank-Z',type=Path,default=ROOT/'inverse-four-hour-results/rank-rectangle-Z.json');ap.add_argument('--prior',type=Path);ap.add_argument('--families',type=int,nargs='+',required=True);ap.add_argument('--seconds',type=float,default=120);ap.add_argument('--rounds',type=int,default=4);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
source=json.load(open(ROOT/'inversion-results/normal-form.json'));patterns=source_patterns(source,a.families);prob,p,C=model(patterns,16,128);N=len(p.shape) and p.size;m=9*len(a.families);B0=sum(C.values());con=list(prob.constraints);cutlist=[]
for side in ['X','Z']:
 fam=a.families if side=='X' else list(range(5));offset=0 if side=='X' else m
 for cut in json.load(open(a.rank_X if side=='X' else a.rank_Z)):
  T=cut['thin_mask'];I=cut['thick_mask']
  if any(T>>j&1 and j not in fam for j in range(5)):continue
  S=[offset+9*c+i for c,j in enumerate(fam) if T>>j&1 for i in range(9) if I>>i&1]
  cutlist.append({**cut,'sector':side,'columns':S})
K=csc_matrix((np.ones(sum(len(c['columns']) for c in cutlist),dtype=float),([j for c in cutlist for j in c['columns']],[k for k,c in enumerate(cutlist) for j in c['columns']])),shape=(N,len(cutlist)));r=np.array([c['rank'] for c in cutlist],dtype=float)
con.append(16*(K.T@p)<=r);added=set();history=[];start=time.monotonic()
# Reuse the previous solution only to select the initial conditional cuts.
prior=a.prior
if prior is not None and prior.exists():
 d=np.load(prior);pv=d['first'];bv=d['C0']+d['C8']+sum(d[f'C{h}']+d[f'C{h}'].T for h in range(1,8))
else:pv=None;bv=None
for round in range(a.rounds):
 if pv is not None:
  violations=np.max(bv@K-pv[:,None]*r[None,:],axis=0);order=np.argsort(violations)[::-1];new=[int(k) for k in order if violations[k]>2e-5 and k not in added][:120]
  if new:
   con.append(B0@K[:,new]<=cp.reshape(p,(N,1),order='C')@r[new].reshape(1,-1));added.update(new)
  elif round>0:break
 prob=cp.Problem(cp.Minimize(0),con);print('ROUND',round,'N',N,'rank_cuts',len(cutlist),'conditional_cuts',len(added),flush=True)
 prob.solve(solver='SCS',eps=2e-6,max_iters=15000,time_limit_secs=a.seconds,verbose=False,warm_start=True)
 rec={'round':round,'status':prob.status,'conditional_rectangles_added':len(added),'seconds_total':time.monotonic()-start};history.append(rec);print(json.dumps(rec),flush=True)
 a.output.write_text(json.dumps({'families':a.families,'source_C16_answered':False,'scope':'Numerical source binary-rank rectangle constraints and cyclic moments; no exact infeasibility conclusion','first_moment_rank_cuts':len(cutlist),'history':history},indent=2)+'\n')
 if p.value is None:
  a.output.with_suffix('.cuts.json').write_text(json.dumps([cutlist[k] for k in sorted(added)],indent=2)+'\n')
  break
 pv=p.value;bv=sum(C[h].value for h in range(16));np.savez_compressed(a.output.with_suffix('.moments.npz'),first=pv,**{f'C{h}':C[h].value for h in range(9)})
 violations=np.max(bv@K-pv[:,None]*r[None,:],axis=0);rec['maximum_rank_cut_violation']=float(violations.max());rec['remaining_violated_rectangles']=int((violations>2e-5).sum());a.output.with_suffix('.cuts.json').write_text(json.dumps([cutlist[k] for k in sorted(added)],indent=2)+'\n')
a.output.write_text(json.dumps({'families':a.families,'source_C16_answered':False,'scope':'Numerical source binary-rank rectangle constraints and cyclic moments; no exact infeasibility conclusion','first_moment_rank_cuts':len(cutlist),'history':history},indent=2)+'\n')
