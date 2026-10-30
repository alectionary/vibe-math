"""Rhombic incidence from checkerboard cubes and corner triples.

Uses dissertation prose convention: Z cubes detect X errors, X triangles detect Z.
Historical bn3d uses the opposite global Pauli convention; validate explicitly.
"""
import itertools
import numpy as np

def rhombic(L):
 assert L%2==0
 sites=list(itertools.product(range(L),repeat=3));n=3*L**3
 def edge(a,v):return a*L**3+np.ravel_multi_index(tuple(x%L for x in v),(L,)*3)
 cubes=[];triangles=[]
 for v in sites:
  if sum(v)%2==1:
   row=np.zeros(n,np.uint8)
   for a in range(3):
    other=[b for b in range(3) if b!=a]
    for shifts in itertools.product([0,1],repeat=2):
     w=list(v)
     for b,s in zip(other,shifts):w[b]+=s
     row[edge(a,w)]=1
   cubes.append(row)
 # Same geometrical rows ordered by corner orientation, then vertex.
 for orientation in range(4):
  base=[(0,0,0),(0,1,1),(1,0,1),(1,1,0)][orientation]
  for v in sites:
   inward=[b^(sum(v)%2) for b in base];row=np.zeros(n,np.uint8)
   for a in range(3):
    w=list(v);w[a]-=inward[a];row[edge(a,w)]=1
   triangles.append(row)
 S=np.zeros((3,n),np.uint8);M=S.copy()
 for i,(along,axis) in enumerate([(0,1),(1,2),(2,0)]):
  for t in range(L):
   v=[0,0,0];v[along]=t;S[i,edge(axis,v)]=1
 for i,normal in enumerate([2,1,0]):
  for v in sites:
   if v[normal]==0:
    for a in range(3):
     if a!=normal:M[i,edge(a,v)]=1
 return np.array(cubes),np.array(triangles),S,M

def rank2(a):
 rows=[int.from_bytes(x.tobytes(),'little') for x in np.packbits(a,axis=1,bitorder='little')];basis={}
 for x in rows:
  while x:
   p=x.bit_length()-1
   if p in basis:x^=basis[p]
   else:basis[p]=x;break
 return len(basis)
