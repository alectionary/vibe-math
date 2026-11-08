#!/usr/bin/env python3
"""Exact owner-moment consequences of source negative clauses.

For K=sum_{j in J} y_j and m=|J|, K<=m-1. Multiplication by y_a
and by (1-y_a) gives degree-two inequalities for every source event a.
Cyclic/sector averaging maps them to p[45], S[9,45,45], T[9,45,45].
No positivity margin, higher moment, or fixed local shape distribution is used.
"""
from pathlib import Path
from collections import Counter,defaultdict
from itertools import combinations
from fractions import Fraction
import argparse,gzip,hashlib,json,time
import numpy as np
from scipy.optimize import linprog
from scipy.linalg import qr
from scipy.sparse import coo_matrix
from flint import fmpq,fmpq_mat
from certify_profile_moment_point import layout
from verify_algebraic_model import physical
from verify_sparse_quotient import SparseQuotientConsumer
ROOT=Path(__file__).resolve().parent
WIDTH=45+18*2025

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def coord(side,h,i,j):
 h%=16
 if h>8:h=16-h;i,j=j,i
 if h in (0,8) and i>j:i,j=j,i
 return 45+(0 if side=='S' else 9*2025)+h*2025+45*i+j

def key(c):
 if c<45:return ('p',c)
 q,c=divmod(c-45,9*2025);h,c=divmod(c,2025);i,j=divmod(c,45)
 return ('S' if q==0 else 'T',h,i,j)

