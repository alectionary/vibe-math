#!/usr/bin/env python3
"""Pairwise private-partner ownership cuts for source canonical frames.

If distinct same-sector points i,k are both selected, i's unique partner must
anticommute with i and commute with k. Equivalently, C(i,k) plus the i-partner
flow through common neighbors is at most p(i). Cyclic averaging preserves this
inequality without imposing symmetry on the frame.
"""
from block_moment_dual import row
from moment_matching_path_cuts import edge


def neighbor_polynomials(patterns,P=16):
    m=len(patterns);n=len(patterns[0]);out=[list(r) for r in patterns]
    def reverse(v):return sum((v>>h&1)<<((-h)%P) for h in range(P))
    out.extend([[reverse(patterns[j][i]) for j in range(m)] for i in range(n)])
    return out


def common_events(cut,patterns,P=16,neighbors=None):
    i,k,l=[cut[t] for t in ['i','k','l']];m=len(patterns);N=m+len(patterns[0])
    assert all(type(v) is int for v in [i,k,l]) and 0<=i<N and 0<=k<N and 0<=l<P and (i<m)==(k<m) and not(i==k and l==0)
    neighbors=neighbor_polynomials(patterns,P) if neighbors is None else neighbors
    offset=m if i<m else 0;mask=(1<<P)-1;out=[]
    for j,(a,b) in enumerate(zip(neighbors[i],neighbors[k])):
        common=a&(((b<<l)|(b>>(P-l)))&mask)
        while common:
            bit=common&-common;out.append((offset+j,bit.bit_length()-1));common^=bit
    return out


def coefficients(cut,patterns,p,C,P=16,neighbors=None):
    i,k,l=[cut[t] for t in ['i','k','l']]
    return row([(C[l][i][k],1),(p[i],-1)]+[(C[h][i][j],1) for j,h in common_events(cut,patterns,P,neighbors)],0,'ineq')


def model_constraint(cuts,patterns,p,C,P=16):
    import cvxpy as cp
    from scipy.sparse import coo_matrix
    N=int(p.size);ri=[];ci=[];values=[];neighbors=neighbor_polynomials(patterns,P)
    for r,cut in enumerate(cuts):
        i,k,l=[cut[t] for t in ['i','k','l']];ri.append(r);ci.append(i);values.append(-1)
        for j,h in [(k,l)]+common_events(cut,patterns,P,neighbors):
            a,b=i,j
            if h>P//2:h=P-h;a,b=b,a
            ri.append(r);ci.append(N+h*N*N+a+N*b);values.append(1)
    A=coo_matrix((values,(ri,ci)),shape=(len(cuts),N+(P//2+1)*N*N)).tocsr();v=cp.hstack([p]+[cp.vec(C[h],order='F') for h in range(P//2+1)])
    return A@v<=0
