#!/usr/bin/env python3
"""Exhaustive F2^4 controls for the short-sum flat bound in the research note."""
from pathlib import Path
import argparse
import itertools
import json


def span(values):
    result = {0}
    for v in values:
        result |= {x ^ v for x in result}
    return frozenset(result)


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args()
    points = range(1, 16)
    subspaces = {frozenset({0})}
    for k in range(1, 5):
        subspaces |= {span(vs) for vs in itertools.combinations(points, k)}
    assert len(subspaces) == 67
    frames = checks = strict = 0
    for X in itertools.combinations(points, 4):
        if len(span(X)) != 16:
            continue
        Z = [next(z for z in points if all(((x & z).bit_count() % 2) == (i == j)
                                         for i, x in enumerate(X))) for j in range(4)]
        frames += 1
        for U in subspaces:
            u = len(U).bit_length()-1
            W = {z for z in range(16) if all((x & z).bit_count() % 2 == 0 for x in U)}
            for d in range(1, 5):
                short = {0}
                for k in range(1, d+1):
                    for subset in itertools.combinations(Z, k):
                        word = 0
                        for z in subset:
                            word ^= z
                        short.add(word)
                L = span(short & W)
                assert L <= W
                if len(L) < len(W):
                    assert sum(x in U for x in X) <= u-d
                    strict += 1
                checks += 1
    assert (frames, checks, strict) == (840, 225120, 56280)
    result = {'status': 'PASS', 'unordered_full_dual_frames': frames,
              'all_subspaces_F2_4': len(subspaces), 'short_sum_orders': [1, 2, 3, 4],
              'full_frame_bound_checks': checks, 'strict_bound_instances': strict,
              'source_C16_answered': False,
              'control_pool': 'For each full X basis, the allowed Z pool is exactly its four dual vectors.',
              'scope': 'Exhaustive elementary controls; no extra C16 pruning or source completion.'}
    a.output.write_text(json.dumps(result, indent=2)+'\n')
    print(result, flush=True)


if __name__ == '__main__':
    main()
