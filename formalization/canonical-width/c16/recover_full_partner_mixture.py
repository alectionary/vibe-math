#!/usr/bin/env python3
"""Recover an exact mixture in the one-orbit/full-Z-basis convex relaxation.

Numerical closeness only opens the recovery gate. Acceptance requires exact
FLINT equations, nonnegative rational weights, and a separate physical replay.
No local column or mixture is asserted to extend to a full source frame.
"""
from pathlib import Path
from fractions import Fraction
import argparse, gzip, hashlib, json, time
import numpy as np
from scipy.linalg import qr
from flint import fmpq_mat, fmpz_mat
from full_partner_projection_features import FEATURES, moment_target
from verify_projected_profile_moment_rows import point_vector

ROOT = Path(__file__).resolve().parent
LAYOUT = '1,k,C1..C8,n[45],d[45,16].ravel(C)'
SOURCE_NAMES = ('physical-pool-source.json', 'pools/xcoords.txt', 'pools/zcoords.txt',
                'algebraic-results/orbit-rank-profiles.json.gz',
                'algebraic-results/hulls-16-rank.json.gz')


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    raw = Path(path).read_bytes()
    return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)


def exact_recover(A, target, approximate, denominator=1 << 42):
    """Keep dyadic free coordinates and correct a nonsingular exact submatrix.

    Exact rank plus the invertible pivot block certifies that a failed remaining
    equation means target is outside this column span. Negative weights only
    reject this recovery; they do not prove convex-hull nonmembership.
    """
    A = np.asarray(A, dtype=np.int64)
    assert A.ndim == 2 and A.shape[0] == len(target) and A.shape[1] == len(approximate)
    integer = A.tolist()
    rank = int(fmpz_mat(integer).rank())
    assert rank > 0
    _, _, row_order = qr(A.T.astype(float), mode='economic', pivoting=True)
    rows = list(map(int, row_order[:rank]))
    _, _, column_order = qr(A[rows].astype(float), mode='economic', pivoting=True)
    columns = list(map(int, column_order[:rank]))
    base = [Fraction(int(round(float(x)*denominator)), denominator) for x in approximate]
    matrix = fmpq_mat(integer)
    column = fmpq_mat([[str(x)] for x in base])
    rhs = fmpq_mat([[str(x)] for x in target])
    residual = rhs-matrix*column
    B = fmpq_mat(A[np.ix_(rows, columns)].tolist())
    try:
        correction = B.solve(fmpq_mat([[residual[i, 0]] for i in rows]), algorithm='dixon')
    except ZeroDivisionError:
        return {'status': 'PIVOT_SELECTION_FAILED', 'exact_column_rank': rank,
                'pivot_rows': rows, 'pivot_columns': columns}, None
    for i, index in enumerate(columns):
        column[index, 0] += correction[i, 0]
    final = rhs-matrix*column
    failures = [(i, str(final[i, 0])) for i in range(len(target)) if final[i, 0]]
    weights = [Fraction(str(column[i, 0])) for i in range(A.shape[1])]
    record = {'exact_column_rank': rank, 'pivot_rows': rows, 'pivot_columns': columns,
              'rounding_denominator': denominator, 'remaining_nonzero_equations': failures,
              'min_exact_weight': str(min(weights)), 'exact_weight_sum': str(sum(weights)),
              'max_exact_correction': str(max(abs(a-b) for a, b in zip(weights, base)))}
    if failures:
        record['status'] = 'TARGET_OUTSIDE_SELECTED_COLUMN_SPAN'
        return record, None
    if min(weights) < 0:
        record['status'] = 'EXACT_EQUATIONS_BUT_NEGATIVE_RECOVERED_WEIGHTS'
        return record, None
    record['status'] = 'EXACT_NONNEGATIVE_MIXTURE_RECOVERED_REQUIRES_PHYSICAL_REPLAY'
    return record, weights


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--report', type=Path, required=True)
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--residual-gate', type=float, default=1e-7)
    ap.add_argument('--weight-threshold', type=float, default=1e-12)
    args = ap.parse_args()
    assert not args.output.exists() and 0 < args.residual_gate <= 1e-4
    assert 0 <= args.weight_threshold <= 1e-8
    start = time.monotonic()
    report = read(args.report)
    archive = Path(report['columns_artifact'])
    if not archive.is_absolute():
        archive = ROOT/archive
    assert sha(archive) == report['columns_sha256']
    assert sha(args.point) == report['point_sha256']
    source_hashes = {name: sha(ROOT/name) for name in SOURCE_NAMES}
    dependencies = {name: sha(ROOT/name) for name in (
        'recover_full_partner_mixture.py', 'full_partner_projection_features.py',
        'verify_projected_profile_moment_rows.py')}
    target = list(moment_target(point_vector(args.point)))
    arr = np.load(archive)
    F, numeric = arr['features'], arr['master_mixture_weights']
    assert F.ndim == 2 and F.shape[1] == FEATURES and numeric.shape == (len(F),)
    assert arr['masks'].shape == (len(F),) and arr['selected_Z_indices'].shape == (len(F), 128)
    assert np.isfinite(numeric).all() and numeric.min(initial=0) >= -1e-9
    ids = np.flatnonzero(numeric > args.weight_threshold)
    assert len(ids)
    selected = numeric[ids].copy()
    mass_before = float(selected.sum())
    selected /= mass_before
    A = F[ids].T.astype(np.int64)
    b = np.asarray(list(map(float, target)))
    residual = A@selected-b
    out = {'status': 'NUMERICAL_RESIDUAL_TOO_LARGE_NO_EXACT_RECOVERY_ATTEMPT',
           'source_C16_answered': False, 'physical_full_frame': False,
           'orbit': 32, 'feature_layout': LAYOUT, 'point_sha256': sha(args.point),
           'input_report': str(args.report.resolve()), 'input_report_sha256': sha(args.report),
           'input_archive': str(archive.resolve()), 'input_archive_sha256': sha(archive),
           'source_hashes': source_hashes, 'producer_dependencies': dependencies,
           'selected_archive_column_ids': list(map(int, ids)),
           'selected_numeric_mass_before_normalization': mass_before,
           'numeric_max_feature_residual': float(abs(residual).max()),
           'numeric_l1_residual': float(abs(residual).sum()),
           'residual_gate': args.residual_gate, 'weight_threshold': args.weight_threshold,
           'target': list(map(str, target)),
           'scope': 'Membership only in the convex relaxation of an allowed orbit32 mask and a compatible full128 Z basis. Neither individual columns nor their mixture are full source frames.'}
    if abs(residual).max() <= args.residual_gate:
        recovery, weights = exact_recover(A, target, selected)
        out['recovery'] = recovery
        out['status'] = recovery['status']
        if weights is not None:
            assert sum(weights) == 1
            out['columns'] = [
                {'archive_column_id': int(index), 'weight': str(weight),
                 'mask': int(arr['masks'][index]),
                 'selected_Z_indices': list(map(int, arr['selected_Z_indices'][index])),
                 'features': list(map(int, F[index]))}
                for index, weight in zip(ids, weights) if weight > 0]
            out['positive_columns'] = len(out['columns'])
    assert all(sha(ROOT/name) == digest for name, digest in source_hashes.items())
    assert sha(archive) == out['input_archive_sha256'] and sha(args.report) == out['input_report_sha256']
    out['elapsed_seconds'] = time.monotonic()-start
    args.output.write_text(json.dumps(out, indent=2)+'\n')
    print(json.dumps({k: out[k] for k in ('status', 'numeric_max_feature_residual', 'elapsed_seconds')}))


if __name__ == '__main__':
    main()
