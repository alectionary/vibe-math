#!/usr/bin/env python3
"""Bounded exact recovery using five local equations per physical Z vector.

Exact numerical zeros and y=lambda equalities specify a candidate face. Each
five-row Z block eliminates local y variables. Only lambda/free-y parameters
enter the remaining source pattern/count equations. A failed face or negative
exact value is rejected, never interpreted as global infeasibility.
"""
from pathlib import Path
from fractions import Fraction as Q
from math import lcm
import argparse,gzip,hashlib,json,time
import numpy as np
from scipy.linalg import qr
from flint import fmpz_mat,fmpq_mat
from two_sided_count_exact_rows import reconstruct,target
from verify_projected_profile_moment_rows import point_vector
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write(p,x):
 assert not p.exists();raw=(json.dumps(x,indent=2)+'\n').encode();p.write_bytes(gzip.compress(raw,mtime=0) if str(p).endswith('.gz') else raw)
def add(dst,src,scale):
 for j,v in src.items():
  dst[j]=dst.get(j,Q(0))+scale*v
  if not dst[j]:del dst[j]

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--prefix',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--release-zero',type=int,nargs='*',default=[]);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();report=json.loads(Path(str(a.prefix)+'.json').read_text());anchors=report['X_anchors']+report['Z_anchors'];assert report['point_sha256']==sha(a.point);saved=np.load(str(a.prefix)+'.npz');numeric=saved['x'];from scipy.sparse import load_npz;X,Z,_=physical();variables,rows,upper,E,U,domains=reconstruct(X,Z,anchors);assert (E-load_npz(str(a.prefix)+'.equalities.npz')).nnz==0 and (U-load_npz(str(a.prefix)+'.inequalities.npz')).nnz==0;tar=target(point_vector(a.point),anchors);rhs=tar+[Q(0)]*(len(rows)-7211);assert variables==[(str(t),int(m),int(j)) for t,m,j in saved['variables']]
 expressions=[None]*len(variables);constants=[Q(0)]*len(variables);params=list(range(16));approx=list(map(float,numeric[:16]));consistency=[];local_stats=[];byZ=[[] for _ in range(1440)]
 for i in range(16):expressions[i]={i:Q(1)}
 for v,(kind,m,j) in enumerate(variables):
  if kind=='y':byZ[j].append(v)
 sources=['recover_two_sided_count_exact_v2.py','two_sided_count_exact_rows.py','verify_two_sided_anchor_count.py','verify_projected_profile_moment_rows.py','verify_algebraic_model.py','verify_partial_frame.py','audit_pools.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt'];hashes={p:sha(ROOT/p) for p in sources};frozen=dict(status='FROZEN_BEFORE_EXACT_LOCAL_BLOCK_RECOVERY',source_C16_answered=False,anchors=anchors,point_sha256=sha(a.point),candidate_sha256=sha(Path(str(a.prefix)+'.npz')),input_report_sha256=sha(Path(str(a.prefix)+'.json')),source_hashes=hashes,face_rule='Fix zero/tight y asv1 except explicitlyreleased zero variables, chosenfromexactlocalconsistency. Allfinalrows/bounds mustpass exactly.',released_zero_variables=a.release_zero,scope='Count-only auxiliary extension; no physicalrank orfullframe claim. Every recovered rational variable mustpassfull equalityandbound replay.')
 fp=a.output.with_name(a.output.name.removesuffix('.json.gz').removesuffix('.json')+'.frozen.json');write(fp,frozen)
 for j,indices in enumerate(byZ):
  free=[];tight=[]
  for v in indices:
   m=variables[v][1]
   if numeric[v]==0 and v not in a.release_zero:expressions[v]={}
   elif numeric[v]>=numeric[m]:expressions[v]={m:Q(1)};tight.append(v)
   else:free.append(v)
  n=len(free);matrix=[]
  for rowid in range(5):
   def coeff(m):return 1 if rowid==0 else int(m>>(rowid-1)&1)
   right=[-Q(rows[11+j if rowid==0 else 1451+1440*(rowid-1)+j].get(i,0)) for i in range(16)]
   for v in tight:right[variables[v][1]]-=coeff(variables[v][1])
   wanted=tar[11+j] if rowid==0 else tar[1451+1440*(rowid-1)+j]
   matrix.append([Q(coeff(variables[v][1])) for v in free]+right+[wanted])
  pivots=[];r=0
  for col in range(n):
   candidate=next((k for k in range(r,5) if matrix[k][col]),None)
   if candidate is None:continue
   matrix[r],matrix[candidate]=matrix[candidate],matrix[r];pivot=matrix[r][col];matrix[r]=[v/pivot for v in matrix[r]]
   for k in range(5):
    if k!=r and matrix[k][col]:
     multiple=matrix[k][col];matrix[k]=[v-multiple*w for v,w in zip(matrix[k],matrix[r])]
   pivots.append(col);r+=1
   if r==5:break
  nonpivot=[q for q in range(n) if q not in pivots]
  for col in nonpivot:
   v=free[col];p=len(params);params.append(v);approx.append(float(numeric[v]));expressions[v]={p:Q(1)}
  for rowid,col in enumerate(pivots):
   v=free[col];expression={i:x for i,x in enumerate(matrix[rowid][n:n+16]) if x};constants[v]=matrix[rowid][-1]
   for q in nonpivot:add(expression,expressions[free[q]],-matrix[rowid][q])
   expressions[v]=expression
  for rowid in range(r,5):
   assert not any(matrix[rowid][:n]);consistency.append(({i:v for i,v in enumerate(matrix[rowid][n:n+16]) if v},-matrix[rowid][-1],f'Z{j}:consistency{rowid}'))
  local_stats.append(dict(Z=j,positive_nontight_y=n,local_rank=r,free_y=n-r,consistency_rows=5-r))
 assert all(v is not None for v in expressions)
 for i in range(16):
  if numeric[i]==0:consistency.append(({i:Q(1)},Q(0),f'lambda{i}=0'))
 for rowid in list(range(11))+list(range(7211,len(rows))):
  expression={};constant=Q(0)
  for v,c in rows[rowid].items():add(expression,expressions[v],Q(c));constant+=c*constants[v]
  consistency.append((expression,rhs[rowid]-constant,f'globalrow{rowid}'))
 inconsistent=[dict(row=name,rhs=str(b)) for row,b,name in consistency if not row and b]
 reduced=[(row,b,name) for row,b,name in consistency if row];integer=[];target_rhs=[]
 for row,b,name in reduced:
  denominator=lcm(*(v.denominator for v in row.values()));integer.append([int(row.get(j,Q(0))*denominator) for j in range(len(params))]);target_rhs.append(b*denominator)
 result={**frozen,'frozen_sha256':sha(fp),'local_blocks':1440,'parameters':len(params),'free_y_parameters':len(params)-16,'consistency_rows':len(consistency),'nonzero_reduced_rows':len(reduced),'immediate_inconsistent_rows':inconsistent,'local_stats':local_stats,'parameter_original_variables':params,'status':'RECOVERY_NOT_COMPLETE'}
 print('REDUCED',len(params),'parameters',len(reduced),'rows','inconsistent',len(inconsistent),flush=True)
 recovered=None
 if inconsistent:result['status']='TARGET_OUTSIDE_FROZEN_ACTIVE_FACE_LOCAL_CONSISTENCY'
 else:
  A=np.asarray(integer,dtype=np.int64);rank=int(fmpz_mat(integer).rank());print('RANK',rank,flush=True);_,_,ro=qr(A.T.astype(float),mode='economic',pivoting=True);pivot_rows=list(map(int,ro[:rank]));_,_,co=qr(A[pivot_rows].astype(float),mode='economic',pivoting=True);pivot_columns=list(map(int,co[:rank]));base=[Q(x) for x in approx];M=fmpq_mat(integer);v=fmpq_mat([[str(x)] for x in base]);b=fmpq_mat([[str(x)] for x in target_rhs]);res=b-M*v;B=fmpq_mat(A[np.ix_(pivot_rows,pivot_columns)].tolist());correction=B.solve(fmpq_mat([[res[i,0]] for i in pivot_rows]),algorithm='dixon')
  for i,k in enumerate(pivot_columns):v[k,0]+=correction[i,0]
  remaining=b-M*v;fail=[dict(row=reduced[i][2],residual=str(remaining[i,0])) for i in range(len(reduced)) if remaining[i,0]];result.update(reduced_rank=rank,pivot_rows=pivot_rows,pivot_columns=pivot_columns,reduced_remaining_nonzero_equations=fail)
  if fail:result['status']='TARGET_OUTSIDE_FROZEN_ACTIVE_FACE_GLOBAL_SPAN'
  else:
   pvalues=[Q(str(v[i,0])) for i in range(len(params))];recovered=[constants[i]+sum(c*pvalues[j] for j,c in expression.items()) for i,expression in enumerate(expressions)];eq=[sum(v*recovered[j] for j,v in row.items())-b for row,b in zip(rows,rhs)];ur=[sum(v*recovered[j] for j,v in row.items()) for row in upper];bad_bounds=[i for i,v in enumerate(recovered) if not 0<=v<=1];bad_upper=[i for i,v in enumerate(ur) if v>0];assert not any(eq);result.update(exact_nonzero_equalities=0,negative_or_above_one_variables=bad_bounds,positive_upper_rows=bad_upper,minimum_exact_variable=str(min(recovered)),maximum_exact_upper_violation=str(max([Q(0),*ur])),maximum_correction=str(max(abs(x-Q(float(y))) for x,y in zip(recovered,numeric))))
   if bad_bounds or bad_upper:result['status']='EXACT_EQUATIONS_RECOVERED_BUT_BOUNDS_FAIL'
   else:result['status']='EXACT_NONNEGATIVE_COUNT_EXTENSION_RECOVERED_REQUIRES_REPLAY';result['exact_variables']=list(map(str,recovered));result['variables']=[list(v) for v in variables]
 assert all(sha(ROOT/p)==v for p,v in hashes.items());result['elapsed_seconds']=time.monotonic()-start;write(a.output,result);print({k:v for k,v in result.items() if k in ('status','parameters','free_y_parameters','reduced_rank','exact_nonzero_equalities','minimum_exact_variable','maximum_exact_upper_violation','maximum_correction','elapsed_seconds')},flush=True)

if __name__=='__main__':main()
