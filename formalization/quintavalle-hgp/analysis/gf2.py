"""Independent binary linear algebra; rows are vectors, arithmetic is mod 2."""
import itertools
import numpy as np


def rref(a):
    a = np.array(a, dtype=np.uint8, copy=True)
    transform = np.eye(len(a), dtype=np.uint8)
    pivots = []
    for col in range(a.shape[1]):
        row = len(pivots)
        candidates = np.flatnonzero(a[row:, col])
        if not len(candidates):
            continue
        j = row + candidates[0]
        a[[row, j]] = a[[j, row]]
        transform[[row, j]] = transform[[j, row]]
        others = np.flatnonzero(a[:, col])
        others = others[others != row]
        a[others] ^= a[row]
        transform[others] ^= transform[row]
        pivots.append(col)
        if len(pivots) == len(a):
            break
    return a, pivots, transform


def rank(a):
    return len(rref(a)[1])


def kernel(a):
    rr, piv, _ = rref(a)
    free = [j for j in range(a.shape[1]) if j not in piv]
    basis = np.zeros((len(free), a.shape[1]), dtype=np.uint8)
    for i, j in enumerate(free):
        basis[i, j] = 1
        basis[i, piv] = rr[:len(piv), j]
    return basis, free


def span(a):
    rr, piv, _ = rref(a)
    a = rr[:len(piv)]
    words = np.zeros((1, a.shape[1]), dtype=np.uint8)
    for v in a:
        words = np.concatenate((words, words ^ v))
    return words


def in_span(v, a):
    rr, piv, _ = rref(a)
    v = v.copy()
    for row, col in enumerate(piv):
        if v[col]:
            v ^= rr[row]
    return not v.any()


def inverse(a):
    rr, piv, tr = rref(a)
    assert len(piv) == len(a) == a.shape[1]
    return tr


def complement_projector(a):
    """Row-vector projection onto a coordinate complement of rowspan(a)."""
    rr, piv, _ = rref(a)
    b = list(rr[:len(piv)])
    n = a.shape[1]
    for e in np.eye(n, dtype=np.uint8):
        if rank(np.array(b + [e], dtype=np.uint8).reshape(-1, n)) > len(b):
            b.append(e)
    b = np.array(b, dtype=np.uint8).reshape(n, n)
    select = np.diag([0] * len(piv) + [1] * (n - len(piv))).astype(np.uint8)
    return (inverse(b) @ select @ b) % 2


def weights_upto(n, w):
    for t in range(w + 1):
        for indices in itertools.combinations(range(n), t):
            e = np.zeros(n, dtype=np.uint8)
            e[list(indices)] = 1
            yield e


def repetition(n, cyclic=False):
    a = np.zeros((n if cyclic else n - 1, n), dtype=np.uint8)
    for i in range(len(a)):
        a[i, i] ^= 1
        a[i, (i + 1) % n] ^= 1
    return a


def bit_rank(a):
    """Second representation: integer XOR elimination, no NumPy elimination."""
    basis = {}
    for row in a:
        v = sum(int(x) << j for j, x in enumerate(row))
        while v:
            p = v.bit_length() - 1
            if p in basis:
                v ^= basis[p]
            else:
                basis[p] = v
                break
    return len(basis)


def product3(a, b, c):
    ma, na = a.shape; mb, nb = b.shape; mc, nc = c.shape
    eye = lambda n: np.eye(n, dtype=np.uint8)
    kron = lambda x, y, z: np.kron(np.kron(x, y), z)
    d0 = np.vstack((kron(a, eye(nb), eye(nc)), kron(eye(na), b, eye(nc)), kron(eye(na), eye(nb), c)))
    d1 = np.block([
        [kron(eye(ma), b, eye(nc)), kron(a, eye(mb), eye(nc)), np.zeros((ma*mb*nc, na*nb*mc), dtype=np.uint8)],
        [kron(eye(ma), eye(nb), c), np.zeros((ma*nb*mc, na*mb*nc), dtype=np.uint8), kron(a, eye(nb), eye(mc))],
        [np.zeros((na*mb*mc, ma*nb*nc), dtype=np.uint8), kron(eye(na), eye(mb), c), kron(eye(na), b, eye(mc))]])
    d2 = np.hstack((kron(eye(ma), eye(mb), c), kron(eye(ma), b, eye(mc)), kron(a, eye(mb), eye(mc))))
    return d0, d1, d2


class HGP:
    def __init__(self, a, b):
        self.a, self.b = a, b
        self.ma, self.na = a.shape; self.mb, self.nb = b.shape
        self.left = self.na * self.nb
        self.n = self.left + self.ma * self.mb
        eye = lambda n: np.eye(n, dtype=np.uint8)
        self.hx = np.hstack((np.kron(a, eye(self.nb)), np.kron(eye(self.ma), b.T)))
        self.hz = np.hstack((np.kron(eye(self.na), b), np.kron(a.T, eye(self.mb))))
        self.ka, pa = kernel(a); self.kb, pb = kernel(b)
        self.kat, pat = kernel(a.T); self.kbt, pbt = kernel(b.T)
        x, z, labels = [], [], []
        for i, vi in enumerate(self.ka):
            for j, vj in enumerate(self.kb):
                x.append(np.r_[np.kron(eye(self.na)[pa[i]], vj), np.zeros(self.n-self.left, dtype=np.uint8)])
                z.append(np.r_[np.kron(vi, eye(self.nb)[pb[j]]), np.zeros(self.n-self.left, dtype=np.uint8)])
                labels.append(('L', i, j))
        for i, vi in enumerate(self.kat):
            for j, vj in enumerate(self.kbt):
                x.append(np.r_[np.zeros(self.left, dtype=np.uint8), np.kron(vi, eye(self.mb)[pbt[j]])])
                z.append(np.r_[np.zeros(self.left, dtype=np.uint8), np.kron(eye(self.ma)[pat[i]], vj)])
                labels.append(('R', i, j))
        self.lx = np.array(x, dtype=np.uint8).reshape(-1, self.n)
        self.lz = np.array(z, dtype=np.uint8).reshape(-1, self.n)
        self.labels = labels
        self.k = len(labels)
        self.pl = complement_projector(b)
        self.pr = complement_projector(a.T)
        self.ca = span(self.ka); self.cbt = span(self.kbt)
        rr, piv, tr = rref(self.hx)
        self.solver = np.zeros((self.n, len(self.hx)), dtype=np.uint8)
        self.solver[piv] = tr[:len(piv)]

    def syndrome(self, e):
        return (self.hx @ e) % 2

    def correct(self, e):
        valid = (self.solver @ self.syndrome(e)) % 2
        return self.reshape(valid)

    def reshape(self, valid):
        l = valid[:self.left].reshape(self.na, self.nb).copy()
        r = valid[self.left:].reshape(self.ma, self.mb).copy()
        ol = (l @ self.pl) % 2
        ort = (r.T @ self.pr) % 2
        calls = 0
        for j in np.flatnonzero(self.pl.any(axis=0)):
            l[:, j] ^= self.ca[np.argmin(np.sum(self.ca ^ ol[:, j], axis=1))]
            calls += 1
        for i in np.flatnonzero(self.pr.any(axis=0)):
            r[i, :] ^= self.cbt[np.argmin(np.sum(self.cbt ^ ort[:, i], axis=1))]
            calls += 1
        return np.r_[l.ravel(), r.ravel()]

    def logical(self, e):
        return (self.lx @ e) % 2
