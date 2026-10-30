#!/usr/bin/env python3
"""Independent archive and final-support audit of a bounded two-basis pilot.

All archived bases and literal features are replayed. Seed and final rounded
directions are certified using independent signed-prefix ranks; intermediate
discovery directions are not reconstructed. No numerical membership follows.
"""
from pathlib import Path
from fractions import Fraction
from two_basis_replay_paths import RecordedRoot
import argparse
import json
import time
import numpy as np
from verify_two_sided_full_basis_oracle import (
    ROOT, FEATURES, LAYOUT, sha, read, physical_source, domains, rank,
    sector_upper, split_objective, target,
)


def check_basis(U, d, indices):
    chosen = [int(j) for j in indices]
    assert len(chosen) == len(set(chosen)) == 128
    assert all(0 <= j < 720 for j in chosen)
    selected = set(chosen)
    assert set(d['forced']) <= selected and not selected.intersection(d['absent'])
    assert rank(U[j] for j in chosen) == 128
    assert sum(not d['signatures'][j] for j in chosen) == d['zero_required']
    assert all(len(d['signatures'][j]) <= 1 for j in chosen)
    for opposite, bucket in zip(d['opposite'], d['bins']):
        owners = [j for j in chosen if d['signatures'][j] == (opposite,)]
        assert len(owners) == 1 and owners[0] in bucket


