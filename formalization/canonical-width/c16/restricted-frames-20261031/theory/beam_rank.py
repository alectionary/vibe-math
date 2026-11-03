"""How deep can a partial frame stay rank-consistent? (theory push, direction b)

A partial frame C (pairs (i, j), G[C_S, C_T] = identity) is *rank-consistent* if it passes the
la_gen -l test: with X' (Z') the unused pool vectors orthogonal to every chosen Z (X) vector that
still have a live partner, rank G[X', Z'] >= 128 - |C|. Every subset of a frame is rank-consistent.
Surviving nodes always have rank = need exactly, so the beam maximises the number of live pairs; reports the largest rank-consistent partial frame found.
Heuristic (lower bound on the true maximum), not exhaustive.
"""
import sys, random, time, json, argparse
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from common import X, Z, dot, rank
ap = argparse.ArgumentParser(); ap.add_argument('--width', type=int, default=12); ap.add_argument('--branch', type=int, default=20)
ap.add_argument('--seed', type=int, default=0); ap.add_argument('--out', default='beam.json'); args = ap.parse_args()
rnd = random.Random(args.seed)
Grow = [sum(dot(X[i], Z[j]) << j for j in range(720)) for i in range(720)]
Gcol = [sum(dot(X[i], Z[j]) << i for i in range(720)) for j in range(720)]
ALL = (1 << 720) - 1
orthX_of_z = [ALL ^ Gcol[j] for j in range(720)]   # x's orthogonal to z_j
orthZ_of_x = [ALL ^ Grow[i] for i in range(720)]
def bits(m):
    while m:
        b = m & -m; yield b.bit_length() - 1; m ^= b
def evaluate(ax, az):
    # live sides: x alive with some alive partner, z alive with some alive partner
    lx = [i for i in bits(ax) if Grow[i] & az]
    lzmask = 0
    for i in lx: lzmask |= Grow[i] & az
    r = rank([Grow[i] & lzmask for i in lx])
    return r, lx, lzmask
state0 = (0, ALL, ALL, ())   # (k, alive_x, alive_z, pairs)
beam = [state0]; best = (0, ()); hist = []
t0 = time.time()
for depth in range(128):
    children = []
    for k, ax, az, pr in beam:
        r, lx, lz = evaluate(ax, az)
        cand = [(i, j) for i in lx for j in bits(Grow[i] & lz)]
        for i, j in rnd.sample(cand, min(args.branch, len(cand))):
            ax2 = ax & orthX_of_z[j] & ~(1 << i); az2 = az & orthZ_of_x[i] & ~(1 << j)
            r2, lx2, lz2 = evaluate(ax2, az2)
            if r2 >= 128 - (k + 1):   # survives the -l rank test (r2 can never exceed need)
                live = sum((Grow[x] & lz2).bit_count() for x in lx2)
                children.append((live + rnd.random(), (k + 1, ax2, az2, pr + ((i, j),))))
    if not children: break
    children.sort(key=lambda t: -t[0])
    seen = set(); beam = []
    for s, st in children:
        key = frozenset(st[3])
        if key in seen: continue
        seen.add(key); beam.append(st)
        if len(beam) >= args.width: break
    best = (beam[0][0], beam[0][3]); hist.append((depth + 1, round(children[0][0], 1)))
    print(f'depth {depth+1}: {len(children)} surviving children, most live pairs {children[0][0]:.0f}, {time.time()-t0:.0f}s', flush=True)
# verify best is a partial frame
P = best[1]
assert all(dot(X[i], Z[j]) == (a == b) for a, (i, _) in enumerate(P) for b, (_, j) in enumerate(P))
print('largest rank-consistent partial frame found:', best[0], 'pairs')
json.dump({'size': best[0], 'pairs': P, 'slack_history': hist, 'width': args.width, 'branch': args.branch, 'seed': args.seed}, open(args.out, 'w'))
