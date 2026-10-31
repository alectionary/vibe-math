#!/usr/bin/env python3
"""Independent acceptance and owner-row compilation of full-partner cuts.

Features are (1,k,C1..C8,n[45],d[45,16]), with
d[j,h]=sum_t P[t]*Q[j,t+h]. Their sector/cyclic averaged expectations are
(1,16*p[o],16*S_h[o,o],16*p[j],16*T_h[o,j]). No producer feature or support
routine is imported. Physical bins and signed support upper bounds use the
separate low-pivot full-basis consumer. A positive rational target gap is
required, and matrix() accepts only a matching independent PASS receipt.
"""
from pathlib import Path
from fractions import Fraction
from collections import Counter
import argparse
import gzip
import hashlib
import json
import random
import time
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import rebuild_domain, check_support, dimension, extend

ROOT = Path(__file__).resolve().parent
FEATURES = 775
VARIABLES = 36495
FEATURE_LAYOUT = '1,k,C1..C8,n[45],d[45,16].ravel(C)'


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    raw = Path(path).read_bytes()
    return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)


def turn(mask, h):
    h %= 16
    return ((mask << h) & 65535) | (mask >> ((16-h) % 16))


def move(index, h):
    return 16*(index//16)+(index % 16+h) % 16


def coord(side, h, i, j):
    assert side in ('S', 'T') and 0 <= h < 16 and 0 <= i < 45 and 0 <= j < 45
    if h > 8:
        h, i, j = 16-h, j, i
    if h in (0, 8) and i > j:
        i, j = j, i
    if side == 'S' and h == 0 and i == j:
        return i
    return 45+(0 if side == 'S' else 9*2025)+h*2025+45*i+j


def compile_row(coefficients, bound, orbit=32):
    """Exact translation only. matrix() adds the independent acceptance gate."""
    assert len(coefficients) == FEATURES and 0 <= orbit < 45
    c = tuple(Fraction(v) for v in coefficients)
    terms = Counter({orbit: 16*c[1]})
    for h in range(1, 9):
        terms[coord('S', h, orbit, orbit)] += 16*c[h+1]
    for j in range(45):
        terms[j] += 16*c[10+j]
        for h in range(16):
            terms[coord('T', h, orbit, j)] += 16*c[55+16*j+h]
    return dict(sorted((j, v) for j, v in terms.items() if v)), Fraction(bound)-c[0]


def weights(mask, coefficients):
    phases = [t for t in range(16) if mask >> t & 1]
    return [coefficients[10+j]+sum(coefficients[55+16*j+(b-t) % 16] for t in phases)
            for j in range(45) for b in range(16)]


def local_score(mask, coefficients):
    bits = [int(mask >> t & 1) for t in range(16)]
    return coefficients[0]+coefficients[1]*sum(bits)+sum(coefficients[h+1]*sum(bits[t]*bits[(t+h) % 16] for t in range(16)) for h in range(1, 9))


def literal_features(mask, selected_Z):
    p = [int(mask >> t & 1) for t in range(16)]
    selected = set(selected_Z)
    assert len(selected) == len(selected_Z)
    q = [[int(16*j+t in selected) for t in range(16)] for j in range(45)]
    return [1, sum(p)]+[sum(p[t]*p[(t+h) % 16] for t in range(16)) for h in range(1, 9)]+[sum(row) for row in q]+[sum(p[t]*q[j][(t+h) % 16] for t in range(16)) for j in range(45) for h in range(16)]


def prefix_bound(Z, domain, w, n=128):
    assert domain['status'] == 'FULL_PARTNER_BASIS_DOMAIN'
    ordered = sorted(domain['zero'], key=lambda j: (-w[j], j))
    rows = {}
    ranks = []
    for j in ordered:
        extend(rows, Z[j])
        ranks.append(len(rows))
    bound = w[ordered[-1]]*len(rows) if ordered else 0
    bound += sum((w[ordered[t]]-w[ordered[t+1]])*ranks[t] for t in range(len(ordered)-1))
    bound += sum(max(w[j] for j in b) for b in domain['bins'])
    return bound


def point_data(path, orbit):
    """Read the saved compact exact point and independently expand owner indices."""
    data = read(path)
    values = list(map(Fraction, data['values']))
    index = {}
    k = 0
    for i in range(45):
        index['p', i] = k
        k += 1
    for side in 'ST':
        for h in range(9):
            for i in range(45):
                for j in range(i if h in (0, 8) else 0, 45):
                    index[side, h, i, j] = k
                    k += 1
    assert len(values) >= k
    def value(side, h, i, j):
        if h > 8:
            h, i, j = 16-h, j, i
        if h in (0, 8) and i > j:
            i, j = j, i
        return values[index[side, h, i, j]]
    owner = values[:45]+[value(side, h, i, j) for side in 'ST' for h in range(9) for i in range(45) for j in range(45)]
    assert len(owner) == VARIABLES
    target = [Fraction(1), 16*values[orbit]]+[16*value('S', h, orbit, orbit) for h in range(1, 9)]+[16*values[j] for j in range(45)]+[16*value('T', h, orbit, j) for j in range(45) for h in range(16)]
    return owner, target


def translation_controls(X=None, Z=None):
    """Independent literal all16-rotation and both-sector adversarial controls."""
    rng = random.Random(202610300720)
    coefficient_sets = []
    for entries in ({0: 7}, {1: -3, 9: 5}, {10: 2, 54: -7},
                    {55+15: 11, 55+16*44+1: -5},
                    {55+16*32+9: 13, 55+16*2+8: -17}):
        c = [0]*FEATURES
        for i, v in entries.items():
            c[i] = v
        coefficient_sets.append(c)
    coefficient_sets.append([(19*i+5) % 23-11 for i in range(FEATURES)])
    feature_checks = covariance_checks = row_checks = decomposition_checks = 0
    for control, probability in enumerate((0, 1, .02, .1, .25, .5)):
        sets = [{j for j in range(720) if rng.random() < probability} for _ in range(2)]
        indicator = [[[int(16*j+t in selected) for t in range(16)] for j in range(45)] for selected in sets]
        def moment(column):
            if column < 45:
                return Fraction(sum(indicator[0][column])+sum(indicator[1][column]), 32)
            block, rest = divmod(column-45, 9*2025)
            h, rest = divmod(rest, 2025)
            i, j = divmod(rest, 45)
            return Fraction(sum(indicator[s][i][t]*indicator[(s+block) % 2][j][(t+h) % 16] for s in range(2) for t in range(16)), 32)
        averaged = [0]*FEATURES
        for s in range(2):
            p = sum(indicator[s][32][h] << h for h in range(16))
            q = sorted(sets[1-s])
            original_features = literal_features(p, q)
            original_weights = [weights(p, c) for c in coefficient_sets]
            for rotation in range(16):
                rotated_p = turn(p, rotation)
                rotated_q = [move(j, rotation) for j in q]
                features = literal_features(rotated_p, rotated_q)
                assert features == original_features
                averaged = [a+b for a, b in zip(averaged, features)]
                feature_checks += FEATURES
                for c, old_weights in zip(coefficient_sets, original_weights):
                    w = weights(rotated_p, c)
                    assert all(w[move(j, rotation)] == old_weights[j] for j in range(720))
                    covariance_checks += 720
                    assert sum(a*b for a, b in zip(c, features)) == local_score(rotated_p, c)+sum(w[j] for j in rotated_q)
                    decomposition_checks += 1
        target = [Fraction(1), 16*moment(32)]+[16*moment(coord('S', h, 32, 32)) for h in range(1, 9)]+[16*moment(j) for j in range(45)]+[16*moment(coord('T', h, 32, j)) for j in range(45) for h in range(16)]
        assert [Fraction(v, 32) for v in averaged] == target
        for c in coefficient_sets:
            row, rhs = compile_row(c, Fraction(7, 3))
            assert sum(v*moment(j) for j, v in row.items())-rhs == sum(a*b for a, b in zip(c, target))-Fraction(7, 3)
            row_checks += 1
    physical_rotations = 0
    if X is not None:
        for mask in (0, 1, 3, 5):
            for c in coefficient_sets[-3:]:
                original = None
                for r in range(16):
                    rotated = turn(mask, r)
                    selected = [512+h for h in range(16) if rotated >> h & 1]
                    domain = rebuild_domain(X, Z, selected, 128)
                    bound = local_score(rotated, c)+prefix_bound(Z, domain, weights(rotated, c))
                    if original is None:
                        original = bound
                    assert bound == original
                    physical_rotations += 1
    return {'status': 'PASS', 'source_C16_answered': False, 'adversarial_coefficient_sets': len(coefficient_sets),
            'arbitrary_binary_selection_pairs': 6, 'literal_rotated_feature_equalities': feature_checks,
            'individual_weight_covariance_checks': covariance_checks, 'weight_decomposition_checks': decomposition_checks,
            'constant_rhs_and_sector_averaged_row_checks': row_checks,
            'physical_rotation_support_bounds_checked': physical_rotations,
            'scope': 'Exact translation, covariance, signed support and sector normalization controls; no separating cut or source frame is asserted.'}


def matrix(certificates, replays):
    """Return integer CSR M, integer rhs, metadata for accepted M@owner<=rhs."""
    import numpy as np
    from scipy.sparse import coo_matrix
    certificates, replays = list(certificates), list(replays)
    assert len(certificates) == len(replays)
    ii, jj, vv, rhs, metadata = [], [], [], [], []
    limit = (1 << 63)-1
    for path, replay_path in zip(certificates, replays):
        bank, replay = read(path), read(replay_path)
        assert replay['status'] == 'PASS' and replay['bank_sha256'] == sha(path)
        assert replay['cuts_checked'] == len(bank['cuts']) and len(replay['results']) == len(bank['cuts'])
        assert replay['source_hashes'] == bank['source_hashes']
        assert all(sha(ROOT / p) == digest for p, digest in bank['source_hashes'].items())
        for k, cut in enumerate(bank['cuts']):
            assert Fraction(cut['exact_violation']) == Fraction(replay['results'][k]['exact_violation']) > 0
            row, b = compile_row(cut['coefficients'], cut['upper_bound'], bank['orbit'])
            assert b.denominator == 1 and abs(b) <= limit
            for j, value in row.items():
                assert value.denominator == 1 and abs(value) <= limit
                ii.append(len(rhs)); jj.append(j); vv.append(int(value))
            rhs.append(int(b))
            metadata.append({'certificate_sha256': sha(path), 'replay_sha256': sha(replay_path),
                             'cut_index': k, 'orbit': bank['orbit'], 'nonzero_coefficients': len(row),
                             'constant': cut['coefficients'][0], 'inequality': 'matrix @ owner_vector <= rhs',
                             'profile_weights_fixed': False, 'source_necessary': True})
    return coo_matrix((np.asarray(vv, dtype=np.int64), (ii, jj)), shape=(len(rhs), VARIABLES), dtype=np.int64).tocsr(), np.asarray(rhs, dtype=np.int64), metadata


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--certificate', type=Path)
    ap.add_argument('--point', type=Path)
    ap.add_argument('--controls-only', action='store_true')
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    start = time.monotonic()
    X, Z, A = physical()
    assert dimension(X) == dimension(Z) == 128
    for side, pool in [('x', X), ('z', Z)]:
        assert pool == [int(v, 16) for v in (ROOT / f'pools/{side}coords.txt').read_text().split()]
    symmetry_ranks = [dimension([x | (z << 128) for x, z in zip(X, Z)]),
                      dimension([X[i] | (X[move(i, 1)] << 128) for i in range(720)]),
                      dimension([Z[i] | (Z[move(i, 1)] << 128) for i in range(720)])]
    assert symmetry_ranks == [128, 128, 128]
    assert all((A[i] >> j & 1) == (A[j] >> i & 1) == (A[move(i, 1)] >> move(j, 1) & 1) for i in range(720) for j in range(720))
    controls = translation_controls(X, Z)
    if args.controls_only:
        controls.update(consumer_sha256=sha(Path(__file__)), symmetry_graph_ranks=symmetry_ranks,
                        source_sha256=sha(ROOT / 'physical-pool-source.json'), elapsed_seconds=time.monotonic()-start)
        args.output.write_text(json.dumps(controls, indent=2)+'\n')
        print(controls, flush=True)
        return
    assert args.certificate and args.point
    bank = read(args.certificate)
    assert bank['status'] == 'EXACT_SUPPORT_CUT_CANDIDATE' and bank['cuts']
    assert bank['feature_layout'] == FEATURE_LAYOUT and bank['orbit'] == 32
    assert bank['point_sha256'] == sha(args.point)
    required = {'physical-pool-source.json', 'pools/xcoords.txt', 'pools/zcoords.txt',
                'algebraic-results/orbit-rank-profiles.json.gz', 'algebraic-results/hulls-16-rank.json.gz'}
    assert required <= set(bank['source_hashes'])
    assert all(sha(ROOT / p) == digest for p, digest in bank['source_hashes'].items())
    profiles = read(ROOT / 'algebraic-results/orbit-rank-profiles.json.gz')
    profile_row = next(r for r in profiles['records'] if r['orbit'] == 32)
    phase_vectors = X[512:528]
    assert dimension(phase_vectors) == 16
    pair_profiles = [sum(((x & z).bit_count() % 2) << h for h, x in enumerate(phase_vectors)) for z in Z]
    for certificate in profile_row['minimal_bad_certificates']:
        mask = certificate['mask']
        witness = int(certificate['annihilator_hex'], 16)
        assert 0 < witness < 1 << 128
        if certificate['kind'] == 'zero_rank':
            chosen = [phase_vectors[h] for h in range(16) if mask >> h & 1]
            assert dimension(chosen+[witness]) == len(chosen)+1
            assert all(p & mask for z, p in zip(Z, pair_profiles) if (z & witness).bit_count() % 2)
        else:
            assert certificate['kind'] == 'missing_private'
            assert all((p & mask).bit_count() > 1 for z, p in zip(Z, pair_profiles) if (z & witness).bit_count() % 2)
    forbidden = [c['mask'] for c in profile_row['minimal_bad_certificates']]
    allowed = [m for m in range(65536) if not any(m & b == b for b in forbidden)]
    assert len(allowed) == bank['allowed_masks'] == 4597
    representatives = sorted({min(turn(m, h) for h in range(16)) for m in allowed})
    assert len(representatives) == 291 and representatives == bank['representatives']
    owner, target = point_data(args.point, 32)
    domains = {m: rebuild_domain(X, Z, [512+h for h in range(16) if m >> h & 1], 128) for m in representatives}
    assert all(d['status'] == 'FULL_PARTNER_BASIS_DOMAIN' for d in domains.values())
    results = []
    for cut in bank['cuts']:
        c = cut['coefficients']
        assert len(c) == FEATURES and all(type(v) is int for v in c)
        assert type(cut['upper_bound']) is int
        records = {r['mask']: r for r in cut['support_records']}
        assert len(records) == len(cut['support_records']) == 291 and set(records) == set(representatives)
        maximum = None
        prefix_checks = covariance = 0
        for mask in representatives:
            record = records[mask]
            selected = [512+h for h in range(16) if mask >> h & 1]
            w = weights(mask, c)
            adapted = {**record, 'status': 'EXACT_FULL_PARTNER_BASIS_SUPPORT', 'value': record['support_value']}
            prefix_checks += check_support(Z, selected, 128, domains[mask], w, adapted)
            full = local_score(mask, c)+record['support_value']
            assert full == record['full_value']
            assert full == sum(a*b for a, b in zip(c, literal_features(mask, record['selected_Z_indices'])))
            maximum = full if maximum is None else max(maximum, full)
            for r in range(16):
                wr = weights(turn(mask, r), c)
                assert all(wr[move(j, r)] == w[j] for j in range(720))
                assert local_score(turn(mask, r), c) == local_score(mask, c)
                covariance += 720
        assert maximum == cut['upper_bound']
        exact_target = sum(a*b for a, b in zip(c, target))
        violation = exact_target-maximum
        assert exact_target == Fraction(cut['exact_target_value'])
        assert violation == Fraction(cut['exact_violation']) > 0
        row, rhs = compile_row(c, maximum, 32)
        assert sum(value*owner[j] for j, value in row.items())-rhs == violation
        results.append({'exact_target_value': str(exact_target), 'exact_violation': str(violation),
                        'approximate_violation': float(violation), 'upper_bound': maximum,
                        'representative_supports_checked': 291, 'exact_prefix_rank_checks': prefix_checks,
                        'actual_cut_weight_covariance_checks': covariance,
                        'owner_row_nonzeros': len(row), 'owner_rhs': str(rhs),
                        'compiled_owner_row': [[j, str(value)] for j, value in row.items()]})
    out = {'status': 'PASS', 'source_C16_answered': False, 'bank_sha256': sha(args.certificate),
           'point_sha256': sha(args.point), 'consumer_sha256': sha(Path(__file__)),
           'source_hashes': bank['source_hashes'], 'cuts_checked': len(results), 'results': results,
           'allowed_masks_independently_enumerated': 4597, 'representatives_independently_rebuilt': 291,
           'unconditional_profile_witnesses_physically_replayed': len(forbidden),
           'symmetry_graph_ranks': symmetry_ranks, 'physical_pairing_symmetry_checks': 2*720*720,
           'translation_controls': controls, 'profile_weights_fixed_in_separation': False,
           'dependencies': {p: sha(ROOT/p) for p in ['verify_full_partner_basis_oracle.py', 'verify_algebraic_model.py', 'verify_partial_frame.py', 'audit_pools.py']},
           'elapsed_seconds': time.monotonic()-start,
           'scope': 'Exact source-necessary projected moment inequality, proved by full opposite-basis signed support on every allowed phase class and verified covariance, with strict separation of the saved point. No full dual frame or global infeasibility is claimed.'}
    args.output.write_text(json.dumps(out, indent=2)+'\n')
    print({k: v for k, v in out.items() if k not in ['source_hashes', 'results', 'dependencies']}, flush=True)


if __name__ == '__main__':
    main()
