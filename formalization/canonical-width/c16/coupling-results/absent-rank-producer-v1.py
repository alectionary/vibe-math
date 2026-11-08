#!/usr/bin/env python3
"""Bounded full-pool matroid separation conditional on anchor absence.

For anchor a absent, same-sector selected vectors form a basis in the pool
with a deleted; the opposite sector still forms an ordinary source-pool basis.
Every saved inequality is

  sum_(j in K) (p_j - B[a,j]) <= rank(K) (1-p_a),

where the same-sector K excludes a. Numerical projection only proposes K.
An exact point evaluation and an independent physical-rank replay are required.
"""
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter
import argparse, gzip, hashlib, json, time
import numpy as np
from scipy.sparse import coo_matrix
from certify_profile_moment_point import layout
from weighted_matroid_separator import separate, insert

ROOT = Path(__file__).resolve().parent
VARIABLES = 45 + 18 * 2025


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def rank(vectors):
    pivots = {}
    for value in vectors:
        insert(pivots, value)
    return len(pivots)


def closure(vectors, indices, available):
    pivots = {}
    for j in indices:
        insert(pivots, vectors[j])
    def inside(value):
        while value:
            pivot = value.bit_length() - 1
            if pivot not in pivots:
                return False
            value ^= pivots[pivot]
        return True
    return [j for j in available if inside(vectors[j])], len(pivots)


def owner_coordinate(side, h, i, j):
    if side == 'S' and h == 0 and i == j:
        return i
    if h > 8:
        h, i, j = 16 - h, j, i
    if h in (0, 8) and i > j:
        i, j = j, i
    return 45 + (0 if side == 'S' else 9 * 2025) + 2025 * h + 45 * i + j


