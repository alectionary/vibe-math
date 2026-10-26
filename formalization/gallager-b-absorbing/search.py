"""Exact exploratory Gallager-B, flooding, strict majority, zero ties."""
from itertools import product,combinations
import json,random

def run(rows,n,e,cap=1000):
    vs=[[c for c,r in enumerate(rows) if r>>v&1] for v in range(n)]
    cs=[[v for v in range(n) if r>>v&1] for r in rows]
    edges=[(c,v) for c,ns in enumerate(cs) for v in ns]
    s=[(r&e).bit_count()%2 for r in rows]
    x={cv:0 for cv in edges}; seen={}; hist=[]
    if not any(s):return dict(kind='zero',iteration=0,out=0,hist=[])
    for t in range(1,cap+1):
        key=tuple(x.values())
        if key in seen:return dict(kind='cycle',iteration=t,period=t-seen[key],hist=hist)
        seen[key]=t
        y={(c,v):s[c]^ (sum(x[c,u] for u in cs[c] if u!=v)%2) for c,v in edges}
        out=sum((2*sum(y[c,v] for c in vs[v])>len(vs[v]))<<v for v in range(n))
        z={(c,v):int(2*sum(y[d,v] for d in vs[v] if d!=c)>len(vs[v])-1) for c,v in edges}
        hs=[(r&out).bit_count()%2 for r in rows]
        es=[sum(z[c,v] for v in ns)%2 for c,ns in enumerate(cs)]
        hist.append(dict(t=t,out=out,hard_syndrome=hs,edge_syndrome=es,x=list(x.values()),y=list(y.values()),z=list(z.values())))
        if hs==s:return dict(kind='match',iteration=t,out=out,edge_match=es==s,hist=hist)
        x=z
    return dict(kind='cap',hist=hist)

def span(rows):
    a={0}
    for r in rows:a|={v^r for v in a}
    return a

def check(rows,n,quantum=False):
    S=span(rows)
    for e in range(1<<n):
        o=run(rows,n,e)
        if o['kind'] not in ('match','zero') or (quantum and e^o['out'] not in S):return e,o
    return None

if __name__=='__main__':
    for n in range(3,9):
        rows=[sum(((v&c).bit_count()%2)<<v for v in range(1,1<<n)) for c in []] if False else []
        # All nonzero simplex rows on nonzero F2^m columns.
        if n==7:
            rows=[sum(((v&c).bit_count()%2)<<(v-1) for v in range(1,8)) for c in range(1,8)]
            print('simplex',rows,check(rows,n),check(rows,n,True),flush=True)
    # Self-dual small candidates, redundant rows allowed.
    rng=random.Random(20261026)
    for n in (4,6,8,10):
      for trial in range(10000):
        rows=[]
        candidates=[r for r in range(1,1<<n) if r.bit_count()%2==0]
        rng.shuffle(candidates)
        for r in candidates:
          if all((r&s).bit_count()%2==0 for s in rows):
            rows.append(r)
            if len(span(rows))==1<<(n//2):break
        S=span(rows)
        if len(S)!=1<<(n//2):continue
        rows=sorted(S-{0})
        if all(any(r>>v&1 for r in rows) for v in range(n)) and check(rows,n,True) is None:
            print('FOUND',n,rows,flush=True);open('/private/tmp/gallager-found.json','w').write(json.dumps(dict(n=n,rows=rows)));raise SystemExit
      print('done',n,flush=True)
