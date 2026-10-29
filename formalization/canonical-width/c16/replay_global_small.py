#!/usr/bin/env python3
"""Independent source and final-trial binding replay of the four mined clauses."""
from pathlib import Path
import argparse,hashlib,json,time
from verify_algebraic_model import physical
from verify_sparse_quotient import SparseQuotientConsumer
from verify_sparse_gate import independent_obstruction
from verify_mandatory_closure import ClosureConsumer
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();out=ROOT/'transfer-results'
    cp=out/'global-small-cohort.json';sp=out/'global-small-seeds.json';gp=out/'global-trial.json';c=json.loads(cp.read_text());s=json.loads(sp.read_text());g=json.loads(gp.read_text())
    assert g['answer'] is None or g['answer'] in (False,True);assert s['cohort_sha256']==sha(cp) and g['initial_input_sha256']==c['source_initial_input_sha256']
    for p,h in s['source_hashes'].items():assert sha(ROOT/p)==h
    X,Z,A=physical();consumer=SparseQuotientConsumer(X,Z);closure=ClosureConsumer(X,Z,A);old=json.loads((ROOT/'relevant-results/seed-cuts.json').read_text())['cuts'];patterns=set()
    for cut in old:
        for h in range(16):patterns.add(frozenset(16*(i//16)+(i%16+h)%16 for i in cut['indices']))
    for record in c['records']:
        assert record['cut']==g['cuts'][record['cut_index']]
        source=g['records'][record['iteration']];assert source['iteration']==record['iteration'] and source['pairs']==record['pairs'] and record['cut_index'] in source['cut_indices']
        assert source['rank_checks'][0]['necessary_closure_fixed_point']
        consumer.check(record['cut']['certificate'])
    total=0
    for r,cut in zip(s['records'],s['cuts']):
        assert cut['indices']==r['final_ids'] and cut['sector']==r['sector'];consumer.check(cut['certificate']);J=cut['indices'];side=cut['sector']
        assert set(J)<=set(r['starting_ids']) and len(J)<len(r['starting_ids'])
        source=c['records'][r['source_cohort_index']];assert set(r['starting_ids'])=={p[side] for p in source['pairs']}
        for j in J:assert not independent_obstruction(X,Z,1-side,[i for i in J if i!=j])[3];total+=1
        req=[[],[]];req[side]=J;assert closure.replay(*req)['possible']
        assert not any(p<=set(J) for p in patterns)
    assert len(s['cuts'])==4 and total==28
    result={'status':'PASS','source_C16_answered':False,'source_trial_sha256':sha(gp),'seed_file_sha256':sha(sp),'cohort_sha256':sha(cp),
            'starting_matching_count':1,'starting_sector_sets':2,'final_source_clauses':4,'final_sizes':[len(c['indices']) for c in s['cuts']],
            'single_deletion_non_rejections':total,'old_6576_pattern_bank_subsumes_any':False,'elapsed_seconds':time.monotonic()-start,
            'scope':'Final trial binds all eight original sparse certificates to one physical11-pair matching. Four reduced source clauses independently checked; all28 single deletions fail complete order3. All four pass existing unrestricted propagation. This is criterion irreducibility, not globally minimum size or logical independence.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
