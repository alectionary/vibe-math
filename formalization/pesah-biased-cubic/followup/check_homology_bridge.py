"""Independent Python matrix checks of Lean potential/holonomy consumers.
Shared input fields and geometric convention; no independent physics claim.
"""
import pathlib,json,sys,hashlib,itertools
import numpy as np
R=pathlib.Path(__file__).resolve().parent;sys.path.insert(0,str(R.parent/'simulation'))
from engine import lattice
lines=iter(pathlib.Path(sys.argv[1]).read_text().splitlines());records=[];entries=0
for header in lines:
 _,ll,ss,labels,holos,ww=header.split();L=int(ll);seed=int(ss);bits=np.array([int(x) for x in labels],np.uint8);assert holos==labels
 P=np.array([[int(x) for x in next(lines)] for _ in range((L+1)**2)],np.uint8).reshape((L+1,)*3)
 V,F,S,M=lattice(L);xyz=np.indices((L,)*3);x,y,z=xyz
 u=((x*17+y*11+z*7+x*y*3+seed*13)%5==0).astype(np.uint8).ravel()
 error=(V.T@u)%2
 for axis in range(3):
  error[axis*L**3:(axis+1)*L**3]^=(xyz[axis]==0).astype(np.uint8).ravel()*bits[axis]
 assert not np.any((F@error)%2);assert np.array_equal((S@error)%2,bits)
 assert int(error.sum())==int(ww)
 if bits.any():assert int(ww)>=L*L
 ep=error.reshape((3,L,L,L));base=P[:L,:L,:L]
 for a,sl in enumerate([(slice(1,L+1),slice(0,L),slice(0,L)),(slice(0,L),slice(1,L+1),slice(0,L)),(slice(0,L),slice(0,L),slice(1,L+1))]):assert np.array_equal(P[sl]^base,ep[a]);entries+=L**3
 assert np.all((P[L,:L,:L]^P[0,:L,:L])==bits[0]);assert np.all((P[:L,L,:L]^P[:L,0,:L])==bits[1]);assert np.all((P[:L,:L,L]^P[:L,:L,0])==bits[2]);assert P[0,0,0]==0
 records.append(dict(L=L,seed=seed,holonomy=labels,weight=int(ww),matrix_syndrome_zero=True,potential_and_period_checks=True))
assert len(records)==80
out=dict(records=records,fields=80,gradient_entries=entries,errors=[],export_sha256=hashlib.sha256(pathlib.Path(sys.argv[1]).read_bytes()).hexdigest(),source_hashes={str(p.relative_to(R)):hashlib.sha256(p.read_bytes()).hexdigest() for p in [R/'lean/CubicPotential.lean',R/'lean/CubicDistance.lean',R/'lean/HomologyConsumer.lean']},limit='Constructed consumer fields spanning all8labels at odd/even L2..6, not exhaustive enumeration. Shared input potentials, seam convention, Python lattice generator; Lean potential/weight/holonomy computation independently checked against Python incidence matrices. General statements rely on kernel proofs, not these examples.')
(R/'homology-bridge-validation.json').write_text(json.dumps(out,indent=2)+'\n');print('checked',len(records),'fields,',entries,'gradient entries')
