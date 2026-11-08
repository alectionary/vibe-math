from pathlib import Path
import sys,json,time,argparse
import numpy as np,cvxpy as cp
from scipy.sparse import csc_matrix
sys.path.insert(0,'/private/tmp/c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16')
from rectangular_moment_sdp import model,source_patterns
from moment_circuit_cuts import model_constraint
ap=argparse.ArgumentParser();ap.add_argument('--families',type=int,nargs='+',required=True);ap.add_argument('--seconds',type=float,default=90);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();root=Path('/private/tmp');source=json.load(open(root/'c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16/inversion-results/normal-form.json'));prob,p,C=model(source_patterns(source,a.families),16,128);con=list(prob.constraints);N=p.size;m=9*len(a.families);B0=sum(C.values());rectangles=[];conditional={(c['sector'],c['thin_mask'],c['thick_mask']) for c in json.load(open(root/('c16-new-rank-SDP'+''.join(map(str,a.families))+'.cuts.json')))}
for side in ['X','Z']:
 fam=a.families if side=='X' else list(range(5));offset=0 if side=='X' else m
 for c in json.load(open(root/f'c16-new-rank-rectangles-{side}.json')):
  if any(c['thin_mask']>>j&1 and j not in fam for j in range(5)):continue
  S=[offset+9*k+i for k,j in enumerate(fam) if c['thin_mask']>>j&1 for i in range(9) if c['thick_mask']>>i&1];rectangles.append({**c,'sector':side,'columns':S,'conditional':(side,c['thin_mask'],c['thick_mask']) in conditional})
K=csc_matrix((np.ones(sum(len(c['columns']) for c in rectangles)),([j for c in rectangles for j in c['columns']],[k for k,c in enumerate(rectangles) for j in c['columns']])),shape=(N,len(rectangles)));r=np.array([c['rank'] for c in rectangles],dtype=float);con.append(16*(K.T@p)<=r);selected=[k for k,c in enumerate(rectangles) if c['conditional']];con.append(B0@K[:,selected]<=cp.reshape(p,(N,1),order='C')@r[selected].reshape(1,-1));reps=json.load(open(root/'c16-new-source-short-circuits.json'));circuits=[]
for side in ['X','Z']:
 for S in reps[side]:
  if side=='X' and any(v//144 not in a.families for v in S):continue
  for phase in range(16):
   for i in range(N):circuits.append({'sector':side,'circuit':S,'phase':phase,'anchor':i})
con.append(model_constraint(circuits,p,C,a.families));prob=cp.Problem(cp.Minimize(0),con);start=time.monotonic();print('MODEL',a.families,len(circuits),flush=True);prob.solve(solver='SCS',eps=1e-7,max_iters=30000,time_limit_secs=a.seconds,verbose=False);result={'status':prob.status,'X_thin_families':a.families,'source_C16_answered':False,'exact_certificate':False,'circuit_inequalities':len(circuits),'seconds':time.monotonic()-start};a.output.write_text(json.dumps(result,indent=2)+'\n');a.output.with_suffix('.circuits.json').write_text(json.dumps(circuits)+'\n');print(json.dumps(result),flush=True)
if p.value is not None:np.savez_compressed(a.output.with_suffix('.moments.npz'),first=p.value,**{f'C{h}':C[h].value for h in range(9)})
