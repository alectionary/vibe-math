#!/usr/bin/env python3
"""Complete union of accepted inherited closures and one frozen batch gate."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):os.environ[k]='1'
from pathlib import Path
import hashlib,json
ROOT=Path(__file__).resolve().parent
BASES=['two-basis-results/owner-flow-capacity-zero-face-inventory.json',
       'two-basis-results/singleton-global-point22-o40-complete-inventory.json',
       'two-basis-results/singleton-global-point22-o15-complete-inventory.json',
       'two-basis-results/singleton-o15-negative-exchange-batch-inventory.json']
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):return json.loads(Path(p).read_text())
def main():
    out=ROOT/'two-basis-results/singleton-o15-batch64-complete-inventory.json';assert not out.exists()
    files={};external={};parents=[]
    def add(name,digest):
        p=Path(name)
        if p.is_absolute():
            if p.is_relative_to(ROOT):name=str(p.relative_to(ROOT))
            else:assert sha(p)==digest;external[str(p)]=digest;return
        assert '..' not in Path(name).parts
        assert name not in files or files[name]==digest,('mismatched inherited binding',name)
        files[name]=digest
    for name in BASES:
        d=read(ROOT/name);add(name,sha(ROOT/name));parents.append(dict(path=name,sha256=sha(ROOT/name)))
        for key in ('files','additional_files'):
            rows=d.get(key,{})
            if isinstance(rows,dict):
                for p,v in rows.items():add(p,v['sha256'])
            else:
                for v in rows:add(v['path'],v['sha256'])
        for p,h in d.get('input_bindings',{}).items():add(p,h)
    seeds=[Path(__file__),ROOT/'run_singleton_negative_batch_lp.py',ROOT/'singleton_o15_batch64_lp_result.md',
           ROOT/'singleton_o15_negative_exchange_batch.md',ROOT/'two-basis-results/singleton-negative-exchange-batch-peer-review.json']
    seeds.extend((ROOT/'two-basis-results').glob('singleton-o15-batch64-point22*'))
    seeds.extend((ROOT/'two-basis-results').glob('singleton-o15-r20-negative-exchange-batch*'))
    for p in seeds:add(str(p.relative_to(ROOT)),sha(p))
    # Check every unique declared file once, not once per repeated binding.
    records={}
    for name,h in sorted(files.items()):
        p=ROOT/name;assert sha(p)==h,name;records[name]=dict(sha256=h,bytes=p.stat().st_size)
    gate=read(ROOT/'two-basis-results/singleton-o15-batch64-point22.json')
    assert gate['outcome']=='EXACT_RESTRICTED_ARCHIVE_INFEASIBLE_WITH_MISSING_COLUMN'
    assert gate['lp_calls']==gate['post_lp_pricing_calls']==1
    result=dict(status='FROZEN_COMPLETE_SINGLETON_NEGATIVE_BATCH_GATE_CLOSURE',inherited_inventories=parents,
                files=records,file_count=len(records),local_bytes=sum(r['bytes'] for r in records.values()),external_files=external,
                last_solved_columns=3225,final_discovered_columns=3226,exact_membership_proved=False,global_rank_cut_proved=False,
                within_batch_direction_rank=64,new_lp_calls=1,new_pricing_calls=1,source_C16_answered=False,
                all_owned_processes_finished=True,producer_sha256=sha(__file__),nice=19,threads=1)
    out.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k not in ('files','external_files','inherited_inventories')}))
if __name__=='__main__':main()
