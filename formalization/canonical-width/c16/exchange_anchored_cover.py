#!/usr/bin/env python3
"""Global cover exchanges with symmetry-normalized counterexample oracles.

For an UNSAT parent R and trial R', a target matching in R' uses some class
from R' minus R. Each such new class is normalized to one fixed source pair.
All anchored branches UNSAT prove R' UNSAT; one SAT branch supplies a valid
global class-hitting cut. No radius restriction is imposed on proposals.
"""
from pathlib import Path
import argparse
import gzip
import hashlib
import json
import subprocess
import sys
import tempfile
import time
from signature_cover import logical_data,encode,canonical
from anchored_cover_chain import parity_chains
from exchange_signature_cover import representation

ROOT=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--base-chain',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=900);ap.add_argument('--oracle-seconds',type=float,default=3);ap.add_argument('--master-seconds',type=float,default=.3);ap.add_argument('--seed',type=int,default=0);ap.add_argument('--drat-trim',type=Path,required=True);a=ap.parse_args();start=time.monotonic();a.output.parent.mkdir(parents=True,exist_ok=True)
    from ortools.sat.python import cp_model
    A,C,E=logical_data();position={c:k for k,c in enumerate(C)};edgeindex={e[:2]:k for k,e in enumerate(E)};sig={e[:2]:e[2] for e in E}
    base=json.loads(a.base_chain.read_text());best={position[tuple(c)] for c in base['removed_case_tuples']};initial=sorted(best);cuts={};seed_witnesses=[]
    def addcut(pairs,save=False):
        support=frozenset(position[canonical(i,j)] for i,j in pairs)
        if support not in cuts:cuts[support]=pairs
        if save:seed_witnesses.append(pairs)
        return support
    single=json.loads((ROOT/'matrix-witness-results/single-class-signature-screen.json').read_text())
    for r in single['records']:
        if r['satisfiable_partial_signature_matching']:addcut(r['witness'])
    for path in (ROOT/'residual-identity-results').glob('global-cover*.json'):
        d=json.loads(path.read_text())
        for pairs in d['seed_witnesses']:addcut(pairs)
        for r in d['trials']:
            if r['answer'] is True:addcut(r['counterexample_edges'])
    for r in json.loads((ROOT/'theory-loop-results/minimality-witnesses.json').read_text())['records']:addcut(r['partial_matching'])
    seed_witnesses=[pairs for support,pairs in sorted(cuts.items(),key=lambda kv:(len(kv[0]),sorted(kv[0])))];seed_count=len(cuts)
    unknown=[];records=[];steps=[];master_history=[];stop='wall_bound'
    while time.monotonic()-start<a.seconds:
        master=cp_model.CpModel();x=[master.new_bool_var(f'removed_{k}') for k in range(518)]
        for cut in sorted(cuts,key=lambda s:(len(s),sorted(s))):master.add(sum(x[k] for k in cut)<=len(cut)-1)
        for trial in unknown:master.add_bool_or([x[k].Not() if k in trial else x[k] for k in range(518)])
        master.add(sum(x)==len(best)+1);master.maximize(sum(x[k] for k in best))
        solver=cp_model.CpSolver();solver.parameters.num_search_workers=1;solver.parameters.max_time_in_seconds=a.master_seconds;solver.parameters.random_seed=a.seed
        status=solver.solve(master);master_history.append({'status':int(status),'objective':solver.objective_value,'bound':solver.best_objective_bound,'seconds':time.monotonic()-start})
        if status==cp_model.INFEASIBLE:stop='no_unblocked_proposal';break
        if status not in [cp_model.OPTIMAL,cp_model.FEASIBLE]:continue
        trial={k for k in range(518) if solver.value(x[k])};new=sorted(trial-best);assert new
        r={'trial_removed':[C[k] for k in sorted(trial)],'parent_removed_count':len(best),'new_classes':[C[k] for k in new],'restored_classes':[C[k] for k in sorted(best-trial)],'branches':[],'answer':False}
        branchproofs=[]
        for c in new:
            if time.monotonic()-start>=a.seconds:r['answer']=None;break
            aa,bb,h=C[c];ax,az=16*aa,16*bb+h;target=65535^sig[ax,az]
            small=[(i,j,s,0) for i,j,s,k in E if k in trial and (i,j)!=(ax,az) and i!=ax and j!=az and not A[i]>>az&1 and not A[ax]>>j&1]
            clauses,n,_,events=encode(A,[0],small,with_xor=False);n=parity_chains(clauses,n,events,target)
            raw=(f'p cnf {n} {len(clauses)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in clauses)).encode();call_start=time.monotonic();br={'case':C[c],'anchor':[ax,az],'free_edges':len(small),'answer':None}
            with tempfile.TemporaryDirectory(prefix='c16-exchange-oracle-') as folder:
                ip=Path(folder)/'input.cnf';pp=Path(folder)/'proof.drat';mp=Path(folder)/'model.json';ip.write_bytes(raw)
                worker="from pysat.solvers import Solver; from pysat.formula import CNF; import sys,json; s=Solver(name='cadical195',bootstrap_with=CNF(from_file=sys.argv[1]).clauses,with_proof=True); a=s.solve(); print(a,flush=True); open(sys.argv[3],'w').write(json.dumps(s.get_model()) if a else 'null'); p=s.get_proof() if not a else []; open(sys.argv[2],'w').write('\\n'.join(p)+'\\n'); s.delete()"
                try:
                    run=subprocess.run([sys.executable,'-c',worker,str(ip),str(pp),str(mp)],capture_output=True,text=True,timeout=min(a.oracle_seconds,max(.01,a.seconds-(time.monotonic()-start))),check=True)
                    answer=run.stdout.strip()=='True';br['answer']=answer
                    if answer:
                        model=set(json.loads(mp.read_text()));pairs=[(ax,az)]+[e[:2] for k,e in enumerate(small,1) if k in model];selected=representation([edgeindex[p] for p in pairs],E);assert selected is not None
                        pairs=[E[k][:2] for k in selected];value=0
                        for q,(i,j) in enumerate(pairs):
                            value^=sig[i,j]
                            for ii,jj in pairs[:q]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
                        assert value==65535
                        support=frozenset(E[k][3] for k in selected);assert support<=trial and support not in cuts and not support<=best
                        addcut(pairs);r['counterexample_edges']=pairs;r['counterexample_classes']=[C[k] for k in sorted(support)];r['answer']=True
                    else:
                        check=subprocess.run([str(a.drat_trim),str(ip),str(pp)],capture_output=True,text=True,timeout=30);assert check.returncode==0 and 's VERIFIED' in check.stdout
                        proof=pp.read_bytes();branchproofs.append(({'case':C[c],'anchor':[ax,az],'trial_removed':[C[k] for k in sorted(trial)],'anchor_signature':sig[ax,az],'free_target_signature':target,'free_edge_count':len(small),'variables':n,'clauses':len(clauses),'cnf_sha256':hashlib.sha256(raw).hexdigest(),'proof_sha256':hashlib.sha256(proof).hexdigest(),'proof_lines':len(proof.splitlines())},raw,proof))
                except subprocess.TimeoutExpired:r['answer']=None
            br['call_seconds']=time.monotonic()-call_start;r['branches'].append(br)
            if br['answer'] is not False:break
        if r['answer'] is False:
            assert len(branchproofs)==len(new)
            files=[]
            for q,(cert,raw,proof) in enumerate(branchproofs):
                stem=a.output.parent/f'exchange-{len(steps):03d}-branch-{q:03d}';cp=stem.with_suffix('.cnf.gz');dp=stem.with_suffix('.drat.gz');cp.write_bytes(gzip.compress(raw,compresslevel=3,mtime=0));dp.write_bytes(gzip.compress(proof,compresslevel=3,mtime=0));cert.update({'cnf_file':cp.name,'proof_file':dp.name});stem.with_suffix('.json').write_text(json.dumps(cert,indent=2)+'\n');files.append(stem.with_suffix('.json').name)
            step={'parent_removed':[C[k] for k in sorted(best)],'trial_removed':[C[k] for k in sorted(trial)],'new_classes':[C[k] for k in new],'restored_classes':[C[k] for k in sorted(best-trial)],'branch_certificates':files,'retained_case_count':518-len(trial)};steps.append(step);best=trial;print('EXCHANGE candidate cover',518-len(best),'new',len(new),'restored',len(step['restored_classes']),flush=True)
        elif r['answer'] is None:unknown.append(trial)
        records.append(r)
        result={'status':'EXCHANGE_CHAIN_CANDIDATE','source_C16_answered':False,'base_chain_c16_path':str(a.base_chain.resolve().relative_to(ROOT)),'initial_removed':[C[k] for k in initial],'retained_case_count':518-len(best),'removed_case_tuples':[C[k] for k in sorted(best)],'retained_case_tuples':[c for k,c in enumerate(C) if k not in best],'steps':steps,'seed_witnesses':seed_witnesses,'initial_cut_count':seed_count,'cut_count':len(cuts),'records':records,'master_history':master_history,'unknown_candidates':[[C[k] for k in sorted(trial)] for trial in unknown],'stop':stop,'elapsed_seconds':time.monotonic()-start,'scope':'Global proposals with a preference for fewer restorations, no hard exchange radius. Exact coverage requires independent physical replay of base and every successful branch. Unknown no-goods preclude an optimum claim.'}
        a.output.write_text(json.dumps(result,indent=2)+'\n')
        if len(records)%50==0:print(len(records),'proposals best',518-len(best),'cuts',len(cuts),'unknown',len(unknown),'seconds',time.monotonic()-start,flush=True)


if __name__=='__main__':main()
