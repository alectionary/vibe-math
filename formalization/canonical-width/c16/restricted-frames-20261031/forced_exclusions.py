"""Pairwise exclusions forced inside a quarter basis.

For quarter H whose sector-P pool vectors B form a basis of W_H, and any frame:
if b in B is selected with partner q (opposite pool), then every other c in B with
<c,q> = 1 is NOT selected. Hence if every opposite-pool vector q with <b,q> = 1 also
satisfies <c,q> = 1, then b and c are never both selected: a forced pairwise
exclusion. (Only the induced-matching condition is used, so this is exact for every
frame, with no quarter-split assumption.)

Output: for each b, the set E(b) = intersection over partners q of pi(q) minus {b},
recorded as T-orbit offset pairs (orbit_b, orbit_c, h) with c = T^h-translate index.
"""
import json
from collections import defaultdict
from common import *

X, Z = load_pools()
out = {}
for H in ([2, 3], [4, 5], [6, 7]):
    m = mask(H)
    for side, P, Q in (("X", X, Z), ("Z", Z, X)):
        Bidx = [k for k, v in enumerate(P) if v & ~m == 0]
        if len(Bidx) != 32 or rank([P[k] for k in Bidx]) != 32:
            continue
        rels = set()
        detail = {}
        for k in Bidx:
            partners = [q for q in Q if bin(P[k] & q).count("1") & 1]
            common = set(Bidx) - {k}
            for q in partners:
                common &= {c for c in Bidx if bin(P[c] & q).count("1") & 1}
            detail[k] = sorted(common)
            for c in common:
                # pool layout: index = 16*orbit + translate offset
                rels.add((k // 16, c // 16, (c % 16 - k % 16) % 16))
        out[f"{H}-{side}"] = {"forced_exclusion_counts": {str(k): len(v) for k, v in detail.items()},
                              "orbit_offset_relations": sorted(rels)}
json.dump(out, open(HERE / "results" / "forced_exclusions.json", "w"), indent=1)
for k, v in out.items():
    print(k, "relations (orbit_b, orbit_c, h):", v["orbit_offset_relations"])
    print("   per-vector exclusion counts:", sorted(set(v["forced_exclusion_counts"].values())))
