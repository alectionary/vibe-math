#!/usr/bin/env python3
"""A 720-variable CDCL search with certified binary-rank constraints.

At a complete assignment, selected X vectors must be independent, span the
128-dimensional space, and admit a spanning Z pool of degree at most one.
These conditions are equivalent to a pool canonical frame. Partial violations
yield independently checkable clauses from RankOracle.
"""
import argparse
from collections import defaultdict
from itertools import combinations
import json
from pathlib import Path
import signal
import subprocess
import sys
import time
from pysat.card import CardEnc,EncType
from pysat.solvers import Solver
from rank_oracle import RankOracle,basis,seed_clauses


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--seconds',type=float,default=1800)
    ap.add_argument('--cardinality',choices=['none','kmtotalizer','mtotalizer','cardnetwrk','seqcounter'],default='none');ap.add_argument('--phase',choices=['negative','positive'],default='negative')
    ap.add_argument('--seed4-cap',type=int,default=16);ap.add_argument('--fix-orbit',type=int)
    ap.add_argument('--exclude-orbits',nargs='*',type=int,default=[])
    ap.add_argument('--pool-directory',type=Path);ap.add_argument('--assume-frame',type=Path)
    ap.add_argument('--output',type=Path,required=True);ap.add_argument('--proof',action='store_true')
    ap.add_argument('--propagation-library',type=Path);ap.add_argument('--native-library',type=Path);ap.add_argument('--opposite-units',action='store_true');ap.add_argument('--basis-propagation',action='store_true');ap.add_argument('--cyclic-lemmas',action='store_true');ap.add_argument('--seed-lemmas',type=Path,nargs='*',default=[])
    ap.add_argument('--child',action='store_true',help=argparse.SUPPRESS);args=ap.parse_args()
    if not args.child:
        p=subprocess.Popen([sys.executable,str(Path(__file__).resolve())]+sys.argv[1:]+['--child'])
        expired=False
        try:p.wait(timeout=args.seconds+5)
        except subprocess.TimeoutExpired:
            expired=True;p.send_signal(signal.SIGINT)
            try:p.wait(timeout=5)
            except subprocess.TimeoutExpired:p.kill();p.wait()
        d=json.loads(args.output.read_text()) if args.output.exists() else {}
        if d.get('status')=='RUNNING':d['status']='PROCESS_TIME_LIMIT' if expired else 'ERROR'
        d['child_returncode']=p.returncode
        if expired:d['outer_process_limit_seconds']=args.seconds+5
        args.output.write_text(json.dumps(d,indent=2)+'\n');return
    pooldir=args.pool_directory or Path(__file__).parent/'pools'
    X=[int(s,16) for s in (pooldir/'xcoords.txt').read_text().split()]
    Z=[int(s,16) for s in (pooldir/'zcoords.txt').read_text().split()];n=len(X)
    clauses=[]
    for z in Z+[1<<p for p in range(128)]:
        clauses.append([i+1 for i,x in enumerate(X) if (x&z).bit_count()%2])
    ids={x:i for i,x in enumerate(X)};sums=defaultdict(list);circuits=set()
    for i,x in enumerate(X):
        for j in range(i):
            y=x^X[j];sums[y].append((i,j))
            if y in ids:circuits.add(tuple(sorted((i,j,ids[y]))))
    for entries in sums.values():
        for a,b in combinations(entries,2):
            row=tuple(sorted(a+b))
            if len(set(row))==4:circuits.add(row)
    clauses.extend([[-i-1 for i in row] for row in circuits]);top=n
    if args.cardinality!='none':
        enc=CardEnc.equals(list(range(1,n+1)),128,top_id=top,encoding=getattr(EncType,args.cardinality))
        clauses.extend(enc.clauses);top=enc.nv
    if args.seed4_cap<16:
        mono=[i+1 for i,x in enumerate(X) if x.bit_count()==1 and ((x>>64)&65535)]
        enc=CardEnc.atmost(mono,args.seed4_cap,top_id=top,encoding=EncType.seqcounter)
        clauses.extend(enc.clauses);top=enc.nv
    if args.fix_orbit is not None:clauses.append([16*args.fix_orbit+1])
    for orbit in args.exclude_orbits:clauses.extend([[-(16*orbit+h+1)] for h in range(16)])
    assumptions=[]
    if args.assume_frame:
        chosen={i for i,j in json.loads(args.assume_frame.read_text())['pool_pairs']}
        assumptions=[i+1 if i in chosen else -(i+1) for i in range(n)]
    if args.seed_lemmas:clauses.extend(seed_clauses(X,Z,args.seed_lemmas,args.output.with_suffix('.seed.jsonl')))
    cnf=args.output.with_suffix('.cnf')
    with cnf.open('w') as out:
        out.write(f'p cnf {top} {len(clauses)}\n')
        for c in clauses:out.write(' '.join(map(str,c))+' 0\n')
    result={'status':'RUNNING','model':'rank_only','cardinality':args.cardinality,'basis_propagation':args.basis_propagation,'opposite_units':args.opposite_units,'native_library':str(args.native_library) if args.native_library else None,'propagation_library':str(args.propagation_library) if args.propagation_library else None,'variables':top,'clauses':len(clauses),
            'phase':args.phase,'seed4_cap':args.seed4_cap,'fix_orbit':args.fix_orbit,'exclude_orbits':args.exclude_orbits}
    args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)
    oracle=RankOracle(X,Z,args.output.with_suffix('.lemmas.jsonl'),cyclic=args.cyclic_lemmas,basis_propagation=args.basis_propagation,opposite_units=args.opposite_units,native_library=args.native_library,propagation_library=args.propagation_library)
    with Solver(name='cadical195',bootstrap_with=clauses,with_proof=args.proof) as solver:
        solver.connect_propagator(oracle)
        for i in range(1,n+1):solver.observe(i)
        solver.set_phases([-i if args.phase=='negative' else i for i in range(1,n+1)])
        start=time.monotonic()
        try:status=solver.solve(assumptions=assumptions)
        except KeyboardInterrupt:status=None
        result['status']='SAT' if status is True else 'UNSAT' if status is False else 'UNKNOWN'
        result['solve_seconds']=time.monotonic()-start;result['statistics']=solver.accum_stats()
        result['oracle_statistics']=oracle.stats.copy()
        if status:
            model=set(l for l in solver.get_model() if l>0);chosen=[i for i in range(n) if i+1 in model]
            assert len(chosen)==128 and len(basis(X[i] for i in chosen))==128
            owners={j:[i for i in chosen if (X[i]&z).bit_count()%2] for j,z in enumerate(Z)}
            pairs=[[i,next(j for j,own in owners.items() if own==[i])] for i in chosen]
            assert all(((X[i]&Z[j]).bit_count()%2)==(a==b)
                       for a,(i,_) in enumerate(pairs) for b,(_,j) in enumerate(pairs))
            result['pool_pairs']=pairs
        if status is False and args.proof:
            args.output.with_suffix('.drat').write_text('\n'.join(solver.get_proof())+'\n')
    oracle.close();args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)


if __name__=='__main__':main()
