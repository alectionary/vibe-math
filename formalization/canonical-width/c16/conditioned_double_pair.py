"""Supports<=6 containing two disjoint forbidden pairs lose two capacities."""
from collections import defaultdict,Counter
from itertools import combinations
from detecting_capacity import span,remainder
def probe(U,V,J,forbidden,dimension=128,cap=1,stats=None):
    if stats is None:stats=Counter()
    J=list(J);L=span(V[j] for j in J);assert len(L)==len(J)==len(set(J))
    rows={};tags={};original=[];nonbasis=[]
    for idx,x in enumerate(U):
        if any((x&V[j]).bit_count()%2 for j in J):continue
        value=x;tag=0
        while value:
            p=value.bit_length()-1
            if p not in rows:rows[p]=value;tags[p]=tag^(1<<len(original));original.append(idx);break
            value^=rows[p];tag^=tags[p]
        if not value:nonbasis.append((idx,tag))
    if len(original)!=dimension-len(J):stats['rank_deficient']=1;return []
    H={idx:0 for idx in original}
    for t,(idx,tag) in enumerate(nonbasis):
        H[idx]=1<<t
        for k,i in enumerate(original):
            if tag>>k&1:H[i]^=1<<t
    eligible=sorted(H);children=[K for K in forbidden if len(K)==2 and all(i in H for i in K)];stats['eligible_pairs']=len(children)
    bundles={}
    for A,B in combinations(children,2):
        if not set(A)&set(B):bundles.setdefault(tuple(sorted(A+B)),(A,B))
    stats['disjoint_pair_bundles']=len(bundles)
    if not bundles:return []
    dual=[]
    for k in range(len(original)):
        w=0
        for p in sorted(rows):
            if ((rows[p]&w).bit_count()&1)!=((tags[p]>>k)&1):w^=1<<p
        dual.append(w)
    table=defaultdict(list);table[0].append(())
    for i in eligible:table[H[i]].append((i,))
    for i,j in combinations(eligible,2):table[H[i]^H[j]].append((i,j))
    stats['pair_syndrome_keys']=len(table);labels=None;pair_labels=None;seen=set();found=[]
    for K,AB in sorted(bundles.items()):
        target=0
        for i in K:target^=H[i]
        for T in table.get(target,[]):
            if set(K)&set(T):continue
            D=tuple(sorted(K+T))
            if D in seen:continue
            seen.add(D);q=len(D);assert 4<=q<=6;stats['supports_'+str(q)]+=1
            w=0
            for k,i in enumerate(original):
                if i in D:w^=dual[k]
            targetword=remainder(w,L);assert targetword
            if labels is None:labels={0,*(remainder(v,L) for v in V)}
            bound=q-2
            if targetword in labels or any(targetword^x in labels for x in labels):continue
            if bound>=3:
                if pair_labels is None:
                    ss=list(labels);pair_labels={x^y for k,x in enumerate(ss) for y in ss[k:]}
                if any(targetword^x in pair_labels for x in labels):continue
            if bound>=4 and any(targetword^x in pair_labels for x in pair_labels):continue
            found.append({'mandatory_opposite':J,'witness_hex':hex(w),'detecting_support':list(D),'capacity_bound':bound,'minimum_outside_basis_terms':bound+1,
                          'forbidden_children':[{'indices':list(A),'provenance':forbidden[A]} for A in AB]})
            if len(found)>=cap:return found
    return found
