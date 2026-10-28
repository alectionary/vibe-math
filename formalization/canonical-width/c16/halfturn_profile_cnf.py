#!/usr/bin/env python3
"""Add checked one-orbit phase nogoods to the previous half-turn model."""
from pathlib import Path
import argparse,gzip,hashlib,json,time
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--base',type=Path,required=True);ap.add_argument('--profiles',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();base=a.base.read_bytes();rows=base.decode().splitlines();header=rows.pop(0).split();assert header[:2]==['p','cnf'];data=a.profiles.read_bytes();raw=gzip.decompress(data) if a.profiles.suffix=='.gz' else data;source=json.loads(raw);clauses=[];records=[]
 for r in source['records']:
  assert r['complete'];witnesses={}
  for cert in r['minimal_bad_certificates']:
   m=cert['mask'];project=(m&255)|(m>>8);witnesses.setdefault(project,m)
  minimal=[m for m in sorted(witnesses,key=lambda m:(m.bit_count(),m)) if not any(n!=m and n&m==n for n in witnesses)]
  for m in sorted(minimal):
   ids=[8*r['orbit']+h+1 for h in range(8) if m>>h&1]
   for offset in [0,360]:clauses.append(' '.join(str(-i-offset) for i in ids)+' 0')
   records.append({'orbit':r['orbit'],'quotient_mask':m,'physical_source_mask':witnesses[m]})
 n=int(header[2]);rawcnf=(f'p cnf {n} {int(header[3])+len(clauses)}\n'+'\n'.join(rows+clauses)+'\n').encode();a.output.write_bytes(rawcnf);out={'status':'HALFTURN_PROFILE_CNF_CANDIDATE','source_C16_answered':False,'restricted_to_halfturn':True,'base_sha256':hashlib.sha256(base).hexdigest(),'profiles_uncompressed_sha256':hashlib.sha256(raw).hexdigest(),'variables':n,'base_clauses':int(header[3]),'added_clauses':len(clauses),'input_sha256':hashlib.sha256(rawcnf).hexdigest(),'records':records,'elapsed_seconds':time.monotonic()-start};a.output.with_suffix('.json').write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='records'})
if __name__=='__main__':main()
