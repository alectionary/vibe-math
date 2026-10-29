#!/usr/bin/env python3
"""Replay the strict order3 gains against the existing unrestricted closure."""
from pathlib import Path
import argparse, hashlib, json, time
from verify_algebraic_model import physical
from verify_mandatory_closure import ClosureConsumer

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser();p.add_argument('--gate',type=Path,required=True);p.add_argument('--cohort',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();start=time.monotonic()
    gate=json.loads(a.gate.read_text());cohort=json.loads(a.cohort.read_text())['records'];assert sha(a.cohort)==gate['cohort_sha256']
    X,Z,A=physical();consumer=ClosureConsumer(X,Z,A);records=[]
    for k,row in enumerate(gate['records']):
        if not (row['complete3_reject'] and not row['complete2_reject']):continue
        pairs=cohort[k]['pairs'];sector=[]
        for side in (0,1):
            ids=[v[side] for v in pairs];req=[[],[]];req[side]=ids
            sector.append(consumer.replay(*req))
        joint=consumer.replay([v[0] for v in pairs],[v[1] for v in pairs])
        records.append({'cohort_index':k,'pairs':pairs,'individual_sector_results':sector,'joint_result':joint})
    out={'status':'PASS','source_C16_answered':False,'gate_sha256':sha(a.gate),'cohort_sha256':sha(a.cohort),'strict_order3_cases':len(records),'accepted_by_both_individual_closures':sum(all(r['possible'] for r in item['individual_sector_results']) for item in records),'accepted_by_joint_closure':sum(item['joint_result']['possible'] for item in records),'records':records,'physical_forced_coloop_covectors_checked':consumer.forced_covectors_checked,'elapsed_seconds':time.monotonic()-start,'scope':'Post-gate overlap diagnostic on exactly the frozen strict order3 improvements. Existing unrestricted mandatory closure is replayed independently. It does not widen the cohort or change the frozen comparison.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='records'},flush=True)
if __name__=='__main__':main()
