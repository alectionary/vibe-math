#!/usr/bin/env python3
"""Primal-feasible warm-basis diagnostic for fixed-lambda sector allocation.

A separator here is a row in the sixteen shared pattern masses, at a frozen
moment target. It is NOT a global moment inequality until an outer combination
is established and the resulting full functional is exactly repriced.
"""
from pathlib import Path
from fractions import Fraction
import argparse
import datetime
import json
import time

import highspy
import numpy as np
from two_sided_full_basis_oracle import (
    TwoSidedFullBasisOracle, PAIRS, target, rank, source_hashes, sha, json_exact,
)

ROOT = Path(__file__).resolve().parent
SECTOR_FEATURES = 3600


def write(path, obj):
    Path(path).write_text(json.dumps(json_exact(obj), indent=2) + '\n')


def sector_target(point, xx, zz, side):
    full = target(point, xx, zz)
    offset = 0 if side == 'X' else 720
    return full[11 + offset:11 + offset + 720] + [
        full[1451 + 1440 * i + offset + j] for i in range(4) for j in range(720)]


def feature_rows(mask, basis):
    """Rows of a sector's binary (U,P_U) vector, without the mass row."""
    return [*basis, *[720 * (i + 1) + j for i in range(4) if mask >> i & 1 for j in basis]]


