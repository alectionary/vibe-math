#!/usr/bin/env python3
"""Supplement: source cross edges that are absent from the candidate list."""
from pathlib import Path
import hashlib
import itertools
import json
import sys

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT))
from verify_signature_cover import independent_cnf


def main():
    graphs=0;assignments=0
    #0=no source edge;1=source edge outside candidate set;2,3,4=candidate
    # source edge with signature1,2,3. This complements the frozen2x3 controls.
    for cells in itertools.product(range(5),repeat=4):
        A=[sum((cells[2*i+j]!=0)<<j for j in range(2)) for i in range(2)]
        E=[(i,j,cells[2*i+j]-1,0) for i in range(2) for j in range(2) if cells[2*i+j]>=2]
        exists=[]
        for compressed in [False,True]:
            clauses,n,defs,selectors=independent_cnf(A,[0],E,compressed,2,3,{0})
            seen=False
            for mask in range(1<<len(E)):
                chosen=[k for k in range(len(E)) if mask>>k&1]
                good=True
                for a,k in enumerate(chosen):
                    i,j,_,_=E[k]
                    for l in chosen[:a]:
                        x,z,_,_=E[l]
                        if i==x or j==z or A[i]>>z&1 or A[x]>>j&1:good=False
                value=0
                for s in ({E[k][2] for k in chosen} if compressed else [E[k][2] for k in chosen]):value^=s
                expected=good and value==3
                values=[False]*(n+1)
                for k in chosen:values[k+1]=True
                for v in selectors:values[v]=True
                for v,op,terms in defs:values[v]=(any(values[t] for t in terms) if op=='or' else bool(sum(values[t] for t in terms)%2))
                actual=all(any(values[abs(l)]==(l>0) for l in c) for c in clauses)
                assert actual==expected;seen|=actual;assignments+=1
            exists.append(seen)
        assert exists[0]==exists[1];graphs+=1
    result={'status':'PASS','source_C16_answered':False,'source_and_candidate_eligibility_graphs':graphs,'literal_assignments':assignments,'consumer_sha256':hashlib.sha256((ROOT/'verify_signature_cover.py').read_bytes()).hexdigest(),'scope':'Supplemental exhaustive2x2 controls include source cross edges absent from the candidate list. Frozen51-file proof and earlier controls remain unchanged.'}
    print(json.dumps(result,indent=2))


if __name__=='__main__':main()
