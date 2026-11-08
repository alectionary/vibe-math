#!/usr/bin/env python3
"""A disjoint-support packing lower-bounds16-signature proof-method covers."""
from pathlib import Path
import argparse
import json
import time
from signature_cover import logical_data,canonical

ROOT=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=10);a=ap.parse_args();start=time.monotonic()
    from ortools.sat.python import cp_model
    A,C,E=logical_data();pos={c:k for k,c in enumerate(C)};by={}
    def add(pairs):
        support=frozenset(pos[canonical(i,j)] for i,j in pairs)
        if support not in by or len(pairs)<len(by[support]):by[support]=pairs
    single=json.loads((ROOT/'matrix-witness-results/single-class-signature-screen.json').read_text())
    for r in single['records']:
        if r['satisfiable_partial_signature_matching']:add(r['witness'])
    for path in (ROOT/'residual-identity-results').glob('global-cover*.json'):
        d=json.loads(path.read_text())
        for pairs in d['seed_witnesses']:add(pairs)
        for r in d['trials']:
            if r['answer'] is True:add(r['counterexample_edges'])
    for path in (ROOT/'residual-identity-results').glob('compact-greedy-*.json'):
        d=json.loads(path.read_text())
        for r in d.get('trials',[]):
            if r['answer'] is True:add(r['partial_matching'])
    supports=sorted(by,key=lambda s:(len(s),sorted(s)))
    master=cp_model.CpModel();x=[master.new_bool_var(f'witness_{i}') for i in range(len(supports))]
    for c in range(518):master.add(sum(x[k] for k,s in enumerate(supports) if c in s)<=1)
    master.maximize(sum(x));solver=cp_model.CpSolver();solver.parameters.num_search_workers=1;solver.parameters.max_time_in_seconds=a.seconds;status=solver.solve(master)
    assert status in [cp_model.OPTIMAL,cp_model.FEASIBLE]
    chosen=[k for k in range(len(supports)) if solver.value(x[k])];used=set();records=[]
    for k in chosen:
        assert not used&supports[k];used.update(supports[k]);pairs=by[supports[k]];value=0
        for q,(i,j) in enumerate(pairs):
            assert A[i]>>j&1
            for ii,jj in pairs[:q]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
            value^=sum((((A[i]>>(608+t))&1)*((A[608+t]>>j)&1))<<t for t in range(16))
        assert value==65535
        records.append({'classes':[C[c] for c in sorted(supports[k])],'partial_matching':pairs})
    result={'status':'CANDIDATE','source_C16_answered':False,'method_cover_lower_bound':len(chosen),'disjoint_class_supports':records,'candidate_witness_supports':len(supports),'packing_solver_status':int(status),'packing_solver_bound':solver.best_objective_bound,'elapsed_seconds':time.monotonic()-start,'scope':'Every retained-class cover certified solely by16-signature/induced-matching UNSAT must intersect each of these disjoint supports. This is NOT a lower bound for arbitrary covers or full-frame feasibility. No optimality of the packing or cover is asserted.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print('disjoint witness lower bound',len(chosen),'candidate supports',len(supports),flush=True)


if __name__=='__main__':main()
