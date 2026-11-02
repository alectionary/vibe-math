"""Small cocircuits of the pool matroids: functionals u with few pool vectors x having <u,x> = 1.
A frame must use at least one pool vector outside every hyperplane, so small cocircuits give narrow branching.
Searches unit vectors and random information sets (Prange-style) for low-weight codewords of the
[720,128] code {(<u,x>)_x}."""
import random, sys
from pathlib import Path
root = Path(__file__).resolve().parents[2]
P = {s: [int(v, 16) for v in (root / f'pools/{s.lower()}coords.txt').read_text().split()] for s in 'XZ'}
dot = lambda u, v: bin(u & v).count('1') & 1
def wt(u, pool): return sum(dot(u, x) for x in pool)
rnd = random.Random(1)
for side, pool in P.items():
    unit = sorted(wt(1 << c, pool) for c in range(128))
    print(side, 'unit-vector cocircuit sizes min/median/max', unit[0], unit[64], unit[-1])
    best = {}
    n = len(pool)
    for it in range(int(sys.argv[1]) if len(sys.argv) > 1 else 300):
        # choose 127 independent pool vectors at random; u = functional that is 0 on them except one -> weight on the rest
        order = list(range(n)); rnd.shuffle(order)
        piv = {}; basis = []
        for i in order:
            v = pool[i]; e = 1 << len(basis)
            vv, ee = v, 0
            while vv:
                h = vv.bit_length() - 1
                if h not in piv: break
                pv, pe = piv[h]; vv ^= pv; ee ^= pe
            if vv:
                piv[vv.bit_length() - 1] = (vv, ee ^ (1 << len(basis))); basis.append(i)
            if len(basis) == 128: break
        # dual basis of the chosen 128: solve u_j with <u_j, x_basis_k> = delta
        # matrix A rows = basis vectors; dual = columns of A^{-1}
        A = [pool[i] for i in basis]; m = [(A[i] << 128) | (1 << i) for i in range(128)]
        for col in range(128):
            p = next(r for r in range(col, 128) if (m[r] >> (128 + col)) & 1)
            m[col], m[p] = m[p], m[col]
            for r in range(128):
                if r != col and (m[r] >> (128 + col)) & 1: m[r] ^= m[col]
        inv = [m[i] & ((1 << 128) - 1) for i in range(128)]
        for j in range(128):
            u = sum(((inv[c] >> j) & 1) << c for c in range(128))
            w = wt(u, pool)
            best[w] = best.get(w, 0) + 1
    ks = sorted(best)[:8]
    print(side, 'smallest cocircuits found (size: count of hits)', {k: best[k] for k in ks})
