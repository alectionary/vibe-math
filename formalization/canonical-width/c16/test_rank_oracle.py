#!/usr/bin/env python3
"""Controls for algebraic clauses, basis propagation and optional native ranks."""
import argparse
import random
import tempfile
from pathlib import Path
from pysat.solvers import Solver
from rank_oracle import RankOracle,basis,coloop_indices,verify_log


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--native-library',type=Path);args=ap.parse_args()
    rng=random.Random(261027)
    for trial in range(300):
        V=[rng.randrange(1,256) for _ in range(20)];r=len(basis(V))
        assert coloop_indices(V,list(range(20)))==[i for i in range(20) if len(basis(V[:i]+V[i+1:]))<r]
    units=[1<<i for i in range(128)]
    extras=[m for m in range(7,65536) if m.bit_count() in [3,4]][:592]
    X=units+extras
    with tempfile.TemporaryDirectory() as d:
        folder=Path(d);p=folder/'positive.jsonl'
        oracle=RankOracle(X,X,p,basis_propagation=True,opposite_units=True,native_library=args.native_library)
        with Solver(name='cadical195') as solver:
            solver.connect_propagator(oracle)
            for i in range(1,721):solver.observe(i)
            assert solver.solve(assumptions=list(range(1,17)))
            assert [l for l in solver.get_model() if 0<l<=720]==list(range(1,129))
        oracle.close();positive=verify_log(X,X,p)
        p=folder/'opposite.jsonl';oracle=RankOracle(X,units,p,opposite_units=True)
        oracle.on_assignment(3);oracle.on_assignment(4);oracle.check();oracle.close()
        assert oracle.stats['z_zero']==582 and all(len(c)==1 for c in oracle.pending)
        opposite=verify_log(X,units,p)
        # A dependent triple must be rejected, with a direct XOR witness.
        p=folder/'negative.jsonl';oracle=RankOracle(X,X,p)
        for literal in [1,2,3,129]:oracle.on_assignment(literal)
        oracle.check();oracle.close();assert oracle.stats['x_circuit']==1
        verify_log(X,X,p)
        if args.native_library:
            from native_rank_units import NativeRankUnits
            pool=Path(__file__).parent/'pools'
            A=[int(v,16) for v in (pool/'xcoords.txt').read_text().split()]
            B=[int(v,16) for v in (pool/'zcoords.txt').read_text().split()]
            az=[sum(((x&z).bit_count()%2)<<i for i,x in enumerate(A)) for z in B]
            native=NativeRankUnits(A,B,az,args.native_library)
            for ids in [[336,192],[0,1,192,193],[9,45,98,202],[192,193,194,195]]:
                bits=sum(1<<i for i in ids);dim=128-len(ids)
                expected=[i for i in range(720) if i not in ids and len(basis(z for z,m in zip(B,az) if not m&(bits|1<<i)))<dim-1]
                assert native.extensions(bits,dim)==expected
    print(f'PASS: 300 brute coloop controls; positive frame ({positive} certified clauses); {opposite} opposite-coloop units; dependent-X rejection; optional native extension agreement.')


if __name__=='__main__':main()
