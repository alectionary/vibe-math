#!/usr/bin/env python3
"""Describe the frozen comparison without turning partial cuts into cover proofs."""
from pathlib import Path
import argparse,collections,hashlib,json
ROOT=Path(__file__).resolve().parent

def main():
    p=argparse.ArgumentParser();p.add_argument('--directory',type=Path,default=ROOT/'three-term-results');p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    gate=json.loads((a.directory/'sparse-gate.json').read_text());frozen=json.loads((a.directory/'matched-frozen.json').read_text());patterns=set()
    for row in gate['new_certificates']:
        for phase in range(16):patterns.add(tuple(sorted(16*(i//16)+(i%16+phase)%16 for i in row['mandatory_opposite'])))
    patterns=sorted(patterns);trials=[];datasets=[]
    for order in frozen['variants']:
        path=a.directory/f'matched-order-{order}.json';d=json.loads(path.read_text());datasets.append(d);cuts=d['cuts'][d['seed_cut_count']:];calls=collections.Counter();hit_records=0
        for record in d['records']:
            for row in record['rank_checks']:
                if 'quotient_exclusions' in row:calls['invocations']+=1;calls['exclusions']+=row['quotient_exclusions']
            chosen=[{v[side] for v in record['pairs']} for side in (0,1)]
            hit_records+=any(set(pattern)<=ids for ids in chosen for pattern in patterns)
        trials.append({'order':order,'status':d['status'],'answer':d['answer'],'records':len(d['records']),'new_cut_count':len(cuts),'new_cut_kinds':dict(collections.Counter(c['kind'] for c in cuts)),'new_sparse_cut_orders':dict(collections.Counter(c['certificate']['order'] for c in cuts if c['kind']=='universal_sparse_quotient')),'quotient_invocations':calls['invocations'],'quotient_exclusions':calls['exclusions'],'records_hit_by_frozen_gate_certificates':hit_records,'initial_input_sha256':d['initial_input_sha256'],'final_input_sha256':d['input_sha256'],'final_clauses':d['clauses'],'metadata_sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
    assert len({d['initial_input_sha256'] for d in datasets})==1
    prefix=0
    for rows in zip(*(d['records'] for d in datasets)):
        if not all(row['pairs']==rows[0]['pairs'] for row in rows[1:]):break
        prefix+=1
    out={'status':'BOUNDED_COMPARISON_COMPLETE','source_C16_answered':False,'cover_before':409,'cover_after':409,'physical_partial_pairs':88,'full_source_anchor_cases_completed':0,'all_three_unknown':all(r['answer'] is None and r['status'].startswith('UNKNOWN') for r in trials),'initial_inputs_identical':True,'common_partial_matching_prefix':prefix,'frozen_gate_patterns_after_rotation_sector_agnostic':len(patterns),'results':trials,'scope':'Matched concurrent 600-second discovery calls on one cover anchor. Partial-cut counts are not completed cases or a speedup measurement. The post-trial gate-certificate overlap is descriptive only; those clauses were not used to alter the frozen trials.'}
    assert out['all_three_unknown'], 'A solved case needs proof checking and a cover update before this summary can be used.'
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
if __name__=='__main__':main()
