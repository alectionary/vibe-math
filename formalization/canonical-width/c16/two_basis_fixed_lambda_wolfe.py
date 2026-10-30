#!/usr/bin/env python3
"""Fixed-lambda Minkowski-sum L2 discovery with exact sixteen-pattern support.

Each new atom is a lambda-weighted aggregate of sixteen physical sector bases.
Atom zero is an independently accepted physical mixture, possibly interior.
Positive exact gaps are constraints on lambda at the frozen target, not global
moment cuts. Small numerical residuals never establish target membership.
"""
from pathlib import Path
from fractions import Fraction
import argparse
import datetime
import json
import math
import time

import numpy as np
from scipy.linalg import lstsq
from two_sided_full_basis_oracle import TwoSidedFullBasisOracle, target, source_hashes, sha, json_exact

ROOT = Path(__file__).resolve().parent
F = 3600


def write(path, obj):
    Path(path).write_text(json.dumps(json_exact(obj), indent=2) + '\n')


def rows(mask, basis):
    return [*basis, *[720 * (i + 1) + j for i in range(4) if mask >> i & 1 for j in basis]]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--initial', type=Path, required=True)
    ap.add_argument('--initial-receipt', type=Path, required=True)
    ap.add_argument('--controls', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--seconds', type=float, default=120)
    args = ap.parse_args()
    assert 0 < args.seconds <= 120 and not args.output.exists()
    prefix = args.output.with_suffix('')
    fp = prefix.with_name(prefix.name + '.frozen.json')
    cp = prefix.with_name(prefix.name + '.columns.npz')
    assert not fp.exists() and not cp.exists()
    initial = json.loads(args.initial.read_text())
    accepted = json.loads(args.initial_receipt.read_text())
    assert accepted['status'] == 'PASS_EXACT_PHYSICAL_SECTOR_MIXTURE_WITH_ERRORS'
    assert accepted['state_sha256'] == sha(args.initial)
    assert accepted['consumer_sha256'] == sha(ROOT / 'verify_two_basis_sector_state.py')
    assert accepted['point_sha256'] == initial['point_sha256'] == sha(args.point)
    controls = json.loads(args.controls.read_text())
    assert controls['status'] == 'PASS'
    assert controls['producer_sha256'] == sha(ROOT / 'two_sided_full_basis_oracle.py')
    assert controls['consumer_sha256'] == sha(ROOT / 'verify_two_sided_full_basis_oracle.py')
    xx, zz, side = initial['X_anchors'], initial['Z_anchors'], initial['side']
    assert side in ['X', 'Z']
    full_target = target(args.point, xx, zz)
    offset = 0 if side == 'X' else 720
    wanted = full_target[11 + offset:11 + offset + 720] + [
        full_target[1451 + 1440 * i + offset + j] for i in range(4) for j in range(720)]
    assert list(map(Fraction, initial['sector_target'])) == wanted
    lam = list(map(Fraction, initial['lambda_masses']))
    assert len(lam) == 16 and min(lam) >= 0 and sum(lam) == 1
    denominator = math.lcm(*(v.denominator for v in lam))
    assert 0 < denominator < (1 << 63), 'this bounded implementation stores aggregate numerators inint64'
    numerators = [int(v * denominator) for v in lam]
    initial_feature = [Fraction(0)] * F
    initial_mass = [Fraction(0)] * 16
    for r in initial['pattern_basis_records']:
        m, weight = r['mask'], Fraction(r['weight'])
        assert 0 <= m < 16 and weight > 0
        initial_mass[m] += weight
        for j in rows(m, r['selected_indices']):
            initial_feature[j] += weight
    assert initial_mass == lam and all(0 <= v <= 1 for v in initial_feature)
    assert all(x + Fraction(p) - Fraction(n) == t for x, p, n, t in zip(
        initial_feature, initial['positive_feature_errors'], initial['negative_feature_errors'], wanted))
    oracle = TwoSidedFullBasisOracle()
    domains = oracle.prepare(xx, zz)
    assert all(d['status'] == 'FULL_TWO_SIDED_BASIS_DOMAIN' for d in domains)
    b = np.asarray(list(map(float, wanted)))
    features = [np.asarray(list(map(float, initial_feature)))]
    # Atom0 is represented by the external accepted mixture, not by these
    # sentinels. Every later atom has an exact numerator and16 physical bases.
    feature_numerators = [np.zeros(F, dtype=np.int64)]
    physical_bases = [np.full((16, 128), -1, dtype=np.int16)]
    lookup = {}
    active, weights = [0], np.ones(1)
    scale = 1 << 24
    hashes = source_hashes()
    for path in [Path(__file__), args.initial, args.initial_receipt, args.controls,
                 ROOT / 'verify_two_sided_full_basis_oracle.py', ROOT / 'verify_two_basis_sector_state.py']:
        hashes[str(path.resolve().relative_to(ROOT))] = sha(path)
    frozen = dict(status='FROZEN_BEFORE_FIXED_LAMBDA_MINKOWSKI_WOLFE', source_C16_answered=False,
                  utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                  point_sha256=sha(args.point), point_c16_path=str(args.point.resolve().relative_to(ROOT)),
                  X_anchors=xx, Z_anchors=zz, side=side, lambda_masses=list(map(str, lam)),
                  sector_target=list(map(str, wanted)), feature_layout='U720,P_U[4,720].ravel(C)',
                  source_hashes=hashes, initial_atom_source=str(args.initial.resolve().relative_to(ROOT)),
                  initial_atom_sha256=sha(args.initial), initial_receipt_sha256=sha(args.initial_receipt),
                  initial_atom_is_extreme_vertex=False, selection_patterns=list(range(16)),
                  aggregate_feature_denominator=str(denominator), seconds=args.seconds,
                  pricing_scale=scale, metric='raw Euclidean on3600 sector features',
                  scope='FixedlambdaMinkowski sum; strict exactgap giveslambdarow only. No globalmomentcut ormembershipfromnumerics.')
    write(fp, frozen)
    start = time.monotonic()
    deadline = start + args.seconds

    def mixture(ids, w):
        return w @ np.asarray([features[i] for i in ids])

    def objective(x):
        return .5 * float(np.dot(x - b, x - b))

    def correct(ids, w):
        ids, w = list(ids), w.copy()
        rank = 0
        for minor in range(1000):
            if time.monotonic() >= deadline:
                return ids, w, minor, rank, 'TIME_LIMIT_DURING_CORRECTION'
            V = np.asarray([features[i] for i in ids])
            old = objective(w @ V)
            if len(ids) == 1:
                alpha = np.ones(1)
            else:
                eta, _, rank, _ = lstsq((V[1:] - V[0]).T, b - V[0], cond=1e-12, lapack_driver='gelsy')
                if rank != len(ids) - 1:
                    return ids, w, minor, int(rank), 'AFFINE_RANK_FAILURE'
                alpha = np.r_[1 - eta.sum(), eta]
            assert np.all(np.isfinite(alpha))
            if min(alpha) >= -1e-11:
                w = np.maximum(alpha, 0)
                w /= sum(w)
                keep = w > 0
                ids, w = [i for i, k in zip(ids, keep) if k], w[keep]
                assert objective(mixture(ids, w)) <= old + 1e-9 * max(1., old)
                return ids, w, minor + 1, int(rank), None
            bad = np.flatnonzero(alpha < 0)
            ratios = w[bad] / (w[bad] - alpha[bad])
            hit = int(bad[np.argmin(ratios)])
            theta = float(min(ratios))
            assert -1e-12 <= theta <= 1 + 1e-12
            w = (1 - theta) * w + theta * alpha
            w[hit] = 0
            assert min(w) >= -1e-10
            w = np.maximum(w, 0)
            w /= sum(w)
            keep = w > 0
            ids, w = [i for i, k in zip(ids, keep) if k], w[keep]
            assert objective(mixture(ids, w)) <= old + 1e-9 * max(1., old)
        return ids, w, 1000, int(rank), 'MINOR_CYCLE_LIMIT'

    rounds, cuts = [], []
    reason = 'ROUND_LIMIT'
    last_coefficients = [0] * F
    last_support_records = []
    for iteration in range(10000):
        if time.monotonic() >= deadline:
            reason = 'TIME_LIMIT'
            break
        before = time.monotonic()
        active, weights, minor, rank, failure = correct(active, weights)
        x = mixture(active, weights)
        raw = b - x
        norm = float(max(abs(raw)))
        rec = dict(round=iteration, active_atoms=len(active), history_atoms=len(features),
                   objective=objective(x), max_feature_residual=norm, feature_L1_residual=float(sum(abs(raw))),
                   correction_seconds=time.monotonic() - before, minor_cycles=minor,
                   affine_rank=rank, correction_failure=failure, weight_mass=float(sum(weights)),
                   minimum_weight=float(min(weights)))
        rounds.append(rec)
        if failure:
            reason = failure
            break
        stationarity = float(max(abs((np.asarray([features[i] for i in active]) - x) @ raw)))
        rec['corral_stationarity_residual'] = stationarity
        if stationarity > 1e-7 * max(1., norm):
            reason = 'CORRAL_STATIONARITY_FAILURE'
            break
        if norm <= 1e-10:
            reason = 'NUMERICAL_MIXTURE_REQUIRES_EXACT_RECOVERY'
            break
        direction = raw / norm
        c = [int(np.rint(v * scale)) for v in direction]
        last_coefficients = c
        before = time.monotonic()
        records, bounds = [], []
        numerator = np.zeros(F, dtype=np.int64)
        atom_bases = np.zeros((16, 128), dtype=np.int16)
        for m, d in enumerate(domains):
            potential = [c[j] + sum(c[720 * (i + 1) + j] for i in range(4) if m >> i & 1)
                         for j in range(720)]
            full = potential + [0] * 720 if side == 'X' else [0] * 720 + potential
            support = oracle.support_pattern(d, full)[f'{side}_support']
            h = support['value']
            assert Fraction(h).denominator == 1
            B = support['selected_indices']
            records.append(dict(mask=m, value=int(h), selected_indices=B,
                                zero_basis_indices=support['zero_basis_indices'], owner_indices=support['owner_indices']))
            bounds.append(int(h))
            atom_bases[m] = B
            numerator[rows(m, B)] += numerators[m]
        assert min(numerator) >= 0 and max(numerator) <= denominator
        f = numerator.astype(float) / denominator
        key = numerator.tobytes()
        atom = lookup.get(key)
        if atom is None:
            atom = len(features)
            lookup[key] = atom
            features.append(f)
            feature_numerators.append(numerator)
            physical_bases.append(atom_bases)
        left = sum(v * t for v, t in zip(c, wanted))
        right = sum(v * t for v, t in zip(bounds, lam))
        gap = left - right
        last_support_records = records
        scores = np.asarray(features) @ direction
        chosen = int(np.argmax(scores))
        improvement = float(scores[chosen] - direction @ x)
        quantization = float(sum(abs(direction - np.asarray(c) / scale)))
        rec.update(pricing_seconds=time.monotonic() - before, exact_left=str(left),
                   exact_right_at_lambda=str(right), exact_violation=str(gap),
                   normalized_violation=float(gap / scale), priced_atom=atom, chosen_atom=chosen,
                   true_gradient_improvement=improvement, quantization_advantage_bound=quantization,
                   numerical_Wolfe_upper_with_rounding=improvement + quantization)
        print(json.dumps(rec), flush=True)
        if gap > 0:
            cuts.append(dict(side=side, X_anchors=xx, Z_anchors=zz, coefficients=c,
                             exact_left=str(left), pattern_bounds=bounds, lambda_masses=list(map(str, lam)),
                             exact_right_at_lambda=str(right), exact_violation=str(gap), support_records=records,
                             inequality='sum_m pattern_bounds[m]*lambda[m] >= exact_left'))
            reason = 'EXACT_FIXED_LAMBDA_SECTOR_SEPARATOR_CANDIDATE'
            break
        if improvement <= 1e-12:
            reason = 'NO_TRUE_GRADIENT_IMPROVEMENT_FROM_ROUNDED_PRICING'
            break
        if chosen in active:
            reason = 'PRICED_ATOM_ALREADY_IN_CORRAL'
            break
        active.append(chosen)
        weights = np.r_[weights, 0.]
        if iteration % 20 == 0:
            write(prefix.with_name(prefix.name + '.progress.json'),
                  dict(status='RUNNING', elapsed_seconds=time.monotonic() - start, rounds=rounds))
    global_weights = np.zeros(len(features))
    global_weights[np.asarray(active, dtype=np.int64)] = weights
    np.savez_compressed(cp, features=np.asarray(features), feature_numerators=np.asarray(feature_numerators),
                        pattern_selected_indices=np.asarray(physical_bases),
                        aggregate_feature_denominator=str(denominator),
                        master_mixture_weights=global_weights, active_atom_ids=np.asarray(active, dtype=np.int32),
                        last_integer_direction=np.asarray(last_coefficients, dtype=np.int64))
    assert all(sha(ROOT / p) == h for p, h in hashes.items())
    result = dict(frozen)
    result.update(status='EXACT_FIXED_LAMBDA_SECTOR_SEPARATOR_CANDIDATE' if cuts else 'BOUNDED_FIXED_LAMBDA_L2_INCONCLUSIVE',
                  frozen_sha256=sha(fp), cuts=cuts, rounds=rounds, stopping_reason=reason,
                  elapsed_seconds=time.monotonic() - start, history_atoms=len(features),
                  final_active_atom_ids=active, final_numeric_weights=weights.tolist(),
                  columns_artifact=str(cp), columns_sha256=sha(cp),
                  last_integer_direction=last_coefficients, last_support_records=last_support_records,
                  numeric_max_feature_residual=float(max(abs(mixture(active, weights) - b))),
                  numeric_feature_L1_residual=float(sum(abs(mixture(active, weights) - b))),
                  exact_membership_proved=False, global_moment_cut_proved=False)
    write(args.output, result)
    print(json.dumps({k: result[k] for k in ('status', 'stopping_reason', 'elapsed_seconds', 'history_atoms',
                                           'numeric_max_feature_residual', 'numeric_feature_L1_residual')}), flush=True)


if __name__ == '__main__':
    main()
