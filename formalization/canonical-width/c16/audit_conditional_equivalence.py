#!/usr/bin/env python3
"""Discover exact source-pool graph equivalences; emit verifiable permutations.

Nauty is a discovery tool only. Consumers must check actual pairing adjacency.
No graph automorphism need be a physical/code automorphism: its permutation of
the exact two dictionaries preserves the Gram-identity completion question.
"""
from pathlib import Path
import argparse
import collections
import hashlib
import gzip
import json
import time

ROOT = Path(__file__).resolve().parent


def inputs():
    paths = [ROOT/'pools/xcoords.txt', ROOT/'pools/zcoords.txt']
    X, Z = [[int(s, 16) for s in p.read_text().split()] for p in paths]
    rows = [sum(((x & z).bit_count() % 2) << j for j, z in enumerate(Z)) for x in X]
    return X, Z, rows, {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}


def members(mask):
    while mask:
        b = mask & -mask
        yield b.bit_length()-1
        mask ^= b


def full_graph(rows):
    import pynauty
    adj = {i: [720+j for j in members(row)] for i, row in enumerate(rows)}
    for j in range(720):
        adj[720+j] = [i for i, row in enumerate(rows) if row >> j & 1]
    return pynauty.Graph(1440, adjacency_dict=adj)


def rank(vectors):
    piv = {}
    for v in vectors:
        while v:
            k = v.bit_length()
            if k not in piv:
                piv[k] = v
                break
            v ^= piv[k]
    return len(piv)


def residual(rows, x, z):
    left = [i for i, row in enumerate(rows) if not (row >> z & 1)]
    right = list(members(((1 << 720)-1) ^ rows[x]))
    rmask = sum(1 << j for j in right)
    subrows = [rows[i] & rmask for i in left]
    return left, right, subrows


def invariant(left, right, subrows):
    dl = [r.bit_count() for r in subrows]
    dr = [sum(r >> j & 1 for r in subrows) for j in right]
    # Complete exact degree histograms, allowing a global sector swap.
    sectors = sorted((tuple(sorted(collections.Counter(dl).items())),
                      tuple(sorted(collections.Counter(dr).items()))))
    return (min(len(left), len(right)), max(len(left), len(right)), tuple(sectors))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--mode', choices=['full', 'invariants'], default='full')
    a = ap.parse_args()
    t = time.monotonic()
    X, Z, rows, hashes = inputs()
    cases = json.loads((ROOT/'overnight-results/pair-case-cover.json').read_text())['cases']
    result = {'source_sha256': hashes, 'source_C16_answered': False,
              'original_cover_count': len(cases), 'mode': a.mode}
    if a.mode == 'full':
        import pynauty
        print('Starting exact full pairing-graph automorphism discovery', flush=True)
        gens, size, exponent, orbits, norbits = pynauty.autgrp(full_graph(rows))
        print(f'Discovered {len(gens)} generators, group order {size} * 10^{exponent}', flush=True)
        edges = [(i, j) for i, row in enumerate(rows) for j in members(row)]
        pos = {e: k for k, e in enumerate(edges)}
        parent = list(range(len(edges)))
        def find(k):
            while parent[k] != k:
                parent[k] = parent[parent[k]]
                k = parent[k]
            return k
        def join(k, l):
            k, l = find(k), find(l)
            if k != l:
                parent[max(k, l)] = min(k, l)
        def image(g, i, j):
            u, v = g[i], g[720+j]
            return (u, v-720) if u < 720 else (v, u-720)
        for g in gens:
            assert sorted(g) == list(range(1440))
            assert len({g[i]//720 for i in range(720)}) == 1
            assert all(g[720+j]//720 != g[0]//720 for j in range(720))
            for k, (i, j) in enumerate(edges):
                e = image(g, i, j)
                assert e in pos
                join(k, pos[e])
        classes = collections.defaultdict(list)
        for k, case in enumerate(cases):
            classes[find(pos[(case['X_index'], case['Z_index'])])].append(k)
        groups = sorted(classes.values(), key=lambda c: c[0])
        result.update({'pynauty_version': pynauty.__version__, 'generators': gens,
                       'reported_group_order': [size, exponent], 'reported_vertex_orbits': orbits,
                       'reported_vertex_orbit_count': norbits, 'edge_orbit_count': len({find(k) for k in range(len(edges))}),
                       'cover_equivalence_class_count': len(groups),
                       'classes': [{'representative_case': cases[c[0]]['id'],
                                    'case_ids': [cases[k]['id'] for k in c]} for c in groups]})
    else:
        bins = collections.defaultdict(list)
        records = []
        for k, c in enumerate(cases):
            left, right, subrows = residual(rows, c['X_index'], c['Z_index'])
            key = invariant(left, right, subrows)
            ranks = [rank(X[i] for i in left), rank(Z[j] for j in right)]
            assert max(ranks) <= 127
            bins[key].append(c['id'])
            records.append({'id': c['id'], 'pool_sizes': [len(left), len(right)],
                            'remaining_pool_ranks': ranks, 'invariant': key})
            if k % 50 == 0:
                print(f'{k}/{len(cases)} residual signatures, {len(bins)} invariant classes, {time.monotonic()-t:.1f}s', flush=True)
        result.update({'degree_invariant_class_count': len(bins),
                       'classes': list(bins.values()), 'cases': records,
                       'rank_excluded_cases': [r['id'] for r in records if min(r['remaining_pool_ranks']) < 127],
                       'scope': 'Different signatures prove nonisomorphism; equal signatures do not prove equivalence.'})
    result['elapsed_seconds'] = time.monotonic()-t
    raw=(json.dumps(result, separators=(',',':'))+'\n').encode() if a.mode=='invariants' else (json.dumps(result,indent=2)+'\n').encode()
    a.output.write_bytes(gzip.compress(raw,mtime=0) if a.output.suffix=='.gz' else raw)
    print(f'Saved {a.output}; elapsed {result["elapsed_seconds"]:.2f}s', flush=True)


if __name__ == '__main__':
    main()
