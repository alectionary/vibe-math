"""Support-at-most-four extension of the detector-capacity discovery gate.

Discovery enumerates supports of size at most four using residual-basis
columns. It does not enumerate source bases. The returned child is a previously
certified forbidden subset of the complete detecting support.
"""
from collections import defaultdict
from itertools import combinations

def span(values):
    rows={}
    for value in values:
        while value:
            p=value.bit_length()-1
            if p not in rows:rows[p]=value;break
            value^=rows[p]
    return rows

def remainder(value,rows):
    for p in sorted(rows,reverse=True):
        if value>>p&1:value^=rows[p]
    return value

def probe(U,V,J,forbidden,dimension=128,cap=1,order=4,stats=None):
    """Return certificates; forbidden maps sorted pool-index tuples to provenance."""
    assert order in (3,4)
    if stats is None:stats=defaultdict(int)
    J=list(J);L=span(V[j] for j in J)
    assert len(J)==len(set(J))==len(L)
    rows={};tags={};original=[];nonbasis=[]
    for idx,x in enumerate(U):
        if any((x&V[j]).bit_count()%2 for j in J):continue
        value=x;tag=0
        while value:
            p=value.bit_length()-1
            if p not in rows:
                rows[p]=value;tags[p]=tag^(1<<len(original));original.append(idx);break
            value^=rows[p];tag^=tags[p]
        if not value:nonbasis.append((idx,tag))
    r=len(original)
    if r!=dimension-len(J):return [] # rank deficiency is already an old exclusion
    columns=[0]*r
    for t,(_,tag) in enumerate(nonbasis):
        while tag:
            b=tag&-tag;k=b.bit_length()-1;columns[k]|=1<<t;tag-=b
    dual=[]
    for k in range(r):
        w=0
        for p in sorted(rows):
            if ((rows[p]&w).bit_count()&1)!=((tags[p]>>k)&1):w^=1<<p
        dual.append(w)
    labels=None;pair_labels=None;found=[];seen_support=set()
    def inspect(T,tail):
        nonlocal labels,pair_labels
        q=len(T)+tail.bit_count()
        if q<2 or q>order:return
        S=sorted([original[k] for k in T]+[nonbasis[t][0] for t in range(len(nonbasis)) if tail>>t&1])
        key=tuple(S)
        if key in seen_support:return
        seen_support.add(key)
        stats['supports_'+str(q)]+=1
        child=next((c for size in range(2,q+1) for c in combinations(S,size) if c in forbidden),None)
        if child is None:return
        stats['forbidden_child_hits_'+str(q)]+=1
        w=0
        for k in T:w^=dual[k]
        target=remainder(w,L);assert target
        if labels is None:labels={0,*(remainder(v,L) for v in V)}
        bound=q-1
        if target in labels:return
        if bound>=2 and any(target^v in labels for v in labels):return
        if bound>=3:
            if pair_labels is None:
                single=list(labels);pair_labels={a^b for i,a in enumerate(single) for b in single[i:]}
            if any(target^v in pair_labels for v in labels):return
        found.append({'mandatory_opposite':J,'witness_hex':hex(w),'detecting_support':S,
                      'capacity_bound':bound,'minimum_outside_basis_terms':bound+1,
                      'forbidden_child_indices':list(child),'child_provenance':forbidden[child]})
    for i in range(r):
        inspect([i],columns[i])
        if len(found)>=cap:return found
    lookup=defaultdict(list)
    for k,c in enumerate(columns):lookup[c].append(k)
    # A triple basis support permits one nonbasis hit at order4. Hash its
    # possible final column, instead of scanning every basis triple.
    nearby=defaultdict(list)
    if order==4:
        for k,c in enumerate(columns):
            nearby[c].append((k,0))
            for t in range(len(nonbasis)):nearby[c^(1<<t)].append((k,1<<t))
    pairs=defaultdict(list)
    for i in range(r):
        for j in range(i+1,r):
            tail=columns[i]^columns[j]
            if tail.bit_count()<=order-2:inspect([i,j],tail)
            if len(found)>=cap:return found
            if order==3:
                for k in lookup.get(tail,[]):
                    if k>j:inspect([i,j,k],0)
                    if len(found)>=cap:return found
            else:
                for k,rest in nearby.get(tail,[]):
                    if k>j:inspect([i,j,k],rest)
                    if len(found)>=cap:return found
                # Unique ordered split a<b<i<j covers every four-index set.
                for a,b in pairs.get(tail,[]):
                    if b<i:inspect([a,b,i,j],0)
                    if len(found)>=cap:return found
                pairs[tail].append((i,j))
    return found
