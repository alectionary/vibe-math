"""Compile independently accepted projected shared-profile cuts as M @ x <= rhs.

The owner vector is p[45], then S[h].ravel(order='C') for h=0..8,
then T[h].ravel(order='C') for h=0..8.  No shape-weight variables
occur.  Receipt acceptance is a provenance gate, not a new source proof.
"""
from collections import Counter
from fractions import Fraction
from pathlib import Path
import hashlib
import json

import numpy as np
from scipy.sparse import coo_matrix

ORBITS = 45
PERIOD = 16
BLOCK = ORBITS * ORBITS
VARIABLES = ORBITS + 18 * BLOCK
INT64_MAX = (1 << 63) - 1


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def _require(condition, message):
    if not condition:
        raise ValueError(message)


def _integer(value, label):
    _require(type(value) is int, f'{label} must be an integer')
    _require(-INT64_MAX <= value <= INT64_MAX, f'{label} exceeds safe int64 range')
    return value


def owner_coordinate(side, h, i, j):
    """Use the moment identities, including the Boolean same-event diagonal."""
    _require(side in ('S', 'T'), 'sector must be S or T')
    for value, limit, label in ((h, 16, 'phase'), (i, 45, 'first orbit'), (j, 45, 'second orbit')):
        _require(type(value) is int and 0 <= value < limit, f'invalid {label}')
    if h > 8:
        h, i, j = 16 - h, j, i
    if h in (0, 8) and i > j:
        i, j = j, i
    if side == 'S' and h == 0 and i == j:
        return i
    return ORBITS + (0 if side == 'S' else 9 * BLOCK) + BLOCK * h + ORBITS * i + j


def _validate(bank, replay, digest):
    _require(isinstance(bank, dict) and isinstance(replay, dict), 'bank and replay must be objects')
    _require(replay.get('status') == 'PASS', 'independent replay must have status PASS')
    _require(replay.get('bank_sha256') == digest, 'independent replay bank SHA-256 mismatch')
    _require(bank.get('profile_weights_free') is True, 'bank must declare free profile weights')
    _require(replay.get('profile_weights_fixed_in_separation') is False,
             'independent replay must confirm projected, free-weight separation')
    o = bank.get('orbit')
    _require(type(o) is int and 0 <= o < 45, 'invalid profile orbit')
    anchors = bank.get('anchors')
    _require(isinstance(anchors, list), 'anchors must be a list')
    for anchor in anchors:
        _require(isinstance(anchor, list) and len(anchor) == 2, 'invalid anchor')
        side, orbit = anchor
        _require(side in ('S', 'T') and type(orbit) is int and 0 <= orbit < 45, 'invalid anchor sector/orbit')
    cuts = bank.get('cuts')
    _require(isinstance(cuts, list) and cuts, 'bank must contain projected cuts')
    _require(type(replay.get('cuts_checked')) is int and replay['cuts_checked'] == len(cuts),
             'independent replay cut count mismatch')
    results = replay.get('results')
    _require(isinstance(results, list) and len(results) == len(cuts), 'independent replay results mismatch')
    for k, cut in enumerate(cuts):
        _require(isinstance(cut, dict), 'cut must be an object')
        _require('shape_bounds' not in cut, 'fixed-shape bounds are not projected moment cuts')
        u = cut.get('unconditional_coefficients')
        _require(isinstance(u, list) and len(u) == 10, 'projected cut requires ten unconditional coefficients')
        for value in u:
            _integer(value, 'unconditional coefficient')
        coefficients = cut.get('anchor_coefficients')
        _require(isinstance(coefficients, list) and len(coefficients) == len(anchors), 'anchor coefficient count mismatch')
        for coefficients_row in coefficients:
            _require(isinstance(coefficients_row, list) and len(coefficients_row) == 17,
                     'each anchor requires seventeen coefficients')
            for value in coefficients_row:
                _integer(value, 'anchor coefficient')
        _require(isinstance(results[k], dict), 'independent cut result must be an object')
        if 'exact_violation' in cut:
            _require(Fraction(cut['exact_violation']) == Fraction(results[k].get('exact_violation', '0')),
                     'independent replay claimed exact violation mismatch')
    return o, anchors, cuts


def matrix(certificates, replays):
    """Return integer CSR matrix, integer RHS, and one metadata item per row.

    Each bank must have a matching independent PASS receipt produced by the
    whole-mask/source consumer. Rows are retained in certificate/cut order.
    """
    certificates, replays = list(certificates), list(replays)
    _require(len(certificates) == len(replays), 'certificate/replay count mismatch')
    ii, jj, vv, rhs, metadata = [], [], [], [], []
    for path, replay_path in zip(certificates, replays):
        path, replay_path = Path(path), Path(replay_path)
        digest = sha(path)
        bank, replay = json.loads(path.read_text()), json.loads(replay_path.read_text())
        orbit, anchors, cuts = _validate(bank, replay, digest)
        for cut_index, cut in enumerate(cuts):
            u = cut['unconditional_coefficients']
            terms = Counter({orbit: 16 * u[1]})
            for h in range(1, 9):
                terms[owner_coordinate('S', h, orbit, orbit)] += 16 * u[h + 1]
            for (side, anchor), coefficients in zip(anchors, cut['anchor_coefficients']):
                terms[anchor] += coefficients[0]
                for h, coefficient in enumerate(coefficients[1:]):
                    terms[owner_coordinate(side, h, anchor, orbit)] += coefficient
            terms = sorted((col, _integer(value, 'compiled coefficient')) for col, value in terms.items() if value)
            row = len(rhs)
            for col, value in terms:
                ii.append(row)
                jj.append(col)
                vv.append(value)
            rhs.append(_integer(-u[0], 'compiled RHS'))
            metadata.append({'certificate': str(path), 'certificate_sha256': digest,
                             'independent_replay': str(replay_path), 'independent_replay_sha256': sha(replay_path),
                             'cut_index': cut_index, 'orbit': orbit, 'anchors': len(anchors),
                             'nonzero_coefficients': len(terms), 'constant': u[0],
                             'inequality': 'matrix @ owner_vector <= rhs',
                             'profile_weights_fixed': False})
    result = coo_matrix((np.asarray(vv, dtype=np.int64), (ii, jj)),
                        shape=(len(rhs), VARIABLES), dtype=np.int64).tocsr()
    return result, np.asarray(rhs, dtype=np.int64), metadata
