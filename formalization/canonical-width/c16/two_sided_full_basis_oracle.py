#!/usr/bin/env python3
"""Exact signed support for two physical bases sharing a 2X+2Z pattern.

All sixteen patterns are retained.  Each sector is a full basis, contains its
selected anchors, deletes its absent anchors, and gives each selected opposite
anchor exactly one owner.  Pairings between unanchored X and Z are relaxed.
The zero matroid is contracted by ALL forced zero anchors jointly.

This producer supplies candidates only.  Source acceptance belongs to the
separate independent consumer; neither numerical no-separation nor an auxiliary
basis pair is a physical dual-frame certificate.
"""
from collections import Counter
from fractions import Fraction
from itertools import combinations
from numbers import Integral
from pathlib import Path
import argparse
import hashlib
import json
import math
import time

ROOT = Path(__file__).resolve().parent
N = 7211
OWNER_N = 36495
PAIRS = tuple(combinations(range(4), 2))
LAYOUT = '1,P[4],PP[6lex],U[X720,Z720],P_U[4,1440].ravel(C)'
SCHEMA = 'c16-two-sided-full-basis-v1'
DOMAIN_OK = 'FULL_TWO_SIDED_BASIS_DOMAIN'
SIDE_OK = 'FULL_SECTOR_BASIS_DOMAIN'


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def exact(value):
    """Reject floating discovery numbers at the exact support boundary."""
    if isinstance(value, bool):
        raise TypeError('Boolean is not an exact support coefficient')
    if isinstance(value, Integral):
        return int(value)
    if isinstance(value, Fraction):
        return value
    raise TypeError('exact integer/Fraction coefficients required')


def exact_list(values, size):
    if len(values) != size:
        raise ValueError(f'expected {size} exact coefficients')
    return [exact(v) for v in values]


def add_vector(pivots, vector):
    while vector:
        pivot = vector.bit_length() - 1
        if pivot in pivots:
            vector ^= pivots[pivot]
        else:
            pivots[pivot] = vector
            return True
    return False


def rank(vectors):
    pivots = {}
    for vector in vectors:
        add_vector(pivots, vector)
    return len(pivots)


def anchors(X_anchors, Z_anchors, pool_sizes=(720, 720)):
    out = []
    for selected, size in zip((X_anchors, Z_anchors), pool_sizes):
        selected = tuple(selected)
        if len(selected) != 2 or len(set(selected)) != 2:
            raise ValueError('exactly two distinct anchor indices per sector')
        if any(type(j) is not int or not 0 <= j < size for j in selected):
            raise ValueError('anchor index outside physical pool')
        out.append(selected)
    return tuple(out)


def pattern_bits(mask):
    if type(mask) is not int or not 0 <= mask < 16:
        raise ValueError('four-bit pattern required')
    return [(mask >> i) & 1 for i in range(4)]


def feature(mask, X_selected, Z_selected, pool_sizes=(720, 720)):
    """Literal (not phase-summed) features; arbitrary tiny pool sizes allowed."""
    bits = pattern_bits(mask)
    chosen = []
    for selected, size in zip((X_selected, Z_selected), pool_sizes):
        selected = tuple(selected)
        if len(selected) != len(set(selected)) or any(type(j) is not int or not 0 <= j < size for j in selected):
            raise ValueError('invalid selected physical indices')
        selected_set = set(selected)
        chosen.extend(int(j in selected_set) for j in range(size))
    return [1, *bits, *[bits[i] * bits[j] for i, j in PAIRS],
            *chosen, *[bit * value for bit in bits for value in chosen]]


