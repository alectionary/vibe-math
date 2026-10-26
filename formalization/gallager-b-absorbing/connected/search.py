"""Exact development search for CSS-preserving CNOT coupling; no sampled decoder runs."""
from pathlib import Path
import json,itertools,collections,time
ROOT=Path(__file__).resolve().parent
BASE=json.loads((ROOT.parent/'certificate.json').read_text())
def mask(r):return sum(v<<i for i,v in enumerate(r))
X0=[mask(r) for r in BASE['HX']];Z0=[mask(r) for r in BASE['HZ']]
def cx(x,c,t):return x^((1<<t) if x>>c&1 else 0)
def cz(z,c,t):return z^((1<<c) if z>>t&1 else 0)
def span(rs):
 s={0}
 for r in rs:s|={w^r for w in s}
 return s
def connected(rows,n):
 seen={0}
 while True:
  nxt=seen|{v for r in rows if any(r>>u&1 for u in seen) for v in range(n) if r>>v&1}
  if nxt==seen:return len(seen)==n and all(rows)
  seen=nxt

def absorb(rows,A):
 for v in range(A.bit_length()):
  if not A>>v&1:continue
  ns=[(r&A).bit_count()%2 for r in rows if r>>v&1]
  if 2*sum(ns)>=len(ns):return False
 return True

def decode(rows,n,e):
 cs=[[v for v in range(n) if r>>v&1] for r in rows]
 vs=[[c for c,r in enumerate(rows) if r>>v&1] for v in range(n)]
 edges=[(c,v) for c,ns in enumerate(cs) for v in ns]
 s=[(r&e).bit_count()%2 for r in rows]
 if not any(s):return 0,0,None
 x={k:0 for k in edges};seen=set()
 for t in range(1,1001):
  key=tuple(x.values())
  if key in seen:return None,t,'cycle'
  seen.add(key)
  y={(c,v):s[c]^(sum(x[c,u] for u in cs[c] if u!=v)%2) for c,v in edges}
  out=sum(int(2*sum(y[c,v] for c in vs[v])>len(vs[v]))<<v for v in range(n))
  z={(c,v):int(2*sum(y[d,v] for d in vs[v] if d!=c)>len(vs[v])-1) for c,v in edges}
  es=[sum(z[c,v] for v in ns)%2 for c,ns in enumerate(cs)]
  if [(r&out).bit_count()%2 for r in rows]==s:return out,t,es==s
  x=z
 return None,1000,'cap'

def analyze(c,t):
 X=[cx(r,c,t) for r in X0];Z=[cz(r,c,t) for r in Z0];A=127;n=14
 assert all((x&z).bit_count()%2==0 for x in X for z in Z)
 if not connected(X,n) or not absorb(X,A):return None
 SX=span(X);SZ=span(Z)
 localX=sorted(w for w in SX if w&~A==0);localZ=sorted(w for w in SZ if w&~A==0)
 if len(localX)*len(localZ)>=128:return None
 records=[]
 for e in range(128):
  out,it,edge=decode(X,n,e)
  if out is None or e^out not in SZ:return None
  records.append(dict(input=e,output=out,iteration=it,edge_match=edge,residual=e^out))
 return dict(control=c,target=t,HX=X,HZ=Z,A=A,n=n,k=n-(len(SX).bit_length()-1)-(len(SZ).bit_length()-1),local_X_words=localX,local_Z_words=localZ,local_stabilizer_rank=(len(localX)*len(localZ)).bit_length()-1,records=records)

if __name__=='__main__':
 results=[]
 for c,t in [(0,7),(7,0)]:
  q=analyze(c,t);print(c,t,'PASS' if q else 'FAIL',flush=True)
  if q:results.append(q)
 if results:
  q=results[0];(ROOT/'candidate.json').write_text(json.dumps(q,indent=2)+'\n')
  print(json.dumps({k:q[k] for k in ['control','target','HX','HZ','k','local_stabilizer_rank']},indent=2))
