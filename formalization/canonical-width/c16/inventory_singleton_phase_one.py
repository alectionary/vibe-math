#!/usr/bin/env python3
"""Freeze one completed phase-I calibration with its inherited physical archive."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    os.environ[key]='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,hashlib,json
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):return json.loads(Path(p).read_text())
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--endpoint',type=Path,required=True)
    ap.add_argument('--source',type=Path,action='append',default=[]);a=ap.parse_args()
    parent=ROOT/'two-basis-results/singleton-o15-batch64-complete-inventory.json'
    out=ROOT/'two-basis-results/singleton-o15-phase-one-complete-inventory.json';assert not out.exists()
    inherited=read(parent);files={p:r['sha256'] for p,r in inherited['files'].items()}
    def add(path):
        path=path.resolve();name=str(path.relative_to(ROOT));digest=sha(path)
        assert name not in files or files[name]==digest,name
        files[name]=digest
    add(parent)
    for p in [Path(__file__),ROOT/'export_singleton_phase_one.py',ROOT/'run_singleton_phase_one_soplex.py',
              ROOT/'verify_singleton_phase_one.py',ROOT/'read_soplex_exact_output.py',
              ROOT/'SINGLETON-PHASE-ONE.md',ROOT/'two-basis-results/singleton-phase-one-peer-review.json',
              ROOT/'singleton_o15_phase_one_result.md',a.endpoint,*a.source]:add(p)
    for p in (ROOT/'two-basis-results').glob('singleton-o15-batch64-phase-one-point22*'):add(p)
    endpoint=read(a.endpoint)
    assert endpoint['status']=='PASS_EXACT_SINGLETON_PHASE_ONE_OPTIMUM_AND_FULL_GREEDY_PRICING'
    assert endpoint['point_sha256']=='4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f'
    assert endpoint['anchor_orbit']==15 and endpoint['physical_bases_checked']==3225
    records={}
    for name,h in sorted(files.items()):
        p=ROOT/name;assert sha(p)==h,name;records[name]=dict(sha256=h,bytes=p.stat().st_size)
    objective=Q(endpoint['exact_restricted_L1_distance']);gap=Q(endpoint['pricing']['exact_global_separation_gap'])
    result=dict(status='FROZEN_COMPLETE_SINGLE_EXACT_PHASE_ONE_CALIBRATION',
                parent_inventory=str(parent.relative_to(ROOT)),parent_inventory_sha256=sha(parent),
                files=records,file_count=len(records),local_bytes=sum(r['bytes'] for r in records.values()),
                external_files=inherited.get('external_files',{}),endpoint=str(a.endpoint),endpoint_sha256=sha(a.endpoint),
                exact_restricted_L1_distance=str(objective),exact_global_separation_gap=str(gap),
                exact_missing_column_reduced_cost=str(objective-gap),
                full_singleton_membership=objective==0,global_separation_proved=gap>0,
                lp_calls=1,source_C16_answered=False,all_owned_processes_finished=True,
                producer_sha256=sha(__file__),nice=19,threads=1)
    out.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k not in ('files','external_files')}),flush=True)
if __name__=='__main__':main()
