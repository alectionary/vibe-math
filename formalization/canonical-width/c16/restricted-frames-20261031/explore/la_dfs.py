#!/usr/bin/env python3
"""Linear-algebra-aware exact search for half-turn (T^8-invariant) frames.

State: chosen sub-orbit pairs; residual R = I - sum of chosen outer products
(128x128 over F2). Any completion's outer products sum to R, so
  (branch)  pick an entry (c,c') with R[c,c'] = 1; some remaining pair must have a
            1 there. Branch over exactly those candidate pairs.
  (prune)   rank G[X',Z'] >= number of vectors still needed, where X' (resp. Z')
            are the unused pool sub-orbits orthogonal to every chosen Z (resp. X) vector.
This prototype measures the tree; it does not yet use the symmetry group.
"""
import sys, time, random
sys.path.insert(0, '..')
import numpy as np
import cnc
X, Z, P = cnc.patterns()
d, m = 8, 360
def bits(v): return np.array([(v >> k) & 1 for k in range(128)], dtype=np.uint8)
Xv = [[X[16*(i//d)+i%d], X[16*(i//d)+i%d+8]] for i in range(m)]
Zv = [[Z[16*(j//d)+j%d], Z[16*(j//d)+j%d+8]] for j in range(m)]
XB = np.array([[bits(v) for v in Xv[i]] for i in range(m)])   # m x 2 x 128
ZB = np.array([[bits(v) for v in Zv[j]] for j in range(m)])
pairs = [(i, j, P[i][j].bit_length() - 1) for i in range(m) for j in range(m) if bin(P[i][j]).count('1') == 1]
PI = np.array([p[0] for p in pairs]); PJ = np.array([p[1] for p in pairs]); PH = np.array([p[2] for p in pairs])
# per pair: the two (x,z) vector pairs: (x_{i,0}, z_{j,h}), (x_{i,1}, z_{j,1-h})
X0 = XB[PI, 0]; X1 = XB[PI, 1]; Z0 = ZB[PJ, PH]; Z1 = ZB[PJ, 1 - PH]
# orthogonality: sub-orbit i (X) is orthogonal to sub-orbit j (Z) iff pattern zero
zero = np.array([[P[i][j] == 0 for j in range(m)] for i in range(m)])
def dot(u, v): return bin(u & v).count('1') & 1
def basis(vs):
    piv = {}
    for v in vs:
        while v:
            h = v.bit_length() - 1
            if h in piv: v ^= piv[h]
            else: piv[h] = v; break
    return list(piv.values())
def rank_pair(xi, zj):
    bx = basis([v for i in xi for v in Xv[i]]); bz = basis([w for j in zj for w in Zv[j]])
    return len(basis([sum(dot(u, w) << k for k, w in enumerate(bz)) for u in bx]))
nodes = [0] * 70; t0 = time.time(); LIMIT = 60
class Stop(Exception): pass
def search(R, okx, okz, depth, maxdepth):
    nodes[depth] += 1
    if time.time() - t0 > LIMIT: raise Stop
    need = 128 - 2 * depth
    if need == 0: return True
    xi = np.nonzero(okx)[0]; zj = np.nonzero(okz)[0]
    if rank_pair(xi, zj) < need: return False
    if depth >= maxdepth: return None
    live = np.nonzero(okx[PI] & okz[PJ])[0]
    # branching entry: rows of R that are nonzero; count candidates per entry for a few rows
    rows = [c for c in range(128) if R[c].any()]
    best = None
    for c in rows[:16]:
        cnt = (X0[live, c][:, None] & Z0[live] ^ X1[live, c][:, None] & Z1[live]).sum(0)
        cnt = np.where(R[c] == 1, cnt, 10**9)
        k = int(cnt.argmin())
        if best is None or cnt[k] < best[0]: best = (int(cnt[k]), c, k)
    if best[0] == 0: return False
    _, c, k = best
    sel = live[(X0[live, c] & Z0[live, k] ^ X1[live, c] & Z1[live, k]) == 1]
    found = False
    for q in sel:
        i, j = PI[q], PJ[q]
        R2 = R ^ np.outer(X0[q], Z0[q]) ^ np.outer(X1[q], Z1[q])
        okx2 = okx & zero[:, j]; okx2[i] = False
        okz2 = okz & zero[i, :]; okz2[j] = False
        r = search(R2, okx2, okz2, depth + 1, maxdepth)
        if r: return True
    return found
if __name__ == '__main__':
    maxd = int(sys.argv[1]) if len(sys.argv) > 1 else 2
    LIMIT = float(sys.argv[2]) if len(sys.argv) > 2 else 60
    R = np.eye(128, dtype=np.uint8); okx = np.ones(m, bool); okz = np.ones(m, bool)
    try: search(R, okx, okz, 0, maxd); status = 'complete'
    except Stop: status = 'time limit'
    print(status, 'nodes per depth', [n for n in nodes if n], 'secs', round(time.time() - t0, 1))
