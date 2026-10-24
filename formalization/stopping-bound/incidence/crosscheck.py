"""Deterministic independent matrix reconstruction and bounded stopping search.
All finite computations below are corroboration; Lean carries the universal proofs.
"""
from pathlib import Path
import collections,json,hashlib,sys,time
W=Path(__file__).resolve().parent

def graph(n):
 cols=[]
 for b in range(2):
  for j in range(7):
   for f in range(n):
    cols.append([(j*n+(f-s)%n) for s in (0,1,6)] if b else [((j+r)%7)*n+(f+s)%n for r,s in ((0,27),(1,0),(2,54))])
 rows=[[]for _ in range(7*n)]
 for v,cs in enumerate(cols):
  assert len(set(cs))==3
  for c in cs:rows[c].append(v)
 assert all(len(set(vs))==6 for vs in rows)
 return cols,rows

def search(cols,rows,roots):
 nodes=0;found=set()
 def visit(S):
  nonlocal nodes
  nodes+=1
  degree=collections.Counter(c for v in S for c in cols[v])
  c=next((c for c,d in sorted(degree.items())if d==1),None)
  if c is None:found.add(tuple(sorted(S)));return
  if len(S)==5:return
  for v in rows[c]:
   if v not in S:visit(S|{v})
 for v in roots:visit({v})
 return {'roots':len(roots),'nodes':nodes,'stopping_supports_at_most_five':len(found)}

out={'evidence':'exact finite computation plus separately labelled floating illustration','domains':[]}
start=time.monotonic()
for t in range(1,9):
 n=63*t;cols,rows=graph(n)
 # Full root coverage at the base; two-root checks at larger lengths.
 roots=range(14*n) if t==1 else [0,7*n]
 result=search(cols,rows,roots);assert result['stopping_supports_at_most_five']==0
 # Reconstruct every H_Z row directly from B and A-transpose, and check CSS parity sparsely.
 hz=[]
 for j in range(7):
  for f in range(n):
   support=[j*n+(f-s)%n for s in (0,1,6)]+[7*n+((j+r)%7)*n+(f+s)%n for r,s in ((0,27),(1,0),(2,54))]
   assert len(set(support))==6
   profile=collections.Counter(c for v in support for c in cols[v]);assert set(profile.values())=={2}
   hz.append(support)
 # Check the covering map at every variable incidence and at every check row.
 projv=lambda v: (v//(7*n))*441+((v%(7*n))//n)*63+(v%n)%63
 projc=lambda c:(c//n)*63+(c%n)%63
 basecols,baserows=graph(63)
 assert all(sorted(map(projc,cs))==sorted(basecols[projv(v)])for v,cs in enumerate(cols))
 assert all(sorted(map(projv,vs))==sorted(baserows[projc(c)])for c,vs in enumerate(rows))
 out['domains'].append(dict(t=t,lift_length=n,columns=14*n,rows=7*n,search=result,companion_rows_checked=len(hz),witness=hz[0],all_companion_induced_degrees=2,cover_maps_checked=True))
# Dense NumPy reconstruction is independent of the sparse edge generator at t=1.
import numpy as np
n=63; cols,rows=graph(n); H=np.zeros((441,882),dtype=np.int64)
for v,cs in enumerate(cols):H[cs,v]=1
S=np.roll(np.eye(7,dtype=np.int64),1,axis=0)
P=lambda s:np.roll(np.eye(63,dtype=np.int64),s,axis=0)
A=np.kron(np.eye(7,dtype=np.int64),P(27))+np.kron(S,P(0))+np.kron(S@S,P(54))
B=P(0)+P(1)+P(6)
HX=np.hstack([A,np.kron(np.eye(7,dtype=np.int64),B.T)])
HZ=np.hstack([np.kron(np.eye(7,dtype=np.int64),B),A.T])
assert np.array_equal(H,HX) and not ((HX@HZ.T)%2).any()
s=float(np.linalg.eigvalsh(H@H.T)[-2])
out['independent_dense_reconstruction']='identical integer matrix; CSS product zero mod2'
out['floating_illustration_only']=dict(sigma2_squared=s,zhu_bit=882*(6-s)/(18-s),zhu_parity=2*882*(10-s)/(6*(18-s)),not_a_Lean_premise=True)
out['runtime_seconds']=time.monotonic()-start
(W/'crosscheck.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps({'status':'passed','domains':len(out['domains']),'base_full_root_search':out['domains'][0]['search'],'runtime_seconds':out['runtime_seconds']}))
