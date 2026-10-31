#!/usr/bin/env python3
"""Independent exact two-sided basis support, source bridge and tiny controls.

Production certificates are checked without importing the producer oracle.
The consumer independently rebuilds domains and uses low-pivot GF(2) ranks
of every signed-weight prefix after joint contraction. Producer calls occur
only in explicitly labelled controls, compared with exhaustive tiny bases.
"""
from collections import Counter
from copy import deepcopy
from fractions import Fraction
from itertools import combinations, product
from pathlib import Path
import argparse
import gzip
import hashlib
import json
import random
import time

ROOT = Path(__file__).resolve().parent
FEATURES = 7211
LAYOUT = '1,P[4],PP[6lex],U[X720,Z720],P_U[4,1440].ravel(C)'
PAIRS = tuple(combinations(range(4), 2))
STATUS = {None: 'FULL_SECTOR_BASIS_DOMAIN',
          'DEPENDENT_OPPOSITE': 'EXCLUDED_DEPENDENT_OPPOSITE_ANCHORS',
          'FORCED_MULTIBIT': 'EXCLUDED_FORCED_MULTIBIT',
          'DEPENDENT_FORCED_ZERO': 'EXCLUDED_DEPENDENT_FORCED_ZERO',
          'FORCED_OWNER_COLLISION': 'EXCLUDED_FORCED_OWNER_COLLISION',
          'EMPTY_REQUIRED_OWNER': 'EXCLUDED_EMPTY_REQUIRED_OWNER',
          'DEFICIENT_ZERO_AFTER_DELETION': 'EXCLUDED_DEFICIENT_ZERO_POOL'}


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    raw = Path(path).read_bytes()
    return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)


def rational(value):
    if type(value) is int or isinstance(value, Fraction):
        return Fraction(value)
    if type(value) is str:
        result = Fraction(value)
        assert str(result) == value, 'noncanonical rational string'
        return result
    raise TypeError('exact int/Fraction/canonical rational string required')


def extend(rows, value):
    assert type(value) is int and value >= 0
    while value:
        pivot = value & -value
        if pivot in rows:
            value ^= rows[pivot]
        else:
            rows[pivot] = value
            return True
    return False


def rank(vectors):
    rows = {}
    for value in vectors:
        extend(rows, value)
    return len(rows)


def checked_indices(indices, size, length=None):
    result = tuple(indices)
    assert length is None or len(result) == length
    assert len(result) == len(set(result))
    assert all(type(i) is int and 0 <= i < size for i in result)
    return result


def sector_domain(U, V, dimension, own, selected_own, selected_opposite):
    """Build a sector from physical pairings, with independent rejection data."""
    own = checked_indices(own, len(U), 2)
    forced = checked_indices(selected_own, len(U))
    opposite = checked_indices(selected_opposite, len(V))
    assert set(forced) <= set(own)
    assert all(type(v) is int and 0 <= v < 1 << dimension for v in [*U, *V])
    absent = set(own) - set(forced)
    out = dict(feasible=False, forced=forced, absent=sorted(absent), opposite=opposite)
    opposite_rank = rank(V[j] for j in opposite)
    out['opposite_rank'] = opposite_rank
    if opposite_rank != len(opposite):
        return dict(out, reason='DEPENDENT_OPPOSITE')
    signatures = [tuple(j for j in opposite if (u & V[j]).bit_count() & 1) for u in U]
    out['signatures'] = signatures
    if any(len(signatures[i]) > 1 for i in forced):
        return dict(out, reason='FORCED_MULTIBIT')
    zero_forced = [i for i in forced if not signatures[i]]
    zero_free = [i for i in range(len(U)) if not signatures[i] and i not in own]
    out.update(zero_forced=zero_forced, zero_free=zero_free, zero_required=dimension-len(opposite))
    zero_forced_rank = rank(U[i] for i in zero_forced)
    out['zero_forced_rank'] = zero_forced_rank
    if zero_forced_rank != len(zero_forced):
        return dict(out, reason='DEPENDENT_FORCED_ZERO')
    bins = []
    for j in opposite:
        fixed = [i for i in forced if signatures[i] == (j,)]
        if len(fixed) > 1:
            return dict(out, reason='FORCED_OWNER_COLLISION')
        candidates = fixed or [i for i in range(len(U)) if signatures[i] == (j,) and i not in absent]
        if not candidates:
            return dict(out, reason='EMPTY_REQUIRED_OWNER')
        bins.append(candidates)
    out['bins'] = bins
    zero_rank = rank(U[i] for i in [*zero_forced, *zero_free])
    out['zero_rank'] = zero_rank
    assert zero_rank <= dimension-len(opposite)
    if zero_rank != dimension-len(opposite):
        return dict(out, reason='DEFICIENT_ZERO_AFTER_DELETION')
    return dict(out, feasible=True, reason=None)


