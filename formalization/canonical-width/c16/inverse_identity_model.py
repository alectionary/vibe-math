#!/usr/bin/env python3
"""Rank-minimal identity decompositions, tested only on small quotient pools.

Exactly n rank-one terms summing to I_n force both factor matrices invertible;
the terms are then a canonical frame. No pairwise cross constraints are needed.
"""
import argparse,json,time,subprocess,sys
from pathlib import Path
from ortools.sat.python import cp_model
from quotient_inverse_model import fold

def solve(X,Z,n,seconds):
 edges=[(i,j) for i,x in enumerate(X) for j,z in enumerate(Z) if (x&z).bit_count()%2];model=cp_model.CpModel();s=[model.new_bool_var(f'e{k}') for k in range(len(edges))];model.add(sum(s)==n)
 rows=[]
 for a in range(n):
  for b in range(n):
   indices=[k for k,(i,j) in enumerate(edges) if X[i]>>a&1 and Z[j]>>b&1];values=[s[k] for k in indices]
   if a!=b:values.append(True) # AddBoolXOr enforces odd parity.
   model.add_bool_xor(values);rows.append(indices)
 engine=cp_model.CpSolver();engine.parameters.max_time_in_seconds=seconds;engine.parameters.num_search_workers=2;engine.parameters.random_seed=20261027;status=engine.solve(model);out={'status':engine.status_name(status),'variables':len(edges),'xor_equations':n*n,'seconds':engine.wall_time,'source_question_answered':False}
 if status in [cp_model.OPTIMAL,cp_model.FEASIBLE]:
  pairs=[[X[i],Z[j]] for k,(i,j) in enumerate(edges) if engine.value(s[k])];assert len(pairs)==n
  assert all(sum(((x>>a)&1)*((z>>b)&1) for x,z in pairs)%2==(a==b) for a in range(n) for b in range(n));assert all((x&z).bit_count()%2==(i==j) for i,(x,_) in enumerate(pairs) for j,(_,z) in enumerate(pairs));out['pairs']=pairs
 if status==cp_model.INFEASIBLE:out['independent_negative_certificate']='not supplied by CP-SAT; only controls have external certificates'
 return out

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--period',type=int,choices=[1,2],default=2);ap.add_argument('--seconds',type=float,default=30);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--child',action='store_true');args=ap.parse_args()
 if not args.child:
  proc=subprocess.Popen([sys.executable,str(Path(__file__).resolve()),*sys.argv[1:],'--child'])
  try:proc.wait(timeout=args.seconds+12)
  except subprocess.TimeoutExpired:
   proc.terminate()
   try:proc.wait(timeout=2)
   except subprocess.TimeoutExpired:proc.kill();proc.wait()
   args.output.write_text(json.dumps({'status':'PROCESS_TIME_LIMIT','source_question_answered':False})+'\n')
  if proc.returncode:raise SystemExit(proc.returncode)
  return
 root=Path(__file__).parent;j=args.period;X=sorted({fold(int(v,16),j) for v in (root/'pools/xcoords.txt').read_text().split()});Z=sorted({fold(int(v,16),j) for v in (root/'pools/zcoords.txt').read_text().split()});assert solve([1,2,4,8],[1,2,4,8],4,2)['status']=='OPTIMAL';r=solve(X,Z,8*j,args.seconds);r.update(period=j,scope='small quotient rank-minimal identity model; no full-C16 run');args.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({k:v for k,v in r.items() if k!='pairs'}),flush=True)

if __name__=='__main__':main()
