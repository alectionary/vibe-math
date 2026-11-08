"""Local frames of a pair of subspaces (U of the X space, U2 of the Z space) with nondegenerate pairing.

Coordinates: fix a basis b_1..b_d of U. An X pool vector x in U gets its coefficient vector c(x) in F2^d;
a Z pool vector z in U2 gets w(z) = (<b_k, z>)_k. Then <x, z> = c(x) . w(z), so frames of (U, U2) built
from pool vectors are exactly frames of F2^d for the vectors c(x), w(z); la_gen decides them.
Requires pairing U x U2 nondegenerate (so w is injective on U2)."""
import json, subprocess, sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent))
from common import X, Z, dot
HERE = Path(__file__).resolve().parent; LA_GEN = HERE.parent / 'la' / 'la_gen'
(HERE / 'inst2').mkdir(exist_ok=True)

class Span:
    """Row-echelon basis of a subspace with coefficient tracking against the chosen basis vectors."""
    def __init__(self, vecs):
        self.piv = {}; self.basis = []
        for v in vecs: self.add(v)
    def add(self, v):
        comb = 0; w = v
        while w:
            h = w.bit_length() - 1
            if h in self.piv: pv, pc = self.piv[h]; w ^= pv; comb ^= pc
            else:
                k = len(self.basis); self.basis.append(v)
                self.piv[h] = (w, comb ^ (1 << k)); return True
        return False
    def coeffs(self, v):
        """Coefficient bitmask of v in self.basis, or None if v is not in the span."""
        comb = 0; w = v
        while w:
            h = w.bit_length() - 1
            if h not in self.piv: return None
            pv, pc = self.piv[h]; w ^= pv; comb ^= pc
        return comb
    def __len__(self): return len(self.basis)

def h64(v): return f'{v & (2**64 - 1):x} {v >> 64:x}'

def instance(UX, UZ, xs, zs, path):
    """UX: Span of the X-side subspace, UZ: Span of the Z-side subspace (same dim d, nondegenerate pairing).
    xs, zs: pool indices of X vectors in UX and Z vectors in UZ. Writes a la_gen instance; returns (d, items)."""
    d = len(UX); assert len(UZ) == d
    cx = [UX.coeffs(X[i]) for i in xs]; assert all(c is not None for c in cx)
    wz = [sum(dot(b, Z[j]) << k for k, b in enumerate(UX.basis)) for j in zs]
    items = [(a, b) for a in range(len(xs)) for b in range(len(zs)) if (cx[a] & wz[b]).bit_count() & 1]
    with open(path, 'w') as f:
        f.write(f'{len(xs)} {len(zs)} {len(items)} {d}\n{h64((1 << d) - 1)}\n')
        for c in cx: f.write(h64(c) + '\n')
        for w in wz: f.write(h64(w) + '\n')
        for a, b in items: f.write(f'1 {a} {b}\n')
    return d, len(items)

def pairing_rank(UX, UZ):
    from common import rank
    return rank([sum(dot(b, c) << k for k, c in enumerate(UZ.basis)) for b in UX.basis])

def run(path, knuth=0, timeout=1800, extra=()):
    cmd = ['nice', '-n', '10', str(LA_GEN), '-l'] + (['-k', str(knuth)] if knuth else ['-1']) + list(extra) + [str(path)]
    p = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
    return json.loads(p.stdout.strip().splitlines()[-1])

def local_and_complement(xorbs, zorbs, tag, knuth_cap=5e6):
    """U = span of X orbits, U2 = span of Z orbits. Returns dict with local and complement results."""
    UX = Span([v for a in xorbs for v in X[16*a:16*a+16]]); UZ = Span([v for b in zorbs for v in Z[16*b:16*b+16]])
    out = {'xorbs': list(xorbs), 'zorbs': list(zorbs), 'dimU': len(UX), 'dimU2': len(UZ)}
    if len(UX) != len(UZ): out['status'] = 'DIM_MISMATCH'; return out
    d = len(UX); pr = pairing_rank(UX, UZ); out['pairing_rank'] = pr
    if pr < d: out['status'] = 'DEGENERATE'; return out
    xs = [i for i in range(len(X)) if UX.coeffs(X[i]) is not None]; zs = [j for j in range(len(Z)) if UZ.coeffs(Z[j]) is not None]
    out['local_vectors'] = (len(xs), len(zs))
    p = HERE / 'inst2' / f'{tag}-L.txt'; instance(UX, UZ, xs, zs, p)
    r = run(p); out['local'] = {k: r.get(k) for k in ('status', 'frames', 'nodes')}; p.unlink()
    # complement: X vectors orthogonal to U2, Z vectors orthogonal to U
    cxs = [i for i in range(len(X)) if all(dot(X[i], c) == 0 for c in UZ.basis)]
    czs = [j for j in range(len(Z)) if all(dot(b, Z[j]) == 0 for b in UX.basis)]
    CX = Span([X[i] for i in cxs]); CZ = Span([Z[j] for j in czs])
    out['complement_vectors'] = (len(cxs), len(czs)); out['complement_ranks'] = (len(CX), len(CZ))
    if len(CX) < 128 - d or len(CZ) < 128 - d: out['complement'] = {'status': 'COMPLETE', 'frames': 0, 'reason': 'rank'}; return out
    p = HERE / 'inst2' / f'{tag}-C.txt'; instance(CX, CZ, cxs, czs, p)
    k = run(p, knuth=200, timeout=600); out['complement_knuth'] = k.get('mean_tree')
    if k.get('mean_tree', 1e99) <= knuth_cap and k.get('max', 1e99) <= 50 * knuth_cap:
        r = run(p, timeout=3600); out['complement'] = {kk: r.get(kk) for kk in ('status', 'frames', 'nodes')}
    else: out['complement'] = {'status': 'SKIPPED'}
    p.unlink(); return out
