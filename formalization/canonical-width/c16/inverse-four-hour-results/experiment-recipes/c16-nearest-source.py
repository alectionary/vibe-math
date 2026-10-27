from pathlib import Path
import sys,json
sys.path.insert(0,'formalization/canonical-width/c16');from quotient_inverse_model import fold
from ortools.sat.python import cp_model
root=Path('formalization/canonical-width/c16');data=json.loads(Path('/private/tmp/c16-new-projective-relaxation.json').read_text());X,Z=data['X'],data['Z'];old={s:{fold(int(v,16),2) for v in (root/f'pools/{s}coords.txt').read_text().split()} for s in ['x','z']};lines=Path('/private/tmp/c16-new-projective-relaxation.cnf').read_text().splitlines();nv=int(next(s for s in lines if s.startswith('p ')).split()[2]);model=cp_model.CpModel();b=[model.new_bool_var(f'v{i}') for i in range(1,nv+1)]
for line in lines:
 if line.startswith(('p','c')):continue
 cs=list(map(int,line.split()))[:-1];model.add_bool_or([b[c-1] if c>0 else ~b[-c-1] for c in cs])
penalty=[b[i] for i,x in enumerate(X) if x not in old['x']]+[b[len(X)+i] for i,z in enumerate(Z) if z not in old['z']];model.minimize(sum(penalty));hint={int(v) for line in Path('/private/tmp/c16-new-projective-relaxation.log').read_text().splitlines() if line.startswith('v ') for v in line[2:].split() if int(v)>0}
for i,v in enumerate(b):model.add_hint(v,int(i+1 in hint))
class Save(cp_model.CpSolverSolutionCallback):
 def __init__(self):super().__init__();self.count=0
 def on_solution_callback(self):
  I=[i for i in range(len(X)) if self.value(b[i])];J=[j for j in range(len(Z)) if self.value(b[len(X)+j])];pairs=[]
  for i in I:
   mate=[j for j in J if (X[i]&Z[j]).bit_count()%2];assert len(mate)==1;pairs.append([X[i],Z[mate[0]]])
  assert len(pairs)==16 and all((x&z).bit_count()%2==(i==j) for i,(x,_) in enumerate(pairs) for j,(_,z) in enumerate(pairs));self.count+=1;r={'status':'QUOTIENT_ENLARGEMENT_FRAME_CHECKED','extra_vectors':int(self.objective_value),'best_bound':self.best_objective_bound,'seconds':self.wall_time,'pairs':pairs,'source_C16_answered':False,'original_period_two_answered':self.objective_value==0,'scope':'Nearest source frame inside the180-point period-two scalar relaxation; optimization bound is numerical solver output, not an external proof'};Path('/private/tmp/c16-new-nearest-source-best.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({k:v for k,v in r.items() if k!='pairs'}),flush=True)
solver=cp_model.CpSolver();solver.parameters.max_time_in_seconds=600;solver.parameters.num_search_workers=2;solver.parameters.random_seed=20261027;cb=Save();status=solver.solve(model,cb);Path('/private/tmp/c16-new-nearest-source-final.json').write_text(json.dumps({'status':solver.status_name(status),'objective':solver.objective_value,'bound':solver.best_objective_bound,'seconds':solver.wall_time,'solutions':cb.count,'source_C16_answered':False},indent=2)+'\n')
