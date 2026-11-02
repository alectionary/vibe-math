#!/usr/bin/env python3
"""Independent SAT check for symmetric frames (no code shared with la/).

A frame is a pair of 128-sets S (X pool indices), T (Z pool indices) such that G[S,T] is a
permutation matrix, G[i][j] = <x_i, z_j> mod 2. Equivalently: every chosen X vector has exactly
one chosen Z neighbour in G, every chosen Z vector has exactly one chosen X neighbour, |S| = 128.
(|T| = 128 then follows.)

Symmetry classes, written as constraints on the vertex sets only:
  swap    T = S                 (uses G symmetric: then G[S,S] is a symmetric permutation matrix,
                                 so the frame is fixed by (i,j) -> (j,i))
  swapT8  T = tau(S)            (tau = T^8 on indices; the induced matching on (S, tau S) is unique,
                                 so it is fixed by (i,j) -> (tau j, tau i))
  half    S = tau S, T = tau T  (the half-turn class, for comparison with la/ and the Mac run)
In each case the class is *exactly* the set of frames fixed by the involution, because a frame
is determined by its vertex sets.

  sat_symmetric.py CLASS OUT.cnf [--plant SEED]
"""
import hashlib, random, sys
from pathlib import Path
root = Path(__file__).resolve().parents[2]
X = [int(v, 16) for v in (root / 'pools/xcoords.txt').read_text().split()]
Z = [int(v, 16) for v in (root / 'pools/zcoords.txt').read_text().split()]
args = sys.argv[1:]
plant = None
if '--plant' in args:
    k = args.index('--plant'); plant = int(args[k + 1]); del args[k:k + 2]
mode, out = args

def Tsh(v, k=1):
    return sum(((((v >> (16 * b)) & 0xffff) << k | ((v >> (16 * b)) & 0xffff) >> (16 - k)) & 0xffff) << (16 * b) for b in range(8))

if plant is not None:
    # planted positive control: random T-invariant basis A and its dual basis Zd (own implementation)
    rnd = random.Random(plant)
    while True:
        A = [Tsh(g, t) for g in (rnd.getrandbits(128) for _ in range(8)) for t in range(16)]
        M = [(A[i] << 128) | (1 << i) for i in range(128)]; ok = True
        for c in range(128):
            p = next((r for r in range(c, 128) if M[r] >> (128 + c) & 1), None)
            if p is None: ok = False; break
            M[c], M[p] = M[p], M[c]
            for r in range(128):
                if r != c and M[r] >> (128 + c) & 1: M[r] ^= M[c]
        if ok: break
    inv = [M[i] & ((1 << 128) - 1) for i in range(128)]
    Zd = [sum(((inv[c] >> j) & 1) << c for c in range(128)) for j in range(128)]
    X = X + A; Z = Z + Zd

n = len(X)
dot = lambda u, v: bin(u & v).count('1') & 1
G = [[dot(X[i], Z[j]) for j in range(n)] for i in range(n)]
tau = lambda i: 16 * (i // 16) + (i % 16 + 8) % 16
if mode == 'swap' and plant is None:
    assert all(G[i][j] == G[j][i] for i in range(n) for j in range(i)), 'G must be symmetric'

clauses = []; top = [0]
def new():
    top[0] += 1; return top[0]
s = [new() for _ in range(n)]                 # X vector i chosen
if mode == 'swap':
    t = s                                      # T = S
elif mode == 'swapT8':
    t = [s[tau(j)] for j in range(n)]          # j in T  iff  tau(j) in S
elif mode == 'half':
    t = [new() for _ in range(n)]
    for i in range(n):
        if tau(i) > i:
            clauses += [[-s[i], s[tau(i)]], [s[i], -s[tau(i)]], [-t[i], t[tau(i)]], [t[i], -t[tau(i)]]]
else:
    raise SystemExit('unknown class')

def amo_if(guard, lits):
    """guard -> at most one of lits (sequential counter; every clause carries -guard)"""
    if len(lits) <= 1: return
    r = [new() for _ in lits[:-1]]
    clauses.append([-guard, -lits[0], r[0]])
    for k in range(1, len(lits) - 1):
        clauses.extend([[-guard, -lits[k], r[k]], [-guard, -r[k - 1], r[k]], [-guard, -lits[k], -r[k - 1]]])
    clauses.append([-guard, -lits[-1], -r[-1]])

for i in range(n):                             # chosen X vector: exactly one chosen Z neighbour
    nb = [t[j] for j in range(n) if G[i][j]]
    clauses.append([-s[i]] + nb); amo_if(s[i], nb)
seen = set()
for j in range(n):                             # chosen Z vector: exactly one chosen X neighbour
    if t[j] in seen: continue                  # identical guard literal -> identical constraint
    seen.add(t[j])
    nb = [s[i] for i in range(n) if G[i][j]]
    clauses.append([-t[j]] + nb); amo_if(t[j], nb)

def atmost(lits, k):
    """sequential counter: at most k of lits"""
    m = len(lits); R = [[new() for _ in range(k)] for _ in range(m - 1)]
    clauses.append([-lits[0], R[0][0]])
    for jj in range(1, k): clauses.append([-R[0][jj]])
    for i in range(1, m - 1):
        clauses.extend([[-lits[i], R[i][0]], [-R[i - 1][0], R[i][0]]])
        for jj in range(1, k):
            clauses.extend([[-lits[i], -R[i - 1][jj - 1], R[i][jj]], [-R[i - 1][jj], R[i][jj]]])
        clauses.append([-lits[i], -R[i - 1][k - 1]])
    clauses.append([-lits[m - 1], -R[m - 2][k - 1]])
atmost(s, 128)
atmost([-v for v in s], n - 128)               # at least 128

with open(out, 'w') as f:
    f.write(f'p cnf {top[0]} {len(clauses)}\n')
    for c in clauses: f.write(' '.join(map(str, c)) + ' 0\n')
print(mode, 'plant' if plant is not None else 'real', 'vars', top[0], 'clauses', len(clauses),
      hashlib.sha256(Path(out).read_bytes()).hexdigest())