def audit(path, recorded_root):
    paths=RecordedRoot(ROOT,recorded_root)
    assert sha(ROOT/'audit_two_sided_full_basis_endpoint.py')=='66c1d15b7541ccb9851d3a2655d311b6a089e27af0fa2a863efe7367942bc628'
    start = time.monotonic()
    report = read(path)
    prefix = path.with_suffix('')
    frozen_path = prefix.with_name(prefix.name+'.frozen.json')
    frozen = read(frozen_path)
    assert report['frozen_sha256'] == sha(frozen_path)
    assert report['feature_layout'] == LAYOUT and report['selection_patterns'] == list(range(16))
    assert frozen['source_hashes'] == report['source_hashes']
    assert all(sha(ROOT/p) == h for p, h in frozen['source_hashes'].items())
    point = ROOT/report['point_c16_path']
    assert report['point_sha256'] == frozen['point_sha256'] == sha(point)
    archive = paths.resolve(report['columns_artifact'])
    assert report['columns_sha256'] == sha(archive)
    data = np.load(archive, allow_pickle=False)
    F, masks = data['features'], data['masks']
    XB, ZB = data['selected_X_indices'], data['selected_Z_indices']
    weights, active = data['master_mixture_weights'], data['active_column_ids']
    size = len(F)
    assert F.shape == (size, FEATURES) and F.dtype.kind in 'iu' and int(F.max()) <= 1 and int(F.min()) >= 0
    assert masks.shape == (size,) and masks.dtype.kind in 'iu' and int(masks.max()) < 16
    assert XB.shape == ZB.shape == (size, 128) and XB.dtype.kind in 'iu' and ZB.dtype.kind in 'iu'
    assert weights.shape == (size,) and np.isfinite(weights).all() and float(weights.min()) >= 0
    assert active.dtype.kind in 'iu' and len(set(map(int, active))) == len(active)
    assert all(0 <= int(j) < size for j in active)
    assert np.flatnonzero(weights > 0).tolist() == sorted(int(j) for j in active if weights[j] > 0)
    assert active.tolist() == report['final_active_columns']
    assert weights[active].tolist() == report['final_numeric_weights']
    assert abs(float(weights.sum())-1) < 1e-12
    X, Z, bridge = physical_source()
    xx, zz = report['X_anchors'], report['Z_anchors']
    dd = domains(X, Z, xx, zz)
    for k in range(size):
        m = int(masks[k]); d = dd[m]
        assert d['feasible']
        check_basis(X, d['X'], XB[k]); check_basis(Z, d['Z'], ZB[k])
    for lo in range(0, size, 128):
        hi = min(size, lo+128); count = hi-lo
        p = ((masks[lo:hi, None] >> np.arange(4)) & 1).astype(np.uint8)
        u = np.zeros((count, 1440), dtype=np.uint8)
        rows = np.arange(count)[:, None]
        u[rows, XB[lo:hi]] = 1; u[rows, 720+ZB[lo:hi]] = 1
        assert np.all(F[lo:hi, 0] == 1) and np.array_equal(F[lo:hi, 1:5], p)
        pairs = np.stack([p[:, i]*p[:, j] for i in range(4) for j in range(i+1, 4)], axis=1)
        assert np.array_equal(F[lo:hi, 5:11], pairs)
        assert np.array_equal(F[lo:hi, 11:1451], u)
        assert np.array_equal(F[lo:hi, 1451:].reshape(count, 4, 1440), p[:, :, None]*u[:, None, :])
        assert np.array_equal(p, u[:, [*xx, *[720+j for j in zz]]])
    wanted = target(point, xx, zz); b = np.array(list(map(float, wanted)))
    mixture = weights[active] @ F[active].astype(float)
    error = float(max(abs(mixture-b)))
    assert abs(error-report['numeric_mixture_max_feature_residual']) < 1e-13
    direction = data['search_direction']
    assert direction.shape == (FEATURES,) and np.isfinite(direction).all() and direction[0] == 0
    scale = frozen['pricing_scale']; assert scale == 1 << 24
    c = [int(np.rint(v*scale)) for v in direction]; c[0] = 0
    last = next(r for r in reversed(report['rounds']) if 'exact_upper_bound' in r)
    queries = [(r['label'], r['coefficients'], saved) for r, saved in zip(frozen['seed_queries'], report['seed_results'])]
    queries.append(('final_rounded_direction', c, last))
    supports = []
    for label, coefficients, saved in queries:
        assert len(coefficients) == FEATURES and all(type(v) is int for v in coefficients)
        assert sum(abs(v) for v in coefficients) < 1 << 63
        scores = F @ np.array(coefficients, dtype=np.int64)
        bounds = []; prefixes = 0; witness_ids = []
        for d in dd:
            ids = np.flatnonzero(masks == d['mask'])
            if not d['feasible']:
                assert not len(ids)
                continue
            assert len(ids)
            index = int(ids[np.argmax(scores[ids])])
            constant, wx, wz = split_objective(coefficients, d['mask'], (720, 720))
            ux, nx = sector_upper(X, 128, d['X'], wx)
            uz, nz = sector_upper(Z, 128, d['Z'], wz)
            value = constant+ux+uz
            assert value == int(scores[index])
            bounds.append(value); prefixes += nx+nz; witness_ids.append(index)
        bound = max(bounds)
        value = sum((v*t for v, t in zip(coefficients, wanted)), Fraction(0))
        gap = value-bound
        assert bound == saved['exact_upper_bound'] if label == 'final_rounded_direction' else bound == saved['upper_bound']
        assert value == Fraction(saved['exact_target_value']) and gap == Fraction(saved['exact_violation'])
        supports.append(dict(label=label, upper_bound=str(bound), exact_target_value=str(value), exact_violation=str(gap),
                             prefix_ranks_checked=prefixes, maximizing_archive_column_ids=witness_ids))
    assert report['status'] == 'NO_EXACT_SEPARATOR_FOUND' and not report['positive_proposals'] and report['retained_cuts'] == 0
    assert all(Fraction(r['exact_violation']) <= 0 for r in report['rounds'] if 'exact_violation' in r)
    assert all(Fraction(r['exact_violation']) <= 0 for r in supports)
    exact_mass = sum((Fraction.from_float(float(v)) for v in weights if v), Fraction(0))
    return dict(portable_replay=paths.evidence(),frozen_consumer_sha256=sha(ROOT/'audit_two_sided_full_basis_endpoint.py'),status='PASS_BOUNDED_ENDPOINT_AUDIT_INCONCLUSIVE', source_C16_answered=False,
                report_sha256=sha(path), frozen_sha256=sha(frozen_path), archive_sha256=sha(archive), point_sha256=sha(point),
                source_hashes=report['source_hashes'], X_anchors=xx, Z_anchors=zz, feature_count=FEATURES,
                all_archived_columns_checked=size, full_physical_bases_checked=2*size,
                literal_feature_coordinates_checked=size*FEATURES, physical_symmetry_bridge=bridge,
                active_columns=len(active), positive_numeric_weights=int(sum(weights > 0)),
                exact_binary_float_weight_mass=str(exact_mass), numeric_max_feature_residual=error,
                exact_priced_directions_replayed=supports, discovery_rounds_reported=len(report['rounds']),
                all_intermediate_directions_independently_repriced=False,
                pilot_search_budget_seconds=frozen['seconds'], reported_search_and_preservation_elapsed_seconds=report['elapsed_seconds'],
                numeric_membership_claimed=False, elapsed_seconds=time.monotonic()-start,
                scope='Every saved auxiliary basis pair and all7211literal features checked. Frozen seed and final rounded direction supports are exactly repriced by independent prefix bounds. Intermediate numerical directions are not reconstructed; no exact target membership, global nonmembership, source frame or case exclusion follows.')


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--report', type=Path, required=True); ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--recorded-root',type=Path,required=True)
    a = ap.parse_args(); assert not a.output.exists()
    out = audit(a.report,a.recorded_root); out['auditor_sha256'] = sha(__file__)
    out['independent_consumer_sha256'] = sha(ROOT/'verify_two_sided_full_basis_oracle.py')
    a.output.write_text(json.dumps(out, indent=2)+'\n')
    print(json.dumps({k:v for k,v in out.items() if k not in ('source_hashes', 'exact_priced_directions_replayed')}, indent=2), flush=True)


if __name__ == '__main__':
    main()
