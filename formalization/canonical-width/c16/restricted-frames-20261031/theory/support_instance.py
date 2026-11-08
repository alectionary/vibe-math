"""Write a la_gen instance whose items are the single pairs (i, j), G = 1, lying in the support cells
of a cell-level LP solution (cell = (orbit, position mod m)). A frame found there is a genuine frame;
no frame there says nothing about the full problem."""
import json, sys
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from common import X, Z, dot
import os; os.makedirs(os.path.dirname(sys.argv[2]) or '.', exist_ok=True)
sol = json.load(open(sys.argv[1])); out = sys.argv[2]; m = sol['m']
sup = {(p, q) for p, q, v in sol['support']}
def cell(i): return (i // 16) * m + (i % 16) % m
items = [(i, j) for i in range(720) for j in range(720) if (cell(i), cell(j)) in sup and dot(X[i], Z[j])]
h64 = lambda v: f'{v & (2**64 - 1):x} {v >> 64:x}'
with open(out, 'w') as f:
    f.write(f'720 720 {len(items)} 128\n{h64(2**128 - 1)}\n')
    for v in X: f.write(h64(v) + '\n')
    for v in Z: f.write(h64(v) + '\n')
    for i, j in items: f.write(f'1 {i} {j}\n')
print(out, 'support cells', len(sup), 'items', len(items))
