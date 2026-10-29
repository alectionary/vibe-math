"""Literal quotient-coset certificate checks for small mandatory source subsets."""
from itertools import combinations

def check(X,Z,row,dimension=128):
    assert row['kind']=='sparse_quotient_obstruction' and row['side'] in (0,1)
    U,V=(X,Z) if row['side']==0 else (Z,X);J=row['mandatory_opposite'];q=row['order']
    assert len(J)==len(set(J))<=8 and all(0<=j<len(V) for j in J) and 0<=q<=4
    L={0}
    for j in J:L|={v^V[j] for v in list(L)}
    canonical=lambda v:min(v^ell for ell in L)
    w=int(row['witness_hex'],16);assert 0<w<1<<dimension and w not in L
    D=[i for i,x in enumerate(U) if (x&w).bit_count()%2 and all(not (x&V[j]).bit_count()%2 for j in J)]
    assert D==row['detecting_support'] and len(D)==q and row['minimum_outside_basis_terms']==q+1
    # Use actual source sums followed by literal coset minimization; this does
    # not call either discovery elimination or its quotient-label routine.
    values=[0,*V];target=canonical(w)
    if q>=1:assert all(canonical(z)!=target for z in values)
    pair_labels=None
    if q>=2:
        pair_labels={canonical(a^b) for i,a in enumerate(values) for b in values[i:]}
        assert target not in pair_labels
    if q>=3:assert all(canonical(w^z) not in pair_labels for z in values)
    if q>=4:assert all(canonical(w^p) not in pair_labels for p in pair_labels)
    clause=[-j-1-(len(X) if row['side']==0 else 0) for j in J];assert row['clause']==clause
    return {'clause':clause,'detecting_support_size':q,'literal_span_size':len(L),
            'distinct_pair_sum_cosets':len(pair_labels) if pair_labels is not None else None}
