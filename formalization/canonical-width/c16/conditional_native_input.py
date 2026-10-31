#!/usr/bin/env python3
"""Native-CNF-XOR export of the exact same conditional parity domain."""
from pathlib import Path
import argparse,gzip,hashlib,json,time
from algebraic_domain import make_domain
from signature_cover import encode
from exchange_anchored_cover import signature_amo
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--kind',choices=['hard','control'],required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--compressed',action='store_true');ap.add_argument('--one-per-signature',action='store_true');a=ap.parse_args();start=time.monotonic();A,E,t,eq,anchor,R=make_domain(a.kind);clauses,n,_,events=encode(A,[0],[(*e,0) for e in E],with_xor=False,compress_signatures=a.compressed)
 if a.one_per_signature:n=signature_amo(clauses,n,[(*e,0) for e in E])
 lines=[' '.join(map(str,c))+' 0' for c in clauses]
 for k in range(len(eq)):
  literals=[v for v,s in events if s>>k&1];assert literals
  if not t>>k&1:literals[0]=-literals[0]
  lines.append('x'+' '.join(map(str,literals))+' 0')
 raw=(f'p cnf {n} {len(lines)}\n'+'\n'.join(lines)+'\n').encode();a.output.write_bytes(gzip.compress(raw,mtime=0));d={'status':'EXPORTED_CONDITIONAL_NATIVE_PARITY','source_C16_answered':False,'kind':a.kind,'anchor':anchor,'trial_removed':sorted(R),'free_edges':len(E),'variables':n,'CNF_clauses':len(clauses),'native_XORs':len(eq),'signature_compression':a.compressed,'one_per_signature':a.one_per_signature,'free_target_signature':t,'input_sha256':hashlib.sha256(raw).hexdigest(),'input_file':a.output.name,'elapsed_seconds':time.monotonic()-start};a.output.with_suffix('.json').write_text(json.dumps(d,indent=2)+'\n');print({k:v for k,v in d.items() if k!='trial_removed'})
if __name__=='__main__':main()
