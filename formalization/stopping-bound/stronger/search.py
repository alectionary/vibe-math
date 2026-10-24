from pathlib import Path
import json,time
S=[0,1,4,6]
def search(n,bound):
 cols=[[(j+(-s if side else s))%n for s in S] for side in range(2) for j in range(n)];rows=[[v for v,c in enumerate(cols) if i in c] for i in range(n)]
 nodes=0;memo=set()
 def dfs(t):
  nonlocal nodes
  nodes+=1
  key=tuple(sorted(t))
  if key in memo:return
  memo.add(key)
  ones=[c for v in t for c in cols[v] if sum(c in cols[w] for w in t)==1]
  if not ones:return key
  if len(t)==bound:return
  # Fixed local order for faithful small Lean replication.
  c=ones[0]
  for v in rows[c]:
   if v not in t:
    found=dfs([v]+t)
    if found:return found
 for root in [0,n]:
  f=dfs([root])
  if f:return dict(n=n,bound=bound,found=f,nodes=nodes,seconds=round(time.time()-start,3))
 return dict(n=n,bound=bound,found=None,nodes=nodes,seconds=round(time.time()-start,3))
out=[]
for n in [13,26,39,65,91]:
 for b in [4,5,6,7,8]:
  start=time.time();r=search(n,b);out.append(r);print(r,flush=True)
  if r['found']:break
Path(__file__).with_name('search.json').write_text(json.dumps(out,indent=2)+'\n')
