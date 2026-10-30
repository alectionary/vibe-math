#!/usr/bin/env python3
"""Exact physical fixed-pattern sector mixture with explicit feature errors.

This accepts a feasible auxiliary search point, not target membership, unless
every error vanishes. The initial intended endpoints have nonzero errors.
"""
from fractions import Fraction as Q
from pathlib import Path
import argparse
import json
import time
import numpy as np
from verify_two_sided_full_basis_oracle import ROOT, sha, read, physical_source, domains, target
from audit_two_sided_full_basis_endpoint import check_basis


def feature_rows(mask, basis):
    return list(basis)+[720*(i+1)+j for i in range(4) if mask >> i & 1 for j in basis]


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--state', type=Path, required=True); ap.add_argument('--report', type=Path, required=True); ap.add_argument('--output', type=Path, required=True)
    a = ap.parse_args(); assert not a.output.exists(); start = time.monotonic()
    state, report = read(a.state), read(a.report)
    assert state['status'] == 'EXACT_NORMALIZED_PHASE_I_STATE_CANDIDATE'
    assert report['last_feasible_exact_state_sha256'] == sha(a.state)
    assert state['source_hashes'] == report['source_hashes'] and all(sha(ROOT/p) == h for p, h in state['source_hashes'].items())
    assert state['point_sha256'] == report['point_sha256'] and state['side'] == report['side']
    point = ROOT/report['point_c16_path']; assert sha(point) == state['point_sha256']
    assert state['X_anchors'] == report['X_anchors'] and state['Z_anchors'] == report['Z_anchors']
    frozen_path = a.report.with_name(a.report.stem+'.frozen.json')
    assert state['frozen_sha256'] == report['frozen_sha256'] == sha(frozen_path)
    frozen = read(frozen_path)
    assert state['lambda_masses'] == report['lambda_masses'] == frozen['lambda_masses']
    lam = list(map(Q, state['lambda_masses'])); assert len(lam) == 16 and min(lam) >= 0 and sum(lam) == 1
    X, Z, bridge = physical_source(); side = state['side']; assert side in ('X', 'Z')
    xx, zz = state['X_anchors'], state['Z_anchors']; dd = domains(X, Z, xx, zz)
    full = target(point, xx, zz); offset = 720*(side == 'Z')
    wanted = full[11+offset:731+offset]+[full[1451+1440*i+offset+j] for i in range(4) for j in range(720)]
    assert wanted == list(map(Q, state['sector_target']))
    for k in range(11):
        def low(mask):
            bits = [(mask >> j) & 1 for j in range(4)]
            return [1, *bits, *[bits[i]*bits[j] for i in range(4) for j in range(i+1, 4)]][k]
        assert sum(lam[m]*low(m) for m in range(16)) == full[k]
    raw_path = Path(str(a.state).replace('.last-feasible-exact.json', '.last-feasible.npz'))
    raw = np.load(raw_path, allow_pickle=False); values = raw['variable_values']; ids = raw['basis_variable_ids']
    assert np.isfinite(values).all() and values.min() >= 0
    assert int(raw['round']) == state['source_round']
    assert len(ids) == len(raw['masks']) == len(raw['selected_indices']) and len(set(map(int, ids))) == len(ids)
    assert all(0 <= int(j) < len(values) for j in ids)
    weights = [Q.from_float(float(values[j])) for j in ids]
    masses = [sum(w for m, w in zip(raw['masks'], weights) if int(m) == pattern) for pattern in range(16)]
    assert masses == list(map(Q, state['pre_normalization_pattern_masses']))
    expected = []
    for mask, basis, weight in zip(raw['masks'], raw['selected_indices'], weights):
        m = int(mask); assert masses[m] > 0 or lam[m] == 0
        normalized = weight*lam[m]/masses[m] if masses[m] else Q(0)
        if normalized:
            expected.append(dict(mask=m, selected_indices=list(map(int, basis)), weight=str(normalized)))
    assert state['pattern_basis_records'] == expected
    actual = [Q(0)]*3600; mass = [Q(0)]*16; pool = X if side == 'X' else Z
    for record in expected:
        m, basis, weight = record['mask'], record['selected_indices'], Q(record['weight'])
        assert weight > 0 and dd[m]['feasible']; check_basis(pool, dd[m][side], basis)
        mass[m] += weight
        for j in feature_rows(m, basis):
            actual[j] += weight
    assert mass == lam
    positive, negative = list(map(Q, state['positive_feature_errors'])), list(map(Q, state['negative_feature_errors']))
    assert len(positive) == len(negative) == 3600 and min(positive+negative) >= 0
    assert all(p*n == 0 for p, n in zip(positive, negative))
    assert all(x+p-n == b for x, p, n, b in zip(actual, positive, negative, wanted))
    objective = sum(positive)+sum(negative); assert objective == Q(state['phase_I_objective'])
    assert objective > 0, 'zero-error endpoint needs explicit full membership classification'
    out = dict(status='PASS_EXACT_PHYSICAL_SECTOR_MIXTURE_WITH_ERRORS', source_C16_answered=False,
               state_sha256=sha(a.state), report_sha256=sha(a.report), frozen_sha256=sha(frozen_path), raw_numeric_checkpoint_sha256=sha(raw_path),
               point_sha256=state['point_sha256'], side=side, X_anchors=xx, Z_anchors=zz, producer_source_hashes=state['source_hashes'],
               physical_symmetry_bridge=bridge, all_positive_physical_bases_checked=len(expected), source_numerical_basis_columns=len(ids),
               exact_pattern_mass_equations=16, exact_anchor_low_moment_equations=11, exact_feature_error_equations=3600,
               exact_binary_float_normalization_replayed=True, negative_weight_clamping_used=False,
               exact_phase_I_objective=str(objective), maximum_exact_feature_error=str(max(positive+negative)),
               zero_mass_patterns=[m for m, value in enumerate(lam) if not value], target_membership=False,
               elapsed_seconds=time.monotonic()-start, consumer_sha256=sha(__file__),
               dependencies={p:sha(ROOT/p) for p in ['verify_two_sided_full_basis_oracle.py', 'audit_two_sided_full_basis_endpoint.py']},
               scope='Exact nonnegative physical sector mixture with the frozen pattern masses and explicit nonzero errors from the target. Suitable as an auxiliary search start only; no target allocation, joint two-sector membership or source frame follows.')
    a.output.write_text(json.dumps(out, indent=2)+'\n'); print(json.dumps({k:v for k,v in out.items() if k != 'producer_source_hashes'}, indent=2), flush=True)


if __name__ == '__main__':
    main()
