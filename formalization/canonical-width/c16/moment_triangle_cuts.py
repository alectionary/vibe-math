#!/usr/bin/env python3
"""Literal Boolean triple inequalities for cyclic selection moments."""
from block_moment_dual import row


def constraint(cut,p,C,P):
    kind=cut['kind'];i,j,k=[cut[t] for t in ['i','j','k']];h,l=[cut[t] for t in ['h','l']]
    assert kind in [0,1] and all(0<=v<len(p) for v in [i,j,k]) and 0<=h<P and 0<=l<P
    a,b,c=C[h][i][j],C[l][i][k],C[(l-h)%P][j][k]
    return row([(a,1),(b,1),(c,-1),(p[i],-1)],0,'ineq') if kind==0 else row([(p[i],1),(p[j],1),(p[k],1),(a,-1),(b,-1),(c,-1)],1,'ineq')


def expression(cut,p,C,P):
    kind=cut['kind'];i,j,k=[cut[t] for t in ['i','j','k']];h,l=[cut[t] for t in ['h','l']]
    a,b,c=C[h][i,j],C[l][i,k],C[(l-h)%P][j,k]
    return a+b-c<=p[i] if kind==0 else p[i]+p[j]+p[k]-a-b-c<=1


def literal_control():
    from itertools import product
    cases=0
    for a,b,c in product([0,1],repeat=3):
        assert a*b+a*c-b*c<=a
        assert a+b+c-a*b-a*c-b*c<=1
        cases+=2
    return {'status':'PASS','Boolean_literal_tests':cases,'scope':'Two valid degree-two inequalities on arbitrary Boolean triples.'}
