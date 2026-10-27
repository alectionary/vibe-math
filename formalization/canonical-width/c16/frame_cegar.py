#!/usr/bin/env python3
"""Exact128-selection SAT with independently checked model-refinement cuts.

No native SAT callbacks are used. A candidate model is either physically
materializable or rejected by a necessary algebraic/propagation certificate.
UNSAT remains pending until the final augmented CNF is independently proved.
"""
import argparse
from array import array
from collections import Counter
from datetime import datetime,timezone
import hashlib
import json
from pathlib import Path
import random
import signal
import subprocess
import sys
import time
from pysat.card import CardEnc,EncType
from pysat.solvers import Solver
from rank_oracle import basis,annihilator,zero_exclusion,rotate_row,seed_clauses
from rank_cut_check import CutChecker


def circuit(X,ids):
    rows={}
    for i in ids:
        v=X[i];tag=1<<i
        while v:
            p=v.bit_length()-1
            if p not in rows:rows[p]=(v,tag);break
            v^=rows[p][0];tag^=rows[p][1]
        if not v:
            core=[j for j in ids if tag>>j&1]
            return {'kind':'x_circuit','indices':core,'clause':[-i-1 for i in core]}
    return None


def make_cut(X,Z,az,ids):
    row=circuit(X,ids)
    if row:return row
    bits=sum(1<<i for i in ids);zero=basis(z for z,m in zip(Z,az) if not m&bits)
    if len(zero)<128-len(ids):return zero_exclusion(X,Z,az,ids,bits,zero)
    eligible=basis(z for z,m in zip(Z,az) if (m&bits).bit_count()<=1)
    if len(eligible)<128:
        w=annihilator(eligible)
        return {'kind':'z_eligible','indices':ids,'annihilator':hex(w),'clause':[-i-1 for i in ids]}
    return {'kind':'forced_propagation','indices':ids,'clause':[-i-1 for i in ids]}


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--seconds',type=float,default=3600);ap.add_argument('--deadline-utc');ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--solver',default='cadical195');ap.add_argument('--seed4-cap',type=int,default=11);ap.add_argument('--seed',type=int,default=20261027)
    ap.add_argument('--pool-directory',type=Path);ap.add_argument('--seed-lemmas',type=Path,nargs='*',default=[]);ap.add_argument('--propagation-library',type=Path,required=True)
    ap.add_argument('--cuts-per-model',type=int,default=4);ap.add_argument('--subset-size',type=int,default=16);ap.add_argument('--assume-frame',type=Path);ap.add_argument('--no-cyclic',action='store_true');ap.add_argument('--child',action='store_true',help=argparse.SUPPRESS)
    args=ap.parse_args()
    if not args.child:
        deadline=datetime.fromisoformat(args.deadline_utc.replace('Z','+00:00')) if args.deadline_utc else None
        allowance=args.seconds
        if deadline:allowance=min(allowance,max(0,(deadline-datetime.now(timezone.utc)).total_seconds()))
        child=subprocess.Popen([sys.executable,str(Path(__file__).resolve())]+sys.argv[1:]+['--child']);expired=False
        try:child.wait(timeout=allowance)
        except subprocess.TimeoutExpired:
            expired=True;child.terminate()
            try:child.wait(timeout=3)
            except subprocess.TimeoutExpired:child.kill();child.wait()
        d=json.loads(args.output.read_text()) if args.output.exists() else {}
        if d.get('status') in [None,'RUNNING']:d['status']='PROCESS_TIME_LIMIT' if expired else 'ERROR'
        d['child_returncode']=child.returncode;d['outer_wall_limit']=allowance;args.output.write_text(json.dumps(d,indent=2)+'\n');return
    root=Path(__file__).parent;pool=args.pool_directory or root/'pools';X=[int(v,16) for v in (pool/'xcoords.txt').read_text().split()];Z=[int(v,16) for v in (pool/'zcoords.txt').read_text().split()];n=len(X)
    assert len(X)==len(Z)==720 and len(basis(X))==len(basis(Z))==128
    rng=random.Random(args.seed);checker=CutChecker(X,Z,cyclic=not args.no_cyclic);az=checker.az
    from native_forced_propagation import NativeForcedPropagation
    native=NativeForcedPropagation(X,Z,args.propagation_library)
    enc=CardEnc.equals(list(range(1,n+1)),128,top_id=n,encoding=EncType.kmtotalizer);clauses=enc.clauses;top=enc.nv
    for w in Z+[1<<p for p in range(128)]:clauses.append([i+1 for i,x in enumerate(X) if (x&w).bit_count()%2])
    if args.seed4_cap<16:
        mono=[i+1 for i,x in enumerate(X) if x.bit_count()==1 and (x>>64)&65535];enc=CardEnc.atmost(mono,args.seed4_cap,top_id=top,encoding=EncType.seqcounter);clauses.extend(enc.clauses);top=enc.nv
    if args.seed_lemmas:clauses.extend(seed_clauses(X,Z,args.seed_lemmas,args.output.with_suffix('.seed.jsonl')))
    assumptions=[]
    if args.assume_frame:
        selected={i for i,j in json.loads(args.assume_frame.read_text())['pool_pairs']};assumptions=[i+1 if i in selected else -i-1 for i in range(n)]
    clauses.extend([[lit] for lit in assumptions])
    base=args.output.with_suffix('.base.cnf')
    with base.open('w') as out:
        out.write(f'p cnf {top} {len(clauses)}\n')
        for row in clauses:out.write(' '.join(map(str,row))+' 0\n')
    result={'status':'RUNNING','model':'exact128_X_CEGAR','solver':args.solver,'variables':top,'base_clauses':len(clauses),'seed4_cap':args.seed4_cap,'assumptions':bool(assumptions),'seed':args.seed,'cuts_per_model':args.cuts_per_model,'subset_size':args.subset_size,'base_cnf_sha256':hashlib.sha256(base.read_bytes()).hexdigest(),'models':0,'cut_classes':0,'added_clauses':0}
    log=args.output.with_suffix('.lemmas.jsonl').open('w');seen=set();extra=[];kinds=Counter();start=time.monotonic();last=start;solve_seconds=0;check_seconds=0
    def snapshot():
        result.update(wall_seconds=time.monotonic()-start,solve_seconds=solve_seconds,check_seconds=check_seconds,cut_kinds=dict(kinds));args.output.write_text(json.dumps(result,indent=2)+'\n')
    snapshot();print(json.dumps(result),flush=True)
    with Solver(name=args.solver,bootstrap_with=clauses) as solver:
        solver.set_phases([-i for i in range(1,n+1)])
        while True:
            t=time.monotonic();status=solver.solve(assumptions=assumptions);solve_seconds+=time.monotonic()-t
            if not status:
                result['status']='UNSAT_PENDING_CERTIFICATE';break
            model={lit for lit in solver.get_model() if lit>0};chosen=[i for i in range(n) if i+1 in model];assert len(chosen)==128;bits=sum(1<<i for i in chosen);result['models']+=1;t=time.monotonic()
            dep=circuit(X,chosen);owners={};
            if dep is None:
                for j,m in enumerate(az):
                    label=m&bits
                    if label and not label&(label-1):owners[(label&-label).bit_length()-1]=j
                if len(owners)==128:
                    pairs=[[i,owners[i]] for i in chosen];assert all((X[i]&Z[j]).bit_count()%2==(a==b) for a,(i,_) in enumerate(pairs) for b,(_,j) in enumerate(pairs));result.update(status='SAT',pool_pairs=pairs);check_seconds+=time.monotonic()-t;break
            rows=[]
            for attempt in range(args.cuts_per_model):
                sample=rng.sample(chosen,min(args.subset_size,len(chosen)))
                core=native.exclusion(sum(1<<i for i in sample))
                if core is not None:rows.append(make_cut(X,Z,az,core))
            if not rows:
                if dep:rows=[dep]
                else:
                    core=native.exclusion(bits);assert core is not None;rows=[make_cut(X,Z,az,core)]
            added=0
            for row in rows:
                assert set(row['indices'])<=set(chosen);checker.check(row)
                generated=[]
                for h in range(1 if args.no_cyclic else 16):
                    c=rotate_row(row,h,X,Z)['clause'] if not args.no_cyclic else row['clause'];key=hashlib.sha256(array('i',sorted(c)).tobytes()).digest()
                    if key in seen:continue
                    seen.add(key);generated.append(c)
                if not generated:continue
                for c in generated:solver.add_clause(c)
                extra.extend(generated);added+=len(generated);result['cut_classes']+=1;kinds[row['kind']]+=1
                if not args.no_cyclic:row=dict(row,cyclic=True)
                log.write(json.dumps(row)+'\n');log.flush()
            assert added>0,'A satisfying model must be rejected by a new necessary clause.'
            result['added_clauses']+=added;check_seconds+=time.monotonic()-t
            if time.monotonic()-last>=10:
                result['statistics']=solver.accum_stats();snapshot();print(json.dumps({k:v for k,v in result.items() if k not in ['statistics']}),flush=True);last=time.monotonic()
        result['statistics']=solver.accum_stats()
    log.close();native.close()
    if result['status']=='UNSAT_PENDING_CERTIFICATE':
        with args.output.with_suffix('.final.cnf').open('w') as out:
            out.write(f'p cnf {top} {len(clauses)+len(extra)}\n')
            for row in clauses+extra:out.write(' '.join(map(str,row))+' 0\n')
    snapshot();print(json.dumps({k:v for k,v in result.items() if k!='pool_pairs'}),flush=True)


if __name__=='__main__':main()
