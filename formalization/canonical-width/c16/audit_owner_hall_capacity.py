#!/usr/bin/env python3
"""Small exact Hall/capacity controls; no LP and no large physical search."""
import os
assert os.nice(0) == 19
for key in ['OPENBLAS_NUM_THREADS', 'OMP_NUM_THREADS', 'MKL_NUM_THREADS',
            'VECLIB_MAXIMUM_THREADS', 'NUMEXPR_NUM_THREADS', 'BLIS_NUM_THREADS']:
    assert os.environ.get(key) == '1'
from fractions import Fraction as Q
from itertools import combinations, permutations
from pathlib import Path
import argparse
import hashlib
import json
import time

ROOT = Path(__file__).resolve().parent
def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def dot(x, z): return (x & z).bit_count() % 2
def rank(values):
    rows = {}
    for v in values:
        while v:
            p = v & -v
            if p in rows: v ^= rows[p]
            else: rows[p] = v; break
    return len(rows)
def subsets(values):
    return ([v for j, v in enumerate(values) if mask >> j & 1]
            for mask in range(1 << len(values)))

def controls():
    totals = dict(full_basis_pairs=0, deterministic_hall_checks=0,
                  orthogonal_rank_checks=0, anchor_compatible_basis_pairs=0,
                  forced_matching_edge_checks=0)
    for n in [2, 3]:
        ground = list(range(1, 1 << n))
        bases = [B for B in combinations(ground, n) if rank(B) == n]
        for S in subsets(ground):
            C = [z for z in ground if not any(dot(x, z) for x in S)]
            assert rank(S)+rank(C) <= n
            totals['orthogonal_rank_checks'] += 1
        for B in bases:
            for C in bases:
                matches = [list(zip(B, perm)) for perm in permutations(C)
                           if all(dot(x, z) for x, z in zip(B, perm))]
                assert matches
                totals['full_basis_pairs'] += 1
                for S in subsets(B):
                    N = {z for z in C if any(dot(x, z) for x in S)}
                    assert len(S) <= len(N)
                    totals['deterministic_hall_checks'] += 1
                # Fixed X anchor1 and Z anchor2, with domain-required unique owners.
                if 1 in B and 2 in C and sum(dot(1, z) for z in C) == 1 and sum(dot(x, 2) for x in B) == 1:
                    totals['anchor_compatible_basis_pairs'] += 1
                    for matching in matches:
                        for x, z in matching:
                            assert not (x != 1 and dot(1, z))
                            assert not (z != 2 and dot(x, 2))
                            totals['forced_matching_edge_checks'] += 1
        if n == 3:
            lam = Q(3, 7)
            Xlaw = [(bases[0], Q(1, 3)), (bases[-1], Q(2, 3))]
            Zlaw = [(bases[1], Q(1, 4)), (bases[-2], Q(3, 4))]
            x = {v: lam*sum(w for B, w in Xlaw if v in B) for v in ground}
            z = {v: lam*sum(w for B, w in Zlaw if v in B) for v in ground}
            flow = {(i, j): Q(0) for i in ground for j in ground}
            for B, bx in Xlaw:
                for C, cz in Zlaw:
                    matching = next(zip(B, p) for p in permutations(C) if all(dot(i, j) for i, j in zip(B, p)))
                    for i, j in matching: flow[i, j] += lam*bx*cz
            assert all(sum(flow[i, j] for j in ground) == x[i] for i in ground)
            assert all(sum(flow[i, j] for i in ground) == z[j] for j in ground)
            assert all(v >= 0 and (not v or dot(i, j)) for (i, j), v in flow.items())
            fractional = 0
            for S in subsets(ground):
                N = {j for j in ground if any(dot(i, j) for i in S)}
                assert sum(x[i] for i in S) <= lam*rank(S)
                assert sum(z[j] for j in S) <= lam*rank(S)
                assert sum(x[i] for i in S) <= sum(z[j] for j in N)
                fractional += 1
            totals['fractional_rank_and_hall_subset_checks'] = fractional
            totals['fractional_flow'] = [[i, j, str(v)] for (i, j), v in flow.items() if v]
    # Full bases can have an ordinary owner matching while Frechet is impossible.
    B, C = [1, 2], [1, 3]
    assert rank(B) == rank(C) == 2
    edges = [(i, j) for i in B for j in C if dot(i, j)]
    assert edges == [(1, 1), (1, 3), (2, 3)]
    assert all(dot(i, j) for i, j in [(1, 1), (2, 3)])
    assert sum(1 for i, j in edges if i == 1) == 2
    totals['deterministic_frechet_obstruction'] = dict(X=B, Z=C, ordinary_matching=[[1, 1], [2, 3]],
                                                     required_first_row_minimum=2, first_row_owner_total=1)
    # Capacity source truth table: a selected vertex has at most one selected owner.
    assignments = []
    for vertex in [0, 1]:
        for a in [0, 1]:
            for b in [0, 1]:
                if vertex and a+b > 1: continue
                assert vertex*a+vertex*b <= vertex
                assignments.append([vertex, a, b])
    totals['capacity_valid_binary_assignments'] = assignments
    X, Z = [[int(v, 16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
    centers = {'X': [614, 281], 'Z': [51, 83]}
    commonX = [i for i in range(720) if i not in centers['X'] and all(dot(X[i], Z[j]) for j in centers['Z'])]
    commonZ = [j for j in range(720) if j not in centers['Z'] and all(dot(X[i], Z[j]) for i in centers['X'])]
    design = json.loads((ROOT/'two-basis-results/owner-star-capacity-design.json').read_text())
    assert commonX == design['common_unchosen_X'] and commonZ == design['common_unchosen_Z']
    assert len(commonX) == 74 and len(commonZ) == 9
    assert 16*(len(commonX)+len(commonZ)) == design['raw_capacity_rows'] == 1328
    totals['physical_common_unchosen_vertices'] = {'X': len(commonX), 'Z': len(commonZ)}
    totals['capacity_rows'] = 1328
    return totals

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--output', type=Path, required=True)
    a = ap.parse_args(); assert not a.output.exists(); started = time.monotonic()
    source_paths = [Path(__file__).resolve(), ROOT/'OWNER-HALL-CAPACITY-REVIEW.md',
                    ROOT/'two_basis_owner_star_capacity.py', ROOT/'export_owner_star_capacity_lp.py',
                    ROOT/'two-basis-results/owner-star-capacity-design.json', ROOT/'pools/xcoords.txt', ROOT/'pools/zcoords.txt']
    hashes = {str(p.relative_to(ROOT)): sha(p) for p in source_paths}
    out = dict(status='PASS_EXACT_ORDINARY_HALL_AND_CAPACITY_CONTROLS', controls=controls(),
               source_hashes=hashes, no_LP_solve=True, source_C16_answered=False,
               priority=os.nice(0), elapsed_seconds=time.monotonic()-started)
    assert all(sha(ROOT/p) == h for p, h in hashes.items())
    a.output.write_text(json.dumps(out, indent=2)+'\n')
    print(out['status'], out['elapsed_seconds'], flush=True)

if __name__ == '__main__': main()
