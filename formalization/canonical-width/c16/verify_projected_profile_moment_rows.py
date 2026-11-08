#!/usr/bin/env python3
"""Exact projected-row translation consumer; no optimization is performed.

Literal controls average arbitrary binary X/Z selections over all 16 rotations
and both sector choices. They test the translation, not physical feasibility.
The independent source certificate remains verify_common_profile_cut.py's bank
receipt. Point evaluation here checks only these rows and required identities.
"""
import argparse
from collections import Counter
from copy import deepcopy
from fractions import Fraction
import gzip
import hashlib
import json
from pathlib import Path
import time

import numpy as np
from projected_profile_moment_matrix import matrix, owner_coordinate, _validate

ROOT = Path(__file__).resolve().parent
N = 45 + 18 * 45 * 45
BASE = ROOT / 'moment-resumption-results'


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    raw = Path(path).read_bytes()
    return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)


def check(condition, message):
    if not condition:
        raise ValueError(message)


def decode(column):
    """Decode actual stored owner columns without the compiler's folding code."""
    if column < 45:
        return ('p', column)
    sector, rem = divmod(column - 45, 9 * 2025)
    h, rem = divmod(rem, 2025)
    i, j = divmod(rem, 45)
    return ('ST'[sector], h, i, j)


def point_vector(path):
    data = read(path)
    if 'owner_vector' in data:
        values = list(map(Fraction, data['owner_vector']))
        check(len(values) == N, 'owner_vector length mismatch')
    else:
        # Independently reconstruct the compact rational certificate's ordering.
        compact = list(map(Fraction, data['values']))
        named = {}
        cursor = 0
        for i in range(45):
            named['p', i] = compact[cursor]
            cursor += 1
        for side in 'ST':
            for h in range(9):
                for i in range(45):
                    for j in range(i if h in (0, 8) else 0, 45):
                        named[side, h, i, j] = compact[cursor]
                        cursor += 1
        hulls = read(ROOT / 'algebraic-results/hulls-16-rank.json.gz')
        check(len(compact) == cursor + sum(len(r['shapes']) for r in hulls['records']),
              'compact point length mismatch')
        values = []
        for col in range(N):
            key = decode(col)
            if key[0] != 'p':
                side, h, i, j = key
                if h in (0, 8) and i > j:
                    i, j = j, i
                key = side, h, i, j
            values.append(named[key])
    for i in range(45):
        check(values[i] == values[45 + 45 * i + i], 'point violates S0 diagonal Boolean identity')
    for side_offset in (45, 45 + 9 * 2025):
        for h in (0, 8):
            for i in range(45):
                for j in range(i):
                    check(values[side_offset + 2025 * h + 45 * i + j] ==
                          values[side_offset + 2025 * h + 45 * j + i],
                          'point violates phase 0/8 symmetry')
    return values


def row_residuals(compiled, rhs, values):
    result = []
    for row in range(compiled.shape[0]):
        start, stop = compiled.indptr[row:row + 2]
        result.append(sum((int(c) * (int(values[int(j)]) if isinstance(values[int(j)], np.integer) else values[int(j)]) for j, c in
                           zip(compiled.indices[start:stop], compiled.data[start:stop])), Fraction(0)) - int(rhs[row]))
    return result


def empirical_counts(X, Z):
    """Actual sum of the 32 transformed owner vectors, with no phase folding."""
    counts = np.zeros(N, dtype=np.int64)
    for first, second in ((X, Z), (Z, X)):
        for rotation in range(16):
            anchor = first[:, rotation]
            counts[:45] += anchor
            for h in range(9):
                counts[45 + 2025 * h:45 + 2025 * (h + 1)] += np.outer(
                    anchor, first[:, (h + rotation) % 16]).ravel(order='C')
                offset = 45 + 9 * 2025 + 2025 * h
                counts[offset:offset + 2025] += np.outer(
                    anchor, second[:, (h + rotation) % 16]).ravel(order='C')
    return counts


