#!/usr/bin/env python3
"""Independent finite checks for structural necessary conditions."""
import argparse
from collections import defaultdict
from itertools import combinations
import json
from pathlib import Path
import random
import numpy as np
from owner_hall import allocation,literal_owners
from structural_master import LinearMaster,upper_planes
from orbit_benders import canonical
from audit_pools import exchange
from verify_partial_frame import mask,shift


def main():
 ap=argparse.ArgumentParser();ap.add_argument('inputs',type=Path);ap.add_argument('--cuts',type=Path,nargs='+',required=True);ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();root=Path(__file__).parent
 patterns=json.loads((args.inputs/'mapping.json').read_text())['patterns'];shapes=list(map(int,(args.inputs/'masks.txt').read_text().split()));profiles={r['pattern']:r for r in json.loads((args.inputs/'profiles.json').read_text())};weights=np.array([s.bit_count() for s in shapes]);checked=0
 for path in args.cuts:
  for line in path.read_text().splitlines():
   row=json.loads(line);assert row['kind']=='local_shape';eligible=weights==row['count']
   for r in row['demands']:
    assert r['pattern']==canonical(patterns[row['owner']][r['opposite']]);p=profiles[r['pattern']];eligible&=(np.array(p['zero'])>=r['zero'])&(np.array(p['owners'])>=r['owners'])
   assert not eligible.any();checked+=1
 # Big-M truth table: a single active witness is equivalent to its inequality,
 # and an inactive witness imposes no constraint on the declared domain.
 bigm=0
 for c in range(17):
  terms=[]
  if c:terms.append((1,c-1,17-c))
  if c<16:terms.append((-1,-c-1,c+1))
  for sign,rhs,M in terms:
   for value in range(17):
    assert sign*value<=rhs+M
    assert (sign*value+M<=rhs+M)==(sign*value<=rhs);bigm+=1
 envelope_planes=0;groups_checked=0
 for a in range(45):
  groups=defaultdict(list)
  for b in range(45):groups[canonical(patterns[a][b])].append(b)
  for f,bins in groups.items():
   if len(bins)<2 or f.bit_count()<=1:continue
   values=[max(v for v,w in zip(profiles[f]['owners'],weights) if w==c) for c in range(17)]
   for A,B,D in upper_planes(values):
    assert B>0 and all(A*int(c)+B*v<=D for c,v in zip(weights,profiles[f]['owners']));envelope_planes+=2
   for I in shapes[::257]:
    owners=[literal_owners(patterns[a][b],I)[1] for b in bins];assert len(set(owners))==1;groups_checked+=1
 # Reconstruct physical pool and locate each known physical support independently.
 source=json.loads((root/'physical-pool-source.json').read_text());Z=[shift(mask(r),h) for r in source['Z_orbit_representatives'] for h in range(16)];X=[exchange(z) for z in Z];xi={v:i for i,v in enumerate(X)};zi={v:i for i,v in enumerate(Z)}
 pairs=[(xi[mask(r['X'])],zi[mask(r['Z'])]) for r in json.loads((root/'partial-frame-88.json').read_text())['pairs']];assert len(pairs)==88
 positive_rows=0
 for side in [0,1]:
  chosen=[0]*45;demands=[[0]*45 for _ in range(45)]
  for pair in pairs:
   i,j=pair[side],pair[1-side];chosen[i//16]|=1<<(i%16);demands[i//16][j//16]+=1
  for a,I in enumerate(chosen):
   if not I:continue
   active=[b for b,n in enumerate(demands[a]) if n]
   for h in range(16):
    rotated=((I<<h)|(I>>(16-h)))&65535;owners=[literal_owners(patterns[a][b],rotated)[1] for b in active];assert allocation(owners,[demands[a][b] for b in active])['possible'];positive_rows+=1
 result={'status':'PASS','shape_cuts_replayed':checked,'big_M_boundary_cases':bigm,'envelope_planes':envelope_planes,'rotation_owner_set_checks':groups_checked,'physical_88_positive_rows_and_translates':positive_rows,'scope':'finite necessary-condition controls; no full-frame conclusion'};args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))

if __name__=='__main__':main()
