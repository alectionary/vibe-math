#!/usr/bin/env python3
"""Necessary phase-shape relaxation retaining one shape per selected orbit.

Each orbit's subset is represented up to cyclic shift. Exact zero/private-owner
profiles then constrain all opposite orbit counts simultaneously. Relative
alignment between different orbits remains relaxed: feasibility is not a frame.
"""
import argparse
from itertools import combinations
import json
from pathlib import Path
from ortools.sat.python import cp_model
from replay_seed4 import rotate
from rank_oracle import basis


def main():
    ap=argparse.ArgumentParser();ap.add_argument('mapping',type=Path);ap.add_argument('masks',type=Path);ap.add_argument('profiles',type=Path);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=1800);ap.add_argument('--workers',type=int,default=2);args=ap.parse_args()
    mapping=json.loads(args.mapping.read_text());masks=list(map(int,args.masks.read_text().split()));profiles={r['pattern']:r for r in json.loads(args.profiles.read_text())};assert len(masks)==4116
    canonical=lambda f:min(rotate(f,h) for h in range(16));reverse=lambda f:sum(((f>>h)&1)<<((-h)%16) for h in range(16))
    patterns=mapping['patterns'];assert all(patterns[b][a]==reverse(patterns[a][b]) for a in range(45) for b in range(45))
    model=cp_model.CpModel();sx=[model.new_int_var(0,len(masks)-1,f'sx{a}') for a in range(45)];sz=[model.new_int_var(0,len(masks)-1,f'sz{b}') for b in range(45)]
    x=[model.new_int_var(0,16,f'x{a}') for a in range(45)];z=[model.new_int_var(0,16,f'z{b}') for b in range(45)];weight=[m.bit_count() for m in masks]
    for a in range(45):model.add_element(sx[a],weight,x[a]);model.add_element(sz[a],weight,z[a])
    e=[[model.new_int_var(0,16,f'e{a}_{b}') for b in range(45)] for a in range(45)]
    for a in range(45):
        model.add(sum(e[a])==x[a])
        for b in range(45):
            f=canonical(patterns[a][b])
            if not f:model.add(e[a][b]==0);continue
            if f.bit_count()==1:model.add(x[a]+z[b]-e[a][b]<=16);continue
            p=profiles[f];q=profiles[canonical(reverse(f))]
            zero=model.new_int_var(0,16,f'zeroZ{a}_{b}');own=model.new_int_var(0,16,f'ownX{a}_{b}')
            model.add_element(sx[a],p['zero'],zero);model.add_element(sx[a],p['owners'],own);model.add(z[b]-e[a][b]<=zero);model.add(e[a][b]<=own)
            zero2=model.new_int_var(0,16,f'zeroX{a}_{b}');own2=model.new_int_var(0,16,f'ownZ{a}_{b}')
            model.add_element(sz[b],q['zero'],zero2);model.add_element(sz[b],q['owners'],own2);model.add(x[a]-e[a][b]<=zero2);model.add(e[a][b]<=own2)
    for b in range(45):model.add(sum(e[a][b] for a in range(45))==z[b])
    model.add(sum(x)==128);model.add(sum(z)==128);model.add(x[12]<=11);model.add(z[12]<=11)
    root=Path(__file__).parent;X=[int(v,16) for v in (root/'pools/xcoords.txt').read_text().split()]
    for selected in combinations(range(45),3):
        rank=len(basis(X[16*a+h] for a in selected for h in range(16)))
        if rank<48:model.add(sum(x[a] for a in selected)<=rank);model.add(sum(z[a] for a in selected)<=rank)
    print('MODEL_BUILT',flush=True)
    solver=cp_model.CpSolver();solver.parameters.max_time_in_seconds=args.seconds;solver.parameters.num_search_workers=args.workers;solver.parameters.log_search_progress=True
    status=solver.solve(model);result={'status':solver.status_name(status),'scope':'necessary orbit-shape relaxation','physical_frame':False,'seconds':solver.wall_time,'masks':str(args.masks),'profiles':str(args.profiles)}
    if status in [cp_model.FEASIBLE,cp_model.OPTIMAL]:result.update(X_shapes=[masks[solver.value(v)] for v in sx],Z_shapes=[masks[solver.value(v)] for v in sz],X_counts=[solver.value(v) for v in x],Z_counts=[solver.value(v) for v in z],flow=[[solver.value(v) for v in row] for row in e])
    args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k not in ['flow','X_shapes','Z_shapes','X_counts','Z_counts']}),flush=True)


if __name__=='__main__':main()
