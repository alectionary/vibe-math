#!/usr/bin/env python3
"""Physical-pool replay of the inverse-flat dimension hypotheses."""
from pathlib import Path
import argparse,gzip,hashlib,json,time
from verify_algebraic_model import physical
def eliminate(values):
 rows={}
 for v in values:
  while v:
   p=v&-v
   if p not in rows:rows[p]=v;break
   v^=rows[p]
 return rows
def inside(v,rows):
 while v:
  p=v&-v
  if p not in rows:return False
  v^=rows[p]
 return True
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();X,Z,A=physical();raw=a.certificate.read_bytes();d=json.loads(gzip.decompress(raw));strict=0;minimum=10**9
 for r in d['records']:
  own,other=(X,Z) if r['sector']=='X' else (Z,X);B=eliminate(own[16*o+h] for o in r['generator_orbits'] for h in range(16));ids=[i for i,v in enumerate(own) if inside(v,B)];ann=[j for j,w in enumerate(other) if all(not (b&w).bit_count()%2 for b in B.values())];v=len(eliminate(other[j] for j in ann));u=len(B)
  assert ids==r['closure_indices'] and ann==r['opposite_annihilator_indices'];assert u==r['dimension'] and v==r['opposite_annihilator_rank'];s=u+v<128;bound=u-int(s);assert s==r['strict'] and bound==r['full_frame_upper_bound'];margin=45*bound-8*len(ids);assert margin==r['uniform_8_over_45_margin'];minimum=min(minimum,margin);strict+=s
 assert strict==d['strict_cuts'] and len(d['records'])==d['distinct_flats']
 out={'status':'PASS','source_C16_answered':False,'certificate_sha256':hashlib.sha256(raw).hexdigest(),'physical_pairings_rebuilt':518400,'flats_checked':len(d['records']),'strict_saturation_cuts_checked':strict,'uniform_point_passes':minimum>=0,'uniform_cleared_denominator_minimum_margin':minimum,'elapsed_seconds':time.monotonic()-start,'scope':'Finite hypotheses of the written flat-saturation lemma. Bounds apply to full allowed dual bases; no full case completed and no global obstruction from these cuts alone if the uniform point passes.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print(out)
if __name__=='__main__':main()