def compile_rows(cuts):
 rows=[]
 for number,cut in enumerate(cuts):
  J=cut['indices'];m=len(J);assert m==len(set(J)) and m>=2
  base=Counter(j//16 for j in J)
  rows.append(dict(cut=number,family='first',terms=sorted(base.items()),rhs=m-1))
  for side in ('S','T'):
   for a in range(720):
    product=Counter()
    for j in J:
     product[a//16 if side=='S' and a==j else coord(side,(j-a)%16,a//16,j//16)]+=1
    selected=product.copy();selected[a//16]-=m-1
    absent=base.copy();absent.subtract(product);absent[a//16]+=m-1
    for family,terms,rhs in [('selected',selected,0),('absent',absent,m-1)]:
     rows.append(dict(cut=number,family=('internal_selected' if family=='selected' and side=='S' and a in J else family),anchor_relation=side,anchor=a,
                      terms=sorted((int(c),int(v)) for c,v in terms.items() if v),rhs=rhs))
 return rows

def matrix(bank):
 """Return M,b,metadata for M@owner_vector<=b; translation only."""
 if isinstance(bank,(str,Path)):bank=json.loads(Path(bank).read_text())
 rows=compile_rows(bank['cuts']);ii=[];jj=[];vv=[]
 for i,row in enumerate(rows):
  for j,v in row['terms']:ii.append(i);jj.append(j);vv.append(v)
 return coo_matrix((vv,(ii,jj)),shape=(len(rows),WIDTH),dtype='int64').tocsr(),np.array([r['rhs'] for r in rows],dtype='int64'),rows

def point_loader(path):
 hulls=json.loads(gzip.decompress((ROOT/'algebraic-results/hulls-16-rank.json.gz').read_bytes()));names,index,m=layout(hulls)
 data=json.loads(gzip.decompress(path.read_bytes()));values=list(map(Fraction,data['values']))
 def value(c):
  k=key(c)
  return values[index[k]] if k[0]=='p' else values[m(*k)]
 return value

def local_marginal(cut,value):
 J=cut['indices'];m=len(J);pairs=list(combinations(range(m),2));masks=list(range((1<<m)-1))
 A=np.array([[1,*[(mask>>i)&1 for i in range(m)],*[(mask>>i&1)*(mask>>j&1) for i,j in pairs]] for mask in masks],dtype=np.int64).T
 target=[Fraction(1),*[value(j//16) for j in J],*[value(coord('S',(J[j]-J[i])%16,J[i]//16,J[j]//16)) for i,j in pairs]]
 lp=linprog(np.arange(len(masks),dtype=float)/len(masks),A_eq=A,b_eq=np.array(list(map(float,target))),bounds=(0,None),method='highs')
 if not lp.success:return dict(status='NUMERICAL_MARGINAL_FAILURE',message=lp.message)
 columns=np.flatnonzero(lp.x>1e-9);B=A[:,columns];_,R,permutation=qr(B.T.astype(float),pivoting=True,mode='economic');rank=int(np.sum(np.abs(np.diag(R))>1e-9));assert rank==len(columns)
 rr=permutation[:rank];weights=fmpq_mat(B[rr,:].tolist()).solve(fmpq_mat([[fmpq(str(target[i]))] for i in rr]));weights=[Fraction(str(weights[i,0])) for i in range(rank)]
 assert all(w>=0 for w in weights)
 assert all(sum(int(A[i,j])*w for j,w in zip(columns,weights))==target[i] for i in range(len(target)))
 return dict(status='EXACT_LOCAL_DEGREE2_DISTRIBUTION',indices=J,forbidden_mask=(1<<m)-1,
             support=[dict(mask=int(j),weight=str(w)) for j,w in zip(columns,weights)],target=list(map(str,target)),
             feature_order='1; singles in indices order; pairs in itertools.combinations order',
             conclusion='Every degree2 inequality supported only on these J events and valid for all Boolean assignments except all-selected holds at this target.')

def mapping_controls(rows):
 rng=np.random.default_rng(20261030);assignments=[set(np.flatnonzero(rng.random(1440)<p)) for p in (0.1,0.5,0.9)]
 sample=[r for r in rows if r['family']=='first']
 sample += [r for r in rows if r.get('anchor') in (0,17,178,429,598,719) and r['family']!='first']
 checks=0
 for chosen in assignments:
  memo={}
  def selected(side,i):return int(720*side+i in chosen)
  def moment(c):
   if c in memo:return memo[c]
   k=key(c)
   if k[0]=='p':n=sum(selected(s,16*k[1]+h) for s in (0,1) for h in range(16))
   else:
    relation,h,i,j=k;n=sum(selected(s,16*i+t)*selected(s^(relation=='T'),16*j+(t+h)%16) for s in (0,1) for t in range(16))
   memo[c]=Fraction(n,32);return memo[c]
  for row in sample:
   J=CUTS[row['cut']]['indices'];m=len(J);literal=0
   for s in (0,1):
    for h in range(16):
     count=sum(selected(s,16*(j//16)+(j%16+h)%16) for j in J)
     if row['family']=='first':term=count
     else:
      a=row['anchor'];anchor=selected(s^(row['anchor_relation']=='T'),16*(a//16)+(a%16+h)%16)
      term=anchor*(count-m+1) if row['family'] in ('selected','internal_selected') else count-anchor*count+(m-1)*anchor
     literal+=term
   assert Fraction(literal,32)==sum(c*moment(j) for j,c in row['terms']);checks+=1
 # Literal Boolean controls cover both core sizes and internal/external anchors.
 boolean=0
 for m in (8,9):
  for mask in range((1<<m)-1):
   count=mask.bit_count();assert count<=m-1
   for anchor in (0,1):
    assert anchor*(count-m+1)<=0
    assert count-anchor*count+(m-1)*anchor<=m-1;boolean+=2
 return dict(literal32_action_mapping_checks=checks,literal_boolean_row_checks=boolean)

def main():
 global CUTS
 ap=argparse.ArgumentParser();ap.add_argument('--cuts',type=Path,default=ROOT/'coupling-results/word-subspace-minimized-new-cuts.json');ap.add_argument('--point',type=Path,default=ROOT/'coupling-results/witness2-rational.json.gz');ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();assert not args.output.exists();start=time.monotonic()
 bank=json.loads(args.cuts.read_text());CUTS=bank['cuts'];X,Z,_=physical();consumer=SparseQuotientConsumer(X,Z)
 for cut in CUTS:consumer.check(cut['certificate'])
 rows=compile_rows(CUTS);value=point_loader(args.point);summaries=defaultdict(list);violations=[]
 for number,row in enumerate(rows):
  slack=Fraction(row['rhs'])-sum(c*value(j) for j,c in row['terms']);summaries[row['family']].append(slack)
  if slack<0:violations.append(dict(row=number,slack=str(slack)))
 from canonical_forbidden_moment_matrix import matrix as old_matrix
 _,old_rows=old_matrix([args.cuts]);internal=[tuple(map(tuple,r['terms'])) for r in rows if r['family']=='internal_selected'];assert set(internal)==set(old_rows)
 controls=mapping_controls(rows);marginals=[local_marginal(c,value) for c in CUTS]
 paths=[args.cuts,args.point,ROOT/'algebraic-results/hulls-16-rank.json.gz',ROOT/'physical-pool-source.json',ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt',ROOT/'verify_algebraic_model.py',ROOT/'verify_sparse_quotient.py',ROOT/'certify_profile_moment_point.py',ROOT/'canonical_forbidden_moment_matrix.py',Path(__file__)]
 out=dict(status='SEPARATED' if violations else 'PASS_ALL_DECLARED_ROWS',source_C16_answered=False,source_hashes={str(p.resolve().relative_to(ROOT)):sha(p) for p in paths},cuts=CUTS,owner_width=WIDTH,rows=rows,
          family_statistics={family:dict(rows=len(v),minimum_exact_slack=str(min(v)),maximum_exact_slack=str(max(v)),violated=sum(x<0 for x in v)) for family,v in summaries.items()},violations=violations,
          existing_compiler_internal_rows_identical=len(old_rows),mapping_controls=controls,local_marginals=marginals,elapsed_seconds=time.monotonic()-start,
          proof='K=sum_J y_j<=m-1. Multiply by y_a and1-y_a, then average over16 cyclic phases and2 sector choices. Same-event squares reduce to y_a. No higher moments occur.',
          scope='Source-valid first/second-moment rows and exact point screening. Local marginal certificates concern only the listed J events. They do not prove a common source distribution, source extendibility, full-anchor exclusion, or cover improvement.')
 args.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ['rows','source_hashes','cuts','local_marginals']});print('LOCAL',[(r['status'],len(r.get('support',[]))) for r in marginals])
if __name__=='__main__':main()