def read_lambda(path, point, xx, zz):
    bank = json.loads(Path(path).read_text())
    assert bank['point_sha256'] == sha(point)
    assert bank['X_anchors'] == xx and bank['Z_anchors'] == zz
    lam = list(map(Fraction, bank['lambda_masses']))
    assert len(lam) == 16 and min(lam) >= 0 and sum(lam) == 1
    wanted = target(point, xx, zz)[:11]
    for row in range(11):
        if row == 0:
            values = [1] * 16
        elif row < 5:
            values = [m >> (row - 1) & 1 for m in range(16)]
        else:
            i, j = PAIRS[row - 5]
            values = [(m >> i & 1) * (m >> j & 1) for m in range(16)]
        assert sum(w * v for w, v in zip(lam, values)) == wanted[row]
    return lam


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--side', choices=['X', 'Z'], required=True)
    ap.add_argument('--X', type=int, nargs=2, required=True)
    ap.add_argument('--Z', type=int, nargs=2, required=True)
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--lambda-source', type=Path, required=True)
    ap.add_argument('--archive-report', type=Path, required=True)
    ap.add_argument('--archive-receipt', type=Path, required=True)
    ap.add_argument('--controls', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--seconds', type=float, default=30)
    ap.add_argument('--max-rounds', type=int, default=100)
    args = ap.parse_args()
    assert 0 < args.seconds <= 30 and args.max_rounds > 0 and not args.output.exists()
    prefix = args.output.with_suffix('')
    fp = prefix.with_name(prefix.name + '.frozen.json')
    cp = prefix.with_name(prefix.name + '.columns.npz')
    assert not fp.exists() and not cp.exists()
    preparation_start = time.monotonic()
    lam = read_lambda(args.lambda_source, args.point, args.X, args.Z)
    wanted = sector_target(args.point, args.X, args.Z, args.side)
    b = np.asarray(list(map(float, wanted)))
    source_report = json.loads(args.archive_report.read_text())
    assert source_report['X_anchors'] == args.X and source_report['Z_anchors'] == args.Z
    archive_path = ROOT / source_report['columns_artifact']
    assert sha(archive_path) == source_report['columns_sha256']
    receipt = json.loads(args.archive_receipt.read_text())
    assert receipt['status'] == 'PASS_BOUNDED_ENDPOINT_AUDIT_INCONCLUSIVE'
    assert receipt['report_sha256'] == sha(args.archive_report)
    assert receipt['archive_sha256'] == sha(archive_path)
    controls = json.loads(args.controls.read_text())
    assert controls['status'] == 'PASS'
    assert controls['producer_sha256'] == sha(ROOT / 'two_sided_full_basis_oracle.py')
    assert controls['consumer_sha256'] == sha(ROOT / 'verify_two_sided_full_basis_oracle.py')
    oracle = TwoSidedFullBasisOracle()
    domains = oracle.prepare(args.X, args.Z)
    pool = oracle.X if args.side == 'X' else oracle.Z
    other = oracle.Z if args.side == 'X' else oracle.X
    saved = np.load(archive_path)
    masks, bases, lookup = [], [], {}
    for mask, row in zip(saved['masks'], saved[f'selected_{args.side}_indices']):
        m, B = int(mask), tuple(map(int, row))
        # The reviewed archive remains available, but the initial master uses
        # exactly one physical basis per pattern. New columns are priced.
        if m in masks:
            continue
        assert B == tuple(sorted(set(B))) and len(B) == 128 and all(0 <= j < 720 for j in B)
        key = m, B
        if key in lookup:
            continue
        domain = domains[m][args.side]
        assert domain['status'] == 'FULL_SECTOR_BASIS_DOMAIN'
        assert rank(pool[j] for j in B) == 128
        assert set(domain['selected_anchor_indices']) <= set(B)
        assert not set(domain['absent_anchor_indices']) & set(B)
        assert all(sum((pool[j] & other[k]).bit_count() % 2 for j in B) == 1
                   for k in domain['opposite_selected_indices'])
        lookup[key] = len(bases)
        masks.append(m)
        bases.append(B)
    assert sorted(masks) == list(range(16))
    initial_columns = len(bases)
    H = highspy.Highs()
    for name, value in [('output_flag', False), ('threads', 1), ('solver', 'simplex'),
                        ('presolve', 'off'), ('simplex_strategy', 4), ('primal_feasibility_tolerance', 1e-9),
                        ('dual_feasibility_tolerance', 1e-9)]:
        assert H.setOptionValue(name, value) == highspy.HighsStatus.kOk
    rhs = np.r_[np.asarray(list(map(float, lam))), b]
    assert H.addRows(len(rhs), rhs, rhs, 0, np.zeros(len(rhs) + 1, dtype=np.int32),
                     np.array([], dtype=np.int32), np.array([], dtype=float)) == highspy.HighsStatus.kOk
    basis_variable_ids = []

    def add_basis_columns(new_ids):
        if not new_ids:
            return
        start_col = H.getNumCol()
        ptr, rows = [0], []
        for idx in new_ids:
            rows.extend([masks[idx], *[16 + j for j in feature_rows(masks[idx], bases[idx])]])
            ptr.append(len(rows))
        n = len(new_ids)
        assert H.addCols(n, np.zeros(n), np.zeros(n), np.full(n, highspy.kHighsInf),
                         len(rows), np.asarray(ptr, dtype=np.int32), np.asarray(rows, dtype=np.int32),
                         np.ones(len(rows))) == highspy.HighsStatus.kOk
        basis_variable_ids.extend(range(start_col, start_col + n))

    add_basis_columns(list(range(len(bases))))
    error_variable_start = H.getNumCol()
    error_rows = np.r_[16 + np.arange(SECTOR_FEATURES), 16 + np.arange(SECTOR_FEATURES)].astype(np.int32)
    assert H.addCols(2 * SECTOR_FEATURES, np.ones(2 * SECTOR_FEATURES),
                     np.zeros(2 * SECTOR_FEATURES), np.full(2 * SECTOR_FEATURES, highspy.kHighsInf),
                     2 * SECTOR_FEATURES, np.arange(2 * SECTOR_FEATURES + 1, dtype=np.int32),
                     error_rows, np.r_[np.ones(SECTOR_FEATURES), -np.ones(SECTOR_FEATURES)]) == highspy.HighsStatus.kOk
    initial_feature = [Fraction(0)] * SECTOR_FEATURES
    for m, B in zip(masks, bases):
        for j in feature_rows(m, B):
            initial_feature[j] += lam[m]
    initial_residual = [t - x for t, x in zip(wanted, initial_feature)]
    positive_error = [max(v, Fraction(0)) for v in initial_residual]
    negative_error = [max(-v, Fraction(0)) for v in initial_residual]
    assert all(x + p - n == t for x, p, n, t in zip(initial_feature, positive_error, negative_error, wanted))
    warm_basis = highspy.HighsBasis()
    col_status = [highspy.HighsBasisStatus.kLower] * H.getNumCol()
    for j in basis_variable_ids:
        col_status[j] = highspy.HighsBasisStatus.kBasic
    for j, value in enumerate(initial_residual):
        index = error_variable_start + j + (SECTOR_FEATURES if value < 0 else 0)
        col_status[index] = highspy.HighsBasisStatus.kBasic
    warm_basis.col_status = col_status
    warm_basis.row_status = [highspy.HighsBasisStatus.kLower] * len(rhs)
    warm_basis.valid = True
    assert sum(s == highspy.HighsBasisStatus.kBasic for s in warm_basis.col_status) == len(rhs)
    assert H.setBasis(warm_basis) == highspy.HighsStatus.kOk
    hashes = source_hashes()
    for path in [Path(__file__), args.lambda_source, args.archive_report, args.archive_receipt,
                 args.controls, ROOT / 'verify_two_sided_full_basis_oracle.py']:
        hashes[str(path.resolve().relative_to(ROOT))] = sha(path)
    frozen = dict(status='FROZEN_BEFORE_FIXED_LAMBDA_SECTOR_PRIMAL_WARM_BASIS', source_C16_answered=False,
                  utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                  point_c16_path=str(args.point.resolve().relative_to(ROOT)), point_sha256=sha(args.point),
                  X_anchors=args.X, Z_anchors=args.Z, side=args.side,
                  lambda_masses=list(map(str, lam)), sector_target=list(map(str, wanted)),
                  feature_layout='U720,P_U[4,720].ravel(C)', source_hashes=hashes,
                  initial_archive=str(archive_path.relative_to(ROOT)), initial_archive_sha256=sha(archive_path),
                  initial_unique_sector_bases=initial_columns, seconds=args.seconds, max_rounds=args.max_rounds,
                  simplex_strategy='primal', initial_basis='onephysicalbasisperpattern plusone signederror perfeature',
                  mass_rows=16, feature_rows=SECTOR_FEATURES, mass_rows_have_no_error_variables=True,
                  objective='sum of positive and negative errors on3600 feature rows',
                  lambda_float_handling='exact rationals converted individually; no clamping or normalization',
                  scope='Fixed-lambda sector allocation. Exact repriced rows constrainlambda atthispoint; no globalmomentcut ormembershipclaim.')
    write(fp, frozen)
    initial_path = prefix.with_name(prefix.name + '.initial-exact.json')
    assert not initial_path.exists()
    initial = dict(status='EXACT_PHASE_I_FEASIBLE_INITIAL_BASIS_CANDIDATE',
                   source_C16_answered=False, point_sha256=sha(args.point), side=args.side,
                   X_anchors=args.X, Z_anchors=args.Z, lambda_masses=list(map(str, lam)),
                   sector_target=list(map(str, wanted)), frozen_sha256=sha(fp), source_hashes=hashes,
                   pattern_basis_records=[dict(mask=m, selected_indices=list(B), weight=str(lam[m]))
                                          for m, B in zip(masks, bases)],
                   positive_feature_errors=list(map(str, positive_error)),
                   negative_feature_errors=list(map(str, negative_error)),
                   phase_I_objective=str(sum(positive_error) + sum(negative_error)),
                   basic_variable_indices=[j for j, s in enumerate(warm_basis.col_status)
                                           if s == highspy.HighsBasisStatus.kBasic],
                   scope='Feasiblephase-Istatewithnonzeroerrorvariables; nottargetmembership.')
    write(initial_path, initial)
    start = time.monotonic()
    deadline = start + args.seconds
    rounds, cuts = [], []
    reason = 'ROUND_LIMIT'
    last_dual = np.zeros(len(rhs))
    last_values = None
    last_primal_valid = False
    scale = 1 << 24
    for iteration in range(args.max_rounds):
        remaining = deadline - time.monotonic()
        if remaining <= 0:
            reason = 'TIME_LIMIT'
            break
        assert H.setOptionValue('time_limit', remaining) == highspy.HighsStatus.kOk
        before = time.monotonic()
        H.run()
        solve_seconds = time.monotonic() - before
        status = H.getModelStatus()
        solution = H.getSolution()
        info = H.getInfo()
        rec = dict(round=iteration, solver_status=str(status), solve_seconds=solve_seconds,
                   objective=float(info.objective_function_value), sector_basis_columns=len(bases),
                   primal_valid=bool(solution.value_valid), dual_valid=bool(solution.dual_valid),
                   simplex_iterations=int(info.simplex_iteration_count))
        rounds.append(rec)
        if solution.value_valid:
            last_values = np.asarray(solution.col_value)
            last_primal_valid = True
        if not solution.dual_valid:
            reason = 'NO_NUMERICAL_DUAL_AVAILABLE'
            break
        last_dual = np.asarray(solution.row_dual)
        a = last_dual[16:]
        assert len(a) == SECTOR_FEATURES and np.all(np.isfinite(a))
        norm = float(max(abs(a)))
        if norm == 0:
            reason = 'ZERO_FEATURE_DUAL_INCONCLUSIVE_WITHOUT_EXACT_TARGET_MIXTURE'
            break
        c = [int(np.rint(v * scale / norm)) for v in a]
        support_records, pattern_bounds, proposed = [], [], []
        before = time.monotonic()
        for m, domain in enumerate(domains):
            weights = [c[j] + sum(c[720 * (i + 1) + j] for i in range(4) if m >> i & 1)
                       for j in range(720)]
            full_weights = weights + [0] * 720 if args.side == 'X' else [0] * 720 + weights
            priced = oracle.support_pattern(domain, full_weights)
            assert priced['value'] is not None, 'all sixteen domains required by this pilot'
            r = priced[f'{args.side}_support']
            bound = r['value']
            assert Fraction(bound).denominator == 1
            pattern_bounds.append(int(bound))
            support_records.append(dict(mask=m, value=int(bound), selected_indices=r['selected_indices'],
                                        zero_basis_indices=r['zero_basis_indices'], owner_indices=r['owner_indices']))
            B = tuple(r['selected_indices'])
            true_score = sum(a[j] for j in feature_rows(m, B))
            reduced_violation = float(true_score + last_dual[m])
            if reduced_violation > 1e-8 and (m, B) not in lookup:
                proposed.append((m, B, reduced_violation))
        left = sum(v * t for v, t in zip(c, wanted))
        right = sum(h * mass for h, mass in zip(pattern_bounds, lam))
        gap = left - right
        rec.update(pricing_seconds=time.monotonic() - before, exact_left=str(left),
                   exact_right_at_lambda=str(right), exact_violation=str(gap),
                   normalized_violation=float(gap / scale), proposed_columns=len(proposed))
        print(json.dumps(rec), flush=True)
        if gap > 0:
            cuts.append(dict(side=args.side, X_anchors=args.X, Z_anchors=args.Z,
                             coefficients=c, exact_left=str(left), pattern_bounds=pattern_bounds,
                             lambda_masses=list(map(str, lam)), exact_right_at_lambda=str(right),
                             exact_violation=str(gap), support_records=support_records,
                             inequality='sum_m pattern_bounds[m]*lambda[m] >= exact_left'))
            reason = 'EXACT_FIXED_LAMBDA_SECTOR_SEPARATOR_CANDIDATE'
            break
        if status != highspy.HighsModelStatus.kOptimal:
            reason = 'NONOPTIMAL_NUMERICAL_MASTER_AFTER_EXACT_REPRICING'
            break
        if float(info.objective_function_value) <= 1e-8:
            reason = 'NUMERICAL_SECTOR_MIXTURE_REQUIRES_EXACT_RECOVERY'
            break
        if not proposed:
            reason = 'NO_DISCOVERED_IMPROVING_COLUMNS_WITHOUT_EXACT_MEMBERSHIP'
            break
        new_ids = []
        for m, B, _ in proposed:
            idx = len(bases)
            lookup[m, B] = idx
            masks.append(m)
            bases.append(B)
            new_ids.append(idx)
        add_basis_columns(new_ids)
    # Preserve last solved variable cohort explicitly: newly appended bases
    # after the final solve have no invented primal weight.
    solved_basis_ids = [i for i, j in enumerate(basis_variable_ids)
                        if last_values is not None and j < len(last_values)]
    saved_weights = np.full(len(bases), np.nan)
    if last_values is not None:
        for i in solved_basis_ids:
            saved_weights[i] = last_values[basis_variable_ids[i]]
    np.savez_compressed(cp, masks=np.asarray(masks, dtype=np.uint8), selected_indices=np.asarray(bases, dtype=np.uint16),
                        basis_variable_ids=np.asarray(basis_variable_ids, dtype=np.int32),
                        last_solved_basis_ids=np.asarray(solved_basis_ids, dtype=np.int32),
                        last_numeric_basis_weights=saved_weights, last_row_dual=last_dual,
                        last_variable_values=np.asarray([] if last_values is None else last_values),
                        error_variable_start=error_variable_start)
    residual = None
    if last_values is not None:
        mass = np.zeros(16)
        recovered = np.zeros(SECTOR_FEATURES)
        for i in solved_basis_ids:
            w = saved_weights[i]
            mass[masks[i]] += w
            recovered[feature_rows(masks[i], bases[i])] += w
        residual = dict(maximum_pattern_mass_residual=float(max(abs(mass - np.asarray(list(map(float, lam)))))),
                        maximum_feature_residual=float(max(abs(recovered - b))),
                        feature_L1_residual=float(sum(abs(recovered - b))),
                        minimum_basis_weight=float(np.nanmin(saved_weights)),
                        last_primal_valid=last_primal_valid)
    assert all(sha(ROOT / p) == h for p, h in hashes.items())
    result = dict(frozen)
    result.update(status='EXACT_FIXED_LAMBDA_SECTOR_SEPARATOR_CANDIDATE' if cuts else 'BOUNDED_FIXED_LAMBDA_SECTOR_INCONCLUSIVE',
                  frozen_sha256=sha(fp), cuts=cuts, rounds=rounds, stopping_reason=reason,
                  solver_budget_seconds=args.seconds, elapsed_solver_gate_seconds=time.monotonic() - start,
                  total_elapsed_seconds=time.monotonic() - preparation_start,
                  columns_artifact=str(cp), columns_sha256=sha(cp), numerical_residual=residual,
                  exact_membership_proved=False, global_moment_cut_proved=False)
    write(args.output, result)
    print(json.dumps({k: result[k] for k in ('status', 'stopping_reason', 'elapsed_solver_gate_seconds',
                                           'total_elapsed_seconds', 'numerical_residual')}), flush=True)


if __name__ == '__main__':
    main()
