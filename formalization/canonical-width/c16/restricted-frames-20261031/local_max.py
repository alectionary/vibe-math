"""Largest selection A of a quarter basis B compatible with the frame condition:
every a in A needs an opposite-pool partner q with {c in A : <c,q>=1} = {a}.
Encodes 'at least k selected' and asks Kissat; scans k. Usage: python3 local_max.py KISSAT"""
import json, subprocess, sys
from common import *

kissat = sys.argv[1]
X, Z = load_pools()
res = {}
for H in ([2, 3], [4, 5], [6, 7]):
    m = mask(H)
    for side, P, Q in (("X", X, Z), ("Z", Z, X)):
        Bidx = [k for k, v in enumerate(P) if v & ~m == 0]
        if len(Bidx) != 32:
            continue
        pats = sorted({sum(1 << i for i, k in enumerate(Bidx) if bin(P[k] & q).count("1") & 1) for q in Q} - {0})
        best = None
        for K in range(1, 33):
            e = Enc()
            a = [e.new() for _ in Bidx]
            # y[i][t]: a_i uses pattern t as its partner pattern
            for i in range(32):
                ys = []
                for pt in pats:
                    if not (pt >> i) & 1:
                        continue
                    y = e.new(); ys.append(y)
                    for j in range(32):
                        if j != i and (pt >> j) & 1:
                            e.cl.append([-y, -a[j]])
                e.cl.append([-a[i]] + ys)
            e.at_most([-v for v in a], 32 - K)
            write_cnf("work/lm.cnf", e.nv, e.cl)
            r = subprocess.run([kissat, "-q", "work/lm.cnf"], capture_output=True, text=True).stdout
            if "s SATISFIABLE" in r:
                best = K
            else:
                break
        res[f"{H}-{side}"] = {"distinct_partner_patterns": len(pats), "max_feasible_selection": best,
                              "first_infeasible_size_UNSAT": best + 1}
        print(H, side, res[f"{H}-{side}"], flush=True)
json.dump(res, open(HERE / "results" / "local_max.json", "w"), indent=1)
