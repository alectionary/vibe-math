#!/usr/bin/env python3
"""Literal small-matroid controls of the exploratory projection's rank oracle."""
from pathlib import Path
from itertools import combinations,product
import json,time
import numpy as np
from weighted_matroid_separator import greedy,prefix_cut,separate
from verify_weighted_matroid_cuts import rank

def main():
 start=time.monotonic();vectors=list(range(1,8));bases=[B for B in combinations(range(7),3) if rank(vectors[i] for i in B)==3];checks=0;prefixes=0
 for weights in product((-1,0,1),repeat=7):
  for mandatory in [None,*range(7)]:
   allowed=[B for B in bases if mandatory is None or mandatory in B];g=greedy(vectors,weights,mandatory);assert len(g)==3 and rank(vectors[i] for i in g)==3 and (mandatory is None or mandatory in g);assert sum(weights[i] for i in g)==max(sum(weights[i] for i in B) for B in allowed);checks+=1
   order=sorted(range(7),key=lambda i:(-weights[i],i));J=set()
   for i in order:
    J.add(i);bound=rank(vectors[j] for j in J|({mandatory} if mandatory is not None else set()))-int(mandatory is not None and mandatory not in J);assert bound==max(len(J&set(B)) for B in allowed);prefixes+=1
 # Independent sets, including nonbases, satisfy every conditioned rank bound.
 independent=[I for k in range(4) for I in combinations(range(7),k) if rank(vectors[i] for i in I)==k];partial=0
 for bits in range(1<<7):
  J={i for i in range(7) if bits>>i&1}
  for a in range(7):
   b=rank(vectors[i] for i in J|{a})-int(a not in J)
   for I in independent:
    if a in I:assert len(J&set(I))<=b;partial+=1
 # This mass-three point violates the rank-two line {1,2,3}; separator must find it.
 x=np.array([1.,1.,1.,0.,0.,0.,0.]);cut,diag=separate(vectors,x,iterations=100);assert cut and sum(x[i] for i in cut['indices'])>cut['bound'] and rank(vectors[i] for i in cut['indices'])==cut['bound']
 # Exact convex average of all bases cannot violate a valid rank subset.
 x=sum((np.array([int(i in B) for i in range(7)],dtype=float) for B in bases))/len(bases);cut,diag=separate(vectors,x,iterations=100);assert cut is None
 out={'status':'PASS','greedy_weight_controls':checks,'literal_prefix_support_bounds':prefixes,'independent_partial_controls':partial,'positive_rank_violation_found':True,'convex_basis_average_preserved':True,'elapsed_seconds':time.monotonic()-start};Path('moment-resumption-results/matroid-small-controls.json').write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':main()
