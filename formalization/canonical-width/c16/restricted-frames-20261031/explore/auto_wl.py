"""Colour refinement (1-WL) on the coordinate/pool-vector incidence graph, to bound the
coordinate-permutation automorphism group of (X pool, Z pool). Optional arg 'swap' merges
X and Z vertex colours (allows the X<->Z swap)."""
import sys
from pathlib import Path
root = Path(__file__).resolve().parents[2]
X = [int(v, 16) for v in (root / 'pools/xcoords.txt').read_text().split()]
Z = [int(v, 16) for v in (root / 'pools/zcoords.txt').read_text().split()]
swap = 'swap' in sys.argv
vecs = [('X', v) for v in X] + [('Z', v) for v in Z]
supp = [[k for k in range(128) if v >> k & 1] for _, v in vecs]
nbr = [[] for _ in range(128)]
for i, s in enumerate(supp):
    for k in s: nbr[k].append(i)
def refine(cc, vc):
    while True:
        nv = [(vc[i], tuple(sorted(cc[k] for k in supp[i]))) for i in range(len(vecs))]
        m = {c: j for j, c in enumerate(sorted(set(nv)))}; vc2 = [m[c] for c in nv]
        nc = [(cc[k], tuple(sorted(vc2[i] for i in nbr[k]))) for k in range(128)]
        m = {c: j for j, c in enumerate(sorted(set(nc)))}; cc2 = [m[c] for c in nc]
        if len(set(cc2)) == len(set(cc)) and len(set(vc2)) == len(set(vc)):
            return cc2, vc2
        cc, vc = cc2, vc2
cc = [0] * 128; vc = [0 if (swap or t == 'X') else 1 for t, _ in vecs]
cc, vc = refine(cc, vc)
from collections import Counter
print('coordinate colour classes', len(set(cc)), 'sizes', sorted(Counter(cc).values()))
print('vector colour classes', len(set(vc)))
for c in sorted(set(cc)):
    print(c, [k for k in range(128) if cc[k] == c])
# individualise coordinate 0 and refine: a discrete colouring means the stabiliser of coordinate 0 is trivial
cc0 = [c * 2 + (1 if k == 0 else 0) for k, c in enumerate(cc)]
c1, v1 = refine(cc0, vc)
print('after individualising coord 0:', len(set(c1)), 'coordinate classes;', 'sizes', sorted(Counter(c1).values())[-5:])
