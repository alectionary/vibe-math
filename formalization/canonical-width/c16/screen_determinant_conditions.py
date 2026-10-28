#!/usr/bin/env python3
"""Exact bounded necessary two-pair determinant tests for518 fixed anchors.

After fixing(x0,z0), residual pairs obey H_rs=beta(u_r,v_s)+
beta(u_r,z0)beta(x0,v_s)=sum_e a_r(e)b_s(e). If a2x2 minor is1,
Cauchy--Binet forces a compatible two-edge minor term1. This tests existence
for each minor separately, not simultaneous consistency of all minor equations.
"""
from pathlib import Path
import argparse
import gzip
import itertools
import json
import time

ROOT=Path(__file__).resolve().parent


def bits(v):
    while v:
        b=v&-v;v^=b;yield b.bit_length()-1


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    X,Z=[[int(s,16) for s in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in ['x','z']]
    A=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X]
    cols=[sum(((row>>j)&1)<<i for i,row in enumerate(A)) for j in range(720)]
    allbits=(1<<720)-1
    U=X[608:624];V=Z[608:624]
    avalues=[[((u&z).bit_count()%2) for z in Z] for u in U]
    bvalues=[[((x&v).bit_count()%2) for x in X] for v in V]
    Gram=[[((u&v).bit_count()%2) for v in V] for u in U]
    minors=[]
    for r,s in itertools.combinations(range(16),2):
        at=[avalues[r][j]+2*avalues[s][j] for j in range(720)]
        bt=[bvalues[r][i]+2*bvalues[s][i] for i in range(720)]
        amask=[sum((at[j]==c)<<j for j in range(720)) for c in range(4)]
        bmask=[sum((bt[i]==c)<<i for i in range(720)) for c in range(4)]
        minors.append((r,s,at,bt,[sum(amask[d] for d in range(1,4) if d!=c) for c in range(4)],[sum(bmask[d] for d in range(1,4) if d!=c) for c in range(4)]))
    cases=json.loads((ROOT/'joint-cover-results/source-witness-cover.json').read_text())['cases']
    checked=0;records=[];excluded=[]
    for index,c in enumerate(cases):
        x0,z0=c['X_index'],c['Z_index'];Lm=allbits^cols[z0];Rm=allbits^A[x0]
        H=[[Gram[r][s]^(avalues[r][z0]*bvalues[s][x0]) for s in range(16)] for r in range(16)]
        witnesses=[]
        for r,s,at,bt,za,xb in minors:
            det=(H[r][r]*H[s][s])^(H[r][s]*H[s][r])
            if not det:continue
            found=None
            for i in bits(Lm&xb[0]):
                for j in bits(A[i]&Rm&za[0]):
                    kset=Lm&xb[bt[i]]&~cols[j]
                    lset=Rm&za[at[j]]&~A[i]
                    for k in bits(kset):
                        options=A[k]&lset
                        if options:
                            l=(options&-options).bit_length()-1;found=[i,j,k,l];break
                    if found:break
                if found:break
            checked+=1
            if not found:
                excluded.append({'case':c['id'],'minor':[r,s]})
            else:witnesses.append([r,s]+found)
        records.append({'id':c['id'],'X_index':x0,'Z_index':z0,'two_edge_minor_witnesses':witnesses})
        if index%100==0:print(index,'anchors;',checked,'nonzero principal minors;',len(excluded),'failed existence tests;',time.monotonic()-start,'seconds',flush=True)
    result={'status':'PASS','source_C16_answered':False,'witness_source_indices':list(range(608,624)),'anchor_cases':len(cases),'principal_minors_per_anchor':120,'nonzero_minor_conditions_tested':checked,'excluded_anchor_cases':excluded,'records':records,'scope':'Each of120 principal2x2 minors from16 translated witness pairs, for every518 anchor. Existence tested separately. No assertion of simultaneous determinant feasibility, a larger frame, or a complete exterior-square relaxation.','elapsed_seconds':time.monotonic()-start}
    a.output.write_bytes(gzip.compress(json.dumps(result,separators=(',',':')).encode()+b'\n',mtime=0))
    print('PASS:',checked,'conditional minor existence tests,',len(excluded),'excluded anchors',flush=True)


if __name__=='__main__':main()
