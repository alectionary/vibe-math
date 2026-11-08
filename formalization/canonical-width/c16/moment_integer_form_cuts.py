#!/usr/bin/env python3
"""Valid degree-two cuts from S(S-1)>=0 for integer affine Boolean forms."""
from itertools import product
from block_moment_dual import row


def coefficients(cut,p,C,P=16):
    events=cut['events'];weights=cut['weights'];c=cut['constant'];assert type(c) is int and len(events)==len(weights) and all(type(b) is int for b in weights) and all(type(v) is int and 0<=v<len(p)*P for v in events)
    terms=[]
    for i,(v,b) in enumerate(zip(events,weights)):
        a,h=divmod(v,P);terms.append((p[a],-(c*b+b*(b-1)//2)))
        for w,d in zip(events[:i],weights[:i]):
            j,k=divmod(w,P);terms.append((C[(h-k)%P][j][a],-b*d))
    return row(terms,c*(c-1)//2,'ineq')


def expression(cut,p,C,P=16):
    events=cut['events'];weights=cut['weights'];c=cut['constant'];v=0
    for i,(event,b) in enumerate(zip(events,weights)):
        a,h=divmod(event,P);v-=(c*b+b*(b-1)//2)*p[a]
        for event2,d in zip(events[:i],weights[:i]):
            j,k=divmod(event2,P);v-=b*d*C[(h-k)%P][j,a]
    return v<=c*(c-1)//2


def literal_control(cut):
    assert len(cut['events'])<=12
    n=0
    for x in product([0,1],repeat=len(cut['events'])):
        S=cut['constant']+sum(a*b for a,b in zip(x,cut['weights']));assert S*(S-1)>=0;n+=1
    return n
