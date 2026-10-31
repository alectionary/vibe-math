#!/usr/bin/env python3
"""Source-specific conditional binary circuit-rank inequalities."""
from pathlib import Path
from block_moment_dual import row
from verify_inverse_lift import vp,outer,shifts,rank


def source_vectors(source,side):
    q=source['dictionary']
    if side=='X':return [v for b in map(vp,q['X_right_factors']) for a in map(vp,q['X_left_dictionary']) for v in shifts(outer(a,b))]
    assert side=='Z'
    return [v for c in map(vp,q['Z_left_factors']) for d in map(vp,q['Z_right_dictionary']) for v in shifts(outer(c,d))]


def validate(cut,source,vectors=None):
    side=cut['sector'];V=source_vectors(source,side) if vectors is None else vectors;S=cut['circuit'];assert 3<=len(S)<=12 and len(set(S))==len(S) and all(0<=i<720 for i in S)
    w=0
    for i in S:w^=V[i]
    assert w==0 and rank(V[i] for i in S)==len(S)-1


def model_orbit(side,root,families):
    if side=='Z':return 9*len(families)+root
    c,j=divmod(root,9)
    return 9*families.index(c)+j if c in families else None


def constraint(cut,p,C,families=None):
    families=list(range(5)) if families is None else families
    side=cut['sector'];S=cut['circuit'];h=cut['phase'];i=cut['anchor'];assert side in ['X','Z'] and 0<=h<16 and 0<=i<len(p)
    terms=[]
    for v in S:
        j=model_orbit(side,v//16,families)
        if j is not None:terms.append((C[(v%16+h)%16][i][j],1))
    return row(terms+[(p[i],-(len(S)-1))],0,'ineq')


def expression(cut,p,C,families=None):
    families=list(range(5)) if families is None else families;i=cut['anchor'];h=cut['phase'];S=cut['circuit'];terms=[]
    for v in S:
        j=model_orbit(cut['sector'],v//16,families)
        if j is not None:terms.append(C[(v%16+h)%16][i,j])
    return sum(terms)<=(len(S)-1)*p[i]


def model_constraint(cuts,p,C,families=None):
    import cvxpy as cp
    from scipy.sparse import coo_matrix
    families=list(range(5)) if families is None else families;N=int(p.size);ri=[];ci=[];values=[]
    for r,cut in enumerate(cuts):
        side=cut['sector'];i=cut['anchor'];phase=cut['phase'];S=cut['circuit']
        ri.append(r);ci.append(i);values.append(-(len(S)-1))
        for v in S:
            j=model_orbit(side,v//16,families)
            if j is None:continue
            h=(v%16+phase)%16;a,b=i,j
            if h>8:h=16-h;a,b=b,a
            ri.append(r);ci.append(N+h*N*N+a+N*b);values.append(1)
    A=coo_matrix((values,(ri,ci)),shape=(len(cuts),N+9*N*N)).tocsr()
    v=cp.hstack([p]+[cp.vec(C[h],order='F') for h in range(9)])
    return A@v<=0
