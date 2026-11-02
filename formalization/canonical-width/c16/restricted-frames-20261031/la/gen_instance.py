#!/usr/bin/env python3
"""Write la_dfs.c instances from the canonical pools.

  gen_instance.py order L OUT      frames invariant under <T^(16/L)>, L in {1,2,4,8,16}
                                    (L=1 is the unrestricted problem)
  gen_instance.py support B OUT    frames of span(e_i : i in blocks B) from pool
                                    vectors supported in B, e.g. B = 0,1 (32 dims)
"""
import sys
from pathlib import Path
root = Path(__file__).resolve().parents[2]
X = [int(v, 16) for v in (root / 'pools/xcoords.txt').read_text().split()]
Z = [int(v, 16) for v in (root / 'pools/zcoords.txt').read_text().split()]
dot = lambda u, v: bin(u & v).count('1') & 1
def h64(v): return f'{v & (2**64 - 1):x} {v >> 64:x}'

def write(out, groupsX, groupsZ, g, items, dim_mask):
    vx = sorted({i for gr in groupsX for i in gr}); vz = sorted({j for gr in groupsZ for j in gr})
    ix = {v: k for k, v in enumerate(vx)}; iz = {v: k for k, v in enumerate(vz)}
    orth = [''.join('1' if all(dot(X[a], Z[b]) == 0 for a in gx for b in gz) else '0' for gz in groupsZ) for gx in groupsX]
    with open(out, 'w') as f:
        f.write(f'{len(vx)} {len(vz)} {len(groupsX)} {len(groupsZ)} {g} {len(items)} {bin(dim_mask).count("1")}\n{h64(dim_mask)}\n')
        for v in vx: f.write(h64(X[v]) + '\n')
        for v in vz: f.write(h64(Z[v]) + '\n')
        for gr in groupsX: f.write(' '.join(str(ix[i]) for i in gr) + '\n')
        for gr in groupsZ: f.write(' '.join(str(iz[j]) for j in gr) + '\n')
        for (a, b, pairs) in items: f.write(f'{a} {b} ' + ' '.join(f'{ix[x]} {iz[z]}' for x, z in pairs) + '\n')
        for row in orth: f.write(row + '\n')
    print(out, 'groups', len(groupsX), len(groupsZ), 'items', len(items), 'dim', bin(dim_mask).count('1'))

def T(v, k=1): return sum(((((v >> (16*b)) & 0xffff) << k | ((v >> (16*b)) & 0xffff) >> (16 - k)) & 0xffff) << (16*b) for b in range(8))
def plant(seed):
    """Append a random T-invariant frame (8 X orbits, 8 Z orbits) to the pools: a positive control."""
    import random
    rnd = random.Random(seed)
    while True:
        gens = [rnd.getrandbits(128) for _ in range(8)]
        A = [T(gv, t) for gv in gens for t in range(16)]
        # invert A over F2 (rows = vectors); dual basis = rows of (A^-1)^T
        n = 128; M = [(A[i] << n) | (1 << i) for i in range(n)]   # augmented [A | I], bit layout: high n bits = A row
        ok = True
        for col in range(n):
            piv = next((r for r in range(col, n) if (M[r] >> (n + col)) & 1), None)
            if piv is None: ok = False; break
            M[col], M[piv] = M[piv], M[col]
            for r in range(n):
                if r != col and (M[r] >> (n + col)) & 1: M[r] ^= M[col]
        if not ok: continue
        Inv = [M[i] & ((1 << n) - 1) for i in range(n)]          # rows of A^-1 (A^-1 A = I in row form)
        # z_j = column j of A^-1 written as a row: z_j[c] = Inv[c] bit j
        Zd = [sum(((Inv[c] >> j) & 1) << c for c in range(n)) for j in range(n)]
        assert all((bin(A[i] & Zd[j]).count('1') & 1) == (i == j) for i in range(n) for j in range(n))
        for k in range(8):   # Z orbit k must be T-closed: z_{k,t+1} = T z_{k,t}
            assert all(Zd[16*k + t + 1] == T(Zd[16*k + t]) for t in range(15))
        return A, Zd

if __name__ == '__main__':
    args = sys.argv[1:]
    if args[0] == '--plant':
        A, Zd = plant(int(args[1])); X.extend(A); Z.extend(Zd); args = args[2:]
        print('planted 8+8 orbits; pool orbits now', len(X) // 16)
    mode, arg, out = args[:3]
    NORB = len(X) // 16
    if mode == 'order':
        L = int(arg); d = 16 // L
        gX = [[16 * a + p + d * s for s in range(L)] for a in range(NORB) for p in range(d)]
        gZ = gX
        items = []
        for A, ga in enumerate(gX):
            for B, gb in enumerate(gZ):
                bits = [dot(X[ga[0]], Z[gb[h]]) for h in range(L)]
                if sum(bits) == 1:
                    h = bits.index(1)
                    items.append((A, B, [(ga[s], gb[(s + h) % L]) for s in range(L)]))
        write(out, gX, gZ, L, items, 2**128 - 1)
    elif mode == 'support':
        blocks = [int(b) for b in arg.split(',')]
        mask = sum(0xffff << (16 * b) for b in blocks)
        sx = [i for i in range(len(X)) if X[i] & ~mask == 0]; sz = [j for j in range(len(Z)) if Z[j] & ~mask == 0]
        items = [(a, b, [(i, j)]) for a, i in enumerate(sx) for b, j in enumerate(sz) if dot(X[i], Z[j])]
        write(out, [[i] for i in sx], [[j] for j in sz], 1, items, mask)
