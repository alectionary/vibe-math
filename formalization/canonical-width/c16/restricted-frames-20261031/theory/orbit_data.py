"""Basic data on pool orbits: span ranks, pairing ranks between orbit spans, pool vectors per span."""
import sys
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from common import X, Z, dot, rank
def basis(vs):
    piv = {}
    for v in vs:
        while v:
            h = v.bit_length() - 1
            if h in piv: v ^= piv[h]
            else: piv[h] = v; break
    return piv
def in_span(piv, v):
    while v:
        h = v.bit_length() - 1
        if h not in piv: return False
        v ^= piv[h]
    return True
OX = [X[16*a:16*a+16] for a in range(45)]; OZ = [Z[16*a:16*a+16] for a in range(45)]
if __name__ == '__main__':
    print('orbit ranks X', sorted({rank(o) for o in OX}), 'Z', sorted({rank(o) for o in OZ}))
    # pairing rank between X orbit a and Z orbit b
    pr = [[rank([sum(dot(x, z) << j for j, z in enumerate(OZ[b])) for x in OX[a]]) for b in range(45)] for a in range(45)]
    from collections import Counter
    print('pairing rank distribution', Counter(r for row in pr for r in row))
    full = [(a, b) for a in range(45) for b in range(45) if pr[a][b] == 16]
    print('nondegenerate orbit pairs', len(full))
    # pool vectors in each orbit span
    cntx = [sum(in_span(basis(OX[a]), v) for v in X) for a in range(45)]
    cntz = [sum(in_span(basis(OZ[b]), v) for v in Z) for b in range(45)]
    print('X pool vectors per X-orbit span', Counter(cntx)); print('Z pool per Z-orbit span', Counter(cntz))
    import json; json.dump({'pair_rank': pr, 'nondeg': full, 'cntx': cntx, 'cntz': cntz}, open('orbit_data.json', 'w'))
