#!/usr/bin/env python3
"""Check z_i = pi(x_i) for every pool index i, where pi exchanges coordinate blocks 2<->4 and 3<->5.

Consequently G[i][j] = <x_i, pi x_j>, which is symmetric because pi is a symmetric permutation.
Run from anywhere: python3 check_pi.py  (prints the number of indices satisfying it; expected 720).
"""
from pathlib import Path

root = Path(__file__).resolve().parents[2]
X = [int(v, 16) for v in (root / 'pools/xcoords.txt').read_text().split()]
Z = [int(v, 16) for v in (root / 'pools/zcoords.txt').read_text().split()]
PERM = {0: 0, 1: 1, 2: 4, 3: 5, 4: 2, 5: 3, 6: 6, 7: 7}


def pi(v: int) -> int:
    return sum(((v >> (16 * b)) & 0xFFFF) << (16 * PERM[b]) for b in range(8))


ok = sum(pi(X[i]) == Z[i] for i in range(len(X)))
print(f'z_i = pi(x_i) holds for {ok} of {len(X)} indices')
assert ok == len(X) == 720
