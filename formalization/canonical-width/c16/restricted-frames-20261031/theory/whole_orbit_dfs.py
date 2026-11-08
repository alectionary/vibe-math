"""Exact test: can a frame contain all 16 vectors of X orbit a?
Partners: z_t must pair with orbit a as the unit vector e_t, so z_t is in C_t (computed). Choose z_0..z_15
in order; necessary condition at every step: the X pool vectors outside orbit a that are orthogonal to
all chosen partners have rank >= 112 (the other 112 X vectors of the frame lie there, independent).
Survivors with all 16 partners chosen are passed to la_gen -p (16 fixed pairs, all completions searched).
By X<->Z symmetry of G (Z = pi X, G symmetric) the Z-orbit statement is the same."""
import json, subprocess, sys
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from common import X, Z, dot
from subspace_frames import Span
from pathlib import Path
here = Path(__file__).resolve().parent
LAGEN = here.parent / 'la' / 'la_gen'; FULL = here / 'inst2' / 'full-o1.txt'
def rk(vs): return len(Span(vs))
from subspace_frames import instance, run
def complement_frames(xs_fixed, zs_fixed, tag):
    """Frames of the complement of the fixed pairs, in complement coordinates (Lemma A)."""
    UX = Span([X[i] for i in xs_fixed]); UZ = Span([Z[j] for j in zs_fixed])
    cxs = [i for i in range(720) if i not in xs_fixed and all(dot(X[i], c) == 0 for c in UZ.basis)]
    czs = [j for j in range(720) if j not in zs_fixed and all(dot(b, Z[j]) == 0 for b in UX.basis)]
    CX = Span([X[i] for i in cxs]); CZ = Span([Z[j] for j in czs])
    if len(CX) < 128 - len(UX) or len(CZ) < 128 - len(UX): return {'status': 'COMPLETE', 'frames': 0, 'reason': 'rank'}
    p = here / 'inst2' / f'{tag}.txt'; instance(CX, CZ, cxs, czs, p)
    r = run(p, timeout=1800); p.unlink(); return {k: r.get(k) for k in ('status', 'frames', 'nodes')}
results = {}
for a in [int(s) for s in sys.argv[1:]]:
    ox = list(range(16*a, 16*a+16))
    C = [[j for j in range(720) if all(dot(X[i], Z[j]) == (k == t) for k, i in enumerate(ox))] for t in range(16)]
    others = [i for i in range(720) if i // 16 != a]
    stats = {'nodes': 0, 'pruned': 0, 'leaves': 0, 'completions': []}
    def dfs(t, chosen, cand):
        stats['nodes'] += 1
        if rk([X[i] for i in cand]) < 112: stats['pruned'] += 1; return
        if t == 16:
            stats['leaves'] += 1
            r = complement_frames(ox, chosen, f'w{a}_{stats["leaves"]}')
            stats['completions'].append({'partners': chosen, 'result': r}); return
        for j in C[t]:
            dfs(t + 1, chosen + [j], [i for i in cand if dot(X[i], Z[j]) == 0])
    dfs(0, [], others)
    results[a] = {'C_sizes': [len(c) for c in C], **stats}
    print(a, results[a]['C_sizes'][0], {k: v for k, v in stats.items() if k != 'completions'}, stats['completions'][:3], flush=True)
json.dump(results, open(here / f'whole_orbit_dfs_{"_".join(sys.argv[1:])}.json', 'w'), indent=1)
