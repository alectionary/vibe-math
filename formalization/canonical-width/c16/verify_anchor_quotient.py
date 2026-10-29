#!/usr/bin/env python3
"""Independent physical consumer of the fixed-anchor quotient coordinates."""
from pathlib import Path
import argparse,hashlib,json
from verify_algebraic_model import physical
def quotient(metadata):
 d=json.loads(metadata.read_text());X,Z,A=physical();a,b=d['anchor'];assert A[a]>>b&1;ids=d['basis_X_pool_indices'];assert len(ids)==len(set(ids))==128 and ids[0]==a;assert all(not A[i]>>b&1 for i in ids[1:]);B=[X[i] for i in ids];piv={}
 if d.get('fixed_X_only',False):
  assert all((A[i]>>j&1)==(A[j]>>i&1)==(A[16*(i//16)+(i+1)%16]>>(16*(j//16)+(j+1)%16)&1) for i in range(720) for j in range(720))
 for k,v in enumerate(B):
  tag=1<<k
  while v:
   low=v&-v
   if low not in piv:piv[low]=(v,tag);break
   row,t=piv[low];v^=row;tag^=t
  assert v
 assert len(piv)==128
 def coords(v):
  tag=0
  while v:
   row,t=piv[v&-v];v^=row;tag^=t
  return tag
 XX=[coords(x)>>1 if i!=a and (d.get('fixed_X_only',False) or not A[i]>>b&1) else 0 for i,x in enumerate(X)];ZZ=[sum(((x&z).bit_count()%2)<<k for k,x in enumerate(B))>>1 if j!=b and not A[a]>>j&1 else 0 for j,z in enumerate(Z)]
 for side,values in [('x',XX),('z',ZZ)]:
  raw=('\n'.join(f'{v:032x}' for v in values)+'\n').encode();file=metadata.parent/d['files'][side]['file'];assert file.read_bytes()==raw and hashlib.sha256(raw).hexdigest()==d['files'][side]['sha256'];assert sum(bool(v) for v in values)==d['files'][side]['nonzero_vectors']
 AA=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(ZZ)) for x in XX];assert all((AA[i]>>j&1)==(bool(XX[i]) and bool(ZZ[j]) and bool(A[i]>>j&1)) for i in range(720) for j in range(720));return XX,ZZ,AA,d
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--metadata',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();X,Z,A,d=quotient(a.metadata);out={'status':'PASS','source_C16_answered':False,'anchor':d['anchor'],'fixed_X_only':bool(d.get('fixed_X_only',False)),'Z_coordinate_gauge_is_selected':not d.get('fixed_X_only',False),'effective_dimension':127,'physical_pairings_rebuilt':518400,'all518400_quotient_pairings_checked':True,'free_X':sum(bool(x) for x in X),'free_Z':sum(bool(z) for z in Z),'metadata_sha256':hashlib.sha256(a.metadata.read_bytes()).hexdigest(),'scope':('Necessary X-only quotient: project every other original X modulo the fixed X and retain Z annihilating it. The displayed Z index is a coordinate gauge, not a selected partner.' if d.get('fixed_X_only',False) else 'Exact original free pools after a fixed source pair, in127-dimensional dual coordinates. No source vector outside the original compatible pools is admitted.')};a.output.write_text(json.dumps(out,indent=2)+'\n');print(out)
if __name__=='__main__':main()
