"""Exhaustive abstract socket matching, independent of exponent discovery.

This checks a finite combinatorial reduction, NOT the generic source/graph
bridge. Vertices are support positions; every source check meets zero or two.
No repeated edge and no triangle encode source Tanner girth at least eight.
"""
from itertools import combinations_with_replacement
from functools import lru_cache
from pathlib import Path
import json,time

R=Path(__file__).resolve().parent

@lru_cache(None)
def matchings(n):
    if not n:return ((),)
    def go(xs):
        if not xs:yield ();return
        a=xs[0]
        for b in xs[1:]:
            for rest in go(tuple(x for x in xs[1:] if x!=b)):
                yield ((a,b),)+rest
    return tuple(go(tuple(range(n))))

def test(uc,vc):
    a=sum(uc);n=a+sum(vc);ug=[];vg=[];offset=0
    for c in uc:ug.append(list(range(offset,offset+c)));offset+=c
    for c in vc:vg.append(list(range(offset,offset+c)));offset+=c
    buckets=[u+v for u in ug for v in vg if u or v]
    assert all(len(x)%2==0 for x in buckets)
    buckets.sort(key=len)
    adjacent=[0]*n;counts=0;nodes=0;examples=[]
    def go(k):
        nonlocal counts,nodes
        nodes+=1
        if k==len(buckets):
            counts+=1
            if len(examples)<2:examples.append(adjacent.copy())
            return
        xs=buckets[k]
        for matching in matchings(len(xs)):
            added=[];ok=True
            for i,j in matching:
                u,v=xs[i],xs[j]
                if (adjacent[u]>>v)&1 or adjacent[u]&adjacent[v]:ok=False;break
                adjacent[u]|=1<<v;adjacent[v]|=1<<u;added.append((u,v))
            if ok:go(k+1)
            for u,v in added:adjacent[u]^=1<<v;adjacent[v]^=1<<u
    start=time.monotonic();go(0)
    return {'U':uc,'V':vc,'weight':n,'matchings':counts,'nodes':nodes,'examples':examples,'seconds':time.monotonic()-start}

if __name__=='__main__':
    records=[]
    for parity in (0,1):
        us=[tuple(reversed(x)) for x in combinations_with_replacement(range(parity,12,2),4) if 0<sum(x)<=10]
        vs=[tuple(reversed(x)) for x in combinations_with_replacement(range(parity,12,2),3) if 0<sum(x)<=10]
        for uc in us:
            for vc in vs:
                if sum(uc)+sum(vc)>11:continue
                rec=test(uc,vc);records.append(rec);print(json.dumps(rec),flush=True)
    result={'scope':'All mixed source-socket counts through11, up to group permutations, with one parity shared by every U/V group; no repeated normal edge or triangle. Pure supports are separate classical/transpose cases.','count_cases':len(records),'surviving_count_cases':[r for r in records if r['matchings']],'records':records}
    (R/'socket-topologies.json').write_text(json.dumps(result,indent=2)+'\n')
