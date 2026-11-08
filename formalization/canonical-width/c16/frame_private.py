#!/usr/bin/env python3
"""Exact full-frame model via private neighbors, without Z-selection variables.

For a set S of 128 X vectors, a Z vector is private if it anticommutes with
exactly one member of S. S extends to a dual pool basis iff each member has a
private neighbor: choose one for each, obtaining the identity Gram matrix.
The private neighbors then span the Z sector, so every pool X has a private
neighbor and every pool Z has positive pairing degree against S. These are
equivalent redundant strengthenings when |S|=128.
"""
import argparse
import hashlib
import json
from pathlib import Path
import signal
import subprocess
import sys
import time
from pysat.card import CardEnc,EncType
from pysat.solvers import Solver
from frame_sat import SharedCounters


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--solver',default='cadical195');ap.add_argument('--seconds',type=float,default=1800)
    ap.add_argument('--seed4-cap',type=int,default=12);ap.add_argument('--pool-directory',type=Path)
    ap.add_argument('--assume-frame',type=Path);ap.add_argument('--fix-orbit',type=int)
    ap.add_argument('--exclude-orbits',type=int,nargs='*',default=[])
    ap.add_argument('--output',type=Path,required=True);ap.add_argument('--cnf',type=Path)
    ap.add_argument('--proof',action='store_true');ap.add_argument('--child',action='store_true',help=argparse.SUPPRESS)
    ap.add_argument('--private-count',action='store_true',help='Enforce exactly 128 private Z vectors (pool classes must be distinct).')
    ap.add_argument('--rank-oracle',action='store_true')
    ap.add_argument('--both-seed4-caps',action='store_true');ap.add_argument('--dual-oracle',action='store_true');ap.add_argument('--basis-propagation',action='store_true');ap.add_argument('--propagation-library',type=Path)
    ap.add_argument('--private-rank-cuts',action='store_true')
    ap.add_argument('--cyclic-lemmas',action='store_true');ap.add_argument('--seed-lemmas',type=Path,nargs='*',default=[])
    args=ap.parse_args();root=Path(__file__).parent
    if not args.child:
        p=subprocess.Popen([sys.executable,str(Path(__file__).resolve())]+sys.argv[1:]+['--child'])
        try:p.wait(timeout=args.seconds+5)
        except subprocess.TimeoutExpired:
            p.send_signal(signal.SIGINT)
            try:p.wait(timeout=5)
            except subprocess.TimeoutExpired:p.kill();p.wait()
            d=json.loads(args.output.read_text()) if args.output.exists() else {}
            if d.get('status')=='RUNNING':d['status']='PROCESS_TIME_LIMIT'
            d['outer_process_limit_seconds']=args.seconds+5;args.output.write_text(json.dumps(d,indent=2)+'\n')
        d=json.loads(args.output.read_text()) if args.output.exists() else {}
        if d.get('status')=='RUNNING':d['status']='ERROR'
        d['child_returncode']=p.returncode
        args.output.write_text(json.dumps(d,indent=2)+'\n')
        return
    pooldir=args.pool_directory or root/'pools'
    X=[int(s,16) for s in (pooldir/'xcoords.txt').read_text().split()]
    Z=[int(s,16) for s in (pooldir/'zcoords.txt').read_text().split()]
    n=len(X);assert n==len(Z)==720
    ax=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X]
    az=[sum(((x&z).bit_count()%2)<<i for i,x in enumerate(X)) for z in Z]
    start=time.monotonic();counter=SharedCounters(n);degrees=[counter.count(mask,0) for mask in az]
    clauses=counter.clauses
    for one,two in degrees:clauses.append([one])
    functional_masks=ax+[sum(((z>>p)&1)<<j for j,z in enumerate(Z)) for p in range(128)]
    for neighbors in functional_masks:
        js=[j for j in range(n) if neighbors>>j&1]
        if any(degrees[j][1]==0 for j in js):continue
        clauses.append([-degrees[j][1] for j in js])
    top=counter.top
    if args.solver!='minicard':
        enc=CardEnc.equals(list(range(1,n+1)),128,top_id=top,encoding=EncType.cardnetwrk)
        clauses.extend(enc.clauses);top=enc.nv
    private_lits=[-two for one,two in degrees if two]
    private_target=128-sum(two==0 for one,two in degrees)
    if args.private_count:
        assert len(set(Z))==len(Z)
        if args.solver!='minicard':
            enc=CardEnc.equals(private_lits,private_target,top_id=top,encoding=EncType.cardnetwrk)
            clauses.extend(enc.clauses);top=enc.nv
    if args.seed4_cap>=0:
        mono=[i+1 for i,x in enumerate(X) if x.bit_count()==1 and ((x>>64)&65535)]
        enc=CardEnc.atmost(mono,args.seed4_cap,top_id=top,encoding=EncType.seqcounter)
        clauses.extend(enc.clauses);top=enc.nv
        if args.both_seed4_caps:
            assert all((ax[i]>>j&1)==(az[i]>>j&1) for i in range(n) for j in range(n))
            mono_indices=[i for i,x in enumerate(X) if x.bit_count()==1 and ((x>>64)&65535)]
            constants=sum(degrees[j][1]==0 for j in mono_indices)
            cap=args.seed4_cap-constants
            if cap<0:clauses.append([])
            else:
                enc=CardEnc.atmost([-degrees[j][1] for j in mono_indices if degrees[j][1]],cap,top_id=top,encoding=EncType.seqcounter)
                clauses.extend(enc.clauses);top=enc.nv
    if args.fix_orbit is not None:clauses.append([16*args.fix_orbit+1])
    for orbit in args.exclude_orbits:
        clauses.extend([[-(16*orbit+h+1)] for h in range(16)])
    assumptions=[]
    if args.assume_frame:
        selected={i for i,j in json.loads(args.assume_frame.read_text())['pool_pairs']}
        assumptions=[i+1 if i in selected else -(i+1) for i in range(n)]
    if args.seed_lemmas:
        from rank_oracle import seed_clauses
        clauses.extend(seed_clauses(X,Z,args.seed_lemmas,args.output.with_suffix('.seed.jsonl'),[-two if two else 0 for one,two in degrees]))
    if args.cnf:
        with args.cnf.open('w') as out:
            out.write(f'p cnf {top} {len(clauses)}\n')
            for c in clauses:out.write(' '.join(map(str,c))+' 0\n')
    result={'status':'RUNNING','model':'private_neighbors','solver':args.solver,'variables':top,
            'clauses':len(clauses),'counter_nodes':len(counter.cache),'build_seconds':time.monotonic()-start,
            'seed4_cap':args.seed4_cap,'fix_orbit':args.fix_orbit,'exclude_orbits':args.exclude_orbits}
    result['both_seed4_caps']=args.both_seed4_caps;result['dual_oracle']=args.dual_oracle;result['basis_propagation']=args.basis_propagation;result['propagation_library']=str(args.propagation_library) if args.propagation_library else None
    result['private_count']=args.private_count
    result['private_rank_cuts']=args.private_rank_cuts
    if args.private_rank_cuts or args.dual_oracle:result['private_literals']=[-two if two else 0 for one,two in degrees]
    args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)
    with Solver(name=args.solver,bootstrap_with=clauses,with_proof=args.proof) as solver:
        oracle=None
        if args.rank_oracle or args.private_rank_cuts or args.dual_oracle:
            from rank_oracle import RankOracle
            private_literals=[-two if two else 0 for one,two in degrees] if args.private_rank_cuts else None
            if args.dual_oracle:
                from dual_rank_oracle import DualRankOracle
                private_literals=[-two if two else 0 for one,two in degrees]
                oracle=DualRankOracle(X,Z,args.output,private_literals,cyclic=args.cyclic_lemmas,basis_propagation=args.basis_propagation,propagation_library=args.propagation_library)
            else:
                oracle=RankOracle(X,Z,args.output.with_suffix('.lemmas.jsonl'),private_literals,cyclic=args.cyclic_lemmas,basis_propagation=args.basis_propagation,propagation_library=args.propagation_library)
            solver.connect_propagator(oracle)
            for i in range(1,n+1):solver.observe(i)
            if private_literals:
                for lit in private_literals:
                    if lit:solver.observe(abs(lit))
        if args.solver=='minicard':
            solver.add_atmost(list(range(1,n+1)),128);solver.add_atmost(list(range(-1,-n-1,-1)),n-128)
            if args.private_count:
                solver.add_atmost(private_lits,private_target)
                solver.add_atmost([-v for v in private_lits],len(private_lits)-private_target)
        start=time.monotonic()
        try:status=solver.solve(assumptions=assumptions)
        except KeyboardInterrupt:status=None
        result['solve_seconds']=time.monotonic()-start;result['statistics']=solver.accum_stats()
        result['status']='SAT' if status is True else 'UNSAT' if status is False else 'UNKNOWN'
        if oracle:
            result['oracle_statistics']=oracle.stats.copy();oracle.close()
        if status:
            model=set(l for l in solver.get_model() if l>0);chosen=[i for i in range(n) if i+1 in model]
            assert len(chosen)==128
            private={j:[i for i in chosen if (ax[i]>>j)&1] for j in range(n)}
            pairs=[[i,next(j for j,owners in private.items() if owners==[i])] for i in chosen]
            assert len(set(j for i,j in pairs))==128
            assert all(((X[i]&Z[j]).bit_count()%2)==(a==b)
                       for a,(i,_) in enumerate(pairs) for b,(_,j) in enumerate(pairs))
            result['pool_pairs']=pairs
        if status is False and args.proof:
            path=args.output.with_suffix('.drat');path.write_text('\n'.join(solver.get_proof())+'\n')
            result['proof_file']=str(path);result['proof_sha256']=hashlib.sha256(path.read_bytes()).hexdigest()
    args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)


if __name__=='__main__':main()
