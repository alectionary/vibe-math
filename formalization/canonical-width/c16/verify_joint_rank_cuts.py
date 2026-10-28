#!/usr/bin/env python3
"""Physical/cyclic-polynomial consumer of the91125 bounded joint-rank cuts."""
from pathlib import Path
import argparse
import collections
from fractions import Fraction
import gzip
import itertools
import json
import time

ROOT=Path(__file__).resolve().parent


def rank(rows):
    piv={}
    for v in rows:
        while v:
            p=v&-v
            if p not in piv:
                piv[p]=v
                break
            v^=piv[p]
    return len(piv)


def cyclic_rank(p,n=16):
    if not p:
        return 0
    # f(1+epsilon), using binomial coefficients modulo2 directly.
    jet=0
    for h in range(n):
        if p>>h&1:
            for k in range(n):
                if k&~h==0:
                    jet^=1<<k
    return n-((jet&-jet).bit_length()-1)


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    start=time.monotonic()
    from audit_pools import exchange
    from verify_partial_frame import mask,shift
    source=json.loads((ROOT/'physical-pool-source.json').read_text())
    Z=[shift(mask(seed),h) for seed in source['Z_orbit_representatives'] for h in range(16)]
    X=list(map(exchange,Z))
    pat=[[sum(((X[16*i]&Z[16*j+h]).bit_count()%2)<<h for h in range(16)) for j in range(45)] for i in range(45)]
    ranks=[[cyclic_rank(p) for p in row] for row in pat]
    d=json.loads(gzip.decompress((ROOT/'structural-results/c16-structural-sdp-certified.rational.json.gz').read_bytes()))
    C={int(h):[[Fraction(v) for v in row] for row in M] for h,M in d['C'].items()}
    for h in range(9,16):C[h]=list(map(list,zip(*C[16-h])))
    weight=[[16*sum((C[h][i][45+j] for h in range(16) if pat[i][j]>>h&1),Fraction(0)) for j in range(45)] for i in range(45)]
    ix={x:i for i,x in enumerate(X)};iz={z:i for i,z in enumerate(Z)}
    partial=json.loads((ROOT/'partial-frame-88.json').read_text())
    pairs=[(ix[mask(c['X'])]//16,iz[mask(c['Z'])]//16) for c in partial['pairs']]
    assert len(pairs)==88
    counts=collections.Counter(pairs)
    hist=collections.Counter();tested=0;minimum=None;nonzero=None
    for i in range(45):
        for k in [1,2]:
            for J in itertools.combinations(range(45),k):
                # Circulant images are ideals in F2[epsilon]/epsilon^16,
                # hence nested; concatenated rank is the maximum block rank.
                checks=[(max(ranks[i][j] for j in J),sum((weight[i][j] for j in J),Fraction(0)),sum(counts[i,j] for j in J))]
                if k==2:
                    checks.append((max(ranks[j][i] for j in J),sum((weight[j][i] for j in J),Fraction(0)),sum(counts[j,i] for j in J)))
                for R,mass,physical in checks:
                    assert physical<=R and mass<=R
                    hist[R]+=1;tested+=1
                    slack=R-mass
                    minimum=slack if minimum is None else min(minimum,slack)
                    if R:nonzero=slack if nonzero is None else min(nonzero,slack)
    old=json.loads((ROOT/'joint-cover-results/joint-rank-screen.json').read_text())
    assert tested==old['tested_cuts']==91125
    assert dict(hist)=={int(k):v for k,v in old['rank_histogram'].items()}
    assert old['violated_cut_count']==0 and minimum==Fraction(old['minimum_slack'])
    # Literal finite controls for the local-ring rank formula, in period4.
    literal=0
    for p in range(16):
        for q in range(16):
            rows=[sum(((p>>(j-i)%4)&1)<<j for j in range(4)) | (sum(((q>>(j-i)%4)&1)<<j for j in range(4))<<4) for i in range(4)]
            assert rank(rows)==max(cyclic_rank(p,4),cyclic_rank(q,4));literal+=1
    result={'status':'PASS','source_C16_answered':False,'joint_rank_cuts_independently_rechecked':tested,'physical88_occupancy_controls':tested,
            'rank_method':'Multiplicity at t=1 via exact binomial substitution; nested ideals give rank of concatenated circulants.',
            'minimum_exact_slack':str(minimum),'minimum_slack_among_positive_rank_cuts':str(nonzero),
            'small_literal_two_circulant_controls':literal,'violated_cut_count':0,
            'scope':old['scope'],'elapsed_seconds':time.monotonic()-start}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(f'PASS: {tested} joint rank cuts, physical88 controls, {literal} literal polynomial controls; no separation.',flush=True)


if __name__=='__main__':main()
