#!/usr/bin/env python3
"""Literal finite checks for the rank-minimal identity equivalence."""
from itertools import combinations
import argparse,json
from pathlib import Path

def outer(x,z,n):return sum(((x>>a&1)*(z>>b&1))<<(n*a+b) for a in range(n) for b in range(n))
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();cases=0;identities=0
 for n in [2,3]:
  atoms=[(x,z,outer(x,z,n)) for x in range(1,1<<n) for z in range(1,1<<n)];identity=sum(1<<(n*i+i) for i in range(n))
  for selected in combinations(atoms,n):
   total=0
   for x,z,v in selected:total^=v
   gram=all((x&z).bit_count()%2==(i==j) for i,(x,_,_) in enumerate(selected) for j,(_,z,_) in enumerate(selected));assert (total==identity)==gram;cases+=1;identities+=gram
  for selected in combinations(atoms,n-1):
   total=0
   for x,z,v in selected:total^=v
   assert total!=identity;cases+=1
 r={'status':'PASS','literal_decomposition_cases':cases,'rank_minimal_identities':identities,'scope':'all nonzero rank-one atoms in dimensions2 and3; no C16 conclusion'};args.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r))

if __name__=='__main__':main()
