#!/usr/bin/env python3
"""Recover a rational witness for the profile-enhanced real relaxation.

The independently callable verifier below checks exact equalities, local convex
weights and capacities before consuming the original physical/interval checker.
A successful witness is a method barrier, not a physical frame.
"""
from pathlib import Path
import argparse,gzip,hashlib,json,time
import numpy as np
from scipy.sparse import coo_matrix
from scipy.linalg import qr,lstsq
from flint import fmpq,fmpq_mat
ROOT=Path(__file__).resolve().parent

def layout(hulls):
 names=[];index={}
 def add(key):index[key]=len(names);names.append(key)
 for i in range(45):add(('p',i))
 for side in ['S','T']:
  for h in range(9):
   for i in range(45):
    for j in range(i if h in [0,8] else 0,45):add((side,h,i,j))
 for r in hulls['records']:
  for j in range(len(r['shapes'])):add(('w',r['orbit'],j))
 def m(side,h,i,j):
  if h>8:h=16-h;i,j=j,i
  if h in [0,8] and i>j:i,j=j,i
  return index[side,h,i,j]
 return names,index,m

def equalities(hulls,index,m):
 rows=[];rhs=[]
 def row(pairs,b=0):rows.append(pairs);rhs.append(b)
 for i in range(45):row([(m('S',0,i,i),1),(index['p',i],-1)])
 row([(index['p',i],16) for i in range(45)],128)
 for side in ['S','T']:
  for i in range(45):row([(m(side,h,i,j),1) for h in range(16) for j in range(45)]+[(index['p',i],-128)])
 X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in ['x','z']]
 for i in range(45):row([(m('T',h,i,j),1) for h in range(16) for j in range(45) if (X[16*i]&Z[16*j+h]).bit_count()%2]+[(index['p',i],-1)])
 for r in hulls['records']:
  o=r['orbit'];shapes=r['shapes'];row([(index['w',o,j],1) for j in range(len(shapes))],1)
  row([(index['w',o,j],s['moments'][0]) for j,s in enumerate(shapes)]+[(index['p',o],-16)])
  for h in range(1,9):row([(index['w',o,j],s['moments'][h]) for j,s in enumerate(shapes)]+[(m('S',h,o,o),-16)])
 ii=[];jj=[];vv=[]
 for k,r in enumerate(rows):
  for c,v in r:
   if v:ii.append(k);jj.append(c);vv.append(v)
 A=coo_matrix((vv,(ii,jj)),shape=(len(rows),len(index)),dtype=np.int64).tocsr();A.sum_duplicates();A.eliminate_zeros();return A,np.array(rhs,dtype=np.int64)