def domains(X, Z, xx, zz, dimension=128):
    xx = checked_indices(xx, len(X), 2)
    zz = checked_indices(zz, len(Z), 2)
    result = []
    for mask in range(16):
        sx = [j for k, j in enumerate(xx) if mask >> k & 1]
        sz = [j for k, j in enumerate(zz) if mask >> (k+2) & 1]
        dx = sector_domain(X, Z, dimension, xx, sx, sz)
        dz = sector_domain(Z, X, dimension, zz, sz, sx)
        result.append(dict(mask=mask, X=dx, Z=dz, feasible=dx['feasible'] and dz['feasible']))
    return result


def feature(mask, X_selected, Z_selected, sizes=(720, 720)):
    assert type(mask) is int and 0 <= mask < 16
    xs = checked_indices(X_selected, sizes[0])
    zs = checked_indices(Z_selected, sizes[1])
    p = [(mask >> k) & 1 for k in range(4)]
    xset, zset = set(xs), set(zs)
    u = [int(j in xset) for j in range(sizes[0])] + [int(j in zset) for j in range(sizes[1])]
    return [1, *p, *[p[i]*p[j] for i, j in PAIRS], *u, *[bit*q for bit in p for q in u]]


def split_objective(c, mask, sizes):
    size = sum(sizes)
    assert len(c) == 11+5*size
    c = list(map(rational, c))
    bits = [(mask >> k) & 1 for k in range(4)]
    constant = c[0] + sum(c[1+k]*bits[k] for k in range(4))
    constant += sum(c[5+k]*bits[i]*bits[j] for k, (i, j) in enumerate(PAIRS))
    weights = [c[11+j]+sum(c[11+size+size*k+j]*bits[k] for k in range(4)) for j in range(size)]
    return constant, weights[:sizes[0]], weights[sizes[0]:]


def sector_upper(U, dimension, d, weights):
    """Rank-prefix bound in the matroid contracted by ALL forced zero vectors."""
    assert d['feasible'] and len(weights) == len(U)
    weights = list(map(rational, weights))
    forced = d['zero_forced']
    contracted_rank = len(forced)
    rows = {}
    for j in forced:
        assert extend(rows, U[j])
    order = sorted(d['zero_free'], key=lambda j: (-weights[j], j))
    prefix_ranks = []
    for j in order:
        extend(rows, U[j])
        prefix_ranks.append(len(rows)-contracted_rank)
    remaining_rank = d['zero_required']-contracted_rank
    assert len(rows) == d['zero_required'] and remaining_rank >= 0
    upper = sum((weights[j] for j in forced), Fraction(0))
    if order:
        upper += weights[order[-1]]*remaining_rank
        upper += sum((weights[order[t]]-weights[order[t+1]])*prefix_ranks[t] for t in range(len(order)-1))
    else:
        assert remaining_rank == 0
    upper += sum((max(weights[j] for j in b) for b in d['bins']), Fraction(0))
    return upper, len(order)


