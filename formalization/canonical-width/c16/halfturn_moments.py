#!/usr/bin/env python3
"""Bounded numeric moment pilot for the still-open half-turn invariant case.

Invariance is an explicit restriction here. Quotient vertices represent two
physical points. An allowed selected block has exactly one of its two entries
nonzero; a double block forbids simultaneous endpoint selection. Cyclic and
sector exchange average moments within this restricted question.
"""
from pathlib import Path
import argparse,gzip,json,math,time
import numpy as np
import cvxpy as cp
ROOT=Path(__file__).resolve().parent
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--seconds',type=float,default=180);ap.add_argument('--iterations',type=int,default=10000);ap.add_argument('--flat-cuts',type=Path);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();P=8;q=45;target=64;X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in ['x','z']];unit=[];bad=[]
 for h in range(P):
  bits=np.array([[(X[16*i]&Z[16*j+h]).bit_count()%2+2*((X[16*i]&Z[16*j+h+8]).bit_count()%2) for j in range(q)] for i in range(q)]);unit.append(((bits==1)|(bits==2)).astype(int));bad.append((bits==3).astype(int))
 assert all(np.array_equal(unit[h],unit[(-h)%P].T) and np.array_equal(bad[h],bad[(-h)%P].T) for h in range(P))
 p=cp.Variable(q);S={0:cp.Variable((q,q),symmetric=True),4:cp.Variable((q,q),symmetric=True)};T={0:cp.Variable((q,q),symmetric=True),4:cp.Variable((q,q),symmetric=True)}
 for h in range(1,4):S[h]=cp.Variable((q,q));T[h]=cp.Variable((q,q));S[P-h]=S[h].T;T[P-h]=T[h].T
 rows=cp.reshape(p,(q,1),order='C')@np.ones((1,q));con=[p>=0,p<=1,cp.diag(S[0])==p,P*cp.sum(p)==target,P*p[12]<=5]
 for M in [sum(S.values()),sum(T.values())]:con.append(cp.sum(M,axis=1)==target*p)
 for h in range(5):
  for M in [S[h],T[h]]:con.extend([M>=0,M<=rows,M<=rows.T,M>=rows+rows.T-1])
  con.append(cp.multiply(bad[h],T[h])==0)
 con.append(cp.sum(sum(cp.multiply(unit[h],T[h]) for h in range(P)),axis=1)==p)
 G=cp.bmat([[np.ones((1,1)),cp.reshape(p,(1,q),order='C')],[cp.reshape(p,(q,1),order='C'),(sum(S.values())+sum(T.values()))/(2*P)]]);con.extend([G>>0,(sum(S.values())-sum(T.values()))>>0])
 for k in range(1,5):
  for sign in [1,-1]:
   B={h:S[h]+sign*T[h] for h in range(P)};real=B[0]+(-1)**k*B[4];imag=0*B[0]
   for h in range(1,4):real+=math.cos(2*math.pi*k*h/P)*(B[h]+B[h].T);imag+=math.sin(2*math.pi*k*h/P)*(B[h]-B[h].T)
   con.append((real if k==4 else cp.bmat([[real,-imag],[imag,real]]))>>0)
 flat_count=0
 if a.flat_cuts:
  d=json.loads(gzip.decompress(a.flat_cuts.read_bytes()))
  for r in d['records']:
   if r['sector']!='X':continue
   ids=r['closure_indices'];orbits=sorted({i//16 for i in ids});assert len(ids)==16*len(orbits)
   con.append(P*cp.sum(p[orbits])<=r['full_frame_upper_bound']//2);flat_count+=1
 problem=cp.Problem(cp.Minimize(0),con);print('HALFTURN MOMENTS prepared',len(con),'constraints',flat_count,'flat cuts',flush=True);a.output.write_text(json.dumps({'status':'RUNNING','scope':'Half-turn invariant necessary moment relaxation only','flat_cuts':flat_count})+'\n')
 value=problem.solve(solver='SCS',max_iters=a.iterations,eps=1e-6,time_limit_secs=a.seconds,verbose=False);stats=problem.solver_stats;out={'status':problem.status,'source_C16_answered':False,'scope':'Numerical half-turn invariant moment pilot. No exclusion without exact dual replay, no construction from moments.','target_quotient_pairs':target,'physical_pairs':128,'period':P,'types_per_sector':q,'flat_cuts':flat_count,'wall_seconds':time.monotonic()-start,'solver_seconds':stats.solve_time,'iterations':stats.num_iters,'objective':value}
 if p.value is not None:
  arrays={'p':p.value,**{f'S{h}':S[h].value for h in range(5)},**{f'T{h}':T[h].value for h in range(5)}};np.savez_compressed(a.output.with_suffix('.npz'),**arrays);out['max_constraint_violation']=max(float(np.max(c.violation())) for c in con)
 a.output.write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':main()
