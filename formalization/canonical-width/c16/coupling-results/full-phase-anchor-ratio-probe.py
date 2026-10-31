#!/usr/bin/env python3
"""Optimize a nonnegative S13/T relative scale using frozen branch supports.

No basis oracle is run. The supplied full-phase support bank must separately
pass an independent source/physical consumer. Every retained proposal uses
exact branch bounds; an exact11-variable primal/dual optimum is recovered when
possible. The T-form scale remains1, and all sixteen phase forms have their
usual expectation16 times their phase-zero moment form.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse, gzip, hashlib, json, math, sys, time
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import numpy as np
from scipy.optimize import linprog
from flint import fmpq, fmpq_mat
from certify_profile_moment_point import layout


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    raw = Path(path).read_bytes()
    return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)


def dump(path, data):
    Path(path).write_text(json.dumps(data, indent=2) + '\n')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--support-bank', type=Path, required=True)
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--projected-output', type=Path)
    args = ap.parse_args()
    start = time.monotonic()
    bank = read(args.support_bank)
    assert bank['point_sha256'] == sha(args.point)
    assert bank['orbit'] == 32 and bank['anchors'][0] == ['S', 13]
    coefficients = bank['anchor_coefficients']
    anchors = bank['anchors']
    hulls = read(ROOT / 'algebraic-results/hulls-16-rank.json.gz')
    _, index, moment = layout(hulls)
    point = list(map(Q, read(args.point)['values']))
    features = [Q(1), 16 * point[index['p', 32]], *[16 * point[moment('S', h, 32, 32)] for h in range(1, 9)]]
    forms = [16 * (c[0] * point[index['p', orbit]] + sum(c[h + 1] * point[moment(side, h, orbit, 32)] for h in range(16))) for (side, orbit), c in zip(anchors, coefficients)]
    assert features == list(map(Q, bank['target_features']))
    assert sum(forms) == Q(bank['fixed_anchor_target'])
    s_target, t_target = forms[0], sum(forms[1:])
    targets = features + [s_target]
    rows, rhs, row_ids = [], [], []
    for ri, record in enumerate(bank['records']):
        for bi, branch in enumerate(record['branches']):
            if branch['status'] == 'EXACT_FULL_PARTNER_BASIS_SUPPORT':
                rows.append(record['features'] + [branch['S_score']])
                rhs.append(-Q(branch['basis_score']))
                row_ids.append({'record': ri, 'mask': record['mask'], 'branch': bi, 'Q_mask': branch['Q_mask']})
    branch_count = len(rows)
    rows.append([0] * 10 + [-1]); rhs.append(Q(0)); row_ids.append({'constraint': 'alpha_nonnegative'})
    frozen = {'status': 'FROZEN_BEFORE_FULL_PHASE_RELATIVE_S_OPTIMIZATION', 'source_C16_answered': False,
        'support_bank': str(args.support_bank.resolve().relative_to(ROOT)), 'support_bank_sha256': sha(args.support_bank),
        'point_sha256': sha(args.point), 'producer_sha256': sha(Path(__file__)),
        'source_branch_rows': branch_count, 'nonnegative_alpha_constraint': True,
        'features_target': list(map(str, features)), 'S_target': str(s_target), 'T_target': str(t_target),
        'scope': 'Eleven-variable feature/relative-S LP over previously frozen full-phase physical support branches; T scale fixed1.'}
    fp = Path(str(args.output) + '.frozen.json')
    dump(fp, frozen)
    proposals, optimum = [], None
    def save(u, alpha, origin):
        u, alpha = list(map(Q, u)), Q(alpha)
        assert len(u) == 10 and alpha >= 0
        correction = max(sum(c * f for c, f in zip(u, row[:10])) + alpha * row[10] - b for row, b in zip(rows[:-1], rhs[:-1]))
        u[0] -= correction
        value = t_target + alpha * s_target + sum(c * t for c, t in zip(u, features))
        proposals.append({'origin': origin, 'unconditional_coefficients': list(map(str, u)),
            'relative_S_scale': str(alpha), 'T_scale': 1, 'exact_violation': str(value),
            'normalized_exact_violation': str(value / 16), 'normalization': 16,
            'integer_scale': math.lcm(alpha.denominator, *(c.denominator for c in u)),
            'corrected_constant': str(correction)})
    baseline_best = max(bank['proposals'], key=lambda r: Q(r['exact_violation']))
    save(baseline_best['unconditional_coefficients'], Q(1), 'fixed_alpha1_baseline')
    lp = linprog(-np.array(list(map(float, targets))), A_ub=np.array(rows, dtype=float),
                 b_ub=list(map(float, rhs)), bounds=[(None, None)] * 11, method='highs')
    if lp.success:
        for denominator in (1, 16, 256, 4096):
            rounded = [Q(round(float(x) * denominator), denominator) for x in lp.x]
            if rounded[10] >= 0:
                save(rounded[:10], rounded[10], 'rounded_relative_scale_LP_exactly_corrected')
        candidates = [j for j, value in enumerate(lp.ineqlin.marginals) if abs(value) > 1e-8]
        candidates += [j for j, value in enumerate(lp.ineqlin.residual) if abs(value) < 1e-7 and j not in candidates]
        active = []
        for j in candidates:
            if fmpq_mat([rows[k] for k in active + [j]]).rank() > len(active):
                active.append(j)
            if len(active) == 11:
                break
        if len(active) == 11:
            B = fmpq_mat([rows[j] for j in active])
            u = [Q(str(x)) for x in B.solve(fmpq_mat([[fmpq(str(rhs[j]))] for j in active]))]
            lam = [Q(str(x)) for x in B.transpose().solve(fmpq_mat([[fmpq(str(t))] for t in targets]))]
            if u[10] >= 0 and min(lam) >= 0 and all(sum(c * f for c, f in zip(u, row)) <= b for row, b in zip(rows, rhs)):
                primal = sum(c * t for c, t in zip(u, targets))
                assert primal == sum(weight * rhs[j] for weight, j in zip(lam, active))
                optimum = {'unconditional_coefficients': list(map(str, u[:10])), 'relative_S_scale': str(u[10]),
                    'active_rows': active, 'dual_weights': list(map(str, lam)), 'exact_violation': str(t_target + primal)}
                save(u[:10], u[10], 'exact_relative_scale_primal_dual_optimum')
    best = max(proposals, key=lambda r: Q(r['exact_violation']))
    scale, alpha = best['integer_scale'], Q(best['relative_S_scale'])
    cuts = []
    if Q(best['exact_violation']) > 0:
        cuts.append({'unconditional_coefficients': [int(scale * Q(c)) for c in best['unconditional_coefficients']],
            'anchor_coefficients': [[int(16 * scale * (alpha if side == 'S' else 1) * c) for c in row] for (side, orbit), row in zip(anchors, coefficients)],
            'exact_violation': str(scale * Q(best['exact_violation'])), 'scale': 16 * scale,
            'relative_S_scale': str(alpha), 'T_scale': 1, 'normalized_exact_violation': best['normalized_exact_violation'],
            'origin': best['origin']})
    projected_output = args.projected_output or Path(str(args.output).removesuffix('.json') + '-projected.json')
    out = {'status': 'CANDIDATE_REQUIRES_INDEPENDENT_REPLAY', 'source_C16_answered': False,
        'orbit': 32, 'anchors': anchors, 'anchor_coefficients': coefficients,
        'point_sha256': sha(args.point), 'frozen_sha256': sha(fp),
        'support_bank': str(args.support_bank.resolve().relative_to(ROOT)), 'support_bank_sha256': sha(args.support_bank),
        'source_branch_rows': branch_count, 'constraint_rows': len(rows), 'constraint_row_ids': row_ids,
        'targets': list(map(str, targets)), 'T_target': str(t_target),
        'LP_status': int(lp.status), 'LP_message': lp.message, 'proposals': proposals,
        'exact_relative_scale_optimum': optimum, 'cuts': cuts,
        'exact_gain_over_alpha1': str(Q(best['exact_violation']) - Q(baseline_best['exact_violation'])),
        'projected_output': str(projected_output.resolve().relative_to(ROOT)) if cuts else None,
        'elapsed_seconds': time.monotonic() - start,
        'scope': 'Relative-S optimization is exact only if its rational primal/dual certificate passes, and all support rows still require their separate physical consumer. A nonoptimal numerical status is inconclusive.'}
    dump(args.output, out)
    if cuts:
        dump(projected_output, {'status': 'CANDIDATE_REQUIRES_INDEPENDENT_REPLAY', 'source_C16_answered': False,
            'orbit': 32, 'anchors': anchors, 'cuts': cuts, 'point_sha256': sha(args.point),
            'profile_weights_free': True, 'proof_kind': 'full_phase_anchor_full_partner_basis_relative_scale',
            'support_bank': str(args.support_bank.resolve().relative_to(ROOT)), 'support_bank_sha256': sha(args.support_bank),
            'ratio_bank': str(args.output.resolve().relative_to(ROOT)), 'ratio_bank_sha256': sha(args.output)})
    print(json.dumps({k: v for k, v in out.items() if k not in ('proposals', 'constraint_row_ids', 'anchors', 'anchor_coefficients', 'cuts')}, indent=2))
    print('BEST_PROPOSAL', json.dumps(best))


if __name__ == '__main__':
    main()