def check_sector(U, dimension, d, weights, chosen):
    assert d['feasible']
    chosen = checked_indices(chosen, len(U), dimension)
    selected = set(chosen)
    assert set(d['forced']) <= selected and not selected.intersection(d['absent'])
    assert rank(U[j] for j in chosen) == dimension, 'dependent saved physical basis'
    zero = [j for j in chosen if not d['signatures'][j]]
    assert len(zero) == d['zero_required']
    assert all(len(d['signatures'][j]) <= 1 for j in chosen)
    for opposite, bucket in zip(d['opposite'], d['bins']):
        owners = [j for j in chosen if d['signatures'][j] == (opposite,)]
        assert len(owners) == 1 and owners[0] in bucket
    upper, prefix_count = sector_upper(U, dimension, d, weights)
    value = sum((rational(weights[j]) for j in chosen), Fraction(0))
    assert value == upper, ('saved basis fails independent signed-prefix upper bound', value, upper)
    return upper, prefix_count


def check_support(X, Z, xx, zz, c, records, upper_bound=None, dimension=128):
    """Replay every pattern, exact source exclusions, and two physical maximizers."""
    dd = domains(X, Z, xx, zz, dimension)
    assert len(records) == 16 and [r['mask'] for r in records] == list(range(16))
    prefix_count = feasible = 0
    values = []
    exclusions = []
    for d, record in zip(dd, records):
        if not d['feasible']:
            assert record['status'] == 'EXCLUDED_PATTERN'
            assert record['value'] is None
            assert not record.get('X_selected') and not record.get('Z_selected')
            assert record['rejection_reasons'] == {side: STATUS[d[side]['reason']] for side in ('X', 'Z')}
            exclusions.append(dict(mask=d['mask'], X_reason=d['X']['reason'], Z_reason=d['Z']['reason']))
            continue
        assert record['value'] is not None
        assert record['status'] == 'EXACT_TWO_SIDED_PATTERN_BASIS_SUPPORT'
        kappa, wx, wz = split_objective(c, d['mask'], (len(X), len(Z)))
        xvalue, nx = check_sector(X, dimension, d['X'], wx, record['X_selected'])
        zvalue, nz = check_sector(Z, dimension, d['Z'], wz, record['Z_selected'])
        literal = feature(d['mask'], record['X_selected'], record['Z_selected'], (len(X), len(Z)))
        exact = sum((rational(a)*b for a, b in zip(c, literal)), Fraction(0))
        assert exact == kappa+xvalue+zvalue == rational(record['value'])
        assert rational(record['basis_value']) == xvalue+zvalue
        assert rational(record['pattern_constant']) == kappa
        for side, weights, value in [('X', wx, xvalue), ('Z', wz, zvalue)]:
            saved = record[side+'_support']
            chosen = record[side+'_selected']
            assert saved['status'] == 'EXACT_SECTOR_FULL_BASIS_SUPPORT'
            assert saved['selected_indices'] == chosen and rational(saved['value']) == value
            zeros = saved['zero_basis_indices']; owners = saved['owner_indices']
            assert len(zeros) == len(set(zeros)) == d[side]['zero_required']
            assert set(zeros) == {j for j in chosen if not d[side]['signatures'][j]}
            assert len(owners) == len(d[side]['bins'])
            assert all(j in b for j, b in zip(owners, d[side]['bins']))
            assert set(zeros).isdisjoint(owners) and set(zeros+owners) == set(chosen)
        prefix_count += nx+nz
        feasible += 1
        values.append(exact)
    bound = max(values) if values else None
    if upper_bound is not None:
        assert bound == rational(upper_bound), 'wrong global bound'
    return dict(upper_bound=bound, feasible_patterns=feasible, exclusions=exclusions,
                exact_signed_prefix_rank_checks=prefix_count, physical_bases_checked=2*feasible)


def coordinate(side, h, i, j):
    h %= 16
    if h > 8:
        h, i, j = 16-h, j, i
    if h in (0, 8) and i > j:
        i, j = j, i
    if side == 'S' and h == 0 and i == j:
        return i
    return 45+(0 if side == 'S' else 18225)+2025*h+45*i+j


