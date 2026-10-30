"""Small-row direct fixed-lambda allocation LP; exact candidate recovery only.

At the accepted zero-higher-moment law, six pair-pattern allocations determine
all empty/singleton allocations. Local exact facet faces are eliminated first;
only pair bucket masses remain as global equalities. Rank inequalities are
omitted. An accepted allocation is not full-basis membership.
"""
from pathlib import Path
from fractions import Fraction as Q
from itertools import combinations
from math import lcm
import argparse,gzip,hashlib,json,time
import numpy as np
from scipy.sparse import csr_matrix,save_npz
from scipy.optimize import linprog
from scipy.linalg import qr
from flint import fmpq_mat,fmpz_mat
from verify_two_sided_full_basis_oracle import physical_source,domains,target
from two_basis_structure import status_normals,generator,pattern_support,solve_unique
ROOT=Path(__file__).resolve().parent
PAIRS=[3,5,6,9,10,12]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):return json.loads(Path(p).read_text())
def expr(c=0,r=None):return (Q(c),{} if r is None else r)
def plus(a,b,t=Q(1)):
 c=a[0]+t*b[0];r=dict(a[1])
 for k,v in b[1].items():
  w=r.get(k,Q(0))+t*v
  if w:r[k]=w
  elif k in r:del r[k]
 return c,r
def substitute(e,sub):
 out=expr(e[0])
 for j,c in e[1].items():out=plus(out,sub[j],c)
 return out
def local_eliminate(equations,n,offset):
 A=[[r.get(j,Q(0)) for j in range(n)]+[-c] for c,r in equations];row=0;piv=[]
 for col in range(n):
  q=next((q for q in range(row,len(A)) if A[q][col]),None)
  if q is None:continue
  A[row],A[q]=A[q],A[row];v=A[row][col];A[row]=[x/v for x in A[row]]
  for k in range(len(A)):
   if k!=row and A[k][col]:v=A[k][col];A[k]=[x-v*y for x,y in zip(A[k],A[row])]
  piv.append(col);row+=1
 assert all(any(r[:-1]) or r[-1]==0 for r in A)
 free=[j for j in range(n) if j not in piv];sub={j:expr(0,{offset+k:Q(1)}) for k,j in enumerate(free)}
 for row,p in enumerate(piv):
  out=expr(A[row][-1])
  for j in free:out=plus(out,sub[j],-A[row][j])
  sub[p]=out
 return sub,free

def status_table(dd):
 out=[[-1]*16 for j in range(720)]
 for m,d in enumerate(dd):
  for j in d['zero_forced']:out[j][m]=1
  for j in d['zero_free']:out[j][m]=0
  for choices in d['bins']:
   for j in choices:out[j][m]=1 if j in d['forced'] else 0
 return out

def construct(X,Z,side,xx,zz,lam,b):
 dd=[r[side] for r in domains(X,Z,xx,zz)];assert all(r['feasible'] for r in dd);status=status_table(dd);normcache={};face=[];allE=[[None]*720 for m in range(16)];variables=[];local=[]
 for j,ss in enumerate(status):
  key=tuple(ss)
  if key not in normcache:normcache[key]=status_normals(key)
  fixed={m:(lam[m] if ss[m]==1 else Q(0)) for m in range(16) if ss[m]!=0 or not lam[m]};witness={};wanted=[b[720*i+j] for i in range(5)];N=normcache[key]
  for v0 in [*N['facet_normals'],*N['equality_normals']]:
   for sign in [1,-1]:
    v=[sign*a for a in v0];left=sum(a*z for a,z in zip(v,wanted));h=pattern_support(ss,v);upper=sum(l*z for l,z in zip(lam,h));assert left<=upper
    if left==upper:
     for m in range(16):
      dot=sum(x*y for x,y in zip(v,generator(m)))
      if ss[m]==0 and lam[m] and dot:
       value=lam[m] if dot>0 else Q(0)
       if m in fixed:assert fixed[m]==value
       else:fixed[m]=value;witness[m]=v
  face.extend(dict(vector=j,mask=m,value=str(fixed[m]),normal=v) for m,v in witness.items())
  rawfree=[m for m in PAIRS if m not in fixed];raw={m:expr(fixed[m]) if m in fixed else expr(0,{rawfree.index(m):Q(1)}) for m in PAIRS};ee={m:expr(0) for m in range(16)};ee.update(raw)
  for i in range(4):
   e=expr(b[720*(i+1)+j])
   for m in PAIRS:
    if m>>i&1:e=plus(e,raw[m],Q(-1))
   ee[1<<i]=e
  e=expr(b[j]-sum(b[720*(i+1)+j] for i in range(4)))
  for m in PAIRS:e=plus(e,raw[m])
  ee[0]=e
  equations=[plus(ee[m],expr(-v)) for m,v in fixed.items()];offset=len(variables);sub,free=local_eliminate(equations,len(rawfree),offset);variables.extend([j,rawfree[k]] for k in free)
  for m in range(16):
   allE[m][j]=substitute(ee[m],sub)
   if m in fixed:assert allE[m][j]==expr(fixed[m])
  local.append(dict(vector=j,raw_pair_variables=len(rawfree),free_variables=len(free),fixed_patterns={str(m):str(v) for m,v in fixed.items()}))
 equalities=[];labels=[]
 for m in PAIRS:
  d=dd[m];buckets=[('zero',d['zero_forced']+d['zero_free'],d['zero_required'])]+[(f'owner{k}',a,1) for k,a in enumerate(d['bins'])]
  for name,indices,r in buckets:
   e=expr(-lam[m]*r)
   for j in indices:e=plus(e,allE[m][j])
   if e[1]:equalities.append(e);labels.append([m,name])
   else:assert e[0]==0
 # Full boxes. Positive normalized margin only on coordinates not exactly fixed.
 inequalities=[];boundsmeta=[]
 for m in range(16):
  for j in range(720):
   c,r=allE[m][j]
   if not r:assert 0<=c<=lam[m];continue
   inequalities.append((-c,{k:-v for k,v in r.items()}));boundsmeta.append([m,j,'lower'])
   inequalities.append((c-lam[m],dict(r)));boundsmeta.append([m,j,'upper'])
 return dd,allE,variables,equalities,labels,inequalities,boundsmeta,face,local

