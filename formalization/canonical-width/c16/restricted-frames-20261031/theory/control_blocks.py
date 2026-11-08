"""Control of the coordinate-change pipeline on real pool vectors with known answers (THEORY-NOTES
Prop. 4): U = U2 = coordinates of blocks B. Local frame exists iff B within {0,1,3,5,7}."""
import sys
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from common import X, Z, dot
from subspace_frames import Span, instance, run
from pathlib import Path
here = Path(__file__).resolve().parent
for B, expect in (((0, 1, 3, 5, 7), 'frame'), ((2, 4, 6), 'none'), ((0, 1), 'frame'), ((2, 3), 'none'), ((0, 1, 2, 3), 'none')):
    basis = [1 << (16*b + t) for b in B for t in range(16)]
    U = Span(basis)
    xs = [i for i in range(720) if U.coeffs(X[i]) is not None]; zs = [j for j in range(720) if U.coeffs(Z[j]) is not None]
    p = here / 'inst2' / f'ctlB{"".join(map(str, B))}.txt'; d, ni = instance(U, U, xs, zs, p)
    r = run(p, timeout=1200)
    print(B, 'expect', expect, 'dim', d, 'vectors', len(xs), len(zs), 'items', ni, '->', {k: r.get(k) for k in ('status', 'frames', 'nodes')}, flush=True)
    p.unlink()
