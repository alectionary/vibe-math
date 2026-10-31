#!/usr/bin/env python3
"""Bounded literal-7211 Wolfe discovery; exact 16-pattern cut pricing.

The numerical corral is discovery only.  A positive integer support gap is
exported for independent acceptance; no numerical residual certifies membership.
All priced physical columns and the final convex-combination weights are saved.
"""
from pathlib import Path
from fractions import Fraction
import argparse
import datetime
import hashlib
import json
import time

import numpy as np
from scipy.linalg import lstsq
from two_sided_full_basis_oracle import (
    TwoSidedFullBasisOracle, N, LAYOUT, feature, target, compile_row,
    json_exact, source_hashes, export_cut_bank, sha,
)

ROOT = Path(__file__).resolve().parent


def write(path, obj):
    Path(path).write_text(json.dumps(json_exact(obj), indent=2) + '\n')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--X', type=int, nargs=2, required=True)
    parser.add_argument('--Z', type=int, nargs=2, required=True)
    parser.add_argument('--point', type=Path, required=True)
    parser.add_argument('--controls', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--seconds', type=float, default=60)
    parser.add_argument('--seed', type=int, default=20261030)
    parser.add_argument('--max-cuts', type=int, default=8)
    args = parser.parse_args()
    assert 0 < args.seconds <= 60 and args.max_cuts > 0
    assert not args.output.exists()
    prefix = args.output.with_suffix('')
    frozen_path = prefix.with_name(prefix.name + '.frozen.json')
    archive_path = prefix.with_name(prefix.name + '.columns.npz')
    cut_path = prefix.with_name(prefix.name + '.cuts.json')
    assert not any(p.exists() for p in (frozen_path, archive_path, cut_path))
    controls = json.loads(args.controls.read_text())
    assert controls['status'] == 'PASS'
    assert controls['proof_kind'] == 'two_sided_full_basis_shared_2X2Z_pattern_controls'
    assert controls['producer_sha256'] == sha(ROOT / 'two_sided_full_basis_oracle.py')
    assert controls['consumer_sha256'] == sha(ROOT / 'verify_two_sided_full_basis_oracle.py')
    assert sha(args.point) == '5f9a622e68a3c1e842ae13a5a5b18cf06b388515b5821d17eda2389375b290ef'
    wanted = target(args.point, args.X, args.Z)
    b = np.array(list(map(float, wanted)))
    oracle = TwoSidedFullBasisOracle()
    domains = oracle.prepare(args.X, args.Z)
    scale = 1 << 24
    rng = np.random.default_rng(args.seed)
    target_direction = np.rint(b * scale / max(abs(b))).astype(np.int64).tolist()
    target_direction[0] = 0
    seeds = [('zero', [0] * N), ('target', target_direction),
             ('negative_target', [-v for v in target_direction])]
    seeds += [(f'signed_random_{i}', rng.integers(-16, 17, size=N).tolist()) for i in range(4)]
    for _, c in seeds:
        c[0] = 0
    hashes = source_hashes()
    hashes['two_sided_full_basis_wolfe.py'] = sha(Path(__file__))
    hashes['verify_two_sided_full_basis_oracle.py'] = sha(ROOT / 'verify_two_sided_full_basis_oracle.py')
    hashes[str(args.controls.resolve().relative_to(ROOT))] = sha(args.controls)
    frozen = dict(status='FROZEN_BEFORE_TWO_SIDED_FULL_BASIS_WOLFE',
                  source_C16_answered=False, utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                  point_c16_path=str(args.point.resolve().relative_to(ROOT)), point_sha256=sha(args.point),
                  controls_sha256=sha(args.controls), source_hashes=hashes,
                  X_anchors=args.X, Z_anchors=args.Z, feature_layout=LAYOUT,
                  selection_patterns=list(range(16)), metric='raw Euclidean on7210 nonconstant literal features',
                  seconds=args.seconds, pricing_scale=scale, random_seed=args.seed,
                  seed_queries=[dict(label=label, coefficients=c) for label, c in seeds],
                  maximum_retained_cuts=args.max_cuts,
                  scope='Two full physical bases, common2X2Zpattern; unanchored mutual pairings relaxed. Numerical discovery only.')
    write(frozen_path, frozen)
    start = time.monotonic()
    deadline = start + args.seconds
    features, masks, X_bases, Z_bases = [], [], [], []
    lookup = {}
    cuts, positive_proposals, seen_directions = [], [], set()

    def archive(priced):
        ids = []
        for r in priced['support_records']:
            if r['value'] is None:
                continue
            f = np.asarray(feature(r['mask'], r['X_selected'], r['Z_selected']), dtype=np.uint8)
            key = f.tobytes()
            idx = lookup.get(key)
            if idx is None:
                idx = len(features)
                lookup[key] = idx
                features.append(f)
                masks.append(r['mask'])
                X_bases.append(np.asarray(r['X_selected'], dtype=np.uint16))
                Z_bases.append(np.asarray(r['Z_selected'], dtype=np.uint16))
            ids.append(idx)
        return ids

    def record_direction(c, priced, label):
        bound = priced['upper_bound']
        assert bound is not None and Fraction(bound).denominator == 1
        exact_value = sum(a * v for a, v in zip(c, wanted))
        gap = exact_value - bound
        if gap > 0:
            positive_proposals.append(dict(label=label, coefficients=c, upper_bound=int(bound),
                                           exact_target_value=str(exact_value), exact_violation=str(gap)))
            key = tuple(c)
            if key not in seen_directions:
                seen_directions.add(key)
                row, rhs = compile_row(c, bound, args.X, args.Z)
                cuts.append(dict(label=label, X_anchors=args.X, Z_anchors=args.Z,
                                 coefficients=c, upper_bound=int(bound), exact_target_value=str(exact_value),
                                 exact_violation=str(gap), owner_row_terms=[[j, a] for j, a in row.items()],
                                 rhs=rhs, support_records=priced['support_records'],
                                 direction_max_abs=max(abs(v) for v in c)))
                cuts.sort(key=lambda cut: Fraction(cut['exact_violation']) / cut['direction_max_abs'], reverse=True)
                del cuts[args.max_cuts:]
        return bound, exact_value, gap

    seed_results = []
    for label, c in seeds:
        assert time.monotonic() < deadline, 'seed preparation exceeded fixed pilot cap'
        priced = oracle.support(c, domains)
        ids = archive(priced)
        bound, value, gap = record_direction(c, priced, label)
        seed_results.append(dict(label=label, upper_bound=int(bound), exact_target_value=str(value),
                                 exact_violation=str(gap), column_ids=ids))
    nearest = min(range(len(features)), key=lambda i: float(np.dot(features[i] - b, features[i] - b)))
    active, weights = [nearest], np.ones(1)

    def mixture(ids, w):
        return w @ np.asarray([features[i] for i in ids], dtype=float)

    def objective(x):
        return 0.5 * float(np.dot(x - b, x - b))

    def correct(ids, w):
        ids, w = list(ids), w.copy()
        affine_rank = 0
        for minor in range(1000):
            if time.monotonic() >= deadline:
                return ids, w, minor, affine_rank, 'TIME_LIMIT_DURING_CORRECTION'
            old = objective(mixture(ids, w))
            V = np.asarray([features[i][1:] for i in ids], dtype=float)
            if len(ids) == 1:
                alpha = np.ones(1)
            else:
                eta, _, affine_rank, _ = lstsq((V[1:] - V[0]).T, b[1:] - V[0],
                                               cond=1e-12, lapack_driver='gelsy')
                if affine_rank != len(ids) - 1:
                    return ids, w, minor, int(affine_rank), 'AFFINE_RANK_FAILURE'
                alpha = np.r_[1 - eta.sum(), eta]
            assert np.all(np.isfinite(alpha))
            if alpha.min() >= -1e-11:
                w = np.maximum(alpha, 0)
                w /= w.sum()
                keep = w > 0
                ids, w = [i for i, k in zip(ids, keep) if k], w[keep]
                assert objective(mixture(ids, w)) <= old + 1e-9 * max(1., old)
                return ids, w, minor + 1, int(affine_rank), None
            bad = np.flatnonzero(alpha < 0)
            ratios = w[bad] / (w[bad] - alpha[bad])
            hit = int(bad[np.argmin(ratios)])
            theta = float(min(ratios))
            assert -1e-12 <= theta <= 1 + 1e-12
            w = (1 - theta) * w + theta * alpha
            w[hit] = 0
            assert w.min() >= -1e-10
            w = np.maximum(w, 0)
            w /= w.sum()
            keep = w > 0
            ids, w = [i for i, k in zip(ids, keep) if k], w[keep]
            assert objective(mixture(ids, w)) <= old + 1e-9 * max(1., old)
        return ids, w, 1000, int(affine_rank), 'MINOR_CYCLE_LIMIT'

    rounds = []
    reason = 'ROUND_LIMIT'
    last_direction = np.zeros(N)
    for iteration in range(10000):
        if time.monotonic() >= deadline:
            reason = 'TIME_LIMIT'
            break
        before = time.monotonic()
        active, weights, minor, affine_rank, failure = correct(active, weights)
        x = mixture(active, weights)
        raw = b - x
        raw[0] = 0
        norm = float(max(abs(raw)))
        rec = dict(round=iteration, active_columns=len(active), history_columns=len(features),
                   objective=objective(x), max_feature_residual=norm, minor_cycles=minor,
                   affine_rank=affine_rank, correction_seconds=time.monotonic() - before,
                   correction_failure=failure, weight_mass=float(sum(weights)),
                   minimum_weight=float(min(weights)))
        rounds.append(rec)
        if failure:
            reason = failure
            break
        V = np.asarray([features[i] for i in active], dtype=float)
        stationarity = float(max(abs((V - x) @ raw)))
        rec['corral_stationarity_residual'] = stationarity
        if stationarity > 1e-7 * max(1., norm):
            reason = 'CORRAL_STATIONARITY_FAILURE'
            break
        if norm <= 1e-10:
            reason = 'NUMERICAL_MIXTURE_REQUIRES_EXACT_RECOVERY'
            break
        direction = raw / norm
        last_direction = direction
        c = [int(np.rint(v * scale)) for v in direction]
        c[0] = 0
        before = time.monotonic()
        priced = oracle.support(c, domains)
        ids = archive(priced)
        bound, value, gap = record_direction(c, priced, f'round_{iteration}')
        # Score exact rounded maximizers using the true residual direction.
        # Binary features have range1, so L1 coefficient-rounding error bounds
        # the possible advantage of the true maximizer over a rounded one.
        sample_scores = [float(direction @ features[i]) for i in ids]
        sampled_best = ids[int(np.argmax(sample_scores))]
        chosen = sampled_best
        chosen_score = max(sample_scores)
        for lo in range(0, len(features), 512):
            scores = np.asarray(features[lo:lo + 512], dtype=float) @ direction
            j = int(np.argmax(scores))
            if scores[j] > chosen_score:
                chosen, chosen_score = lo + j, float(scores[j])
        improvement = float(chosen_score - direction @ x)
        quantization = float(sum(abs(direction - np.asarray(c) / scale)))
        rec.update(pricing_seconds=time.monotonic() - before, exact_upper_bound=int(bound),
                   exact_target_value=str(value), exact_violation=str(gap),
                   normalized_violation=float(gap / scale),
                   true_gradient_vertex_improvement=improvement,
                   quantization_advantage_bound=quantization,
                   numerical_Wolfe_upper_with_rounding=improvement + quantization,
                   chosen_column_id=chosen, retained_cuts=len(cuts))
        print(json.dumps(rec), flush=True)
        if improvement <= 1e-12:
            reason = 'NO_TRUE_GRADIENT_IMPROVEMENT_FROM_ROUNDED_PRICING'
            break
        if chosen in active:
            reason = 'PRICED_VERTEX_ALREADY_IN_CORRAL'
            break
        active.append(chosen)
        weights = np.r_[weights, 0.]
        if iteration % 10 == 0:
            write(prefix.with_name(prefix.name + '.progress.json'),
                  dict(status='RUNNING', elapsed_seconds=time.monotonic() - start,
                       rounds=rounds, positive_proposals=len(positive_proposals)))
    global_weights = np.zeros(len(features))
    global_weights[np.asarray(active, dtype=np.int64)] = weights
    np.savez_compressed(archive_path, features=np.stack(features), masks=np.asarray(masks, dtype=np.uint8),
                        selected_X_indices=np.stack(X_bases), selected_Z_indices=np.stack(Z_bases),
                        master_mixture_weights=global_weights, active_column_ids=np.asarray(active, dtype=np.int32),
                        search_direction=last_direction)
    assert all(sha(ROOT / p) == value for p, value in hashes.items())
    if cuts:
        export_cut_bank(cut_path, args.point, cuts,
                        frozen_inputs={str(frozen_path.resolve().relative_to(ROOT)): sha(frozen_path),
                                       str(archive_path.resolve().relative_to(ROOT)): sha(archive_path)})
    result = dict(**frozen)
    result.update(status='EXACT_SUPPORT_CUT_CANDIDATE' if cuts else 'NO_EXACT_SEPARATOR_FOUND',
                  frozen_sha256=sha(frozen_path), stopping_reason=reason,
                  elapsed_seconds=time.monotonic() - start, seed_results=seed_results,
                  initial_active_column=nearest, rounds=rounds, positive_proposals=positive_proposals,
                  retained_cuts=len(cuts), cut_bank=str(cut_path) if cuts else None,
                  cut_bank_sha256=sha(cut_path) if cuts else None,
                  columns_artifact=str(archive_path), columns_sha256=sha(archive_path),
                  history_columns=len(features), final_active_columns=active,
                  final_numeric_weights=weights.tolist(),
                  numeric_mixture_max_feature_residual=float(max(abs(mixture(active, weights) - b))),
                  numerical_no_cut_is_not_membership=True)
    write(args.output, result)
    print(json.dumps({k: result[k] for k in ('status', 'stopping_reason', 'elapsed_seconds', 'retained_cuts',
                                           'history_columns', 'numeric_mixture_max_feature_residual')}), flush=True)


if __name__ == '__main__':
    main()
