#!/usr/bin/env python3
"""Exact source cross-rank cuts on matching-edge moments.

For an induced matching, its selected edges in S x T give an identity minor
of A[S,T]. Therefore sum of their edge indicators <= rank_F2 A[S,T].
Here S,T are unions of full cyclic source orbits. All calculations are exact.
"""
from pathlib import Path
import argparse
import collections
import gzip
import hashlib
import itertools
import json
import time
from fractions import Fraction

ROOT = Path(__file__).resolve().parent


def rank(vs):
    piv = {}
    for v in vs:
        while v:
            k = v.bit_length()
            if k not in piv:
                piv[k] = v
                break
            v ^= piv[k]
    return len(piv)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--max-small-side', type=int, default=2)
    a = ap.parse_args()
    start = time.monotonic()
    X, Z = [[int(s, 16) for s in (ROOT/f'pools/{side}coords.txt').read_text().split()] for side in ['x','z']]
    rows = [sum(((x & z).bit_count()%2) << j for j,z in enumerate(Z)) for x in X]
    path = ROOT/'structural-results/c16-structural-sdp-certified.rational.json.gz'
    d = json.loads(gzip.decompress(path.read_bytes()))
    C = {int(h): [[Fraction(v) for v in row] for row in M] for h,M in d['C'].items()}
    for h in range(9,16):
        C[h] = list(map(list, zip(*C[16-h])))
    weights = [[16*sum((C[h][i][45+j] for h in range(16) if rows[16*i] >> (16*j+h) & 1), Fraction(0)) for j in range(45)] for i in range(45)]
    assert sum(map(sum, weights)) == 128
    masks = [((1<<16)-1) << (16*j) for j in range(45)]
    # Check every singleton x singleton and every singleton x two-orbit union,
    # in both sector orientations. This is a complete, explicitly bounded family.
    choices = [c for k in range(1,a.max_small_side+1) for c in itertools.combinations(range(45),k)]
    cuts = []
    minimum = None
    tested = 0
    ranks = collections.Counter()
    for i in range(45):
        for J in choices:
            mask = sum(masks[j] for j in J)
            R = rank(rows[k] & mask for k in range(16*i,16*i+16))
            mass = sum((weights[i][j] for j in J), Fraction(0))
            slack = R-mass
            tested += 1
            ranks[R] += 1
            if minimum is None or slack < minimum[0]:
                minimum = (slack, [i], list(J), R, mass)
            if slack < 0:
                cuts.append({'X_orbits':[i], 'Z_orbits':list(J),'rank':R,'mass':str(mass),'slack':str(slack)})
            if len(J) > 1:
                # Independent opposite orientation; matrix is symmetric in the
                # source indexing but moments need not have been exchange averaged.
                mask2 = masks[i]
                R2 = rank(rows[k] & mask2 for j in J for k in range(16*j,16*j+16))
                mass2 = sum((weights[j][i] for j in J), Fraction(0))
                slack2 = R2-mass2
                tested += 1
                ranks[R2] += 1
                if minimum is None or slack2 < minimum[0]:
                    minimum = (slack2, list(J), [i], R2, mass2)
                if slack2 < 0:
                    cuts.append({'X_orbits':list(J),'Z_orbits':[i],'rank':R2,'mass':str(mass2),'slack':str(slack2)})
        if i % 5 == 0:
            print(f'orbit {i}/45: {tested} joint rank cuts, {len(cuts)} violations, {time.monotonic()-start:.1f}s',flush=True)
    result = {'status':'PASS','source_C16_answered':False,
              'theorem':'Selected matching edges in S x T are at most rank_F2(A[S,T]); valid for every partial induced matching, hence for full source frames and their averaged moments.',
              'scope':'All singleton-orbit x one-or-two-orbit subsets, and transposes; no larger orbit unions or phase-specific subsets tested.',
              'point_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
              'tested_cuts':tested,'rank_histogram':dict(sorted(ranks.items())),
              'violated_cut_count':len(cuts),'violations':cuts,
              'minimum_slack':str(minimum[0]),'minimum_example':{'X_orbits':minimum[1],'Z_orbits':minimum[2],'rank':minimum[3],'mass':str(minimum[4])},
              'elapsed_seconds':time.monotonic()-start}
    a.output.write_text(json.dumps(result,indent=2)+'\n')
    print(f'PASS: {tested} exact joint rank cuts; {len(cuts)} violations',flush=True)


if __name__ == '__main__':
    main()
