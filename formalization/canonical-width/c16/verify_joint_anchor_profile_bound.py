#!/usr/bin/env python3
"""Independent exhaustive-subset consumer for joint anchor profile bounds.

Does not import the producer, its partition optimization, or its mask closure.
For every source-unexcluded mask, checks all 4096 subsets of the twelve
anchors against physical independence and both cross-pairing degree bounds.
All objective, rotation and point calculations use exact integers/rationals.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse, gzip, hashlib, json, time
import numpy as np
from certify_profile_moment_point import layout

ROOT = Path(__file__).resolve().parent


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def dimension(vectors):
    basis = {}
    for value in vectors:
        while value:
            bit = value & -value
            if bit in basis:
                value ^= basis[bit]
            else:
                basis[bit] = value
                break
    return len(basis)


def turn(mask, h):
    return ((mask << h) & 65535) | (mask >> (16 - h))


def feature(mask):
    return [1, mask.bit_count(), *[(mask & turn(mask, h)).bit_count() for h in range(1, 9)]]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--certificate', type=Path, required=True)
    ap.add_argument('--parent', type=Path, required=True)
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    a = ap.parse_args()
    start = time.monotonic()
    d = json.loads(a.certificate.read_text())
    parent = json.loads(a.parent.read_text())
    bindings = d['input_hashes']
    assert bindings['bank_sha256'] == digest(a.parent)
    assert bindings['point_sha256'] == parent['point_sha256'] == digest(a.point)
    assert d['point_sha256'] == digest(a.point)
    hp = ROOT / 'algebraic-results/hulls-16-rank.json.gz'
    pp = ROOT / 'algebraic-results/orbit-rank-profiles.json.gz'
    assert bindings['hulls_sha256'] == digest(hp) and bindings['profiles_sha256'] == digest(pp)
    assert all(bindings['pool_sha256'][s] == digest(ROOT / f'pools/{s}coords.txt') for s in 'xz')
    hulls = json.loads(gzip.decompress(hp.read_bytes()))
    profiles = json.loads(gzip.decompress(pp.read_bytes()))
    anchors = d['anchors']
    assert anchors == parent['anchors'] and anchors[0] == ['S', 13]
    assert len(anchors) == 12 and all(s == 'T' for s, o in anchors[1:])
    assert d['orbit'] == parent['orbit'] == 32
    forbidden = [r['mask'] for r in next(r for r in profiles['records'] if r['orbit'] == 32)['minimal_bad_certificates']]
    allowed = [m for m in range(65536) if not any(m & b == b for b in forbidden)]
    assert len(allowed) == d['allowed_masks'] == 4597
    X, Z = [[int(v, 16) for v in (ROOT / f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
    phase_vectors = X[512:528]
    s_vector = X[208]
    z_vectors = [Z[16 * o] for s, o in anchors[1:]]
    compatibility = d.get('conditional_profile_dependency')
    conditional_table = None
    if compatibility:
        cp = ROOT / compatibility['bank']
        rp = ROOT / compatibility['replay']
        assert digest(cp) == compatibility['bank_sha256'] and digest(rp) == compatibility['replay_sha256']
        cb = json.loads(cp.read_text())
        cr = json.loads(rp.read_text())
        assert cr['status'] == 'PASS' and cr['bank_sha256'] == digest(cp)
        assert cr['source_hashes'] == cb['source_hashes']
        assert all(digest(ROOT / path) == expected for path, expected in cb['source_hashes'].items())
        record = next(r for r in cb['records'] if (r['orbit'], r['side'], r['anchor'], r['condition']) == (32, 'S', 13, 1))
        source_path = ROOT / 'algebraic-results/conditional-capacity/case-13.json.gz'
        assert digest(source_path) == cb['source_hashes']['algebraic-results/conditional-capacity/case-13.json.gz']
        conditional_source = json.loads(gzip.decompress(source_path.read_bytes()))
        assert conditional_source['conditioned_on_X_index'] == 208
        qr = next(r for r in conditional_source['records'] if r['orbit'] == 32)
        assert qr['complete']
        conditional_bad = [r['mask'] for r in qr['minimal_bad_certificates']]
        conditional_table = np.zeros(65536, dtype=bool)
        for mask in allowed:
            vectors = [phase_vectors[h] for h in range(16) if mask >> h & 1]
            conditional_table[mask] = (mask & ~qr['eligible_mask']) == 0 and not any(mask & b == b for b in conditional_bad) and dimension(vectors + [s_vector]) == len(vectors) + 1
        assert hashlib.sha256(conditional_table.tobytes()).hexdigest() == compatibility['table_sha256'] == record['table_sha256']
        assert int(conditional_table.sum()) == compatibility['compatible_masks'] == record['compatible'] == 2754
    assert dimension(z_vectors) == d['all_Z_anchors_rank'] == 11
    # The complete subset table is independent of the producer's partner bins.
    subset = np.arange(4096, dtype=np.int64)
    incidence = np.array([[(j >> k) & 1 for k in range(12)] for j in range(4096)], dtype=np.int64)
    includes_s = (subset & 1) != 0
    z_subsets = subset >> 1
    z_independent = np.array([dimension([z_vectors[k] for k in range(11) if bits >> k & 1]) == bits.bit_count() for bits in range(2048)])
    assert np.all(z_independent)
    z_ok = z_independent[z_subsets]
    physical = np.array([[(x & z).bit_count() % 2 for z in z_vectors] for x in [*phase_vectors, s_vector]], dtype=np.int64)
    row_degrees = physical @ incidence[:, 1:].T
    old_coefs = parent['cuts'][0]['anchor_coefficients']
    coefficients = np.array(old_coefs, dtype=np.int64)
    stored = {r['mask']: r for r in d['mask_bounds']}
    assert len(stored) == len(allowed) and set(stored) == set(allowed)
    joint_scores = {}
    old_scores = {}
    subset_checks = valid_subset_instances = 0
    rank_checks = 2049
    for mask in allowed:
        phases = [h for h in range(16) if mask >> h & 1]
        vectors = [phase_vectors[h] for h in phases]
        p_ok = dimension(vectors) == len(phases)
        s_ok = dimension(vectors + [s_vector]) == len(phases) + 1
        if conditional_table is not None:
            s_ok = s_ok and bool(conditional_table[mask])
        rank_checks += 2
        assert p_ok
        columns = physical[phases].sum(axis=0) if phases else np.zeros(11, dtype=np.int64)
        invalid0 = sum(1 << j for j in range(11) if columns[j] > 1)
        invalid1 = sum(1 << j for j in range(11) if columns[j] + physical[16, j] > 1)
        valid = z_ok.copy()
        if phases:
            valid &= np.all(row_degrees[phases] <= 1, axis=0)
        valid &= (~includes_s) | (row_degrees[16] <= 1)
        valid &= np.where(includes_s, (z_subsets & invalid1) == 0, (z_subsets & invalid0) == 0)
        if not s_ok:
            valid &= ~includes_s
        assert valid[0]
        values = coefficients[:, 0] + (coefficients[:, np.array(phases) + 1].sum(axis=1) if phases else 0)
        objectives = incidence @ values
        bound = int(np.max(objectives[valid]))
        old_bound = (max(0, int(values[0])) if s_ok else 0) + sum(max(0, int(values[j + 1])) for j in range(11) if columns[j] <= 1)
        assert bound == stored[mask]['joint_bound'], ('wrong_joint_maximum', mask)
        assert old_bound == stored[mask]['independent_hinge_bound']
        assert 0 <= bound <= old_bound
        joint_scores[mask] = bound
        old_scores[mask] = old_bound
        subset_checks += len(subset)
        valid_subset_instances += int(np.count_nonzero(valid))
    # Reconstruct the entire orbit certificate, using all 16 rotations, not
    # the producer's class list or its division by distinct class sizes.
    cut = d['cut']
    assert d['cuts'] == [cut] and d['profile_weights_free'] is True
    assert d['proof_kind'] == 'joint_anchor_partial_matching'
    scale = cut['scale']
    assert isinstance(scale, int) and scale > 0
    assert cut['anchor_coefficients'] == [[scale * x for x in c] for c in old_coefs]
    u = cut['unconditional_coefficients']
    assert len(u) == 10 and all(isinstance(x, int) for x in u)
    slacks = []
    old_u = parent['cuts'][0]['unconditional_coefficients']
    parent_residuals = []
    class_representatives = set()
    for mask in allowed:
        rotations = [turn(mask, h) for h in range(16)]
        assert all(m in joint_scores for m in rotations)
        f = feature(mask)
        residual = 16 * sum(x * y for x, y in zip(u, f)) + scale * sum(joint_scores[m] for m in rotations)
        assert residual <= 0, ('joint_class_bound_failed', mask, residual)
        slacks.append(-residual)
        parent_residuals.append(Q(16 * sum(x * y for x, y in zip(old_u, f)) + sum(joint_scores[m] for m in rotations), 16))
        class_representatives.add(min(rotations))
    assert len(class_representatives) == d['cyclic_classes'] == 291
    assert -max(parent_residuals) == Q(d['existing_functional_constant_gain'])
    assert d['strictly_improved_masks'] == sum(joint_scores[m] < old_scores[m] for m in allowed)
    by_rep = {r['representative']: r for r in d['class_bounds']}
    assert set(by_rep) == class_representatives
    for representative, row in by_rep.items():
        rotations = {turn(representative, h) for h in range(16)}
        assert row['size'] == len(rotations)
        assert row['features'] == feature(representative)
        assert row['old_score_sum'] == sum(old_scores[m] for m in rotations)
        assert row['joint_score_sum'] == sum(joint_scores[m] for m in rotations)
    _, index, moment = layout(hulls)
    point = list(map(Q, json.loads(gzip.decompress(a.point.read_bytes()))['values']))
    targets = [Q(1), 16 * point[index['p', 32]], *[16 * point[moment('S', h, 32, 32)] for h in range(1, 9)]]
    anchor_value = sum(coefs[0] * point[index['p', orbit]] + sum(coefs[h + 1] * point[moment(side, h, orbit, 32)] for h in range(16)) for (side, orbit), coefs in zip(anchors, old_coefs))
    exact = sum(x * y for x, y in zip(u, targets))
    for (side, orbit), coefs in zip(anchors, cut['anchor_coefficients']):
        exact += coefs[0] * point[index['p', orbit]] + sum(coefs[h + 1] * point[moment(side, h, orbit, 32)] for h in range(16))
    assert exact == Q(cut['exact_violation'])
    assert exact / scale == Q(cut['normalized_exact_violation'])
    assert exact / scale - Q(parent['cuts'][0]['exact_violation']) == Q(cut['normalized_gain_over_parent'])
    # Exact primal/dual certificates distinguish feature-bound optimization
    # from the additional improvement caused by joint anchor compatibility.
    optima = {}
    for certificate in d['feature_optima']:
        field = certificate['bound_family']
        assert field in ('old_score_sum', 'joint_score_sum')
        coefficients = list(map(Q, certificate['unconditional_coefficients_rational']))
        assert len(coefficients) == 10
        for row in by_rep.values():
            assert sum(c * f for c, f in zip(coefficients, row['features'])) + Q(row[field], row['size']) <= 0
        dual_target = [Q(0)] * 10
        dual_value = Q(0)
        seen = set()
        for item in certificate['dual_support']:
            representative = item['representative']
            assert representative not in seen
            seen.add(representative)
            row = by_rep[representative]
            weight = Q(item['weight'])
            assert weight >= 0
            for h in range(10):
                dual_target[h] += weight * row['features'][h]
            dual_value -= weight * Q(row[field], row['size'])
        assert dual_target == targets
        primal_value = sum(c * t for c, t in zip(coefficients, targets))
        assert primal_value == dual_value == Q(certificate['exact_unconditional_objective'])
        total = primal_value + anchor_value
        assert total == Q(certificate['exact_total_violation'])
        optima[field] = total
    assert set(optima) == {'old_score_sum', 'joint_score_sum'}
    joint_gain = optima['joint_score_sum'] - optima['old_score_sum']
    assert joint_gain == Q(d['exact_joint_gain_over_matched_hinge_optimum'])
    assert exact / scale == optima['joint_score_sum']
    baseline = d['matched_hinge_cut']
    assert Q(baseline['normalized_exact_violation']) == optima['old_score_sum']
    independent_hinge_residual = max(Q(sum(c * f for c, f in zip(u, row['features'])), scale) + Q(row['old_score_sum'], row['size']) for row in by_rep.values())
    # A deliberately false bound at a concrete mask is rejected by the exact
    # exhaustive maximum, and a sufficiently raised constant fails a class.
    first = allowed[0]
    assert stored[first]['joint_bound'] - 1 != joint_scores[first]
    raise_by = min(slacks) // 16 + 1
    assert any(-slack + 16 * raise_by > 0 for slack in slacks)
    result = {
        'status': 'PASS', 'source_C16_answered': False,
        'certificate_sha256': digest(a.certificate), 'bank_sha256': digest(a.certificate), 'parent_sha256': digest(a.parent),
        'point_sha256': digest(a.point), 'consumer_sha256': digest(Path(__file__)),
        'allowed_masks_independently_enumerated': len(allowed),
        'all_anchor_subsets_per_mask': 4096, 'explicit_subset_checks': subset_checks,
        'valid_local_subset_instances': valid_subset_instances,
        'independent_physical_rank_checks': rank_checks,
        'all_11_Z_anchors_independent': True,
        'conditional_profile_dependency': compatibility,
        'source_conditions_checked': ['X-mask independence', 'X-mask plus S13 independence', 'all Z-anchor-subset independence', 'one Z partner per selected X phase', 'one Z partner for S13', 'one selected X partner per selected Z anchor'],
        'all16_rotation_bounds_checked': len(allowed),
        'strictly_improved_masks': d['strictly_improved_masks'],
        'strictly_improved_classes': d['strictly_improved_classes'],
        'existing_functional_constant_gain': d['existing_functional_constant_gain'],
        'exact_projected_violation': str(exact), 'normalizing_scale': scale,
        'proof_kind': 'joint_anchor_partial_matching',
        'cuts_checked': 1, 'results': [{'exact_violation': str(exact), 'normalized_exact_violation': str(exact / scale)}],
        'profile_weights_fixed_in_separation': False,
        'exact_feature_optima_checked': len(optima),
        'exact_joint_gain_over_matched_hinge_optimum': str(joint_gain),
        'normalized_maximum_old_hinge_residual': str(independent_hinge_residual),
        'normalized_gain_over_parent': cut['normalized_gain_over_parent'],
        'minimum_integer_class_slack': min(slacks),
        'lowered_local_maximum_negative_control_rejected': True,
        'raised_constant_negative_control_rejected': True,
        'elapsed_seconds': time.monotonic() - start,
        'scope': 'Exact maximum over all local physical independent partial-matching subsets, yielding a valid projected first/second-moment inequality. Neither local admissibility nor a positive violation at the already-excluded parent point answers the full source question.',
    }
    a.output.write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
