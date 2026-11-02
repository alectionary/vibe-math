"""Parity checks on frames.

A frame is a set F of 128 pool pairs (x,z) with sum over F of x z^T = I. For any matrix L,
taking the inner product <L, .> gives  #{(x,z) in F : z^T L x = 1} = tr(L)  (mod 2).
If tr(L) = 1, every frame contains at least one pair in supp(L) = {pool pairs e : z_e^T L x_e = 1}.
A small supp(L) means narrow forced branching (unit L = e_k e_c^T is the residual-entry rule).

supp(L) is the complement of S = {e : <L, z_e x_e^T> = 0}; we want a large set S of pair matrices
whose span avoids... precisely: L exists with L _|_ S and <L,I> = 1  iff  I not in span(S).
Greedy: add pair matrices to S while I stays outside span(S). Restricting L to coordinate block
set B (rows/cols in B) gives a |B|^2-dim problem.
"""
import random, sys
from collections import Counter
from pathlib import Path
root = Path(__file__).resolve().parents[2]
X = [int(v, 16) for v in (root / 'pools/xcoords.txt').read_text().split()]
Z = [int(v, 16) for v in (root / 'pools/zcoords.txt').read_text().split()]
dot = lambda u, v: bin(u & v).count('1') & 1
pairs = [(i, j) for i in range(720) for j in range(720) if dot(X[i], Z[j])]

def proj(v, coords):
    return sum(((v >> c) & 1) << k for k, c in enumerate(coords))

def run(blocks, trials=20, seed=0):
    coords = [16 * b + p for b in blocks for p in range(16)]; n = len(coords)
    pts = Counter()
    for i, j in pairs:
        px, pz = proj(X[i], coords), proj(Z[j], coords)
        if px and pz:
            m = 0
            for r in range(n):
                if (pz >> r) & 1: m |= px << (n * r)      # row r of z x^T  (rows indexed by z coord)
            pts[m] += 1
    I = sum(1 << (n * r + r) for r in range(n))
    items = list(pts.items()); best = None
    rnd = random.Random(seed)
    for t in range(trials):
        order = sorted(items, key=lambda kv: -kv[1] * (1 + 0.3 * rnd.random())) if t else sorted(items, key=lambda kv: -kv[1])
        piv = {}
        def reduce(v):
            while v:
                h = v.bit_length() - 1
                if h not in piv: return v
                v ^= piv[h]
            return 0
        # maintain basis of S; I in span(S) iff reduce(I) == 0. Adding m keeps I outside iff reduce(I) stays nonzero
        # after inserting m: I in span(S+m) iff reduce(I) in span? use: I in span(S+m) iff reduce(I) == reduce(m) (both nonzero) or reduce(I)==0
        supp = 0
        for m, w in order:
            rm = reduce(m)
            if rm == 0: continue           # already in span, harmless
            rI = reduce(I)
            # inserting rm: I enters span iff reduce(rI) w.r.t. new basis is 0, i.e. rI reduces to 0 using rm
            v = rI
            piv_tmp_h = rm.bit_length() - 1
            # emulate one more reduction step with rm added
            ok = True
            while v:
                h = v.bit_length() - 1
                if h == piv_tmp_h: v ^= rm; continue
                if h not in piv: break
                v ^= piv[h]
            if v == 0: supp += w; continue   # adding m would put I in span: m goes to supp(L)
            piv[piv_tmp_h] = rm
        best = supp if best is None else min(best, supp)
    unit = min(sum(w for m, w in items if (m >> (n * r + r)) & 1) for r in range(n))
    print(f'blocks {blocks}: {len(items)} distinct pair matrices from {sum(pts.values())} pairs; '
          f'best diagonal unit check {unit}; greedy best check support {best}', flush=True)

for arg in sys.argv[1:]:
    run([int(b) for b in arg.split(',')])
