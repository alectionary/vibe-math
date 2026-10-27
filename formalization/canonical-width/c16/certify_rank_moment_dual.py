#!/usr/bin/env python3
"""Find and rigorously consume a residual-corrected rational SDP dual ray."""
from pathlib import Path
from itertools import product
from collections import defaultdict
import argparse,json,math,time
import numpy as np,cvxpy as cp
from rectangular_moment_sdp import model,source_patterns
from scipy.sparse import csc_matrix
from rank_moment_dual import verify
from block_moment_dual import layout,row,source_constraints

def unsvec(v,n):
 M=np.zeros((n,n));k=0
 for j in range(n):
  for i in range(j,n):M[i,j]=M[j,i]=v[k]/(1 if i==j else math.sqrt(2));k+=1
 assert k==len(v);return M

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--families',type=int,nargs='+',required=True);ap.add_argument('--rank-X',type=Path,required=True);ap.add_argument('--rank-Z',type=Path,required=True);ap.add_argument('--conditional-cuts',type=Path,required=True);ap.add_argument('--linear',action='store_true');ap.add_argument('--seconds',type=float,default=120);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
 source=json.loads((Path(__file__).parent/'inversion-results/normal-form.json').read_text());patterns=source_patterns(source,a.families);P=16;m=len(patterns);n=len(patterns[0]);N=m+n;prob,p,C=model(patterns,P,128);B0=sum(C.values());con=list(prob.constraints);rectangles=[];conditional=json.loads(a.conditional_cuts.read_text());selected={(c['sector'],c['thin_mask'],c['thick_mask']) for c in conditional}
 for side,path in [('X',a.rank_X),('Z',a.rank_Z)]:
  fam=a.families if side=='X' else list(range(5));offset=0 if side=='X' else m
  for cut in json.loads(path.read_text()):
   T=cut['thin_mask'];I=cut['thick_mask']
   if any(T>>j&1 and j not in fam for j in range(5)):continue
   columns=[offset+9*c+i for c,j in enumerate(fam) if T>>j&1 for i in range(9) if I>>i&1]
   rectangles.append({**cut,'sector':side,'columns':columns,'first':True,'conditional':(side,T,I) in selected})
 K=csc_matrix((np.ones(sum(len(c['columns']) for c in rectangles)),([j for c in rectangles for j in c['columns']],[k for k,c in enumerate(rectangles) for j in c['columns']])),shape=(N,len(rectangles)));r=np.array([c['rank'] for c in rectangles],dtype=float);con.append(16*(K.T@p)<=r);selected=[k for k,c in enumerate(rectangles) if c['conditional']]
 con.append(B0@K[:,selected]<=cp.reshape(p,(N,1),order='C')@r[selected].reshape(1,-1));prob=cp.Problem(cp.Minimize(0),[c for c in con if not(a.linear and isinstance(c,cp.constraints.psd.PSD))])
 prob.solve(solver='SCS',eps=1e-9,max_iters=100000,time_limit_secs=a.seconds,verbose=False);print('NUMERICAL_STATUS',prob.status,flush=True)
 if prob.status!='infeasible':
  a.output.write_text(json.dumps({'status':prob.status,'linear_only':a.linear,'source_C16_answered':False,'X_thin_families':a.families,'exact_certificate':False})+'\n');return
 data,chain,inverses=prob.get_problem_data(cp.SCS);stuff=[v for v in inverses if hasattr(v,'var_offsets')][-1];names={v.name():v.id for v in prob.variables()};pidx,Cidx,V=layout(N,P);oldnew={}
 for name,newindices in [('first',pidx)]+[('C0' if h==0 else 'Chalf' if h==8 else f'C{h}',[Cidx[h][i][j] for i in range(N) for j in range(i,N)] if h in [0,8] else [Cidx[h][i][j] for j in range(N) for i in range(N)]) for h in range(9)]:
  off=stuff.var_offsets[names[name]]
  for k,new in enumerate(newindices):oldnew[off+k]=new
 assert set(oldnew)==set(range(V)) and len(oldnew)==data['A'].shape[1]
 z=data['dims'].zero;l=data['dims'].nonneg;end=z+l;A=data['A'][:end,:].tocsr();bb=data['b'][:end];yy=prob.solver_stats.extra_stats['y'];assert all(np.isfinite(yy));off=end;Ys=[]
 for n in data['dims'].psd:
  length=n*(n+1)//2;Ys.append(unsvec(yy[off:off+length],n));off+=length
 if a.linear:assert not Ys;Ys=[np.zeros((N+1,N+1))]+[np.zeros((2*N,2*N)) for _ in range(7)]+[np.zeros((N,N))]
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
 terms=defaultdict(int);eq,ineq,_=source_constraints(patterns,P,128)
 for i in range(end):
  mult=round(yy[i]*den)
  if i>=z:mult=max(0,mult)
  if mult==0:continue
  rr=A[i:i+1,:];coeff=[(oldnew[int(j)],round(float(v))) for j,v in zip(rr.indices,rr.data)];kind='eq' if i<z else 'ineq';raw=tuple(sorted((j,v) for j,v in coeff if v));rhs=round(float(bb[i]));key=row(coeff,rhs,kind)
  if kind=='eq' and raw and raw[0][1]<0:mult=-mult
  terms[(kind,key)]+=mult
 linear=[{'kind':kind,'coeff':key[0],'rhs':key[1],'multiplier':mult} for (kind,key),mult in sorted(terms.items()) if mult]
 # A small rational identity shift makes the entire dual moment matrix strict.
 for shift in [1e-7,1e-6,1e-5,1e-4]:
  dd={h:[r[:] for r in M] for h,M in D.items()};delta=math.ceil(shift*den)
  for i in range(N):dd[0][i][i]+=delta
  cert={'status':'RATIONAL_DUAL_CANDIDATE','source_C16_answered':False,'scope':'Source rank-rectangle moment obstruction for the listed X thin families','X_thin_families':a.families,'rank_rectangles':rectangles,'target':128,'period':16,'patterns':patterns,'denominator':den,'constant':y00+delta,'mean':u,'D':dd,'linear_terms':linear,'identity_shift_numerator':delta}
  try:check=verify(cert,source)
  except (AssertionError,np.linalg.LinAlgError) as e:print('RETRY',shift,str(e)[:180],flush=True);continue
  cert['status']='EXACT_SOURCE_RANK_SDP_INFEASIBILITY_CERTIFICATE';a.output.write_text(json.dumps(cert)+'\n');a.output.with_suffix('.checked.json').write_text(json.dumps(check,indent=2)+'\n');print(json.dumps(check),flush=True);break
 else:raise AssertionError('No rigorous dual certificate recovered')
if __name__=='__main__':main()
