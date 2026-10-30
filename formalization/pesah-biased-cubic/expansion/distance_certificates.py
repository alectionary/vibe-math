"""Finite distance certificates via disjoint homologous logical representatives.

An undetectable nontrivial Pauli must anticommute with some dual logical class.
K disjoint representatives of that class, equal modulo stabilizers, force weight
at least K. Explicit logical witnesses achieve the matching upper bound.
This executable certificate is not a Lean-formalized theorem for arbitrary L.
"""
import itertools,json,pathlib
import numpy as np
from pauli import lattice
from geometry import rhombic

def integer(a):return int.from_bytes(np.packbits(a,bitorder='little').tobytes(),'little')
def basis(H):
 b={}
 for row in H:
  x=integer(row)
  while x:
   k=x.bit_length()-1
   if k in b:x^=b[k]
   else:b[k]=x;break
 return b

def member(x,b):
 while x:
  k=x.bit_length()-1
  if k not in b:return False
  x^=b[k]
 return True
rows=[]
for code,builder in [('cubic',lattice),('rhombic',rhombic)]:
 for L in [2,4,6,8,10]:
  V,F,S,M=builder(L);bv=basis(V);bf=basis(F);n=V.shape[1];assert n-len(bv)-len(bf)==3
  def edge(a,v):return a*L**3+np.ravel_multi_index(tuple(v),(L,)*3)
  xbounds=[];zbounds=[]
  for normal in range(3):
   membrane_index=normal if code=='cubic' else [2,1,0].index(normal);target=integer(M[membrane_index]);used=0
   for offset in range(L):
    row=np.zeros(n,np.uint8)
    for v in itertools.product(range(L),repeat=3):
     if v[normal]==offset:
      for a in ([normal] if code=='cubic' else [b for b in range(3) if b!=normal]):row[edge(a,v)]=1
    bits=integer(row);assert not bits&used;used|=bits;assert member(bits^target,bv)
   xbounds.append(L)
   target=integer(S[normal]);used=0;count=0
   for axis in ([normal] if code=='cubic' else [b for b in range(3) if b!=normal]):
    other=[b for b in range(3) if b!=normal]
    for transverse in itertools.product(range(L),repeat=2):
     row=np.zeros(n,np.uint8)
     for t in range(L):
      v=[0,0,0];v[normal]=t
      for b,u in zip(other,transverse):v[b]=u
      row[edge(axis,v)]=1
     bits=integer(row);assert not bits&used;used|=bits;assert member(bits^target,bf);count+=1
   zbounds.append(count)
  assert min(xbounds)==int(S.sum(axis=1).min());assert min(zbounds)==int(M.sum(axis=1).min())
  rows.append(dict(code=code,L=L,d_X=int(S.sum(axis=1).min()),d_Z=int(M.sum(axis=1).min()),disjoint_dual_representatives_X=xbounds,disjoint_dual_representatives_Z=zbounds,all_membership_and_disjointness_checks=True));print(rows[-1],flush=True)
pathlib.Path(__file__).with_name('distance-certificates.json').write_text(json.dumps(dict(rows=rows,scope='Exact finite-size certificates at listed L, using explicit independent geometry. Not a formally verified or arbitrary-L proof; includes computational row-space membership checks. Rhombic convention is thesis prose, globally swapped from historical source.'),indent=2)+'\n')
