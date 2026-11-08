from pathlib import Path
import sys,json,time
import numpy as np,cvxpy as cp
from scipy.sparse import csc_matrix,coo_matrix
sys.path.insert(0,'/private/tmp/c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16')
from rectangular_moment_sdp import model,source_patterns
from moment_triangle_cuts import expression
from moment_integer_form_cuts import expression as form_expression
from moment_owner_cuts import model_constraint as owner_model
root=Path('/private/tmp');source=json.load(open(root/'c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16/inversion-results/normal-form.json'));prob,p,C=model(source_patterns(source,list(range(5))),16,128);con=list(prob.constraints);N=90;P=16;B0=sum(C.values());rectangles=[];conditional={(c['sector'],c['thin_mask'],c['thick_mask']) for c in json.load(open(root/'c16-new-rank-SDPglobal.cuts.json'))}
for side in ['X','Z']:
 for c in json.load(open(root/f'c16-new-rank-rectangles-{side}.json')):
  S=[(0 if side=='X' else 45)+9*j+i for j in range(5) if c['thin_mask']>>j&1 for i in range(9) if c['thick_mask']>>i&1];rectangles.append({**c,'sector':side,'columns':S,'conditional':(side,c['thin_mask'],c['thick_mask']) in conditional})
K=csc_matrix((np.ones(sum(len(c['columns']) for c in rectangles)),([j for c in rectangles for j in c['columns']],[k for k,c in enumerate(rectangles) for j in c['columns']])),shape=(N,len(rectangles)));r=np.array([c['rank'] for c in rectangles],dtype=float);con.append(16*(K.T@p)<=r);selected=[k for k,c in enumerate(rectangles) if c['conditional']];con.append(B0@K[:,selected]<=cp.reshape(p,(N,1),order='C')@r[selected].reshape(1,-1));triangles=json.load(open(root/'c16-new-lattice-source-triangles.json'));con.extend(expression(c,p,C,16) for c in triangles);forms=json.load(open(root/'c16-new-lattice-source-integer-forms.json'));con.extend(form_expression(c,p,C,16) for c in forms);owners=json.load(open(root/'c16-new-all-owner-cuts.json'));con.append(owner_model(owners,source_patterns(source,list(range(5))),p,C,16))
reps=json.load(open(root/'c16-new-source-short-circuits.json'));ri=[];ci=[];value=[];cutlist=[]
for side in ['X','Z']:
 offset=0 if side=='X' else 45
 for S in reps[side]:
  for phase in range(16):
   for i in range(N):
    row=len(cutlist);ri.append(row);ci.append(i);value.append(-(len(S)-1));cutlist.append({'sector':side,'circuit':S,'phase':phase,'anchor':i})
    for v in S:
     h=(v%16+phase)%16;j=offset+v//16;a,b=i,j
     if h>8:h=16-h;a,b=b,a
     ri.append(row);ci.append(N+h*N*N+a+N*b);value.append(1)
A=coo_matrix((value,(ri,ci)),shape=(len(cutlist),N+9*N*N)).tocsr();v=cp.hstack([p]+[cp.vec(C[h],order='F') for h in range(9)]);con.append(A@v<=0);prob=cp.Problem(cp.Minimize(0),con);start=time.monotonic();print('MODEL','circuits',len(cutlist),'triangles',len(triangles),flush=True);prob.solve(solver='SCS',eps=1e-7,max_iters=30000,time_limit_secs=180,verbose=False)
result={'status':prob.status,'source_C16_answered':False,'exact_certificate':False,'scope':'Full source moment model with all short-circuit conditional rank bounds; arbitrary asymmetric frames retained','circuit_inequalities':len(cutlist),'triangle_inequalities':len(triangles),'seconds':time.monotonic()-start};(root/'c16-new-all-owner-source-SDP.json').write_text(json.dumps(result,indent=2)+'\n');(root/'c16-new-all-owner-source-cuts.json').write_text(json.dumps(cutlist)+'\n');(root/'c16-new-all-owner-source-triangles.json').write_text(json.dumps(triangles)+'\n');print(json.dumps(result),flush=True)
if p.value is not None:np.savez_compressed(root/'c16-new-all-owner-source-moments.npz',first=p.value,**{f'C{h}':C[h].value for h in range(9)})