def columns(X_anchors, Z_anchors):
    """Literal factor-one map into p45 + S[0..8] + T[0..8]."""
    from projected_profile_moment_matrix import owner_coordinate
    xx, zz = anchors(X_anchors, Z_anchors)
    aa = [(0, j) for j in xx] + [(1, j) for j in zz]
    full = [(side, j) for side in range(2) for j in range(720)]

    def pair(a, b):
        kind = 'S' if a[0] == b[0] else 'T'
        return owner_coordinate(kind, (b[1] - a[1]) % 16,
                                a[1] // 16, b[1] // 16)

    out = [None, *[j // 16 for _, j in aa],
           *[pair(aa[i], aa[j]) for i, j in PAIRS],
           *[j // 16 for _, j in full],
           *[pair(a, u) for a in aa for u in full]]
    assert len(out) == N and all(j is None or 0 <= j < OWNER_N for j in out)
    return out


def target(point, X_anchors, Z_anchors):
    from verify_projected_profile_moment_rows import point_vector
    owner = point_vector(Path(point))
    return [Fraction(1) if j is None else owner[j]
            for j in columns(X_anchors, Z_anchors)]


def compile_row(coefficients, bound, X_anchors, Z_anchors):
    """Exact integer owner row; range guards precede any downstream int64 cast."""
    c = exact_list(coefficients, N)
    bound = exact(bound)
    if any(Fraction(v).denominator != 1 for v in [*c, bound]):
        raise TypeError('clear rational denominators before integer row export')
    c = list(map(int, c))
    row = Counter()
    for value, j in zip(c, columns(X_anchors, Z_anchors)):
        if j is not None:
            row[j] += value
    row = dict(sorted((j, value) for j, value in row.items() if value))
    rhs = int(bound) - c[0]
    if any(not -(1 << 63) <= value < (1 << 63) for value in [*row.values(), rhs]):
        raise OverflowError('owner row exceeds signed int64 range')
    return row, rhs


def integer_direction(coefficients):
    """Clear rational denominators and positive common gcd without sign flip."""
    c = exact_list(coefficients, N)
    denominator = math.lcm(*(Fraction(v).denominator for v in c))
    out = [int(Fraction(v) * denominator) for v in c]
    divisor = math.gcd(*out)
    return [v // divisor for v in out] if divisor else out


class TwoSidedFullBasisOracle:
    def __init__(self, X_pool=None, Z_pool=None, dimension=128, root=ROOT):
        if type(dimension) is not int or dimension <= 0:
            raise ValueError('positive integer ambient dimension required')
        if (X_pool is None) != (Z_pool is None):
            raise ValueError('supply both pools or neither')
        if X_pool is None:
            X_pool, Z_pool = [[int(v, 16) for v in (Path(root) / f'pools/{s}coords.txt').read_text().split()]
                              for s in 'xz']
        self.dimension = dimension
        self.X, self.Z = tuple(X_pool), tuple(Z_pool)
        for pool in (self.X, self.Z):
            if any(type(v) is not int or not 0 <= v < (1 << dimension) for v in pool):
                raise ValueError('pool coordinates must be nonnegative in-range integers')
        self.pool_sizes = (len(self.X), len(self.Z))
        self.feature_count = 11 + 5 * sum(self.pool_sizes)
        self._domains = {}

    def _sector(self, side, own_anchors, forced, opposite_selected):
        U, V = (self.X, self.Z) if side == 'X' else (self.Z, self.X)
        forced = tuple(forced)
        opposite_selected = tuple(opposite_selected)
        absent = tuple(j for j in own_anchors if j not in forced)
        k = len(opposite_selected)
        d = dict(side=side, dimension=self.dimension, pool_size=len(U),
                 selected_anchor_indices=list(forced), absent_anchor_indices=list(absent),
                 opposite_selected_indices=list(opposite_selected),
                 opposite_rank=rank(V[j] for j in opposite_selected),
                 zero_basis_required=self.dimension - k,
                 forced_zero_indices=[], zero_free_indices=[], owner_bins=[])
        if d['opposite_rank'] != k:
            return dict(d, status='EXCLUDED_DEPENDENT_OPPOSITE_ANCHORS')
        signature = [sum(((u & V[j]).bit_count() % 2) << h
                         for h, j in enumerate(opposite_selected)) for u in U]
        multibit = [j for j in forced if signature[j] & (signature[j] - 1)]
        if multibit:
            return dict(d, status='EXCLUDED_FORCED_MULTIBIT', witness_indices=multibit)
        fixed_zero = [j for j in forced if not signature[j]]
        zero_free = [j for j, s in enumerate(signature) if not s and j not in own_anchors]
        d.update(forced_zero_indices=fixed_zero, zero_free_indices=zero_free,
                 forced_zero_rank=rank(U[j] for j in fixed_zero),
                 zero_pool_rank=rank(U[j] for j in [*fixed_zero, *zero_free]))
        if d['forced_zero_rank'] != len(fixed_zero):
            return dict(d, status='EXCLUDED_DEPENDENT_FORCED_ZERO')
        assert d['zero_pool_rank'] <= self.dimension - k
        for h, opposite_anchor in enumerate(opposite_selected):
            fixed_owner = [j for j in forced if signature[j] == (1 << h)]
            if len(fixed_owner) > 1:
                return dict(d, status='EXCLUDED_FORCED_OWNER_COLLISION',
                            witness_indices=fixed_owner, witness_owner=opposite_anchor)
            choices = fixed_owner or [j for j, s in enumerate(signature)
                                      if s == (1 << h) and j not in own_anchors]
            d['owner_bins'].append(dict(opposite_anchor_index=opposite_anchor,
                                        forced_index=fixed_owner[0] if fixed_owner else None,
                                        candidate_indices=choices))
            if not choices:
                return dict(d, status='EXCLUDED_EMPTY_REQUIRED_OWNER', witness_owner=opposite_anchor)
        if d['zero_pool_rank'] != self.dimension - k:
            return dict(d, status='EXCLUDED_DEFICIENT_ZERO_POOL')
        return dict(d, status=SIDE_OK)

    def prepare(self, X_anchors, Z_anchors):
        xx, zz = anchors(X_anchors, Z_anchors, self.pool_sizes)
        key = xx, zz
        if key not in self._domains:
            domains = []
            for mask in range(16):
                bits = pattern_bits(mask)
                selected_X = [j for h, j in enumerate(xx) if bits[h]]
                selected_Z = [j for h, j in enumerate(zz) if bits[2 + h]]
                dx = self._sector('X', xx, selected_X, selected_Z)
                dz = self._sector('Z', zz, selected_Z, selected_X)
                feasible = dx['status'] == dz['status'] == SIDE_OK
                domains.append(dict(mask=mask, status=DOMAIN_OK if feasible else 'EXCLUDED_PATTERN',
                                    X_anchors=list(xx), Z_anchors=list(zz), X=dx, Z=dz))
            self._domains[key] = tuple(domains)
        return self._domains[key]

    def _sector_support(self, domain, weights):
        if domain['status'] != SIDE_OK:
            return dict(status=domain['status'], value=None, selected_indices=[])
        U = self.X if domain['side'] == 'X' else self.Z
        pivots = {}
        zeros = list(domain['forced_zero_indices'])
        for j in zeros:
            assert add_vector(pivots, U[j])
        for j in sorted(domain['zero_free_indices'], key=lambda j: (-weights[j], j)):
            if len(zeros) == domain['zero_basis_required']:
                break
            if add_vector(pivots, U[j]):
                zeros.append(j)
        assert len(zeros) == domain['zero_basis_required']
        owners = [max(b['candidate_indices'], key=lambda j: (weights[j], -j))
                  for b in domain['owner_bins']]
        selected = sorted(zeros + owners)
        assert len(selected) == len(set(selected)) == self.dimension
        assert rank(U[j] for j in selected) == self.dimension
        assert set(domain['selected_anchor_indices']) <= set(selected)
        assert not set(domain['absent_anchor_indices']) & set(selected)
        return dict(status='EXACT_SECTOR_FULL_BASIS_SUPPORT',
                    value=Fraction(sum(weights[j] for j in selected)),
                    selected_indices=selected, zero_basis_indices=zeros, owner_indices=owners)

    def support_pattern(self, domain, weights):
        weights = exact_list(weights, sum(self.pool_sizes))
        mask = domain['mask']
        pattern_bits(mask)
        if domain['status'] != DOMAIN_OK:
            return dict(mask=mask, status='EXCLUDED_PATTERN', value=None,
                        X_selected=[], Z_selected=[],
                        rejection_reasons={'X': domain['X']['status'], 'Z': domain['Z']['status']})
        nx = self.pool_sizes[0]
        sx = self._sector_support(domain['X'], weights[:nx])
        sz = self._sector_support(domain['Z'], weights[nx:])
        return dict(mask=mask, status='EXACT_TWO_SIDED_PATTERN_BASIS_SUPPORT',
                    value=sx['value'] + sz['value'], X_selected=sx['selected_indices'],
                    Z_selected=sz['selected_indices'], X_support=sx, Z_support=sz)

    def support(self, coefficients, domains):
        c = exact_list(coefficients, self.feature_count)
        if len(domains) != 16 or [d['mask'] for d in domains] != list(range(16)):
            raise ValueError('all sixteen patterns in canonical order required')
        total_pool = sum(self.pool_sizes)
        records = []
        for domain in domains:
            bits = pattern_bits(domain['mask'])
            weights = [c[11 + j] + sum(c[11 + total_pool + total_pool * i + j]
                                       for i in range(4) if bits[i]) for j in range(total_pool)]
            result = self.support_pattern(domain, weights)
            if result['value'] is not None:
                constant = c[0] + sum(c[1 + i] * bits[i] for i in range(4))
                constant += sum(c[5 + h] * bits[i] * bits[j] for h, (i, j) in enumerate(PAIRS))
                result['pattern_constant'] = Fraction(constant)
                result['basis_value'] = result['value']
                result['value'] += constant
                actual = sum(a * b for a, b in zip(c, feature(domain['mask'], result['X_selected'],
                                                            result['Z_selected'], self.pool_sizes)))
                assert actual == result['value']
            records.append(result)
        possible = [r['value'] for r in records if r['value'] is not None]
        return dict(status='EXACT_TWO_SIDED_FULL_BASIS_SUPPORT' if possible else 'EMPTY_TWO_SIDED_RELAXATION',
                    upper_bound=max(possible) if possible else None, support_records=records)


def json_exact(obj):
    if isinstance(obj, Fraction):
        return str(obj)
    if isinstance(obj, dict):
        return {str(k): json_exact(v) for k, v in obj.items()}
    if isinstance(obj, (list, tuple)):
        return [json_exact(v) for v in obj]
    return obj


def source_hashes():
    paths = ['two_sided_full_basis_oracle.py', 'physical-pool-source.json',
             'pools/xcoords.txt', 'pools/zcoords.txt', 'projected_profile_moment_matrix.py',
             'verify_projected_profile_moment_rows.py',
             'moment-resumption-results/symmetry-bridge-independent.json']
    receipt = json.loads((ROOT / paths[-1]).read_text())
    assert receipt['status'] == 'PASS' and receipt['source_pool_ranks'] == [128, 128]
    assert all(sha(ROOT / p) == value for p, value in receipt['pool_sha256'].items())
    return {p: sha(ROOT / p) for p in paths}


def cut_candidate(oracle, domains, coefficients, point):
    """Exact integer candidate with full pattern records; None if gap <= 0."""
    if oracle.pool_sizes != (720, 720) or oracle.dimension != 128:
        raise ValueError('physical C16 pools required for owner-row export')
    c = integer_direction(coefficients)
    support = oracle.support(c, domains)
    if support['upper_bound'] is None:
        raise ValueError('empty relaxation needs separate source-domain review')
    xx, zz = domains[0]['X_anchors'], domains[0]['Z_anchors']
    wanted = target(point, xx, zz)
    value = sum(a * b for a, b in zip(c, wanted))
    bound = support['upper_bound']
    if value <= bound:
        return None
    row, rhs = compile_row(c, bound, xx, zz)
    from verify_projected_profile_moment_rows import point_vector
    owner = point_vector(Path(point))
    assert sum(a * owner[j] for j, a in row.items()) - rhs == value - bound
    return dict(X_anchors=xx, Z_anchors=zz, coefficients=c, upper_bound=int(bound),
                exact_target_value=str(value), exact_violation=str(value - bound),
                owner_row_terms=[[j, a] for j, a in row.items()], rhs=rhs,
                support_records=support['support_records'])


def export_cut_bank(output, point, candidates, frozen_inputs=None):
    """Write only precomputed positive candidates; independent replay required."""
    output = Path(output)
    if output.exists() or not candidates:
        raise ValueError('new output path and at least one exact candidate required')
    if any(Fraction(c['exact_violation']) <= 0 for c in candidates):
        raise ValueError('strict exact target violation required')
    bank = dict(schema=SCHEMA, status='EXACT_TWO_SIDED_FULL_BASIS_CUT_CANDIDATES',
                source_C16_answered=False, feature_layout=LAYOUT, feature_count=N,
                dimension=128, pool_sizes=[720, 720], selection_patterns=list(range(16)),
                point_c16_path=str(Path(point).resolve().relative_to(ROOT)), point_sha256=sha(point),
                source_hashes=source_hashes(), frozen_inputs=frozen_inputs or {}, cuts=candidates,
                scope='Two full physical bases with common anchor pattern; unanchored mutual pairings relaxed.')
    output.write_text(json.dumps(json_exact(bank), indent=2) + '\n')
    return bank


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists() or args.output.with_suffix('.frozen.json').exists():
        raise ValueError('output and frozen declaration must be new')
    start = time.monotonic()
    hashes = source_hashes()
    cohorts = [('zero', [0] * N),
               ('negative_pool', [0] * 11 + [-1 - j % 7 for j in range(1440)] + [0] * 5760),
               ('signed_ties', [((13 * j + 7) % 19) - 9 for j in range(N)]),
               ('signed_fraction', [Fraction(((5 * j + 11) % 23) - 11, 1 + j % 4) for j in range(N)])]
    quads = [([80, 512], [186, 433]), ([80, 432], [186, 514])]
    frozen = dict(schema=SCHEMA, status='FROZEN_BEFORE_TWO_SIDED_FULL_BASIS_SUPPORTS',
                  feature_layout=LAYOUT, feature_count=N, dimension=128, pool_sizes=[720, 720],
                  selection_patterns=list(range(16)), source_hashes=hashes,
                  quads=[dict(X_anchors=x, Z_anchors=z) for x, z in quads],
                  cohorts=[dict(label=label, coefficients=c) for label, c in cohorts])
    fp = args.output.with_suffix('.frozen.json')
    fp.write_text(json.dumps(json_exact(frozen), indent=2) + '\n')
    oracle = TwoSidedFullBasisOracle()
    queries = []
    for xx, zz in quads:
        domains = oracle.prepare(xx, zz)
        for label, c in cohorts:
            queries.append(dict(label=label, X_anchors=xx, Z_anchors=zz,
                                coefficients=c, **oracle.support(c, domains)))
    assert all(sha(ROOT / p) == value for p, value in hashes.items())
    result = dict(schema=SCHEMA, status='EXACT_TWO_SIDED_FULL_BASIS_SUPPORT_BANK_CANDIDATE',
                  source_C16_answered=False, feature_layout=LAYOUT, feature_count=N,
                  dimension=128, pool_sizes=[720, 720], selection_patterns=list(range(16)),
                  source_hashes=hashes, frozen_sha256=sha(fp), queries=queries,
                  elapsed_seconds=time.monotonic() - start,
                  scope='Exact relaxed support candidates; independent acceptance required. No unanchored mutual-pairing constraint.')
    args.output.write_text(json.dumps(json_exact(result), indent=2) + '\n')
    print(json.dumps({k: v for k, v in result.items() if k not in ('queries', 'source_hashes')}))


if __name__ == '__main__':
    main()
