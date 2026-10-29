"""Compose certified forbidden detector sets with exact quotient word demand.

Discovery enumerates supports of size at most three using residual-basis
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

def probe(U,V,J,forbidden,dimension=128,cap=1):
    """Return certificates; forbidden maps sorted pool-index tuples to provenance."""
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
    labels=None;found=[];seen_support=set()
    def inspect(T,tail):
        nonlocal labels
        q=len(T)+tail.bit_count()
        if q<2 or q>3:return
        S=sorted([original[k] for k in T]+[nonbasis[t][0] for t in range(len(nonbasis)) if tail>>t&1])
        key=tuple(S)
        if key in seen_support:return
        seen_support.add(key)
        child=next((c for size in range(2,q+1) for c in combinations(S,size) if c in forbidden),None)
        if child is None:return
        w=0
        for k in T:w^=dual[k]
        target=remainder(w,L);assert target
        if labels is None:labels={0,*(remainder(v,L) for v in V)}
        bound=q-1
        if target in labels:return
        if bound>=2 and any(target^v in labels for v in labels):return
        found.append({'mandatory_opposite':J,'witness_hex':hex(w),'detecting_support':S,
                      'capacity_bound':bound,'minimum_outside_basis_terms':bound+1,
                      'forbidden_child_indices':list(child),'child_provenance':forbidden[child]})
    for i in range(r):
        inspect([i],columns[i])
        if len(found)>=cap:return found
    lookup=defaultdict(list)
    for k,c in enumerate(columns):lookup[c].append(k)
    for i in range(r):
        for j in range(i+1,r):
            tail=columns[i]^columns[j]
            if tail.bit_count()<=1:inspect([i,j],tail)
            if len(found)>=cap:return found
            for k in lookup.get(tail,[]):
                if k>j:inspect([i,j,k],0)
                if len(found)>=cap:return found
    return found
