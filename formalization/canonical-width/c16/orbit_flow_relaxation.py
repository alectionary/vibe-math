#!/usr/bin/env python3
"""Necessary orbit-cardinality flow relaxation of a full canonical frame.

Pairwise tables are exact for each16x16 block, but consistency of phase subsets
between different blocks is relaxed. INFEASIBLE could therefore be a global
obstruction; a feasible flow is not a physical frame.
"""
import argparse
import hashlib
import json
from pathlib import Path
from ortools.sat.python import cp_model
from rank_oracle import basis


def main():
    ap=argparse.ArgumentParser();ap.add_argument('mapping',type=Path);ap.add_argument('tables',type=Path);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=300);ap.add_argument('--workers',type=int,default=2);ap.add_argument('--maximize',action='store_true');ap.add_argument('--augmentation',action='store_true');args=ap.parse_args()
    assert not (args.maximize and args.augmentation),'Augmentation identity is necessary only for a full128-pair frame.'
    mapping=json.loads(args.mapping.read_text());tables={r['pattern']:r['allowed'] for r in json.loads(args.tables.read_text())};assert mapping['P']==16 and mapping['blocks']==45
    model=cp_model.CpModel();x=[model.new_int_var(0,16,f'x{a}') for a in range(45)];z=[model.new_int_var(0,16,f'z{b}') for b in range(45)];edges=[[model.new_int_var(0,16,f'e{a}_{b}') for b in range(45)] for a in range(45)]
    for a in range(45):
        model.add(sum(edges[a])==x[a])
        for b in range(45):
            pattern=mapping['canonical_patterns'][a][b]
            if not pattern:model.add(edges[a][b]==0)
            elif pattern.bit_count()==1:
                model.add(edges[a][b]<=x[a]);model.add(edges[a][b]<=z[b]);model.add(x[a]+z[b]-edges[a][b]<=16)
            else:model.add_allowed_assignments([x[a],z[b],edges[a][b]],tables[pattern])
    for b in range(45):model.add(sum(edges[a][b] for a in range(45))==z[b])
    if args.maximize:model.maximize(sum(x));model.add(sum(x)<=128)
    else:model.add(sum(x)==128)
    model.add(sum(x)==sum(z));model.add(x[12]<=11);model.add(z[12]<=11)
    root=Path(__file__).parent;X=[int(v,16) for v in (root/'pools/xcoords.txt').read_text().split()];data=json.loads((root/'physical-pool-source.json').read_text());groups=[[] for _ in range(5)]
    for a,s in enumerate(data['Z_orbit_representatives']):groups[next(iter({(q//32)%5 for q in s}))].append(a)
    for group in groups:
        r=len(basis(X[16*a+h] for a in group for h in range(16)));model.add(sum(x[a] for a in group)<=r);model.add(sum(z[a] for a in group)<=r)
    # Both sector pools have the same binary matroid under the checked linear
    # identification, so the same orbit-subset rank bounds apply to each.
    from itertools import combinations
    for selected in combinations(range(45),3):
        rank=len(basis(X[16*a+h] for a in selected for h in range(16)))
        if rank<48:model.add(sum(x[a] for a in selected)<=rank);model.add(sum(z[a] for a in selected)<=rank)
    if args.augmentation:
        from orbit_augmentation import add_augmentation_constraints
        Z=[int(v,16) for v in (root/'pools/zcoords.txt').read_text().split()]
        add_augmentation_constraints(model,edges,X,Z)
    model.export_to_file(str(args.output.with_suffix('.pbtxt')))
    solver=cp_model.CpSolver();solver.parameters.max_time_in_seconds=args.seconds;solver.parameters.num_search_workers=args.workers;solver.parameters.log_search_progress=True
    status=solver.solve(model);result={'status':solver.status_name(status),'scope':'necessary orbit-cardinality relaxation','physical_frame':False,'augmentation':args.augmentation,'seconds':solver.wall_time,'best_bound':solver.best_objective_bound,'mapping_sha256':hashlib.sha256(args.mapping.read_bytes()).hexdigest(),'tables_sha256':hashlib.sha256(args.tables.read_bytes()).hexdigest()}
    if status in [cp_model.FEASIBLE,cp_model.OPTIMAL]:result.update(X_counts=[solver.value(v) for v in x],Z_counts=[solver.value(v) for v in z],flow=[[solver.value(v) for v in row] for row in edges],total=sum(solver.value(v) for v in x))
    args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)


if __name__=='__main__':main()
