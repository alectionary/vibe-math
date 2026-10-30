#!/usr/bin/env python3
"""Bounded cutting-plane separation for an orbit/full-opposite-basis projection.

Numerical LP output proposes coefficients. Every exported cut has an exactly
computed support over all291 mask representatives, using equivariant weights.
It remains a CANDIDATE until the independent physical support consumer passes.
No numerical no-separation result establishes convex-hull membership.
"""
from pathlib import Path
from fractions import Fraction
import argparse
import gzip
import hashlib
import json
import math
import os
import time

import numpy as np
from scipy.optimize import linprog
from scipy.sparse import csr_matrix, hstack

from full_partner_basis_oracle import FullPartnerBasisOracle
from full_partner_projection_features import (FEATURES, candidate_weights, column_features,
                                             mask_score, moment_target, rotate)
from verify_projected_profile_moment_rows import point_vector

ROOT = Path(__file__).resolve().parent
LAYOUT = '1,k,C1..C8,n[45],d[45,16].ravel(C)'


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    raw = Path(path).read_bytes()
    return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)


def mask_universe(orbit):
    profiles = read(ROOT / 'algebraic-results/orbit-rank-profiles.json.gz')
    hulls = read(ROOT / 'algebraic-results/hulls-16-rank.json.gz')
    profile = next(r for r in profiles['records'] if r['orbit'] == orbit)
    bad = bytearray(65536)
    for item in profile['minimal_bad_certificates']:
        bad[item['mask']] = 1
    for mask in range(65536):
        if orbit == 12 and mask.bit_count() > 11:
            bad[mask] = 1
        if not bad[mask]:
            bits = mask
            while bits:
                bit = bits & -bits
                bits -= bit
                if bad[mask ^ bit]:
                    bad[mask] = 1
                    break
    allowed = [mask for mask in range(65536) if not bad[mask]]
    expected = next(r for r in hulls['records'] if r['orbit'] == orbit)['phase_patterns']
    assert len(allowed) == expected
    allowed_set = set(allowed)
    assert all(rotate(mask, h) in allowed_set for mask in allowed for h in range(16))
    return allowed, sorted({min(rotate(mask, h) for h in range(16)) for mask in allowed})


