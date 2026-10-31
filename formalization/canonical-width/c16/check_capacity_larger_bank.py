#!/usr/bin/env python3
"""Check whether any previously mined child can strengthen the eight small supports."""
from pathlib import Path
from itertools import combinations
import hashlib,json,time
from replay_capacity_four import supports_through_four
from verify_algebraic_model import physical
from detecting_capacity_four import probe
from verify_detecting_capacity_four import CapacityFourConsumer
from verify_sparse_gate import independent_obstruction
from verify_mandatory_closure import ClosureConsumer
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    start=time.monotonic();out=ROOT/'transfer-results';bp=ROOT/'relevant-results/seed-cuts.json';bank=json.loads(bp.read_text())['cuts'];prior=json.loads((out/'capacity-four/gate.json').read_text())
    selected=[r for r in prior['records'] if r['diagnostics']];assert len(selected)==8
    frozen={'status':'FROZEN_BEFORE_LARGER_CHILD_BANK_CHECK','source_C16_answered':False,'bank_c16_path':str(bp.relative_to(ROOT)),
            'bank_sha256':sha(bp),'previous_gate_sha256':sha(out/'capacity-four/gate.json'),'candidate_indices':[r['candidate_index'] for r in selected],
            'source_sha256':sha(Path(__file__)),'scope':'Exactly the8 residual queries with a detecting support<=4, now compared against every previously retained source child of size<=4. The other376 queries have no such support by independent complete replay. This does not modify either running solver trial.'}
    fp=out/'capacity-larger-bank-frozen.json';fp.write_text(json.dumps(frozen,indent=2)+'\n')
    forbidden={};eligible=0
    for k,c in enumerate(bank):
        if len(c['indices'])>4:continue
        eligible+=1
        for h in range(16):forbidden.setdefault(tuple(sorted(16*(i//16)+(i%16+h)%16 for i in c['indices'])),{'bank_index':k,'cyclic_shift':h})
    X,Z,A=physical();consumer=CapacityFourConsumer(X,Z,bank);closure=ClosureConsumer(X,Z,A);records=[];cuts=[]
    for record in selected:
        J=record['ids'];supports=supports_through_four(X,Z,J);hits=[]
        for D in supports:
            for n in range(2,len(D)+1):
                for K in combinations(D,n):
                    if K in forbidden:hits.append({'support':D,'child':K,'provenance':forbidden[K]})
        discovered=probe(X,Z,J,forbidden,cap=16)
        for result in discovered:
            row={'kind':'detecting_capacity_obstruction','side':0,**result,'clause':[-j-721 for j in J]};consumer.check(row)
            old=independent_obstruction(X,Z,0,J);assert not old[3];prop=closure.replay([],J)
            cuts.append({'kind':'universal_detecting_capacity','sector':1,'indices':J,'certificate':row,'passes_complete3':True,'passes_unrestricted_propagation':prop['possible']})
        records.append({'candidate_index':record['candidate_index'],'ids':J,'supports':[list(D) for D in supports],'child_hits':hits,'capacity_certificates':len(discovered)})
    result={'status':'COMPLETE','source_C16_answered':False,'frozen_sha256':sha(fp),'old_source_patterns_considered':eligible,
            'queries_checked':len(selected),'records':records,'cuts':cuts,'elapsed_seconds':time.monotonic()-start,
            'scope':'Previously known source children only; fixed eight-query extension. Any accepted source certificate is checked independently. No new solver outcome or full-frame conclusion.'}
    (out/'capacity-larger-bank.json').write_text(json.dumps(result,indent=2)+'\n');print('LARGER CHILD BANK',eligible,'hits',sum(len(r['child_hits']) for r in records),'certificates',len(cuts),result['elapsed_seconds'],flush=True)
if __name__=='__main__':main()
