#!/usr/bin/env python3
"""Find and rigorously consume a residual-corrected rational SDP dual ray."""
from pathlib import Path
from itertools import product
from collections import defaultdict
import argparse,json,math,time
import numpy as np,cvxpy as cp
from cyclic_moment_sdp import model
from block_moment_dual import patterns_from_source,layout,row,source_constraints,verify

def unsvec(v,n):
 M=np.zeros((n,n));k=0
 for j in range(n):
  for i in range(j,n):M[i,j]=M[j,i]=v[k]/(1 if i==j else math.sqrt(2));k+=1
 assert k==len(v);return M

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--block',type=int,default=4);ap.add_argument('--target',type=int,default=64);ap.add_argument('--seconds',type=float,default=90);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();source=json.loads((Path(__file__).parent/'inversion-results/normal-form.json').read_text());patterns=patterns_from_source(source,a.block);P=16;m=len(patterns);N=2*m;prob,p,C=model(patterns,P,a.target,None);prob.solve(solver='SCS',eps=1e-9,max_iters=100000,time_limit_secs=a.seconds,verbose=False);print('NUMERICAL_STATUS',prob.status,flush=True);assert prob.status=='infeasible'
 data,chain,inverses=prob.get_problem_data(cp.SCS);stuff=[v for v in inverses if hasattr(v,'var_offsets')][-1];names={v.name():v.id for v in prob.variables()};pidx,Cidx,V=layout(N,P);oldnew={}
 for name,newindices in [('first',pidx)]+[('C0' if h==0 else 'Chalf' if h==8 else f'C{h}',[Cidx[h][i][j] for i in range(N) for j in range(i,N)] if h in [0,8] else [Cidx[h][i][j] for j in range(N) for i in range(N)]) for h in range(9)]:
  off=stuff.var_offsets[names[name]]
  for k,new in enumerate(newindices):oldnew[off+k]=new
 assert set(oldnew)==set(range(V)) and len(oldnew)==data['A'].shape[1]
 z=data['dims'].zero;l=data['dims'].nonneg;end=z+l;A=data['A'][:end,:].tocsr();bb=data['b'][:end];yy=prob.solver_stats.extra_stats['y'];assert all(np.isfinite(yy));off=end;Ys=[]
 for n in data['dims'].psd:
  length=n*(n+1)//2;Ys.append(unsvec(yy[off:off+length],n));off+=length
 assert len(Ys)==9;Y0=Ys[0];Y8=Ys[8];Ds={}
 for h in range(9):
  M=Y0[1:,1:]+((-1)**h)*Y8
  for k in range(1,8):
   Y=Ys[k];U=(Y[:N,:N]+Y[N:,N:])/2;VV=(Y[N:,:N]-Y[:N,N:])/2;M=M+2*(math.cos(2*math.pi*k*h/P)*U+math.sin(2*math.pi*k*h/P)*VV)
  Ds[h]=M/P
 den=1<<40;u=np.rint(Y0[0,1:]/4*den).astype(np.int64).tolist();y00=round(Y0[0,0]*den);D={h:np.rint(v*den).astype(np.int64).tolist() for h,v in Ds.items()}
 for h in [0,8]:
  for i in range(N):
   for j in range(i,N):D[h][i][j]=D[h][j][i]=round((D[h][i][j]+D[h][j][i])/2)
 terms=defaultdict(int);eq,ineq,_=source_constraints(patterns,P,a.target)
 for i in range(end):
  mult=round(yy[i]*den)
  if i>=z:mult=max(0,mult)
  if mult==0:continue
  rr=A[i:i+1,:];coeff=[(oldnew[int(j)],round(float(v))) for j,v in zip(rr.indices,rr.data)];kind='eq' if i<z else 'ineq';raw=tuple(sorted((j,v) for j,v in coeff if v));rhs=round(float(bb[i]));key=row(coeff,rhs,kind)
  if kind=='eq' and raw and raw[0][1]<0:mult=-mult
  assert key in (eq if kind=='eq' else ineq),(kind,key)
  terms[(kind,key)]+=mult
 linear=[{'kind':kind,'coeff':key[0],'rhs':key[1],'multiplier':mult} for (kind,key),mult in sorted(terms.items()) if mult]
 # A small rational identity shift makes the entire dual moment matrix strict.
 for shift in [1e-7,1e-6,1e-5,1e-4]:
  dd={h:[r[:] for r in M] for h,M in D.items()};delta=math.ceil(shift*den)
  for i in range(N):dd[0][i][i]+=delta
  cert={'status':'RATIONAL_DUAL_CANDIDATE','source_C16_answered':False,'scope':'Forced block moment obstruction only; source thin-family bridge is separate','block':a.block,'target':a.target,'period':16,'patterns':patterns,'denominator':den,'constant':y00+delta,'mean':u,'D':dd,'linear_terms':linear,'identity_shift_numerator':delta}
  try:check=verify(cert,source)
  except (AssertionError,np.linalg.LinAlgError) as e:print('RETRY',shift,str(e)[:180],flush=True);continue
  cert['status']='EXACT_BLOCK_SDP_INFEASIBILITY_CERTIFICATE';a.output.write_text(json.dumps(cert)+'\n');a.output.with_suffix('.checked.json').write_text(json.dumps(check,indent=2)+'\n');print(json.dumps(check),flush=True);break
 else:raise AssertionError('No rigorous dual certificate recovered')
if __name__=='__main__':main()
