#!/usr/bin/env python3
"""How early does the residual-rank bound bite on random half-turn partial frames?
A partial frame with k pairs (A,B) leaves X' = pool X vectors orthogonal to B,
Z' = pool Z vectors orthogonal to A. Any completion needs rank G[X',Z'] >= 128-k."""
import random, sys
sys.path.insert(0, '..'); sys.path.insert(0, '.')
import cnc
X, Z, P = cnc.patterns()
d = 8; m = 360
def vecs(side, i):  # the two pool vectors of sub-orbit i
    a, p = divmod(i, d); V = X if side == 0 else Z
    return [V[16*a+p], V[16*a+p+8]]
def dot(u, v): return bin(u & v).count('1') & 1
def basis(vs):
    piv = {}
    for v in vs:
        while v:
            h = v.bit_length() - 1
            if h in piv: v ^= piv[h]
            else: piv[h] = v; break
    return list(piv.values())
def rank_pair(Xs, Zs):
    bx, bz = basis(Xs), basis(Zs)
    rows = [sum(dot(u, w) << j for j, w in enumerate(bz)) for u in bx]
    return len(basis(rows))
mono = [[j for j in range(m) if bin(P[i][j]).count('1') == 1] for i in range(m)]
def trial(seed):
    rnd = random.Random(seed); A = []; B = []; selx = set(); selz = set()
    while True:
        k = len(A)
        Xp = [i for i in range(m) if i not in selx and all(dot(v, w) == 0 for v in vecs(0, i) for w in B)]
        Zp = [j for j in range(m) if j not in selz and all(dot(v, w) == 0 for v in A for w in vecs(1, j))]
        r = rank_pair([v for i in Xp for v in vecs(0, i)], [w for j in Zp for w in vecs(1, j)])
        if r < 128 - k: return k, 'rank', r
        cands = [(i, j) for i in Xp for j in mono[i] if j in set(Zp)]
        if not cands: return k, 'dead', r
        i, j = rnd.choice(cands); selx.add(i); selz.add(j); A += vecs(0, i); B += vecs(1, j)
        if len(A) == 128: return k, 'FRAME', r
import collections
res = [trial(s) for s in range(int(sys.argv[1]) if len(sys.argv) > 1 else 30)]
print(collections.Counter(r[1] for r in res)); print('pairs placed when stopped:', sorted(r[0] // 2 for r in res))
