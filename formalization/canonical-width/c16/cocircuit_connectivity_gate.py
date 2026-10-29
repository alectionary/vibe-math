#!/usr/bin/env python3
"""Reproduce the source-matroid connectivity gate using fundamental circuits."""
from pathlib import Path
import argparse
import json
from verify_algebraic_model import physical


def components(values):
    parent = list(range(len(values)))
    pivots = {}

    def find(i):
        while parent[i] != i:
            parent[i] = parent[parent[i]]
            i = parent[i]
        return i

    for i, v in enumerate(values):
        support = 1 << i
        while v:
            k = v.bit_length()-1
            if k not in pivots:
                pivots[k] = (v, support)
                break
            w, s = pivots[k]
            v ^= w
            support ^= s
        if not v:
            members = [j for j in range(len(values)) if support >> j & 1]
            for j in members[1:]:
                parent[find(j)] = find(members[0])
    counts = {}
    for i in range(len(values)):
        root = find(i)
        counts[root] = counts.get(root, 0)+1
    return len(pivots), sorted(counts.values())


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args()
    X, Z, A = physical()
    rank, sizes = components(X)
    rows = []
    for o in range(45):
        values = [x for i, x in enumerate(X) if not (A[i] >> (16*o) & 1)]
        r, s = components(values)
        assert r == 127 and s == [len(values)]
        rows.append({'Z_orbit': o, 'zero_pool_size': len(values), 'rank': r,
                     'component_sizes': s})
    assert rank == 128 and sizes == [720]
    out = {'status': 'EXACT_MATROID_CONNECTIVITY_GATE', 'full_X_rank': rank,
           'full_X_component_sizes': sizes, 'records': rows, 'source_C16_answered': False}
    a.output.write_text(json.dumps(out, indent=2)+'\n')
    print('PASS: full matroid and all45 representative zero pools are connected', flush=True)


if __name__ == '__main__':
    main()
