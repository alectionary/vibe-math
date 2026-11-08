import sys,json,time,argparse
from pathlib import Path
import numpy as np,cvxpy as cp
sys.path.insert(0,'/private/tmp/c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16')
from rectangular_moment_sdp import source_patterns,model
ap=argparse.ArgumentParser();ap.add_argument('--period',type=int,choices=[4,8],default=8);ap.add_argument('--seconds',type=float,default=90);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();source=json.load(open('/private/tmp/c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16/inversion-results/normal-form.json'));full=source_patterns(source,list(range(5)));P=a.period;q=16//P;patterns=[[sum((sum(v>>(h+P*k)&1 for k in range(q))==1)<<h for h in range(P)) for v in row] for row in full];forbidden=[np.array([[sum(v>>(h+P*k)&1 for k in range(q))>=2 for v in row] for row in full]) for h in range(P)];prob,p,C=model(patterns,P,8*P);con=list(prob.constraints)
for h in range(P):
 i,j=np.where(forbidden[h]);con.append(C[h][i,45+j]==0)
prob=cp.Problem(cp.Minimize(0),con);start=time.monotonic();prob.solve(solver='SCS',eps=1e-7,max_iters=20000,time_limit_secs=a.seconds,verbose=False);r={'status':prob.status,'period':P,'subgroup_orbit_size':q,'target_orbit_pairs':8*P,'forbidden_orbit_pairs':sum(int(v.sum()) for v in forbidden),'seconds':time.monotonic()-start,'source_C16_answered':False,'scope':'Necessary moment model for full T^period-invariant source frames only; no frame-symmetry assumption on the unrestricted target'};a.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r),flush=True)
if p.value is not None:np.savez_compressed(a.output.with_suffix('.moments.npz'),first=p.value,**{f'C{h}':C[h].value for h in range(P//2+1)})
