#!/usr/bin/env python3
"""Freeze the completed successor cohort and smoke-replay its source closure."""
from pathlib import Path
from collections import Counter
import argparse, json, os, shutil, subprocess, sys, time
from two_basis_portable_replay_v4 import closure, sha, data, ROOT

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--batch',type=Path,required=True)
    ap.add_argument('--copy-root',type=Path,required=True)
    ap.add_argument('--output-dir',type=Path,required=True)
    a=ap.parse_args();start=time.monotonic();b=data(a.batch)
    assert b['status']=='ALL_COHORT_ENDPOINTS_INDEPENDENTLY_REPLAYED' and len(b['outcomes'])==22
    assert not a.copy_root.exists() and not a.output_dir.exists()
    fp=a.batch.with_suffix('.frozen.json');f=data(fp)
    assert b['frozen_sha256']==sha(fp)
    assert all(sha(ROOT/p)==h for p,h in f['source_hashes'].items())
    seeds=[Path(__file__).name,'two_basis_export_physical_closed_rank_rows.py',
           'verify_two_basis_rank_closed_allocation.py','two_basis_physical_closed_batch.py',
           'two_basis_structure_verify_physical_push_closed.py',
           'two-basis-results/two-basis-point22-closed-rank-export-summary.json',
           'two-basis-results/two-basis-physical-closed-preparation-control.json',
           'two-basis-results/two-basis-rank-closed-allocation-regression-independent.json']
    for pattern in ['two-basis-push-relabel-closed-point22*','two-basis-direct-*-closedrank*',
                    'two-basis-point22-*-closed-rank-bank*']:
        seeds.extend(str(p.relative_to(ROOT)) for p in (ROOT/'two-basis-results').glob(pattern) if p.is_file())
    names=closure(seeds);files=[dict(path=n,sha256=sha(ROOT/n),bytes=(ROOT/n).stat().st_size) for n in names]
    cohort=[]
    for r in b['outcomes']:
        c=data(ROOT/r['certificate']);receipt=data(ROOT/r['receipt']);s=c['solver_endpoint']
        assert sha(ROOT/r['certificate'])==r['certificate_sha256']==receipt['certificate_sha256']
        assert sha(ROOT/r['receipt'])==r['receipt_sha256']
        cut=c['physical_rank_cut']
        cohort.append(dict(side=r['side'],mask=r['mask'],solver_status=s['status'],
            independent_status=receipt['status'],solver_seconds=s['seconds'],steps=s['steps'],
            zero_bases=len(s['bases']),full_bases=len(c['physical_basis_records']),
            rank=cut['contraction_rank'] if cut else None,raw_rank_gap=cut['exact_raw_violation'] if cut else None))
    assert sorted((r['side'],r['mask']) for r in cohort)==sorted((s,m) for s in ['X','Z'] for m in [0,1,2,3,4,5,6,8,9,10,12])
    a.output_dir.mkdir(parents=True);a.copy_root.mkdir(parents=True)
    for r in files:
        p=a.copy_root/r['path'];p.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(ROOT/r['path'],p)
        assert sha(p)==r['sha256']
    inventory=dict(status='FROZEN_POINT22_SUCCESSOR_PHYSICAL_COHORT',point_sha256=f['point_sha256'],
        batch_sha256=sha(a.batch),cohort=cohort,counts=dict(Counter(r['solver_status'] for r in cohort)),
        source_data_closure=files,total_files=len(files),total_bytes=sum(r['bytes'] for r in files),
        producer_sha256=sha(__file__),source_root=str(ROOT),copy_root=str(a.copy_root.resolve()),
        automatic_refinement_performed=False,all_patterns_membership_proved=False,
        shared_lambda_excluded=False,global_target_excluded=False,source_C16_answered=False)
    (a.output_dir/'inventory.json').write_text(json.dumps(inventory,indent=2)+'\n')
    jobs=[];point='coupling-results/two-basis-integer-witness22-rational.json.gz'
    for side in ['X','Z']:
        jobs.append((f'allocation-{side}',['verify_two_basis_rank_closed_allocation.py','allocation','--certificate',
            f'two-basis-results/two-basis-direct-{side}-closedrank-dyadic-point22-b50.json.gz','--point',point]))
        jobs.append((f'closed-bank-{side}',['two_basis_structure_verify_physical_closed_rank_bank.py','--bank',
            f'two-basis-results/two-basis-point22-{side}-closed-rank-bank.json']))
    for status in ['EXACT_BASE_MIXTURE','EXACT_RANK_VIOLATION']:
        r=next((r for r in b['outcomes'] if r['solver_status']==status),None)
        if r:jobs.append((status,['two_basis_structure_verify_physical_push_closed.py','--certificate',r['certificate'],'--point',point]))
    results=[];env=dict(os.environ,OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1',MKL_NUM_THREADS='1',VECLIB_MAXIMUM_THREADS='1',PYTHONDONTWRITEBYTECODE='1')
    temp=a.copy_root/'two-basis-results/closed-cohort-clean-replay';temp.mkdir()
    for label,args in jobs:
        output=temp/(label+'.json');log=a.output_dir/(label+'.log')
        command=[sys.executable,'-B',*args,'--output',str(output)]
        with log.open('w') as stream:
            result=subprocess.run(command,cwd=a.copy_root,env=env,stdout=stream,stderr=subprocess.STDOUT,timeout=60)
        assert result.returncode==0 and output.exists(),label
        shutil.copy2(output,a.output_dir/output.name);receipt=data(output)
        results.append(dict(name=label,status=receipt['status'],receipt_sha256=sha(output),log_sha256=sha(log)))
    assert all(sha(ROOT/r['path'])==r['sha256'] for r in files)
    summary=dict(status='PASS_SUCCESSOR_COHORT_CLEAN_COPY_REPLAY',inventory_sha256=sha(a.output_dir/'inventory.json'),
        total_files=len(files),total_bytes=inventory['total_bytes'],counts=inventory['counts'],
        results=results,elapsed_seconds=time.monotonic()-start,source_C16_answered=False,
        scope='All22 original endpoints have independent physical receipts. Clean-copy smoke repeats both allocations, both incoming closed banks, and one endpoint of each observed decision type; it is not a second full22 endpoint replay.')
    (a.output_dir/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps(summary),flush=True)
if __name__=='__main__':main()
