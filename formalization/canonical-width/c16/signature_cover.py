#!/usr/bin/env python3
r"""Nonlinear cover refinement from16 simultaneous dual-expansion identities.

Outside the518 cover all16 signatures vanish. If a full frame avoids a retained
list D, its edges from C\D form a partial induced matching with XOR signature
65535. Proving that partial-matching problem UNSAT certifies D as a cover.
No claim that a SAT partial matching extends to a full frame is justified.
"""
from pathlib import Path
import argparse
import collections
import gzip
import hashlib
import json
import random
import subprocess
import sys
import tempfile
import time

ROOT=Path(__file__).resolve().parent


def canonical(i,j):
    a,b,h=i//16,j//16,(j-i)%16
    return min((a,b,h),(b,a,-h%16))


def logical_data():
    X,Z=[[int(s,16) for s in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in ['x','z']]
    rows=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X]
    cover=json.loads((ROOT/'joint-cover-results/source-witness-cover.json').read_text())
    C=[tuple(r['orbit_tuple']) for r in cover['cases']]
    pos={c:k for k,c in enumerate(C)}
    signaturesX=[sum(((x&Z[608+t]).bit_count()%2)<<t for t in range(16)) for x in X]
    signaturesZ=[sum(((X[608+t]&z).bit_count()%2)<<t for t in range(16)) for z in Z]
    edges=[]
    for i,row in enumerate(rows):
        for j in range(720):
            if not row>>j&1:
                continue
            sig=signaturesX[i]&signaturesZ[j]
            key=canonical(i,j)
            assert (sig!=0)==(key in pos)
            if sig:
                edges.append((i,j,sig,pos[key]))
    assert len(edges)==16304
    return rows,C,edges


def encode(rows,C,edges,with_xor=True,compress_signatures=False):
    m=len(edges);cnf=[];n=m
    left=collections.defaultdict(list);right=collections.defaultdict(list)
    edgevar={}
    for e,(i,j,s,c) in enumerate(edges,1):
        left[i].append(e);right[j].append(e);edgevar[i,j]=e
    pv={};qv={}
    for i in sorted(left):n+=1;pv[i]=n
    for j in sorted(right):n+=1;qv[j]=n
    selectors=[]
    for c in C:n+=1;selectors.append(n)
    for e,(i,j,s,c) in enumerate(edges,1):
        cnf.extend([[-e,pv[i]],[-e,qv[j]],[-e,selectors[c]]])
    for i in sorted(left):
        for j in sorted(right):
            if rows[i]>>j&1:
                clause=[-pv[i],-qv[j]]
                if (i,j) in edgevar:clause.append(edgevar[i,j])
                cnf.append(clause)
    # At most one selected edge per endpoint, using independent prefix flags.
    for side in [left,right]:
        for k in sorted(side):
            literals=side[k]
            if len(literals)<2:continue
            n+=1;old=n;cnf.append([-literals[0],old])
            for e in literals[1:-1]:
                n+=1;new=n
                cnf.extend([[-e,new],[-old,new],[-e,-old]]);old=new
            cnf.append([-literals[-1],-old])
    events=[(e,s) for e,(_,_,s,_) in enumerate(edges,1)]
    if compress_signatures:
        grouped=collections.defaultdict(list)
        for e,s in events:grouped[s].append(e)
        events=[]
        for signature in sorted(grouped):
            n+=1;presence=n
            for e in grouped[signature]:cnf.append([-e,presence])
            cnf.append([-presence]+grouped[signature])
            events.append((presence,signature))
    for t in range(16) if with_xor else []:
        literals=[e for e,s in events if s>>t&1]
        if not literals:cnf.append([]);continue
        old=literals[0]
        for e in literals[1:]:
            n+=1;new=n
            cnf.extend([[old,e,-new],[-old,-e,-new],[old,-e,new],[-old,e,new]])
            old=new
        cnf.append([old])
    return cnf,n,selectors,events


