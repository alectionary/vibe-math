#!/usr/bin/env python3
"""Bounded partial-frame construction through exact reduced neighborhoods.

Preserve most known pairs, project candidates by their commuting conditions,
and ask for one additional pair. Local failure is never a global exclusion.
"""
from pathlib import Path
import argparse
import hashlib
import json
import random
import time
from ortools.sat.python import cp_model
from audit_pools import exchange
from verify_partial_frame import mask,shift

ROOT=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--seconds',type=float,default=2);ap.add_argument('--trials',type=int,default=24);a=ap.parse_args()
    start=time.monotonic();X=[int(v,16) for v in (ROOT/'pools/xcoords.txt').read_text().split()];Z=[int(v,16) for v in (ROOT/'pools/zcoords.txt').read_text().split()]
    physical=json.loads((ROOT/'physical-pool-source.json').read_text());Zp=[shift(mask(v),h) for v in physical['Z_orbit_representatives'] for h in range(16)];Xp=list(map(exchange,Zp))
    xi={v:i for i,v in enumerate(Xp)};zi={v:i for i,v in enumerate(Zp)}
    initial=ROOT/'partial-frame-88.json';pairs=[(xi[mask(p['X'])],zi[mask(p['Z'])]) for p in json.loads(initial.read_text())['pairs']]
    assert len(pairs)==88 and all((X[i]&Z[j]).bit_count()%2==(u==v) for u,(i,_) in enumerate(pairs) for v,(_,j) in enumerate(pairs))
    A=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X]
    AT=[sum(((A[i]>>j)&1)<<i for i in range(720)) for j in range(720)]
    def candidates(fixed):
        fx=sum(1<<i for i,j in fixed);fz=sum(1<<j for i,j in fixed)
        I=[i for i in range(720) if not(fx>>i&1) and not(A[i]&fz)]
        J=[j for j in range(720) if not(fz>>j&1) and not(AT[j]&fx)]
        return I,J
    I,J=candidates(pairs);direct_sizes=[len(I),len(J)]
    direct=sum(A[i]>>j&1 for i in I for j in J);assert direct==0
    rng=random.Random(20261028);trials=[];witness=None
    for trial in range(a.trials):
        count=[8,16,24,32][trial%4];released=sorted(rng.sample(range(88),count));fixed=[p for k,p in enumerate(pairs) if k not in released]
        I,J=candidates(fixed);graph=[[b for b,j in enumerate(J) if A[i]>>j&1] for i in I]
        trans=[[u for u,row in enumerate(graph) if v in row] for v in range(len(J))]
        model=cp_model.CpModel();xs=[model.new_bool_var('x'+str(i)) for i in I];zs=[model.new_bool_var('z'+str(j)) for j in J]
        model.add(sum(xs)==count+1);model.add(sum(zs)==count+1)
        for u,nb in enumerate(graph):model.add(sum(zs[v] for v in nb)==1).only_enforce_if(xs[u])
        for v,nb in enumerate(trans):model.add(sum(xs[u] for u in nb)==1).only_enforce_if(zs[v])
        oldx={pairs[k][0] for k in released};oldz={pairs[k][1] for k in released}
        for i,x in zip(I,xs):model.add_hint(x,int(i in oldx))
        for j,z in zip(J,zs):model.add_hint(z,int(j in oldz))
        solver=cp_model.CpSolver();solver.parameters.num_search_workers=1;solver.parameters.random_seed=20261028+trial;solver.parameters.max_time_in_seconds=a.seconds
        status=solver.solve(model);record={'trial':trial,'released_pairs':released,'candidate_sizes':[len(I),len(J)],'edges':sum(map(len,graph)),'status':solver.status_name(status),'wall_seconds':solver.wall_time,'branches':solver.num_branches};trials.append(record)
        if status in [cp_model.OPTIMAL,cp_model.FEASIBLE]:
            extra=[(I[u],J[next(v for v in graph[u] if solver.value(zs[v]))]) for u in range(len(I)) if solver.value(xs[u])]
            full=fixed+extra;assert len(full)==89 and len(set(i for i,j in full))==len(set(j for i,j in full))==89
            assert all((X[i]&Z[j]).bit_count()%2==(u==v) for u,(i,_) in enumerate(full) for v,(_,j) in enumerate(full))
            def support(v):return [i for i in range(1088) if v>>i&1]
            witness={'n_pairs':89,'pairs':[{'X':support(Xp[i]),'Z':support(Zp[j])} for i,j in full],
                'scope':'Physical partial canonical frame; original128-pair problem unanswered. Independent physical checker required.'}
            a.output.with_suffix('.witness.json').write_text(json.dumps(witness,indent=2)+'\n');break
    result={'status':'CONSTRUCTION_FOUND_NEEDS_PHYSICAL_CHECK' if witness else 'NO_IMPROVEMENT_IN_TESTED_NEIGHBORHOODS','source_C16_answered':False,'initial_pairs':88,'candidate_pairs':89 if witness else 88,
        'seed':20261028,'single_worker':True,'solver_seconds_per_neighborhood':a.seconds,'frozen_release_sizes':[8,16,24,32],
        'direct_extension':{'remaining_X':direct_sizes[0],'remaining_Z':direct_sizes[1],'remaining_edges':direct,'maximal_under_direct_extension':True},
        'trials':trials,'total_seconds':time.monotonic()-start,'initial_physical_witness_sha256':hashlib.sha256(initial.read_bytes()).hexdigest(),
        'limit':'Failures concern only the recorded retained-pair neighborhoods; no global maximum or source width exclusion follows.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:result[k] for k in ['status','candidate_pairs','total_seconds']}),flush=True)


if __name__=='__main__':main()
