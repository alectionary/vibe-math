#!/usr/bin/env python3
"""120-second Wolfe pilot for a singleton conditional zero-pool basis law."""
from pathlib import Path
from fractions import Fraction as Q
import argparse, hashlib, json, sys, time
import numpy as np
from scipy.linalg import lstsq
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from full_partner_projection_features import moment_target
from verify_projected_profile_moment_rows import point_vector
from weighted_matroid_separator import insert
from recover_full_partner_mixture import exact_recover


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--seconds', type=float, default=120)
    ap.add_argument('--column-cap', type=int, default=2000)
    args = ap.parse_args()
    assert not args.output.exists() and 0 < args.seconds <= 120 and 1 <= args.column_cap <= 2000
    start = time.monotonic()
    owner = point_vector(args.point); p = owner[32]
    assert 0 < p < 1
    q = [x/(16*p) for x in moment_target(owner)[55:]]
    X, Z = [[int(v, 16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
    zero = [j for j in range(720) if not ((X[512] & Z[j]).bit_count() % 2)]
    units = [j for j in range(720) if (X[512] & Z[j]).bit_count() % 2]
    assert all(0 <= value <= 1 for value in q) and sum(q[j] for j in zero) == 127 and sum(q[j] for j in units) == 1
    ground = [j for j in zero if q[j] > 0]; positions = {j: i for i, j in enumerate(ground)}
    rows = {}
    for j in ground: insert(rows, Z[j])
    assert len(rows) == 127
    target = [q[j] for j in ground]; b = np.asarray(list(map(float, target)))
    sources = {name: sha(ROOT/name) for name in ('physical-pool-source.json', 'pools/xcoords.txt', 'pools/zcoords.txt',
               'recover_full_partner_mixture.py', 'weighted_matroid_separator.py', 'full_partner_projection_features.py',
               'verify_projected_profile_moment_rows.py', 'full_partner_projection_wolfe.py')}
    frozen = {'status': 'FROZEN_SINGLETON_WOLFE_PILOT', 'point_sha256': sha(args.point), 'source_hashes': sources,
              'producer_sha256': sha(Path(__file__)), 'seconds': args.seconds, 'column_cap': args.column_cap,
              'anchor_orbit': 32, 'zero_pool_size': len(zero), 'positive_zero_ground_size': len(ground),
              'scope': 'Present-conditioned T law for orbit32; no joint-profile membership or full source frame.'}
    fp = args.output.with_suffix('.frozen.json'); assert not fp.exists(); fp.write_text(json.dumps(frozen, indent=2)+'\n')
    bases, features, lookup = [], [], {}

    def greedy(weights):
        rows, chosen = {}, []
        for j in sorted(ground, key=lambda j: (-weights[positions[j]], j)):
            old = len(rows); insert(rows, Z[j])
            if len(rows) != old: chosen.append(j)
            if len(chosen) == 127: break
        assert len(chosen) == 127
        return sorted(chosen)

    def add(basis):
        key = tuple(basis)
        if key in lookup: return lookup[key]
        index = len(bases); lookup[key] = index; bases.append(basis)
        chosen = set(basis); features.append(np.asarray([int(j in chosen) for j in ground], dtype=np.int8))
        return index

    active, lam = [add(greedy(b))], np.ones(1)
    rounds, reason = [], 'COLUMN_CAP'
    out = {**frozen, 'frozen_sha256': sha(fp), 'status': 'BOUNDED_INCONCLUSIVE', 'source_C16_answered': False,
           'physical_full_frame': False, 'conditional_probability': str(p), 'rounds': rounds}
    for iteration in range(args.column_cap):
        if time.monotonic()-start >= args.seconds: reason = 'TIME_LIMIT'; break
        failure = None
        for minor in range(1000):
            if time.monotonic()-start >= args.seconds: failure = 'TIME_LIMIT_DURING_CORRECTION'; break
            V = np.asarray([features[i] for i in active], dtype=float)
            old = lam@V; oldobj = float((old-b)@(old-b))
            if len(active) == 1: alpha, rank = np.ones(1), 0
            else:
                eta, _, rank, _ = lstsq((V[1:]-V[0]).T, b-V[0], cond=1e-12, lapack_driver='gelsy')
                if rank != len(active)-1: failure = 'AFFINE_RANK_FAILURE'; break
                alpha = np.r_[1-eta.sum(), eta]
            if alpha.min() >= -1e-11:
                lam = np.maximum(alpha, 0); lam /= lam.sum()
                keep = lam > 0; active = [i for i, keep_i in zip(active, keep) if keep_i]; lam = lam[keep]
                V = np.asarray([features[i] for i in active], dtype=float)
                assert float((lam@V-b)@(lam@V-b)) <= oldobj+1e-9*max(1., oldobj)
                break
            bad = np.flatnonzero(alpha < 0); ratios = lam[bad]/(lam[bad]-alpha[bad]); hit = int(bad[np.argmin(ratios)])
            theta = float(ratios.min()); assert -1e-12 <= theta <= 1+1e-12
            candidate = (1-theta)*lam+theta*alpha; candidate[hit] = 0
            assert candidate.min() >= -1e-10
            candidate = np.maximum(candidate, 0); candidate /= candidate.sum(); keep = candidate > 0
            active = [i for i, keep_i in zip(active, keep) if keep_i]; lam = candidate[keep]
            V = np.asarray([features[i] for i in active], dtype=float)
            assert float((lam@V-b)@(lam@V-b)) <= oldobj+1e-9*max(1., oldobj)
        if failure: reason = failure; break
        V = np.asarray([features[i] for i in active], dtype=float); x = lam@V; residual = b-x
        norm = float(max(abs(residual))); objective = float(residual@residual)/2
        stationarity = float(max(abs((V-x)@residual)))
        rec = {'iteration': iteration, 'active_columns': len(active), 'historical_columns': len(bases),
               'max_residual': norm, 'squared_objective': objective, 'stationarity': stationarity,
               'minor_cycles': minor+1, 'weight_mass': float(lam.sum()), 'minimum_weight': float(lam.min())}
        rounds.append(rec)
        if stationarity > 1e-7*max(1., norm): reason = 'STATIONARITY_FAILURE'; break
        if norm <= 1e-10 and (iteration % 20 == 0 or norm <= 1e-13):
            matrix = np.vstack((np.ones(len(active), dtype=np.int64), V.T.astype(np.int64)))
            recovery, exact = exact_recover(matrix, [Q(1)]+target, lam)
            out['recovery'] = recovery
            out.setdefault('recovery_attempts', []).append({'iteration': iteration, 'status': recovery['status'],
                'exact_column_rank': recovery.get('exact_column_rank'),
                'remaining_nonzero_equations': len(recovery.get('remaining_nonzero_equations', []))})
            if exact is not None:
                out.update(status='EXACT_SINGLETON_CONDITIONAL_BASIS_MIXTURE_CANDIDATE',
                           zero_bases=[{'indices': bases[i], 'weight': str(w)} for i, w in zip(active, exact) if w > 0],
                           unit_probabilities=[{'index': j, 'probability': str(q[j])} for j in units if q[j]],
                           conditional_target=list(map(str, q)))
                reason = 'EXACT_RECOVERY_REQUIRES_INDEPENDENT_REPLAY'
                break
            if norm <= 1e-14:
                reason = 'FLOAT_FLOOR_EXACT_RECOVERY_FAILED'; break
        scale = 1 << 30
        direction = residual/norm; c = [int(round(v*scale)) for v in direction]
        basis = greedy(c); support = sum(c[positions[j]] for j in basis)
        value = sum(Q(c[i])*target[i] for i in range(len(ground)))
        rec['exact_pricing_gap'] = str(value-support)
        if value > support:
            prefix, rows, total = [], {}, Q(0)
            for j in sorted(ground, key=lambda j: (-c[positions[j]], j)):
                prefix.append(j); insert(rows, Z[j]); total += q[j]
                if total > len(rows):
                    out.update(status='EXACT_CONDITIONAL_RANK_CUT_CANDIDATE',
                               cut={'sector': 'T', 'anchor_orbit': 32, 'mandatory_index': None, 'indices': sorted(prefix),
                                    'bound': len(rows), 'exact_violation': str((total-len(rows))*p)})
                    break
            assert 'cut' in out; reason = 'EXACT_PREFIX_RANK_VIOLATION'; break
        index = add(basis)
        score = float(direction@features[index]-direction@x)
        rec['true_gradient_improvement'] = score
        if index in active or score <= 1e-12: reason = 'NO_NEW_IMPROVING_VERTEX'; break
        active.append(index); lam = np.r_[lam, 0.]
        if iteration % 100 == 0: print(json.dumps(rec), flush=True)
    out.update(stopping_reason=reason, elapsed_seconds=time.monotonic()-start, feature_columns=len(bases),
               final_numeric_active_columns=active, final_numeric_weights=list(map(float, lam)),
               numerical_basis_archive=bases)
    assert all(sha(ROOT/name) == digest for name, digest in sources.items())
    args.output.write_text(json.dumps(out, indent=2)+'\n')
    print(json.dumps({k: out[k] for k in ('status', 'stopping_reason', 'elapsed_seconds', 'feature_columns')}))


if __name__ == '__main__':
    main()