def verify(data,hulls,capacities,conditional,cross=None):
 from verify_moment_certificate import verify as old_verify
 names,index,m=layout(hulls);v=list(map(fmpq,data['values']));assert len(v)==len(names);A,b=equalities(hulls,index,m)
 for i in range(A.shape[0]):
  r=A[i:i+1];assert sum(int(a)*v[j] for a,j in zip(r.data,r.indices))==int(b[i]),('equality',i)
 for key,k in index.items():
  if key[0]=='w':assert v[k]>=0,('negative_weight',key,str(v[k]))
 p=[v[index['p',i]] for i in range(45)]
 for r in hulls['records']:
  o=r['orbit'];weights=[v[index['w',o,j]] for j in range(len(r['shapes']))];assert sum(weights)==1
  assert sum(w*s['moments'][0] for w,s in zip(weights,r['shapes']))==16*p[o]
  for h in range(1,9):assert sum(w*s['moments'][h] for w,s in zip(weights,r['shapes']))==16*v[m('S',h,o,o)]
 for i in range(45):assert 0<=p[i]<=1
 caps=[min(r['full_frame_count_upper_bound'],11 if r['orbit']==12 else 16) for r in sorted(capacities['records'],key=lambda r:r['orbit'])];M=conditional['capacity_matrix'];assert capacities['status']==conditional['status']=='PASS'
 for i in range(45):
  for j in range(45):
   for side in ['S','T']:assert sum(v[m(side,h,i,j)] for h in range(16))<=caps[j]*p[i],('capacity',side,i,j)
   assert sum(v[m('S',h,i,j)] for h in range(16))<=M[i][j]*p[i],('conditional',i,j)
 cross_checked=0
 if cross is not None:
  assert cross['status']=='PASS' and cross['selected_quotient_sector']=='Z';N=cross['capacity_matrix'];assert len(N)==45 and all(len(r)==45 for r in N);X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in ['x','z']]
  for i in range(45):
   for j in range(45):assert sum(v[m('T',h,i,j)] for h in range(16) if not (X[16*i]&Z[16*j+h]).bit_count()%2)<=N[i][j]*p[i],('conditional_nonpartner',i,j)
  cross_checked=2025
 C={}
 for h in range(9):C[str(h)]=[[str(v[m('S' if (i<45)==(j<45) else 'T',h,i%45,j%45)]) for j in range(90)] for i in range(90)]
 old=old_verify({'p':list(map(str,p+p)),'C':C},ROOT)
 return {'status':'PASS','source_C16_answered':False,'scope':'Exact feasible point of the stated real degree-two profile/capacity relaxation; not a distribution or source frame.','exact_equalities':A.shape[0],'rational_variables':len(v),'nonnegative_profile_weights':sum(k[0]=='w' for k in names),'capacity_inequalities':6075,'conditional_nonpartner_inequalities':cross_checked,'original_physical_moment_consumer':old}

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--numeric',type=Path);ap.add_argument('--hulls',type=Path,required=True);ap.add_argument('--capacities',type=Path,required=True);ap.add_argument('--conditional',type=Path,required=True);ap.add_argument('--conditional-cross',type=Path);ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--verify-only',action='store_true');ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();hulls=json.loads(gzip.decompress(a.hulls.read_bytes()));caps=json.loads(a.capacities.read_text());cond=json.loads(a.conditional.read_text());assert hulls['period']==16 and hulls['mode']=='rank'
 if a.verify_only:data=json.loads(gzip.decompress(a.certificate.read_bytes()))
 else:
  names,index,m=layout(hulls);A,b=equalities(hulls,index,m);z=np.load(a.numeric);x=np.array([float(z['p'][k[1]]) if k[0]=='p' else float(z[f'{k[0]}{k[1]}'][k[2],k[3]]) if k[0] in ['S','T'] else float(z[f'w{k[1]}'][k[2]]) for k in names]);G=(A@A.T).toarray().astype(float);_,R,rr=qr(G,pivoting=True);rank=int(np.sum(abs(np.diag(R))>1e-7));rr=rr[:rank];Ar=A[rr,:];br=b[rr];G=(Ar@Ar.T).toarray().astype(float)
  # Floating projection is only a search aid; every row is checked exactly later.
  for _ in range(2):x+=Ar.T@lstsq(G,br-Ar@x,cond=1e-12)[0]
  rng=np.random.default_rng(20261029);candidates=list(range(45))+list(rng.choice(len(names),9000,replace=False))
  for o in range(45):
   ids=[k for k,key in enumerate(names) if key[0]=='w' and key[1]==o];candidates.extend(sorted(ids,key=lambda k:x[k],reverse=True)[:60])
  cols=np.unique(candidates);_,R,perm=qr(Ar[:,cols].toarray().astype(float),pivoting=True,mode='economic');assert abs(R[rank-1,rank-1])>1e-8;cols=cols[perm[:rank]];D=1<<42;n=np.rint(x*D).astype(np.int64);res=b*D-A@n;B=Ar[:,cols].toarray();print('EXACT_RECOVERY',A.shape,'rank',rank,'residual',int(max(abs(res))),flush=True);delta=fmpq_mat(B.tolist()).solve(fmpq_mat([[int(t)] for t in res[rr]]));values=[fmpq(int(t),D) for t in n]
  for k,c in enumerate(cols):values[c]+=delta[k,0]/D
  data={'status':'CANDIDATE_REQUIRES_INDEPENDENT_REPLAY','source_C16_answered':False,'values':list(map(str,values)),'inputs':{str(p.name):hashlib.sha256(p.read_bytes()).hexdigest() for p in [a.hulls,a.capacities,a.conditional]},'row_rank_search':rank};a.certificate.write_bytes(gzip.compress((json.dumps(data)+'\n').encode(),mtime=0))
 for p in [a.hulls,a.capacities,a.conditional]:assert data['inputs'][p.name]==hashlib.sha256(p.read_bytes()).hexdigest()
 cross=json.loads(a.conditional_cross.read_text()) if a.conditional_cross else None;result=verify(data,hulls,caps,cond,cross);
 if a.conditional_cross:result['conditional_cross_matrix_sha256']=hashlib.sha256(a.conditional_cross.read_bytes()).hexdigest()
 result['certificate_sha256']=hashlib.sha256(a.certificate.read_bytes()).hexdigest();result['elapsed_seconds']=time.monotonic()-start;a.output.write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
