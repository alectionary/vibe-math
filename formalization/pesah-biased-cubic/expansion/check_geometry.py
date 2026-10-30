import json,pathlib,sys,types
import numpy as np
from scipy.sparse import csr_matrix
from pauli import lattice
from geometry import rhombic,rank2
from validate import historical
source=pathlib.Path(sys.argv[1]);historical(source)
package=types.ModuleType('bn3d.rhombic');package.__path__=[str(source/'bn3d/rhombic')];sys.modules['bn3d.rhombic']=package
from bn3d.rhombic._rhombic_code import RhombicCode
rows=[]
for name,builder in [('cubic',lattice),('rhombic',rhombic)]:
 for L in [2,4,6,8,10]:
  V,F,S,M=builder(L);n=V.shape[1];v=csr_matrix(V);f=csr_matrix(F)
  assert not np.any((v@f.T).data%2)
  assert not np.any(v@S.T%2);assert not np.any(f@M.T%2)
  assert rank2(S@M.T%2)==3
  rv=rank2(V);rf=rank2(F);assert n-rv-rf==3
  record=dict(code=name,L=L,n=n,k=n-rv-rf,rank_X_detection=rv,rank_Z_detection=rf,logical_X_weights=S.sum(axis=1).tolist(),logical_Z_weights=M.sum(axis=1).tolist(),axis_X_detection_nullity=L**3-rank2(V[:,:L**3]),axis_Z_detection_nullity=L**3-rank2(F[:,:L**3]))
  if name=='rhombic':
   c=RhombicCode(L);record['historical_global_Hadamard_match']=bool(np.array_equal(V,c.Hz) and np.array_equal(F,c.Hx) and np.array_equal(S,c.logical_zs[:,n:]) and np.array_equal(M,c.logical_xs[:,:n]));assert record['historical_global_Hadamard_match']
  rows.append(record);print(record,flush=True)
pathlib.Path(sys.argv[2]).write_text(json.dumps(dict(rows=rows,limits='Finite-size algebra checks, not an asymptotic distance proof. Rhombic matrices match historical source only after global X/Z swap; source prose/caption conflicts require explicit convention audit.'),indent=2)+'\n')
