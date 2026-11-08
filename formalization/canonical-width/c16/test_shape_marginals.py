#!/usr/bin/env python3
"""Literal physical positive controls for full and restricted shape support."""
import sys,json
from pathlib import Path
import numpy as np
from cyclic_moment_sdp import moments_from_masks,verify_shape_marginals
from audit_pools import exchange
from verify_partial_frame import mask,shift
root=Path(__file__).resolve().parent;source=json.loads((root/'physical-pool-source.json').read_text());Z=[shift(mask(r),h) for r in source['Z_orbit_representatives'] for h in range(16)];X=[exchange(z) for z in Z];xi={v:i for i,v in enumerate(X)};zi={v:i for i,v in enumerate(Z)}
folder=Path(sys.argv[1]);shapes=list(map(int,(folder/'masks.txt').read_text().split()));ids={v:i for i,v in enumerate(shapes)};patterns=json.loads((folder/'mapping.json').read_text())['patterns'];pairs=json.loads((root/'partial-frame-88.json').read_text())['pairs'];checks=[]
for count in [88,4]:
 chosen=[0]*90
 for r in pairs[:count]:
  i=xi[mask(r['X'])];j=zi[mask(r['Z'])];chosen[i//16]|=1<<(i%16);chosen[45+j//16]|=1<<(j%16)
 p,C=moments_from_masks(chosen,16);distribution=np.zeros((90,len(shapes)))
 for a,I in enumerate(chosen):
  canonical=min(((I<<h)|(I>>(16-h)))&65535 for h in range(16));distribution[a,ids[canonical]]=1
 check=verify_shape_marginals(patterns,p,C,distribution,folder);assert check['maximum_residual']==0
 if count==4:assert all(I.bit_count()<=4 for I in chosen)
 checks.append({'physical_pairs':count,'max_shape_weight':max(I.bit_count() for I in chosen),'check':check})
result={'status':'PASS','controls':checks};Path(sys.argv[2]).write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))
