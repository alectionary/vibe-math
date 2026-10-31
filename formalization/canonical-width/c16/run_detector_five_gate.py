#!/usr/bin/env python3
"""Frozen bounded child-conditioned detecting-support-five gate."""
from pathlib import Path
import argparse,collections,datetime,hashlib,json,time
from conditioned_detector_five import probe
from verify_detector_five import CapacityFiveConsumer
from verify_algebraic_model import physical
from verify_sparse_gate import independent_obstruction
from verify_mandatory_closure import ClosureConsumer
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--seconds',type=float,default=600);a=ap.parse_args();start=time.monotonic()
    out=ROOT/'moment-resumption-results/detector-five';out.mkdir(exist_ok=False)
    paths=[ROOT/'relevant-results/seed-cuts.json',ROOT/'moment-resumption-results/all-pair-word-cuts.json'];bank=[];origins=[]
    for p in paths:
        for i,c in enumerate(json.loads(p.read_text())['cuts']):
            if 2<=len(c['indices'])<=4:bank.append(c);origins.append({'c16_path':str(p.relative_to(ROOT)),'index':i})
    bp=out/'child-bank.json';bp.write_text(json.dumps({'cuts':bank,'origins':origins},indent=2)+'\n')
    parent=ROOT/'transfer-results/capacity/frozen.json';cohort=json.loads(parent.read_text())['cohort'];assert len(cohort)==384
    excluded=[r for r in cohort if r['ids']==[416,512]];assert len(excluded)==1
    controls=ROOT/'moment-resumption-results/detector-five-controls.json';c=json.loads(controls.read_text());assert c['status']=='PASS' and c['discovery_source_sha256']==sha(ROOT/'conditioned_detector_five.py') and c['counts']['certificates_support_5']>0
    forbidden={}
    for k,cut in enumerate(bank):
        for h in range(16):forbidden.setdefault(tuple(sorted(16*(i//16)+(i%16+h)%16 for i in cut['indices'])),{'bank_index':k,'cyclic_shift':h})
    frozen={'status':'FROZEN_BEFORE_SOURCE_GATE','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'seconds':a.seconds,
            'source_C16_answered':False,'bank_c16_path':str(bp.relative_to(ROOT)),'bank_sha256':sha(bp),'bank_records':len(bank),'translated_children':len(forbidden),
            'cohort_c16_path':str(parent.relative_to(ROOT)),'cohort_sha256':sha(parent),'cohort_size':383,'excluded_already_proved':[416,512],
            'control_sha256':sha(controls),'prior_complete4_replay_sha256':sha(ROOT/'transfer-results/capacity-four-independent.json'),
            'inputs':{str(p.relative_to(ROOT)):sha(p) for p in paths},
            'source_hashes':{p:sha(ROOT/p) for p in ['conditioned_detector_five.py','verify_detector_five.py','run_detector_five_gate.py']},
            'scope':'Every detecting support through5 containing a fixed-bank forbidden child of size2..4, on the specified383 independent mandatory sets. New parents are never added as children. Positive source certificates independently checked; negative results are producer coverage until separately replayed.'}
    fp=out/'frozen.json';fp.write_text(json.dumps(frozen,indent=2)+'\n')
    X,Z,A=physical();consumer=CapacityFiveConsumer(X,Z,bank);closure=ClosureConsumer(X,Z,A);stats=collections.Counter();records=[];cuts=[];expired=False
    def checkpoint(status):
        result={'status':status,'source_C16_answered':False,'frozen_sha256':sha(fp),'candidates_processed':len(records),'candidate_count':383,
                'cuts':cuts,'records':records,'statistics':dict(stats),'independently_checked_children':sorted(consumer.checked),'elapsed_seconds':time.monotonic()-start,
                'scope':'Conditional detector-capacity source obstructions only; no full frame, full-anchor exclusion, or cover reduction.'}
        temp=out/'gate.tmp';temp.write_text(json.dumps(result,indent=2)+'\n');temp.replace(out/'gate.json')
    for k,item in enumerate(cohort):
        J=item['ids']
        if J==[416,512]:continue
        if time.monotonic()-start>=a.seconds:expired=True;break
        t=time.monotonic();diagnostic=collections.Counter();rows=probe(X,Z,J,forbidden,cap=1,stats=diagnostic);stats.update(diagnostic)
        record={'candidate_index':k,'ids':J,'capacity_reject':bool(rows),'diagnostics':dict(diagnostic),'seconds':time.monotonic()-t}
        for result in rows:
            row={'kind':'detecting_capacity_obstruction','side':0,**result,'clause':[-j-721 for j in J]};consumer.check(row)
            old=independent_obstruction(X,Z,0,J);assert not old[3];prop=closure.replay([],J)
            record['old_complete_predicate']=old;record['propagation']=prop
            cuts.append({'kind':'universal_detecting_capacity','sector':1,'indices':J,'certificate':row,'passes_complete3':True,'passes_unrestricted_propagation':prop['possible']})
        records.append(record)
        if k%10==0 or rows:
            checkpoint('RUNNING');print('DETECTOR5',k,'certificates',len(cuts),'stats',dict(stats),'seconds',round(time.monotonic()-start,2),flush=True)
    checkpoint('TIME_LIMIT' if expired else 'COMPLETE');print('DETECTOR5 END',len(records),len(cuts),dict(stats),round(time.monotonic()-start,2),flush=True)
if __name__=='__main__':main()
