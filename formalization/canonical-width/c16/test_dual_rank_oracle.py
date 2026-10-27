#!/usr/bin/env python3
"""Check signed private-literal mapping and certificates on both sides."""
from pathlib import Path
import tempfile
from pysat.solvers import Solver
from dual_rank_oracle import DualRankOracle
from rank_oracle import verify_log


def main():
    X=[1<<i for i in range(128)]+[m for m in range(7,65536) if m.bit_count() in [3,4]][:592]
    D=[(721+j)*(1 if j%2==0 else -1) for j in range(720)]
    with tempfile.TemporaryDirectory() as d:
        root=Path(d)
        for positive in [True,False]:
            path=root/('positive.json' if positive else 'negative.json');oracle=DualRankOracle(X,X,path,D,basis_propagation=True)
            if positive:
                assumptions=[i+1 if i<128 else -(i+1) for i in range(720)]+[v if j<128 else -v for j,v in enumerate(D)]
            else:assumptions=[D[j] for j in [0,1,2,128]]
            with Solver(name='cadical195',bootstrap_with=[[1440,-1440]]) as solver:
                solver.connect_propagator(oracle)
                for i in range(1,1441):solver.observe(i)
                assert solver.solve(assumptions=assumptions)==positive
            if not positive:assert oracle.z.stats['x_circuit']>0
            oracle.close()
            verify_log(X,X,path.with_suffix('.x.lemmas.jsonl'),D)
            verify_log(X,X,path.with_suffix('.z.lemmas.jsonl'))
    print('PASS dual signed-literal mapping: positive identity bases retained, dependent Z selection rejected; both logs independently verified.')


if __name__=='__main__':main()
