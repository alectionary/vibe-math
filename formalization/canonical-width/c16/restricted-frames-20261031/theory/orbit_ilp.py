"""Integer orbit-count model for C16 frames (theory push, 2026-11-03).

Variables n[a][c] = number of frame pairs (x, z) with x in X-orbit a, z in Z-orbit c.
Necessary conditions for a 128-pair frame:
  (1) 0 <= n[a][c] <= nu[a][c], nu = max induced matching of the 16x16 circulant block G[a, c];
  (2) row sums <= 16, column sums <= 16, total = 128;
  (3) parity: sum_{a,c} n[a][c] * rho(x_a) rho(z_c)^T = 0 over F2 (rho = sum of coordinates per block;
      from sum_i x_i z_i^T = I, multiplied by rho on the left and rho^T on the right; rho rho^T = 16 I = 0);
  (4) pairing rank: sum_{a in P, c in Q} n[a][c] <= rank G[P, Q] (lazy cuts, heuristic separation).
Infeasibility of (1)-(4) would prove that no frame exists (all are necessary).
"""
import sys, json, random, time
import numpy as np
from scipy.optimize import milp, LinearConstraint, Bounds
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from common import X, Z, dot, blk, rank
N = 45
Grow = [sum(dot(X[i], Z[j]) << j for j in range(720)) for i in range(720)]
def circ(a, c): return [(Grow[16 * a + s] >> (16 * c)) & 0xffff for s in range(16)]
def max_induced_exact(rows):
    # columns adjacency
    cols = [0] * 16
    for s in range(16):
        for u in range(16):
            if rows[s] >> u & 1: cols[u] |= 1 << s
    edges = [(s, u) for s in range(16) for u in range(16) if rows[s] >> u & 1]
    best = 0
    # choose edges in order; maintain forbidden rows/cols (adjacent to chosen edges)
    def rec(k, i, forbR, forbC):
        nonlocal best
        if k > best: best = k
        if k + (16 - bin(forbR).count('1')) <= best: return
        for idx in range(i, len(edges)):
            s, u = edges[idx]
            if forbR >> s & 1 or forbC >> u & 1: continue
            rec(k + 1, idx + 1, forbR | cols[u] | (1 << s), forbC | rows[s] | (1 << u))
    rec(0, 0, 0, 0)
    return best
def rho(v): return sum((blk(v, b).bit_count() & 1) << b for b in range(8))
def compute_nu():
    t0 = time.time()
    nu = {}
    for a in range(N):
        for c in range(N):
            rows = circ(a, c)
            if any(rows): nu[(a, c)] = max_induced_exact(rows)
    print('orbit pairs with edges', len(nu), 'nu histogram', {k: list(nu.values()).count(k) for k in sorted(set(nu.values()))}, f'{time.time()-t0:.1f}s', flush=True)
    json.dump({f'{a},{c}': v for (a, c), v in nu.items()}, open('nu.json', 'w'))
    rx = [rho(X[16 * a]) for a in range(N)]; rz = [rho(Z[16 * c]) for c in range(N)]
    print('residues X', [format(r, '08b') for r in rx]); print('residues Z', [format(r, '08b') for r in rz])

def rank_PQ(P, Q, cache={}):
    key = (P, Q)
    if key in cache: return cache[key]
    colmask = 0
    for c in range(N):
        if Q >> c & 1: colmask |= 0xffff << (16 * c)
    r = rank([Grow[16 * a + t] & colmask for a in range(N) if P >> a & 1 for t in range(16)])
    cache[key] = r; return r

