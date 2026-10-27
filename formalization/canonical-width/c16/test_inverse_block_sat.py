#!/usr/bin/env python3
from itertools import product,combinations
import argparse,json
from pathlib import Path
from pysat.solvers import Solver
from inverse_block_sat import rectangular_encode,circuits
from dual_basis_cuts import rank_pivots

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();cases=0
 for m,n in [(1,2),(2,1),(2,2),(2,3),(3,2),(3,3)]:
  for bits in product([0,1],repeat=m*n):
   P=[bits[i*n:(i+1)*n] for i in range(m)]
   for target in range(1,min(m,n)+1):
    for coverage in [False,True]:
     cnf,_=rectangular_encode(P,target,coverage)
     with Solver(name='cadical195',bootstrap_with=cnf) as s:
      for choice in product([0,1],repeat=m+n):
       I=[i for i in range(m) if choice[i]];J=[j for j in range(n) if choice[m+j]];ok=len(I)==len(J)==target and all(sum(P[i][j] for j in J)==1 for i in I) and all(sum(P[i][j] for i in I)==1 for j in J)
       if coverage:ok=ok and all(any(P[i][j] for j in J) for i in range(m)) and all(any(P[i][j] for i in I) for j in range(n))
       assert s.solve(assumptions=[i+1 if b else -i-1 for i,b in enumerate(choice)])==ok;cases+=1
 V=list(range(1,8));actual=circuits(V,6);want=[]
 for k in range(3,7):
  for ids in combinations(range(len(V)),k):
   v=0
   for i in ids:v^=V[i]
   if v==0 and len(rank_pivots([V[i] for i in ids],3))==k-1:want.append(ids)
 assert actual==sorted(want)
 r={'status':'PASS','literal_rectangular_assignment_cases':cases,'complete_small_circuit_catalogue':len(actual)};a.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r))
if __name__=='__main__':main()
