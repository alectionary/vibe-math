"""CNF for frames invariant under the subgroup <T^(16/L)> of order L.
Usage: python3 subgroup_cnf.py L out.cnf   (also writes out.cnf.map.json)

Variables 1..n select X orbits, n+1..2n select Z orbits. For orbit pair (P,Q),
cnt = number of j with <x_P, T^(dj) z_Q> = 1. A selected pair with cnt>=2 is
forbidden; each selected orbit has exactly one selected partner with cnt=1;
every orbit (selected or not) meets some selected orbit on the other side;
at least 128/L X orbits are selected.  Equivalent to: an invariant 128-pair
frame exists iff SAT (orbits are all of full size L here)."""
import sys, json
import numpy as np
from common import *

L = int(sys.argv[1]); out = sys.argv[2]
d = 16 // L
X, Z = load_pools(); G = load_gram()
ix = {v: i for i, v in enumerate(X)}; iz = {v: i for i, v in enumerate(Z)}
def orbs(P, idx):
    seen, res = set(), []
    for v in P:
        if idx[v] in seen:
            continue
        o = [idx[shift(v, d * k)] for k in range(L)]
        seen |= set(o); res.append(o)
    return res
OX, OZ = orbs(X, ix), orbs(Z, iz)
assert all(len(set(o)) == L for o in OX + OZ)
cnt = np.array([G[o[0]][np.array(OZ)].sum(1) for o in OX])
n = len(OX); K = 128 // L
e = Enc()
x = [e.new() for _ in range(n)]; z = [e.new() for _ in range(n)]
for P in range(n):
    for Q in np.nonzero(cnt[P] >= 2)[0]:
        e.cl.append([-x[P], -z[Q]])
for P in range(n): e.guarded_exactly_one(x[P], [z[Q] for Q in np.nonzero(cnt[P] == 1)[0]])
for Q in range(n): e.guarded_exactly_one(z[Q], [x[P] for P in np.nonzero(cnt[:, Q] == 1)[0]])
for P in range(n): e.cl.append([z[Q] for Q in np.nonzero(cnt[P] >= 1)[0]])
for Q in range(n): e.cl.append([x[P] for P in np.nonzero(cnt[:, Q] >= 1)[0]])
e.at_most([-v for v in x], n - K)
write_cnf(out, e.nv, e.cl)
json.dump({"L": L, "OX": OX, "OZ": OZ, "x_vars": [1, n], "z_vars": [n + 1, 2 * n]}, open(out + ".map.json", "w"))
print(json.dumps({"L": L, "orbits": n, "unit": int((cnt == 1).sum()), "zero": int((cnt == 0).sum()),
                  "other": int((cnt > 1).sum()), "vars": e.nv, "clauses": len(e.cl)}))
