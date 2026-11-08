#!/usr/bin/env python3
from itertools import combinations,product
from pathlib import Path
import argparse,json
from pysat.solvers import Solver
from dual_basis_cuts import CoverCNF,dual_basis,nullspace

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();count=0;enc=0
 for n in [2,3]:
  allv=list(range(1,1<<n))
  for B in combinations(allv,n):
   dual=dual_basis(B,n)
   for zmask in range(1<<len(allv)):
    Z={z for i,z in enumerate(allv) if zmask>>i&1};condition=all(sum((x&w).bit_count()%2 for x in B)>=(1 if w in Z else 2) for w in allv);expected=dual is not None and set(dual)<=Z;assert condition==expected;count+=1
   if dual is None:assert nullspace(B,n)
 for m in range(0,8):
  for k in [1,2]:
   c=CoverCNF(m);c.at_least(list(range(1,m+1)),k)
   with Solver(name='cadical195',bootstrap_with=c.clauses) as s:
    for bits in product([False,True],repeat=m):
     assert s.solve(assumptions=[i+1 if b else -(i+1) for i,b in enumerate(bits)])==(sum(bits)>=k);enc+=1
 r={'status':'PASS','literal_inverse_membership_cases':count,'threshold_encoder_cases':enc};a.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r))
if __name__=='__main__':main()
