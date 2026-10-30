#!/usr/bin/env python3
"""Bound the saved orbit32 functional using joint anchor compatibility.

The source necessity is elementary: selected vectors are independent in each
sector and their cross-pairing matrix is a partial permutation matrix. For the
saved one-X/eleven-Z anchor set, the eleven Z vectors are independent. After
branching on the X anchor, eligible Z anchors therefore form partner bins of
capacity one, plus an unrestricted zero-pairing bin. This computes the exact
maximum over these local necessities. It does not require a full completion.

Floating LP output proposes ten unconditional feature coefficients. Only exact
integer class bounds are retained, for independent exhaustive-subset replay.
"""
from pathlib import Path
from fractions import Fraction as Q
from collections import defaultdict
import argparse, gzip, hashlib, json, time
import numpy as np
from scipy.optimize import linprog
from certify_profile_moment_point import layout

ROOT = Path(__file__).resolve().parent


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def rank(vectors):
    pivots = {}
    for value in vectors:
        while value:
            p = value.bit_length() - 1
            if p in pivots:
                value ^= pivots[p]
            else:
                pivots[p] = value
                break
    return len(pivots)


def rotate(mask, h):
    return ((mask << h) | (mask >> (16 - h))) & 65535


def features(mask):
    return (1, mask.bit_count(), *[(mask & rotate(mask, h)).bit_count() for h in range(1, 9)])


