#!/usr/bin/env python3
"""Independent finite local-box/zonotope and exact shared-pattern-law replay.

Does not import the Mobius/zonotope producer. Rational row reduction constructs
the inverse Boolean moment map and complete facet normals independently.
"""
from collections import defaultdict
from fractions import Fraction as Q
from itertools import combinations
from math import gcd, lcm
from pathlib import Path
import argparse
import json
import time
from verify_two_sided_full_basis_oracle import ROOT, sha, read, physical_source, domains, target

SUBSETS = [0, 1, 2, 4, 8, 3, 5, 9, 6, 10, 12, 7, 11, 13, 14, 15]


def rref(rows, columns):
    A = [[Q(v) for v in row] for row in rows]
    assert all(len(row) == columns for row in A)
    pivots = []; r = 0
    for c in range(columns):
        pivot = next((i for i in range(r, len(A)) if A[i][c]), None)
        if pivot is None:
            continue
        A[r], A[pivot] = A[pivot], A[r]
        value = A[r][c]; A[r] = [v/value for v in A[r]]
        for i in range(len(A)):
            if i != r and A[i][c]:
                value = A[i][c]; A[i] = [v-value*w for v, w in zip(A[i], A[r])]
        pivots.append(c); r += 1
        if r == len(A):
            break
    return A, pivots


def qrank(rows, columns):
    return len(rref(rows, columns)[1])


