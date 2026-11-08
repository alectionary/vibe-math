#!/usr/bin/env python3
"""Decode a Kissat model for sat_symmetric.py and check G[S,T] is a 128x128 permutation matrix.
  check_model.py CLASS SOLVER_OUTPUT [--plant SEED]   (re-runs the same pool construction)"""
import subprocess, sys
args = sys.argv[1:]; mode, outp = args[0], args[1]; extra = args[2:]
lits = {int(x) for l in open(outp) if l.startswith('v ') for x in l[2:].split()}
# rebuild pools exactly as sat_symmetric.py does by importing it in a subprocess-free way
sys.argv = ['x', mode, '/dev/null'] + extra
src = open(__file__.replace('check_model.py', 'sat_symmetric.py')).read().split("clauses = []; top = [0]")[0]
ns = {'__file__': __file__.replace('check_model.py', 'sat_symmetric.py')}; exec(src, ns)
X, Z, n, tau = ns['X'], ns['Z'], ns['n'], ns['tau']
S = [i for i in range(n) if (i + 1) in lits]
T = S if mode == 'swap' else [tau(i) for i in S] if mode == 'swapT8' else [j for j in range(n) if (n + j + 1) in lits]
dot = lambda u, v: bin(u & v).count('1') & 1
M = [[dot(X[i], Z[j]) for j in T] for i in S]
perm = len(S) == len(T) == 128 and all(sum(r) == 1 for r in M) and all(sum(c) == 1 for c in zip(*M))
print('|S| =', len(S), '|T| =', len(T), 'G[S,T] permutation:', perm, 'uses planted vectors:', any(i >= 720 for i in S + T))
