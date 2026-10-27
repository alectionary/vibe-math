#!/usr/bin/env python3
"""CNF induced-matching model using shared threshold-two counters.

For 128 selected X/Z operators, each selected operator has selected degree
exactly one. Every pool vector has positive selected degree because the chosen
opposite sector is a basis. The >=2 counters for different neighborhoods share
subtrees. UNKNOWN/interruption is not an exclusion.
"""
import argparse
from collections import defaultdict
import hashlib
from itertools import combinations
import json
from pathlib import Path
import signal
import subprocess
import sys
import time
from pysat.card import CardEnc, EncType
from pysat.solvers import Solver


class SharedCounters:
    def __init__(self, top):
        self.top=top;self.clauses=[];self.cache={}
    def var(self):
        self.top+=1;return self.top
    def count(self, mask, base):
        if mask&(mask-1)==0:return (base+mask.bit_length(),0)
        key=(base,mask)
        if key in self.cache:return self.cache[key]
        lo=(mask&-mask).bit_length()-1;hi=mask.bit_length()-1
        step=1<<((lo^hi).bit_length()-1);boundary=(hi//step)*step
        left=mask&((1<<boundary)-1);right=mask^left
        assert left and right
        a,a2=self.count(left,base);b,b2=self.count(right,base)
        c,c2=self.var(),self.var()
        self.clauses.extend([[-a,c],[-b,c],[-c,a,b],[-a,-b,c2]])
        if a2:self.clauses.append([-a2,c2])
        if b2:self.clauses.append([-b2,c2])
        optional=[v for v in (a2,b2) if v]
        self.clauses.extend([[-c2]+optional+[a],[-c2]+optional+[b]])
        self.cache[key]=(c,c2);return c,c2


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--solver',default='cadical195')
    ap.add_argument('--seconds',type=float,default=1800)
    ap.add_argument('--seed4-cap',type=int,default=12)
    ap.add_argument('--fix-orbit',type=int)
    ap.add_argument('--exclude-orbits',type=int,nargs='*',default=[])
    ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--proof',action='store_true')
    ap.add_argument('--cnf',type=Path)
    ap.add_argument('--pool-directory',type=Path)
    ap.add_argument('--assume-frame',type=Path,help='Force the vertex sets of a supplied pool_pairs witness.')
    ap.add_argument('--child',action='store_true',help=argparse.SUPPRESS)
    args=ap.parse_args();root=Path(__file__).parent
    if not args.child:
        # CaDiCaL's PySAT wrapper cannot be interrupted by another Python
        # thread. A separate parent process enforces wall time instead.
        proc=subprocess.Popen([sys.executable,str(Path(__file__).resolve())]+sys.argv[1:]+['--child'])
        try:proc.wait(timeout=args.seconds+5)
        except subprocess.TimeoutExpired:
            proc.send_signal(signal.SIGINT)
            try:proc.wait(timeout=5)
            except subprocess.TimeoutExpired:proc.kill();proc.wait()
            data=json.loads(args.output.read_text()) if args.output.exists() else {}
            if data.get('status')=='RUNNING':data['status']='PROCESS_TIME_LIMIT'
            data['outer_process_limit_seconds']=args.seconds+5
            args.output.write_text(json.dumps(data,indent=2)+'\n')
        return
    pooldir=args.pool_directory or root/'pools'
    X=[int(s,16) for s in (pooldir/'xcoords.txt').read_text().split()]
    Z=[int(s,16) for s in (pooldir/'zcoords.txt').read_text().split()]
    assert len(X)==len(Z)==720
    anti=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X]
    assert all(((anti[i]>>j)&1)==((anti[j]>>i)&1) for i in range(720) for j in range(720))
    counter=SharedCounters(1440);clauses=counter.clauses;t0=time.monotonic()
    for i,mask in enumerate(anti):
        z1,z2=counter.count(mask,720);x1,x2=counter.count(mask,0)
        clauses.extend([[z1],[x1]])
        if z2:clauses.append([-(i+1),-z2])
        if x2:clauses.append([-(721+i),-x2])
    top=counter.top
    if args.solver=='minicard':
        native=True
    else:
        native=False
        for base in [0,720]:
            enc=CardEnc.equals([base+i+1 for i in range(720)],128,top_id=top,encoding=EncType.cardnetwrk)
            clauses.extend(enc.clauses);top=enc.nv
    mono=[i for i,x in enumerate(X) if x.bit_count()==1 and ((x>>64)&65535)]
    if args.seed4_cap >= 0:
        for base in [0,720]:
            enc=CardEnc.atmost([base+i+1 for i in mono],args.seed4_cap,top_id=top,encoding=EncType.seqcounter)
            clauses.extend(enc.clauses);top=enc.nv
    for values,base in [(X,0),(Z,720)]:
        ids={v:i for i,v in enumerate(values)};pairs=defaultdict(list);circuits=set()
        for i,a in enumerate(values):
            for j in range(i):
                w=a^values[j];pairs[w].append((i,j))
                if w in ids:circuits.add(tuple(sorted((i,j,ids[w]))))
        for entries in pairs.values():
            for a,b in combinations(entries,2):
                row=tuple(sorted(a+b))
                if len(set(row))==4:circuits.add(row)
        for row in circuits:clauses.append([-(base+i+1) for i in row])
    if args.fix_orbit is not None:clauses.append([16*args.fix_orbit+1])
    for orbit in args.exclude_orbits:
        for h in range(16):clauses.append([-(16*orbit+h+1)])
    assumptions=[]
    if args.assume_frame:
        pairs=json.loads(args.assume_frame.read_text())['pool_pairs']
        chosenX={i for i,j in pairs};chosenZ={j for i,j in pairs}
        assumptions=[i+1 if i in chosenX else -(i+1) for i in range(720)]
        assumptions += [721+j if j in chosenZ else -(721+j) for j in range(720)]
    if args.cnf:
        with args.cnf.open('w') as out:
            out.write(f'p cnf {top} {len(clauses)}\n')
            for c in clauses:out.write(' '.join(map(str,c))+' 0\n')
    result={'solver':args.solver,'variables':top,'clauses':len(clauses),'shared_counter_nodes':len(counter.cache),
            'build_seconds':time.monotonic()-t0,'seed4_cap':args.seed4_cap,
            'fix_orbit':args.fix_orbit,'exclude_orbits':args.exclude_orbits,'status':'RUNNING'}
    args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)
    with Solver(name=args.solver,bootstrap_with=clauses,with_proof=args.proof) as solver:
        if native:
            for base in [0,720]:
                solver.add_atmost([base+i+1 for i in range(720)],128)
                solver.add_atmost([-(base+i+1) for i in range(720)],592)
        start=time.monotonic()
        try:status=solver.solve(assumptions=assumptions)
        except KeyboardInterrupt:status=None
        result['solve_seconds']=time.monotonic()-start
        result['status']='SAT' if status is True else 'UNSAT' if status is False else 'UNKNOWN'
        result['statistics']=solver.accum_stats()
        if status:
            model=set(l for l in solver.get_model() if l>0)
            xs=[i for i in range(720) if i+1 in model];zs=[j for j in range(720) if j+721 in model]
            assert len(xs)==len(zs)==128
            pairs=[]
            for i in xs:
                partners=[j for j in zs if (anti[i]>>j)&1];assert len(partners)==1
                pairs.append([i,partners[0]])
            assert len(set(j for i,j in pairs))==128
            assert all(((X[i]&Z[j]).bit_count()%2)==(a==b)
                       for a,(i,_) in enumerate(pairs) for b,(_,j) in enumerate(pairs))
            result['pool_pairs']=pairs
        if status is False and args.proof:
            path=args.output.with_suffix('.drat');path.write_text('\n'.join(solver.get_proof())+'\n')
            result['proof_file']=str(path);result['proof_sha256']=hashlib.sha256(path.read_bytes()).hexdigest()
    args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)


if __name__=='__main__':main()
