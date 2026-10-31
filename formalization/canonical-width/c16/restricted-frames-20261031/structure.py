"""Recompute every structural fact stated in RESTRICTED-FRAMES-20261031.md.
Usage: python3 structure.py  (writes results/structure.json)"""
import itertools, json, collections
from common import *

X, Z = load_pools()
SX, SZ = set(X), set(Z)
G = load_gram()
out = {}
out["gram_symmetric"] = bool((G == G.T).all())
out["closed_under_T"] = {"X": all(shift(v) in SX for v in X), "Z": all(shift(v) in SZ for v in Z)}

def orbits(P, L):
    seen, res = set(), []
    for v in P:
        if v in seen:
            continue
        o = {shift(v, (16 // L) * k) for k in range(L)}
        seen |= o
        res.append(o)
    return res
out["T_orbits"] = {n: [len(orbits(P, 16)), sorted({len(o) for o in orbits(P, 16)})] for n, P in (("X", X), ("Z", Z))}

def units(P):
    u = [v for v in P if bin(v).count("1") == 1]
    return len(u), sorted({(v.bit_length() - 1) // 16 for v in u})
out["unit_vectors"] = {"X": units(X), "Z": units(Z)}
ux = {v for v in X if bin(v).count("1") == 1}
uz = {v for v in Z if bin(v).count("1") == 1}
out["common_unit_vectors"] = len(ux & uz)

# block index b = 4a + 2p + q
halves = {"p0": [0, 1, 4, 5], "p1": [2, 3, 6, 7], "a0": [0, 1, 2, 3], "a1": [4, 5, 6, 7]}
hs = {}
for name, H in halves.items():
    m = mask(H)
    xs = [v for v in X if v & ~m == 0]
    zs = [v for v in Z if v & ~m == 0]
    hs[name] = {"blocks": H, "X": len(xs), "X_rank": rank(xs), "Z": len(zs), "Z_rank": rank(zs)}
out["half_subpools"] = hs

def blockperm(v, perm):  # block b of v moves to block perm[b]
    return sum(w << (16 * perm[b]) for b, w in enumerate(blocks(v)))
m0, m1 = mask(halves["p0"]), mask(halves["p1"])
Zp0 = {v for v in Z if v & ~m0 == 0}
Zp1 = {v for v in Z if v & ~m1 == 0}
sh = {0: 2, 1: 3, 4: 6, 5: 7, 2: 0, 3: 1, 6: 4, 7: 5}
out["Z_p1_equals_Z_p0_block_shifted_0to2_1to3_4to6_5to7"] = {blockperm(v, sh) for v in Zp0} == Zp1

# valuation-profile-preserving block permutations
VX = sorted(tuple(val(w) for w in blocks(v)) for v in X)
VZ = sorted(tuple(val(w) for w in blocks(v)) for v in Z)
def pv(V, sg):
    return sorted(tuple(t[sg[b]] for b in range(8)) for t in V)
out["valuation_preserving_block_perms"] = [list(sg) for sg in itertools.permutations(range(8)) if pv(VX, sg) == VX and pv(VZ, sg) == VZ]
out["valuation_X_to_Z_block_perms"] = [list(sg) for sg in itertools.permutations(range(8)) if pv(VX, sg) == VZ]

# per-pair GL2(F2) maps on block pairs (2g,2g+1): X -> X with Z -> Z by inverse transpose
mats = [((a, b), (c, d)) for a, b, c, d in itertools.product((0, 1), repeat=4) if (a * d + b * c) % 2 == 1]
def invT(M):
    (a, b), (c, d) = M
    return ((d, c), (b, a))
def app4(Ms, v):
    b = blocks(v); o = [0] * 8
    for g in range(4):
        u0, u1 = b[2 * g], b[2 * g + 1]; (a, bb), (c, d) = Ms[g]
        o[2 * g] = (u0 if a else 0) ^ (u1 if bb else 0)
        o[2 * g + 1] = (u0 if c else 0) ^ (u1 if d else 0)
    return sum(w << (16 * i) for i, w in enumerate(o))
good = [Ms for Ms in itertools.product(mats, repeat=4)
        if all(app4(Ms, v) in SX for v in X) and all(app4([invT(M) for M in Ms], v) in SZ for v in Z)]
out["blockpair_GL2_pool_automorphisms"] = len(good)
r3 = ((0, 1), (1, 1))
Xp0 = [v for v in X if v & ~m0 == 0]
out["X_p0_invariant_under_order3_map_on_each_pair"] = all(app4([r3] * 4, v) in set(Xp0) for v in Xp0)
json.dump(out, open(HERE / "results" / "structure.json", "w"), indent=1)
print(json.dumps(out, indent=1))
