#!/usr/bin/env python3
"""Source matching-path triple exclusions in cyclic selection moments.

A selected center cannot have two selected anticommuting partners. Thus for
three distinct events a,b,c with b adjacent to both a and c, abc=0 and
E[ab]+E[ac]<=E[a]. These cuts require the source edges; they are not generic
Boolean triangle inequalities.
"""
from block_moment_dual import row


def edge(patterns,a,ha,b,hb,P=16):
    m=len(patterns);N=m+len(patterns[0])
    if a<m<=b:return patterns[a][b-m]>>((hb-ha)%P)&1
    if b<m<=a:return patterns[b][a-m]>>((ha-hb)%P)&1
    return 0


def validate(cut,patterns,P=16):
    m=len(patterns);N=m+len(patterns[0]);i,j,k=[cut[t] for t in ['i','j','k']];h,l=[cut[t] for t in ['h','l']]
    assert all(type(v) is int for v in [i,j,k,h,l]) and all(0<=v<N for v in [i,j,k]) and 0<=h<P and 0<=l<P
    assert (i<m)==(k<m) and (i<m)!=(j<m) and not(i==k and l==0)
    assert edge(patterns,i,0,j,h,P)==edge(patterns,k,l,j,h,P)==1


def coefficients(cut,p,C,P=16):
    i,j,k=[cut[t] for t in ['i','j','k']];h,l=[cut[t] for t in ['h','l']]
    return row([(C[h][i][j],1),(C[l][i][k],1),(p[i],-1)],0,'ineq')


def model_constraint(cuts,p,C,P=16):
    import cvxpy as cp
    from scipy.sparse import coo_matrix
    N=int(p.size);ri=[];ci=[];values=[]
    for r,cut in enumerate(cuts):
        i,j,k=[cut[t] for t in ['i','j','k']];h,l=[cut[t] for t in ['h','l']]
        ri.append(r);ci.append(i);values.append(-1)
        for shift,b in [(h,j),(l,k)]:
            a=i
            if shift>P//2:shift=P-shift;a,b=b,a
            ri.append(r);ci.append(N+shift*N*N+a+N*b);values.append(1)
    A=coo_matrix((values,(ri,ci)),shape=(len(cuts),N+(P//2+1)*N*N)).tocsr();v=cp.hstack([p]+[cp.vec(C[h],order='F') for h in range(P//2+1)])
    return A@v<=0
