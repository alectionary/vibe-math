#!/usr/bin/env python3
"""Short source-rank nogoods for compact partial cover necessity models.

Their validity is conditional on an original full minimum-pool frame. Negative
selection constraints are inherited by deleting pairs; a positive partial
matching used as an oracle witness must satisfy them separately.
"""
from pathlib import Path
from itertools import combinations
import gzip,json
ROOT=Path(__file__).resolve().parent
CUTS=ROOT/'algebraic-results/small-conditional-original.json.gz'
def family():
 data=json.loads(gzip.decompress(CUTS.read_bytes()));F={}
 for k,c in enumerate(data['cuts']):
  for t in range(16):
   ids=tuple(sorted(16*(i//16)+(i+t)%16 for i in [c['anchor_X_index']]+c['other_X_indices']));F.setdefault(ids,(k,t))
 return F

def violation(pairs,F):
 for side in [0,1]:
  ids=sorted({p[side] for p in pairs})
  for size in range(2,min(len(ids),max(map(len,F)))+1):
   for S in combinations(ids,size):
    if S in F:return {'sector':'X' if side==0 else 'Z','indices':list(S),'rank_cut_index':F[S][0],'translation':F[S][1]}
 return None

def clauses(edges,anchor,F):
 m=len(edges);left=sorted({e[0] for e in edges});right=sorted({e[1] for e in edges});maps=[{i:m+k+1 for k,i in enumerate(left)},{j:m+len(left)+k+1 for k,j in enumerate(right)}];out=set()
 for ids in F:
  for side in [0,1]:
   fixed=anchor[side];owner=maps[side]
   if any(i!=fixed and i not in owner for i in ids):continue
   out.add(tuple(sorted(-owner[i] for i in ids if i!=fixed)))
 return sorted(out)
