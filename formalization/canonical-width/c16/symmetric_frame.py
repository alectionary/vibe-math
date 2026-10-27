#!/usr/bin/env python3
"""Construction subproblem with identical X/Z pool index sets (restricted).

The pairing matrix happens to be symmetric. A selected principal permutation
submatrix would give a full frame. Failure does not exclude different X/Z sets.
"""
import argparse
import json
from pathlib import Path
from ortools.sat.python import cp_model


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--seconds',type=float,default=300);ap.add_argument('--workers',type=int,default=2);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--maximize',action='store_true');args=ap.parse_args()
    root=Path(__file__).parent;X=[int(v,16) for v in (root/'pools/xcoords.txt').read_text().split()];Z=[int(v,16) for v in (root/'pools/zcoords.txt').read_text().split()]
    A=[[(x&z).bit_count()%2 for z in Z] for x in X];n=len(X)
    assert all(A[i][j]==A[j][i] for i in range(n) for j in range(i))
    model=cp_model.CpModel();selected=[model.new_bool_var(f's{i}') for i in range(n)]
    for i,row in enumerate(A):model.add(sum(selected[j] for j,a in enumerate(row) if a)==1).only_enforce_if(selected[i])
    if args.maximize:model.maximize(sum(selected))
    else:model.add(sum(selected)==128)
    # All principal permutation submatrices are nonsingular, hence at most128.
    model.add(sum(selected)<=128)
    solver=cp_model.CpSolver();solver.parameters.max_time_in_seconds=args.seconds;solver.parameters.num_search_workers=args.workers;solver.parameters.log_search_progress=True
    status=solver.solve(model);result={'status':solver.status_name(status),'scope':'identical X/Z index sets only','seconds':solver.wall_time,'best_bound':solver.best_objective_bound,'full_unrestricted_decision':False}
    if status in [cp_model.OPTIMAL,cp_model.FEASIBLE]:
        ids=[i for i,s in enumerate(selected) if solver.value(s)];pairs=[]
        for i in ids:
            mates=[j for j in ids if A[i][j]];assert len(mates)==1;pairs.append([i,mates[0]])
        assert all(A[i][j]==(a==b) for a,(i,_) in enumerate(pairs) for b,(_,j) in enumerate(pairs));result['pool_pairs']=pairs;result['pairs']=len(pairs)
    args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)


if __name__=='__main__':main()
