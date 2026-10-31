"""Independent sparse rows for exact recovery of the two-sided count hull."""
from fractions import Fraction
import numpy as np
from scipy.sparse import coo_matrix
from verify_two_sided_anchor_count import domain,columns,feature,N

def target(owner,anchors):
 return [Fraction(1) if j is None else owner[j] for j in columns(anchors[:2],anchors[2:])]

def reconstruct(X,Z,anchors):
 variables=[('lambda',m,-1) for m in range(16)];rows=[{} for _ in range(N)];upper=[];domains=[]
 for m in range(16):
  d=domain(X,Z,anchors[:2],anchors[2:],m);domains.append(d)
  if d is None:continue
  fixed,buckets=d
  for r,v in enumerate(feature(m,fixed)):
   if v:rows[r][m]=v
  for take,A in buckets:
   row={m:-take};rows.append(row)
   for j in A:
    v=len(variables);variables.append(('y',m,j));row[v]=1;rows[11+j][v]=1
    for i in range(4):
     if m>>i&1:rows[1451+1440*i+j][v]=1
    upper.append({v:1,m:-1})
 def sparse(R):
  triples=[(i,j,v) for i,row in enumerate(R) for j,v in row.items()];return coo_matrix(([v for i,j,v in triples],([i for i,j,v in triples],[j for i,j,v in triples])),shape=(len(R),len(variables)),dtype=np.int64).tocsr()
 return variables,rows,upper,sparse(rows),sparse(upper),domains