def ceiling(value):
    return -((-value.numerator) // value.denominator)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--bank', type=Path, required=True)
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--seconds', type=float, default=60)
    ap.add_argument('--output', type=Path, required=True)
    a = ap.parse_args()
    start = time.monotonic()
    hp = ROOT / 'algebraic-results/hulls-16-rank.json.gz'
    pp = ROOT / 'algebraic-results/orbit-rank-profiles.json.gz'
    source = json.loads(a.bank.read_text())
    assert source['point_sha256'] == digest(a.point)
    anchors = source['anchors']
    assert len(anchors) == 12 and anchors[0] == ['S', 13]
    assert all(s == 'T' for s, o in anchors[1:]) and source['orbit'] == 32
    oldcut = source['cuts'][0]
    frozen = {
        'status': 'FROZEN_BEFORE_JOINT_ANCHOR_BOUND', 'orbit': 32,
        'anchors': anchors, 'bank_sha256': digest(a.bank),
        'point_sha256': digest(a.point), 'producer_sha256': digest(Path(__file__)),
        'hulls_sha256': digest(hp), 'profiles_sha256': digest(pp),
        'pool_sha256': {s: digest(ROOT / f'pools/{s}coords.txt') for s in 'xz'},
        'feature_LP_seconds': a.seconds,
        'scope': 'Existing affine anchor forms only; exact joint local partial-matching/independence maxima. This is a source necessary family, not a full-frame completion test.',
    }
    a.output.with_suffix('.frozen.json').write_text(json.dumps(frozen, indent=2) + '\n')
    hulls = json.loads(gzip.decompress(hp.read_bytes()))
    profiles = json.loads(gzip.decompress(pp.read_bytes()))
    hr = next(r for r in hulls['records'] if r['orbit'] == 32)
    pr = next(r for r in profiles['records'] if r['orbit'] == 32)
    bad = bytearray(65536)
    for row in pr['minimal_bad_certificates']:
        bad[row['mask']] = 1
    for mask in range(65536):
        if bad[mask]:
            continue
        bits = mask
        while bits:
            bit = bits & -bits
            bits -= bit
            if bad[mask ^ bit]:
                bad[mask] = 1
                break
    allowed = [m for m in range(65536) if not bad[m]]
    assert len(allowed) == 4597 == hr['phase_patterns']
    X, Z = [[int(v, 16) for v in (ROOT / f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
    orbit = X[16 * 32:16 * 33]
    sx = X[16 * anchors[0][1]]
    za = [Z[16 * o] for s, o in anchors[1:]]
    zrank = rank(za)
    assert zrank == len(za), ('partition_shortcut_requires_independent_Z_anchors', zrank)
    pairing = [[(x & z).bit_count() % 2 for z in za] for x in orbit]
    spair = [(sx & z).bit_count() % 2 for z in za]
    coefs = oldcut['anchor_coefficients']
    mask_rows = []
    for mask in allowed:
        phases = [h for h in range(16) if mask >> h & 1]
        vectors = [orbit[h] for h in phases]
        assert rank(vectors) == len(phases)
        s_ok = rank(vectors + [sx]) == len(phases) + 1
        values = [c[0] + sum(c[h + 1] for h in phases) for c in coefs]
        independent = max(0, values[0]) if s_ok else 0
        for j in range(11):
            if sum(pairing[h][j] for h in phases) <= 1:
                independent += max(0, values[j + 1])
        branches = []
        for include_s in (False, True):
            if include_s and not s_ok:
                continue
            zero = 0
            bins = {}
            for j in range(11):
                partners = [h for h in phases if pairing[h][j]]
                if include_s and spair[j]:
                    partners.append(16)
                if len(partners) > 1:
                    continue
                score = max(0, values[j + 1])
                if not partners:
                    zero += score
                else:
                    bins[partners[0]] = max(bins.get(partners[0], 0), score)
            branches.append((values[0] if include_s else 0) + zero + sum(bins.values()))
        joint = max(branches)
        assert 0 <= joint <= independent
        mask_rows.append({'mask': mask, 'independent_hinge_bound': independent, 'joint_bound': joint})
    scores = {r['mask']: r for r in mask_rows}
    classes = defaultdict(list)
    for mask in allowed:
        classes[min(rotate(mask, h) for h in range(16))].append(mask)
    class_rows = []
    for representative, masks in sorted(classes.items()):
        assert set(masks) == {rotate(representative, h) for h in range(16)}
        class_rows.append({
            'representative': representative, 'size': len(masks),
            'features': features(representative),
            'old_score_sum': sum(scores[m]['independent_hinge_bound'] for m in masks),
            'joint_score_sum': sum(scores[m]['joint_bound'] for m in masks),
        })
    _, index, moment = layout(hulls)
    values = list(map(Q, json.loads(gzip.decompress(a.point.read_bytes()))['values']))
    targets = [Q(1), 16 * values[index['p', 32]], *[16 * values[moment('S', h, 32, 32)] for h in range(1, 9)]]
    anchor_value = sum(c[0] * values[index['p', o]] + sum(c[h + 1] * values[moment(s, h, o, 32)] for h in range(16)) for (s, o), c in zip(anchors, coefs))
    old_u = oldcut['unconditional_coefficients']
    old_violation = anchor_value + sum(c * q for c, q in zip(old_u, targets))
    assert old_violation == Q(oldcut['exact_violation'])
    def class_residual(u, row, scale=1):
        return sum(c * f for c, f in zip(u, row['features'])) + Q(scale * row['joint_score_sum'], row['size'])
    improvement = -max(class_residual(old_u, r) for r in class_rows)
    assert improvement >= 0
    proposals = []
    def save_proposal(u, scale, origin):
        correction = ceiling(max(class_residual(u, r, scale) for r in class_rows))
        u = list(u)
        u[0] -= correction
        violation = scale * anchor_value + sum(c * q for c, q in zip(u, targets))
        assert all(class_residual(u, r, scale) <= 0 for r in class_rows)
        proposals.append({'unconditional_coefficients': u,
            'anchor_coefficients': [[scale * c for c in cs] for cs in coefs],
            'scale': scale, 'origin': origin, 'exact_violation': str(violation),
            'normalized_exact_violation': str(violation / scale),
            'normalized_gain_over_parent': str(violation / scale - old_violation)})
    scale = improvement.denominator
    save_proposal([scale * c for c in old_u], scale, 'existing_functional_exact_constant_tightening')
    A = np.array([r['features'] for r in class_rows], dtype=float)
    bounds = np.array([-r['joint_score_sum'] / r['size'] for r in class_rows])
    lp = linprog(-np.array(list(map(float, targets))), A_ub=A, b_ub=bounds,
                 bounds=[(None, None)] * 10, method='highs', options={'time_limit': a.seconds})
    if lp.success:
        for scale in (1, 16, 256, 4096):
            save_proposal(np.rint(lp.x * scale).astype(np.int64).tolist(), scale, 'joint_feature_support_LP_exactly_corrected')
    best = max(proposals, key=lambda r: Q(r['normalized_exact_violation']))
    result = {
        'status': 'EXACT_JOINT_BOUND_CANDIDATE', 'source_C16_answered': False,
        'orbit': 32, 'anchors': anchors, 'profile_weights_free': True,
        'input_hashes': frozen, 'frozen_sha256': digest(a.output.with_suffix('.frozen.json')),
        'all_Z_anchors_rank': zrank, 'allowed_masks': len(allowed),
        'cyclic_classes': len(classes),
        'strictly_improved_masks': sum(r['joint_bound'] < r['independent_hinge_bound'] for r in mask_rows),
        'strictly_improved_classes': sum(r['joint_score_sum'] < r['old_score_sum'] for r in class_rows),
        'existing_functional_constant_gain': str(improvement),
        'parent_exact_violation': str(old_violation),
        'feature_LP_status': int(lp.status), 'feature_LP_message': lp.message,
        'cut': best, 'proposals': proposals, 'class_bounds': class_rows,
        'mask_bounds': mask_rows, 'elapsed_seconds': time.monotonic() - start,
        'scope': 'Necessary joint local anchor/phase inequalities. Positive projected gains do not prove source infeasibility; the old saved point is already excluded by its parent cut. Independent exhaustive-subset replay is required.',
    }
    a.output.write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({k: v for k, v in result.items() if k not in ('mask_bounds', 'class_bounds', 'proposals', 'input_hashes', 'cut')}, indent=2))
    print('BEST_CUT', json.dumps(best))


if __name__ == '__main__':
    main()
