"""Complete detecting supports<=5 containing a previously forbidden2/3/4-set.

Write the residual evaluation code in systematic coordinates. Its parity-check
syndrome columns H_i make D a detecting support exactly when XOR(H_i:i in D)=0.
For a fixed forbidden child K, the rest has at most3 points. Pair-sum tables
therefore find every qualifying support without enumerating arbitrary5-sets.
"""
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
    eligible=sorted(H);children=[K for K in forbidden if 2<=len(K)<=4 and all(i in H for i in K)];stats['eligible_children']=len(children)
    if not children:return []
    dual=[]
    for k in range(len(original)):
        w=0
        for p in sorted(rows):
            if ((rows[p]&w).bit_count()&1)!=((tags[p]>>k)&1):w^=1<<p
        dual.append(w)
    one=defaultdict(list);one[0].append(())
    for i in eligible:one[H[i]].append((i,))
    pairs=None;labels=None;pair_labels=None;seen=set();found=[]
    def inspect(K,T):
        nonlocal labels,pair_labels
        if len(T)!=len(set(T)) or set(K)&set(T):return
        D=tuple(sorted(K+T))
        if D in seen:return
        seen.add(D);q=len(D);assert 2<=q<=5;stats['supports_'+str(q)]+=1
        w=0
        for k,i in enumerate(original):
            if i in D:w^=dual[k]
        target=remainder(w,L);assert target
        if labels is None:labels={0,*(remainder(v,L) for v in V)}
        bound=q-1
        if target in labels:return
        if bound>=2 and any(target^x in labels for x in labels):return
        if bound>=3:
            if pair_labels is None:
                ss=list(labels);pair_labels={x^y for k,x in enumerate(ss) for y in ss[k:]}
            if any(target^x in pair_labels for x in labels):return
        if bound>=4 and any(target^x in pair_labels for x in pair_labels):return
        found.append({'mandatory_opposite':J,'witness_hex':hex(w),'detecting_support':list(D),'capacity_bound':bound,
                      'minimum_outside_basis_terms':bound+1,'forbidden_child_indices':list(K),'child_provenance':forbidden[K]})
    for K in sorted(children,key=lambda K:(len(K),K)):
        target=0
        for i in K:target^=H[i]
        limit=5-len(K)
        if limit>=2 and pairs is None:
            pairs={s:list(ts) for s,ts in one.items()}
            for i,j in combinations(eligible,2):pairs.setdefault(H[i]^H[j],[]).append((i,j))
            stats['pair_syndrome_keys']=len(pairs)
        table=one if limit==1 else pairs
        for T in table.get(target,[]):
            inspect(K,T)
            if len(found)>=cap:return found
        if limit==3:
            for i in eligible:
                if i in K:continue
                for T in pairs.get(target^H[i],[]):
                    inspect(K,(i,)+T)
                    if len(found)>=cap:return found
    return found
