#!/usr/bin/env python3
"""Compare subgroup CNF with literal expanded permutation submatrices."""
from itertools import combinations,product
import json
import random
from pysat.solvers import Solver
from subgroup_frame import encode


def literal(patterns,L,target):
    m=len(patterns)
    for I in combinations(range(m),target):
        for J in combinations(range(m),target):
            expanded=[[patterns[a][b]>>((t-s)%L)&1 for b in J for t in range(L)] for a in I for s in range(L)]
            if all(sum(row)==1 for row in expanded) and all(sum(row[j] for row in expanded)==1 for j in range(target*L)):return True
    return False


def main():
    checked=0
    for L in [2,4]:
        for flat in product(range(1<<L),repeat=4):
            patterns=[list(flat[:2]),list(flat[2:])]
            for target in [1,2]:
                clauses,top=encode(patterns,target)
                with Solver(name='glucose42',bootstrap_with=clauses) as solver:answer=solver.solve()
                assert answer==literal(patterns,L,target),(L,patterns,target);checked+=1
    rng=random.Random(202610271755)
    for L in [8,16]:
        for _ in range(128):
            patterns=[[rng.randrange(1<<L) for b in range(3)] for a in range(3)]
            for target in [1,2,3]:
                clauses,top=encode(patterns,target)
                with Solver(name='glucose42',bootstrap_with=clauses) as solver:answer=solver.solve()
                assert answer==literal(patterns,L,target);checked+=1
    print(json.dumps({'status':'PASS','literal_subgroup_model_comparisons':checked,'scope':'all two-orbit patterns for subgroup orders2 and4; sampled orders8 and16; no unrestricted regularization claimed'}))


if __name__=='__main__':main()