def support_all(oracle, domains, coefficients):
    """Exact pricing, including mandatory negative weights; no floating support."""
    records, columns = [], []
    maximum = None
    for mask, domain in domains:
        result = oracle.support(domain, candidate_weights(mask, coefficients))
        if result['status'] != 'EXACT_FULL_PARTNER_BASIS_SUPPORT':
            raise ValueError('Infeasible mask domain needs an independent exclusion record before this pilot can omit it')
        assert result['value'].denominator == 1
        support = int(result['value'])
        total = mask_score(mask, coefficients) + support
        assert isinstance(total, int)
        feature = column_features(mask, result['selected_Z_indices'])
        assert total == sum(c * f for c, f in zip(coefficients, feature))
        records.append({'mask': mask, 'support_value': support, 'full_value': total,
                        'selected_Z_indices': list(result['selected_Z_indices']),
                        'zero_basis_indices': list(result['zero_basis_indices']),
                        'owner_indices': list(result['owner_indices'])})
        columns.append(feature)
        maximum = total if maximum is None else max(maximum, total)
    return maximum, records, columns


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--orbit', type=int, default=32)
    ap.add_argument('--seconds', type=float, default=600)
    ap.add_argument('--max-rounds', type=int, default=100)
    ap.add_argument('--pricing-scale', type=int, default=65536)
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    assert args.orbit == 32, 'First bounded pilot is scoped to orbit32'
    assert 0 < args.seconds <= 600 and args.max_rounds > 0 and args.pricing_scale > 0
    assert not args.output.exists() and not args.output.with_suffix('.frozen.json').exists()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    start = time.monotonic()
    allowed, representatives = mask_universe(args.orbit)
    target = moment_target(point_vector(args.point), args.orbit)
    assert len(target) == FEATURES and target[0] == 1
    source_paths = ['full_partner_projection.py', 'full_partner_projection_features.py',
                    'full_partner_basis_oracle.py', 'verify_projected_profile_moment_rows.py',
                    'projected_profile_moment_matrix.py', 'pools/xcoords.txt', 'pools/zcoords.txt',
                    'physical-pool-source.json', 'algebraic-results/orbit-rank-profiles.json.gz',
                    'algebraic-results/hulls-16-rank.json.gz',
                    'moment-resumption-results/symmetry-bridge-independent.json',
                    'coupling-results/full-partner-orbit32-independent.json']
    sources = {path: sha(ROOT / path) for path in source_paths}
    symmetry = read(ROOT / 'moment-resumption-results/symmetry-bridge-independent.json')
    assert symmetry['status'] == 'PASS'
    assert all(symmetry['pool_sha256'][f'pools/{s}coords.txt'] == sources[f'pools/{s}coords.txt'] for s in 'xz')
    frozen = {'status': 'FROZEN_BEFORE_FULL_PARTNER_PROJECTION', 'source_C16_answered': False,
              'orbit': args.orbit, 'feature_layout': LAYOUT, 'point_sha256': sha(args.point),
              'source_hashes': sources, 'allowed_masks': len(allowed), 'representatives': representatives,
              'allowed_mask_list_sha256': hashlib.sha256(json.dumps(allowed, separators=(',', ':')).encode()).hexdigest(),
              'seconds': args.seconds, 'max_rounds': args.max_rounds, 'pricing_scale': args.pricing_scale,
              'dual_coefficient_box': [-1, 1], 'constant_feature_coefficient': 0,
              'scope': 'Bounded numerical separation of one-sided full-basis projection; no remaining physical X completion or outside-mask X absences are required.'}
    frozen_path = args.output.with_suffix('.frozen.json')
    frozen_path.write_text(json.dumps(frozen, indent=2) + '\n')
    oracle = FullPartnerBasisOracle()
    domains = [(mask, oracle.prepare(args.orbit, mask)) for mask in representatives]
    assert all(domain['status'] == 'FULL_PARTNER_BASIS_DOMAIN' for _, domain in domains)
    zero = (0,) * FEATURES
    _, _, initial = support_all(oracle, domains, zero)
    features, seen = [], set()

    def add_columns(columns):
        added = 0
        for column in columns:
            packed = np.asarray(column[1:], dtype=np.int16)
            key = packed.tobytes()
            if key not in seen:
                seen.add(key)
                features.append(packed)
                added += 1
        return added

    add_columns(initial)
    rounds, cuts = [], []
    result = {**frozen, 'status': 'RUNNING', 'frozen_sha256': sha(frozen_path),
              'rounds': rounds, 'cuts': cuts, 'source_C16_answered': False}
    objective = np.r_[-np.array(list(map(float, target[1:]))), 1.0]
    bounds = [(-1.0, 1.0)] * (FEATURES - 1) + [(None, None)]
    reason = 'ROUND_LIMIT'
    for iteration in range(args.max_rounds):
        remaining = args.seconds - (time.monotonic() - start)
        if remaining <= 0:
            reason = 'TIME_LIMIT'
            break
        A = hstack([csr_matrix(np.stack(features)), -np.ones((len(features), 1))], format='csr')
        before = time.monotonic()
        lp = linprog(objective, A_ub=A, b_ub=np.zeros(len(features)), bounds=bounds, method='highs',
                     options={'time_limit': max(.01, remaining), 'dual_feasibility_tolerance': 1e-9,
                              'primal_feasibility_tolerance': 1e-9})
        record = {'round': iteration, 'master_columns': len(features), 'numeric_status': int(lp.status),
                  'numeric_message': str(lp.message), 'LP_seconds': time.monotonic() - before,
                  'numeric_restricted_separation': -float(lp.fun) if lp.fun is not None else None}
        rounds.append(record)
        if lp.status != 0 or lp.x is None:
            reason = 'MASTER_NOT_OPTIMAL'
            break
        coefficients = (0, *(int(np.rint(value * args.pricing_scale)) for value in lp.x[:-1]))
        before = time.monotonic()
        upper, supports, columns = support_all(oracle, domains, coefficients)
        target_value = sum(c * t for c, t in zip(coefficients, target))
        gap = target_value - upper
        added = add_columns(columns)
        record.update(exact_integer_support=upper, exact_target_value=str(target_value), exact_violation=str(gap),
                      scaled_violation=float(gap / args.pricing_scale), pricing_seconds=time.monotonic()-before,
                      columns_added=added, numeric_master_bound=float(lp.x[-1]),
                      rounded_global_bound=upper / args.pricing_scale)
        print(json.dumps(record), flush=True)
        if gap > 0:
            cuts.append({'coefficients': list(coefficients), 'upper_bound': upper,
                         'exact_target_value': str(target_value), 'exact_violation': str(gap),
                         'pricing_scale': args.pricing_scale, 'support_records': supports})
            reason = 'EXACT_POSITIVE_SUPPORT_GAP_REQUIRES_INDEPENDENT_REPLAY'
            break
        result.update(elapsed_seconds=time.monotonic()-start, feature_columns=len(features))
        args.output.write_text(json.dumps(result, indent=2) + '\n')
        if added == 0:
            reason = 'NO_NEW_COLUMNS_NUMERICAL_STALL'
            break
        if upper / args.pricing_scale <= float(lp.x[-1]) + 1e-8:
            reason = 'NO_EXACT_SEPARATOR_AT_NUMERICAL_STOP'
            break
    unchanged = {path: sha(ROOT / path) == digest for path, digest in sources.items()}
    assert all(unchanged.values()), 'A frozen dependency changed during pricing'
    result.update(status='EXACT_SUPPORT_CUT_CANDIDATE' if cuts else 'NO_EXACT_SEPARATOR_FOUND',
                  stopping_reason=reason, elapsed_seconds=time.monotonic()-start,
                  feature_columns=len(features), source_files_unchanged=unchanged,
                  scope='Each positive candidate has an exact integer global support calculation over all291 representatives for equivariant weights, but requires independent physical upper-bound and translation replay. No-separation, stall, or timeout establishes neither projection membership nor source feasibility. No full source anchor is excluded.')
    args.output.write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({key: result[key] for key in ('status', 'stopping_reason', 'elapsed_seconds', 'feature_columns')}), flush=True)


if __name__ == '__main__':
    main()
