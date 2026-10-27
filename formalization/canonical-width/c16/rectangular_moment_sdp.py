#!/usr/bin/env python3
"""Necessary cyclic degree-two moments for rectangular orbit pools."""
from pathlib import Path
import argparse,json,math,time
import numpy as np,cvxpy as cp
from itertools import product
from pool_inverse_structure import rank_one,rotate_s

def source_patterns(source,families):
 q=source['dictionary'];X=[rank_one(a,q['X_right_factors'][c]) for c in families for a in q['X_left_dictionary']];Z=[rank_one(c,d) for c in q['Z_left_factors'] for d in q['Z_right_dictionary']];pack=lambda v:sum(w<<(16*i) for i,w in enumerate(w for s in v for w in s));xx=list(map(pack,X));patterns=[[0]*len(Z) for _ in X]
 for j,z in enumerate(Z):
  for h in range(16):
   cov=pack([(b,a^b) for a,b in [rotate_s(v,h) for v in z]])
   for i,x in enumerate(xx):patterns[i][j]|=((x&cov).bit_count()%2)<<h
 return patterns

def model(patterns,P,target,normalize_equalities=False,fixed_margin=0,linear_slack=0):
 m=len(patterns);n=len(patterns[0]);N=m+n;p=cp.Variable(N,name='first');C={0:cp.Variable((N,N),symmetric=True,name='C0'),P//2:cp.Variable((N,N),symmetric=True,name='Chalf')}
 for h in range(1,P//2):C[h]=cp.Variable((N,N),name=f'C{h}');C[P-h]=C[h].T
 B0=sum(C.values());ones=np.ones((1,N));rows=cp.reshape(p,(N,1),order='C')@ones;cols=rows.T;eta=linear_slack;con=[p>=eta,p<=1-eta,cp.diag(C[0])==p]
 if normalize_equalities:con.extend([(P/target)*cp.sum(p[:m])==1,(P/target)*cp.sum(p[m:])==1,cp.sum(B0[:,:m],axis=1)/target==p,cp.sum(B0[:,m:],axis=1)/target==p])
 else:con.extend([P*cp.sum(p[:m])==target,P*cp.sum(p[m:])==target,cp.sum(B0[:,:m],axis=1)==target*p,cp.sum(B0[:,m:],axis=1)==target*p])
 for h in range(P//2+1):
  upper_slack=eta*(np.ones((N,N))-np.eye(N) if h==0 else np.ones((N,N)));con.extend([C[h]>=eta,C[h]<=rows-upper_slack,C[h]<=cols-upper_slack,C[h]>=rows+cols-1+eta])
 G0=cp.bmat([[np.ones((1,1)),math.sqrt(P)*cp.reshape(p,(1,N),order='C')],[math.sqrt(P)*cp.reshape(p,(N,1),order='C'),B0]]);
 if fixed_margin:
  U=np.zeros((N+1,2));U[0,:]=-target/math.sqrt(P);U[1:m+1,0]=1;U[m+1:,1]=1;projection=np.eye(N+1)-U@np.linalg.inv(U.T@U)@U.T;con.append(G0-fixed_margin*projection>>0)
 else:con.append(G0>>0)
 for k in range(1,P//2+1):
  real=C[0]+((-1)**k)*C[P//2];imag=0*C[0]
  for h in range(1,P//2):
   c=(-1)**h if k==P//2 else math.cos(2*math.pi*k*h/P);s=0 if k==P//2 else math.sin(2*math.pi*k*h/P);real=real+c*(C[h]+C[h].T);imag=imag+s*(C[h]-C[h].T)
  block=real if k==P//2 else cp.bmat([[real,-imag],[imag,real]]);con.append(block-fixed_margin*np.eye(block.shape[0])>>0)
 anti=[np.array([[patterns[a][b]>>h&1 for b in range(n)] for a in range(m)],dtype=float) for h in range(P)];cross=sum(cp.multiply(anti[h],C[h][:m,m:]) for h in range(P));con.extend([cp.sum(cross,axis=1)==p[:m],cp.sum(cross,axis=0)==p[m:]])
 return cp.Problem(cp.Minimize(0),con),p,C

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--families',type=int,nargs='+',required=True);ap.add_argument('--seconds',type=float,default=90);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();source=json.loads((Path(__file__).parent/'inversion-results/normal-form.json').read_text());patterns=source_patterns(source,a.families);start=time.monotonic();prob,p,C=model(patterns,16,128);print('MODEL',a.families,len(patterns),len(patterns[0]),flush=True);prob.solve(solver='SCS',eps=2e-6,max_iters=10000,time_limit_secs=a.seconds,verbose=False);r={'status':prob.status,'families':a.families,'target':128,'seconds':time.monotonic()-start,'source_C16_answered':False,'scope':'Numerical necessary relaxation with X thin support restricted to the listed families; no symmetry restriction on a hypothetical frame','orbit_counts':[len(patterns),len(patterns[0])]};a.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r),flush=True)
 if p.value is not None:np.savez_compressed(a.output.with_suffix('.moments.npz'),first=p.value,**{f'C{h}':C[h].value for h in range(9)})
if __name__=='__main__':main()
