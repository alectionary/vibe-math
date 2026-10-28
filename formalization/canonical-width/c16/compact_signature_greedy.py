#!/usr/bin/env python3
"""Greedy cover expansion of the removable set with a fresh compact oracle.

SAT partial matchings become valid class hitting cuts. All UNSAT discovery
improvements require a final independently checked uncompressed proof.
"""
from pathlib import Path
import argparse
import json
import random
import time
from signature_cover import logical_data,encode
from exchange_signature_cover import representation

ROOT=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--prior',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=240);ap.add_argument('--call-seconds',type=float,default=.5);ap.add_argument('--seed',type=int,default=0);ap.add_argument('--solver',choices=['cms','cadical195'],default='cms');a=ap.parse_args();start=time.monotonic()
    A,C,E=logical_data();pos={c:k for k,c in enumerate(C)}
    prior=json.loads(a.prior.read_text());best={pos[tuple(c)] for c in prior['removed_case_tuples']}
    forced={pos[tuple(r['case'])] for r in json.loads((ROOT/'matrix-witness-results/single-class-signature-screen.json').read_text())['records'] if r['satisfiable_partial_signature_matching']}
    order=[k for k in range(518) if k not in best|forced];random.Random(a.seed).shuffle(order)
    history=[];cuts=[]
    for k in order:
        if time.monotonic()-start>a.seconds:break
        trial=best|{k};small=[e for e in E if e[3] in trial]
        compressed=a.solver=='cms'
        clauses,n,S,events=encode(A,C,small,with_xor=not compressed,compress_signatures=compressed)
        call_start=time.monotonic()
        if compressed:
            import pycryptosat
            solver=pycryptosat.Solver(threads=1,options={'minmatrixrows':'0','maxmatrixrows':'1000','autodisablegauss':'0'})
            for c in clauses:solver.add_clause(c)
            for t in range(16):solver.add_xor_clause([v for v,s in events if s>>t&1],True)
            sat,model=solver.solve(time_limit=min(a.call_seconds,max(.01,a.seconds-(time.monotonic()-start))))
            chosen=[i for i in range(len(small)) if model[i+1]] if sat else []
        else:
            from pysat.solvers import Solver
            solver=Solver(name='cadical195',bootstrap_with=clauses)
            solver.conf_budget(20000)
            sat=solver.solve_limited()
            model=set(solver.get_model()) if sat else set()
            chosen=[i for i in range(len(small)) if i+1 in model]
            solver.delete()
        r={'case':C[k],'answer':sat,'removed_count_before':len(best),'call_seconds':time.monotonic()-call_start}
        if sat is False:
            best=trial;print('UNSAT candidate cover',518-len(best),'trial',len(history),flush=True)
        elif sat:
            # Presence compression is existence-equivalent: first retain just
            # one edge per present signature, then extract a linear subset.
            reps={}
            for i in chosen:reps.setdefault(small[i][2],i)
            selected=representation(list(reps.values()) if compressed else chosen,small);assert selected is not None
            value=0
            for q,i in enumerate(selected):
                x,z,s,c=small[i];value^=s
                for j in selected[:q]:
                    xx,zz,_,_=small[j];assert x!=xx and z!=zz and not A[x]>>zz&1 and not A[xx]>>z&1
            assert value==65535
            r['partial_matching']=[list(small[i][:2]) for i in selected]
            r['support_classes']=[C[c] for c in sorted({small[i][3] for i in selected})]
        history.append(r)
        result={'status':'DISCOVERY_ONLY','source_C16_answered':False,'solver':a.solver,'seed':a.seed,'prior':str(a.prior),'retained_case_count':518-len(best),'removed_case_tuples':[C[c] for c in sorted(best)],'retained_case_tuples':[c for c in C if pos[c] not in best],'trials':history,'elapsed_seconds':time.monotonic()-start,'scope':'Fresh compact partial-signature oracle. Discovery UNSAT is not a coverage claim until independent full proof replay. SAT partial witnesses do not imply full frames.'}
        a.output.write_text(json.dumps(result,indent=2)+'\n')
        if len(history)%25==0:print(len(history),'trials, best',518-len(best),'seconds',time.monotonic()-start,flush=True)


if __name__=='__main__':main()
