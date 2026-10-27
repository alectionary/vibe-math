from pathlib import Path
import sys,json,time
import numpy as np,cvxpy as cp
from scipy.sparse import csc_matrix,save_npz
sys.path.insert(0,'/private/tmp/c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16')
from cyclic_moment_sdp import model
from rectangular_moment_sdp import source_patterns
from moment_triangle_cuts import expression
from moment_circuit_cuts import model_constraint
root=Path('/private/tmp');source=json.load(open(root/'c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16/inversion-results/normal-form.json'));patterns=source_patterns(source,list(range(5)));prob,p,C=model(patterns,16,128,None,maximize_margin=True);con=list(prob.constraints);N=90;B0=sum(C.values());rectangles=[];conditional={(c['sector'],c['thin_mask'],c['thick_mask']) for c in json.load(open(root/'c16-new-joint-source-rankcuts.json'))}
for side in ['X','Z']:
 for c in json.load(open(root/f'c16-new-rank-rectangles-{side}.json')):
  S=[(0 if side=='X' else 45)+9*j+i for j in range(5) if c['thin_mask']>>j&1 for i in range(9) if c['thick_mask']>>i&1];rectangles.append({**c,'sector':side,'columns':S,'conditional':(side,c['thin_mask'],c['thick_mask']) in conditional})
K=csc_matrix((np.ones(sum(len(c['columns']) for c in rectangles)),([j for c in rectangles for j in c['columns']],[k for k,c in enumerate(rectangles) for j in c['columns']])),shape=(N,len(rectangles)));r=np.array([c['rank'] for c in rectangles],dtype=float);con.append(16*(K.T@p)<=r);selected=[k for k,c in enumerate(rectangles) if c['conditional']];con.append(B0@K[:,selected]<=cp.reshape(p,(N,1),order='C')@r[selected].reshape(1,-1));triangles=json.load(open(root/'c16-new-joint-source-triangles.json'));circuits=json.load(open(root/'c16-new-joint-source-circuits.json'));con.extend(expression(c,p,C,16) for c in triangles);con.append(model_constraint(circuits,p,C));prob=cp.Problem(prob.objective,con);start=time.monotonic();print('MODEL',len(triangles),len(circuits),flush=True);prob.solve(solver='SCS',eps=1e-8,max_iters=50000,time_limit_secs=240,verbose=False);result={'status':prob.status,'objective':prob.value,'seconds':time.monotonic()-start,'scope':'Interior search in strengthened necessary source moment relaxation; no physical frame','source_C16_answered':False};prefix=root/'c16-new-joint-margin';prefix.with_suffix('.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)
if p.value is not None:
 np.savez_compressed(prefix.with_suffix('.moments.npz'),first=p.value,**{f'C{h}':C[h].value for h in range(9)})
 data,chain,inverse=prob.get_problem_data(cp.SCS);stuff=[v for v in inverse if hasattr(v,'var_offsets')][-1];stats=prob.solver_stats.extra_stats;np.savez_compressed(Path(str(prefix)+'.canonical.npz'),x=stats['x'],b=data['b'][:data['dims'].zero]);save_npz(str(prefix)+'.equalities.npz',data['A'][:data['dims'].zero,:]);metadata={'offsets':{str(k):int(v) for k,v in stuff.var_offsets.items()},'shapes':{str(v.id):list(v.shape) for v in prob.variables()},'variables':{str(v.id):v.name() for v in prob.variables()}};Path(str(prefix)+'.canonical.json').write_text(json.dumps(metadata)+'\n');Path(str(prefix)+'.cuts.json').write_text(json.dumps({'rank_rectangles':rectangles,'moment_triangles':triangles,'moment_circuits':circuits})+'\n')
