#!/usr/bin/env python3
"""Select a mandatory new matrix identity from a checked spurious partial frame.

For any partial dual frame S=sum x_i z_i^T is a rank-m projector. If m<128,
I-S is nonzero. The selected witness provably rejects the saved partial frame;
no claim that adding it solves the anchored full-frame completion follows.
"""
from pathlib import Path
import argparse
import json
import time

ROOT=Path(__file__).resolve().parent


def rank(vs):
    piv={}
    for v in vs:
        while v:
            k=v.bit_length()
            if k not in piv:piv[k]=v;break
            v^=piv[k]
    return len(piv)


def outer(x,z):
    return sum(z << (128*i) for i in range(128) if x>>i&1)


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    folder=ROOT/'matrix-witness-results';X,Z=[[int(s,16) for s in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in ['x','z']]
    c=json.loads((folder/'conditional-signature-screen.json').read_text())['records'][0];pairs=c['partial_matching'];m=len(pairs)
    S=[0]*128
    for i,j in pairs:
        for bit in range(128):
            if X[i]>>bit&1:S[bit]^=Z[j]
    R=[s^(1<<i) for i,s in enumerate(S)]
    assert rank(S)==m and rank(R)==128-m
    for M in [S,R]:
        for row in M:
            square=0
            for j in range(128):
                if row>>j&1:square^=M[j]
            assert square==row
    old=json.loads((ROOT/'joint-cover-results/source-witness-cover.json').read_text())
    found=None
    for w in sorted(old['witness_costs'],key=lambda w:(w['case_count'],w['u_X_index'],w['v_Z_index'])):
        for h in range(16):
            u=16*(w['u_X_index']//16)+(w['u_X_index']+h)%16;v=16*(w['v_Z_index']//16)+(w['v_Z_index']+h)%16
            value=sum(((X[u]&Z[j]).bit_count()%2)*((X[i]&Z[v]).bit_count()%2) for i,j in pairs)%2
            if value!=1:found=(u,v,h,value,w);break
        if found:break
    assert found is not None
    u,v,h,value,w=found
    before=[outer(Z[608+t],X[608+t]) for t in range(16)]
    after=before+[outer(Z[16*(v//16)+(v+t)%16],X[16*(u//16)+(u+t)%16]) for t in range(16)]
    result={'status':'PASS','source_C16_answered':False,'anchor':{'id':c['id'],'X_index':c['X_index'],'Z_index':c['Z_index']},'partial_matching':pairs,'partial_rank':m,'residual_rank':128-m,'residual_rows_hex':[hex(r) for r in R],'new_witness':{'u_X_index':u,'v_Z_index':v,'expected_full_basis_value':1,'saved_partial_value':value,'source_witness_orbit_cover_count':w['case_count']},'old_functional_span_rank':rank(before),'new_functional_span_rank':rank(after),'next_solver_gate':'Unrun: add the16 translated identities from this new witness to a fixed-anchor model, retaining all new nonzero-signature source edges. Seek a checked obstruction or physical128-frame within a bounded comparison.','scope':'A checked separation of this saved partial matching, not an exclusion of the anchor or a reduced cover.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print('Selected source witness',u,v,'rank',result['old_functional_span_rank'],'->',result['new_functional_span_rank'],'rejects partial rank',m,flush=True)


if __name__=='__main__':main()
