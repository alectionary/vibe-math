"""Independent SAT check that a complement pair has no frame: find S (X side), T (Z side) of the
candidate vectors with |S| >= need and every chosen vertex having exactly one chosen neighbour
(an induced matching of size need = a frame of the complement). No code shared with la/."""
import itertools, json, subprocess, sys
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from common import X, Z, dot
from subspace_frames import Span
def cnf_for(xorbs, zorbs, path):
    UX = Span([v for a in xorbs for v in X[16*a:16*a+16]]); UZ = Span([v for b in zorbs for v in Z[16*b:16*b+16]])
    need = 128 - len(UX)
    xs = [i for i in range(720) if all(dot(X[i], c) == 0 for c in UZ.basis)]
    zs = [j for j in range(720) if all(dot(b, Z[j]) == 0 for b in UX.basis)]
    nb = {('x', i): [j for j in zs if dot(X[i], Z[j])] for i in xs}
    nb.update({('z', j): [i for i in xs if dot(X[i], Z[j])] for j in zs})
    var = {}; 
    for i in xs: var[('x', i)] = len(var) + 1
    for j in zs: var[('z', j)] = len(var) + 1
    cl = []
    for (side, u), ns in nb.items():
        other = 'z' if side == 'x' else 'x'; s = var[(side, u)]; vs = [var[(other, w)] for w in ns]
        cl.append([-s] + vs)                                   # at least one chosen neighbour
        for p, q in itertools.combinations(vs, 2): cl.append([-s, -p, -q])   # at most one
    # sum of X selections >= need: sequential counter on the X variables
    xv = [var[('x', i)] for i in xs]; n = len(xv); nv = len(var)
    # r[k][c]: among first k vars at least c selected (c=1..need)
    def R(k, c): return nv + (k - 1) * need + c
    for k in range(1, n + 1):
        for c in range(1, need + 1):
            r = R(k, c)
            # r(k,c) -> r(k-1,c) or (x_k and r(k-1,c-1))
            prev = R(k - 1, c) if k > 1 else None
            prev1 = (R(k - 1, c - 1) if k > 1 else None) if c > 1 else 'T'
            if prev1 is None: cl.append([-r] + ([prev] if prev else []))  # cannot have c>=2 with k=1 unless prev
            # encode r -> (prev or x_k) and r -> (prev or prev1)
            cl.append([-r] + ([prev] if prev else []) + [xv[k - 1]])
            if prev1 != 'T' and prev1 is not None: cl.append([-r] + ([prev] if prev else []) + [prev1])
    cl.append([R(n, need)])
    top = nv + n * need
    with open(path, 'w') as f:
        f.write(f'p cnf {top} {len(cl)}\n'); f.writelines(' '.join(map(str, c)) + ' 0\n' for c in cl)
    return {'xs': len(xs), 'zs': len(zs), 'need': need, 'vars': top, 'clauses': len(cl)}
if __name__ == '__main__':
    xo = [int(s) for s in sys.argv[1].split(',')]; zo = [int(s) for s in sys.argv[2].split(',')]
    path = sys.argv[3]; info = cnf_for(xo, zo, path); print(json.dumps(info), flush=True)
