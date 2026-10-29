#!/usr/bin/env python3
"""Literal exhaustive controls for the full-anchor owner-cardinality counter."""
from pathlib import Path
import argparse,json,time
from pysat.solvers import Solver
from full_anchor_model import at_least_network

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();cases=0
 for n in range(1,9):
  for bound in range(1,n+1):
   cnf,top=at_least_network(list(range(1,n+1)),bound,n)
   with Solver(name='cadical195',bootstrap_with=cnf) as s:
    for mask in range(1<<n):
     fixed=[i+1 if mask>>i&1 else -(i+1) for i in range(n)];ans=s.solve(assumptions=fixed);assert ans==(mask.bit_count()>=bound);cases+=1
     if ans:
      model=set(s.get_model());v=n
      for i in range(1,n+1):
       for k in range(1,min(i,bound)+1):v+=1;assert (v in model)==((mask&((1<<i)-1)).bit_count()>=k)
      assert v==top
 assert cases==3586
 out={'status':'PASS','source_C16_answered':False,'literal_input_controls':cases,'input_sizes':list(range(1,9)),'bounds':'all1..n','auxiliary_threshold_models_checked':True,'scope':'Exhaustive small controls for the saturated prefix threshold recurrence. The generic gate equivalence and prefix induction justify the127 threshold; these controls are not a source-frame search.','elapsed_seconds':time.monotonic()-start};a.output.write_text(json.dumps(out,indent=2)+'\n');print(out)
if __name__=='__main__':main()
