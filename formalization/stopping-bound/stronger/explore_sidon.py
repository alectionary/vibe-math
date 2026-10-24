from pathlib import Path
import json,time

def find(n,S,bound,cap=2000000):
 cols=[[(j+(-s if side else s))%n for s in S]for side in range(2)for j in range(n)];rows=[[v for v,c in enumerate(cols)if i in c]for i in range(n)];nodes=0;memo=set();start=time.time()
 def dfs(t):
  nonlocal nodes
  nodes+=1
  if nodes>cap:raise TimeoutError
  key=tuple(sorted(t))
  if key in memo:return
  memo.add(key)
  ones=[c for v in t for c in cols[v]if sum(c in cols[w]for w in t)==1]
  if not ones:return key
  if len(t)==bound:return
  c=ones[0]
  for v in rows[c]:
   if v not in t:
    found=dfs([v]+t)
    if found:return found
 try:
  f=None
  for root in [0,n]:
   f=dfs([root])
   if f:break
  return dict(n=n,S=S,bound=bound,found=f,nodes=nodes,status='witness'if f else'excluded',seconds=round(time.time()-start,3))
 except TimeoutError:return dict(n=n,S=S,bound=bound,nodes=nodes,status='capped',seconds=round(time.time()-start,3))
out=[]
for n,S in [(7,[0,1,3]),(27,[1,3,9]),(81,[1,3,9,27]),(31,[0,1,4,10]),(39,[0,1,4,6]),(729,[1,3,9,27,81,243])]:
 for b in range((2*(len(S)+1)+2)//3,2*len(S)+1):
  r=find(n,S,b);out.append(r);print(r,flush=True)
  if r['status']!='excluded':break
Path(__file__).with_name('explore_sidon.json').write_text(json.dumps(out,indent=2)+'\n')