def row_terms(cut):
    """Canonical owner coordinates for M @ owner_vector <= rank(K)."""
    anchor, side, bound = cut['anchor_orbit'], cut['sector'], cut['bound']
    terms = Counter({anchor: bound})
    for j in cut['indices']:
        terms[j // 16] += 1
        terms[owner_coordinate(side, j % 16, anchor, j // 16)] -= 1
    return sorted((j, c) for j, c in terms.items() if c), bound


def matrix(certificates, replays):
    """Return integer CSR, integer RHS, metadata; consume matching PASS receipts."""
    assert len(certificates) == len(replays)
    ii, jj, vv, rhs, metadata = [], [], [], [], []
    for certificate, replay in zip(certificates, replays):
        d = json.loads(Path(certificate).read_text())
        r = json.loads(Path(replay).read_text())
        assert d['status'] == 'CANDIDATE_ABSENT_RANK_CUTS'
        assert r['status'] == 'PASS' and r['bank_sha256'] == sha(certificate)
        assert r['cuts_checked'] == len(d['cuts']) and r['anchor_condition_value'] == 0
        for k, cut in enumerate(d['cuts']):
            terms, bound = row_terms(cut)
            row = len(rhs)
            for j, c in terms:
                ii.append(row); jj.append(j); vv.append(c)
            rhs.append(bound)
            metadata.append({'certificate': str(certificate), 'certificate_sha256': sha(certificate),
                'independent_replay': str(replay), 'independent_replay_sha256': sha(replay),
                'cut_index': k, 'anchor_condition_value': 0,
                'inequality': 'M @ owner_vector <= rhs', 'sector': cut['sector'], 'anchor_orbit': cut['anchor_orbit']})
    M = coo_matrix((np.asarray(vv, dtype=np.int64), (ii, jj)), shape=(len(rhs), VARIABLES), dtype=np.int64).tocsr()
    return M, np.asarray(rhs, dtype=np.int64), metadata


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--iterations', type=int, default=600)
    ap.add_argument('--seconds', type=float, default=600)
    ap.add_argument('--anchors', nargs='+', type=int, default=list(range(45)))
    ap.add_argument('--sectors', nargs='+', choices=['S', 'T'], default=['S', 'T'])
    ap.add_argument('--seed-banks', nargs='*', type=Path, default=[])
    ap.add_argument('--output', type=Path, required=True)
    a = ap.parse_args()
    start = time.monotonic()
    hp = ROOT / 'algebraic-results/hulls-16-rank.json.gz'
    frozen = {'status': 'FROZEN_BEFORE_ABSENT_RANK_PROBE', 'point_sha256': sha(a.point),
        'producer_sha256': sha(Path(__file__)), 'basis_separator_sha256': sha(ROOT / 'weighted_matroid_separator.py'),
        'hulls_sha256': sha(hp), 'pool_sha256': {s: sha(ROOT / f'pools/{s}coords.txt') for s in 'xz'},
        'physical_source_sha256': sha(ROOT / 'physical-pool-source.json'),
        'seed_banks': {str(p): sha(p) for p in a.seed_banks},
        'anchors': a.anchors, 'sectors': a.sectors, 'anchor_condition_value': 0,
        'iterations_per_query': a.iterations, 'outer_seconds': a.seconds,
        'scope': 'Bounded separation only; nonseparation does not certify a complete conditional basis decomposition.'}
    a.output.with_suffix('.frozen.json').write_text(json.dumps(frozen, indent=2) + '\n')
    hulls = json.loads(gzip.decompress(hp.read_bytes()))
    _, index, moment = layout(hulls)
    v = list(map(Q, json.loads(gzip.decompress(a.point.read_bytes()))['values']))
    p = [v[index['p', o]] for o in range(45)]
    assert sum(p) * 16 == 128
    pools = [[int(x, 16) for x in (ROOT / f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
    assert all(rank(U) == 128 for U in pools)
    seed_sets = sorted({tuple(c['indices']) for path in a.seed_banks for c in json.loads(path.read_text())['cuts']})
    seed_ranks = [[rank(U[j] for j in ids) for ids in seed_sets] for U in pools]
    cuts, records = [], []
    for side in a.sectors:
        U = pools[0 if side == 'S' else 1]
        for anchor in a.anchors:
            if time.monotonic() - start > a.seconds:
                break
            assert 0 <= anchor < 45 and 0 <= p[anchor] < 1
            normalizer = 1 - p[anchor]
            numerators = [p[j // 16] - v[moment(side, j % 16, anchor, j // 16)] for j in range(720)]
            assert all(0 <= x <= normalizer for x in numerators)
            assert sum(numerators) == 128 * normalizer
            deleted = 16 * anchor if side == 'S' else None
            if deleted is not None:
                assert numerators[deleted] == 0
            available = [j for j in range(720) if j != deleted]
            assert rank(U[j] for j in available) == 128
            x = np.array([float(q / normalizer) for q in numerators])
            proposed = None
            if seed_sets:
                ranks = seed_ranks[0 if side == 'S' else 1]
                violations = [sum(x[list(ids)]) - r for ids, r in zip(seed_sets, ranks)]
                best = int(np.argmax(violations))
                if violations[best] > 1e-6:
                    proposed = [j for j in seed_sets[best] if j != deleted]
                    diag = {'cut_found': True, 'method': 'saved_subset_absence_screen', 'seed_index': best,
                        'seed_normalized_violation': float(violations[best]), 'seed_subsets_screened': len(seed_sets)}
            if proposed is None:
                found, diag = separate([U[j] for j in available], x[available], mandatory=None,
                                       iterations=a.iterations, tolerance=1e-6)
                diag['method'] = 'greedy_basis_projection_on_deletion_or_whole_pool'
                diag['seed_subsets_screened'] = len(seed_sets)
                if found is not None:
                    proposed = [available[j] for j in found['indices']]
            record = {'sector': side, 'anchor_orbit': anchor, 'absence_probability': str(normalizer),
                'deleted_index': deleted, 'available_pool_rank': 128, **diag}
            if proposed is not None:
                F, bound = closure(U, proposed, available)
                exact = sum(numerators[j] for j in F) - bound * normalizer
                record.update(proposed_subset_size=len(proposed), closed_subset_size=len(F))
                record['exact_violation'] = str(exact)
                record['accepted_exact_positive'] = exact > 0
                if exact > 0:
                    cut = {'sector': side, 'anchor_orbit': anchor, 'anchor_condition_value': 0,
                        'deleted_index': deleted, 'indices': F, 'bound': bound,
                        'span_closed_in_available_pool': True, 'proposed_indices': sorted(proposed),
                        'exact_violation': str(exact), 'exact_normalized_violation': str(exact / normalizer)}
                    cuts.append(cut)
            records.append(record)
            print(side, anchor, record, flush=True)
        if time.monotonic() - start > a.seconds:
            break
    out = {'status': 'CANDIDATE_ABSENT_RANK_CUTS', 'source_C16_answered': False,
        'anchor_condition_value': 0, 'point_sha256': sha(a.point), 'input_hashes': frozen,
        'frozen_sha256': sha(a.output.with_suffix('.frozen.json')),
        'queries_completed': len(records), 'queries_requested': len(a.anchors) * len(a.sectors),
        'complete_requested_query_list': len(records) == len(a.anchors) * len(a.sectors),
        'records': records, 'cuts': cuts, 'elapsed_seconds': time.monotonic() - start,
        'scope': 'Exact positive violations of absent-anchor rank necessities proposed by bounded numerical basis separation. Even complete query-list coverage is not complete matroid-polytope separation.'}
    a.output.write_text(json.dumps(out, indent=2) + '\n')
    print('ABSENT_RANK_RESULT', {k: v for k, v in out.items() if k not in ('records', 'cuts', 'input_hashes')}, 'cuts', len(cuts), flush=True)


if __name__ == '__main__':
    main()
