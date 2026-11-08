#!/usr/bin/env python3
"""Knuth tree-size estimate for the same linear-algebra search on the FULL
(unrestricted) C16 problem: 720 X and 720 Z pool vectors, items are single pairs
(s,t) with G[s,t]=1, and a frame is 128 pairs whose outer products sum to I."""
import sys, random, time, collections, numpy as np
sys.path.insert(0, '..')
import cnc
X, Z, _ = cnc.patterns()
n = 720
XB = np.array([[(v >> k) & 1 for k in range(128)] for v in X], dtype=np.uint8)
ZB = np.array([[(v >> k) & 1 for k in range(128)] for v in Z], dtype=np.uint8)
G = (XB.astype(np.int32) @ ZB.T.astype(np.int32)) % 2
PI, PJ = np.nonzero(G)
def basis(vs):
    piv = {}
    for v in vs:
        while v:
            h = v.bit_length() - 1
            if h in piv: v ^= piv[h]
            else: piv[h] = v; break
    return list(piv.values())
def dot(u, v): return bin(u & v).count('1') & 1
def rank_pair(xi, zj):
    bx = basis([X[i] for i in xi]); bz = basis([Z[j] for j in zj])
    return len(basis([sum(dot(u, w) << k for k, w in enumerate(bz)) for u in bx]))
def probe(rnd):
    R = np.eye(128, dtype=np.uint8); okx = np.ones(n, bool); okz = np.ones(n, bool)
    est, prod, depth = 1.0, 1.0, 0
    while True:
        need = 128 - depth
        if rank_pair(np.nonzero(okx)[0], np.nonzero(okz)[0]) < need: return est, depth, 'rank'
        live = np.nonzero(okx[PI] & okz[PJ])[0]
        XL = XB[PI[live]]; ZL = ZB[PJ[live]]
        cnt = XL.T.astype(np.int32) @ ZL.astype(np.int32)       # 128 x 128 candidate counts per entry
        cnt = np.where(R == 1, cnt, 10**9); c, k = np.unravel_index(cnt.argmin(), cnt.shape)
        if cnt[c, k] == 0: return est, depth, 'empty'
        ch = live[(XL[:, c] & ZL[:, k]) == 1]
        prod *= len(ch); est += prod
        q = ch[rnd.randrange(len(ch))]; s, t = PI[q], PJ[q]
        R = R ^ np.outer(XB[s], ZB[t])
        okx = okx & (G[:, t] == 0); okx[s] = False; okz = okz & (G[s, :] == 0); okz[t] = False
        depth += 1
        if depth == 128: return est, depth, 'FRAME'
rnd = random.Random(2); t0 = time.time(); out = [probe(rnd) for _ in range(int(sys.argv[1]))]
e = [o[0] for o in out]
print('mean %.3g median %.3g max %.3g' % (np.mean(e), np.median(e), max(e)), collections.Counter(o[1] for o in out), collections.Counter(o[2] for o in out), round(time.time() - t0), 's')