def literal_sum(bank, cut, X, Z):
    """Evaluate the unfurled mask functional on each action, using raw phases."""
    total = 0
    orbit = bank['orbit']
    u = cut['unconditional_coefficients']
    for primary, opposite in ((X, Z), (Z, X)):
        for rotation in range(16):
            bits = [int(primary[orbit, (rotation + h) % 16]) for h in range(16)]
            value = u[0] + u[1] * sum(bits)
            for h in range(1, 9):
                value += u[h + 1] * sum(bits[t] * bits[(t + h) % 16] for t in range(16))
            for (side, anchor), c in zip(bank['anchors'], cut['anchor_coefficients']):
                indicator = int((primary if side == 'S' else opposite)[anchor, rotation])
                value += indicator * (c[0] + sum(c[h + 1] * bits[h] for h in range(16)))
            total += value
    return total


def generated_selections(count, seed):
    check(count >= 8, 'at least eight generated translation controls are required')
    zero, one = np.zeros((45, 16), dtype=np.int64), np.ones((45, 16), dtype=np.int64)
    even = np.tile(np.arange(16) % 2, (45, 1)).astype(np.int64)
    orbit = zero.copy()
    orbit[32] = 1
    fixed = [('empty', zero, zero), ('full', one, one), ('X-only', one, zero),
             ('Z-only', zero, one), ('opposite-parity', even, 1 - even),
             ('same-parity', even, even), ('orbit32-X-only', orbit, zero),
             ('orbit32-both', orbit, orbit)]
    yield from fixed
    rng = np.random.default_rng(seed)
    probabilities = (.03, .1, .25, .5, .75, .9)
    for k in range(count - len(fixed)):
        probability = probabilities[k % len(probabilities)]
        yield (f'random-{k}-density-{probability}', (rng.random((45, 16)) < probability).astype(np.int64),
               (rng.random((45, 16)) < probability).astype(np.int64))


def custom_selections(path):
    data = read(path)
    entries = data['selections'] if isinstance(data, dict) else data
    check(isinstance(entries, list), 'selection file must contain a list')
    for k, entry in enumerate(entries):
        arrays = []
        for side in ('X', 'Z'):
            array = np.asarray(entry[side])
            check(array.shape in ((720,), (45, 16)), f'{side} must have 720 bits or shape 45 by 16')
            check(array.dtype.kind in 'biu' and np.all((array == 0) | (array == 1)), 'selections must be binary integers')
            arrays.append(array.astype(np.int64).reshape(45, 16))
        yield entry.get('name', f'custom-{k}'), *arrays


def reference_check(path, compiled, rhs, metadata):
    reference = read(path)
    check(compiled.shape[0] == 1, 'standalone saved-row comparison requires exactly one row')
    check(reference.get('status') == 'PASS', 'saved row reference must have status PASS')
    check(reference['scientific_bank_sha256'] == metadata[0]['certificate_sha256'], 'reference source bank SHA mismatch')
    expected = Counter()
    for term in reference['coefficients']:
        expected[tuple(term['coordinate'])] += term['coefficient']
    expected = {k: v for k, v in expected.items() if v}
    actual = {decode(int(j)): int(v) for j, v in zip(compiled.indices, compiled.data)}
    check(actual == expected, 'full saved coefficient-row comparison failed')
    check(-int(rhs[0]) == reference['constant'], 'saved coefficient-row constant mismatch')
    check(len(actual) == reference['nonzero_moment_coefficients'], 'saved coefficient count mismatch')
    return {'sha256': sha(path), 'all_coefficients_agree': True,
            'nonzero_coefficients': len(actual), 'constant': -int(rhs[0])}


