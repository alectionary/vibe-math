#!/usr/bin/env python3
"""Bounded full/half-turn moment comparison with checked local profile hulls."""
from pathlib import Path
import argparse,gzip,json,math,time
import numpy as np
import cvxpy as cp
ROOT=Path(__file__).resolve().parent
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--hulls',type=Path,required=True);ap.add_argument('--seconds',type=float,default=300);ap.add_argument('--iterations',type=int,default=30000);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();data=json.loads(gzip.decompress(a.hulls.read_bytes()));P=data['period'];q=45;target=128 if P==16 else 64;X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in ['x','z']];unit=[];bad=[]
 for h in range(P):
  first=np.array([[(X[16*i]&Z[16*j+h]).bit_count()%2 for j in range(q)] for i in range(q)])
  second=np.zeros_like(first) if P==16 else np.array([[(X[16*i]&Z[16*j+h+8]).bit_count()%2 for j in range(q)] for i in range(q)])
  unit.append(first^second);bad.append(first&second)
 assert all(np.array_equal(unit[h],unit[(-h)%P].T) and np.array_equal(bad[h],bad[(-h)%P].T) for h in range(P));half=P//2;p=cp.Variable(q);S={0:cp.Variable((q,q),symmetric=True),half:cp.Variable((q,q),symmetric=True)};T={0:cp.Variable((q,q),symmetric=True),half:cp.Variable((q,q),symmetric=True)}
 for h in range(1,half):S[h]=cp.Variable((q,q));T[h]=cp.Variable((q,q));S[P-h]=S[h].T;T[P-h]=T[h].T
 rows=cp.reshape(p,(q,1),order='C')@np.ones((1,q));con=[p>=0,p<=1,cp.diag(S[0])==p,P*cp.sum(p)==target]
 for M in [sum(S.values()),sum(T.values())]:con.append(cp.sum(M,axis=1)==target*p)
 for h in range(half+1):
  for M in [S[h],T[h]]:con.extend([M>=0,M<=rows,M<=rows.T,M>=rows+rows.T-1])
  if P==8:con.append(cp.multiply(bad[h],T[h])==0)
 con.append(cp.sum(sum(cp.multiply(unit[h],T[h]) for h in range(P)),axis=1)==p)
 G=cp.bmat([[np.ones((1,1)),cp.reshape(p,(1,q),order='C')],[cp.reshape(p,(q,1),order='C'),(sum(S.values())+sum(T.values()))/(2*P)]]);con.extend([G>>0,(sum(S.values())-sum(T.values()))>>0])
 for k in range(1,half+1):
  for sign in [1,-1]:
   B={h:S[h]+sign*T[h] for h in range(P)};real=B[0]+(-1)**k*B[half];imag=0*B[0]
   for h in range(1,half):real+=math.cos(2*math.pi*k*h/P)*(B[h]+B[h].T);imag+=math.sin(2*math.pi*k*h/P)*(B[h]-B[h].T)
   con.append((real if k==half else cp.bmat([[real,-imag],[imag,real]]))>>0)
 weights=[]
 for r in data['records']:
  o=r['orbit'];features=np.array([s['moments'] for s in r['shapes']],dtype=float).T;w=cp.Variable(features.shape[1],nonneg=True);weights.append(w);con.extend([cp.sum(w)==1,P*p[o]==features[0]@w])
  for h in range(1,half+1):con.append(P*S[h][o,o]==features[h]@w)
 problem=cp.Problem(cp.Minimize(0),con);print('PROFILE MOMENT prepared',P,data['mode'],data['shape_variables'],'shape variables',len(con),'constraint objects',flush=True);a.output.write_text(json.dumps({'status':'RUNNING','period':P,'mode':data['mode'],'scope':'Numeric necessary-model test; not a proof'})+'\n')
 value=problem.solve(solver='SCS',max_iters=a.iterations,eps=1e-6,time_limit_secs=a.seconds,verbose=False);stats=problem.solver_stats;out={'status':problem.status,'source_C16_answered':False,'scope':'Numerical profile-enhanced moment relaxation; no original exclusion without exact source-binding and dual replay, no construction from moments.','physical_target':128,'restricted_to_halfturn':P==8,'period':P,'mode':data['mode'],'shape_variables':data['shape_variables'],'wall_seconds':time.monotonic()-start,'solver_seconds':stats.solve_time,'iterations':stats.num_iters,'objective':value}
 if p.value is not None:
  arrays={'p':p.value,**{f'S{h}':S[h].value for h in range(half+1)},**{f'T{h}':T[h].value for h in range(half+1)},**{f'w{o}':w.value for o,w in enumerate(weights)}};np.savez_compressed(a.output.with_suffix('.npz'),**arrays);out['max_constraint_violation']=max(float(np.max(c.violation())) for c in con)
 np.savez_compressed(a.output.with_suffix('.scs.npz'),**{k:v for k,v in stats.extra_stats.items() if isinstance(v,np.ndarray)});out['solver_info']=stats.extra_stats.get('info',{})
 def clean(v):
  if isinstance(v,dict):return {k:clean(x) for k,x in v.items()}
  if isinstance(v,list):return [clean(x) for x in v]
  if isinstance(v,float) and not math.isfinite(v):return None
  return v
 out=clean(out);a.output.write_text(json.dumps(out,indent=2,allow_nan=False)+'\n');print(out,flush=True)
if __name__=='__main__':main()
