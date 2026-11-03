"""32-dimensional orbit flats: closures of two X orbits (and of two Z orbits) of rank 32.
(1) Whole-flat test: if a frame contains 32 X vectors from flat F (necessarily spanning F), its other
    96 Z vectors lie in F^perp: need rank(Z pool cap F^perp) >= 96.
(2) Pair test: for X flat F and Z flat F2 with nondegenerate pairing, a local frame of (F, F2) in a
    frame forces a frame of the complement pair (F2^perp, F^perp) (Lemma A); search both sides."""
import itertools, json, sys
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from common import X, Z, dot
from subspace_frames import Span, local_and_complement
def flats(P):
    seen = {}
    for a, b in itertools.combinations(range(45), 2):
        S = Span(P[16*a:16*a+16] + P[16*b:16*b+16])
        if len(S) != 32: continue
        orbs = tuple(c for c in range(45) if all(S.coeffs(v) is not None for v in P[16*c:16*c+16]))
        seen[orbs] = S
    return seen
FX, FZ = flats(X), flats(Z)
print('X flats of rank 32:', len(FX), 'with >2 orbits:', sum(len(k) > 2 for k in FX)); print('Z flats:', len(FZ))
whole = {}
for side, F, Q in (('X', FX, Z), ('Z', FZ, X)):
    for orbs, S in F.items():
        if len(orbs) < 3: continue     # two-orbit flats: covered by the single-orbit test (contains a whole orbit)
        r = len(Span([q for q in Q if all(dot(b, q) == 0 for b in S.basis)]))
        whole[f'{side}{orbs}'] = r
print('3+-orbit flats and rank of orthogonal opposite pool:', whole)
pairs = []
big = [o for o in FX if len(o) > 2]; bigz = [o for o in FZ if len(o) > 2]
for ox in big:
    for oz in bigz:
        r = local_and_complement(list(ox[:2]), list(oz[:2]), f'f{"_".join(map(str, ox))}-{"_".join(map(str, oz))}', knuth_cap=2e4)
        if r.get('status') == 'DEGENERATE': continue
        pairs.append(r); print(ox, oz, r.get('local'), r.get('complement_ranks'), r.get('complement'), flush=True)
json.dump({'whole': whole, 'pairs': pairs}, open('flat_split.json', 'w'), indent=1)