def columns(xx, zz):
    xx = checked_indices(xx, 720, 2)
    zz = checked_indices(zz, 720, 2)
    aa = [(0, i) for i in xx]+[(1, j) for j in zz]
    full = [(side, j) for side in range(2) for j in range(720)]
    def pair(a, b):
        return coordinate('S' if a[0] == b[0] else 'T', b[1]-a[1], a[1]//16, b[1]//16)
    return [None]+[j//16 for side, j in aa]+[pair(aa[i], aa[j]) for i, j in PAIRS]+[j//16 for side, j in full]+[pair(a, u) for a in aa for u in full]


def point_owner(path):
    data = read(path)
    if 'owner_vector' in data:
        owner = list(map(rational, data['owner_vector']))
        assert len(owner) == 36495
    else:
        raw = list(map(rational, data['values']))
        cursor = 45
        owner = raw[:45]+[None]*36450
        for offset in (45, 18270):
            for h in range(9):
                for i in range(45):
                    for j in range(i if h in (0, 8) else 0, 45):
                        owner[offset+2025*h+45*i+j] = raw[cursor]
                        if h in (0, 8):
                            owner[offset+2025*h+45*j+i] = raw[cursor]
                        cursor += 1
        hull = read(ROOT/'algebraic-results/hulls-16-rank.json.gz')
        assert len(raw) == cursor+sum(len(r['shapes']) for r in hull['records'])
        assert all(v is not None for v in owner)
    for i in range(45):
        assert owner[i] == owner[45+46*i]
    for offset in (45, 18270):
        for h in (0, 8):
            assert all(owner[offset+2025*h+45*i+j] == owner[offset+2025*h+45*j+i] for i in range(45) for j in range(45))
    return owner


def target(point, xx, zz):
    owner = point_owner(point)
    return [Fraction(1) if j is None else owner[j] for j in columns(xx, zz)]


def integer_row(c, upper_bound, xx, zz):
    assert len(c) == FEATURES and all(type(v) is int for v in c)
    bound = rational(upper_bound)
    assert bound.denominator == 1
    row = Counter()
    for value, index in zip(c, columns(xx, zz)):
        if index is not None:
            row[index] += value
    row = [[index, value] for index, value in sorted(row.items()) if value]
    rhs = int(bound)-c[0]
    return row, rhs


def physical_source():
    from verify_algebraic_model import physical
    X, Z, A = physical()
    assert len(X) == len(Z) == 720 and rank(X) == rank(Z) == 128
    assert X == [int(x, 16) for x in (ROOT/'pools/xcoords.txt').read_text().split()]
    assert Z == [int(z, 16) for z in (ROOT/'pools/zcoords.txt').read_text().split()]
    rotation = [16*(i//16)+(i+1)%16 for i in range(720)]
    graphs = dict(sector_swap=rank(x | (z << 128) for x, z in zip(X, Z)),
                  X_rotation=rank(x | (X[rotation[i]] << 128) for i, x in enumerate(X)),
                  Z_rotation=rank(z | (Z[rotation[i]] << 128) for i, z in enumerate(Z)))
    assert all(value == 128 for value in graphs.values())
    for i in range(720):
        for j in range(720):
            q = (X[i] & Z[j]).bit_count() & 1
            assert q == (A[i] >> j & 1) == ((X[j] & Z[i]).bit_count() & 1)
            assert q == ((X[rotation[i]] & Z[rotation[j]]).bit_count() & 1)
    return X, Z, dict(physical_pairings_rebuilt=518400, sector_and_rotation_comparisons=1036800, graph_ranks=graphs)


def literal_mapping_controls(quads, producer=None):
    import numpy as np
    rng = random.Random(20261030)
    samples = []
    zero = np.zeros((2, 45, 16), dtype=np.int64)
    samples += [zero, np.ones_like(zero)]
    one_sector = zero.copy(); one_sector[0] = 1
    samples.append(one_sector)
    parity = zero.copy(); parity[0, :, ::2] = 1; parity[1, :, 1::2] = 1
    samples.append(parity)
    for density in (.03, .2, .5, .9):
        samples.append(np.array([int(rng.random() < density) for _ in range(1440)], dtype=np.int64).reshape(2, 45, 16))
    checked = 0
    for xx, zz in quads:
        owner_columns = columns(xx, zz)
        assert len(owner_columns) == FEATURES
        if producer is not None:
            assert list(producer.columns(xx, zz)) == owner_columns
        for raw in samples:
            accumulated = np.zeros(FEATURES, dtype=np.int64)
            moments = np.zeros(36495, dtype=np.int64)
            for swap, rotation in product(range(2), range(16)):
                x = np.roll(raw[swap], rotation, axis=1)
                z = np.roll(raw[1-swap], rotation, axis=1)
                sx = np.flatnonzero(x.ravel()).tolist(); sz = np.flatnonzero(z.ravel()).tolist()
                bits = [int(x.flat[j]) for j in xx]+[int(z.flat[j]) for j in zz]
                mask = sum(bit << k for k, bit in enumerate(bits))
                f = feature(mask, sx, sz)
                if producer is not None:
                    assert list(producer.feature(mask, sx, sz)) == f
                accumulated += f
                moments[:45] += x[:, 0]
                for h in range(9):
                    moments[45+2025*h:45+2025*(h+1)] += np.outer(x[:, 0], x[:, h]).ravel()
                    moments[18270+2025*h:18270+2025*(h+1)] += np.outer(x[:, 0], z[:, h]).ravel()
            expected = [32 if j is None else int(moments[j]) for j in owner_columns]
            assert accumulated.tolist() == expected
            checked += FEATURES
    return dict(literal_32_action_feature_equalities=checked, arbitrary_binary_selections=len(samples), quads_checked=len(quads), factor='one', self_products_and_reversed_phases_included=True)


def exhaustive_bases(U, V, dimension, own, forced, opposite):
    """Literal rank/anchor/selected-row tests; no zero/owner decomposition used."""
    answer = []
    for chosen in combinations(range(len(U)), dimension):
        chosen_set = set(chosen)
        if any((j in chosen_set) != (j in forced) for j in own):
            continue
        if rank(U[j] for j in chosen) != dimension:
            continue
        pairings = [[(U[i] & V[j]).bit_count() & 1 for i in chosen] for j in opposite]
        if any(sum(row) != 1 for row in pairings):
            continue
        if any(sum(pairings[k][t] for k in range(len(opposite))) > 1 for t in range(dimension)):
            continue
        answer.append(chosen)
    return answer


def expect_rejection(call, label):
    try:
        call()
    except (AssertionError, TypeError, ValueError, IndexError):
        return label
    raise AssertionError(('corrupt control accepted', label))


def tiny_controls(producer):
    full = list(range(1, 8))
    fixtures = [
        ('full', full, full, [0, 1], [2, 3], None),
        ('dependent_opposite', full, [1, 1, 2, 4, 3, 5, 6, 7], [0, 1], [0, 1], (12, 'X', 'DEPENDENT_OPPOSITE')),
        ('dependent_forced_zero', [1, 1, 2, 4, 3, 5, 6, 7], full, [0, 1], [1, 2], (3, 'X', 'DEPENDENT_FORCED_ZERO')),
        ('owner_collision', full, full, [0, 2], [0, 1], (7, 'X', 'FORCED_OWNER_COLLISION')),
        ('multibit', full, full, [2, 3], [0, 1], (13, 'X', 'FORCED_MULTIBIT')),
        ('empty_owner', [2, 4, 6], full, [0, 1], [0, 1], (4, 'X', 'EMPTY_REQUIRED_OWNER')),
        ('deletion_rank', [1, 2, 4], full, [0, 1], [0, 1], (0, 'X', 'DEFICIENT_ZERO_AFTER_DELETION')),
        ('zero_vector', [0, *full], full, [0, 1], [1, 2], (1, 'X', 'DEPENDENT_FORCED_ZERO')),
    ]
    cases = pairs_checked = prefix = physical = 0
    exclusions = Counter(); mandatory = []; zero_forced_sizes = set()
    corruptions = []
    for name, X, Z, xx, zz, explicit in fixtures:
        oracle = producer.TwoSidedFullBasisOracle(X, Z, 3)
        pd = oracle.prepare(xx, zz)
        dd = domains(X, Z, xx, zz, 3)
        if explicit:
            mask, side, reason = explicit
            assert dd[mask][side]['reason'] == reason
            mandatory.append(dict(name=name, mask=mask, side=side, reason=reason))
        size = len(X)+len(Z)
        coefficients = [[0]*(11+5*size), [0]*11+[-j-1 for j in range(size)]+[0]*(4*size),
                        [((k*7+3) % 9)-4 for k in range(11+5*size)],
                        [Fraction((-1)**k*((k % 5)+1), 3) for k in range(11+5*size)]]
        possibilities = []
        for m in range(16):
            sx = [j for k, j in enumerate(xx) if m >> k & 1]
            sz = [j for k, j in enumerate(zz) if m >> (k+2) & 1]
            bx = exhaustive_bases(X, Z, 3, xx, sx, sz)
            bz = exhaustive_bases(Z, X, 3, zz, sz, sx)
            assert bool(bx and bz) == dd[m]['feasible']
            possibilities.append((bx, bz))
            for side in ('X', 'Z'):
                if dd[m][side]['feasible']:
                    zero_forced_sizes.add(len(dd[m][side]['zero_forced']))
                else:
                    exclusions[dd[m][side]['reason']] += 1
        for c in coefficients:
            result = oracle.support(c, pd)
            records = result['support_records']
            check = check_support(X, Z, xx, zz, c, records, result['upper_bound'], 3)
            prefix += check['exact_signed_prefix_rank_checks']; physical += check['physical_bases_checked']
            for m, (bx, bz) in enumerate(possibilities):
                values = []
                for a, b in product(bx, bz):
                    f = feature(m, a, b, (len(X), len(Z)))
                    values.append(sum((rational(v)*q for v, q in zip(c, f)), Fraction(0)))
                    pairs_checked += 1
                expected = max(values) if values else None
                actual = records[m]['value']
                assert (rational(actual) if actual is not None else None) == expected
                cases += 1
        if name == 'full':
            c = coefficients[2]
            result = oracle.support(c, pd)
            records = result['support_records']
            m = next(r['mask'] for r in records if r['value'] is not None)
            bad = deepcopy(records); bad[m]['X_selected'] = list(bad[m]['X_selected']); bad[m]['X_selected'][0] = bad[m]['X_selected'][1]
            corruptions.append(expect_rejection(lambda: check_support(X, Z, xx, zz, c, bad, result['upper_bound'], 3), 'duplicate/dependent saved basis'))
            bad_bound = rational(result['upper_bound'])+1
            corruptions.append(expect_rejection(lambda: check_support(X, Z, xx, zz, c, records, bad_bound, 3), 'corrupt global bound'))
            bad_c = list(c); bad_c[0] += 1
            corruptions.append(expect_rejection(lambda: check_support(X, Z, xx, zz, bad_c, records, result['upper_bound'], 3), 'corrupt coefficient'))
            corruptions.append(expect_rejection(lambda: oracle.support([0.0]*len(c), pd), 'float coefficients'))
            corruptions.append(expect_rejection(lambda: oracle.support(c[:-1], pd), 'wrong coefficient length'))
            corruptions.append(expect_rejection(lambda: oracle.support_pattern(pd[m], [0.0]*size), 'float weights'))
            corruptions.append(expect_rejection(lambda: oracle.support_pattern(pd[m], [0]*(size-1)), 'wrong weight length'))
            owner_tested = absent_tested = False
            for md in dd:
                if not md['feasible']:
                    continue
                dx = md['X']
                for chosen in combinations(range(len(X)), 3):
                    if rank(X[j] for j in chosen) != 3:
                        continue
                    if not absent_tested and set(chosen).intersection(dx['absent']):
                        corruptions.append(expect_rejection(lambda: check_sector(X, 3, dx, [0]*len(X), chosen), 'absent anchor in saved basis'))
                        absent_tested = True
                    states_ok = set(dx['forced']) <= set(chosen) and not set(chosen).intersection(dx['absent'])
                    owner_bad = any(sum((X[j] & Z[k]).bit_count() & 1 for j in chosen) != 1 for k in dx['opposite'])
                    if not owner_tested and states_ok and owner_bad:
                        corruptions.append(expect_rejection(lambda: check_sector(X, 3, dx, [0]*len(X), chosen), 'wrong opposite-anchor owner with full physical rank'))
                        owner_tested = True
                if owner_tested and absent_tested:
                    break
            assert owner_tested and absent_tested
    assert zero_forced_sizes == {0, 1, 2}
    return dict(exhaustive_tiny_pattern_objectives=cases, literal_feasible_basis_pairs_priced=pairs_checked,
                physical_bases_checked=physical, exact_signed_prefix_rank_checks=prefix,
                required_exclusion_fixtures=mandatory, exclusion_reason_counts=dict(exclusions),
                forced_zero_cardinalities=sorted(zero_forced_sizes), signed_negative_tied_fractional_weights=True,
                corruption_controls_rejected=corruptions)


def dependencies():
    paths = ['physical-pool-source.json', 'pools/xcoords.txt', 'pools/zcoords.txt',
             'verify_algebraic_model.py', 'verify_partial_frame.py', 'audit_pools.py',
             'algebraic-results/hulls-16-rank.json.gz', 'two_sided_full_basis_next_gate.md']
    return {path: sha(ROOT/path) for path in paths}


def replay_query_bank(path, X, Z):
    bank = read(path)
    assert bank['schema'] == 'c16-two-sided-full-basis-v1'
    assert bank['feature_layout'] == LAYOUT and bank['feature_count'] == FEATURES
    assert bank['dimension'] == 128 and bank['pool_sizes'] == [720, 720]
    assert bank['selection_patterns'] == list(range(16))
    assert all(sha(ROOT/p) == h for p, h in bank['source_hashes'].items())
    frozen_path = path.with_suffix('.frozen.json')
    frozen = read(frozen_path)
    assert bank['frozen_sha256'] == sha(frozen_path)
    for key in ('schema', 'feature_layout', 'feature_count', 'dimension', 'pool_sizes', 'selection_patterns', 'source_hashes'):
        assert bank[key] == frozen[key]
    expected = [(q['X_anchors'], q['Z_anchors'], c['label'], c['coefficients']) for q in frozen['quads'] for c in frozen['cohorts']]
    assert len(expected) == len(bank['queries'])
    results = []
    for q, (xx, zz, label, c) in zip(bank['queries'], expected):
        assert (q['X_anchors'], q['Z_anchors'], q['label'], q['coefficients']) == (xx, zz, label, c)
        check = check_support(X, Z, xx, zz, c, q['support_records'], q['upper_bound'])
        check['upper_bound'] = str(check['upper_bound'])
        results.append(dict(label=label, X_anchors=xx, Z_anchors=zz, **check))
    return dict(bank_sha256=sha(path), frozen_sha256=sha(frozen_path), queries_checked=len(results), results=results)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--controls', action='store_true')
    ap.add_argument('--bank', type=Path)
    ap.add_argument('--point', type=Path)
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    assert not args.output.exists()
    start = time.monotonic(); source_hashes = dependencies()
    X, Z, physical_checks = physical_source()
    quads = [([80, 512], [186, 433]), ([80, 432], [186, 514])]
    if args.controls:
        import two_sided_full_basis_oracle as producer
        producer_hash = sha(ROOT/'two_sided_full_basis_oracle.py')
        tiny = tiny_controls(producer)
        mapping = literal_mapping_controls(quads, producer)
        prefix = physical_bases = 0; result_rows = []
        for xx, zz in quads:
            oracle = producer.TwoSidedFullBasisOracle(); pd = oracle.prepare(xx, zz)
            weight_sets = [[0]*FEATURES, [0]*11+[-1-j%7 for j in range(1440)]+[0]*5760,
                           [(k*11+7)%19-9 for k in range(FEATURES)],
                           [Fraction((-1)**k*(k%11), 5) for k in range(FEATURES)]]
            for c in weight_sets:
                result = oracle.support(c, pd)
                check = check_support(X, Z, xx, zz, c, result['support_records'], result['upper_bound'])
                prefix += check['exact_signed_prefix_rank_checks']; physical_bases += check['physical_bases_checked']
                result_rows.append(dict(X_anchors=xx, Z_anchors=zz, feasible_patterns=check['feasible_patterns'], exclusions=check['exclusions'], upper_bound=str(check['upper_bound'])))
            if args.point:
                assert list(producer.target(args.point, xx, zz)) == target(args.point, xx, zz)
        assert sha(ROOT/'two_sided_full_basis_oracle.py') == producer_hash
        out = dict(status='PASS', proof_kind='two_sided_full_basis_shared_2X2Z_pattern_controls',
                   producer_sha256=producer_hash, tiny_exhaustive_controls=tiny, literal_mapping_controls=mapping,
                   physical_signed_support_queries=len(result_rows), physical_support_results=result_rows,
                   exact_signed_prefix_rank_checks=prefix, physical_bases_checked=physical_bases)
        if args.bank:
            out['saved_query_bank_replay'] = replay_query_bank(args.bank, X, Z)
    else:
        assert args.bank and args.point
        bank = read(args.bank)
        assert bank['point_sha256'] == sha(args.point)
        assert bank['feature_layout'] == LAYOUT and bank['selection_patterns'] == list(range(16))
        assert all(sha(ROOT/path) == value for path, value in bank['source_hashes'].items())
        assert bank['schema'] == 'c16-two-sided-full-basis-v1'
        assert bank['dimension'] == 128 and bank['pool_sizes'] == [720, 720] and bank['feature_count'] == FEATURES
        owner = point_owner(args.point); results = []
        for cut in bank['cuts']:
            xx, zz = cut['X_anchors'], cut['Z_anchors']
            tar = target(args.point, xx, zz)
            c = cut['coefficients']
            assert len(c) == FEATURES and all(type(v) is int for v in c)
            check = check_support(X, Z, xx, zz, c, cut['support_records'], cut['upper_bound'])
            bound = check.pop('upper_bound')
            value = sum((v*t for v, t in zip(c, tar)), Fraction(0)); gap = value-bound
            assert gap > 0 and rational(cut['exact_target_value']) == value and rational(cut['exact_violation']) == gap
            row, rhs = integer_row(c, bound, xx, zz)
            assert cut['owner_row_terms'] == row and cut['rhs'] == rhs
            assert sum((v*owner[j] for j, v in row), Fraction(0))-rhs == gap
            results.append(dict(**check, exact_violation=str(gap), exact_target_value=str(value), upper_bound=str(bound), owner_row_terms=row, rhs=rhs,
                                int64_export_safe=all(-(1<<63) <= v < 1<<63 for j, v in row) and -(1<<63) <= rhs < 1<<63))
        out = dict(status='PASS' if results else 'NO_ACCEPTED_CUT_NUMERICAL_STATUS_ONLY', proof_kind='two_sided_full_basis_shared_2X2Z_pattern',
                   bank_sha256=sha(args.bank), point_sha256=sha(args.point), cuts_checked=len(results), results=results,
                   profile_weights_fixed_in_separation=False, unanchored_mutual_pairing_enforced=False)
    assert source_hashes == dependencies()
    out.update(source_C16_answered=False, consumer_sha256=sha(__file__), source_hashes=source_hashes,
               physical_symmetry_bridge=physical_checks, elapsed_seconds=time.monotonic()-start,
               scope='Two physical full bases with selected/deleted 2X+2Z anchors and exact opposite-anchor owner constraints. Unanchored mutual X/Z pairing is relaxed. No source frame, cover-case exclusion or target convex membership is claimed.')
    if args.point:
        out['point_sha256'] = sha(args.point)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(out, indent=2)+'\n')
    print(json.dumps({k: v for k, v in out.items() if k not in ('results', 'physical_support_results')}, indent=2), flush=True)


if __name__ == '__main__':
    main()
