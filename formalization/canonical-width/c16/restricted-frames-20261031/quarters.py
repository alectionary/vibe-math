"""Human-checkable reason for the quarter obstructions.
For each quarter H (two blocks, a 32-dim space) list pool sizes and ranks; when a side
has exactly 32 vectors of rank 32 it must be the whole frame side, so the other side is
forced to be its dual basis. Report how many forced dual vectors lie in the other pool."""
import json
import numpy as np
from common import *

X, Z = load_pools()
SX, SZ = set(X), set(Z)
def dual_basis(vs, bitpos):
    # rows: vs restricted to coordinates bitpos; return dual basis as ints (inverse transpose)
    n = len(bitpos)
    A = np.array([[(v >> p) & 1 for p in bitpos] for v in vs], dtype=np.uint8)
    M = np.concatenate([A, np.eye(n, dtype=np.uint8)], 1)
    r = 0
    for c in range(n):
        piv = [k for k in range(r, n) if M[k, c]]
        if not piv: return None
        M[[r, piv[0]]] = M[[piv[0], r]]
        for k in range(n):
            if k != r and M[k, c]: M[k] ^= M[r]
        r += 1
    Ainv = M[:, n:]          # A @ Ainv = I ; dual vectors are columns of Ainv
    return [sum(int(Ainv[i, j]) << bitpos[i] for i in range(n)) for j in range(n)]
res = {}
for H in ([0, 1], [2, 3], [4, 5], [6, 7]):
    m = mask(H); bp = [16 * b + i for b in H for i in range(16)]
    xs = [v for v in X if v & ~m == 0]; zs = [v for v in Z if v & ~m == 0]
    r = {"X": len(xs), "X_rank": rank(xs), "Z": len(zs), "Z_rank": rank(zs)}
    for side, vs, other in (("X", xs, SZ), ("Z", zs, SX)):
        if len(vs) == 32 and rank(vs) == 32:
            D = dual_basis(vs, bp)
            r[f"forced_dual_of_{side}_in_other_pool"] = sum(d in other for d in D)
            r[f"forced_dual_of_{side}_missing_example_hex"] = next((f"{d:032x}" for d in D if d not in other), None)
    res[str(H)] = r
json.dump(res, open(HERE / "results" / "quarters.json", "w"), indent=1)
print(json.dumps(res, indent=1))
