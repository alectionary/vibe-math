#!/usr/bin/env python3
"""Exact weighted full opposite-basis support after selected physical X vectors.

Let W be k independent selected X vectors in an n-dimensional physical space.
Any full Gram-identity frame has exactly one selected Z of evaluation e_i for
each member i of W, and n-k selected Z of evaluation zero. The zero vectors
must span ker(W). Conversely, any basis of the zero-evaluation pool, together
with one vector from each unit-evaluation owner bin, is an n-vector Z basis:
evaluation on W kills every possible owner coefficient in a dependence.

Thus arbitrary SIGNED weight support is the sum of the maximum weight in
every REQUIRED owner bin and the maximum weight of a FULL zero-pool basis.
The latter is ordinary linear-matroid greedy. Negative weights are retained.
This is exact for the one-sided full-basis necessity, not for completion of
the remaining dual X vectors inside the original X pool.

API: oracle.prepare(orbit, mask, extra_X_indices=()) returns a cached domain;
oracle.support(domain, weights) takes720 exact integer/Fraction weights and
returns an exact Fraction value plus128 selected Z indices when feasible.
prepare_selected(indices) also supports general fixed physical X sets.
"""
from pathlib import Path
from fractions import Fraction
from numbers import Integral
import argparse
import gzip
import hashlib
import json
import platform
import statistics
import time

ROOT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def add_vector(pivots, vector):
    while vector:
        pivot = vector.bit_length()-1
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


class FullPartnerBasisOracle:
    def __init__(self, x_pool=None, z_pool=None, dimension=128, root=ROOT):
        self.root = Path(root)
        self.dimension = dimension
        assert (x_pool is None) == (z_pool is None)
        if x_pool is None:
            x_pool, z_pool = [[int(v, 16) for v in (self.root / f'pools/{side}coords.txt').read_text().split()] for side in 'xz']
        self.X = tuple(map(int, x_pool))
        self.Z = tuple(map(int, z_pool))
        assert all(0 <= v < 1 << dimension for v in self.X + self.Z)
        self.domains = {}
        self.pairing_rows = {}

    def prepare(self, orbit, mask, extra_X_indices=()):
        assert 0 <= mask < 65536 and 16*orbit+16 <= len(self.X)
        selected = [16*orbit+h for h in range(16) if mask >> h & 1]
        selected.extend(extra_X_indices)
        return self.prepare_selected(selected)

    def prepare_selected(self, selected_X_indices):
        selected = tuple(sorted(set(map(int, selected_X_indices))))
        assert all(0 <= i < len(self.X) for i in selected)
        if selected in self.domains:
            return self.domains[selected]
        k = len(selected)
        selected_rank = rank(self.X[i] for i in selected)
        domain = {'selected_X_indices': selected, 'selected_rank': selected_rank,
                  'dimension': self.dimension, 'zero_basis_required': self.dimension-k}
        if selected_rank != k:
            domain['status'] = 'EXCLUDED_DEPENDENT_SELECTED_X'
            self.domains[selected] = domain
            return domain
        signatures = [0] * len(self.Z)
        for h, i in enumerate(selected):
            if i not in self.pairing_rows:
                self.pairing_rows[i] = tuple((self.X[i] & z).bit_count() % 2 for z in self.Z)
            for j, value in enumerate(self.pairing_rows[i]):
                signatures[j] |= value << h
        zero = []
        owners = [[] for _ in selected]
        for j, signature in enumerate(signatures):
            if signature == 0:
                zero.append(j)
            elif signature & (signature-1) == 0:
                owners[signature.bit_length()-1].append(j)
        zero_rank = rank(self.Z[j] for j in zero)
        assert zero_rank <= self.dimension-k
        domain.update(zero_indices=tuple(zero), owner_bins=tuple(tuple(b) for b in owners),
                      zero_rank=zero_rank, eligible_count=len(zero)+sum(map(len, owners)))
        if zero_rank != self.dimension-k:
            domain['status'] = 'EXCLUDED_DEFICIENT_ZERO_POOL'
        elif any(not b for b in owners):
            domain['status'] = 'EXCLUDED_EMPTY_REQUIRED_OWNER'
        else:
            domain['status'] = 'FULL_PARTNER_BASIS_DOMAIN'
        self.domains[selected] = domain
        return domain

    def support(self, domain, weights):
        assert domain['dimension'] == self.dimension and len(weights) == len(self.Z)
        exact = []
        for value in weights:
            if isinstance(value, Integral):
                exact.append(int(value))
            elif isinstance(value, Fraction):
                exact.append(value)
            else:
                raise TypeError('support weights must be exact integers or Fractions')
        if domain['status'] != 'FULL_PARTNER_BASIS_DOMAIN':
            return {'status': domain['status'], 'value': None, 'selected_Z_indices': ()}
        order = sorted(domain['zero_indices'], key=lambda j: (-exact[j], j))
        pivots = {}
        zero_basis = []
        for j in order:
            if add_vector(pivots, self.Z[j]):
                zero_basis.append(j)
                if len(zero_basis) == domain['zero_basis_required']:
                    break
        assert len(zero_basis) == domain['zero_basis_required']
        owner_choices = [max(indices, key=lambda j: (exact[j], -j)) for indices in domain['owner_bins']]
        chosen = tuple(zero_basis + owner_choices)
        assert len(chosen) == len(set(chosen)) == self.dimension
        value = Fraction(sum(exact[j] for j in chosen))
        return {'status': 'EXACT_FULL_PARTNER_BASIS_SUPPORT', 'value': value,
                'selected_Z_indices': chosen, 'zero_basis_indices': tuple(zero_basis),
                'owner_indices': tuple(owner_choices)}