def negative_controls(bank_path, replay_path):
    bank, replay = read(bank_path), read(replay_path)
    digest = sha(bank_path)
    tests = []

    def reject(name, change_bank=None, change_replay=None, rebind=False):
        b, r = deepcopy(bank), deepcopy(replay)
        if change_bank:
            change_bank(b)
        if change_replay:
            change_replay(r)
        d = digest
        if change_bank:
            d = hashlib.sha256(json.dumps(b, sort_keys=True).encode()).hexdigest()
            if rebind:
                # In-memory schema fixture only; never exported as a source receipt.
                r['bank_sha256'] = d
        try:
            _validate(b, r, d)
        except (ValueError, TypeError, KeyError) as error:
            tests.append({'case': name, 'rejected': True, 'reason': str(error)})
        else:
            raise ValueError(f'negative input control was accepted: {name}')

    reject('stale-source-bank-hash', lambda b: b['cuts'][0]['unconditional_coefficients'].__setitem__(0, -2))
    reject('non-PASS-receipt', change_replay=lambda r: r.__setitem__('status', 'UNKNOWN'))
    reject('wrong-source-bank-hash', change_replay=lambda r: r.__setitem__('bank_sha256', '0' * 64))
    reject('wrong-cut-count', change_replay=lambda r: r.__setitem__('cuts_checked', len(bank['cuts']) + 1))
    reject('fixed-weight-receipt', change_replay=lambda r: r.__setitem__('profile_weights_fixed_in_separation', True))
    reject('fixed-weight-bank-format', lambda b: b.__setitem__('profile_weights_free', False), rebind=True)
    reject('shape-bounds-in-projected-cut', lambda b: b['cuts'][0].__setitem__('shape_bounds', [0]), rebind=True)
    reject('short-unconditional-vector', lambda b: b['cuts'][0]['unconditional_coefficients'].pop(), rebind=True)
    reject('short-anchor-vector', lambda b: b['cuts'][0]['anchor_coefficients'][0].pop(), rebind=True)
    reject('float-coefficient', lambda b: b['cuts'][0]['unconditional_coefficients'].__setitem__(0, -1.0), rebind=True)
    reject('invalid-anchor-sector', lambda b: b['anchors'][0].__setitem__(0, 'X'), rebind=True)
    reject('invalid-anchor-orbit', lambda b: b['anchors'][0].__setitem__(1, 45), rebind=True)
    reject('unsafe-integer', lambda b: b['cuts'][0]['unconditional_coefficients'].__setitem__(0, 1 << 70), rebind=True)
    reject('false-claimed-violation', lambda b: b['cuts'][0].__setitem__('exact_violation', '1'), rebind=True)
    return tests



def translation_mutation_controls(compiled, rhs, rows, selections):
    """Require the literal consumer to detect deliberate compiler-output errors."""
    fixtures = []
    changed = compiled.copy()
    changed.data[0] += 1
    fixtures.append(('changed-row-coefficient', changed, rhs))
    fixtures.append(('changed-RHS-sign', compiled, -rhs if any(rhs) else rhs + 1))
    for offset, column in enumerate(compiled.indices[:compiled.indptr[1]]):
        key = decode(int(column))
        if key[0] in ('S', 'T') and 0 < key[1] < 8 and key[2] != key[3]:
            side, h, i, j = key
            wrong_column = 45 + (0 if side == 'S' else 9 * 2025) + h * 2025 + 45 * j + i
            changed = compiled.tolil(copy=True)
            coefficient = int(compiled.data[offset])
            changed[0, int(column)] = 0
            changed[0, wrong_column] += coefficient
            fixtures.append(('wrong-phase-transpose', changed.tocsr(), rhs))
            break
    for offset, column in enumerate(compiled.indices[:compiled.indptr[1]]):
        if column < 45:
            changed = compiled.tolil(copy=True)
            coefficient = int(compiled.data[offset])
            changed[0, int(column)] = 0
            changed[0, 45 + 9 * 2025 + 46 * int(column)] += coefficient
            fixtures.append(('cross-sector-diagonal-confused-with-marginal', changed.tocsr(), rhs))
            break
    result = []
    for name, changed, changed_rhs in fixtures:
        rejected_by = None
        for selection_name, X, Z in selections:
            observed = row_residuals(changed, [32 * int(r) for r in changed_rhs], empirical_counts(X, Z))
            expected = [literal_sum(bank, cut, X, Z) for bank, cut in rows]
            if observed != expected:
                rejected_by = selection_name
                break
        check(rejected_by is not None, f'literal controls failed to detect translation mutation: {name}')
        result.append({'case': name, 'rejected': True, 'detected_by': rejected_by})
    return result


