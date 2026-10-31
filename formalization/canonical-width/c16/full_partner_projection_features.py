#!/usr/bin/env python3
"""Pure feature/weight translation for the proposed full-partner projection.

There is no solver, support-bound acceptance, source exclusion, or certificate
compiler here. moment_row() translates a supplied bound; it does NOT validate
that bound. Features are invariant under simultaneous physical phase rotation.
"""
from collections import Counter
from fractions import Fraction
from numbers import Integral

from projected_profile_moment_matrix import owner_coordinate

ORBITS = 45
PERIOD = 16
FEATURES = 10 + 45 + 45 * 16


def rotate(mask, phase):
    phase %= 16
    return ((mask << phase) | (mask >> ((16 - phase) % 16))) & 65535


def _exact(values, length):
    values = tuple(values)
    if len(values) != length:
        raise ValueError(f'expected {length} coefficients')
    if any(not isinstance(v, (Integral, Fraction)) for v in values):
        raise TypeError('coefficients must be exact integers or Fractions')
    return tuple(int(v) if isinstance(v, Integral) else v for v in values)


def column_features(mask, selected_Z_indices):
    """Return integer (1, |P|, C1..C8, n[45], d[45,16].ravel(C)).

    d[j,h] = sum_t p[t] q[j,t+h]. Arbitrary subsets are accepted for
    translation controls; callers must separately establish full-basis validity.
    """
    if type(mask) is not int or not 0 <= mask < 65536:
        raise ValueError('mask must be a 16-bit integer')
    selected = tuple(selected_Z_indices)
    if any(type(i) is not int or not 0 <= i < 720 for i in selected) or len(set(selected)) != len(selected):
        raise ValueError('selected Z indices must be distinct physical indices')
    masks = [0] * 45
    for index in selected:
        orbit, phase = divmod(index, 16)
        masks[orbit] |= 1 << phase
    return (1, mask.bit_count(), *(int((mask & rotate(mask, h)).bit_count()) for h in range(1, 9)),
            *(q.bit_count() for q in masks),
            *((mask & rotate(q, -h)).bit_count() for q in masks for h in range(16)))


def candidate_weights(mask, coefficients):
    """Induce720 exact signed weights a[j,b]=v[j]+sum_h w[j,h]*p[b-h]."""
    if type(mask) is not int or not 0 <= mask < 65536:
        raise ValueError('mask must be a 16-bit integer')
    c = _exact(coefficients, FEATURES)
    return tuple(c[10 + j] + sum(c[55 + 16 * j + h]
                 for h in range(16) if mask >> ((b - h) % 16) & 1)
                 for j in range(45) for b in range(16))


def mask_score(mask, coefficients):
    c = _exact(coefficients, FEATURES)
    feature = column_features(mask, ())
    return sum(c[i] * feature[i] for i in range(10))


def moment_target(owner_vector, orbit=32):
    """Exact target in the integer-feature normalization; no feasibility claim."""
    if len(owner_vector) != 36495 or not 0 <= orbit < 45:
        raise ValueError('wrong owner vector length or profile orbit')
    return (1, 16 * owner_vector[orbit],
            *(16 * owner_vector[owner_coordinate('S', h, orbit, orbit)] for h in range(1, 9)),
            *(16 * owner_vector[j] for j in range(45)),
            *(16 * owner_vector[owner_coordinate('T', h, orbit, j)] for j in range(45) for h in range(16)))


def moment_row(coefficients, bound, orbit=32):
    """Translate c.dot(phi)<=bound to a sparse physical owner row <= rhs.

    This function accepts an UNVERIFIED bound for translation. A future source
    cut consumer must prove it by the exact global support oracle independently.
    """
    c = _exact(coefficients, FEATURES)
    bound = _exact((bound,), 1)[0]
    if not 0 <= orbit < 45:
        raise ValueError('invalid orbit')
    row = Counter({orbit: 16 * c[1]})
    for h in range(1, 9):
        row[owner_coordinate('S', h, orbit, orbit)] += 16 * c[h + 1]
    for j in range(45):
        row[j] += 16 * c[10 + j]
        for h in range(16):
            row[owner_coordinate('T', h, orbit, j)] += 16 * c[55 + 16 * j + h]
    return dict(sorted((i, value) for i, value in row.items() if value)), bound - c[0]


