#!/usr/bin/env python3
"""Freeze the one matched phase-I trial and complete inherited source closure."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    os.environ[key]='1'
from pathlib import Path
import hashlib,json
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):return json.loads(Path(p).read_text())
def main():
    parent=ROOT/'two-basis-results/singleton-o15-phase-one-complete-inventory.json'
    out=ROOT/'two-basis-results/singleton-phase-one-matched-complete-inventory.json';assert not out.exists()
    inherited=read(parent);files={p:r['sha256'] for p,r in inherited['files'].items()}
    def add(path):
        path=path.resolve();name=str(path.relative_to(ROOT));digest=sha(path)
        assert name not in files or files[name]==digest,name
        files[name]=digest
    add(parent)
    for name in ('singleton_phase_one_exchange_batch.py','verify_singleton_phase_one_exchange_batch.py',
                 'export_singleton_phase_one_matched.py','run_singleton_phase_one_matched_soplex.py',
                 'compare_singleton_phase_one_matched.py','singleton_phase_one_matched_result.md',
                 'inventory_singleton_phase_one_matched.py'):
        add(ROOT/name)
    for p in (ROOT/'two-basis-results').glob('singleton-phase-one-matched-*'):
        if p!=out:add(p)
    comparison=ROOT/'two-basis-results/singleton-phase-one-matched-point22-comparison.json';c=read(comparison)
    assert c['status']=='PASS_EXACT_MATCHED_PHASE_ONE_OBJECTIVE_COMPARISON'
    records={}
    for name,h in sorted(files.items()):
        p=ROOT/name;assert sha(p)==h,name;records[name]=dict(sha256=h,bytes=p.stat().st_size)
    result=dict(status='FROZEN_COMPLETE_MATCHED_SINGLETON_PHASE_ONE_TRIAL',
                parent_inventory=str(parent.relative_to(ROOT)),parent_inventory_sha256=sha(parent),
                files=records,file_count=len(records),local_bytes=sum(r['bytes'] for r in records.values()),
                external_files=inherited.get('external_files',{}),comparison=str(comparison.relative_to(ROOT)),comparison_sha256=sha(comparison),
                matched_trial_lp_calls=1,strict_exact_decrease=c['strict_decrease'],
                exact_old_L1_distance=c['exact_old_L1_distance'],exact_new_L1_distance=c['exact_new_L1_distance'],
                exact_relative_decrease=c['exact_relative_decrease'],full_singleton_membership=c['full_singleton_membership'],
                global_cut_proved=c['positive_global_gap'],source_C16_answered=False,
                all_owned_processes_finished=True,no_automatic_retry=True,producer_sha256=sha(__file__),nice=19,threads=1)
    out.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k not in ('files','external_files','exact_old_L1_distance','exact_new_L1_distance','exact_relative_decrease')}),flush=True)
if __name__=='__main__':main()