def canonical(v):
    denominator = lcm(*(Q(x).denominator for x in v))
    values = [int(Q(x)*denominator) for x in v]
    divisor = gcd(*values)
    assert divisor
    values = [x//divisor for x in values]
    if next(x for x in values if x) < 0:
        values = [-x for x in values]
    return tuple(values)


def nullspace(rows, columns):
    A, pivots = rref(rows, columns)
    result = []
    for f in range(columns):
        if f in pivots:
            continue
        vector = [Q(0)]*columns; vector[f] = 1
        for i, p in enumerate(pivots):
            vector[p] = -A[i][f]
        result.append(canonical(vector))
    return result


def moment_inverse():
    zeta = [[int(m&s == s) for m in range(16)] for s in SUBSETS]
    augmented = [row+[int(i == j) for j in range(16)] for i, row in enumerate(zeta)]
    reduced, pivots = rref(augmented, 32)
    assert pivots == list(range(16))
    inverse = [row[16:] for row in reduced]
    assert all(sum(inverse[i][j]*zeta[j][k] for j in range(16)) == int(i == k) for i in range(16) for k in range(16))
    return [row[:11] for row in inverse], [row[11:] for row in inverse]


def g(mask):
    return [1]+[(mask >> k) & 1 for k in range(4)]


def class_normals(status, saved):
    generators = [g(m) for m in range(16) if status[m] == 0]
    r = qrank(generators, 5)
    assert saved['rank'] == r
    coords = []
    for j in range(5):
        trial = coords+[j]
        if qrank([[v[k] for k in trial] for v in generators], len(trial)) > len(coords):
            coords.append(j)
    assert saved['coordinates'] == coords and len(coords) == r
    expected = set()
    if r:
        for subset in combinations(generators, r-1):
            projected = [[v[j] for j in coords] for v in subset]
            if qrank(projected, r) != r-1:
                continue
            vector, = nullspace(projected, r)
            lifted = [0]*5
            for j, value in zip(coords, vector):
                lifted[j] = value
            expected.add(canonical(lifted))
    assert set(map(tuple, saved['facet_normals'])) == expected
    assert len(saved['facet_normals']) == len(expected)
    equalities = saved['equality_normals']
    assert len(equalities) == qrank(equalities, 5) == 5-r
    assert all(sum(a*b for a, b in zip(n, v)) == 0 for n in equalities for v in generators)
    return r, len(expected), len(equalities)


def rebuild_statuses(X, Z, xx, zz):
    dd = domains(X, Z, xx, zz)
    assert all(d['feasible'] for d in dd), 'this finite outer candidate requires all16 domains feasible'
    status = [[-1]*16 for _ in range(1440)]
    for d in dd:
        m = d['mask']
        for side, offset in [('X', 0), ('Z', 720)]:
            s = d[side]
            for j in s['forced']:
                status[offset+j][m] = 1
            free = set(s['zero_free']) | {j for b in s['bins'] for j in b if j not in s['forced']}
            for j in free:
                assert status[offset+j][m] == -1
                status[offset+j][m] = 0
    grouped = defaultdict(list)
    for j, values in enumerate(status):
        grouped[tuple(values)].append(j)
    return sorted(grouped.items())


def verify(candidate, point):
    start = time.monotonic(); bank = read(candidate)
    assert bank['status'] == 'EXACT_OUTER_FEASIBLE' and bank['point_sha256'] == sha(point)
    assert all(sha(ROOT/p) == h for p, h in bank['source_hashes'].items())
    frozen = candidate.with_suffix('.frozen.json'); assert bank['frozen_sha256'] == sha(frozen)
    declaration = read(frozen)
    for key in ('point_sha256', 'X_anchors', 'Z_anchors', 'source_hashes', 'high_moment_subsets'):
        assert bank[key] == declaration[key]
    assert bank['high_moment_subsets'] == SUBSETS[11:]
    X, Z, bridge = physical_source(); xx, zz = bank['X_anchors'], bank['Z_anchors']
    wanted = target(point, xx, zz)
    assert list(map(Q, bank['exact_target'])) == wanted
    low = wanted[:11]; L, C = moment_inverse()
    base = [sum(a*b for a, b in zip(row, low)) for row in L]
    solution = bank['solution']; tau = list(map(Q, solution['high_moments'])); margin = Q(solution['exact_margin'])
    lam = [v+sum(a*b for a, b in zip(row, tau)) for v, row in zip(base, C)]
    assert min(lam) >= 0 and sum(lam) == 1 and lam == list(map(Q, bank['lambda_masses']))
    assert all(sum(lam[m] for m in range(16) if m&s == s) == value for s, value in zip(SUBSETS, low+tau))
    seed_path = candidate.with_suffix('.lambda.json'); assert bank['lambda_seed_sha256'] == sha(seed_path)
    seed = read(seed_path); assert list(map(Q, seed['lambda_masses'])) == lam and seed['point_sha256'] == sha(point)
    groups = rebuild_statuses(X, Z, xx, zz)
    assert len(groups) == len(bank['classes'])
    reconstructed = []
    def append(kind, h, terms, **metadata):
        left = sum((Q(v)*wanted[j] for j, v in terms), Q(0))
        a = [-sum(h[m]*C[m][j] for m in range(16)) for j in range(5)]
        b = sum(h[m]*base[m] for m in range(16))-left
        reconstructed.append(dict(kind=kind, h=h, feature_terms=terms, a=a, b=b, **metadata))
    for m in range(16):
        append('lambda_nonnegative', [int(j == m) for j in range(16)], [], mask=m)
    facets = equalities = literal_vector_bounds = 0
    for cid, ((status, indices), saved) in enumerate(zip(groups, bank['classes'])):
        assert saved['class'] == cid and saved['status'] == list(status) and saved['indices'] == indices
        r, fn, en = class_normals(status, saved); facets += fn; equalities += en
        for kind, normals in [('facet', saved['facet_normals']), ('equality', saved['equality_normals'])]:
            for normal in normals:
                for sign in (1, -1):
                    v = [sign*x for x in normal]
                    h = []
                    for m in range(16):
                        score = sum(a*b for a, b in zip(v, g(m)))
                        h.append(score if status[m] == 1 else max(0, score) if status[m] == 0 else 0)
                    rhs = sum(a*b for a, b in zip(h, lam)); values = []
                    for j in indices:
                        indices5 = [11+j]+[1451+1440*k+j for k in range(4)]
                        left = sum(Q(a)*wanted[col] for a, col in zip(v, indices5))
                        assert left <= rhs
                        values.append(left); literal_vector_bounds += 1
                    chosen = indices[values.index(max(values))]
                    terms = [[11+chosen if k == 0 else 1451+1440*(k-1)+chosen, v[k]] for k in range(5) if v[k]]
                    append(kind, h, terms, **{'class':cid, 'vector':chosen, 'normal':v})
    assert len(reconstructed) == len(bank['rows'])
    for row, saved in zip(reconstructed, bank['rows']):
        normalized = dict(saved, b=Q(saved['b']), a=list(map(Q, saved['a'])))
        assert row == normalized
        assert sum(a*b for a, b in zip(row['a'], tau)) <= row['b']
        if any(row['a']):
            assert sum(a*b for a, b in zip(row['a'], tau))+margin <= row['b']
        else:
            assert row['b'] >= 0
    indices = solution['dual_indices']; z = list(map(Q, solution['dual_weights']))
    assert len(indices) == len(set(indices)) == len(z) and min(z) >= 0 and sum(z) == 1
    assert all(any(reconstructed[i]['a']) for i in indices)
    assert all(sum(weight*reconstructed[i]['a'][j] for i, weight in zip(indices, z)) == 0 for j in range(5))
    assert sum(weight*reconstructed[i]['b'] for i, weight in zip(indices, z)) == margin == Q(solution['exact_combined_rhs'])
    active = solution['primal_active_rows']
    assert len(active) == 6 and qrank([reconstructed[i]['a']+[1] for i in active], 6) == 6
    assert all(sum(a*b for a, b in zip(reconstructed[i]['a'], tau))+margin == reconstructed[i]['b'] for i in active)
    return dict(status='PASS_EXACT_LOCAL_BOX_PATTERN_LAW_ONLY', source_C16_answered=False,
                candidate_sha256=sha(candidate), frozen_sha256=sha(frozen), lambda_seed_sha256=sha(seed_path), point_sha256=sha(point),
                producer_source_hashes=bank['source_hashes'], physical_symmetry_bridge=bridge,
                X_anchors=xx, Z_anchors=zz, complete_status_classes=len(groups), vectors_partitioned=sum(len(v) for k, v in groups),
                facet_normals_independently_enumerated=facets, annihilator_normals_checked=equalities,
                compressed_rows_checked=len(reconstructed), individual_vector_support_bounds_checked=literal_vector_bounds,
                exact_margin=str(margin), margin_scope='Nonconstant five-higher-moment rows only; zero-coefficient tautologies/equalities are checked separately.',
                exact_primal_dual_optimum_checked=True, lambda_masses=list(map(str, lam)),
                full_cardinality_or_rank_membership_claimed=False, elapsed_seconds=time.monotonic()-start,
                scope='Exact membership in individual conditional boxes with shared anchor-pattern law. Bucket cardinalities, both sector matroid ranks and unanchored mutual pairing remain omitted.')


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--candidate', type=Path, required=True); ap.add_argument('--point', type=Path, required=True); ap.add_argument('--output', type=Path, required=True)
    a = ap.parse_args(); assert not a.output.exists(); out = verify(a.candidate, a.point)
    out['consumer_sha256'] = sha(__file__); out['physical_consumer_sha256'] = sha(ROOT/'verify_two_sided_full_basis_oracle.py')
    a.output.write_text(json.dumps(out, indent=2)+'\n')
    print(json.dumps({k:v for k,v in out.items() if k not in ('producer_source_hashes','lambda_masses')}, indent=2), flush=True)


if __name__ == '__main__':
    main()
