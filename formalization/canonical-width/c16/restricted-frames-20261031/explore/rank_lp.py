"""Rank-inequality LP bound on the frame size (= induced matching in the anticommutation graph).

For a frame F (|F| = 128, G[S,T] = permutation) and any row set A, column set B:
    #{(i,j) in F : i in A, j in B}  <=  rank_F2 G[A,B]
because those pairs form an identity submatrix of G[A,B]. Aggregating by T-orbits (variables
m[a][c] = number of frame pairs from X-orbit a to Z-orbit c) gives an LP whose optimum bounds the
frame size. If the optimum is < 128, no frame exists.

Cutting planes: start with single-orbit rows/cols and orbit-pair blocks, then repeatedly search for
orbit sets P, Q with sum_{P x Q} m - rank G[P,Q] > 0 (greedy + random restarts) and add them.
"""
import random, sys, time
import numpy as np
from scipy.optimize import linprog
from pathlib import Path
root = Path(__file__).resolve().parents[2]
X = [int(v, 16) for v in (root / 'pools/xcoords.txt').read_text().split()]
Z = [int(v, 16) for v in (root / 'pools/zcoords.txt').read_text().split()]
N = 45
dot = lambda u, v: bin(u & v).count('1') & 1
# G rows as bit masks over 720 columns
Grow = [sum(dot(X[i], Z[j]) << j for j in range(720)) for i in range(720)]
orbmask = [sum(1 << (16 * c + t) for t in range(16)) for c in range(N)]
cache = {}
def rank(P, Q):
    key = (P, Q)
    if key in cache: return cache[key]
    colmask = 0
    for c in range(N):
        if Q >> c & 1: colmask |= orbmask[c]
    piv = {}; r = 0
    for a in range(N):
        if not P >> a & 1: continue
        for t in range(16):
            v = Grow[16 * a + t] & colmask
            while v:
                h = v.bit_length() - 1
                if h in piv: v ^= piv[h]
                else: piv[h] = v; r += 1; break
            if r == 128: break
    cache[key] = r; return r

full = (1 << N) - 1
cons = []   # (P, Q, rhs)
def add(P, Q): cons.append((P, Q, rank(P, Q)))
for a in range(N):
    add(1 << a, full); add(full, 1 << a)
    for c in range(N): add(1 << a, 1 << c)
add(full, full)

def solve():
    A = np.zeros((len(cons), N * N)); b = np.zeros(len(cons))
    for k, (P, Q, r) in enumerate(cons):
        rows = [a for a in range(N) if P >> a & 1]; cols = [c for c in range(N) if Q >> c & 1]
        for a in rows: A[k, [a * N + c for c in cols]] = 1
        b[k] = r
    res = linprog(-np.ones(N * N), A_ub=A, b_ub=b, bounds=(0, None), method='highs')
    return -res.fun, res.x.reshape(N, N)

def violation(P, Q, m):
    rows = [a for a in range(N) if P >> a & 1]; cols = [c for c in range(N) if Q >> c & 1]
    return m[np.ix_(rows, cols)].sum() - rank(P, Q)

def separate(m, tries, rnd):
    found = []
    for _ in range(tries):
        P = rnd.getrandbits(N) | 1 << rnd.randrange(N); Q = rnd.getrandbits(N) | 1 << rnd.randrange(N)
        v = violation(P, Q, m); improved = True
        while improved:
            improved = False
            for k in rnd.sample(range(2 * N), 2 * N):
                P2, Q2 = (P ^ (1 << k), Q) if k < N else (P, Q ^ (1 << (k - N)))
                if not P2 or not Q2: continue
                v2 = violation(P2, Q2, m)
                if v2 > v + 1e-9: P, Q, v, improved = P2, Q2, v2, True
        if v > 1e-6: found.append((v, P, Q))
    found.sort(reverse=True)
    return found

rnd = random.Random(int(sys.argv[1]) if len(sys.argv) > 1 else 0)
t0 = time.time()
for it in range(200):
    val, m = solve()
    cuts = separate(m, int(sys.argv[2]) if len(sys.argv) > 2 else 12, rnd)
    print(f'iter {it}: LP bound {val:.3f}, constraints {len(cons)}, new cuts {len(cuts)}, '
          f'best violation {cuts[0][0] if cuts else 0:.3f}, {time.time() - t0:.0f}s', flush=True)
    if not cuts: break
    seen = {(P, Q) for P, Q, _ in cons}
    for v, P, Q in cuts[:20]:
        if (P, Q) not in seen: add(P, Q); seen.add((P, Q))
print('final LP bound', val)
