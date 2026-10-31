#!/usr/bin/env python3
"""Read-only audit of the first time-limited, primal-infeasible inner attempts.

Also constructs an exact feasible PHASE-I starting basis using artificial
errors. Those errors explicitly prevent a target-membership interpretation.
"""
from fractions import Fraction as Q
from pathlib import Path
from two_basis_replay_paths import RecordedRoot
import argparse
import json
import time
import numpy as np
from verify_two_sided_full_basis_oracle import ROOT, sha, read, target


def coordinates(mask, basis):
    return list(basis)+[720*(i+1)+j for i in range(4) if mask >> i & 1 for j in basis]


def audit(path, recorded_root):
    paths=RecordedRoot(ROOT,recorded_root)
    assert sha(ROOT/'audit_two_basis_inner_initial.py')=='2a4ad40cf9cda25418949b0ae8161b8684fb24985c3db0a71b75219e63dceada'
    start = time.monotonic(); report = read(path)
    assert report['status'] == 'BOUNDED_FIXED_LAMBDA_SECTOR_INCONCLUSIVE' and report['cuts'] == []
    assert report['exact_membership_proved'] is False and report['global_moment_cut_proved'] is False
    assert len(report['rounds']) == 1 and report['rounds'][0]['solver_status'] == 'HighsModelStatus.kTimeLimit'
    assert all(sha(ROOT/p) == h for p, h in report['source_hashes'].items())
    frozen_path = path.with_name(path.stem+'.frozen.json'); assert report['frozen_sha256'] == sha(frozen_path)
    frozen = read(frozen_path)
    for key in ('lambda_masses', 'sector_target', 'point_sha256', 'side', 'X_anchors', 'Z_anchors', 'source_hashes'):
        assert frozen[key] == report[key]
    point = ROOT/report['point_c16_path']; assert sha(point) == report['point_sha256']
    full = target(point, report['X_anchors'], report['Z_anchors']); side = report['side']; offset = 720*(side == 'Z')
    wanted = full[11+offset:731+offset]+[full[1451+1440*i+offset+j] for i in range(4) for j in range(720)]
    assert wanted == list(map(Q, report['sector_target']))
    lam = list(map(Q, report['lambda_masses'])); assert len(lam) == 16 and min(lam) >= 0 and sum(lam) == 1
    for row in range(11):
        def phi(m):
            bits = [(m >> i) & 1 for i in range(4)]
            return [1, *bits, *[bits[i]*bits[j] for i in range(4) for j in range(i+1, 4)]][row]
        assert sum(lam[m]*phi(m) for m in range(16)) == full[row]
    archive_path = paths.resolve(report['columns_artifact']); assert sha(archive_path) == report['columns_sha256']
    data = np.load(archive_path, allow_pickle=False)
    source_path = ROOT/report['initial_archive']; assert sha(source_path) == report['initial_archive_sha256']
    source = np.load(source_path, allow_pickle=False)
    unique = {}; expected = []
    for mask, basis in zip(source['masks'], source['selected_'+side+'_indices']):
        key = int(mask), tuple(map(int, basis))
        if key not in unique:
            unique[key] = len(expected); expected.append(key)
    observed = [(int(mask), tuple(map(int, basis))) for mask, basis in zip(data['masks'], data['selected_indices'])]
    assert expected == observed and len(observed) == report['initial_unique_sector_bases']
    source_receipts = [ROOT/p for p in report['source_hashes'] if p.endswith('-endpoint-independent.json')]
    assert len(source_receipts) == 1
    replay = read(source_receipts[0]); assert replay['status'] == 'PASS_BOUNDED_ENDPOINT_AUDIT_INCONCLUSIVE'
    assert replay['archive_sha256'] == sha(source_path) and replay['all_archived_columns_checked'] == len(source['masks'])
    assert data['basis_variable_ids'].tolist() == list(range(len(expected)))
    assert data['last_solved_basis_ids'].tolist() == list(range(len(expected)))
    assert int(data['error_variable_start']) == len(expected)
    values = data['last_variable_values']; weights = data['last_numeric_basis_weights']
    assert values.shape == (len(expected)+7200,) and np.array_equal(values[:len(expected)], weights)
    assert np.isfinite(values).all() and np.all(data['last_row_dual'] == 0)
    mass = np.zeros(16); found = np.zeros(3600)
    for (m, basis), weight in zip(expected, weights):
        mass[m] += weight; found[coordinates(m, basis)] += weight
    residuals = dict(maximum_pattern_mass_residual=float(max(abs(mass-np.array(list(map(float, lam)))))),
                     maximum_feature_residual=float(max(abs(found-np.array(list(map(float, wanted)))))),
                     feature_L1_residual=float(sum(abs(found-np.array(list(map(float, wanted)))))),
                     minimum_basis_weight=float(min(weights)))
    for key, value in residuals.items():
        assert abs(value-report['numerical_residual'][key]) < 1e-11
    assert residuals['minimum_basis_weight'] < 0 and residuals['maximum_pattern_mass_residual'] > .1
    # A genuine nonnegative phase-I basis exists without optimization.
    selected = [next(i for i, (m, b) in enumerate(expected) if m == pattern) for pattern in range(16)]
    reconstructed = [Q(0)]*3600
    for m, idx in enumerate(selected):
        for row in coordinates(m, expected[idx][1]):
            reconstructed[row] += lam[m]
    errors = [wanted[j]-reconstructed[j] for j in range(3600)]
    signed_errors = [[j, 1 if error >= 0 else -1, str(abs(error))] for j, error in enumerate(errors)]
    assert all(reconstructed[j]+Q(sign)*Q(value) == wanted[j] for j, sign, value in signed_errors)
    error_sum = sum(map(abs, errors), Q(0)); assert error_sum > 0
    return dict(portable_replay=paths.evidence(),frozen_consumer_sha256=sha(ROOT/'audit_two_basis_inner_initial.py'),status='PASS_REJECTED_NUMERIC_ENDPOINT_AND_EXACT_PHASE_I_START', source_C16_answered=False,
                report_sha256=sha(path), frozen_sha256=sha(frozen_path), archive_sha256=sha(archive_path), point_sha256=sha(point),
                source_archive_sha256=sha(source_path), source_archive_independent_sha256=sha(source_receipts[0]),
                side=side, saved_columns_exactly_match_checked_archive=True, unique_sector_bases=len(expected),
                recomputed_numeric_residuals=residuals, all_saved_feature_duals_zero=True,
                saved_primal_is_feasible=False, saved_primal_available_flag_is_not_feasibility=True,
                cooperative_solver_limit=report['solver_budget_seconds'], actual_solver_seconds=report['rounds'][0]['solve_seconds'],
                exact_phase_I_feasible_start=dict(pattern_column_ids=selected, pattern_weights=list(map(str, lam)),
                    signed_error_variables=signed_errors, objective=str(error_sum), basis_size=3616,
                    independence_proof='Mass-row block isI16; one signed error unit per3600feature row makes the full basis blocktriangular with diagonal1or-1.',
                    actual_sector_membership=False),
                source_hashes=report['source_hashes'], elapsed_seconds=time.monotonic()-start,
                scope='Current saved numerical values are infeasible and cannot be recovered as a membership certificate. The explicit feasible start is for the artificial-error phase-I LP only; its positive errors do not establish sector allocation or source feasibility.')


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--report', type=Path, required=True); ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--recorded-root',type=Path,required=True)
    a = ap.parse_args(); assert not a.output.exists(); result = audit(a.report,a.recorded_root)
    result['auditor_sha256'] = sha(__file__); result['physical_consumer_sha256'] = sha(ROOT/'verify_two_sided_full_basis_oracle.py')
    a.output.write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k not in ('source_hashes', 'exact_phase_I_feasible_start')}, indent=2), flush=True)


if __name__ == '__main__':
    main()
