#!/usr/bin/env python3
"""Freeze and evaluate the order-four extension on the same384 source neighbors."""
from pathlib import Path
import collections,datetime,hashlib,json,time
from sparse_quotient_four import probe
from verify_four_term_small import check
from verify_sparse_gate import independent_obstruction
from verify_mandatory_closure import ClosureConsumer
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    start=time.monotonic();out=ROOT/'transfer-results/four-term';out.mkdir(exist_ok=False)
    cp=ROOT/'transfer-results/capacity/frozen.json';parent=json.loads(cp.read_text());cohort=parent['cohort'];assert len(cohort)==384
    frozen={'status':'FROZEN_BEFORE_COMPLETE_ORDER4_SCREEN','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
            'source_C16_answered':False,'cohort_c16_path':str(cp.relative_to(ROOT)),'cohort_sha256':sha(cp),'seconds':900,
            'source_hashes':{p:sha(ROOT/p) for p in ['sparse_quotient_four.py','verify_four_term_small.py','run_four_term_gate.py']},
            'prior_exploration':'A diagnostic on the eight supports<=4 identified J=[416,512] as a candidate with no four-term representation. This is an exploratory theoretical screen, not an untouched performance holdout.',
            'scope':'Same384 canonical single-deletion neighbors. Complete order4 existence predicate on full-rank residuals. The earlier independent replay established non-rejection by complete order3. No change to either running solver trial.'}
    fp=out/'frozen.json';fp.write_text(json.dumps(frozen,indent=2)+'\n');X,Z,A=physical();closure=ClosureConsumer(X,Z,A);records=[];cuts=[];counts=collections.Counter();expired=False
    for k,item in enumerate(cohort):
        if time.monotonic()-start>=900:expired=True;break
        J=item['ids'];stats=collections.Counter();found=probe(X,Z,J,cap=4,stats=stats);counts.update(stats)
        record={'candidate_index':k,'ids':J,'order4_reject':bool(found),'diagnostics':dict(stats)}
        for result in found:
            row={'kind':'sparse_quotient_obstruction','side':0,**result,'clause':[-j-721 for j in J]};receipt=check(X,Z,row)
            old=independent_obstruction(X,Z,0,J);assert not old[3];prop=closure.replay([],J)
            cuts.append({'kind':'universal_sparse_quotient_four','sector':1,'indices':J,'certificate':row})
            record['literal_check']=receipt;record['old_complete_predicate']=old;record['propagation']=prop
        records.append(record)
        if k%25==0:print('ORDER4',k,'new',len(cuts),'seconds',round(time.monotonic()-start,2),flush=True)
    d={'status':'TIME_LIMIT' if expired else 'COMPLETE','source_C16_answered':False,'frozen_sha256':sha(fp),
       'candidate_count':384,'candidates_processed':len(records),'records':records,'cuts':cuts,'statistics':dict(counts),
       'elapsed_seconds':time.monotonic()-start,'scope':'Exact source certificates checked by literal span/coset enumeration independent of discovery. Strictness over order3 checked by the existing independent complete predicate. No global or full-anchor decision.'}
    (out/'gate.json').write_text(json.dumps(d,indent=2)+'\n');print('ORDER4 END',d['status'],[(c['indices'],c['certificate']['order']) for c in cuts],d['elapsed_seconds'],flush=True)
if __name__=='__main__':main()
