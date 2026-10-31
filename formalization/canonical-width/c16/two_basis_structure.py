"""Exact five-dimensional shared-pattern algebra and local zonotope facets.

No source feasibility is inferred here. Local boxes omit joint cardinality,
matroid rank, and mutual pairings between unanchored vectors.
"""
from fractions import Fraction as Q
from itertools import combinations
from functools import reduce
from math import gcd
from flint import fmpz_mat

LOW=[0,1,2,4,8,3,5,9,6,10,12]
HIGH=[7,11,13,14,15]
PATTERNS=range(16)

def generator(m,n=4):return [1]+[(m>>i)&1 for i in range(n)]
def anchor_feature(m):return [int(m&s==s) for s in LOW]

def lambda_transform():
    """lambda=L*mu_low+C*mu_high, by literal inclusion-exclusion."""
    L=[];C=[]
    for m in PATTERNS:
        row={s:(-1)**((s^m).bit_count()) for s in range(16) if s&m==m}
        L.append([row.get(s,0) for s in LOW]);C.append([row.get(s,0) for s in HIGH])
    return L,C

def lambda_affine(low):
    L,C=lambda_transform()
    return [sum(Q(a)*b for a,b in zip(r,low)) for r in L],C

def lambda_values(low,high):
    base,C=lambda_affine(low)
    return [v+sum(Q(a)*b for a,b in zip(r,high)) for v,r in zip(base,C)]

def solve_unique(A,b):
    A=[[Q(v) for v in row]+[Q(rhs)] for row,rhs in zip(A,b)];n=len(A[0])-1;piv=[];r=0
    for j in range(n):
        k=next((k for k in range(r,len(A)) if A[k][j]),None)
        if k is None:continue
        A[r],A[k]=A[k],A[r];t=A[r][j];A[r]=[v/t for v in A[r]]
        for k in range(len(A)):
            if k!=r and A[k][j]:
                t=A[k][j];A[k]=[x-t*y for x,y in zip(A[k],A[r])]
        piv.append(j);r+=1
    assert len(piv)==n and all(any(row[:-1]) or row[-1]==0 for row in A)
    x=[Q(0)]*n
    for i,j in enumerate(piv):x[j]=A[i][-1]
    return x

def primitive(v):
    v=list(map(int,v));g=reduce(gcd,map(abs,v),0)
    if not g:return None
    v=[x//g for x in v]
    if next(x for x in v if x)<0:v=[-x for x in v]
    return tuple(v)

def zonotope_normals(generators,ambient):
    """Complete facet and span normals, including ranks0 and1.

    Project injectively to independent coordinate rows. Facets in rank r are
    normal to r-1 independent generators. Lift those normals and add a basis
    of annihilator equalities. Both signs are returned by the caller.
    """
    G=[list(map(int,g)) for g in generators];assert all(len(g)==ambient for g in G)
    rank=fmpz_mat(G).rank() if G else 0
    if not rank:return {'rank':0,'coordinates':[],'facet_normals':[],'equality_normals':[tuple(int(i==j) for i in range(ambient)) for j in range(ambient)]}
    coordinates=[]
    for j in range(ambient):
        trial=coordinates+[j]
        if fmpz_mat([[g[k] for k in trial] for g in G]).rank()>len(coordinates):coordinates.append(j)
        if len(coordinates)==rank:break
    P=[[g[k] for k in coordinates] for g in G];facets=set()
    for subset in combinations(range(len(P)),rank-1):
        rows=[P[i] for i in subset]
        v=[(-1)**j*int(fmpz_mat([[row[k] for k in range(rank) if k!=j] for row in rows]).det()) for j in range(rank)] if rank>1 else [1]
        v=primitive(v)
        if v is None:continue
        lifted=[0]*ambient
        for k,x in zip(coordinates,v):lifted[k]=x
        facets.add(primitive(lifted))
    N,nullity=fmpz_mat(G).nullspace();eq=[primitive([int(N[i,j]) for i in range(ambient)]) for j in range(nullity)]
    assert nullity==ambient-rank and all(all(sum(a*b for a,b in zip(n,g))==0 for g in G) for n in eq)
    return {'rank':rank,'coordinates':coordinates,'facet_normals':sorted(facets),'equality_normals':eq}

def status_normals(status):
    assert len(status)==16 and all(v in (-1,0,1) for v in status)
    return zonotope_normals([generator(m) for m in PATTERNS if status[m]==0],5)

def pattern_support(status,v):
    assert len(v)==5
    values=[sum(a*b for a,b in zip(v,generator(m))) for m in PATTERNS]
    return [values[m] if status[m]==1 else max(0,values[m]) if status[m]==0 else 0 for m in PATTERNS]

def outer_row(h,left,low):
    base,C=lambda_affine(low)
    return [-sum(h[m]*C[m][j] for m in PATTERNS) for j in range(5)],sum(Q(h[m])*base[m] for m in PATTERNS)-Q(left)

def compose_outer_cut(rows,multipliers):
    """Combine rows h.lambda>=v.feature using exact nonnegative multipliers.

    Rows contain h[16] and sparse feature_terms on the full7211 layout.
    Cancellation of the five high moments leaves a valid homogeneous normal.
    """
    assert len(rows)==len(multipliers) and all(Q(z)>=0 for z in multipliers)
    L,C=lambda_transform();H=[sum(Q(z)*r['h'][m] for z,r in zip(multipliers,rows)) for m in PATTERNS]
    assert all(sum(H[m]*C[m][j] for m in PATTERNS)==0 for j in range(5))
    normal=[Q(0)]*7211
    for z,r in zip(multipliers,rows):
        for i,v in r['feature_terms']:normal[i]+=Q(z)*v
    for j in range(11):normal[j]-=sum(H[m]*L[m][j] for m in PATTERNS)
    return normal
