#!/usr/bin/env python3
"""Fixed383-query test of two simultaneous forbidden-pair capacity losses."""
from pathlib import Path
import collections,datetime,hashlib,json,time
from conditioned_double_pair import probe
from verify_double_pair import DoublePairConsumer
from verify_algebraic_model import physical
from verify_sparse_gate import independent_obstruction
from verify_mandatory_closure import ClosureConsumer
from rank_oracle import basis,zero_exclusion
from verify_mixed_rank_cover_cuts import check as rank_check
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    start=time.monotonic();out=ROOT/'moment-resumption-results/double-pair';out.mkdir(exist_ok=False);X,Z,A=physical()
    bp0=ROOT/'moment-resumption-results/detector-five/child-bank.json';bank=[c for c in json.loads(bp0.read_text())['cuts'] if len(c['indices'])==2]
    ids=[336,438];az=[sum(((x&z).bit_count()%2)<<i for i,x in enumerate(X)) for z in Z];bits=sum(1<<i for i in ids);B=basis(z for z,r in zip(Z,az) if not r&bits);assert len(B)<126
    rankcut={'sector':0,**zero_exclusion(X,Z,az,ids,bits,B)};assert rankcut['indices']==ids;rank_check(X,Z,ids,int(rankcut['annihilator'],16));bank.append(rankcut)
    bp=out/'child-bank.json';bp.write_text(json.dumps({'cuts':bank,'rank_pair_residual_rank':len(B),'rank_pair_independently_checked':True},indent=2)+'\n')
    parent=ROOT/'transfer-results/capacity/frozen.json';cohort=json.loads(parent.read_text())['cohort'];assert len(cohort)==384
    controls=ROOT/'moment-resumption-results/double-pair-controls.json';c=json.loads(controls.read_text());assert c['status']=='PASS' and c['source_sha256']==sha(ROOT/'conditioned_double_pair.py') and c['counts']['certificates_support_6']>0
    forbidden={}
    for k,cut in enumerate(bank):
        for h in range(16):forbidden.setdefault(tuple(sorted(16*(i//16)+(i%16+h)%16 for i in cut['indices'])),{'bank_index':k,'cyclic_shift':h})
    frozen={'status':'FROZEN_BEFORE_SOURCE_GATE','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'seconds':600,'source_C16_answered':False,
            'bank_c16_path':str(bp.relative_to(ROOT)),'bank_sha256':sha(bp),'bank_records':len(bank),'translated_pair_children':len(forbidden),
            'cohort_c16_path':str(parent.relative_to(ROOT)),'cohort_sha256':sha(parent),'cohort_size':383,'excluded_already_proved':[416,512],'control_sha256':sha(controls),
            'sources':{p:sha(ROOT/p) for p in ['conditioned_double_pair.py','verify_double_pair.py','run_double_pair_gate.py']},
            'scope':'All supports<=6 containing two disjoint translated forbidden pairs from the fixed four-word-pair plus one-rank-pair bank. Their selection capacity is at most|D|-2; no words through that bound gives a source obstruction.'}
    fp=out/'frozen.json';fp.write_text(json.dumps(frozen,indent=2)+'\n');consumer=DoublePairConsumer(X,Z,bank);closure=ClosureConsumer(X,Z,A);stats=collections.Counter();records=[];cuts=[];expired=False
    for k,item in enumerate(cohort):
        J=item['ids']
        if J==[416,512]:continue
        if time.monotonic()-start>=600:expired=True;break
        diagnostic=collections.Counter();rows=probe(X,Z,J,forbidden,cap=1,stats=diagnostic);stats.update(diagnostic);record={'candidate_index':k,'ids':J,'capacity_reject':bool(rows),'diagnostics':dict(diagnostic)}
        for result in rows:
            row={'kind':'double_pair_capacity_obstruction','side':0,**result,'clause':[-j-721 for j in J]};consumer.check(row);old=independent_obstruction(X,Z,0,J);assert not old[3];prop=closure.replay([],J);record['propagation']=prop
            cuts.append({'kind':'universal_double_pair_capacity','sector':1,'indices':J,'certificate':row,'passes_complete3':True,'passes_unrestricted_propagation':prop['possible']})
        records.append(record)
        if k%25==0:print('DOUBLE PAIR',k,'cuts',len(cuts),dict(stats),'seconds',round(time.monotonic()-start,2),flush=True)
    result={'status':'TIME_LIMIT' if expired else 'COMPLETE','source_C16_answered':False,'frozen_sha256':sha(fp),'candidate_count':383,'candidates_processed':len(records),'cuts':cuts,'records':records,'statistics':dict(stats),'independently_checked_children':sorted(consumer.checked),'elapsed_seconds':time.monotonic()-start,'scope':'Fixed finite necessary-condition test. Every positive checked physically; negative coverage requires independent replay. No full-anchor or cover decision.'}
    (out/'gate.json').write_text(json.dumps(result,indent=2)+'\n');print('DOUBLE PAIR END',len(records),len(cuts),dict(stats),result['elapsed_seconds'],flush=True)
if __name__=='__main__':main()
