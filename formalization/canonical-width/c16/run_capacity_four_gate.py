#!/usr/bin/env python3
"""One fixed support-four capacity extension on the prior384-candidate cohort."""
from pathlib import Path
import collections,datetime,hashlib,json,time
from detecting_capacity_four import probe
from verify_detecting_capacity_four import CapacityFourConsumer
from verify_algebraic_model import physical
from verify_sparse_gate import independent_obstruction
from verify_mandatory_closure import ClosureConsumer
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    start=time.monotonic();out=ROOT/'transfer-results/capacity-four';out.mkdir(exist_ok=False)
    parent=ROOT/'transfer-results/capacity/frozen.json';f=json.loads(parent.read_text());bankpath=ROOT/f['bank_c16_path'];assert sha(bankpath)==f['bank_sha256']
    bank=json.loads(bankpath.read_text())['cuts'];cohort=f['cohort'];assert len(bank)==256 and len(cohort)==384
    controls=ROOT/'transfer-results/capacity-four-controls.json';control=json.loads(controls.read_text());assert control['status']=='PASS' and control['source_sha256']==sha(ROOT/'detecting_capacity_four.py')
    frozen={'status':'FROZEN_BEFORE_SUPPORT4_GATE','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
            'source_C16_answered':False,'seconds':900,'parent_cohort_c16_path':str(parent.relative_to(ROOT)),'parent_cohort_sha256':sha(parent),
            'bank_c16_path':str(bankpath.relative_to(ROOT)),'bank_sha256':sha(bankpath),'control_sha256':sha(controls),
            'source_hashes':{p:sha(ROOT/p) for p in ['detecting_capacity_four.py','verify_detecting_capacity_four.py','run_capacity_four_gate.py']},
            'scope':'Same384 single-deletion neighbors and same256 child obstructions. Enumerate detecting supports through4; any child lowers their usable count by at least1. No solver comparison or child-bank growth.'}
    fp=out/'frozen.json';fp.write_text(json.dumps(frozen,indent=2)+'\n')
    forbidden={}
    for k,cut in enumerate(bank):
        for h in range(16):forbidden.setdefault(tuple(sorted(16*(i//16)+(i%16+h)%16 for i in cut['indices'])),{'bank_index':k,'cyclic_shift':h})
    X,Z,A=physical();consumer=CapacityFourConsumer(X,Z,bank);closure=ClosureConsumer(X,Z,A)
    stats=collections.Counter();records=[];cuts=[];expired=False
    for k,item in enumerate(cohort):
        if time.monotonic()-start>=900:expired=True;break
        J=item['ids'];diagnostic=collections.Counter();rows=probe(X,Z,J,forbidden,cap=1,order=4,stats=diagnostic);stats.update(diagnostic)
        record={'candidate_index':k,'ids':J,'capacity_reject':bool(rows),'diagnostics':dict(diagnostic)}
        for result in rows:
            row={'kind':'detecting_capacity_obstruction','side':0,**result,'clause':[-j-721 for j in J]};consumer.check(row)
            old=independent_obstruction(X,Z,0,J);assert not old[3];prop=closure.replay([],J)
            record['old_complete_predicate']=old;record['propagation']=prop
            cuts.append({'kind':'universal_detecting_capacity','sector':1,'indices':J,'certificate':row,
                         'passes_complete3':True,'passes_unrestricted_propagation':prop['possible']})
        records.append(record)
        if k%25==0:print('CAPACITY4',k,'certificates',len(cuts),'stats',dict(stats),'seconds',round(time.monotonic()-start,2),flush=True)
    d={'status':'TIME_LIMIT' if expired else 'COMPLETE','source_C16_answered':False,'frozen_sha256':sha(fp),
       'candidate_count':384,'candidates_processed':len(records),'records':records,'cuts':cuts,'statistics':dict(stats),
       'elapsed_seconds':time.monotonic()-start,'scope':'Fixed finite support-four composition screen. No full frame or cover decision. Every positive certificate independently checked; independent completeness replay is separate.'}
    (out/'gate.json').write_text(json.dumps(d,indent=2)+'\n');print('CAPACITY4 END',d['status'],len(cuts),dict(stats),d['elapsed_seconds'],flush=True)
if __name__=='__main__':main()
