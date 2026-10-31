#!/usr/bin/env python3
"""Shrink the first fixed global sparse obstruction, without changing its trial."""
from pathlib import Path
import hashlib,json,time
from sparse_quotient_oracle import SparseQuotientOracle
from verify_sparse_quotient import SparseQuotientConsumer
from verify_sparse_gate import independent_obstruction
from verify_mandatory_closure import ClosureConsumer
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def orbit(ids):return min(tuple(sorted(16*(i//16)+(i%16+h)%16 for i in ids)) for h in range(16))
def main():
    start=time.monotonic();out=ROOT/'transfer-results';cp=out/'global-small-cohort.json';f=json.loads(cp.read_text())
    bp=ROOT/'relevant-results/comparison-seed-cuts.json';oldbank=json.loads(bp.read_text())['cuts'];oldpatterns=set()
    for c in oldbank:
        for h in range(16):oldpatterns.add(frozenset(16*(i//16)+(i%16+h)%16 for i in c['indices']))
    X,Z,A=physical();consumer=SparseQuotientConsumer(X,Z);closure=ClosureConsumer(X,Z,A);library=Path('/private/tmp/c16-sparse-quotient.dylib');oracle=SparseQuotientOracle(X,Z,library)
    starts={};records=[];cuts=[];seen=set();queries=0
    for k,record in enumerate(f['records']):
        c=record['cut'];consumer.check(c['certificate']);starts.setdefault((c['sector'],tuple(sorted(c['indices']))),k)
    for (side,J),source in starts.items():
        pairs=f['records'][source]['pairs'];assert set(J)=={p[side] for p in pairs}
        for reverse in [False,True]:
            current=list(J);initial=oracle.probe(1-side,current,3,1);queries+=1;assert initial;row=initial[0];removed=[]
            while True:
                changed=False
                for i in sorted(current,reverse=reverse):
                    trial=[j for j in current if j!=i];r=oracle.probe(1-side,trial,3,1);queries+=1
                    if r:current=trial;row=r[0];removed.append(i);changed=True
                if not changed:break
            consumer.check(row);key=orbit(current)
            if key in seen:continue
            seen.add(key);assert not any(p<=set(current) for p in oldpatterns)
            for i in current:assert not independent_obstruction(X,Z,1-side,[j for j in current if j!=i])[3]
            req=[[],[]];req[side]=current;prop=closure.replay(*req);assert prop['possible']
            cut={'kind':'universal_sparse_quotient','sector':side,'indices':current,'certificate':row};cuts.append(cut)
            records.append({'source_cohort_index':source,'source_iteration':f['records'][source]['iteration'],'starting_ids':list(J),
                'final_ids':current,'sector':side,'reverse_deletion_order':reverse,'removed_ids':removed,'canonical_orbit':list(key),
                'single_deletion_non_rejections':len(current),'old_256_bank_subsumes':False,'propagation':prop})
    oracle.close();d={'status':'SOURCE_CERTIFICATES_AND_SINGLE_DELETIONS_CHECKED','source_C16_answered':False,
        'cohort_sha256':sha(cp),'old_bank_sha256':sha(bp),'library_sha256':sha(library),
        'source_hashes':{p:sha(ROOT/p) for p in ['mine_global_small.py','sparse_quotient_oracle.py','verify_sparse_quotient.py','verify_sparse_gate.py']},
        'distinct_starting_sector_sets':len(starts),'queries':queries,'records':records,'cuts':cuts,'elapsed_seconds':time.monotonic()-start,
        'scope':'Fixed first global closure-passing11-pair matching. Two greedy deletion orders per sector; distinct final cyclic/sector orbits retained. Final certificates and every single deletion independently checked. No alteration of the frozen global trial, no new solver outcome, no global shortest-clause claim.'}
    (out/'global-small-seeds.json').write_text(json.dumps(d,indent=2)+'\n');print('GLOBAL SMALL',len(cuts),[(r['sector'],len(r['starting_ids']),r['final_ids']) for r in records],d['elapsed_seconds'],flush=True)
if __name__=='__main__':main()
