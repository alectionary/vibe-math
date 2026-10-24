"""Independent exploratory reconstruction. Floating spectra are not proof certificates."""
from pathlib import Path
import itertools,json,hashlib
import numpy as np
from fractions import Fraction
ROOT=Path(__file__).resolve().parent
rng=np.random.default_rng(20261024)
rep=[]
for r in [2,3,4,5]:
 for ell in [2,3,5,7,11]:
  for gamma in range(1,min(r,ell)+1):
   A=np.zeros((r*ell,r*ell),dtype=np.int64)
   for i in range(r):
    for d in range(gamma):
     j=(i+d)%r; shift=int(rng.integers(ell))
     for t in range(ell): A[i*ell+(t+shift)%ell,j*ell+t]=1
   support=rng.choice(ell,gamma,replace=False)
   B=np.array([[int((i-j)%ell in support) for j in range(ell)] for i in range(ell)],dtype=np.int64)
   H=np.concatenate([A,np.kron(np.eye(r,dtype=np.int64),B.T)],axis=1)
   assert np.all(H.sum(axis=0)==gamma) and np.all(H.sum(axis=1)==2*gamma)
   s=float(np.linalg.eigvalsh(H@H.T)[-2]);assert s>=gamma**2-1e-8
   rep.append(dict(r=r,ell=ell,gamma=gamma,second_squared=s))
# All ordered support pairs for each nonzero common weight through ell=10.
# Classification uses a numerical margin, never exact claims at the boundary.
counts=[];qual=[]
for ell in range(2,11):
 total=0;yes=0;border=0
 for gamma in range(1,ell+1):
  supports=list(itertools.combinations(range(ell),gamma))
  indicators=np.zeros((len(supports),ell))
  for i,S in enumerate(supports):indicators[i,list(S)]=1
  powers=np.abs(np.fft.fft(indicators,axis=1)[:,1:])**2
  spectra=np.max(powers[:,None,:]+powers[None,:,:],axis=2)
  total+=spectra.size;border+=int(np.sum(np.abs(spectra-gamma/2)<1e-8))
  ok=np.argwhere(spectra<gamma/2-1e-8);yes+=len(ok)
  for ai,bi in ok:
   s=float(spectra[ai,bi]);ap=ell/gamma*(1+np.sqrt(1-2*s/gamma))
   assert gamma>(3*ell+1)/4-1e-8 and ap<=2+1e-8
   if len(qual)<8:qual.append(dict(ell=ell,gamma=gamma,a=supports[ai],b=supports[bi],s=s,a_plus=ap))
 counts.append(dict(ell=ell,ordered_pairs=total,strict_qualifying_margin=yes,boundary_cases=border))
# Independent exact finite illustration: all-ones 2-by-4 X and Z checks.
X=[[1]*4 for _ in range(2)]
assert all(sum(X[i][v]*X[j][v] for v in range(4))%2==0 for i in range(2) for j in range(2))
stops=[S for size in range(1,5) for S in itertools.combinations(range(4),size)
       if all(sum(X[i][v] for v in S)!=1 for i in range(2))]
assert min(map(len,stops))==2
out=dict(evidence='Independent finite reconstruction; numerical spectral exploration, not an exact spectral certificate. General claims use Lean.',seed=20261024,replicated_cases=len(rep),replicated=rep,one_row=counts,qualifying_examples=qual,dense_exact=dict(matrix=X,gram=[[4,4],[4,4]],characteristic_polynomial='t*(t-8)',stopping_distance=2,stopping_supports=stops,CSS_orthogonal_mod_2=True))
(ROOT/'crosscheck.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(dict(replicated_cases=len(rep),ordered_one_row_pairs=sum(x['ordered_pairs'] for x in counts),qualifying_margin=sum(x['strict_qualifying_margin'] for x in counts),boundary_cases=sum(x['boundary_cases'] for x in counts),dense_stopping_distance=2)))