def limited_solve(s,assumptions,seconds):
    # MiniSat-style conflict limits are native; a Python timer can be delayed
    # by a solver holding the GIL and must not be treated as a wall guarantee.
    s.conf_budget(2000)
    return s.solve_limited(assumptions=assumptions)


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--seed',type=int,default=0)
    ap.add_argument('--seconds',type=float,default=120)
    ap.add_argument('--per-call-seconds',type=float,default=2)
    ap.add_argument('--solver',default='glucose42')
    ap.add_argument('--certify',action='store_true')
    ap.add_argument('--from-cover',type=Path)
    ap.add_argument('--compress-signatures',action='store_true')
    a=ap.parse_args()
    from pysat.solvers import Solver
    start=time.monotonic()
    rows,C,edges=logical_data()
    singleton=json.loads((ROOT/'matrix-witness-results/single-class-signature-screen.json').read_text())
    mayremove={tuple(r['case']) for r in singleton['records'] if r['satisfiable_partial_signature_matching'] is False}
    if a.certify:
        source=json.loads(a.from_cover.read_text())
        removed={tuple(c) for c in source['removed_case_tuples']}
        edges=[e for e in edges if C[e[3]] in removed]
        cnf,n,selectors,events=encode(rows,C,edges,compress_signatures=a.compress_signatures)
        units=[[v if C[k] in removed else -v] for k,v in enumerate(selectors)]
        allclauses=cnf+units
        cnfpath=a.output.with_suffix('.cnf.gz');proofpath=a.output.with_suffix('.drat.gz')
        raw=(f'p cnf {n} {len(allclauses)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in allclauses)).encode()
        cnfpath.write_bytes(gzip.compress(raw,mtime=0))
        print(f'Certifying compact model: {len(edges)} edges, {n} variables, {len(allclauses)} clauses',flush=True)
        with tempfile.TemporaryDirectory(prefix='c16-signature-proof-') as folder:
            ip=Path(folder)/'input.cnf';op=Path(folder)/'proof.drat';ip.write_bytes(raw)
            worker="from pysat.solvers import Solver; from pysat.formula import CNF; import sys; s=Solver(name='cadical195',bootstrap_with=CNF(from_file=sys.argv[1]).clauses,with_proof=True); a=s.solve(); print(a,flush=True); assert a is False; p=s.get_proof(); open(sys.argv[2],'w').write('\\n'.join(p)+'\\n'); s.delete()"
            run=subprocess.run([sys.executable,'-c',worker,str(ip),str(op)],capture_output=True,text=True,timeout=a.seconds,check=True)
            proofraw=op.read_bytes()
        proofpath.write_bytes(gzip.compress(proofraw,mtime=0))
        result={'status':'UNSAT_PROOF_CANDIDATE','source_C16_answered':False,'signature_compression':a.compress_signatures,'retained_case_count':len(C)-len(removed),'removed_case_tuples':sorted(removed),'retained_case_tuples':[c for c in C if c not in removed],'signature_edges_in_removed_classes':len(edges),'parity_events':len(events),'variables':n,'clauses':len(allclauses),'cnf_sha256':hashlib.sha256(raw).hexdigest(),'proof_sha256':hashlib.sha256(proofraw).hexdigest(),'proof_lines':len(proofraw.splitlines()),'cnf_file':cnfpath.name,'proof_file':proofpath.name,'elapsed_seconds':time.monotonic()-start}
    else:
        native=a.solver=='cms'
        cnf,n,selectors,events=encode(rows,C,edges,with_xor=not native,compress_signatures=a.compress_signatures)
        print(f'Encoded {len(edges)} nonzero-signature edges, {n} variables, {len(cnf)} clauses',flush=True)
        order=[k for k,c in enumerate(C) if c in mayremove]
        random.Random(a.seed).shuffle(order)
        removed=({k for k,c in enumerate(C) if c in {tuple(c) for c in json.loads(a.from_cover.read_text())['removed_case_tuples']}} if a.from_cover else set());history=[];unknown=0
        order=[k for k in order if k not in removed]
        if native:
            import pycryptosat
            s=pycryptosat.Solver(threads=1,options={'minmatrixrows':'0','maxmatrixrows':'1000','autodisablegauss':'0'})
            for clause in cnf:s.add_clause(clause)
            for t in range(16):s.add_xor_clause([e for e,sig in events if sig>>t&1],True)
        else:s=Solver(name=a.solver,bootstrap_with=cnf)
        try:
            for k in order:
                if time.monotonic()-start>a.seconds:break
                trial=removed|{k}
                assumptions=[v if j in trial else -v for j,v in enumerate(selectors)]
                answer=(s.solve(assumptions=assumptions,time_limit=a.per_call_seconds)[0] if native else limited_solve(s,assumptions,a.per_call_seconds))
                if answer is False:removed=trial
                elif answer is None:unknown+=1
                history.append({'case':C[k],'answer':answer,'removed_count':len(removed),'seconds':time.monotonic()-start})
                if len(history)%20==0:print(f'{len(history)} trials: retained {518-len(removed)}, unknown {unknown}, {time.monotonic()-start:.1f}s',flush=True)
        finally:
            if not native:s.delete()
        result={'status':'DISCOVERY_ONLY','source_C16_answered':False,'signature_compression':a.compress_signatures,'seed':a.seed,'solver':a.solver,'retained_case_count':len(C)-len(removed),'removed_case_tuples':[C[k] for k in sorted(removed)],'retained_case_tuples':[c for k,c in enumerate(C) if k not in removed],'trials':history,'unknown_calls':unknown,'original_cases':len(C),'scope':'UNSAT discovery calls only. A final checked proof is required before asserting the smaller cover. SAT witnesses are partial signature matchings and need not extend to full source frames.','elapsed_seconds':time.monotonic()-start}
    a.output.write_text(json.dumps(result,indent=2)+'\n')
    print(f'{result["status"]}: retained {result["retained_case_count"]}, elapsed {time.monotonic()-start:.1f}s',flush=True)


if __name__=='__main__':main()
