#!/usr/bin/env python3
"""Jointly lift all old S13 and T anchor forms over sixteen phases.

For P in orbit32 and phase t of S13, let L_t(P)=L(rotate(P,-t)). Every
nonpositive L_t can be omitted from a maximizing selected-X subset: deleting
that X constraint enlarges the compatible full-Z-basis family. The positive
set has at most five phases for the frozen old functional. Enumerating all
positive subsets on291 representatives requires1211 full-basis-domain queries.

The complete phase objective is covariant. Its expectation is16 times the
old twelve-anchor moment functional, not256 times. No factor16 multiplies
individual S-phase terms inside a branch.
"""
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter
import argparse, gzip, hashlib, json, math, time
import numpy as np
from scipy.optimize import linprog
from flint import fmpq, fmpq_mat
from full_partner_basis_oracle import FullPartnerBasisOracle
from conditional_profile_compatibility import ConditionalProfileCompatibility
from full_partner_projection_features import candidate_weights, column_features, rotate
from certify_profile_moment_point import layout

ROOT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    raw = Path(path).read_bytes()
    return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)


def dump(path, data):
    raw = (json.dumps(data, indent=2) + '\n').encode()
    Path(path).write_bytes(gzip.compress(raw, mtime=0) if str(path).endswith('.gz') else raw)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--bank', type=Path, default=ROOT / 'moment-resumption-results/common-profile32-projected-pruned.json')
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--projected-output', type=Path)
    ap.add_argument('--q-profile', action='store_true')
    ap.add_argument('--baseline', type=Path)
    args = ap.parse_args()
    start = time.monotonic()
    parent = read(args.bank)
    assert parent['orbit'] == 32 and parent['anchors'][0] == ['S', 13]
    anchors, coefficients = parent['anchors'], parent['cuts'][0]['anchor_coefficients']
    assert len(anchors) == 12 and all(s == 'T' for s, o in anchors[1:])
    sform = coefficients[0]
    compatibility_path = ROOT / 'coupling-results/conditional-compat-orbit32.json'
    compatibility_replay = ROOT / 'coupling-results/conditional-compat-orbit32-independent.json'
    compatibility, replay = read(compatibility_path), read(compatibility_replay)
    assert replay['status'] == 'PASS' and replay['bank_sha256'] == sha(compatibility_path)
    assert compatibility['source_hashes'] == replay['source_hashes']
    assert all(sha(ROOT / p) == expected for p, expected in compatibility['source_hashes'].items())
    cp = ConditionalProfileCompatibility()
    table = cp.table(32, 'S', 13, 1)
    table_record = next(r for r in compatibility['records'] if (r['orbit'], r['side'], r['anchor'], r['condition']) == (32, 'S', 13, 1))
    assert hashlib.sha256(table.tobytes()).hexdigest() == table_record['table_sha256']
    domain_path = ROOT / 'coupling-results/full-partner-orbit32.frozen.json'
    representatives = read(domain_path)['representatives']
    assert len(representatives) == 291
    qtable = cp.unconditional(13) if args.q_profile else None
    cohort = []
    for mask in representatives:
        forms = [sform[0] + sum(sform[1 + (h - t) % 16] for h in range(16) if mask >> h & 1) for t in range(16)]
        positive = [t for t, value in enumerate(forms) if value > 0]
        cohort.append({'mask': mask, 'S_phase_forms': forms, 'positive_S_phases': positive,
                       'subsets_to_enumerate': 1 << len(positive)})
    assert max(len(r['positive_S_phases']) for r in cohort) == 5
    assert sum(r['subsets_to_enumerate'] for r in cohort) == 1211
    source_paths = ['full_phase_anchor_partner_template.py', 'full_partner_basis_oracle.py',
        'full_partner_projection_features.py', 'conditional_profile_compatibility.py',
        'pools/xcoords.txt', 'pools/zcoords.txt', 'physical-pool-source.json',
        'algebraic-results/orbit-rank-profiles.json.gz', 'algebraic-results/hulls-16-rank.json.gz',
        'algebraic-results/orbit-rank-profiles-independent.json']
    frozen = {'status': 'FROZEN_BEFORE_FULL_PHASE_ANCHOR_TEMPLATE', 'source_C16_answered': False,
        'point_sha256': sha(args.point), 'parent_bank_sha256': sha(args.bank),
        'parent_bank_path': str(args.bank.resolve().relative_to(ROOT)),
        'conditional_bank_sha256': sha(compatibility_path), 'conditional_replay_sha256': sha(compatibility_replay),
        'conditional_table_sha256': table_record['table_sha256'], 'domain_source_sha256': sha(domain_path),
        'source_hashes': {p: sha(ROOT / p) for p in source_paths}, 'cohort': cohort,
        'positive_subsets_to_enumerate': 1211, 'q_profile_enforced': args.q_profile,
        'q_profile_table_sha256': hashlib.sha256(qtable.tobytes()).hexdigest() if qtable is not None else None,
        'baseline_path': str(args.baseline.resolve().relative_to(ROOT)) if args.baseline else None,
        'baseline_sha256': sha(args.baseline) if args.baseline else None,
        'normalization': 'One term per S phase, all16 T phases; expected total is16 times original12 forms.',
        'scope': 'Fixed old anchor forms and exact whole-opposite-basis support; no remaining-X full completion required.'}
    fp = Path(str(args.output) + '.frozen.json')
    dump(fp, frozen)
    tc = [0] * 775
    for (side, orbit), c in zip(anchors, coefficients):
        if side == 'T':
            tc[10 + orbit] += c[0]
            for h in range(16):
                tc[55 + 16 * orbit + (-h) % 16] += c[h + 1]
    oracle = FullPartnerBasisOracle()
    rows, statuses = [], Counter()
    for entry in cohort:
        mask, positive, forms = entry['mask'], entry['positive_S_phases'], entry['S_phase_forms']
        weights = candidate_weights(mask, tc)
        branches = []
        for bits in range(1 << len(positive)):
            phases = [t for j, t in enumerate(positive) if bits >> j & 1]
            qmask = sum(1 << t for t in phases)
            branch = {'Q_mask': qmask, 'selected_S_phases': phases, 'S_score': sum(forms[t] for t in phases)}
            failed = [t for t in phases if not table[rotate(mask, -t)]]
            if failed:
                branch.update(status='EXCLUDED_INDIVIDUAL_CONDITIONAL_PROFILE', failed_S_phases=failed)
            elif qtable is not None and not qtable[qmask]:
                branch['status'] = 'EXCLUDED_UNCONDITIONAL_Q_PROFILE'
            else:
                domain = oracle.prepare(32, mask, [208 + t for t in phases])
                support = oracle.support(domain, weights)
                branch['status'] = support['status']
                if support['value'] is not None:
                    branch.update(basis_score=str(support['value']), score=str(support['value'] + branch['S_score']),
                                  selected_Z_indices=list(support['selected_Z_indices']))
            statuses[branch['status']] += 1
            branches.append(branch)
        upper = max(Q(b['score']) for b in branches if 'score' in b)
        rows.append({**entry, 'features': list(column_features(mask, ())[:10]), 'branches': branches, 'upper': str(upper)})
    assert sum(statuses.values()) == 1211
    attribution = None
    if args.baseline:
        baseline = read(args.baseline)
        assert baseline['point_sha256'] == sha(args.point) and baseline['anchors'] == anchors
        assert baseline['anchor_coefficients'] == coefficients and not baseline['q_profile_enforced']
        assert [r['mask'] for r in baseline['records']] == representatives
        changes = [Q(old['upper']) - Q(new['upper']) for old, new in zip(baseline['records'], rows)]
        assert min(changes) >= 0
        attribution = {'strictly_improved_representatives': sum(x > 0 for x in changes),
            'maximum_exact_support_improvement': str(max(changes)),
            'additional_Q_profile_exclusions': statuses['EXCLUDED_UNCONDITIONAL_Q_PROFILE']}
    hulls = read(ROOT / 'algebraic-results/hulls-16-rank.json.gz')
    _, index, moment = layout(hulls)
    point = list(map(Q, read(args.point)['values']))
    targets = [Q(1), 16 * point[index['p', 32]], *[16 * point[moment('S', h, 32, 32)] for h in range(1, 9)]]
    fixed = 16 * sum(c[0] * point[index['p', orbit]] + sum(c[h + 1] * point[moment(side, h, orbit, 32)] for h in range(16)) for (side, orbit), c in zip(anchors, coefficients))
    A = np.array([r['features'] for r in rows], dtype=float)
    rhs = [-Q(r['upper']) for r in rows]
    lp = linprog(-np.array(list(map(float, targets))), A_ub=A, b_ub=list(map(float, rhs)), bounds=[(None, None)] * 10, method='highs')
    proposals, optimum = [], None
    def save(u, origin):
        u = list(map(Q, u))
        correction = max(sum(c * f for c, f in zip(u, r['features'])) + Q(r['upper']) for r in rows)
        u[0] -= correction
        value = fixed + sum(c * t for c, t in zip(u, targets))
        proposals.append({'origin': origin, 'unconditional_coefficients': list(map(str, u)),
            'exact_violation': str(value), 'normalized_exact_violation': str(value / 16),
            'normalization': 16, 'integer_scale': math.lcm(*(x.denominator for x in u)),
            'corrected_constant': str(correction)})
    save([16 * c for c in parent['cuts'][0]['unconditional_coefficients']], 'original_form_exact_constant_tightening')
    if lp.success:
        for denominator in (1, 16, 256, 4096):
            save([Q(round(float(x) * denominator), denominator) for x in lp.x], 'rounded_LP_exactly_corrected')
        candidates = [j for j, value in enumerate(lp.ineqlin.marginals) if abs(value) > 1e-8]
        candidates += [j for j, value in enumerate(lp.ineqlin.residual) if abs(value) < 1e-7 and j not in candidates]
        active = []
        for j in candidates:
            if fmpq_mat([rows[k]['features'] for k in active + [j]]).rank() > len(active):
                active.append(j)
            if len(active) == 10:
                break
        if len(active) == 10:
            B = fmpq_mat([rows[j]['features'] for j in active])
            u = [Q(str(x)) for x in B.solve(fmpq_mat([[fmpq(str(rhs[j]))] for j in active]))]
            lam = [Q(str(x)) for x in B.transpose().solve(fmpq_mat([[fmpq(str(t))] for t in targets]))]
            if min(lam) >= 0 and all(sum(c * f for c, f in zip(u, row['features'])) <= b for row, b in zip(rows, rhs)):
                assert sum(c * t for c, t in zip(u, targets)) == sum(weight * rhs[j] for weight, j in zip(lam, active))
                optimum = {'unconditional_coefficients': list(map(str, u)), 'active_rows': active,
                    'dual_weights': list(map(str, lam)), 'exact_violation': str(fixed + sum(c * t for c, t in zip(u, targets)))}
                save(u, 'exact_primal_dual_feature_optimum')
    best = max(proposals, key=lambda p: Q(p['exact_violation']))
    scale = best['integer_scale']
    cuts = []
    if Q(best['exact_violation']) > 0:
        cuts.append({'unconditional_coefficients': [int(Q(c) * scale) for c in best['unconditional_coefficients']],
            'anchor_coefficients': [[16 * scale * c for c in row] for row in coefficients],
            'exact_violation': str(scale * Q(best['exact_violation'])), 'scale': 16 * scale,
            'normalized_exact_violation': best['normalized_exact_violation'], 'origin': best['origin']})
    projected_output = args.projected_output or Path(str(args.output).removesuffix('.gz').removesuffix('.json') + '-projected.json')
    out = {'status': 'CANDIDATE_REQUIRES_INDEPENDENT_REPLAY', 'source_C16_answered': False,
        'orbit': 32, 'anchors': anchors, 'anchor_coefficients': coefficients,
        'point_sha256': sha(args.point), 'point_path': str(args.point.resolve().relative_to(ROOT)),
        'frozen_sha256': sha(fp), 'q_profile_enforced': args.q_profile, 'Q_profile_attribution': attribution,
        'representatives': len(rows), 'positive_subsets_enumerated': sum(statuses.values()),
        'branch_status_counts': dict(statuses), 'records': rows, 'target_features': list(map(str, targets)),
        'fixed_anchor_target': str(fixed), 'LP_status': int(lp.status), 'LP_message': lp.message,
        'proposals': proposals, 'exact_feature_optimum': optimum, 'cuts': cuts,
        'projected_output': str(projected_output.resolve().relative_to(ROOT)) if cuts else None,
        'elapsed_seconds': time.monotonic() - start,
        'scope': 'Exact full-phase fixed-form support candidate; pointwise covariance reduces checking to291 representatives. Source completion remains relaxed; independent physical support, covariance and moment replay required.'}
    dump(args.output, out)
    if cuts:
        canonical = {'status': 'CANDIDATE_REQUIRES_INDEPENDENT_REPLAY', 'source_C16_answered': False,
            'orbit': 32, 'anchors': anchors, 'cuts': cuts, 'point_sha256': sha(args.point),
            'profile_weights_free': True, 'proof_kind': 'full_phase_anchor_full_partner_basis',
            'support_bank': str(args.output.resolve().relative_to(ROOT)), 'support_bank_sha256': sha(args.output),
            'q_profile_enforced': args.q_profile,
            'scope': 'Projected degree-two necessity from all-phase S-anchor subsets and exact full opposite-basis supports; independent consumer required.'}
        dump(projected_output, canonical)
    print(json.dumps({k: v for k, v in out.items() if k not in ('records', 'proposals', 'cuts', 'anchors', 'anchor_coefficients', 'target_features')}, indent=2))
    print('BEST_PROPOSAL', json.dumps(best))


if __name__ == '__main__':
    main()
