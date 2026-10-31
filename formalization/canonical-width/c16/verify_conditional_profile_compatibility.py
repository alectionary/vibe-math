#!/usr/bin/env python3
"""Independent original-coordinate replay of conditional compatibility tables.

No producer import, quotient coordinate files, upward-closure algorithm, LP, or
claimed discovery rank is used. Existing quotient witnesses are lifted into
the original 128-bit spaces, then their span/annihilation properties are checked
directly. Table hashes use literal contained-witness tests on the unchanged
unconditional mask universe. Sector/phase isomorphisms are rebuilt physically.
"""
from pathlib import Path
from itertools import combinations, permutations
import argparse
import gzip
import hashlib
import json
import time
import numpy as np
from verify_algebraic_model import physical

ROOT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    b = Path(path).read_bytes()
    return json.loads(gzip.decompress(b) if str(path).endswith('.gz') else b)


def basis(vectors):
    rows = {}
    for value in vectors:
        while value:
            p = value.bit_length()-1
            if p not in rows:
                rows[p] = value
                break
            value ^= rows[p]
    return rows


def contains(rows, value):
    while value:
        p = value.bit_length()-1
        if p not in rows:
            return False
        value ^= rows[p]
    return True


def xor_subset(values, selector):
    result = 0
    while selector:
        low = selector & -selector
        result ^= values[low.bit_length()-1]
        selector ^= low
    return result


def dual_basis(vectors):
    """Solve B*w=e_k via full binary row reduction, independently of producer."""
    n = len(vectors)
    rows = [value | (1 << (n+k)) for k, value in enumerate(vectors)]
    for col in range(n):
        pivot = next(k for k in range(col, n) if rows[k] >> col & 1)
        rows[col], rows[pivot] = rows[pivot], rows[col]
        for k in range(n):
            if k != col and rows[k] >> col & 1:
                rows[k] ^= rows[col]
    assert [r & ((1 << n)-1) for r in rows] == [1 << k for k in range(n)]
    dual = [sum(((rows[j] >> (n+k)) & 1) << j for j in range(n)) for k in range(n)]
    assert all((v & w).bit_count() % 2 == (i == j) for i, v in enumerate(vectors) for j, w in enumerate(dual))
    return dual


def literal_survivors(masks, row):
    """Direct subset predicates, deliberately not the producer's zeta closure."""
    out = (masks & ~row.get('eligible_mask', 65535)) == 0
    for c in row['minimal_bad_certificates']:
        out &= (masks & c['mask']) != c['mask']
    return out


def check_witness(selected, opponent, profiles, mask, kind, witness, fixed=None):
    assert 0 < witness < (1 << 128)
    chosen = [v for h, v in enumerate(selected) if mask >> h & 1]
    if kind == 'zero_rank':
        assert not contains(basis(chosen + ([] if fixed is None else [fixed])), witness)
        assert all(p & mask for v, p in zip(opponent, profiles) if (v & witness).bit_count() % 2)
    else:
        assert kind == 'missing_private'
        assert not contains(basis([] if fixed is None else [fixed]), witness)
        assert all((p & mask).bit_count() > 1 for v, p in zip(opponent, profiles) if (v & witness).bit_count() % 2)


