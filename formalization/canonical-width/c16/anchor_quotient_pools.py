#!/usr/bin/env python3
"""Exact dual coordinate change for a fixed original pairing anchor."""
from pathlib import Path
import argparse,hashlib,json
ROOT=Path(__file__).resolve().parent
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--anchor',nargs=2,type=int,default=[48,48]);ap.add_argument('--x-only',action='store_true');ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in ['x','z']];ax,az=a.anchor;beta=lambda x,z:(x&z).bit_count()%2;assert beta(X[ax],Z[az]);ids=[ax];basis={}
 def add(v,tag):
  while v:
   p=v.bit_length()-1
   if p not in basis:basis[p]=(v,tag);return True
   w,t=basis[p];v^=w;tag^=t
  return False
 assert add(X[ax],1)
 for i,x in enumerate(X):
  if not beta(x,Z[az]) and add(x,1<<len(ids)):ids.append(i)
  if len(ids)==128:break
 assert len(ids)==128
 def coordinates(v):
  tag=0
  while v:
   p=v.bit_length()-1;w,t=basis[p];v^=w;tag^=t
  return tag
 qx=[];qz=[]
 for i,x in enumerate(X):
  v=coordinates(x) if i!=ax and (a.x_only or not beta(x,Z[az])) else 0
  if not a.x_only:assert not v&1
  qx.append(v>>1)
 for j,z in enumerate(Z):
  v=sum(beta(X[i],z)<<k for k,i in enumerate(ids)) if j!=az and not beta(X[ax],z) else 0;assert not v&1;qz.append(v>>1)
 files={}
 for side,values in [('x',qx),('z',qz)]:
  raw=('\n'.join(f'{v:032x}' for v in values)+'\n').encode();path=a.output.with_name(a.output.stem+'-'+side+'coords.txt');path.write_bytes(raw);files[side]={'file':path.name,'sha256':hashlib.sha256(raw).hexdigest(),'nonzero_vectors':sum(bool(v) for v in values)}
 d={'status':'ANCHOR_QUOTIENT_CANDIDATE_REQUIRES_PHYSICAL_REPLAY','source_C16_answered':False,'anchor':a.anchor,'fixed_X_only':a.x_only,'conditioned_on_X_index':ax if a.x_only else None,'dual_gauge_Z_index':az if a.x_only else None,'effective_dimension':127,'basis_X_pool_indices':ids,'files':files,'convention':'B_X begins with the fixed X vector. X coordinates are B_X inverse, Z coordinates B_X transpose. Removing coordinate0 takes X modulo the fixed X vector and restricts Z to its annihilator. In fixed-pair mode X is additionally restricted by the fixed Z vector. In X-only mode Z in anchor is only a coordinate gauge, not assumed selected. Ineligible original indices are zero placeholders.'};a.output.write_text(json.dumps(d,indent=2)+'\n');print('QUOTIENT',a.anchor,'X-only',a.x_only,files)
if __name__=='__main__':main()
