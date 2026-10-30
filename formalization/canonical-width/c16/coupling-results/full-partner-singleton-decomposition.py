#!/usr/bin/env python3
"""Bounded singleton conditional matroid-base membership attribution pilot."""
from pathlib import Path
from fractions import Fraction as Q
import argparse, hashlib, json, random, sys, time
import numpy as np
import highspy
from scipy.sparse import coo_matrix, csc_matrix
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from full_partner_projection import read
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
    owner = point_vector(args.point)
    p = owner[32]
    assert 0 < p < 1
    q = [x/(16*p) for x in moment_target(owner)[55:]]
    assert all(0 <= x <= 1 for x in q) and sum(q) == 128
    X, Z = [[int(v, 16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
    zero = [j for j in range(720) if not ((X[512] & Z[j]).bit_count() % 2)]
    units = [j for j in range(720) if (X[512] & Z[j]).bit_count() % 2]
    assert sum(q[j] for j in zero) == 127 and sum(q[j] for j in units) == 1
    ground = [j for j in zero if q[j] > 0]
    positions = {j: i for i, j in enumerate(ground)}
    rank_rows = {}
    for j in ground:
        insert(rank_rows, Z[j])
    assert len(rank_rows) == 127, 'positive_conditional_support_has_rank_deficit'
    target = [Q(1)]+[q[j] for j in ground]
    sources = {name: sha(ROOT/name) for name in ('physical-pool-source.json', 'pools/xcoords.txt', 'pools/zcoords.txt',
               'recover_full_partner_mixture.py', 'weighted_matroid_separator.py', 'full_partner_projection_features.py',
               'verify_projected_profile_moment_rows.py', 'coupling-results/full-partner-projection-wolfe-witness2.json')}
    frozen = {'status': 'FROZEN_SINGLETON_CONDITIONAL_BASE_PILOT', 'point_sha256': sha(args.point),
              'source_hashes': sources, 'producer_sha256': sha(Path(__file__)), 'seconds': args.seconds,
              'column_cap': args.column_cap, 'anchor_orbit': 32, 'zero_pool_size': len(zero),
              'positive_zero_ground_size': len(ground), 'positive_zero_ground_rank': 127,
              'scope': 'Present-conditioned T law for orbit32 only. No full source frame or joint-profile membership.'}
    fp = args.output.with_suffix('.frozen.json'); assert not fp.exists()
    fp.write_text(json.dumps(frozen, indent=2)+'\n')
    H = highspy.Highs()
    for key, value in [('output_flag', False), ('threads', 1), ('solver', 'simplex'), ('simplex_strategy', 0),
                       ('primal_feasibility_tolerance', 1e-9), ('dual_feasibility_tolerance', 1e-9)]:
        assert H.setOptionValue(key, value) == highspy.HighsStatus.kOk
    m = len(target); b = np.asarray(list(map(float, target)))
    H.addRows(m, b, b, 0, np.zeros(m+1, np.int32), np.array([], np.int32), np.array([], float))
    error_count = 2*(m-1)
    E = coo_matrix((np.r_[np.ones(m-1), -np.ones(m-1)], (np.tile(np.arange(1, m), 2), np.arange(error_count))), shape=(m, error_count)).tocsc()
    H.addCols(error_count, np.ones(error_count), np.zeros(error_count), np.full(error_count, highspy.kHighsInf),
              E.nnz, E.indptr.astype(np.int32), E.indices.astype(np.int32), E.data)
    bases, features, seen = [], [], set()

    def greedy(weights):
        rows, chosen = {}, []
        for j in sorted(ground, key=lambda j: (-weights[positions[j]], j)):
            old = len(rows); insert(rows, Z[j])
            if len(rows) != old:
                chosen.append(j)
            if len(chosen) == 127:
                break
        assert len(chosen) == 127
        return sorted(chosen)

    def add(batch):
        fresh = []
        for basis in batch:
            key = tuple(basis)
            if key in seen or len(bases) >= args.column_cap:
                continue
            seen.add(key); bases.append(basis)
            column = [1]+[int(j in set(basis)) for j in ground]
            features.append(column); fresh.append(column)
        if fresh:
            M = csc_matrix(np.asarray(fresh, dtype=float).T); count = len(fresh)
            H.addCols(count, np.zeros(count), np.zeros(count), np.full(count, highspy.kHighsInf), M.nnz,
                      M.indptr.astype(np.int32), M.indices.astype(np.int32), M.data)
        return len(fresh)

    bank = read(ROOT/'coupling-results/full-partner-projection-wolfe-witness2.json')
    seed = []
    for record in bank['cuts'][0]['support_records']:
        if record['mask'] & 1:
            basis = sorted(j for j in record['selected_Z_indices'] if j in positions)
            if len(basis) == 127:
                seed.append(basis)
    add(seed)
    rng = random.Random(202610300744)
    probability = np.asarray([float(q[j]) for j in ground])
    logit = np.log(np.maximum(probability, 1e-12)/np.maximum(1-probability, 1e-12))
    random_bases = []
    for i in range(min(600, max(0, args.column_cap-len(bases)))):
        noise = np.asarray([-np.log(-np.log(max(1e-15, rng.random()))) for _ in ground])
        random_bases.append(greedy(noise+(0 if i % 3 == 0 else .5 if i % 3 == 1 else 1)*logit))
    add(random_bases)
    rounds = []
    out = {**frozen, 'frozen_sha256': sha(fp), 'status': 'BOUNDED_INCONCLUSIVE', 'source_C16_answered': False,
           'physical_full_frame': False, 'rounds': rounds, 'conditional_probability': str(p)}
    reason = 'TIME_LIMIT'
    for iteration in range(args.column_cap):
        remaining = args.seconds-(time.monotonic()-start)
        if remaining <= 0:
            break
        H.setOptionValue('time_limit', H.getRunTime()+remaining)
        H.run(); status = H.getModelStatus()
        record = {'iteration': iteration, 'columns': len(bases), 'model_status': str(status),
                  'numeric_l1_distance': float(H.getInfo().objective_function_value)}
        rounds.append(record)
        if status != highspy.HighsModelStatus.kOptimal:
            reason = 'MASTER_NOT_OPTIMAL'; break
        solution = H.getSolution(); lam = np.asarray(solution.col_value[error_count:])
        if record['numeric_l1_distance'] <= 1e-7:
            ids = np.flatnonzero(lam > 1e-12)
            matrix = np.asarray(features, dtype=np.int64)[ids].T
            recovery, exact = exact_recover(matrix, target, lam[ids])
            out['recovery'] = recovery
            if exact is not None:
                out.update(status='EXACT_SINGLETON_CONDITIONAL_BASIS_MIXTURE_CANDIDATE',
                           zero_bases=[{'indices': bases[int(i)], 'weight': str(w)} for i, w in zip(ids, exact) if w > 0],
                           unit_probabilities=[{'index': j, 'probability': str(q[j])} for j in units if q[j]],
                           conditional_target=list(map(str, q)))
                reason = 'EXACT_RECOVERY_REQUIRES_INDEPENDENT_PHYSICAL_REPLAY'
                break
            reason = 'NUMERIC_GATE_OPEN_EXACT_RECOVERY_FAILED'; break
        scale = 1 << 30
        c = [int(round(v*scale)) for v in solution.row_dual[1:]]
        basis = greedy(c); support = sum(c[positions[j]] for j in basis)
        value = sum(Q(c[i])*q[j] for i, j in enumerate(ground))
        record['exact_pricing_gap'] = str(value-support)
        if value > support:
            rows, total, prefix = {}, Q(0), []
            for j in sorted(ground, key=lambda j: (-c[positions[j]], j)):
                prefix.append(j); insert(rows, Z[j]); total += q[j]
                if total > len(rows):
                    out.update(status='EXACT_CONDITIONAL_RANK_CUT_CANDIDATE',
                               cut={'sector': 'T', 'anchor_orbit': 32, 'mandatory_index': None,
                                    'indices': sorted(prefix), 'bound': len(rows),
                                    'exact_violation': str((total-len(rows))*p)})
                    reason = 'EXACT_PREFIX_RANK_VIOLATION'; break
            assert 'cut' in out
            break
        if not add([basis]):
            reason = 'COLUMN_CAP' if len(bases) == args.column_cap else 'NO_NEW_GREEDY_COLUMN'; break
        if iteration % 25 == 0:
            print(json.dumps(record), flush=True)
    out.update(stopping_reason=reason, elapsed_seconds=time.monotonic()-start, feature_columns=len(bases))
    assert all(sha(ROOT/name) == digest for name, digest in sources.items())
    args.output.write_text(json.dumps(out, indent=2)+'\n')
    print(json.dumps({k: out[k] for k in ('status', 'stopping_reason', 'elapsed_seconds', 'feature_columns')}))


if __name__ == '__main__':
    main()
