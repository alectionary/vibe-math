#!/usr/bin/env python3
"""Knuth's unbiased tree-size estimator for la_dfs.py's search tree (random probes).
Uses all 128 rows to pick the branching entry, and adds the column-space check:
the residual R = sum of the remaining outer products, so its column space lies in
span(X') and its row space in span(Z')."""
import sys, random, numpy as np, time
from la_dfs import *
def rank_of(vs): return len(basis(vs))
def to_int(b): return int(sum(int(x) << k for k, x in enumerate(b)))
def colspace_ok(R, xi, zj):
    bx = basis([v for i in xi for v in Xv[i]]); bz = basis([w for j in zj for w in Zv[j]])
    cols = [to_int(R[:, c]) for c in range(128)]; rows = [to_int(R[c]) for c in range(128)]
    return rank_of(bx + cols) == len(bx) and rank_of(bz + rows) == len(bz)
def node_children(R, okx, okz, depth, use_cs):
    need = 128 - 2 * depth
    xi = np.nonzero(okx)[0]; zj = np.nonzero(okz)[0]
    if rank_pair(xi, zj) < need: return 'rank', []
    if use_cs and not colspace_ok(R, xi, zj): return 'colspace', []
    live = np.nonzero(okx[PI] & okz[PJ])[0]
    best = None
    for c in range(128):
        if not R[c].any(): continue
        cnt = ((X0[live, c][:, None] & Z0[live]) ^ (X1[live, c][:, None] & Z1[live])).sum(0)
        cnt = np.where(R[c] == 1, cnt, 10**9); k = int(cnt.argmin())
        if best is None or cnt[k] < best[0]: best = (int(cnt[k]), c, k)
        if best[0] == 0: return 'empty', []
    _, c, k = best
    return 'ok', live[((X0[live, c] & Z0[live, k]) ^ (X1[live, c] & Z1[live, k])) == 1]
def probe(rnd, use_cs):
    R = np.eye(128, dtype=np.uint8); okx = np.ones(m, bool); okz = np.ones(m, bool)
    est, prod, depth = 1.0, 1.0, 0
    while True:
        why, ch = node_children(R, okx, okz, depth, use_cs)
        if why != 'ok': return est, depth, why
        prod *= len(ch); est += prod
        q = ch[rnd.randrange(len(ch))]; i, j = PI[q], PJ[q]
        R = R ^ np.outer(X0[q], Z0[q]) ^ np.outer(X1[q], Z1[q])
        okx = okx & zero[:, j]; okx[i] = False; okz = okz & zero[i, :]; okz[j] = False
        depth += 1
        if depth == 64: return est, depth, 'FRAME'
if __name__ == '__main__':
    n = int(sys.argv[1]); use_cs = len(sys.argv) > 2 and sys.argv[2] == 'cs'
    rnd = random.Random(1); t = time.time(); out = [probe(rnd, use_cs) for _ in range(n)]
    ests = [e for e, _, _ in out]
    import collections
    print('mean tree size %.3g  median %.3g' % (np.mean(ests), np.median(ests)), 'depths', collections.Counter(d for _, d, _ in out),
          collections.Counter(w for _, _, w in out), 'secs', round(time.time() - t))
