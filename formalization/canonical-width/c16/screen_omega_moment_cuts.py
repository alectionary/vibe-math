#!/usr/bin/env python3
"""Exact test of reciprocal-neighbor moment cuts against the saved128 point.

For a full binary dual frame K=U^-1 Omega U and K^2+K+I=0. Its
diagonal equations force every selected pair to have an odd, hence positive,
number of compatible reciprocal auxiliary neighbors. Thus the sum of matching
edge moments over all such neighbors is at least the anchor edge moment.
These are full-dimension necessary cuts; they need not hold for partial frames.
"""
from pathlib import Path
import argparse
import gzip
import hashlib
import json
from flint import fmpq
from verify_pool_inverse_structure import columns,linear

ROOT=Path(__file__).resolve().parent


def bits(v):
    while v:
        b=v&-v;v^=b;yield b.bit_length()-1


def control():
    # Every ordered basis in dimension4, plus dimension2; duals reconstructed
    # independently by literal testing of all covectors.
    cases=0
    def rank(vs):
        p={}
        for v in vs:
            while v:
                k=v.bit_length()-1
                if k not in p:p[k]=v;break
                v^=p[k]
        return len(p)
    def visit(B,n):
        nonlocal cases
        if len(B)<n:
            for v in range(1,1<<n):
                if rank(B+[v])==len(B)+1:visit(B+[v],n)
            return
        Z=[]
        for i in range(n):
            z=[v for v in range(1,1<<n) if all(((v&x).bit_count()%2)==(i==j) for j,x in enumerate(B))]
            assert len(z)==1;Z.append(z[0])
        def omega(v):
            return sum((((v>>(2*j+1))&1)|((((v>>(2*j))^(v>>(2*j+1)))&1)<<1))<<(2*j) for j in range(n//2))
        K=[[((omega(x)&z).bit_count()%2) for x in B] for z in Z]
        for i in range(n):
            degree=sum(K[i][j]*K[j][i] for j in range(n) if i!=j)
            assert degree>=1 and degree%2==1
            cases+=1
    for n in [2,4]:visit([],n)
    return cases


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    normal=json.loads((ROOT/'inversion-results/normal-form.json').read_text())
    O=columns(normal['dictionary']['Omega_original_coordinates'])
    assert all(linear(O,linear(O,1<<i))^linear(O,1<<i)^(1<<i)==0 for i in range(128))
    X=[int(s,16) for s in (ROOT/'pools/xcoords.txt').read_text().split()]
    Z=[int(s,16) for s in (ROOT/'pools/zcoords.txt').read_text().split()]
    A=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X]
    B=[sum(((linear(O,x)&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X]
    # Separate allowed columns and rows: ordinary cross-pairing0, auxiliary1.
    L=[B[i]&~A[i] for i in range(0,720,16)]
    R=[sum((((B[i]>>j)&1) and not((A[i]>>j)&1))<<i for i in range(720)) for j in range(720)]
    point=ROOT/'structural-results/c16-structural-sdp-certified.rational.json.gz'
    d=json.loads(gzip.decompress(point.read_bytes()));C={int(h):[[fmpq(v) for v in row] for row in M] for h,M in d['C'].items()}
    for h in range(9,16):C[h]=list(map(list,zip(*C[16-h])))
    assert len(C[0])==90
    max_edge=max(C[j%16][i//16][45+j//16] for i in range(0,720,16) for j in bits(A[i]))
    assert max_edge<=fmpq(1,2)
    best=None;violated=[];hist={};cases=0
    for a0,lmask in enumerate(L):
        totals=[];degrees=[]
        for k in range(720):
            neighbors=list(bits(A[k]&lmask));degrees.append(len(neighbors))
            totals.append(sum((C[(l%16-k%16)%16][k//16][45+l//16] for l in neighbors),fmpq(0)))
        for j in bits(A[16*a0]):
            ids=list(bits(R[j]));degree=sum(degrees[k] for k in ids)
            slack=sum((totals[k] for k in ids),fmpq(0))-C[j%16][a0][45+j//16]
            cases+=1;hist[degree]=hist.get(degree,0)+1
            if best is None or slack<best[0]:best=(slack,16*a0,j)
            if slack<0:violated.append({'X':16*a0,'Z':j,'slack':str(slack)})
    old=json.loads((ROOT/'inversion-results/omega-screen.json').read_text())
    assert cases==old['pair_orbits']==6238 and min(hist)==old['minimum_auxiliary_degree'] and max(hist)==old['maximum_auxiliary_degree']
    literal=control()
    result={'status':'PASS','source_C16_answered':False,'scope':'All6238 common-translation anchor edge orbits, exact reciprocal-neighbor necessary moment inequalities for full128 frames.',
        'point_sha256':hashlib.sha256(point.read_bytes()).hexdigest(),'tested_anchor_orbits':cases,
        'violated_cut_count':len(violated),'violated_cuts':violated,
        'minimum_exact_slack':str(best[0]),'minimum_slack_anchor':list(best[1:]),
        'neighbor_degree_range':[min(hist),max(hist)],'small_full_basis_vertex_controls':literal,
        'maximum_exact_matching_edge_moment':str(max_edge),
        'conditional_even_subset_parity_cuts':'All satisfied: for an even neighbor subset F, the violation is anchor-sum(neighbors)+sum_F(2*edge_moment-1). Every edge moment<=1/2, so F=empty maximizes it and the tested lower-bound cut suffices.',
        'interpretation':'No separating inequality found at the old rational128 moment point; this family does not by itself repair that relaxation.' if not violated else 'Valid separating cuts found; no global frame exclusion follows without a further exact certificate.',
        'partial_frame_control':'Not applicable: K^2+K+I requires a full basis; no claim that these inequalities hold for physical88.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:result[k] for k in ['status','tested_anchor_orbits','violated_cut_count','minimum_exact_slack','small_full_basis_vertex_controls']}),flush=True)


if __name__=='__main__':main()