def build_and_solve(nu, cuts, parity=True, total=128, time_limit=600):
    pairs = sorted(nu); idx = {p: k for k, p in enumerate(pairs)}
    nv = len(pairs) + (64 if parity else 0)
    rows, lo, hi = [], [], []
    def row(coefs, l, h):
        v = np.zeros(nv)
        for k, c in coefs: v[k] += c
        rows.append(v); lo.append(l); hi.append(h)
    row([(k, 1) for k in range(len(pairs))], total, total)
    for a in range(N):
        row([(idx[p], 1) for p in pairs if p[0] == a], 0, 16)
        row([(idx[p], 1) for p in pairs if p[1] == a], 0, 16)
    if parity:
        rx = [rho(X[16 * a]) for a in range(N)]; rz = [rho(Z[16 * c]) for c in range(N)]
        for p_ in range(8):
            for q_ in range(8):
                coefs = [(idx[(a, c)], 1) for (a, c) in pairs if rx[a] >> p_ & 1 and rz[c] >> q_ & 1]
                coefs.append((len(pairs) + 8 * p_ + q_, -2))
                row(coefs, 0, 0)
    for (P, Q, r) in cuts:
        row([(idx[(a, c)], 1) for (a, c) in pairs if P >> a & 1 and Q >> c & 1], 0, r)
    ub = np.array([nu[p] for p in pairs] + ([64] * 64 if parity else []), dtype=float)
    res = milp(np.zeros(nv), constraints=LinearConstraint(np.array(rows), lo, hi),
               integrality=np.ones(nv), bounds=Bounds(np.zeros(nv), ub),
               options={'time_limit': time_limit, 'disp': False})
    if res.x is None: return res.status, res.message, None
    m = np.zeros((N, N))
    for (a, c), k in idx.items(): m[a, c] = round(res.x[k])
    return res.status, res.message, m

def violation(P, Q, m):
    rws = [a for a in range(N) if P >> a & 1]; cls = [c for c in range(N) if Q >> c & 1]
    return m[np.ix_(rws, cls)].sum() - rank_PQ(P, Q)

def separate(m, tries, rnd):
    found = {}
    sup_r = [a for a in range(N) if m[a].sum() > 0]; sup_c = [c for c in range(N) if m[:, c].sum() > 0]
    for _ in range(tries):
        P = 0; Q = 0
        for a in sup_r:
            if rnd.random() < 0.5: P |= 1 << a
        for c in sup_c:
            if rnd.random() < 0.5: Q |= 1 << c
        if not P or not Q: continue
        v = violation(P, Q, m); improved = True
        while improved:
            improved = False
            for k in rnd.sample(range(2 * N), 2 * N):
                P2, Q2 = (P ^ (1 << k), Q) if k < N else (P, Q ^ (1 << (k - N)))
                if not P2 or not Q2: continue
                v2 = violation(P2, Q2, m)
                if v2 > v + 1e-9: P, Q, v, improved = P2, Q2, v2, True
        if v > 0.5: found[(P, Q)] = v
    return sorted(found.items(), key=lambda kv: -kv[1])

def main():
    import argparse
    ap = argparse.ArgumentParser(); ap.add_argument('--no-parity', action='store_true')
    ap.add_argument('--rounds', type=int, default=60); ap.add_argument('--seed', type=int, default=0)
    ap.add_argument('--out', default='ilp_run.json')
    a_ = ap.parse_args()
    import os
    if not os.path.exists('nu.json'): compute_nu()
    nu = {tuple(map(int, k.split(','))): v for k, v in json.load(open('nu.json')).items()}
    cuts = []
    for a in range(N):   # single-orbit rows/cols
        cuts.append((1 << a, (1 << N) - 1, rank_PQ(1 << a, (1 << N) - 1)))
        cuts.append(((1 << N) - 1, 1 << a, rank_PQ((1 << N) - 1, 1 << a)))
    rnd = random.Random(a_.seed); log = []
    for rd in range(a_.rounds):
        t0 = time.time()
        st, msg, m = build_and_solve(nu, cuts, parity=not a_.no_parity)
        if m is None:
            print(f'round {rd}: ILP status {st} ({msg}) with {len(cuts)} cuts', flush=True)
            log.append({'round': rd, 'status': st, 'msg': msg, 'cuts': len(cuts)}); break
        new = separate(m, 300, rnd)
        print(f'round {rd}: ILP feasible, {len(cuts)} cuts, solve {time.time()-t0:.1f}s, new violated {len(new)}, max viol {new[0][1] if new else 0}', flush=True)
        log.append({'round': rd, 'status': st, 'cuts': len(cuts), 'new': len(new)})
        if not new:
            print('no violated cut found by heuristic separation; integer point:'); 
            nz = [(a, c, int(m[a, c])) for a in range(N) for c in range(N) if m[a, c]]
            print(nz); log.append({'final_point': nz}); break
        for (P, Q), v in new[:40]: cuts.append((P, Q, rank_PQ(P, Q)))
    json.dump({'log': log, 'cuts': [(str(P), str(Q), r) for P, Q, r in cuts]}, open(a_.out, 'w'))
if __name__ == '__main__': main()
