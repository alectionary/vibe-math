#!/usr/bin/env python3
"""Independently check a FRAME line from la_dfs: map item ids back to pool vectors
(by value, through the instance file) and check that the Gram matrix restricted to
the chosen X and Z vectors is the identity in pair order, and the X vectors span the
target dimension. Usage: verify_frame.py INSTANCE FRAMES_FILE"""
import sys
from pathlib import Path
root = Path(__file__).resolve().parents[2]
PX = [int(v, 16) for v in (root / 'pools/xcoords.txt').read_text().split()]
PZ = [int(v, 16) for v in (root / 'pools/zcoords.txt').read_text().split()]
lines = Path(sys.argv[1]).read_text().split('\n')
NX, NZ, GX, GZ, g, NI, DIM = map(int, lines[0].split())
rd = lambda s: int(s.split()[0], 16) | (int(s.split()[1], 16) << 64)
XV = [rd(lines[2 + i]) for i in range(NX)]; ZV = [rd(lines[2 + NX + i]) for i in range(NZ)]
o = 2 + NX + NZ + GX + GZ
items = [list(map(int, lines[o + q].split())) for q in range(NI)]
dot = lambda u, v: bin(u & v).count('1') & 1
for line in Path(sys.argv[2]).read_text().split('\n'):
    if not line.startswith('FRAME'): continue
    pairs = [(XV[it[2 + 2 * s]], ZV[it[3 + 2 * s]]) for q in map(int, line.split()[1:]) for it in [items[q]] for s in range(g)]
    assert len(pairs) == DIM
    assert all(dot(x, z) == (a == b) for a, (x, _) in enumerate(pairs) for b, (_, z) in enumerate(pairs))
    assert all(x in PX for x, _ in pairs) and all(z in PZ for _, z in pairs)
    assert len({x for x, _ in pairs}) == DIM and len({z for _, z in pairs}) == DIM
    print('VERIFIED frame of', DIM, 'pairs; pool indices X', sorted(PX.index(x) for x, _ in pairs)[:8], '...')
