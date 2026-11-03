"""Relaxation for Lemma C: a frame containing all of X orbit a has its Z vectors in
C(a) = (union of partner sets C_t) ∪ {z : z ⊥ span X_a}. Search frames of the full space with the Z pool
restricted to C(a) (all X kept). No frame there ⇒ no frame contains the whole orbit a."""
import json, subprocess, sys
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from common import X, Z, dot
from pathlib import Path
here = Path(__file__).resolve().parent; LAGEN = here.parent / 'la' / 'la_gen'
h64 = lambda v: f'{v & (2**64 - 1):x} {v >> 64:x}'
def write(a, path):
    ox = X[16*a:16*a+16]
    zs = [j for j in range(720) if sum(dot(x, Z[j]) for x in ox) <= 1]   # unit row (partner) or zero row
    items = [(i, k) for i in range(720) for k, j in enumerate(zs) if dot(X[i], Z[j])]
    with open(path, 'w') as f:
        f.write(f'720 {len(zs)} {len(items)} 128\n{h64(2**128 - 1)}\n')
        for v in X: f.write(h64(v) + '\n')
        for j in zs: f.write(h64(Z[j]) + '\n')
        for i, k in items: f.write(f'1 {i} {k}\n')
    return len(zs), len(items)
if __name__ == '__main__':
    mode = sys.argv[1]
    for a in [int(s) for s in sys.argv[2:]]:
        p = here / 'inst2' / f'relax{a}.txt'; nz, ni = write(a, p)
        args = ['-k', '200'] if mode == 'knuth' else ['-1', '-t', str(int(__import__('os').environ.get('TLIM', '3000')))]
        r = subprocess.run(['nice', '-n', '10', str(LAGEN), '-l'] + args + [str(p)], capture_output=True, text=True)
        print(a, 'Z pool', nz, 'items', ni, r.stdout.strip().splitlines()[-1][:300], flush=True)
