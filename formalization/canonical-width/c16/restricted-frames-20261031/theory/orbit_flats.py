"""Orbit 'flats': for unions A of pool orbits, which other pool orbits (and single vectors) lie in span(A)?"""
import itertools, json, sys
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from orbit_data import OX, OZ, basis, in_span
from common import X, Z, rank
def closure(orbs, O, P):
    piv = basis([v for a in orbs for v in O[a]])
    vecs = [i for i, v in enumerate(P) if in_span(piv, v)]
    return len(piv), vecs
res = {}
for side, O, P in (('X', OX, X), ('Z', OZ, Z)):
    extra2 = []
    for A in itertools.combinations(range(45), 2):
        r, vecs = closure(A, O, P)
        own = {16*a + t for a in A for t in range(16)}
        if r < 32 or len(set(vecs) - own):
            extra2.append((A, r, len(vecs)))
    res[side + '2'] = extra2
    print(side, 'pairs with rank<32 or extra pool vectors:', len(extra2), extra2[:10], flush=True)
    extra3 = []
    for A in itertools.combinations(range(45), 3):
        r, vecs = closure(A, O, P)
        own = {16*a + t for a in A for t in range(16)}
        if r < 48 or len(set(vecs) - own):
            extra3.append((A, r, len(vecs)))
    res[side + '3'] = extra3
    print(side, 'triples with rank<48 or extra pool vectors:', len(extra3), extra3[:10], flush=True)
json.dump(res, open('orbit_flats.json', 'w'))
