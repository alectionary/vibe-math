#!/usr/bin/env python3
"""Discovery-side source binding for bounded polynomial-calculus models."""
from pathlib import Path
import argparse,gzip,hashlib,json,time
from signature_cover import logical_data,canonical
from adaptive_matrix_identities import parity
ROOT=Path(__file__).resolve().parent

def make_domain(kind):
 A,_,_=logical_data();X,Z=[[int(s,16) for s in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in ['x','z']];R=None
 if kind in ['control','hard']:
  source=ROOT/f'theory-loop-results/affine-{kind}.json.gz';d=json.loads(gzip.decompress(source.read_bytes()));R=set(map(tuple,d['removed_classes']));anchor=d['anchor'];eq=[(X[608+t],Z[608+t]) for t in range(16)]
 else:
  anchor=[48,48];eq=[(X[608+t],Z[608+t]) for t in range(16)]
  if kind.startswith('block'):
   r=int(kind[5:]);b=json.loads((ROOT/f'theory-loop-results/block-{r}.json').read_text());prior=json.loads((ROOT/'residual-identity-results/adaptive-anchor-compact.json').read_text());eq=[(int(e['u_hex'],16),int(e['v_hex'],16)) for e in prior['equations']]+[(int(u,16),int(v,16)) for u in b['auxiliary_U_hex'] for v in b['auxiliary_V_hex']]
  elif kind=='full':eq=[(1<<i,1<<j) for i in range(128) for j in range(128)]
  else:assert kind=='anchor16'
 a,b=anchor;target=sum((parity(u,v)^parity(X[a],v)*parity(u,Z[b]))<<k for k,(u,v) in enumerate(eq));sx=[sum(parity(x,v)<<k for k,(u,v) in enumerate(eq)) for x in X];sz=[sum(parity(u,z)<<k for k,(u,v) in enumerate(eq)) for z in Z]
 E=[(i,j,sx[i]&sz[j]) for i in range(720) if i!=a and not A[i]>>b&1 for j in range(720) if j!=b and not A[a]>>j&1 and A[i]>>j&1 and sx[i]&sz[j] and (R is None or canonical(i,j) in R)]
 return A,E,target,eq,anchor,R

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--kind',required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();A,E,target,eq,anchor,R=make_domain(a.kind);raw=(f'{len(E)} {len(eq)}\n{target:x}\n'+'\n'.join(f'{row:x}' for row in A)+'\n'+'\n'.join(f'{i} {j} {s:x}' for i,j,s in E)+'\n').encode();a.output.write_bytes(raw)
 d={'kind':a.kind,'anchor':anchor,'free_edges':len(E),'equations':len(eq),'target_hex':hex(target),'equation_uv_hex':[[hex(u),hex(v)] for u,v in eq],'removed_classes':sorted(R) if R is not None else None,'input_file':a.output.name,'input_sha256':hashlib.sha256(raw).hexdigest(),'elapsed_seconds':time.monotonic()-start,'scope':'Original source compatible free edges with nonzero equation signature. R is an additional conditional-domain restriction only for control/hard. Full frames imply a partial solution after deleting zero signatures.'};a.output.with_suffix('.json').write_text(json.dumps(d,indent=2)+'\n');print('DOMAIN',a.kind,len(E),'edges',len(eq),'equations',flush=True)
if __name__=='__main__':main()
