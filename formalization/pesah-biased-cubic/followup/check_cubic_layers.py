"""Independent 2D endpoint reconstruction of pure-X cubic point layers."""
from pathlib import Path
import sys,json,itertools,time
import numpy as np
R=Path(__file__).resolve().parent;sys.path.insert(0,str(R.parent/'simulation'))
from engine import lattice
start=time.perf_counter();rows=[]
for L in [2,4,6,8,10]:
 V,F,S,M=lattice(L);N=L**3
 independent=np.zeros((N,2*N),np.uint8)
 for x,y,z in itertools.product(range(L),repeat=3):
  for local_axis in [0,1]:
   source=np.ravel_multi_index((x,y,z),(L,)*3)
   target=np.ravel_multi_index((x,(y+(local_axis==0))%L,(z+(local_axis==1))%L),(L,)*3)
   independent[source,local_axis*N+source]^=1
   independent[target,local_axis*N+source]^=1
 assert np.array_equal(independent,V[:,N:])
 assert not np.any(F[:N,:N])
 rows.append(dict(L=L,point_entries_compared=int(independent.size),equal=True,first_normal_faces_have_no_first_axis_edges=True))
result=dict(rows=rows,seconds=time.perf_counter()-start,scope='Independent 2D endpoint reconstruction vs actual cubic vertex matrices; shared coordinate ordering, no source generator reuse. General factorization is written separately.')
(R/'cubic-layers-validation.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
