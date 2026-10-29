#!/usr/bin/env python3
"""Independent source replay, including complete non-rejection through order3."""
from pathlib import Path
import argparse
import collections
import hashlib
import itertools
import json
import time
from verify_algebraic_model import physical
from verify_sparse_quotient import SparseQuotientConsumer

ROOT = Path(__file__).resolve().parent


def independent_obstruction(X, Z, side, ids, max_order=3):
    V, opposite = (X, Z) if side == 0 else (Z, X)
    eligible = [i for i, v in enumerate(V) if all((v & opposite[j]).bit_count() % 2 == 0 for j in ids)]
    # Reverse source order and use low pivots, unlike the native construction.
    selected, pivots = [], {}
    for i in reversed(eligible):
        value = V[i]
        for bit, row in sorted(pivots.items()):
            if value >> bit & 1:
                value ^= row
        if value:
            bit = (value & -value).bit_length()-1
            pivots[bit] = value
            selected.append(i)
    rank = len(selected)
    if rank < 128-len(ids):
        return {1: True, 2: True, 3: True}
    assert rank == 128-len(ids)
    rows = [[V[i], 1 << k] for k, i in enumerate(selected)]
    pivot_columns = []
    at = 0
    for col in range(128):
        found = next((i for i in range(at, rank) if rows[i][0] >> col & 1), None)
        if found is None:
            continue
        rows[at], rows[found] = rows[found], rows[at]
        for k in range(rank):
            if k != at and rows[k][0] >> col & 1:
                rows[k][0] ^= rows[at][0]
                rows[k][1] ^= rows[at][1]
        pivot_columns.append(col)
        at += 1
    dual = [sum(((row[1] >> k) & 1) << col for row, col in zip(rows, pivot_columns)) for k in range(rank)]
    supports = [sum(((V[i] & w).bit_count() % 2) << i for i in eligible) for w in dual]
    for k, mask in enumerate(supports):
        assert all(bool(mask >> i & 1) == (j == k) for j, i in enumerate(selected))
    basis_mask = sum(1 << i for i in selected)
    extras = [mask & ~basis_mask for mask in supports]
    residue = SparseQuotientConsumer.quotient(opposite[j] for j in ids)
    singles = {0, *(residue(z) for z in opposite)}
    pairs = None
    result = {1: False, 2: False, 3: False}
    def consider(indices):
        nonlocal pairs
        mask, w = 0, 0
        for i in indices:
            mask ^= supports[i]
            w ^= dual[i]
        q = mask.bit_count()
        if q > max_order:
            return
        target = residue(w)
        assert target and q
        if target in singles:
            return
        if q >= 2 and any(target ^ v in singles for v in singles):
            return
        if q >= 3:
            if pairs is None:
                labels = list(singles)
                pairs = {a ^ b for i, a in enumerate(labels) for b in labels[i:]}
            if any(target ^ v in pairs for v in singles):
                return
        for order in range(q, 4):
            result[order] = True
    for k in range(rank):
        consider((k,))
    for i, j in itertools.combinations(range(rank), 2):
        consider((i, j))
    if not result[3]:
        locations = collections.defaultdict(list)
        for i, mask in enumerate(extras):
            locations[mask].append(i)
        for i, j in itertools.combinations(range(rank), 2):
            for k in locations.get(extras[i] ^ extras[j], []):
                if k > j:
                    consider((i, j, k))
    return result


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--gate', type=Path, required=True)
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args()
    start = time.monotonic()
    data = json.loads(a.gate.read_text())
    frozen = json.loads((a.gate.parent/data['frozen_file']).read_text())
    cp = a.gate.parent/frozen['cohort_file']
    assert hashlib.sha256(cp.read_bytes()).hexdigest() == data['cohort_sha256'] == frozen['cohort_sha256']
    cohort = json.loads(cp.read_text())['records']
    assert len(data['records']) == len(cohort) == frozen['retrospective_cases'] + frozen['generated_cases']
    X, Z, A = physical()
    consumer = SparseQuotientConsumer(X, Z)
    counts = collections.Counter()
    checked_certificates = set()
    for k, record in enumerate(data['records']):
        source = cohort[k]
        assert (record['cohort'], record['index']) == (source['cohort'], source['index'])
        pairs = source['pairs']
        for i, (x, z) in enumerate(pairs):
            assert A[x] >> z & 1
            for xx, zz in pairs[:i]:
                assert x != xx and z != zz and not A[x] >> zz & 1 and not A[xx] >> z & 1
        outcomes = [independent_obstruction(X, Z, side, [p[1-side] for p in pairs]) for side in (0, 1)]
        yes2, yes3 = [any(r[o] for r in outcomes) for o in (2, 3)]
        assert yes2 == record['complete2_reject'] and yes3 == record['complete3_reject'], k
        prefix = source['cohort']
        counts[prefix+'_checked'] += 1
        counts[prefix+'_complete2_reject'] += yes2
        counts[prefix+'_complete3_reject'] += yes3
        counts[prefix+'_strict3_over_complete2'] += yes3 and not yes2
        for index in record['new_certificate_indices']:
            row = data['new_certificates'][index]
            assert set(row['mandatory_opposite']) <= {p[1-row['side']] for p in pairs}
            consumer.check(row)
            checked_certificates.add(index)
        if k % 500 == 0:
            print('INDEPENDENT SPARSE GATE', k, round(time.monotonic()-start, 2), flush=True)
    for key, value in counts.items():
        assert value == data['counts'][key]
    assert checked_certificates == set(range(len(data['new_certificates'])))
    out = {'status': 'PASS', 'source_C16_answered': False,
           'gate_sha256': hashlib.sha256(a.gate.read_bytes()).hexdigest(),
           'cohort_sha256': data['cohort_sha256'], 'physical_pairings_rebuilt': 518400,
           'matched_source_cases_checked': len(data['records']), 'independent_counts': dict(counts),
           'new_certificates_checked': len(data['new_certificates']),
           'elapsed_seconds': time.monotonic()-start,
           'scope': 'Independently reconstructs every source partial matching and complete order2/order3 predicate, including the absence of an order2 obstruction for strict order3 successes. Different basis order and RREF implementation; no native discovery code is used.'}
    a.output.write_text(json.dumps(out, indent=2)+'\n')
    print(out, flush=True)


if __name__ == '__main__':
    main()
