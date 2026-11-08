"""Global consequence of the quarter structure.

Lemma (written). Let W = span(e_i : i in quarter H) and let B be the set of
pool vectors of one sector supported in H. Suppose B is a basis of W (|B| = 32).
If a frame contains every vector of B, then the partner q_b of each b in B
satisfies <b', q_b> = [b = b'] for b' in B, and since b' is supported in H this
only involves q_b|_H. Hence q_b|_H = d_b, the dual basis vector. So every d_b
must be the H-restriction of some opposite-pool vector.

More generally, for any subset A of B in the frame, q_a|_H is a dual system for A
inside W. This script reports, per quarter/side, the count of opposite-pool vectors
realizing each forced restriction d_b, and the T-orbit decomposition of B.
"""
import json
from common import *

X, Z = load_pools()
res = {}
for H in ([2, 3], [4, 5], [6, 7]):
    m = mask(H); bp = [16 * b + i for b in H for i in range(16)]
    for side, P, Q in (("X", X, Z), ("Z", Z, X)):
        B = [v for v in P if v & ~m == 0]
        if not (len(B) == 32 and rank(B) == 32):
            continue
        D = dual_basis(B, bp)
        realized = [sum(1 for q in Q if q & m == d) for d in D]
        orbit_ids = sorted({P.index(v) // 16 for v in B})
        per_orbit = {}
        for o in orbit_ids:
            idx = [k for k, v in enumerate(B) if P.index(v) // 16 == o]
            per_orbit[o] = {"vectors": len(idx), "forced_duals_realized": sum(realized[k] > 0 for k in idx),
                            "min_realizers": min(realized[k] for k in idx)}
        res[f"{H}-{side}"] = {"B_orbits": orbit_ids, "forced_duals_realized_by_opposite_pool_restriction":
                              sum(r > 0 for r in realized), "realizer_counts": realized, "per_orbit": per_orbit}
json.dump(res, open(HERE / "results" / "global_quarter.json", "w"), indent=1)
for k, v in res.items():
    print(k, "orbits", v["B_orbits"], "realized", v["forced_duals_realized_by_opposite_pool_restriction"], "/32", v["per_orbit"])
