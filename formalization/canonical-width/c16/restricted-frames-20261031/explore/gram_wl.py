"""Colour refinement on the bipartite anticommutation graph G (720 X vectors, 720 Z vectors, edge iff
<x,z> = 1). Any linear symmetry A (A X = X, A^{-T} Z = Z) induces an automorphism of this graph, so
the refinement bounds the full linear symmetry group, not just coordinate permutations."""
from collections import Counter
from pathlib import Path
root = Path(__file__).resolve().parents[2]
X = [int(v, 16) for v in (root / 'pools/xcoords.txt').read_text().split()]
Z = [int(v, 16) for v in (root / 'pools/zcoords.txt').read_text().split()]
dot = lambda u, v: bin(u & v).count('1') & 1
nbx = [[j for j in range(720) if dot(X[i], Z[j])] for i in range(720)]
nbz = [[i for i in range(720) if dot(X[i], Z[j])] for j in range(720)]
def refine(cx, cz):
    while True:
        nx = [(cx[i], tuple(sorted(cz[j] for j in nbx[i]))) for i in range(720)]
        nz = [(cz[j], tuple(sorted(cx[i] for i in nbz[j]))) for j in range(720)]
        allc = sorted(set(nx) | set(nz)); m = {c: k for k, c in enumerate(allc)}
        cx2 = [m[c] for c in nx]; cz2 = [m[c] for c in nz]
        if len(set(cx2) | set(cz2)) == len(set(cx) | set(cz)): return cx2, cz2
        cx, cz = cx2, cz2
for swap in (False, True):
    cx, cz = refine([0] * 720, [0 if swap else 1] * 720)
    sizes = Counter(Counter(cx + cz).values())
    print('swap allowed' if swap else 'sides fixed', '- classes', len(set(cx) | set(cz)), 'class sizes', dict(sizes))
    cx1 = list(cx); cx1[0] = -1
    a, b = refine(cx1, cz)
    print('   after individualising X vector 0:', len(set(a) | set(b)), 'classes; largest', max(Counter(a + b).values()))
