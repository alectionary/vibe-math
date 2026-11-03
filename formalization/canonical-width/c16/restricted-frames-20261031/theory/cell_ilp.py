"""Cell-level integer model: cells = (orbit a, position s mod m), m in {1,2,4,8}.

n[(a,σ),(c,τ)] = number of frame pairs with x = T^s x_a (s ≡ σ mod m), z = T^u z_c (u ≡ τ mod m).
Necessary conditions:
  caps: n <= nu (max induced matching of the 16/m x 16/m sub-block), cell row/col sums <= 16/m, total 128;
  folded parity: sum n * (A x)(A z)^T = A A^T = (16/m) I = 0 over F2, where A sums coordinates of
    equal position mod m inside each block (A x depends only on the cell);
  pairing rank: sum over P x Q <= rank G[P, Q] for cell sets P, Q (lazy, heuristic separation).
Any infeasibility proves no frame.
"""
import sys, json, random, time, argparse
import numpy as np
from scipy.optimize import milp, LinearConstraint, Bounds
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from common import X, Z, dot, blk, rank
from orbit_ilp import max_induced_exact
ap = argparse.ArgumentParser(); ap.add_argument('m', type=int); ap.add_argument('--rounds', type=int, default=30)
ap.add_argument('--tries', type=int, default=120); ap.add_argument('--seed', type=int, default=0)
ap.add_argument('--no-parity', action='store_true'); ap.add_argument('--lp', action='store_true'); ap.add_argument('--cover', action='store_true'); ap.add_argument('--time', type=float, default=900)
args = ap.parse_args(); m = args.m; L = 16 // m
NC = 45 * m
def cell(i): return (i // 16) * m + (i % 16) % m
members = [[16 * (k // m) + s for s in range(k % m, 16, m)] for k in range(NC)]
Grow = [sum(dot(X[i], Z[j]) << j for j in range(720)) for i in range(720)]
t0 = time.time()
nu = {}
for p in range(NC):
    for q in range(NC):
        rows = []
        for i in members[p]:
            rows.append(sum(((Grow[i] >> j) & 1) << k for k, j in enumerate(members[q])))
        if any(rows):
            # reuse 16x16 routine by padding
            nu[(p, q)] = max_induced_exact(rows + [0] * (16 - L)) if L < 16 else max_induced_exact(rows)
print(f'm={m}: {len(nu)} cell pairs with edges, nu computed in {time.time()-t0:.0f}s', flush=True)
def fold(v):
    out = 0
    for b in range(8):
        w = blk(v, b)
        for r in range(m):
            par = 0
            for s in range(r, 16, m): par ^= (w >> s) & 1
            out |= par << (b * m + r)
    return out
FX = [fold(X[members[p][0]]) for p in range(NC)]; FZ = [fold(Z[members[q][0]]) for q in range(NC)]
assert all(fold(X[i]) == FX[p] for p in range(NC) for i in members[p])
D = 8 * m
pairs = sorted(nu); idx = {p: k for k, p in enumerate(pairs)}
cmask = [sum(1 << j for j in members[q]) for q in range(NC)]
rcache = {}
def rank_PQ(P, Q):
    key = (P, Q)
    if key not in rcache:
        colmask = 0
        for q in Q: colmask |= cmask[q]
        rcache[key] = rank([Grow[i] & colmask for p in P for i in members[p]])
    return rcache[key]
base_rows = []
def mkrow(coefs, lo, hi, nv):
    v = np.zeros(nv)
    for k, c in coefs: v[k] += c
    return v, lo, hi
npar = 0 if (args.no_parity or args.lp) else D * D
nv = len(pairs) + npar
rows = [mkrow([(k, 1) for k in range(len(pairs))], 0 if args.lp else 128, 128, nv)]
for p in range(NC):
    rows.append(mkrow([(idx[x], 1) for x in pairs if x[0] == p], 0, L, nv))
    rows.append(mkrow([(idx[x], 1) for x in pairs if x[1] == p], 0, L, nv))
if npar:
    for a in range(D):
        for b in range(D):
            coefs = [(idx[(p, q)], 1) for (p, q) in pairs if FX[p] >> a & 1 and FZ[q] >> b & 1]
            coefs.append((len(pairs) + a * D + b, -2)); rows.append(mkrow(coefs, 0, 0, nv))
if args.cover:
    # covering: sum_i x_i[c] z_i[c] = 1, so some frame pair has x[c] = z[c] = 1; it lies in a cell pair of Cov(c)
    ncov = 0
    for c in range(128):
        zc = sum(1 << j for j in range(720) if Z[j] >> c & 1)
        cov = set()
        for i in range(720):
            if X[i] >> c & 1:
                hit = Grow[i] & zc
                while hit:
                    b = hit & -hit; hit ^= b; cov.add((cell(i), cell(b.bit_length() - 1)))
        rows.append(mkrow([(idx[x], 1) for x in cov], 1, 128, nv)); ncov += 1
    print('covering constraints', ncov, flush=True)
cuts = []
for p in range(NC):
    cuts.append(((p,), tuple(range(NC)))); cuts.append((tuple(range(NC)), (p,)))
ub = np.array([nu[x] for x in pairs] + [D * D] * npar, dtype=float)
rnd = random.Random(args.seed)
for rd in range(args.rounds):
    t1 = time.time()
    allrows = rows + [mkrow([(idx[(p, q)], 1) for p in P for q in Q if (p, q) in idx], 0, rank_PQ(P, Q), nv) for P, Q in cuts]
    A = np.array([r[0] for r in allrows]); lo = [r[1] for r in allrows]; hi = [r[2] for r in allrows]
    obj = -np.ones(nv) if args.lp else np.zeros(nv)
    if args.lp: obj[len(pairs):] = 0
    res = milp(obj, constraints=LinearConstraint(A, lo, hi), integrality=np.zeros(nv) if args.lp else np.ones(nv),
               bounds=Bounds(np.zeros(nv), ub), options={'time_limit': args.time})
    if res.x is None:
        print(f'round {rd}: status {res.status}: {res.message} ({len(cuts)} cuts, {time.time()-t1:.0f}s)', flush=True); break
    n = {x: (res.x[k] if args.lp else round(res.x[k])) for x, k in idx.items() if res.x[k] > 1e-7}
    if args.lp: print(f'round {rd}: LP optimum {-res.fun:.4f}', flush=True)
    supR = sorted({p for p, q in n}); supC = sorted({q for p, q in n})
    def viol(P, Q): return sum(n.get((p, q), 0) for p in P for q in Q) - rank_PQ(P, Q)
    found = {}
    for t_ in range(args.tries):
        if t_ == 0: P, Q = set(supR), set(supC)      # always try the full support first
        elif t_ < args.tries // 3: P = {p for p in supR if rnd.random() < 0.9}; Q = {q for q in supC if rnd.random() < 0.9}
        else: P = {p for p in supR if rnd.random() < 0.5}; Q = {q for q in supC if rnd.random() < 0.5}
        if not P or not Q: continue
        v = viol(tuple(sorted(P)), tuple(sorted(Q))); imp = True
        while imp:
            imp = False
            moves = [('r', p) for p in supR] + [('c', q) for q in supC]; rnd.shuffle(moves)
            for kind, e in moves:
                P2, Q2 = set(P), set(Q)
                (P2 if kind == 'r' else Q2).symmetric_difference_update({e})
                if not P2 or not Q2: continue
                v2 = viol(tuple(sorted(P2)), tuple(sorted(Q2)))
                if v2 > v: P, Q, v, imp = P2, Q2, v2, True
        if v > 1e-6: found[(tuple(sorted(P)), tuple(sorted(Q)))] = v
    print(f'round {rd}: feasible, {len(cuts)} cuts, solve+sep {time.time()-t1:.0f}s, violated found {len(found)} (max {max(found.values()) if found else 0})', flush=True)
    if not found:
        print('heuristic separation found no violated rank cut; support size', len(n)); break
    for (P, Q), v in sorted(found.items(), key=lambda kv: -kv[1])[:30]: cuts.append((P, Q))
json.dump({'support': [[int(p), int(q), float(v)] for (p, q), v in n.items()] if res.x is not None else None, 'm': m, 'rounds': rd + 1, 'cuts': len(cuts), 'final_status': ('no solution: ' + str(res.message)) if res.x is None else 'feasible'}, open(f'cell_{"lp" if args.lp else "ilp"}_m{m}.json', 'w'))
