#!/usr/bin/env python3
"""Independent physical/class/normalization replay of the anchored template.

No producer oracle, feature translator, conditional-table generator or solver
is imported. Signed full-basis upper bounds are derived from physical prefix
ranks and required-owner maxima; the saved128-vector witnesses attain them.
"""
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter
import argparse, gzip, hashlib, json, math, random, time
from certify_profile_moment_point import layout
from verify_algebraic_model import physical

ROOT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    raw = Path(path).read_bytes()
    return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)


def extend(rows, value):
    while value:
        bit = value & -value
        if bit in rows:
            value ^= rows[bit]
        else:
            rows[bit] = value
            return


def dimension(values):
    rows = {}
    for value in values:
        extend(rows, value)
    return len(rows)


def turn(mask, h):
    h %= 16
    return ((mask << h) & 65535) | (mask >> ((16 - h) % 16))


def features(mask):
    return [1, mask.bit_count(), *[(mask & turn(mask, h)).bit_count() for h in range(1, 9)]]


def literal_weights(mask, anchors, coefficients, reverse=False):
    """Z_(o,t) sees selected X phases h at relative phase h-t."""
    phases = [h for h in range(16) if mask >> h & 1]
    weights = [0] * 720
    for (side, orbit), c in zip(anchors, coefficients):
        if side == 'T':
            for t in range(16):
                weights[16 * orbit + t] += c[0] + sum(c[1 + ((t - h) % 16 if reverse else (h - t) % 16)] for h in phases)
    return weights


def domain_and_upper(X, Z, selected, weights):
    k = len(selected)
    if dimension(X[j] for j in selected) != k:
        return {'status': 'EXCLUDED_DEPENDENT_SELECTED_X'}
    signatures = [sum(((X[i] & z).bit_count() % 2) << h for h, i in enumerate(selected)) for z in Z]
    zero = [j for j, signature in enumerate(signatures) if signature == 0]
    owners = [[j for j, signature in enumerate(signatures) if signature == 1 << h] for h in range(k)]
    # Prefix telescoping bounds arbitrary SIGNED weights at fixed full rank.
    order = sorted(zero, key=lambda j: (-weights[j], j))
    rows, ranks = {}, []
    for j in order:
        extend(rows, Z[j])
        ranks.append(len(rows))
    if len(rows) != 128 - k:
        return {'status': 'EXCLUDED_DEFICIENT_ZERO_POOL'}
    if any(not owner for owner in owners):
        return {'status': 'EXCLUDED_EMPTY_REQUIRED_OWNER'}
    upper = weights[order[-1]] * (128 - k) if order else 0
    upper += sum((weights[order[t]] - weights[order[t + 1]]) * ranks[t] for t in range(len(order) - 1))
    upper += sum(max(weights[j] for j in owner) for owner in owners)
    return {'status': 'EXACT_FULL_PARTNER_BASIS_SUPPORT', 'upper': Q(upper),
            'signatures': signatures, 'zero_rank': len(rows), 'prefix_checks': len(order)}


def check_witness(Z, selected, weights, domain, branch):
    assert branch['status'] == domain['status'], 'wrong_physical_branch_status'
    if domain['status'] != 'EXACT_FULL_PARTNER_BASIS_SUPPORT':
        assert not any(k in branch for k in ('score', 'basis_score', 'selected_Z_indices'))
        return
    chosen = branch['selected_Z_indices']
    assert len(chosen) == len(set(chosen)) == 128, 'full128_witness_required'
    assert all(isinstance(j, int) and 0 <= j < 720 for j in chosen)
    assert dimension(Z[j] for j in chosen) == 128
    evaluations = Counter(domain['signatures'][j] for j in chosen)
    expected = {0: 128 - len(selected), **{1 << h: 1 for h in range(len(selected))}}
    assert evaluations == Counter({k: v for k, v in expected.items() if v}), 'witness_owner_partition_failed'
    value = sum(weights[j] for j in chosen)
    assert Q(branch['basis_score']) == value == domain['upper'], 'witness_does_not_attain_exact_upper'