def read(path):
    raw = Path(path).read_bytes()
    return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)


def rotate(mask, h):
    return ((mask << h) | (mask >> (16-h))) & 65535


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--orbit', type=int, default=32)
    ap.add_argument('--extra-x', type=int, nargs='*', default=[])
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    start = time.monotonic()
    profile_path = ROOT / 'algebraic-results/orbit-rank-profiles.json.gz'
    hull_path = ROOT / 'algebraic-results/hulls-16-rank.json.gz'
    profiles = read(profile_path)
    row = next(r for r in profiles['records'] if r['orbit'] == args.orbit)
    bad = bytearray(65536)
    for cert in row['minimal_bad_certificates']:
        bad[cert['mask']] = 1
    for mask in range(65536):
        if args.orbit == 12 and mask.bit_count() > 11:
            bad[mask] = 1
        if not bad[mask]:
            bits = mask
            while bits:
                bit = bits & -bits
                bits -= bit
                if bad[mask ^ bit]:
                    bad[mask] = 1
                    break
    allowed = [m for m in range(65536) if not bad[m]]
    assert len(allowed) == next(r for r in read(hull_path)['records'] if r['orbit'] == args.orbit)['phase_patterns']
    representatives = sorted({min(rotate(m, h) for h in range(16)) for m in allowed})
    oracle = FullPartnerBasisOracle()
    weight_sets = [
        {'name': 'all_zero', 'weights': [0]*len(oracle.Z)},
        {'name': 'strictly_negative', 'weights': [-1-j % 13 for j in range(len(oracle.Z))]},
        {'name': 'signed_mixed', 'weights': [(37*j+11) % 29-14 for j in range(len(oracle.Z))]},
        {'name': 'positive_tied', 'weights': [1+j % 17 for j in range(len(oracle.Z))]},
    ]
    frozen = {'status': 'FROZEN_BEFORE_FULL_PARTNER_BASIS_COHORT', 'orbit': args.orbit,
              'extra_X_indices': args.extra_x, 'representatives': representatives,
              'allowed_mask_count': len(allowed), 'weight_sets': weight_sets,
              'source_sha256': sha(ROOT / 'physical-pool-source.json'),
              'pool_sha256': {s: sha(ROOT / f'pools/{s}coords.txt') for s in 'xz'},
              'profiles_sha256': sha(profile_path), 'hulls_sha256': sha(hull_path),
              'producer_sha256': sha(Path(__file__)), 'python': platform.python_version(),
              'scope': 'Exact support over a full physical Z basis matching selected X phase vectors. The remaining dual X completion is not required.'}
    frozen_path = args.output.with_suffix('.frozen.json')
    frozen_path.write_text(json.dumps(frozen, indent=2)+'\n')
    records = []
    prepare_times = []
    support_times = []
    for mask in representatives:
        before = time.monotonic()
        domain = oracle.prepare(args.orbit, mask, args.extra_x)
        prepare_times.append(time.monotonic()-before)
        entry = {'mask': mask, 'domain': {k: v for k, v in domain.items() if k not in ('zero_indices', 'owner_bins')},
                 'zero_count': len(domain.get('zero_indices', ())),
                 'owner_counts': list(map(len, domain.get('owner_bins', ()))), 'supports': []}
        for cohort in weight_sets:
            before = time.monotonic()
            result = oracle.support(domain, cohort['weights'])
            support_times.append(time.monotonic()-before)
            entry['supports'].append({'weight_set': cohort['name'], **result,
                                      'value': str(result['value']) if result['value'] is not None else None})
        records.append(entry)
    out = {'status': 'EXACT_FULL_PARTNER_SUPPORT_CANDIDATE', 'source_C16_answered': False,
           'orbit': args.orbit, 'extra_X_indices': args.extra_x, 'frozen_sha256': sha(frozen_path),
           'producer_sha256': sha(Path(__file__)), 'records': records,
           'representatives': len(representatives), 'weight_sets': len(weight_sets),
           'support_queries': len(support_times),
           'feasible_domains': sum(r['domain']['status'] == 'FULL_PARTNER_BASIS_DOMAIN' for r in records),
           'preparation_seconds': sum(prepare_times), 'support_seconds': sum(support_times),
           'median_support_seconds': statistics.median(support_times),
           'max_support_seconds': max(support_times), 'elapsed_seconds': time.monotonic()-start,
           'scope': frozen['scope']+' Negative weights are retained and every feasible support witness has exactly128 Z vectors.'}
    args.output.write_text(json.dumps(out, separators=(',', ':'))+'\n')
    print({k: v for k, v in out.items() if k != 'records'}, flush=True)


if __name__ == '__main__':
    main()
