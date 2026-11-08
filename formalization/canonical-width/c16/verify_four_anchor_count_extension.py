#!/usr/bin/env python3
"""Independent exact row audit of a numerical four-anchor count-LP candidate.

This consumer reconstructs physical evaluation signatures, variables, moment
targets and every sparse LP row without importing a four-anchor producer.
Binary floating candidates are treated as exact rationals. Small residuals
never become membership claims. The count-only support uses full signed
cardinality, and deliberately imposes no physical zero-pool rank inequalities.
"""
from pathlib import Path
from fractions import Fraction
from itertools import combinations
from collections import Counter
import argparse,hashlib,json,time
import numpy as np
from scipy.sparse import coo_matrix,load_npz
from verify_projected_profile_moment_rows import point_vector
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension
ROOT=Path(__file__).resolve().parent
PAIRS=list(combinations(range(4),2));N=3611
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def coord(side,h,i,j):
 h%=16
 if h>8:h,i,j=16-h,j,i
 if h in (0,8) and i>j:i,j=j,i
 if side=='S' and h==0 and i==j:return i
 return 45+(0 if side=='S' else 18225)+2025*h+45*i+j
def target(owner,anchors):
 a=[divmod(i,16) for i in anchors]
 return [Fraction(1)]+[owner[i] for i,t in a]+[owner[coord('S',a[j][1]-a[i][1],a[i][0],a[j][0])] for i,j in PAIRS]+[owner[j//16] for j in range(720)]+[owner[coord('T',b-t,i,j)] for i,t in a for j in range(45) for b in range(16)]
def literal(mask,Q):
 P=[int(mask>>i&1) for i in range(4)];q=[int(j in Q) for j in range(720)]
 return [1]+P+[P[i]*P[j] for i,j in PAIRS]+q+[p*v for p in P for v in q]
def bins(X,Z,selected):
 signature=[sum(((X[i]&z).bit_count()%2)<<k for k,i in enumerate(selected)) for z in Z]
 return [[j for j,s in enumerate(signature) if s==0]]+[[j for j,s in enumerate(signature) if s==1<<k] for k in range(len(selected))]
def count_support(buckets,n,k,w):
 if len(buckets[0])<n-k or any(not A for A in buckets[1:]):return None
 return sum(sorted((w[j] for j in buckets[0]),reverse=True)[:n-k])+sum(max(w[j] for j in A) for A in buckets[1:])
def tiny_controls():
 checks=0;exclusions=0
 for Z in [list(range(1,8)),[2,4,6],[1,2]]:
  X=[1,2]
  for m in range(4):
   selected=[i for i in range(2) if m>>i&1];bucket=bins(X,Z,selected);k=len(selected)
   allowed=[B for B in combinations(range(len(Z)),3) if len(set(B)&set(bucket[0]))==3-k and all(len(set(B)&set(A))==1 for A in bucket[1:])]
   for w in ([0]*len(Z),[-j-1 for j in range(len(Z))],[(3*j+1)%7-3 for j in range(len(Z))],[Fraction((-1)**j*(j+1),3) for j in range(len(Z))]):
    got=count_support(bucket,3,k,w);wanted=max((sum(w[j] for j in B) for B in allowed),default=None);assert got==wanted;checks+=1;exclusions+=wanted is None
 return dict(exact_signed_count_support_enumerations=checks,excluded_count_domains=exclusions)
def normalization_controls(anchors):
 rng=np.random.default_rng(202610300915);checks=0
 for probability in (0.,.2,.7,1.):
  data=(rng.random((2,45,16))<probability).astype(int)
  owner=[Fraction(int(data[:,j,:].sum()),32) for j in range(45)]
  for sector in (0,1):
   for h in range(9):
    for i in range(45):
     for j in range(45):owner.append(Fraction(sum(int(data[s,i,t])*int(data[s^sector,j,(t+h)%16]) for s in (0,1) for t in range(16)),32))
  observed=[0]*N
  for s in (0,1):
   for r in range(16):
    m=sum(int(data[s,j//16,(j%16-r)%16])<<i for i,j in enumerate(anchors));Q={16*j+t for j in range(45) for t in range(16) if data[1-s,j,(t-r)%16]};f=literal(m,Q);observed=[a+b for a,b in zip(observed,f)]
  assert [Fraction(v,32) for v in observed]==target(owner,anchors);checks+=N
 return checks
def reconstruct(X,Z,anchors):
 variables=[('lambda',m,-1) for m in range(16)];rows=[{} for _ in range(N)];upper=[];domains=[]
 for m in range(16):
  f=literal(m,set())[:11]
  for r,v in enumerate(f):
   if v:rows[r][m]=v
 for m in range(16):
  selected=sorted(anchors[i] for i in range(4) if m>>i&1);assert dimension(X[j] for j in selected)==len(selected);bucket=bins(X,Z,selected);domains.append(bucket)
  for k,A in enumerate(bucket):
   row={m:-(128-len(selected)) if k==0 else -1};rows.append(row)
   for j in A:
    v=len(variables);variables.append(('y',m,j));row[v]=1;rows[11+j][v]=1
    for i in range(4):
     if m>>i&1:rows[731+720*i+j][v]=1
    if k==0:upper.append({v:1,m:-1})
 def sparse(R):
  entries=[(i,j,v) for i,row in enumerate(R) for j,v in row.items()];return coo_matrix(([v for i,j,v in entries],([i for i,j,v in entries],[j for i,j,v in entries])),shape=(len(R),len(variables)),dtype=np.int64).tocsr()
 return variables,rows,upper,sparse(rows),sparse(upper),domains

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--prefix',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();report=json.loads(Path(str(a.prefix)+'.json').read_text());assert report['point_sha256']==sha(a.point);anchors=report['anchors'];assert len(set(anchors))==4
 X,Z,_=physical();owner=point_vector(a.point);tar=target(owner,anchors);variables,rows,upper,E,U,domains=reconstruct(X,Z,anchors);saved=np.load(str(a.prefix)+'.npz');assert variables==[(str(t),int(m),int(j)) for t,m,j in saved['variables']];assert (E-load_npz(str(a.prefix)+'.equalities.npz')).nnz==0 and (U-load_npz(str(a.prefix)+'.inequalities.npz')).nnz==0
 rhs=tar+[Fraction(0)]*(len(rows)-N);assert list(map(Fraction,saved['rhs']))==rhs;raw=saved['x'];assert np.all(np.isfinite(raw));x=[Fraction(float(v)) for v in raw];res=[sum(v*x[j] for j,v in row.items())-b for row,b in zip(rows,rhs)];ur=[sum(v*x[j] for j,v in row.items()) for row in upper];eqbad=[i for i,v in enumerate(res) if v];ubad=[i for i,v in enumerate(ur) if v>0];negative=[i for i,v in enumerate(x) if v<0];above=[i for i,v in enumerate(x) if v>1]
 # These exact target identities are necessary row-dependence checks, not a
 # diagnosis of an internal HiGHS algorithm. Record floating cancellation too.
 dependencies=[('total_opposite_cardinality',sum(tar[11:731])-128, sum(map(float,tar[11:731]))-128)]
 for i,anchor in enumerate(anchors):
  q=tar[731+720*i:731+720*(i+1)];pair=[(X[anchor]&z).bit_count()%2 for z in Z]
  dependencies.append((f'conditional_total_cardinality_{i}',sum(q)-128*tar[1+i],sum(map(float,q))-128*float(tar[1+i])))
  dependencies.append((f'unique_physical_owner_{i}',sum(v for v,p in zip(q,pair) if p)-tar[1+i],sum(float(v) for v,p in zip(q,pair) if p)-float(tar[1+i])))
 assert all(v==0 for name,v,f in dependencies)
 # Every literal count-feasible column embeds exactly in the extension; use
 # extremizers of several signed weights, with no rank assumption involved.
 physical_columns=0;count_checks=0
 from full_partner_basis_oracle import FullPartnerBasisOracle
 oracle=FullPartnerBasisOracle(X,Z)
 for m,bucket in enumerate(domains):
  selected=sorted(anchors[i] for i in range(4) if m>>i&1);k=len(selected)
  for w in ([0]*720,[-j-1 for j in range(720)],[(37*j+5)%31-15 for j in range(720)]):
   zeros=sorted(bucket[0],key=lambda j:(-w[j],j))[:128-k];Q=set(zeros+[max(A,key=lambda j:(w[j],-j)) for A in bucket[1:]]);assert len(Q)==128 and sum(w[j] for j in Q)==count_support(bucket,128,k,w);count_checks+=1
   xx=[0]*len(variables);xx[m]=1
   for v,(kind,mask,j) in enumerate(variables):
    if kind=='y' and mask==m and j in Q:xx[v]=1
   literal_rhs=literal(m,Q)+[0]*(len(rows)-N);assert all(sum(v*xx[j] for j,v in row.items())==b for row,b in zip(rows,literal_rhs));assert all(sum(v*xx[j] for j,v in row.items())<=0 for row in upper)
  full=oracle.support(oracle.prepare_selected(selected),[0]*720);Q=set(full['selected_Z_indices']);assert dimension(Z[j] for j in Q)==128 and all(sum(j in Q for j in A)==(128-k if h==0 else 1) for h,A in enumerate(bucket));physical_columns+=1
 maxeq=max(map(abs,res),default=Fraction(0));maxupper=max([Fraction(0),*ur]);result=dict(status='PASS_EXACT_COUNT_EXTENSION_MEMBERSHIP' if not(eqbad or ubad or negative or above) else 'EXACT_BINARY_RATIONAL_CANDIDATE_FAILS_EQUALITY_OR_BOUND_CHECKS',source_C16_answered=False,anchors=anchors,point_sha256=sha(a.point),input_report_sha256=sha(Path(str(a.prefix)+'.json')),candidate_sha256=sha(Path(str(a.prefix)+'.npz')),consumer_sha256=sha(Path(__file__)),source_hashes={p:sha(ROOT/p) for p in ['physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','verify_algebraic_model.py','verify_partial_frame.py','audit_pools.py','verify_projected_profile_moment_rows.py','verify_full_partner_basis_oracle.py','full_partner_basis_oracle.py']},independent_sparse_matrix_identity=True,variables=len(variables),equalities=len(rows),inequalities=len(upper),exact_nonzero_equalities=len(eqbad),maximum_exact_equality_residual=str(maxeq),maximum_equality_residual_float=float(maxeq),positive_upper_bound_violations=len(ubad),maximum_exact_upper_bound_violation=str(maxupper),maximum_upper_violation_float=float(maxupper),negative_variables=len(negative),minimum_exact_variable=str(min(x)),above_one_variables=len(above),sample_nonzero_equalities=[dict(row=i,residual=str(res[i])) for i in eqbad[:20]],exact_target_dependencies=[dict(name=n,exact=str(v),float_cancellation_residual=f) for n,v,f in dependencies],factor_one_literal_feature_equalities=normalization_controls(anchors),exact_count_columns_embedded=count_checks,physical_full_basis_columns_checked=physical_columns,tiny_controls=tiny_controls(),elapsed_seconds=time.monotonic()-start,scope='Count-only extension constraints are physically necessary. Exact binary-rational solver values are checked without rounding or feasibility tolerance. A failed candidate is not a proof of LP infeasibility; a count-only feasible extension is not full-basis or source-frame membership. Presolve disagreement is numerical evidence only, not an accepted obstruction.')
 a.output.write_text(json.dumps(result,indent=2)+'\n');print({k:v for k,v in result.items() if k not in ('source_hashes','sample_nonzero_equalities','exact_target_dependencies')},flush=True)

if __name__=='__main__':main()
