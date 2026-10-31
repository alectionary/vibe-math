"""Decode a SAT model into pool indices and verify G[S,T] is a permutation matrix.
Usage: python3 decode.py out.cnf.map.json solver_output.txt
Prints the selected X/Z pool indices (0-based lines of ../pools) and the pairing."""
import sys, json
import numpy as np
from common import *

mp = json.load(open(sys.argv[1]))
lits = [int(t) for l in open(sys.argv[2]) if l.startswith("v ") for t in l[2:].split()]
true = {l for l in lits if l > 0}
G = load_gram()
if "OX" in mp:
    n = len(mp["OX"])
    S = sorted(i for P in range(n) if P + 1 in true for i in mp["OX"][P])
    T = sorted(i for Q in range(n) if n + Q + 1 in true for i in mp["OZ"][Q])
else:
    nx = len(mp["xs"])
    S = [mp["xs"][a] for a in range(nx) if a + 1 in true]
    T = [mp["zs"][b] for b in range(len(mp["zs"])) if nx + b + 1 in true]
M = G[np.ix_(S, T)]
ok = len(S) == len(T) and (M.sum(0) == 1).all() and (M.sum(1) == 1).all()
pairs = [[S[a], T[int(np.nonzero(M[a])[0][0])]] for a in range(len(S))] if ok else []
print(json.dumps({"pairs": len(S), "permutation_matrix": bool(ok), "pairing": pairs}))
