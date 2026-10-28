#!/usr/bin/env python3
"""Literal small controls for proof encodings, affine closure and parity logs."""
from pathlib import Path
import argparse
import itertools
import json
import time
from signature_cover import encode
from anchored_cover_chain import parity_chains
from exchange_anchored_cover import signature_amo
from verify_signature_cover import independent_cnf
from verify_anchored_cover_chain import independent_signature_amo
from affine_signature_closure import closure
from check_native_parity_proof import check


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();graphs=assignments=closure_runs=0
    for cells in itertools.product(range(6),repeat=4):
        #0 no source edge;1 source edge omitted;2..5 candidate signature0..3.
        A=[sum((cells[2*i+j]!=0)<<j for j in range(2)) for i in range(2)];E=[(i,j,cells[2*i+j]-2,0) for i in range(2) for j in range(2) if cells[2*i+j]>=2]
        valid=[]
        for mask in range(1<<len(E)):
            chosen=[k for k in range(len(E)) if mask>>k&1];good=True
            for q,k in enumerate(chosen):
                i,j,_,_=E[k]
                for l in chosen[:q]:
                    ii,jj,_,_=E[l]
                    if i==ii or j==jj or A[i]>>jj&1 or A[ii]>>j&1:good=False
            if good:valid.append(chosen)
        for target in range(4):
            exists=[]
            models=[]
            for chosen in valid:
                value=0
                for k in chosen:value^=E[k][2]
                if value==target:models.append(sum(1<<k for k in chosen))
            for compressed,amo in itertools.product([False,True],repeat=2):
                clauses,n,defs,selectors=independent_cnf(A,[0],E,compressed,2,target)
                if amo:n,extra=independent_signature_amo(clauses,n,E);defs+=extra
                actual,nn,_,events=encode(A,[0],E,with_xor=False,compress_signatures=compressed);nn=parity_chains(actual,nn,events,target,2)
                if amo:nn=signature_amo(actual,nn,E)
                assert clauses==actual and n==nn
                any_model=False
                for mask in range(1<<len(E)):
                    chosen=[k for k in range(len(E)) if mask>>k&1];good=chosen in valid
                    unique={E[k][2] for k in chosen};value=0
                    for s in (unique if compressed else [E[k][2] for k in chosen]):value^=s
                    expected=good and value==target and (not amo or len(unique)==len(chosen))
                    values=[False]*(n+1)
                    for k in chosen:values[k+1]=True
                    for v in selectors:values[v]=True
                    for v,op,terms in defs:values[v]=(any(values[q] for q in terms) if op=='or' else bool(sum(values[q] for q in terms)%2))
                    accepted=all(any(values[abs(l)]==(l>0) for l in c) for c in clauses);assert accepted==expected;any_model|=accepted;assignments+=1
                exists.append(any_model)
            assert len(set(exists))==1 and exists[0]==bool(models)
            result=closure(A,[e[:3] for e in E],target,seconds=10,max_passes=20);closure_runs+=1
            for cut in result['proof']:
                if cut[0]==1:assert not any(model>>cut[1]&1 for model in models)
                else:assert not any(model>>cut[1]&1 and model>>cut[2]&1 for model in models)
            if result['outcome']=='UNSAT':assert not models
        graphs+=1
    toy='p xnf 3 3\n1+2 0\n2+3 0\n1+3 0\n';proof='4 0 1 2 3 0\n';assert check(toy,proof)['empty_clause_present']
    negatives=0
    for bad in ['', '4 0 1 2 0\n', '4 1+1 0 1 2 3 0\n']:
        try:check(toy,bad)
        except (AssertionError,ValueError):negatives+=1
        else:raise AssertionError('bad parity proof accepted')
    result={'status':'PASS','source_C16_answered':False,'source_eligibility_and_signature_graphs':graphs,'targets_per_graph':4,'literal_encoder_assignments':assignments,'encoding_variants':'edge XOR/presence XOR, with/without at-most-one per signature','affine_closure_literal_soundness_runs':closure_runs,'parity_proof_positive_controls':1,'parity_proof_negative_controls':negatives,'elapsed_seconds':time.monotonic()-start};a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))


if __name__=='__main__':main()
