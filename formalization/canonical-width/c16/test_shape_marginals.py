import sys,json
from pathlib import Path
import numpy as np
root=Path(__file__).resolve().parent;sys.path.insert(0,str(root))
from cyclic_moment_sdp import moments_from_masks,verify_shape_marginals
from audit_pools import exchange
from verify_partial_frame import mask,shift
source=json.loads((root/'physical-pool-source.json').read_text());Z=[shift(mask(r),h) for r in source['Z_orbit_representatives'] for h in range(16)];X=[exchange(z) for z in Z];xi={v:i for i,v in enumerate(X)};zi={v:i for i,v in enumerate(Z)}
chosen=[0]*90
for r in json.loads((root/'partial-frame-88.json').read_text())['pairs']:
 i=xi[mask(r['X'])];j=zi[mask(r['Z'])];chosen[i//16]|=1<<(i%16);chosen[45+j//16]|=1<<(j%16)
p,C=moments_from_masks(chosen,16);folder=Path(sys.argv[1]);shapes=list(map(int,(folder/'masks.txt').read_text().split()));ids={v:i for i,v in enumerate(shapes)};distribution=np.zeros((90,len(shapes)))
for a,I in enumerate(chosen):
 canonical=min(((I<<h)|(I>>(16-h)))&65535 for h in range(16));distribution[a,ids[canonical]]=1
patterns=json.loads((folder/'mapping.json').read_text())['patterns'];check=verify_shape_marginals(patterns,p,C,distribution,folder);assert check['maximum_residual']==0
Path(sys.argv[2]).write_text(json.dumps({'status':'PASS','known_physical_pairs':88,'check':check},indent=2)+'\n');print(check)
