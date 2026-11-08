#!/usr/bin/env python3
"""Bounded composition gate on one-deletion neighbors of the frozen source bank."""
from pathlib import Path
import argparse,collections,datetime,hashlib,json,time
from detecting_capacity import probe
from verify_detecting_capacity import CapacityConsumer
from verify_algebraic_model import physical
from verify_sparse_gate import independent_obstruction
from verify_mandatory_closure import ClosureConsumer
from sparse_quotient_oracle import SparseQuotientOracle
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def orbit(ids):
    ids=list(ids)
    return min(tuple(sorted(16*(i//16)+(i%16+h)%16 for i in ids)) for h in range(16))
def main():
    p=argparse.ArgumentParser();p.add_argument('--seconds',type=float,default=900);p.add_argument('--library',type=Path,required=True)
    p.add_argument('--output-directory',type=Path,required=True);a=p.parse_args();start=time.monotonic();a.output_directory.mkdir(exist_ok=False)
    bankpath=ROOT/'relevant-results/comparison-seed-cuts.json';bank=json.loads(bankpath.read_text())['cuts'];assert len(bank)==256
    forbidden={};candidates=collections.defaultdict(list)
    for k,cut in enumerate(bank):
        for h in range(16):
            key=tuple(sorted(16*(i//16)+(i%16+h)%16 for i in cut['indices']))
            forbidden.setdefault(key,{'bank_index':k,'cyclic_shift':h})
        for i in cut['indices']:candidates[orbit(j for j in cut['indices'] if j!=i)].append({'bank_index':k,'removed_index':i})
    cohort=[{'ids':list(ids),'origins':origins} for ids,origins in sorted(candidates.items(),key=lambda kv:(len(kv[0]),kv[0]))]
    frozen={'status':'FROZEN_BEFORE_CAPACITY_DISCOVERY','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
            'bank_c16_path':str(bankpath.relative_to(ROOT)),'bank_sha256':sha(bankpath),'candidate_rule':'All single-vector deletions of the256 fixed source cores, deduplicated by cyclic and sector symmetry. No new solver record is used. No recursive enlargement of the child bank.',
            'cohort':cohort,'raw_deletions':sum(len(c['indices']) for c in bank),'canonical_candidates':len(cohort),
            'seconds':a.seconds,'library_sha256':sha(a.library),
            'source_hashes':{name:sha(ROOT/name) for name in ['detecting_capacity.py','verify_detecting_capacity.py','run_capacity_gate.py','verify_sparse_gate.py','verify_sparse_quotient.py']},
            'acceptance':'A composed source certificate that passes the complete old order3 predicate and unrestricted mandatory propagation; independently replay the source child, capacity, exact physical support and short-sum demand.'}
    fp=a.output_directory/'frozen.json';fp.write_text(json.dumps(frozen,indent=2)+'\n')
    X,Z,A=physical();consumer=CapacityConsumer(X,Z,bank);old=SparseQuotientOracle(X,Z,a.library);closure=ClosureConsumer(X,Z,A)
    records=[];cuts=[];stats=collections.Counter();expired=False
    for k,item in enumerate(cohort):
        if time.monotonic()-start>=a.seconds:expired=True;break
        J=item['ids'];old_rows=old.probe(0,J,3,cap=1);stats['old_rejects']+=bool(old_rows)
        assert not old_rows,('previous single-deletion non-rejection did not transfer',J)
        rows=probe(X,Z,J,forbidden,cap=1);record={'candidate_index':k,'ids':J,'old_complete3_native_reject':False,'capacity_reject':bool(rows)}
        for result in rows:
            row={'kind':'detecting_capacity_obstruction','side':0,**result,'clause':[-j-721 for j in J]}
            consumer.check(row);previous=independent_obstruction(X,Z,0,J);assert not previous[3]
            propagation=closure.replay([],J);record['old_complete_predicate']=previous;record['propagation']=propagation
            strict=propagation['possible'];stats['strict_beyond_propagation']+=strict
            cuts.append({'kind':'universal_detecting_capacity','sector':1,'indices':J,'certificate':row,'passes_complete3':True,'passes_unrestricted_propagation':strict})
            stats['composed_certificates']+=1
        records.append(record)
        if k%25==0:print('CAPACITY GATE',k,'of',len(cohort),dict(stats),'seconds',round(time.monotonic()-start,2),flush=True)
    old.close();result={'status':'TIME_LIMIT' if expired else 'COMPLETE','source_C16_answered':False,'frozen_sha256':sha(fp),
            'candidates_processed':len(records),'candidate_count':len(cohort),'records':records,'cuts':cuts,'statistics':dict(stats),
            'elapsed_seconds':time.monotonic()-start,'scope':'One fixed round of composing the unchanged256 source obstructions. No full-anchor or cover conclusion; no recursive closure claim. Non-rejection is not extendibility.'}
    (a.output_directory/'gate.json').write_text(json.dumps(result,indent=2)+'\n');print('CAPACITY END',result['status'],dict(stats),result['elapsed_seconds'],flush=True)
if __name__=='__main__':main()
