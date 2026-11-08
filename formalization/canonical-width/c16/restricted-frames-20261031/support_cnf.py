"""CNF for a frame of span(e_i : i in blocks H) using only pool vectors supported in H.
Usage: python3 support_cnf.py '[2,3,6,7]' out.cnf   (also writes out.cnf.map.json)
Needs exactly 16|H| pairs. Variables 1..|xs| select X vectors, then Z vectors."""
import sys, json
import numpy as np
from common import *

H = json.loads(sys.argv[1]); out = sys.argv[2]
X, Z = load_pools(); G = load_gram()
m = mask(H)
xs = [i for i, v in enumerate(X) if v & ~m == 0]
zs = [i for i, v in enumerate(Z) if v & ~m == 0]
K = 16 * len(H)
g = G[np.ix_(xs, zs)]
e = Enc()
x = [e.new() for _ in xs]; z = [e.new() for _ in zs]
for a in range(len(xs)): e.guarded_exactly_one(x[a], [z[b] for b in np.nonzero(g[a])[0]])
for b in range(len(zs)): e.guarded_exactly_one(z[b], [x[a] for a in np.nonzero(g[:, b])[0]])
for a in range(len(xs)): e.cl.append([z[b] for b in np.nonzero(g[a])[0]])
for b in range(len(zs)): e.cl.append([x[a] for a in np.nonzero(g[:, b])[0]])
e.at_most([-v for v in x], len(xs) - K)
write_cnf(out, e.nv, e.cl)
json.dump({"H": H, "xs": xs, "zs": zs}, open(out + ".map.json", "w"))
print(json.dumps({"H": H, "X": len(xs), "Z": len(zs), "pairs_needed": K, "vars": e.nv, "clauses": len(e.cl)}))
