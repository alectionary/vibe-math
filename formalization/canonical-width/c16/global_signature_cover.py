#!/usr/bin/env python3
"""Global hitting-set proposals and exact16-signature compatibility oracle.

No local exchange restriction. Unknown candidates are discovery no-goods only;
neither optimality nor an unchecked UNSAT candidate is a coverage claim.
"""
from pathlib import Path
import argparse
import json
import time
from signature_cover import logical_data, encode
from exchange_signature_cover import representation

ROOT = Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--seconds',type=float,default=180)
    ap.add_argument('--oracle-seconds',type=float,default=.3)
    ap.add_argument('--master-seconds',type=float,default=.2)
    ap.add_argument('--seed',type=int,default=0)
    ap.add_argument('--target-removed',type=int)
    ap.add_argument('--shrink',action='store_true')
    a=ap.parse_args()
    from ortools.sat.python import cp_model
    import pycryptosat
    start=time.monotonic()
    A,C,E=logical_data();cnf,n,S,events=encode(A,C,E,with_xor=False,compress_signatures=True)
    native=pycryptosat.Solver(threads=1,options={'minmatrixrows':'0','maxmatrixrows':'1000','autodisablegauss':'0'})
    for c in cnf:native.add_clause(c)
    for t in range(16):native.add_xor_clause([v for v,s in events if s>>t&1],True)
    edgeindex={(e[0],e[1]):k for k,e in enumerate(E)}
    position={c:k for k,c in enumerate(C)}
    prior=json.loads((ROOT/'matrix-witness-results/signature-cover-505.json').read_text())
    best={position[tuple(c)] for c in prior['removed_case_tuples']}
    single=json.loads((ROOT/'matrix-witness-results/single-class-signature-screen.json').read_text())
    cuts={frozenset([position[tuple(r['case'])]]) for r in single['records'] if r['satisfiable_partial_signature_matching']}
    seed_witnesses=[]
    for name in ['signature-exchange.json','signature-exchange-compact.json']:
        old=json.loads((ROOT/'matrix-witness-results'/name).read_text())
        for r in old['trials']:
            if 'counterexample_edges' not in r:continue
            selected=[edgeindex[tuple(e)] for e in r['counterexample_edges']]
            assert representation(selected,E) is not None
            cuts.add(frozenset(E[k][3] for k in selected))
            seed_witnesses.append(r['counterexample_edges'])
    seed_count=len(cuts)
    master=cp_model.CpModel();x=[master.new_bool_var(f'remove_{k}') for k in range(len(C))]
    for cut in sorted(cuts,key=lambda c:(len(c),sorted(c))):master.add(sum(x[k] for k in cut)<=len(cut)-1)
    master.add(sum(x)>=len(best)+1)
    if a.target_removed:
        master.add(sum(x)==a.target_removed)
        # Globally allowed exchanges, with overlap only a preference.
        master.maximize(sum(x[k] for k in best))
    else:
        master.maximize(sum(x))
    history=[];improvements=[];unknown=[];master_history=[]
    while time.monotonic()-start<a.seconds:
        solver=cp_model.CpSolver();solver.parameters.num_search_workers=1;solver.parameters.max_time_in_seconds=a.master_seconds;solver.parameters.random_seed=a.seed
        status=solver.solve(master)
        master_history.append({'status':int(status),'objective':solver.objective_value,'bound':solver.best_objective_bound,'seconds':time.monotonic()-start})
        if status==cp_model.INFEASIBLE:
            stop='no_unblocked_improving_proposal';break
        if status not in [cp_model.OPTIMAL,cp_model.FEASIBLE]:continue
        trial={k for k in range(len(C)) if solver.value(x[k])}
        sat,model=native.solve(assumptions=[-v for k,v in enumerate(S) if k not in trial],time_limit=a.oracle_seconds)
        r={'removed_count':len(trial),'answer':sat,'elapsed_seconds':time.monotonic()-start}
        if sat is False:
            best=trial
            master.add(sum(x)>=len(best)+1)
            improvements.append({'retained_count':len(C)-len(best),'removed_case_tuples':[C[k] for k in sorted(best)],'seconds':time.monotonic()-start})
            print('candidate improvement',len(C)-len(best),flush=True)
        elif sat is None:
            unknown.append([C[k] for k in sorted(trial)])
            master.add_bool_or([x[k].Not() for k in trial]+[x[k] for k in range(len(C)) if k not in trial])
        else:
            shrink_trials=[]
            if a.shrink:
                # Class-level deletion asks the oracle to replace its witness;
                # minimizing a fixed matching alone can miss much smaller cuts.
                for c in sorted(trial):
                    smaller=trial-{c}
                    answer,mm=native.solve(assumptions=[-v for k,v in enumerate(S) if k not in smaller],time_limit=.05)
                    shrink_trials.append([c,answer])
                    if answer:
                        trial=smaller;model=mm
                r['class_shrink_trials']=shrink_trials
            chosen={}
            for k in range(len(E)):
                if model[k+1]:chosen.setdefault(E[k][2],k)
            selected=representation(list(chosen.values()),E);assert selected is not None
            for c in sorted({E[k][3] for k in selected}):
                smaller=representation([k for k in selected if E[k][3]!=c],E)
                if smaller is not None:selected=smaller
            support=frozenset(E[k][3] for k in selected);value=0
            for i,k in enumerate(selected):
                u,v,s,c=E[k];assert c in trial;value^=s
                for l in selected[:i]:
                    uu,vv,_,_=E[l];assert u!=uu and v!=vv and not A[u]>>vv&1 and not A[uu]>>v&1
            assert value==65535
            assert support not in cuts
            cuts.add(support);master.add(sum(x[k] for k in support)<=len(support)-1)
            r['counterexample_edges']=[list(E[k][:2]) for k in selected]
            r['counterexample_classes']=[C[k] for k in sorted(support)]
        history.append(r)
        if len(history)%100==0:print(len(history),'proposals',len(cuts),'cuts best',518-len(best),'master removed',len(trial),'seconds',time.monotonic()-start,flush=True)
    else:stop='wall_bound'
    result={'status':'DISCOVERY_ONLY','source_C16_answered':False,'retained_case_count':len(C)-len(best),'removed_case_tuples':[C[k] for k in sorted(best)],'retained_case_tuples':[c for k,c in enumerate(C) if k not in best],'initial_cut_count':seed_count,'seed_witnesses':seed_witnesses,'cut_count':len(cuts),'trials':history,'master_history':master_history,'unknown_candidates':unknown,'improvements':improvements,'stop':stop,'target_removed':a.target_removed,'class_shrink':a.shrink,'elapsed_seconds':time.monotonic()-start,'scope':'Global cover proposals, no distance restriction. Unknown choices are discovery no-goods, so master bounds do not certify a global optimum. Final improvement needs independent CNF/DRAT proof.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n')
    print('saved',len(history),'trials, best',result['retained_case_count'],flush=True)


if __name__=='__main__':main()
