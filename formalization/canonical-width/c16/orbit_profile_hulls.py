#!/usr/bin/env python3
"""Source-valid local autocorrelation hulls from checked phase nogoods.

Convex combinations represent translation-averaged actual one-orbit patterns.
This supplies global moment constraints, not an independence assumption between
different orbits. Both the basic count/owner and stronger rank cohorts are saved.
"""
from pathlib import Path
import argparse,gzip,hashlib,json,time
ROOT=Path(__file__).resolve().parent
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--profiles',type=Path,required=True);ap.add_argument('--period',type=int,choices=[8,16],required=True);ap.add_argument('--mode',choices=['basic','rank'],required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();raw=a.profiles.read_bytes();d=json.loads(gzip.decompress(raw) if a.profiles.suffix=='.gz' else raw);P=a.period;X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in ['x','z']];records=[]
 for r in d['records']:
  assert r['complete'];orbit=r['orbit'];bad=bytearray(65536)
  if a.mode=='rank':
   for c in r['minimal_bad_certificates']:bad[c['mask']]=1
   for mask in range(65536):
    if bad[mask]:continue
    v=mask
    while v:
     bit=v&-v;v-=bit
     if bad[mask^bit]:bad[mask]=1;break
  else:
   freq=[0]*65536
   for z in Z:freq[sum(((X[16*orbit+h]&z).bit_count()%2)<<h for h in range(16))]+=1
   for h in range(16):
    bit=1<<h
    for low in range(0,65536,2*bit):
     for mask in range(low+bit,low+2*bit):freq[mask]+=freq[mask-bit]
   for mask in range(65536):
    inverse=65535^mask;zero=freq[inverse];valid=zero>=128-mask.bit_count();v=mask
    while valid and v:
     bit=v&-v;v-=bit
     if freq[inverse|bit]==zero:valid=False
    bad[mask]=not valid
  shapes={};allowed=0
  for mask in range(1<<P):
   physical=mask if P==16 else mask|(mask<<8)
   if bad[physical] or (orbit==12 and physical.bit_count()>11):continue
   allowed+=1;moments=(mask.bit_count(),)+tuple((mask&(((mask<<h)|(mask>>(P-h)))&((1<<P)-1))).bit_count() for h in range(1,P//2+1));shapes.setdefault(moments,mask)
  records.append({'orbit':orbit,'phase_patterns':allowed,'shapes':[{'moments':list(v),'example_mask':m} for v,m in sorted(shapes.items())]})
 out={'status':'LOCAL_HULL_CANDIDATE','source_C16_answered':False,'period':P,'mode':a.mode,'source_profiles_sha256':hashlib.sha256(raw).hexdigest(),'critical_physical_cap':11,'records':records,'shape_variables':sum(len(r['shapes']) for r in records),'phase_patterns':sum(r['phase_patterns'] for r in records),'elapsed_seconds':time.monotonic()-start,'scope':'One-orbit autocorrelation convex hulls, including prior critical-orbit cap11. Independent completeness replay required before a necessary global-model conclusion.'};a.output.write_bytes(gzip.compress(json.dumps(out,separators=(',',':')).encode(),mtime=0));print({k:v for k,v in out.items() if k!='records'},flush=True)
if __name__=='__main__':main()
