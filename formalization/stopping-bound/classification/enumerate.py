from pathlib import Path
import collections,json,time
W=Path(__file__).resolve().parent
n=63
cols=[[(j*n+(f-s)%n)for s in(0,1,6)] if b else [((j+r)%7)*n+(f+s)%n for r,s in((0,27),(1,0),(2,54))]for b in range(2)for j in range(7)for f in range(n)]
rows=[[]for _ in range(441)]
for v,cs in enumerate(cols):
 for c in cs:rows[c].append(v)
def shift(S,j,f):return tuple(sorted((v//441)*441+((v%441//63+j)%7)*63+(v%63+f)%63 for v in S))
hz={tuple(sorted([j*n+(f-s)%n for s in(0,1,6)]+[441+((j+r)%7)*n+(f+s)%n for r,s in((0,27),(1,0),(2,54))]))for j in range(7)for f in range(n)}
found=set();nodes=0
start=time.monotonic()
def visit(S):
 global nodes
 nodes+=1;d=collections.Counter(c for v in S for c in cols[v]);c=next((c for c,k in sorted(d.items())if k==1),None)
 if c is None:
  found.add(tuple(sorted(S)));return
 if len(S)==6:return
 for v in rows[c]:
  if v not in S:visit(S|{v})
for r in(0,441):visit({r})
normalized=sorted(found);allsets={shift(S,j,f)for S in found for j in range(7)for f in range(63)}
orbits={min(shift(S,j,f)for j in range(7)for f in range(63))for S in found}
out=dict(roots=[0,441],nodes=nodes,seconds=time.monotonic()-start,normalized_stopping_supports=normalized,normalized_count=len(found),all_translates_count=len(allsets),companion_rows_count=len(hz),noncompanion_count=len(allsets-hz),missing_companion_count=len(hz-allsets),orbit_representatives=sorted(orbits))
(W/'enumeration.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items()if k!='normalized_stopping_supports'},indent=2))
