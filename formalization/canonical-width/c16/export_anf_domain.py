#!/usr/bin/env python3
"""Export an exact conditional parity/compatibility necessity domain to ANF."""
from pathlib import Path
import argparse,gzip,hashlib,json,time
from algebraic_domain import make_domain

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--kind',required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();A,E,t,eq,anchor,R=make_domain(a.kind);lines=[]
 for k in range(len(eq)):
  terms=[f'x({i})' for i,(_,_,s) in enumerate(E) if s>>k&1]
  if t>>k&1:terms.append('1')
  if terms:lines.append(' + '.join(terms))
 conflicts=0
 for i,(x,z,s) in enumerate(E):
  for j,(xx,zz,ss) in enumerate(E[:i]):
   if x==xx or z==zz or A[x]>>zz&1 or A[xx]>>z&1:lines.append(f'x({j})*x({i})');conflicts+=1
 raw=('\n'.join(lines)+'\n').encode();a.output.write_bytes(gzip.compress(raw,mtime=0));a.output.with_suffix('.json').write_text(json.dumps({'kind':a.kind,'anchor':anchor,'free_edges':len(E),'parity_equations':len(eq),'quadratic_conflicts':conflicts,'raw_bytes':len(raw),'input_sha256':hashlib.sha256(raw).hexdigest(),'elapsed_seconds':time.monotonic()-start,'scope':'Exact parity necessity domain. No retained full case is completed by solving a removed-class conditional cover domain.'},indent=2)+'\n');print('ANF',a.kind,len(E),'conflicts',conflicts,'bytes',len(raw),flush=True)
if __name__=='__main__':main()
