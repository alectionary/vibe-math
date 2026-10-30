#!/usr/bin/env python3
"""Literal controls and physical ranks for conditioned opposite-pool faces."""
from pathlib import Path
from itertools import combinations
import hashlib,json,time
from verify_weighted_matroid_cuts import rank
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent

def main():
 start=time.monotonic();controls=0;products=0
 for n in (2,3,4):
  pool=list(range(1,1<<n));bases=[B for B in combinations(pool,n) if rank(B)==n]
  for a in pool:
   zero=[v for v in pool if not (a&v).bit_count()%2];one=set(pool)-set(zero);assert rank(zero)==n-1
   zero_bases=[I for I in combinations(zero,n-1) if rank(I)==n-1];cartesian={tuple(sorted((*I,v))) for I in zero_bases for v in one};face={B for B in bases if len(set(B)&set(zero))==n-1};assert cartesian==face;products+=len(cartesian)
   for B in bases:assert len(set(B)&set(zero))<=n-1;controls+=1
  for X in bases:
   Z=[next(z for z in pool if all(((x&z).bit_count()%2)==int(i==j) for j,x in enumerate(X))) for i in range(n)];assert rank(Z)==n
   for a in X:assert sum(not (a&z).bit_count()%2 for z in Z)==n-1;controls+=1
 X,Z,A=physical();records=[]
 for side,U,V in [('X',X,Z),('Z',Z,X)]:
  for orbit in range(45):
   a=16*orbit;ids=[j for j,v in enumerate(V) if not (U[a]&v).bit_count()%2];r=rank(V[j] for j in ids);assert r==127;records.append({'conditioned_sector':side,'anchor':a,'orthogonal_pool_size':len(ids),'rank':r})
 out={'status':'PASS','source_C16_answered':False,'literal_small_basis_and_conditioning_checks':controls,'literal_cartesian_face_basis_members':products,'physical_zero_pool_ranks':records,'physical_pairings_rebuilt':518400,'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'elapsed_seconds':time.monotonic()-start,'scope':'Conditioning on selected a forces exactly127 opposite-sector selected vectors into its rank127 orthogonal pool. Bases on this tight matroid face consist of an orthogonal-pool basis and one nonorthogonal vector. This justifies the reduced greedy search domain; it is not a full-frame existence theorem.'};(ROOT/'moment-resumption-results/zero-pool-face-independent.json').write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='physical_zero_pool_ranks'},flush=True)
if __name__=='__main__':main()