def normalization_controls(anchors, coefficients):
    rng = random.Random(202610300605)
    comparisons = wrong_phase_rejected = wrong_s_factor_rejected = 0
    for control in range(12):
        masks = [[rng.getrandbits(16) for _ in range(45)] for _ in (0, 1)]
        literal = reverse_literal = s_contribution = 0
        for sector in (0, 1):
            P0 = masks[sector][32]
            selected = [16 * o + h for o in range(45) for h in range(16) if masks[1 - sector][o] >> h & 1]
            for rotation in range(16):
                P = turn(P0, rotation)
                Qindices = [16 * (j // 16) + (j % 16 + rotation) % 16 for j in selected]
                s = int(bool(turn(masks[sector][13], rotation) & 1))
                sf = coefficients[0][0] + sum(coefficients[0][h + 1] for h in range(16) if P >> h & 1)
                w = literal_weights(P, anchors, coefficients)
                rw = literal_weights(P, anchors, coefficients, reverse=True)
                literal += sum(w[j] for j in Qindices) + 16 * s * sf
                reverse_literal += sum(rw[j] for j in Qindices) + 16 * s * sf
                s_contribution += s * sf
        corr = lambda a, b, h: (a & turn(b, -h)).bit_count()
        expected = 0
        for (side, orbit), c in zip(anchors, coefficients):
            expected += 16 * c[0] * sum(masks[s][orbit].bit_count() for s in (0, 1))
            expected += 16 * sum(c[h + 1] * sum(corr(masks[s][orbit], masks[s if side == 'S' else 1 - s][32], h) for s in (0, 1)) for h in range(16))
        assert literal == expected, 'factor16_or_phase_orientation_mismatch'
        wrong_phase_rejected += reverse_literal != expected
        wrong_s_factor_rejected += literal - 15 * s_contribution != expected
        comparisons += 1
    assert wrong_phase_rejected and wrong_s_factor_rejected
    return {'literal32_action_comparisons': comparisons,
            'wrong_phase_direction_controls_rejected': wrong_phase_rejected,
            'wrong_S_factor_controls_rejected': wrong_s_factor_rejected}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--bank', type=Path, required=True)
    ap.add_argument('--frozen', type=Path)
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    start = time.monotonic()
    d = read(args.bank)
    fp = args.frozen or Path(str(args.bank) + '.frozen.json')
    frozen = read(fp)
    assert d['frozen_sha256'] == sha(fp)
    assert d['point_sha256'] == frozen['point_sha256'] == sha(args.point)
    assert frozen['class_average_not_representative_only'] is True
    assert all(sha(ROOT / name) == expected for name, expected in frozen['source_hashes'].items())
    parent_path = ROOT / frozen['bank_path']
    assert sha(parent_path) == frozen['bank_sha256']
    parent = read(parent_path)
    anchors, coefficients = d['anchors'], d['anchor_coefficients']
    assert d['orbit'] == parent['orbit'] == 32
    assert anchors == parent['anchors'] and coefficients == parent['cuts'][0]['anchor_coefficients']
    assert anchors[0] == ['S', 13] and all(s == 'T' for s, o in anchors[1:])
    assert len(anchors) == 12 and all(len(c) == 17 and all(isinstance(v, int) for v in c) for c in coefficients)
    domain_path = ROOT / 'coupling-results/full-partner-orbit32.frozen.json'
    assert sha(domain_path) == frozen['domain_source_sha256']
    domain_source = read(domain_path)
    pp = ROOT / 'algebraic-results/orbit-rank-profiles.json.gz'
    hp = ROOT / 'algebraic-results/hulls-16-rank.json.gz'
    assert domain_source['profiles_sha256'] == sha(pp) and domain_source['hulls_sha256'] == sha(hp)
    profile_receipt_path = ROOT / 'algebraic-results/orbit-rank-profiles-independent.json'
    profile_receipt = read(profile_receipt_path)
    assert profile_receipt['status'] == 'PASS'
    assert profile_receipt['certificate_sha256'] == hashlib.sha256(gzip.decompress(pp.read_bytes())).hexdigest()
    profile = next(r for r in read(pp)['records'] if r['orbit'] == 32)
    forbidden = [c['mask'] for c in profile['minimal_bad_certificates']]
    allowed = [mask for mask in range(65536) if not any(mask & bad == bad for bad in forbidden)]
    assert len(allowed) == 4597 == domain_source['allowed_mask_count']
    representatives = sorted({min(turn(mask, h) for h in range(16)) for mask in allowed})
    assert representatives == domain_source['representatives'] and len(representatives) == 291
    cp = ROOT / 'coupling-results/conditional-compat-orbit32.json'
    rp = ROOT / 'coupling-results/conditional-compat-orbit32-independent.json'
    assert sha(cp) == frozen['conditional_bank_sha256'] and sha(rp) == frozen['conditional_replay_sha256']
    conditional, receipt = read(cp), read(rp)
    assert receipt['status'] == 'PASS' and receipt['bank_sha256'] == sha(cp)
    assert receipt['source_hashes'] == conditional['source_hashes']
    assert all(sha(ROOT / name) == expected for name, expected in conditional['source_hashes'].items())
    conditional_row = next(r for r in conditional['records'] if (r['orbit'], r['side'], r['anchor'], r['condition']) == (32, 'S', 13, 1))
    conditional_profile = read(ROOT / 'algebraic-results/conditional-capacity/case-13.json.gz')
    assert conditional_profile['conditioned_on_X_index'] == 208
    qr = next(r for r in conditional_profile['records'] if r['orbit'] == 32)
    cbad = [c['mask'] for c in qr['minimal_bad_certificates']]
    X, Z, pairing = physical()
    assert [X, Z] == [[int(v, 16) for v in (ROOT / f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
    assert dimension(X) == dimension(Z) == 128
    assert dimension([x | (z << 128) for x, z in zip(X, Z)]) == 128
    phase_index = lambda j: 16 * (j // 16) + (j % 16 + 1) % 16
    for i in range(720):
        assert all(((pairing[i] >> j) & 1) == ((pairing[j] >> i) & 1) for j in range(720))
        rotated_row = 0
        for orbit in range(45):
            block = (pairing[i] >> (16 * orbit)) & 65535
            rotated_row |= (((block << 1) & 65535) | (block >> 15)) << (16 * orbit)
        assert rotated_row == pairing[phase_index(i)]
    table = bytearray(65536)
    for mask in allowed:
        selected = [512 + h for h in range(16) if mask >> h & 1]
        table[mask] = int((mask & ~qr['eligible_mask']) == 0 and not any(mask & bad == bad for bad in cbad) and dimension([X[j] for j in selected] + [X[208]]) == len(selected) + 1)
    assert hashlib.sha256(table).hexdigest() == conditional_row['table_sha256']
    assert sum(table) == conditional_row['compatible'] == 2754
    assert [r['mask'] for r in d['mask_rows']] == allowed
    upper_by_mask = {}
    branch_counts = Counter()
    prefix_checks = witnesses = corruptions = 0
    for position, row in enumerate(d['mask_rows']):
        mask = row['mask']
        weights = literal_weights(mask, anchors, coefficients)
        sf = coefficients[0][0] + sum(coefficients[0][h + 1] for h in range(16) if mask >> h & 1)
        assert row['S_form'] == sf
        assert [b['included'] for b in row['branches']] == [0, 1]
        branch_scores = []
        for branch in row['branches']:
            included = branch['included']
            branch_counts[branch['status']] += 1
            if included and not table[mask]:
                assert branch == {'included': 1, 'status': 'EXCLUDED_CHECKED_CONDITIONAL_PROFILE'}
                continue
            selected = sorted([512 + h for h in range(16) if mask >> h & 1] + ([208] if included else []))
            domain = domain_and_upper(X, Z, selected, weights)
            check_witness(Z, selected, weights, domain, branch)
            if domain['status'] != 'EXACT_FULL_PARTNER_BASIS_SUPPORT':
                continue
            assert Q(branch['score']) == domain['upper'] + 16 * included * sf
            branch_scores.append(Q(branch['score']))
            prefix_checks += domain['prefix_checks']
            witnesses += 1
            if not corruptions:
                for corruption in ('short_basis', 'wrong_basis_score'):
                    bad = dict(branch)
                    if corruption == 'short_basis':
                        bad['selected_Z_indices'] = bad['selected_Z_indices'][:-1]
                    else:
                        bad['basis_score'] = str(Q(bad['basis_score']) + 1)
                    try:
                        check_witness(Z, selected, weights, domain, bad)
                    except AssertionError:
                        corruptions += 1
                    else:
                        raise AssertionError('corrupted_support_accepted')
        assert branch_scores and Q(row['upper']) == max(branch_scores)
        upper_by_mask[mask] = max(branch_scores)
        if position % 1000 == 0:
            print('PHYSICAL_TEMPLATE_MASKS', position + 1, 'seconds', time.monotonic() - start, flush=True)
    assert [r['representative'] for r in d['class_rows']] == representatives
    for row in d['class_rows']:
        members = {turn(row['representative'], h) for h in range(16)}
        assert row['size'] == len(members) and row['features'] == features(row['representative'])
        average = sum(upper_by_mask[m] for m in members) / len(members)
        assert average == Q(row['average_upper'])
        # Distinct-class averaging equals all16 rotations, including periods.
        assert average == sum(upper_by_mask[turn(row['representative'], h)] for h in range(16)) / 16
    hulls = read(hp)
    _, index, moment = layout(hulls)
    point = list(map(Q, read(args.point)['values']))
    targets = [Q(1), 16 * point[index['p', 32]], *[16 * point[moment('S', h, 32, 32)] for h in range(1, 9)]]
    fixed = 16 * sum(c[0] * point[index['p', orbit]] + sum(c[h + 1] * point[moment(side, h, orbit, 32)] for h in range(16)) for (side, orbit), c in zip(anchors, coefficients))
    assert targets == list(map(Q, d['target_features'])) and fixed == Q(d['fixed_anchor_target'])
    controls = normalization_controls(anchors, coefficients)
    results = []
    for proposal in d['proposals']:
        u = list(map(Q, proposal['unconditional_coefficients']))
        assert len(u) == 10 and proposal['normalization'] == 16
        assert math.lcm(*(c.denominator for c in u)) == proposal['integer_scale']
        slacks = [-sum(c * f for c, f in zip(u, row['features'])) - Q(row['average_upper']) for row in d['class_rows']]
        assert min(slacks) == 0, 'invalid_or_untight_feature_bound'
        exact = fixed + sum(c * t for c, t in zip(u, targets))
        assert exact == Q(proposal['exact_violation'])
        if proposal['origin'] == 'original_form_exact_constant_tightening':
            old = [16 * c for c in parent['cuts'][0]['unconditional_coefficients']]
            assert u[1:] == old[1:] and Q(proposal['corrected_constant']) == old[0] - u[0]
        results.append({'origin': proposal['origin'], 'exact_violation': str(exact),
            'normalized_exact_violation': str(exact / 16), 'strictly_separates_candidate': exact > 0})
    optimum = d['exact_feature_optimum']
    optimum_value = None
    if optimum is not None:
        u = list(map(Q, optimum['unconditional_coefficients']))
        active = optimum['active_rows']
        lam = list(map(Q, optimum['dual_weights']))
        assert len(active) == len(set(active)) == len(lam) == 10 and min(lam) >= 0
        assert all(0 <= j < len(d['class_rows']) for j in active)
        assert all(sum(c * f for c, f in zip(u, row['features'])) + Q(row['average_upper']) <= 0 for row in d['class_rows'])
        dual_target = [sum(weight * d['class_rows'][j]['features'][h] for weight, j in zip(lam, active)) for h in range(10)]
        assert dual_target == targets
        primal = sum(c * t for c, t in zip(u, targets))
        dual = -sum(weight * Q(d['class_rows'][j]['average_upper']) for weight, j in zip(lam, active))
        assert primal == dual
        optimum_value = fixed + primal
        assert optimum_value == Q(optimum['exact_violation'])
        assert optimum_value == max(Q(r['exact_violation']) for r in results)
    out = {'status': 'PASS', 'source_C16_answered': False, 'bank_sha256': sha(args.bank),
        'frozen_sha256': sha(fp), 'point_sha256': sha(args.point), 'consumer_sha256': sha(Path(__file__)),
        'source_dependencies': {'unconditional_profiles_sha256': sha(pp), 'unconditional_profile_receipt_sha256': sha(profile_receipt_path),
            'conditional_bank_sha256': sha(cp), 'conditional_replay_sha256': sha(rp),
            'conditional_table_sha256': hashlib.sha256(table).hexdigest(), 'physical_source_sha256': sha(ROOT / 'physical-pool-source.json')},
        'physical_pairings_reconstructed': 518400, 'sector_swap_pairing_checks': 518400,
        'phase_generator_pairing_checks': 518400, 'allowed_masks_independently_enumerated': len(allowed),
        'mask_branches_checked': sum(branch_counts.values()), 'branch_status_counts': dict(branch_counts),
        'full128_physical_basis_witnesses_checked': witnesses, 'exact_signed_prefix_rank_checks': prefix_checks,
        'cyclic_class_average_bounds_checked': len(representatives), 'class_averaging_all16_equivalence': True,
        'source_moment_normalization': 16, 'normalization_controls': controls,
        'corrupted_physical_supports_rejected': corruptions, 'proposals_checked': len(results), 'results': results,
        'exact_feature_primal_dual_optimum_checked': optimum is not None,
        'exact_feature_optimum': str(optimum_value) if optimum_value is not None else None,
        'normalized_exact_feature_optimum': str(optimum_value / 16) if optimum_value is not None else None,
        'candidate_separated': any(r['strictly_separates_candidate'] for r in results),
        'fixed_template_cannot_separate_candidate': optimum_value is not None and optimum_value <= 0,
        'profile_weights_fixed_in_separation': False, 'elapsed_seconds': time.monotonic() - start,
        'scope': 'Exact source-valid anchored/full-opposite-basis feature bounds. A nonpositive exact feature optimum proves only this fixed anchor-form template cannot separate this moment point; it is not full relaxation feasibility or a source frame.'}
    args.output.write_text(json.dumps(out, indent=2) + '\n')
    print(json.dumps({k: v for k, v in out.items() if k not in ('results', 'source_dependencies')}, indent=2))


if __name__ == '__main__':
    main()