def self_controls(physical=False):
    """Literal controls, including sector swap; arbitrary selections are not frames."""
    import random
    import numpy as np
    rng = random.Random(20261030)
    coefficients = tuple(rng.randrange(-9, 10) for _ in range(FEATURES))
    feature_checks = weight_checks = row_checks = covariance_checks = 0
    for control in range(12):
        probability = (0, 1, .03, .1, .25, .5)[control % 6]
        X = np.array([[int(rng.random() < probability) for _ in range(16)] for _ in range(45)], dtype=np.int64)
        Z = np.array([[int(rng.random() < probability) for _ in range(16)] for _ in range(45)], dtype=np.int64)
        counts = np.zeros(36495, dtype=np.int64)
        literal = [0] * FEATURES
        for primary, opposite in ((X, Z), (Z, X)):
            original_P = sum(int(primary[32, h]) << h for h in range(16))
            original_Q = [16 * j + h for j in range(45) for h in range(16) if opposite[j, h]]
            weights = candidate_weights(original_P, coefficients)
            direct = sum(c * f for c, f in zip(coefficients, column_features(original_P, original_Q)))
            assert direct == mask_score(original_P, coefficients) + sum(weights[j] for j in original_Q)
            weight_checks += 1
            for rotation in range(16):
                P = rotate(original_P, rotation)
                Q = [16 * (j // 16) + (j % 16 + rotation) % 16 for j in original_Q]
                feature = column_features(P, Q)
                assert feature == column_features(original_P, original_Q)
                shifted_weights = candidate_weights(P, coefficients)
                assert all(shifted_weights[16*j + (b+rotation)%16] == weights[16*j+b] for j in range(45) for b in range(16))
                covariance_checks += 720
                literal = [a + b for a, b in zip(literal, feature)]
                anchor = primary[:, (-rotation) % 16]
                counts[:45] += anchor
                for h in range(9):
                    offset = 45 + 2025 * h
                    counts[offset:offset+2025] += np.outer(anchor, primary[:, (h-rotation)%16]).ravel(order='C')
                    offset += 9 * 2025
                    counts[offset:offset+2025] += np.outer(anchor, opposite[:, (h-rotation)%16]).ravel(order='C')
        moments = [Fraction(int(value), 32) for value in counts]
        target = moment_target(moments)
        assert tuple(Fraction(v, 32) for v in literal) == target
        feature_checks += FEATURES
        row, rhs = moment_row(coefficients, Fraction(7, 3))
        assert sum(value * moments[col] for col, value in row.items()) - rhs == sum(c * f for c, f in zip(coefficients, target)) - Fraction(7, 3)
        row_checks += 1
    physical_queries = 0
    if physical:
        from full_partner_basis_oracle import FullPartnerBasisOracle
        oracle = FullPartnerBasisOracle()
        for P in (0, 1, 3, 5):
            domain = oracle.prepare(32, P)
            assert domain['status'] == 'FULL_PARTNER_BASIS_DOMAIN'
            original = oracle.support(domain, candidate_weights(P, coefficients))
            for rotation in range(16):
                rotated_P = rotate(P, rotation)
                result = oracle.support(oracle.prepare(32, rotated_P), candidate_weights(rotated_P, coefficients))
                assert result['value'] == original['value']
                assert mask_score(P, coefficients) + result['value'] == sum(c*f for c,f in zip(coefficients, column_features(rotated_P, result['selected_Z_indices'])))
                physical_queries += 1
    return {'status': 'PASS', 'source_C16_answered': False, 'feature_count': FEATURES,
            'arbitrary_binary_selection_controls': 12, 'literal32_action_feature_equalities': feature_checks,
            'weight_decomposition_controls': weight_checks, 'individual_weight_covariance_checks': covariance_checks,
            'moment_row_controls': row_checks, 'physical_rotation_support_queries': physical_queries,
            'scope': 'Translation and covariance controls only. No support inequality, projected feasibility result, or source exclusion is certified.'}


if __name__ == '__main__':
    import argparse
    import json
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--physical-controls', action='store_true')
    args = parser.parse_args()
    print(json.dumps(self_controls(args.physical_controls), indent=2))
