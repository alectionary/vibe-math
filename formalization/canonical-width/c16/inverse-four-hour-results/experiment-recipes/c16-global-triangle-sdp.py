from pathlib import Path
import sys,json,time,subprocess
import numpy as np,cvxpy as cp
from scipy.sparse import csc_matrix
sys.path.insert(0,'/private/tmp/c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16')
from rectangular_moment_sdp import model,source_patterns
from block_moment_dual import layout
from moment_triangle_cuts import expression,constraint,literal_control
root=Path('/private/tmp');source=json.load(open(root/'c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16/inversion-results/normal-form.json'));prob,p,C=model(source_patterns(source,list(range(5))),16,128);con=list(prob.constraints);N=90;P=16;B0=sum(C.values());rectangles=[];conditional={(c['sector'],c['thin_mask'],c['thick_mask']) for c in json.load(open(root/'c16-new-rank-SDPglobal.cuts.json'))}
for side in ['X','Z']:
 for c in json.load(open(root/f'c16-new-rank-rectangles-{side}.json')):
  S=[(0 if side=='X' else 45)+9*j+i for j in range(5) if c['thin_mask']>>j&1 for i in range(9) if c['thick_mask']>>i&1];rectangles.append({**c,'sector':side,'columns':S,'conditional':(side,c['thin_mask'],c['thick_mask']) in conditional})
K=csc_matrix((np.ones(sum(len(c['columns']) for c in rectangles)),([j for c in rectangles for j in c['columns']],[k for k,c in enumerate(rectangles) for j in c['columns']])),shape=(N,len(rectangles)));r=np.array([c['rank'] for c in rectangles],dtype=float);con.append(16*(K.T@p)<=r);selected=[k for k,c in enumerate(rectangles) if c['conditional']];con.append(B0@K[:,selected]<=cp.reshape(p,(N,1),order='C')@r[selected].reshape(1,-1));pi,Ci,V=layout(N,P);seen=set();cuts=[];history=[];start=time.monotonic();prior=np.load(root/'c16-new-rank-SDPglobal.moments.npz');pv=prior['first'];cv={h:prior[f'C{h}'] for h in range(9)};cv.update({h:cv[16-h].T for h in range(9,16)})
print(literal_control(),flush=True)
for round in range(5):
 input=root/'c16-new-global-triangle-input.txt';output=root/f'c16-new-global-triangle-screen-{round}.json'
 with input.open('w') as f:
  f.write('90 16\n'+' '.join(map(str,pv))+'\n')
  for h in range(16):f.write(' '.join(map(str,cv[h].ravel()))+'\n')
 subprocess.run([str(root/'c16-moment-triangles'),str(input),str(output),'15000'],check=True,timeout=30)
 screen=json.load(open(output));new=[]
 for cut in sorted(screen['cuts'],key=lambda c:c['violation'],reverse=True):
  key=constraint(cut,pi,Ci,P)
  if key in seen:continue
  seen.add(key);new.append(cut)
  if len(new)>=800:break
 if not new:break
 cuts.extend(new);con.extend(expression(c,p,C,P) for c in new);print('ROUND',round,'triangles',len(cuts),'maximum_before',screen['maximum_violation'],flush=True);prob=cp.Problem(cp.Minimize(0),con);prob.solve(solver='SCS',eps=2e-6,max_iters=20000,time_limit_secs=120,verbose=False)
 rec={'round':round,'status':prob.status,'triangle_cuts':len(cuts),'maximum_triangle_violation_before':screen['maximum_violation'],'seconds_total':time.monotonic()-start};history.append(rec);print(json.dumps(rec),flush=True);(root/'c16-new-global-triangle-SDP.json').write_text(json.dumps({'status':prob.status,'history':history,'source_C16_answered':False,'exact_certificate':False},indent=2)+'\n');(root/'c16-new-global-triangle-cuts.json').write_text(json.dumps(cuts,indent=2)+'\n')
 if p.value is None:break
 pv=p.value;cv={h:C[h].value for h in range(16)};np.savez_compressed(root/'c16-new-global-triangle-moments.npz',first=pv,**{f'C{h}':cv[h] for h in range(9)})
