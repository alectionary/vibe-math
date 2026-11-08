"""Shared loaders for the 2026-10-31 restricted-frame checks.

Reads the canonical pools from ../pools (hex, one 128-bit vector per line).
Block b of a vector is bits 16b..16b+15; T rotates every block by one bit.
"""
from pathlib import Path
import numpy as np

HERE = Path(__file__).resolve().parent
POOLS = HERE.parent / "pools"

def load_pools():
    X = [int(l, 16) for l in (POOLS / "xcoords.txt").read_text().split()]
    Z = [int(l, 16) for l in (POOLS / "zcoords.txt").read_text().split()]
    return X, Z

def blocks(v):
    return [(v >> (16 * b)) & 0xFFFF for b in range(8)]

def rot(w, k=1):
    k %= 16
    return ((w << k) | (w >> (16 - k))) & 0xFFFF

def shift(v, k=1):
    """T^k: simultaneous cyclic rotation of all eight 16-bit blocks."""
    return sum(rot(w, k) << (16 * b) for b, w in enumerate(blocks(v)))

def mask(bs):
    return sum(0xFFFF << (16 * b) for b in bs)

def gram(X, Z):
    """G[i,j] = <X_i, Z_j> over F2 (standard dot product)."""
    return np.array([[bin(x & z).count("1") & 1 for z in Z] for x in X], dtype=np.uint8)

def load_gram(cache=HERE / "work" / "G.npy"):
    if cache.exists():
        return np.load(cache)
    X, Z = load_pools()
    G = gram(X, Z)
    cache.parent.mkdir(exist_ok=True)
    np.save(cache, G)
    return G

def rank(vs):
    basis = {}
    for v in vs:
        while v:
            h = v.bit_length() - 1
            if h in basis:
                v ^= basis[h]
            else:
                basis[h] = v
                break
    return len(basis)

def val(w):
    """y-adic valuation of w in F2[x]/(x^16+1), y = 1+x (16 for w = 0)."""
    if w == 0:
        return 16
    j = 0
    while bin(w).count("1") % 2 == 0:
        q = acc = 0
        for i in range(16):
            acc ^= (w >> i) & 1
            q |= acc << i
        w = q
        j += 1
    return j

def write_cnf(path, nv, cl):
    with open(path, "w") as f:
        f.write(f"p cnf {nv} {len(cl)}\n")
        for c in cl:
            f.write(" ".join(map(str, c)) + " 0\n")

class Enc:
    """Tiny CNF builder: guarded exactly-one and Sinz at-most-k."""
    def __init__(self):
        self.nv = 0
        self.cl = []
    def new(self):
        self.nv += 1
        return self.nv
    def guarded_exactly_one(self, guard, lits):
        # guard -> exactly one of lits
        self.cl.append([-guard] + list(lits))
        prev = None
        for l in lits:
            s = self.new()
            self.cl.append([-l, s])
            if prev:
                self.cl.append([-prev, s])
                self.cl.append([-guard, -prev, -l])
            prev = s
    def at_most(self, lits, k):
        if k <= 0:
            for l in lits:
                self.cl.append([-l])
            return
        m = len(lits)
        s = [[self.new() for _ in range(k)] for _ in range(m)]
        for i in range(m):
            self.cl.append([-lits[i], s[i][0]])
            if i > 0:
                for j in range(k):
                    self.cl.append([-s[i - 1][j], s[i][j]])
                for j in range(1, k):
                    self.cl.append([-lits[i], -s[i - 1][j - 1], s[i][j]])
                self.cl.append([-lits[i], -s[i - 1][k - 1]])


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