def alias_controls():
    checks = 0
    for side in 'ST':
        for i in range(45):
            for j in range(45):
                for h in range(1, 8):
                    check(owner_coordinate(side, 16 - h, i, j) == owner_coordinate(side, h, j, i), 'transpose alias failed')
                    checks += 1
                for h in (0, 8):
                    check(owner_coordinate(side, h, i, j) == owner_coordinate(side, h, j, i), 'symmetric alias failed')
                    checks += 1
            check(owner_coordinate('S', 0, i, i) == i, 'same-event diagonal must reduce to p')
            check(owner_coordinate('T', 0, i, i) != i, 'cross-sector diagonal must remain a pair moment')
            checks += 2
    return checks


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--banks', '--bank', type=Path, nargs='+', default=[BASE / 'common-profile32-projected-pruned.json'])
    ap.add_argument('--replays', '--replay', type=Path, nargs='+', default=[BASE / 'common-profile32-projected-pruned-independent.json'])
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--reference-row', type=Path)
    ap.add_argument('--expect-violation', type=Fraction)
    ap.add_argument('--require-feasible', action='store_true')
    ap.add_argument('--controls', type=int, default=48)
    ap.add_argument('--seed', type=int, default=20261030)
    ap.add_argument('--selections', type=Path, help='Optional JSON list of arbitrary binary X/Z selections')
    ap.add_argument('--output', type=Path, required=True)
    a = ap.parse_args()
    start = time.monotonic()
    compiled, rhs, metadata = matrix(a.banks, a.replays)
    values = point_vector(a.point)
    residuals = row_residuals(compiled, rhs, values)
    check(compiled.shape[0] > 0, 'no projected rows were compiled')
    if a.expect_violation is not None:
        check(max(residuals) == a.expect_violation, 'expected exact violation mismatch')
    if a.require_feasible:
        check(all(r <= 0 for r in residuals), 'rational point violates a projected row')
    banks = [read(path) for path in a.banks]
    rows = [(bank, cut) for bank in banks for cut in bank['cuts']]
    baseline_claims = []
    for bank in banks:
        if bank.get('point_sha256') == sha(a.point):
            baseline_claims.extend(Fraction(c['exact_violation']) if 'exact_violation' in c else None for c in bank['cuts'])
        else:
            baseline_claims.extend([None] * len(bank['cuts']))
    for row, claim in enumerate(baseline_claims):
        if claim is not None:
            check(residuals[row] == claim, 'source-bank baseline exact residual mismatch')
    selections = list(generated_selections(a.controls, a.seed))
    if a.selections:
        selections.extend(custom_selections(a.selections))
    controls = []
    for name, X, Z in selections:
        counts = empirical_counts(X, Z)
        compiled_sums = row_residuals(compiled, [32 * int(r) for r in rhs], counts)
        literal = [literal_sum(bank, cut, X, Z) for bank, cut in rows]
        check(compiled_sums == literal, f'literal 32-action translation failed for {name}')
        controls.append({'name': name, 'action_count': 32,
                         'exact_residuals': [str(Fraction(int(r), 32)) for r in literal]})
    reference = reference_check(a.reference_row, compiled, rhs, metadata) if a.reference_row else None
    result = {'status': 'PASS', 'source_C16_answered': False,
              'scope': 'Projected row translation and exact row evaluation only. Arbitrary binary selections are translation controls, not source frames. This receipt does not establish point feasibility or source infeasibility.',
              'matrix_shape': list(compiled.shape), 'matrix_nonzeros': compiled.nnz,
              'matrix_dtype': str(compiled.dtype), 'rhs': rhs.tolist(), 'row_metadata': metadata,
              'point_sha256': sha(a.point), 'exact_residuals_lhs_minus_rhs': list(map(str, residuals)),
              'exact_slacks_rhs_minus_lhs': [str(-r) for r in residuals],
              'all_projected_rows_satisfied': all(r <= 0 for r in residuals),
              'baseline_claims_checked': sum(c is not None for c in baseline_claims),
              'saved_reference_row': reference, 'literal32_action_controls': controls,
              'literal32_action_control_count': len(controls), 'alias_identity_checks': alias_controls(),
              'rejected_corrupted_input_controls': negative_controls(a.banks[0], a.replays[0]),
              'rejected_translation_mutations': translation_mutation_controls(compiled, rhs, rows, selections),
              'source_hashes': {name: sha(ROOT / name) for name in
                                ('projected_profile_moment_matrix.py', 'verify_projected_profile_moment_rows.py')},
              'elapsed_seconds': time.monotonic() - start}
    a.output.parent.mkdir(parents=True, exist_ok=True)
    a.output.write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({k: result[k] for k in ('status', 'matrix_shape', 'matrix_nonzeros',
          'exact_residuals_lhs_minus_rhs', 'literal32_action_control_count', 'alias_identity_checks', 'elapsed_seconds')}, indent=2))


if __name__ == '__main__':
    main()
