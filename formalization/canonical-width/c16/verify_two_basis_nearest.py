#!/usr/bin/env python3
"""Independent exact nearest-pattern-law primal/dual replay, with frozen rows."""
from pathlib import Path
from fractions import Fraction as Q
import argparse
import json
import time
import numpy as np
from verify_two_sided_full_basis_oracle import ROOT, sha, read
from verify_two_basis_local_box import moment_inverse, SUBSETS, qrank


def main():
    ap = argparse.ArgumentParser()
    for name in ('candidate', 'localbox', 'localbox-replay', 'archive', 'archive-report', 'output'):
        ap.add_argument('--'+name, type=Path, required=True)
    a = ap.parse_args(); assert not a.output.exists(); start = time.monotonic()
    result = read(a.candidate); local = read(a.localbox); accepted = read(a.localbox_replay); report = read(a.archive_report)
    assert result['status'] == 'EXACT_NEAREST_LOCALBOX_PATTERN_LAW_CANDIDATE'
    assert result['localbox_sha256'] == sha(a.localbox) == accepted['candidate_sha256']
    assert result['localbox_replay_sha256'] == sha(a.localbox_replay)
    assert accepted['status'] == 'PASS_EXACT_LOCAL_BOX_PATTERN_LAW_ONLY'
    assert accepted['consumer_sha256'] == sha(ROOT/'verify_two_basis_local_box.py')
    assert accepted['physical_consumer_sha256'] == sha(ROOT/'verify_two_sided_full_basis_oracle.py')
    assert accepted['producer_source_hashes'] == local['source_hashes']
    assert all(sha(ROOT/p) == h for p, h in local['source_hashes'].items())
    assert result['archive_sha256'] == report['columns_sha256'] == sha(a.archive)
    assert result['archive_report_sha256'] == sha(a.archive_report)
    assert result['point_sha256'] == local['point_sha256'] == report['point_sha256'] == accepted['point_sha256']
    assert result['X_anchors'] == local['X_anchors'] == report['X_anchors']
    assert result['Z_anchors'] == local['Z_anchors'] == report['Z_anchors']
    assert all(sha(ROOT/p) == h for p, h in result['source_hashes'].items())
    frozen_path = a.candidate.with_suffix('.frozen.json'); assert result['frozen_sha256'] == sha(frozen_path)
    frozen = read(frozen_path)
    for key in ('point_sha256', 'X_anchors', 'Z_anchors', 'source_hashes', 'archive_sha256', 'localbox_sha256', 'localbox_replay_sha256'):
        assert result[key] == frozen[key]
    data = np.load(a.archive, allow_pickle=False)
    raw = [Q.from_float(float(v)) for v in data['master_mixture_weights']]
    assert min(raw) >= 0; total = sum(raw); assert total > 0
    old = [sum(w for w, m in zip(raw, data['masks']) if int(m) == mask)/total for mask in range(16)]
    assert old == list(map(Q, result['old_lambda_masses'])) and total == Q(result['old_binary_weight_sum_before_normalization'])
    L, C = moment_inverse(); low = list(map(Q, local['exact_target'][:11]))
    base = [sum(x*y for x, y in zip(row, low)) for row in L]
    A = [list(map(Q, row['a']))+[Q(0)]*16 for row in local['rows']]
    b = [Q(row['b']) for row in local['rows']]
    labels = [['localbox', j] for j in range(len(A))]
    for mask in range(16):
        for sign in (1, -1):
            row = [sign*v for v in C[mask]]+[Q(0)]*16; row[5+mask] = -1
            A.append(row); b.append(sign*(old[mask]-base[mask])); labels.append(['distance', mask, sign])
    assert labels == result['row_labels'] and len(A) == result['rows_checked'] == len(local['rows'])+32
    tau = list(map(Q, result['high_moments'])); deviations = list(map(Q, result['absolute_deviations']))
    assert len(tau) == 5 and len(deviations) == 16; x = tau+deviations
    assert all(sum(v*w for v, w in zip(row, x)) <= rhs for row, rhs in zip(A, b))
    lam = [v+sum(a*b for a, b in zip(row, tau)) for v, row in zip(base, C)]
    assert lam == list(map(Q, result['lambda_masses'])) and min(lam) >= 0 and sum(lam) == 1
    assert all(sum(lam[m] for m in range(16) if m&s == s) == value for s, value in zip(SUBSETS, low+tau))
    assert deviations == [abs(v-w) for v, w in zip(lam, old)]
    primal = sum(deviations); assert primal == Q(result['exact_L1_distance'])
    ids = result['dual_indices']; z = list(map(Q, result['dual_weights']))
    assert len(ids) == len(set(ids)) == len(z) and min(z) >= 0 and all(0 <= i < len(A) for i in ids)
    objective = [0]*5+[1]*16
    assert all(sum(weight*A[i][j] for i, weight in zip(ids, z)) == -objective[j] for j in range(21))
    dual = -sum(weight*b[i] for i, weight in zip(ids, z)); assert dual == primal
    active = result['primal_active_rows']; assert len(active) == len(set(active)) == 21
    assert qrank([A[i] for i in active], 21) == 21
    assert all(sum(v*w for v, w in zip(A[i], x)) == b[i] for i in active)
    out = dict(status='PASS_EXACT_NEAREST_LOCAL_BOX_LAMBDA_L1_OPTIMUM', source_C16_answered=False,
               candidate_sha256=sha(a.candidate), frozen_sha256=sha(frozen_path), localbox_sha256=sha(a.localbox),
               localbox_replay_sha256=sha(a.localbox_replay), archive_sha256=sha(a.archive), archive_report_sha256=sha(a.archive_report),
               consumer_sha256=sha(__file__), dependencies={p:sha(ROOT/p) for p in ['verify_two_basis_local_box.py', 'verify_two_sided_full_basis_oracle.py']},
               producer_source_hashes=result['source_hashes'], point_sha256=result['point_sha256'], X_anchors=result['X_anchors'], Z_anchors=result['Z_anchors'],
               old_numeric_weights_exactly_normalized=True, exact_old_weight_mass=str(total), local_rows=len(local['rows']), absolute_distance_rows=32,
               all_inequalities_checked=len(A), primal_active_rank=21, dual_stationarity_equations=21,
               exact_L1_optimum=str(primal), lambda_masses=list(map(str, lam)), high_moments=list(map(str, tau)),
               zero_mass_patterns=[m for m, mass in enumerate(lam) if mass == 0],
               full_basis_membership_claimed=False, elapsed_seconds=time.monotonic()-start,
               scope='The law is exactlyL1-nearest to the normalized saved mixture pattern masses within the independently accepted local-box polytope. This does not prove sector allocation, full-basis membership or a source frame; point15scope only.')
    a.output.write_text(json.dumps(out, indent=2)+'\n')
    print(json.dumps({k:v for k,v in out.items() if k not in ('lambda_masses', 'producer_source_hashes')}, indent=2), flush=True)


if __name__ == '__main__':
    main()