def sparse(rows,n,margin,lam,meta=None):
 rr=[];cc=[];vv=[];rhs=[]
 for i,(c,r) in enumerate(rows):
  rhs.append(float(-c))
  for j,v in r.items():rr.append(i);cc.append(j);vv.append(float(v))
  if margin:rr.append(i);cc.append(n);vv.append(float(lam[meta[i][0]]))
 return csr_matrix((vv,(rr,cc)),shape=(len(rows),n+1)),np.array(rhs)
def evaluate(E,x):return [[c+sum(v*x[k] for k,v in r.items()) for c,r in row] for row in E]
def exact_check(y,lam,dd,b):
 f=[sum(y[m][j] for m in range(16)) for j in range(720)]+[sum(y[m][j] for m in range(16) if m>>i&1) for i in range(4) for j in range(720)];assert f==b
 failures=[]
 for m,d in enumerate(dd):
  assert sum(y[m])==128*lam[m]
  allowed=set(d['zero_forced']+d['zero_free']+[j for B in d['bins'] for j in B])
  for j,v in enumerate(y[m]):
   assert j in allowed or v==0
   if j in d['forced']:assert v==lam[m]
   if not 0<=v<=lam[m]:failures.append([m,j,str(v)])
  assert sum(y[m][j] for j in d['zero_forced']+d['zero_free'])==lam[m]*d['zero_required']
  assert all(sum(y[m][j] for j in B)==lam[m] for B in d['bins'])
 return failures

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--lambda-seed',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--side',choices=['X','Z'],required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=120);ap.add_argument('--prepare-only',action='store_true');a=ap.parse_args();assert not a.output.exists();start=time.monotonic();seed=read(a.lambda_seed);lam=list(map(Q,seed['lambda_masses']));assert all(not l for m,l in enumerate(lam) if m.bit_count()>2) and all(lam[m]>0 for m in [0,1,2,4,8]);assert seed['point_sha256']==sha(a.point);xx,zz=seed['X_anchors'],seed['Z_anchors'];X,Z,_=physical_source();full=target(a.point,xx,zz);s=int(a.side=='Z');b=full[11+720*s:731+720*s]+[full[1451+1440*i+720*s+j] for i in range(4) for j in range(720)];assert all(sum(lam[m] for m in range(16) if m&t==t)==full[k] for k,t in enumerate([0,1,2,4,8,3,5,9,6,10,12]));dd,E,variables,eq,labels,ineq,meta,face,local=construct(X,Z,a.side,xx,zz,lam,b);n=len(variables);Aub,bub=sparse(ineq,n,True,lam,meta);Aeq,beq=sparse(eq,n,False,lam);paths=['two_basis_structure_direct_allocation.py','two_basis_structure.py','verify_two_sided_full_basis_oracle.py','verify_algebraic_model.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt'];frozen=dict(status='FROZEN_DIRECT_PAIR_ALLOCATION_BOX_GATE',side=a.side,X_anchors=xx,Z_anchors=zz,point_sha256=sha(a.point),lambda_seed_sha256=sha(a.lambda_seed),source_hashes={p:sha(ROOT/p) for p in paths},lambda_masses=list(map(str,lam)),variables=variables,variable_count=n,global_equation_count=len(eq),box_inequality_count=len(ineq),global_equation_labels=labels,local_face_fixes=face,local_block_summary=local,seconds=a.seconds,scope='Count/box allocation only; all matroid rank inequalities omitted. Exact recovery and independent replay required.');fp=a.output.with_name(a.output.name.removesuffix('.json.gz').removesuffix('.json')+'.frozen.json');assert not fp.exists();fp.write_text(json.dumps(frozen,indent=2)+'\n');print('PREPARED',a.side,n,'vars',len(eq),'global rows',len(ineq),'box inequalities',len(face),'face fixes',flush=True)
 if a.prepare_only:
  a.output.write_text(json.dumps(dict(status='DIRECT_ALLOCATION_MODEL_PREPARED',frozen_sha256=sha(fp),preparation_seconds=time.monotonic()-start),indent=2)+'\n');return
 c=np.zeros(n+1);c[-1]=-1;lp=linprog(c,A_ub=Aub,b_ub=bub,A_eq=Aeq,b_eq=beq,bounds=[(None,None)]*n+[(0,.5)],method='highs-ipm',options={'presolve':False,'time_limit':a.seconds,'primal_feasibility_tolerance':1e-9,'dual_feasibility_tolerance':1e-9,'ipm_optimality_tolerance':1e-10});out=dict(status='DIRECT_ALLOCATION_NUMERICAL_INCONCLUSIVE',frozen_sha256=sha(fp),numeric_status=int(lp.status),numeric_message=lp.message,iteration_count=int(lp.nit),numeric_margin=None if lp.x is None else float(lp.x[-1]),elapsed_seconds=time.monotonic()-start)
 if lp.x is not None:
  np.savez_compressed(a.output.with_name(a.output.name.removesuffix('.json.gz').removesuffix('.json')+'.numeric.npz'),x=lp.x,variables=np.array(variables,dtype=np.int64));x=[Q(float(v)) for v in lp.x[:-1]];den=[lcm(*(z.denominator for z in [e[0],*e[1].values()])) for e in eq];A=[[int(e[1].get(j,0)*d) for j in range(n)] for e,d in zip(eq,den)];rhs=[-e[0]*d for e,d in zip(eq,den)];rank0=int(fmpz_mat(A).rank());_,_,roworder=qr(np.array(A,dtype=float).T,pivoting=True,mode='economic');rows=list(map(int,roworder[:rank0]));_,_,colorder=qr(np.array(A,dtype=float)[rows],pivoting=True,mode='economic');cols=list(map(int,colorder[:rank0]));res=[rhs[k]-sum(v*z for v,z in zip(A[k],x)) for k in range(len(A))]
  try:
   correction=solve_unique([[A[k][j] for j in cols] for k in rows],[res[k] for k in rows]);
   for j,v in zip(cols,correction):x[j]+=v
   assert all(sum(v*z for v,z in zip(row,x))==t for row,t in zip(A,rhs));y=evaluate(E,x);fail=exact_check(y,lam,dd,b);out.update(global_exact_rank=rank0,recovery_pivot_rows=rows,recovery_pivot_columns=cols,maximum_parameter_correction=str(max([Q(0),*map(abs,correction)])),exact_box_failures=fail,exact_feature_equations=3600,exact_global_bucket_equations=len(eq),minimum_box_slack=str(min(min(v,lam[m]-v) for m,row in enumerate(y) for v in row)),sector_target=list(map(str,b)),exact_allocations=[[str(v) for v in row] for row in y]);out['status']='EXACT_DIRECT_COUNT_ALLOCATION_REQUIRES_REPLAY' if not fail else 'EXACT_DIRECT_ALLOCATION_BOX_RECOVERY_FAILED'
  except (AssertionError,ValueError,ZeroDivisionError) as error:out['exact_recovery_error']=str(error)
 out['elapsed_seconds']=time.monotonic()-start;raw=(json.dumps(out,indent=2)+'\n').encode();a.output.write_bytes(gzip.compress(raw,mtime=0) if str(a.output).endswith('.gz') else raw);print({k:v for k,v in out.items() if k not in ['exact_allocations','sector_target','exact_box_failures']},flush=True)
if __name__=='__main__':main()
