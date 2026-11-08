#!/usr/bin/env python3
"""Check that the 16-element group used by subgroup_frame_o12.py (translations
p -> p+h on both sectors, optionally composed with the sector swap) preserves
everything the non-lex part of the encoding depends on. That part depends on
the patterns only through whether a pattern is zero, has one monomial, or has
two or more. The critical-orbit bound is on orbit 12 on both sides, a set each
group element maps to itself."""
from pathlib import Path
root = Path(__file__).resolve().parent.parent
X = [int(v, 16) for v in (root / 'pools/xcoords.txt').read_text().split()]
Z = [int(v, 16) for v in (root / 'pools/zcoords.txt').read_text().split()]
L, d = 2, 8; m = 45 * d
P = [[sum(((X[16*a+p] & Z[16*b+q+d*h]).bit_count() % 2) << h for h in range(L)) for b in range(45) for q in range(d)] for a in range(45) for p in range(d)]
w = lambda f: min(bin(f).count('1'), 2)
sh = lambda i, h: (i // d) * d + (i % d + h) % d
for h in range(d):
    assert all(w(P[sh(i, h)][sh(j, h)]) == w(P[i][j]) for i in range(m) for j in range(m)), h
assert all(w(P[j][i]) == w(P[i][j]) for i in range(m) for j in range(m))
assert {sh(12 * d + p, h) for p in range(d) for h in range(d)} == {12 * d + p for p in range(d)}
print('OK: translations and sector swap preserve the pattern classes; the critical orbit is mapped to itself')
