"""If a frame contains all 16 vectors of X orbit a, its other 112 Z vectors are orthogonal to span(X_a)
and independent, so rank{z in Z pool : z perp X_a} >= 112 is necessary (and symmetrically for Z orbits).
Also for 32-dimensional orbit flats (closures of two orbits): a frame containing 32 independent pool
vectors from the flat F has its other 96 Z vectors in F^perp."""
import json, sys, itertools
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from common import X, Z, dot, rank
from subspace_frames import Span
res = {'X': [], 'Z': []}
for a in range(45):
    ox = X[16*a:16*a+16]; oz = Z[16*a:16*a+16]
    rz = rank([z for z in Z if all(dot(x, z) == 0 for x in ox)])
    rx = rank([x for x in X if all(dot(x, z) == 0 for z in oz)])
    res['X'].append(rz); res['Z'].append(rx)
print('X orbits: rank of orthogonal Z pool', res['X'])
print('Z orbits: rank of orthogonal X pool', res['Z'])
print('X orbits that can be whole in a frame (rank>=112):', [a for a in range(45) if res['X'][a] >= 112])
print('Z orbits that can be whole in a frame:', [a for a in range(45) if res['Z'][a] >= 112])
json.dump(res, open('whole_orbit.json', 'w'))