def small_controls():
    """Literal dimension-three full bases and partner-removal boundary cases."""
    pool = list(range(1, 8))
    count = 0
    present_partner = absent_partner = 0
    for selected in combinations(pool, 3):
        if len(basis(selected)) != 3:
            continue
        for opposite in permutations(pool, 3):
            if not all((x & z).bit_count() % 2 == (i == j) for i, x in enumerate(selected) for j, z in enumerate(opposite)):
                continue
            for anchor_id, anchor in enumerate(opposite):
                for subset in range(8):
                    chosen = [selected[h] for h in range(3) if subset >> h & 1]
                    degree = sum((x & anchor).bit_count() % 2 for x in chosen)
                    assert degree <= 1
                    remainder = [x for x in chosen if not (x & anchor).bit_count() % 2]
                    assert len(remainder) == len(chosen)-degree
                    assert all(not (x & anchor).bit_count() % 2 for x in remainder)
                    present_partner += degree == 1
                    absent_partner += degree == 0
                    count += 1
    # A quotient-ineligible sole partner must disappear, not reject the mask.
    assert ((1 & 1).bit_count() % 2) == 1
    assert [x for x in [1] if not (x & 1).bit_count() % 2] == []
    # Two independent phase vectors may nevertheless violate the owner bound.
    assert len(basis([1, 2])) == 2 and sum((x & 3).bit_count() % 2 for x in [1, 2]) == 2
    # Same-sector conditioning removes the fixed vector and preserves the rest.
    assert len(basis([1, 2, 4])) == 3 and [x for x in [1, 2, 4] if x != 1] == [2, 4]
    # Correct and deliberately false direct witnesses on a tiny restricted pool.
    check_witness([1], [2], [0], 1, 'zero_rank', 4)
    for bad in (0, 1):
        try:
            check_witness([1], [2], [0], 1, 'zero_rank', bad)
        except AssertionError:
            pass
        else:
            raise AssertionError('tiny false witness accepted')
    try:
        check_witness([1], [2], [0], 1, 'zero_rank', 2)
    except AssertionError:
        pass
    else:
        raise AssertionError('tiny nonannihilating witness accepted')
    return {'full_basis_subset_checks': count, 'possible_partner_present': present_partner,
            'possible_partner_absent': absent_partner, 'sole_partner_removal_control': True,
            'two_partner_rejection_control': True, 'same_anchor_removal_control': True,
            'zero_span_and_nonannihilating_negative_controls': 3}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--bank', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    start = time.monotonic()
    bank = read(args.bank)
    assert len(bank['orbits']) == len(set(bank['orbits']))
    expected_keys = {(o, side, anchor, condition) for o in bank['orbits'] for side in 'ST' for anchor in range(45) for condition in (0, 1)}
    observed_keys = [(r['orbit'], r['side'], r['anchor'], r['condition']) for r in bank['records']]
    assert len(observed_keys) == len(set(observed_keys)) and set(observed_keys) == expected_keys
    assert bank['producer_sha256'] == sha(ROOT / 'conditional_profile_compatibility.py')
    for name, digest in bank['source_hashes'].items():
        assert sha(ROOT / name) == digest, ('source_hash', name)
    X, Z, A = physical()
    for side, values in [('x', X), ('z', Z)]:
        assert values == [int(v, 16) for v in (ROOT / f'pools/{side}coords.txt').read_text().split()]
    ranks = [len(basis(values)) for values in [X, Z]]
    assert ranks == [128, 128]
    shift = lambda i: 16*(i//16)+(i+1) % 16
    graph_ranks = [len(basis([x | (z << 128) for x, z in zip(X, Z)])),
                   len(basis([X[i] | (X[shift(i)] << 128) for i in range(720)])),
                   len(basis([Z[i] | (Z[shift(i)] << 128) for i in range(720)]))]
    assert graph_ranks == [128, 128, 128]
    assert all((A[i] >> j & 1) == (A[j] >> i & 1) == (A[shift(i)] >> shift(j) & 1) for i in range(720) for j in range(720))
    controls = small_controls()
    n = np.arange(65536, dtype=np.int64)
    pop = np.array([v.bit_count() for v in range(65536)], dtype=np.int8)
    profiles = read(ROOT / 'algebraic-results/orbit-rank-profiles.json.gz')
    hulls = read(ROOT / 'algebraic-results/hulls-16-rank.json.gz')
    conditionals = {}
    metadata = {}
    results = []
    classifications = []
    witness_counts = {'unconditional': 0, 'same_sector_selected': 0, 'opposite_sector_selected': 0, 'opposite_sector_absent': 0}
    zero_rejected = 0
    for orbit in bank['orbits']:
        localX = X[16*orbit:16*orbit+16]
        localZ = Z[16*orbit:16*orbit+16]
        assert len(basis(localX)) == len(basis(localZ)) == 16
        original = next(r for r in profiles['records'] if r['orbit'] == orbit)
        original_profiles = [sum(((x & z).bit_count() % 2) << h for h, x in enumerate(localX)) for z in Z]
        for cert in original['minimal_bad_certificates']:
            check_witness(localX, Z, original_profiles, cert['mask'], cert['kind'], int(cert['annihilator_hex'], 16))
            witness_counts['unconditional'] += 1
        universe = literal_survivors(n, original)
        if orbit == 12:
            universe &= pop <= 11  # Explicit unchanged external critical-cap dependency.
        assert int(universe.sum()) == next(r for r in hulls['records'] if r['orbit'] == orbit)['phase_patterns']
        masks = n[universe]
        t21 = {}
        for expected in [r for r in bank['records'] if r['orbit'] == orbit]:
            side, anchor, condition = expected['side'], expected['anchor'], expected['condition']
            anchorX = X[16*anchor]
            anchorZ = Z[16*anchor]
            neighbor = sum(((x & anchorZ).bit_count() % 2) << h for h, x in enumerate(localX))
            baseline = np.ones(len(masks), dtype=bool)
            if not condition:
                if side == 'S' and anchor == orbit:
                    baseline &= (masks & 1) == 0
            elif side == 'T':
                baseline &= pop[masks & neighbor] <= 1
            elif anchor == orbit:
                baseline &= (masks & 1) != 0
            else:
                # Literal high-pivot physical rank, unlike producer coefficients.
                baseline = np.array([len(basis([x for h, x in enumerate(localX) if int(mask) >> h & 1]+[anchorX])) == int(mask).bit_count()+1 for mask in masks])
            compatible = baseline.copy()
            if condition:
                folder = 'conditional-capacity' if side == 'S' else 'conditional-cross-capacity'
                key = side, anchor
                if key not in conditionals:
                    cp = ROOT / f'algebraic-results/{folder}/cohort.json'
                    cohort = read(cp)
                    entry = next(r for r in cohort['records'] if r['orbit'] == anchor)
                    path = cp.parent / entry['certificate_file']
                    assert bank['source_hashes'][str(path.relative_to(ROOT))] == entry['certificate_sha256']
                    d = read(path)
                    assert d['ambient_dimension'] == 127 and d['conditioned_on_X_index'] == 16*anchor
                    assert d.get('selected_quotient_sector', 'X') == ('X' if side == 'S' else 'Z')
                    d['records'] = [r for r in d['records'] if r['orbit'] in bank['orbits']]
                    conditionals[key] = d
                d = conditionals[key]
                if anchor not in metadata:
                    mp = ROOT / d['quotient_metadata_c16_path']
                    md = read(mp)
                    assert bank['source_hashes'][str(mp.relative_to(ROOT))] == d['quotient_metadata_sha256']
                    assert md['fixed_X_only'] and md['anchor'][0] == 16*anchor
                    ids = md['basis_X_pool_indices']
                    assert len(ids) == len(set(ids)) == 128 and ids[0] == 16*anchor
                    B = [X[i] for i in ids]
                    assert len(basis(B)) == 128
                    gauge = Z[md['anchor'][1]]
                    assert (B[0] & gauge).bit_count() % 2
                    assert not any((x & gauge).bit_count() % 2 for x in B[1:])
                    metadata[anchor] = B, dual_basis(B)
                B, dual = metadata[anchor]
                row = next(r for r in d['records'] if r['orbit'] == orbit)
                assert row['complete']
                if side == 'S':
                    selected = localX
                    opposite = [z for z in Z if not (anchorX & z).bit_count() % 2]
                    eligible = sum((not contains(basis([anchorX]), x)) << h for h, x in enumerate(selected))
                    remaining = masks & (~1 if anchor == orbit else 65535)
                    lift = B[1:]
                    fixed = anchorX
                    kind_key = 'same_sector_selected'
                else:
                    # Original coordinates AFTER the exact index-preserving sector exchange.
                    selected = localZ
                    opposite = X
                    eligible = sum((not (anchorX & z).bit_count() % 2) << h for h, z in enumerate(selected))
                    assert eligible == (65535 ^ neighbor)
                    remaining = masks & eligible
                    lift = dual[1:]
                    fixed = None
                    kind_key = 'opposite_sector_selected'
                assert eligible == row['eligible_mask']
                pairing_profiles = [sum(((x & z).bit_count() % 2) << h for h, x in enumerate(selected)) for z in opposite]
                for cert in row['minimal_bad_certificates']:
                    assert cert['mask'] & ~eligible == 0
                    q = int(cert['annihilator_hex'], 16)
                    assert 0 < q < 1 << 127
                    W = xor_subset(lift, q)
                    if side == 'T':
                        assert not (W & anchorX).bit_count() % 2
                    check_witness(selected, opposite, pairing_profiles, cert['mask'], cert['kind'], W, fixed)
                    witness_counts[kind_key] += 1
                    if not zero_rejected:
                        try:
                            check_witness(selected, opposite, pairing_profiles, cert['mask'], cert['kind'], 0, fixed)
                        except AssertionError:
                            zero_rejected = 1
                        else:
                            raise AssertionError('physical zero witness accepted')
                compatible &= literal_survivors(remaining, row)
            elif side == 'T' and anchor == 21:
                d = read(ROOT / 'algebraic-results/absent336-Z-profiles.json.gz')
                assert d['conditioned_on_X_absent'] == 336 and d['selected_quotient_sector'] == 'Z'
                row = next(r for r in d['records'] if r['orbit'] == orbit)
                opposite = [x for j, x in enumerate(X) if j != 336]
                pairing_profiles = [sum(((z & x).bit_count() % 2) << h for h, z in enumerate(localZ)) for x in opposite]
                for cert in row['minimal_bad_certificates']:
                    check_witness(localZ, opposite, pairing_profiles, cert['mask'], cert['kind'], int(cert['annihilator_hex'], 16))
                    witness_counts['opposite_sector_absent'] += 1
                compatible &= literal_survivors(masks, row)
            table = np.zeros(65536, dtype=bool)
            table[masks] = compatible
            digest = hashlib.sha256(table.tobytes()).hexdigest()
            assert digest == expected['table_sha256'], ('table', orbit, side, anchor, condition)
            assert int(baseline.sum()) == expected['old_compatible']
            assert int(compatible.sum()) == expected['compatible']
            assert int((baseline & ~compatible).sum()) == expected['new_exclusions']
            assert not np.any(table & ~universe)
            if side == 'T' and anchor == 21:
                t21[condition] = table.copy()
            corrupt = table.copy()
            corrupt[0] = not corrupt[0]
            assert hashlib.sha256(corrupt.tobytes()).hexdigest() != expected['table_sha256']
            results.append(expected)
        yes, no = t21[1], t21[0]
        classifications.append({'orbit': orbit, 'anchor': ['T', 21],
                                'both_compatible': int((universe & yes & no).sum()),
                                'selected_only': int((universe & yes & ~no).sum()),
                                'absent_only': int((universe & ~yes & no).sum()),
                                'both_incompatible': int((universe & ~yes & ~no).sum()),
                                'selected_only_masks': list(map(int, n[universe & yes & ~no])),
                                'both_incompatible_masks': list(map(int, n[universe & ~yes & ~no]))})
        print('PHYSICAL CONDITIONAL COMPATIBILITY', orbit, 'witnesses', sum(witness_counts.values()), 'seconds', round(time.monotonic()-start, 2), flush=True)
    out = {'status': 'PASS', 'source_C16_answered': False, 'bank_sha256': sha(args.bank),
           'consumer_sha256': sha(Path(__file__)), 'producer_sha256': bank['producer_sha256'],
           'source_hashes': bank['source_hashes'], 'orbits': bank['orbits'],
           'physical_witnesses_checked': witness_counts, 'physical_pool_ranks': ranks,
           'sector_and_phase_graph_ranks': graph_ranks, 'pairing_symmetry_checks': 2*720*720,
           'physical_reconstruction_dependencies': {p: sha(ROOT/p) for p in ['verify_algebraic_model.py', 'verify_partial_frame.py', 'audit_pools.py']},
           'literal_small_controls': controls, 'physical_zero_witness_rejected': bool(zero_rejected),
           'tables_independently_reconstructed': len(results), 'corrupt_table_negative_controls_rejected': len(results),
           'records': results, 'new_exclusions': sum(r['new_exclusions'] for r in results),
           'anchor21_selected_absent_classification': classifications,
           'critical_orbit12_cap11_reused_dependency': 12 in bank['orbits'],
           'elapsed_seconds': time.monotonic()-start,
           'scope': 'Every added exclusion follows from a directly replayed physical full-basis rank/owner obstruction under the stated anchor event. Unexcluded masks need not extend to frames. Unconditional mask universes, source width and cover are unchanged; no complete source anchor is excluded.'}
    args.output.write_text(json.dumps(out, indent=2)+'\n')
    print({k: v for k, v in out.items() if k not in ['records', 'source_hashes', 'physical_reconstruction_dependencies']}, flush=True)


if __name__ == '__main__':
    main()
