from pathlib import Path
import sys,json,time
import numpy as np,cvxpy as cp
from scipy.sparse import save_npz
from scipy.sparse import csc_matrix,coo_matrix
sys.path.insert(0,'/private/tmp/c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16')
from rectangular_moment_sdp import model,source_patterns
from moment_triangle_cuts import expression
from moment_integer_form_cuts import expression as integer_expression
root=Path('/private/tmp');source=json.load(open(root/'c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16/inversion-results/normal-form.json'));prob,p,C=model(source_patterns(source,list(range(5))),16,128,normalize_equalities=True,fixed_margin=1e-4,linear_slack=1e-7);con=list(prob.constraints);N=90;P=16;B0=sum(C.values());rectangles=[];conditional={(c['sector'],c['thin_mask'],c['thick_mask']) for c in json.load(open(root/'c16-new-rank-SDPglobal.cuts.json'))}
for side in ['X','Z']:
 for c in json.load(open(root/f'c16-new-rank-rectangles-{side}.json')):
  S=[(0 if side=='X' else 45)+9*j+i for j in range(5) if c['thin_mask']>>j&1 for i in range(9) if c['thick_mask']>>i&1];rectangles.append({**c,'sector':side,'columns':S,'conditional':(side,c['thin_mask'],c['thick_mask']) in conditional})
K=csc_matrix((np.ones(sum(len(c['columns']) for c in rectangles)),([j for c in rectangles for j in c['columns']],[k for k,c in enumerate(rectangles) for j in c['columns']])),shape=(N,len(rectangles)));r=np.array([c['rank'] for c in rectangles],dtype=float);con.append(16*(K.T@p)<=r);selected=[k for k,c in enumerate(rectangles) if c['conditional']];con.append(B0@K[:,selected]<=cp.reshape(p,(N,1),order='C')@r[selected].reshape(1,-1));triangles=json.load(open(root/'c16-new-joint-source-triangles.json'));con.extend(expression(c,p,C,16) for c in triangles);forms=json.load(open(root/'c16-new-pentagon-screen.json'))['cuts']+json.load(open(root/'c16-new-LLL-form-screen.json'))['cuts'];con.extend(integer_expression(c,p,C,16) for c in forms)
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
A=coo_matrix((value,(ri,ci)),shape=(len(cutlist),N+9*N*N)).tocsr();v=cp.hstack([p]+[cp.vec(C[h],order='F') for h in range(9)]);con.append(A@v<=0);prob=cp.Problem(cp.Minimize(0),con);start=time.monotonic();print('MODEL','circuits',len(cutlist),'triangles',len(triangles),flush=True);prob.solve(solver='SCS',eps=1e-9,max_iters=60000,time_limit_secs=240,verbose=False)
result={'status':prob.status,'source_C16_answered':False,'exact_certificate':False,'scope':'Restricted interior feasible-point search only: fixed PSD and linear margins. Infeasibility of this model would not exclude source frames.','circuit_inequalities':len(cutlist),'triangle_inequalities':len(triangles),'seconds':time.monotonic()-start};(root/'c16-new-normalized-feasible-SDP.json').write_text(json.dumps(result,indent=2)+'\n');(root/'c16-new-normalized-feasible-cuts.json').write_text(json.dumps(cutlist)+'\n');(root/'c16-new-normalized-feasible-triangles.json').write_text(json.dumps(triangles)+'\n');print(json.dumps(result),flush=True)
if p.value is not None:np.savez_compressed(root/'c16-new-normalized-feasible-moments.npz',first=p.value,**{f'C{h}':C[h].value for h in range(9)})

if p.value is not None:
 prefix=root/'c16-new-normalized-feasible';data,chain,inverse=prob.get_problem_data(cp.SCS);stuff=[v for v in inverse if hasattr(v,'var_offsets')][-1];stats=prob.solver_stats.extra_stats;Aeq=data['A'][:data['dims'].zero,:]*128;beq=data['b'][:data['dims'].zero]*128;assert np.max(abs(Aeq.data-np.rint(Aeq.data)))<1e-12 and np.max(abs(beq-np.rint(beq)))<1e-12;np.savez_compressed(Path(str(prefix)+'.canonical.npz'),x=stats['x'],b=beq);save_npz(str(prefix)+'.equalities.npz',Aeq);metadata={'offsets':{str(k):int(v) for k,v in stuff.var_offsets.items()},'shapes':{str(v.id):list(v.shape) for v in prob.variables()},'variables':{str(v.id):v.name() for v in prob.variables()}};Path(str(prefix)+'.canonical.json').write_text(json.dumps(metadata)+'\n')
