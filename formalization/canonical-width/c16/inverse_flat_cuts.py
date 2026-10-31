#!/usr/bin/env python3
"""Discovery of strict flat-saturation cuts for full dual bases.

For U<=V, if span(Zpool intersect U-perp) has dimension <dim(V)-dim(U),
a full allowed dual frame selects at most dim(U)-1 X vectors in U.
Otherwise the ordinary matroid rank bound dim(U) applies. This is necessary,
not a sufficient inverse-membership test and not a partial-frame restriction.
"""
from pathlib import Path
from itertools import combinations
import argparse,gzip,json,time
ROOT=Path(__file__).resolve().parent
def basis(values):
 b={}
 for v in values:
  while v:
   k=v.bit_length()-1
   if k not in b:b[k]=v;break
   v^=b[k]
 return b
def remainder(v,b):
 for k in sorted(b,reverse=True):
  if v>>k&1:v^=b[k]
 return v
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--max-orbits',type=int,default=2);ap.add_argument('--seconds',type=float,default=300);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();pools=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in ['x','z']];records=[];seen=set();scanned=0
 source=json.loads((ROOT/'inversion-results/normal-form.json').read_text());groups=source['arrangement']['groups'];candidates=[]
 for r in range(1,a.max_orbits+1):candidates+=list(combinations(range(45),r))
 for r in range(1,6):candidates +=[tuple(sorted(o for g in gs for o in groups[g])) for gs in combinations(range(5),r)]
 for side in range(2):
  X,Z=pools[side],pools[1-side]
  for orbits in candidates:
   if time.monotonic()-start>a.seconds:break
   B=basis(X[16*o+h] for o in orbits for h in range(16));closure=[i for i,x in enumerate(X) if not remainder(x,B)];key=(side,tuple(closure));scanned+=1
   if key in seen:continue
   seen.add(key);ann=[j for j,z in enumerate(Z) if all(not (v&z).bit_count()%2 for v in B.values())];u=len(B);v=len(basis(Z[j] for j in ann));strict=u+v<128;bound=u-int(strict)
   assert bound>=0
   records.append({'sector':'X' if side==0 else 'Z','generator_orbits':list(orbits),'dimension':u,'closure_indices':closure,'opposite_annihilator_indices':ann,'opposite_annihilator_rank':v,'strict':strict,'full_frame_upper_bound':bound,'uniform_8_over_45_margin':45*bound-8*len(closure)})
 out={'status':'FINISHED_COHORT' if scanned==2*len(candidates) else 'TIME_LIMIT_COHORT','source_C16_answered':False,'max_generator_orbits':a.max_orbits,'candidate_flats_scanned':scanned,'distinct_flats':len(records),'strict_cuts':sum(r['strict'] for r in records),'uniform_point_passes_all_cuts':all(r['uniform_8_over_45_margin']>=0 for r in records),'records':records,'elapsed_seconds':time.monotonic()-start,'scope':'Necessary full-dual-basis cuts only. Strict cuts exclude saturation of the whole flat, not its individual vectors; no retained anchor is excluded.'};a.output.write_bytes(gzip.compress(json.dumps(out,separators=(',',':')).encode(),mtime=0));print({k:v for k,v in out.items() if k!='records'},flush=True)
if __name__=='__main__':main()
