#!/usr/bin/env python3
"""Half-turn (order L=2) frame CNF with orbit-12-first symmetry breaking.

Identical to ../subgroup_frame.py --order 2 (frozen; its encode() is imported
unchanged) except for the variable ORDER used by the lexicographic
symmetry-breaking constraints: the 8 X-side sub-orbit variables of the
critical orbit 12 come first, then every other X variable in the original
order. See HALF-TURN-O12.md for the soundness argument.

Symmetry group used (the same one as the frozen encoder):
  - the translation T, acting on sub-orbit p of every orbit as p -> p+1 (mod 8), on
    both sectors simultaneously (8 elements);
  - the sector swap (S,T) -> (T,S), valid because G = X Z^T is symmetric;
16 elements in all. For each element g other than the identity, require
  sigma(x) >=lex sigma((g.sol)_X)
where sigma is the fixed reordering above and (g.sol)_X is the X part of the
image of the solution (selected = True ranks first, as in add_frame_symmetry).

  PYTHONPATH=pysat_shim python3 subgroup_frame_o12.py OUT.cnf
"""
import hashlib, sys
from pathlib import Path
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
from pysat.card import CardEnc, EncType
from subgroup_frame import encode
from add_frame_symmetry import lex_clauses

L = 2; d = 16 // L; m = 45 * d; target = 128 // L; CRIT = 12


def build():
    root = HERE.parent
    X = [int(v, 16) for v in (root / 'pools/xcoords.txt').read_text().split()]
    Z = [int(v, 16) for v in (root / 'pools/zcoords.txt').read_text().split()]
    patterns = [[sum(((X[16*a+p] & Z[16*b+q+d*h]).bit_count() % 2) << h for h in range(L))
                 for b in range(45) for q in range(d)] for a in range(45) for p in range(d)]
    clauses, top = encode(patterns, target, coverage=True)
    for base in [0, m]:
        enc = CardEnc.atmost([base + CRIT*d + p + 1 for p in range(d)], 11 // L, top_id=top, encoding=EncType.seqcounter)
        clauses.extend(enc.clauses); top = enc.nv
    sigma = [CRIT*d + p for p in range(d)] + [i for i in range(m) if i // d != CRIT]   # position k -> X index
    assert sorted(sigma) == list(range(m))
    left = [i + 1 for i in sigma]
    for sector in [0, m]:
        for h in range(d):
            if sector == 0 and h == 0:
                continue
            img = lambda i: sector + (i // d) * d + (i % d - h) % d + 1      # same map as subgroup_frame.py
            right = [img(i) for i in sigma]
            rows, top = lex_clauses(left, right, top); clauses.extend(rows)
    return clauses, top


if __name__ == '__main__':
    clauses, top = build(); out = Path(sys.argv[1])
    with out.open('w') as f:
        f.write(f'p cnf {top} {len(clauses)}\n')
        for row in clauses:
            f.write(' '.join(map(str, row)) + ' 0\n')
    print(top, len(clauses), hashlib.sha256(out.read_bytes()).hexdigest())
