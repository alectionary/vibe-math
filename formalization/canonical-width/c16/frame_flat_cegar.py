#!/usr/bin/env python3
"""Native-cardinality selector refinement using certified matroid flat cuts.

A full X basis has at most rank(F) members in every pool flat F. Native
cardinality constraints avoid introducing a new CNF counter for each such cut.
An UNSAT result needs conversion of all recorded cardinalities to a static CNF
and an independently checked proof; this program does not claim that bridge.
"""
import argparse
from collections import Counter
from datetime import datetime,timezone
import hashlib
import json
from pathlib import Path
import random
import subprocess
import sys
import time
from pysat.solvers import Solver
from frame_cegar import circuit,make_cut
from rank_cut_check import CutChecker,echelon,in_span
from rank_oracle import basis,rotate_row,seed_clauses


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--seconds',type=float,default=1800);ap.add_argument('--deadline-utc');ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--seed',type=int,default=20261027);ap.add_argument('--seed4-cap',type=int,default=11);ap.add_argument('--pool-directory',type=Path);ap.add_argument('--propagation-library',type=Path,required=True)
    ap.add_argument('--seed-lemmas',type=Path,nargs='*',default=[]);ap.add_argument('--hint',type=Path);ap.add_argument('--assume-frame',type=Path);ap.add_argument('--cuts-per-model',type=int,default=2);ap.add_argument('--subset-size',type=int,default=16);ap.add_argument('--no-cyclic',action='store_true');ap.add_argument('--child',action='store_true',help=argparse.SUPPRESS);args=ap.parse_args()
    if not args.child:
        allowance=args.seconds
        if args.deadline_utc:allowance=min(allowance,max(0,(datetime.fromisoformat(args.deadline_utc.replace('Z','+00:00'))-datetime.now(timezone.utc)).total_seconds()))
        child=subprocess.Popen([sys.executable,str(Path(__file__).resolve())]+sys.argv[1:]+['--child']);expired=False
        try:child.wait(timeout=allowance)
        except subprocess.TimeoutExpired:
            expired=True;child.terminate()
            try:child.wait(timeout=3)
            except subprocess.TimeoutExpired:child.kill();child.wait()
        result=json.loads(args.output.read_text()) if args.output.exists() else {}
        if result.get('status') in [None,'RUNNING']:result['status']='PROCESS_TIME_LIMIT' if expired else 'ERROR'
        result.update(child_returncode=child.returncode,outer_wall_limit=allowance);args.output.write_text(json.dumps(result,indent=2)+'\n');return
    root=Path(__file__).parent;pool=args.pool_directory or root/'pools';X=[int(s,16) for s in (pool/'xcoords.txt').read_text().split()];Z=[int(s,16) for s in (pool/'zcoords.txt').read_text().split()]
    assert len(X)==len(Z)==720 and len(basis(X))==len(basis(Z))==128
    checker=CutChecker(X,Z,cyclic=not args.no_cyclic);az=checker.az
    from native_forced_propagation import NativeForcedPropagation
    native=NativeForcedPropagation(X,Z,args.propagation_library);rng=random.Random(args.seed)
    clauses=[[i+1 for i,x in enumerate(X) if (x&w).bit_count()%2] for w in Z+[1<<p for p in range(128)]]
    if args.seed_lemmas:clauses.extend(seed_clauses(X,Z,args.seed_lemmas,args.output.with_suffix('.seed.jsonl')))
    cardinalities=[{'literals':list(range(1,721)),'bound':128},{'literals':list(range(-1,-721,-1)),'bound':592}]
    if args.seed4_cap<16:
        cardinalities.append({'literals':[i+1 for i,x in enumerate(X) if x.bit_count()==1 and x>>64&65535],'bound':args.seed4_cap})
    if args.assume_frame:
        selected={i for i,j in json.loads(args.assume_frame.read_text())['pool_pairs']};clauses.extend([[i+1 if i in selected else -i-1] for i in range(720)])
    base={'clauses':clauses,'atmost':cardinalities};args.output.with_suffix('.native-base.json').write_text(json.dumps(base)+'\n')
    result={'status':'RUNNING','model':'exact128_X_native_flat_CEGAR','assumptions':bool(args.assume_frame),'seed':args.seed,'seed4_cap':args.seed4_cap,'base_clauses':len(clauses),'models':0,'independent_models':0,'dependent_models':0,'flat_classes':0,'flat_constraints':0,'cut_classes':0,'added_clauses':0,'best_private_pairs':0}
    start=time.monotonic();last=start;solve_seconds=0;check_seconds=0;kinds=Counter();seen=set();flat_seen=set()
    log=args.output.with_suffix('.lemmas.jsonl').open('w');flog=args.output.with_suffix('.flats.jsonl').open('w')
    def snapshot():
        result.update(wall_seconds=time.monotonic()-start,solve_seconds=solve_seconds,check_seconds=check_seconds,cut_kinds=dict(kinds));args.output.write_text(json.dumps(result,indent=2)+'\n')
    snapshot();print(json.dumps(result),flush=True)
    with Solver(name='minicard',bootstrap_with=clauses) as solver:
        for row in cardinalities:solver.add_atmost(row['literals'],row['bound'])
        preferred=set()
        if args.hint:preferred={i for i,j in json.loads(args.hint.read_text())['pool_pairs']}
        solver.set_phases([i+1 if i in preferred else -i-1 for i in range(720)])
        while True:
            t=time.monotonic();status=solver.solve();solve_seconds+=time.monotonic()-t
            if not status:result['status']='UNSAT_PENDING_CNF_AND_CERTIFICATE';break
            selected={v-1 for v in solver.get_model() if 0<v<=720};chosen=sorted(selected);assert len(chosen)==128;bits=sum(1<<i for i in chosen);result['models']+=1;t=time.monotonic()
            span=echelon(X[i] for i in chosen);rank=len(span)
            if rank<128:
                result['dependent_models']+=1
                flat=[i for i,x in enumerate(X) if in_span(x,span)];assert selected<=set(flat) and len(echelon(X[i] for i in flat))==rank
                generated=[]
                for h in range(1 if args.no_cyclic else 16):
                    shifted=tuple(sorted(i//16*16+(i%16+h)%16 for i in flat));key=(shifted,rank)
                    if key in flat_seen:continue
                    flat_seen.add(key);solver.add_atmost([i+1 for i in shifted],rank);generated.append(shifted)
                assert generated
                flog.write(json.dumps({'indices':flat,'rank':rank,'cyclic':not args.no_cyclic})+'\n');flog.flush();result['flat_classes']+=1;result['flat_constraints']+=len(generated)
            else:
                result['independent_models']+=1;owners={}
                for j,mask in enumerate(az):
                    label=mask&bits
                    if label and not label&(label-1):owners[label.bit_length()-1]=j
                if len(owners)>result['best_private_pairs']:
                    result['best_private_pairs']=len(owners);args.output.with_suffix('.best.json').write_text(json.dumps({'scope':'partial frame from a full X basis','pool_pairs':[[i,j] for i,j in sorted(owners.items())]})+'\n')
                if len(owners)==128:result.update(status='SAT',pool_pairs=[[i,owners[i]] for i in chosen]);check_seconds+=time.monotonic()-t;break
                rows=[]
                for attempt in range(args.cuts_per_model):
                    core=native.exclusion(sum(1<<i for i in rng.sample(chosen,min(args.subset_size,128))))
                    if core is not None:rows.append(make_cut(X,Z,az,core))
                if not rows:
                    core=native.exclusion(bits);assert core is not None;rows=[make_cut(X,Z,az,core)]
                added=0
                for row in rows:
                    checker.check(row);generated=[]
                    for h in range(1 if args.no_cyclic else 16):
                        clause=rotate_row(row,h,X,Z)['clause'] if not args.no_cyclic else row['clause'];key=tuple(sorted(clause))
                        if key in seen:continue
                        seen.add(key);solver.add_clause(clause);generated.append(clause)
                    if not generated:continue
                    result['cut_classes']+=1;kinds[row['kind']]+=1;added+=len(generated)
                    if not args.no_cyclic:row=dict(row,cyclic=True)
                    log.write(json.dumps(row)+'\n');log.flush()
                assert added;result['added_clauses']+=added
            check_seconds+=time.monotonic()-t
            if time.monotonic()-last>=10:snapshot();print(json.dumps(result),flush=True);last=time.monotonic()
        result['statistics']=solver.accum_stats()
    native.close();log.close();flog.close();snapshot();print(json.dumps({k:v for k,v in result.items() if k!='pool_pairs'}),flush=True)


if __name__=='__main__':main()
