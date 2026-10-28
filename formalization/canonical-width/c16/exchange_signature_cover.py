#!/usr/bin/env python3
"""Counterexample-guided local exchange of nonlinear signature cover classes.

The master proposes up to3 changes to the current removed set. A native XOR
oracle supplies partial induced matchings; Gaussian reduction compresses each
counterexample to at most16 edges, yielding a valid hitting constraint. Only
UNSAT oracle calls improve the candidate cover. No optimality claim is made.
"""
from pathlib import Path
import argparse
import json
import time
from signature_cover import logical_data,encode

ROOT=Path(__file__).resolve().parent


def representation(selected,edges,target=65535):
    basis={}
    for k in selected:
        v=edges[k][2];comb=1<<k
        while v:
            p=v.bit_length()-1
            if p not in basis:basis[p]=(v,comb);break
            w,mask=basis[p];v^=w;comb^=mask
    v=target;comb=0
    while v:
        p=v.bit_length()-1
        if p not in basis:return None
        w,mask=basis[p];v^=w;comb^=mask
    return [k for k in selected if comb>>k&1]


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--prior',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=180);ap.add_argument('--seed',type=int,default=0);ap.add_argument('--compact-fallback',action='store_true');a=ap.parse_args()
    from ortools.sat.python import cp_model
    import pycryptosat
    start=time.monotonic();A,C,E=logical_data();cnf,n,S,events=encode(A,C,E,with_xor=False,compress_signatures=True)
    native=pycryptosat.Solver(threads=1,options={'minmatrixrows':'0','maxmatrixrows':'1000','autodisablegauss':'0'})
    for c in cnf:native.add_clause(c)
    for t in range(16):native.add_xor_clause([v for v,s in events if s>>t&1],True)
    prior=json.loads(a.prior.read_text());best={k for k,c in enumerate(C) if c in {tuple(c) for c in prior['removed_case_tuples']}}
    edgeindex={(e[0],e[1]):k for k,e in enumerate(E)}
    singleton=json.loads((ROOT/'matrix-witness-results/single-class-signature-screen.json').read_text())
    forced={k for k,c in enumerate(C) if c in {tuple(r['case']) for r in singleton['records'] if r['satisfiable_partial_signature_matching']}}
    cuts=[];unknown=[];history=[];improvements=[];stop='wall_bound'
    while time.monotonic()-start<a.seconds:
        master=cp_model.CpModel();x=[master.new_bool_var(f'remove_{k}') for k in range(518)]
        for k in forced:master.add(x[k]==0)
        for cut in cuts:master.add(sum(x[k] for k in cut)<=len(cut)-1)
        for blocked in unknown:master.add_bool_or([x[k].Not() if k in blocked else x[k] for k in range(518)])
        master.add(sum(x[k] for k in range(518))>=len(best)+1)
        master.add(sum(1-x[k] if k in best else x[k] for k in range(518))<=3)
        master.maximize(sum(x))
        solver=cp_model.CpSolver();solver.parameters.num_search_workers=1;solver.parameters.max_time_in_seconds=.15;solver.parameters.random_seed=a.seed
        status=solver.solve(master)
        if status==cp_model.INFEASIBLE:stop='no_unblocked_improving_exchange_in_tested_neighborhood';break
        if status not in [cp_model.OPTIMAL,cp_model.FEASIBLE]:continue
        trial={k for k in range(518) if solver.value(x[k])}
        sat,model=native.solve(assumptions=[-v for k,v in enumerate(S) if k not in trial],time_limit=.5)
        selected_override=None;fallback_used=False
        if sat is None and a.compact_fallback:
            small=[e for e in E if e[3] in trial]
            cc,nn,ss,ee=encode(A,C,small,with_xor=False,compress_signatures=True)
            fresh=pycryptosat.Solver(threads=1,options={'minmatrixrows':'0','autodisablegauss':'0'})
            for clause in cc:fresh.add_clause(clause)
            for t in range(16):fresh.add_xor_clause([v for v,s in ee if s>>t&1],True)
            answer,mm=fresh.solve(time_limit=.4)
            fallback_used=True
            if answer is not None:
                sat=answer
                if answer:
                    selected_override=[edgeindex[e[:2]] for k,e in enumerate(small,1) if mm[k]]
        record={'trial':len(history),'removed_count':len(trial),'answer':sat,'seconds':time.monotonic()-start}
        if fallback_used:record['compact_fallback']=True
        if sat is False:
            best=trial;improvements.append({'retained_count':518-len(best),'removed_case_tuples':[C[k] for k in sorted(best)],'seconds':time.monotonic()-start})
            print('IMPROVED cover to',518-len(best),'after',len(history),'trials',flush=True)
        elif sat is None:
            unknown.append(trial)
        else:
            chosen={}
            for k in (selected_override if selected_override is not None else [k for k in range(len(E)) if model[k+1]]):chosen.setdefault(E[k][2],k)
            selected=representation(list(chosen.values()),E)
            assert selected is not None
            # Drop whole classes while preserving a representation within this
            # already compatible partial matching. This only strengthens a cut.
            support={E[k][3] for k in selected}
            for c in sorted(support):
                smaller=representation([k for k in selected if E[k][3]!=c],E)
                if smaller is not None:selected=smaller
            support={E[k][3] for k in selected};value=0
            for i,k in enumerate(selected):
                u,v,s,c=E[k];assert c in trial;value^=s
                for l in selected[:i]:
                    uu,vv,_,_=E[l];assert u!=uu and v!=vv and not A[u]>>vv&1 and not A[uu]>>v&1
            assert value==65535 and len(selected)<=16
            cuts.append(support);record['counterexample_classes']=[C[k] for k in sorted(support)];record['counterexample_edges']=[list(E[k][:2]) for k in selected]
        history.append(record)
        if len(history)%50==0:print(len(history),'trials,',len(cuts),'valid cuts,',len(unknown),'unknowns; best',518-len(best),'seconds',time.monotonic()-start,flush=True)
    result={'status':'DISCOVERY_ONLY','source_C16_answered':False,'retained_case_count':518-len(best),'removed_case_tuples':[C[k] for k in sorted(best)],'retained_case_tuples':[c for k,c in enumerate(C) if k not in best],'prior':str(a.prior),'signature_compression':True,'compact_fallback_enabled':a.compact_fallback,'counterexample_cuts':len(cuts),'unknown_oracle_calls':len(unknown),'unknown_candidates':[[C[k] for k in sorted(c)] for c in unknown],'stop':stop,'trials':history,'improvements':improvements,'elapsed_seconds':time.monotonic()-start,'scope':'Counterexample-guided local exchange only, not global or neighborhood optimality. Unknown candidates are blocked as discovery choices; no final coverage claim until an independent UNSAT proof is checked.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print('Saved best candidate cover',result['retained_case_count'],flush=True)


if __name__=='__main__':main()
