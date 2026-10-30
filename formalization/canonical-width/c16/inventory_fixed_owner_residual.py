#!/usr/bin/env python3
"""Freeze the completed one-query fixed-owner gate without modifying inputs."""
from pathlib import Path
import argparse,gzip,hashlib,json,os,time
ROOT=Path(__file__).resolve().parent
PREFIX='two-basis-results/fixed-owner-residual-capacity-point22-Z-m02-X614-v1'

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(k)=='1'
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic()
    cache={};bindings=0
    def digest(p):
        p=Path(p);p=p if p.is_absolute() else ROOT/p
        if p not in cache:cache[p]=hashlib.sha256(p.read_bytes()).hexdigest()
        return cache[p]
    def read(p):
        raw=(ROOT/p).read_bytes();return json.loads(gzip.decompress(raw) if str(p).endswith('.gz') else raw)
    sources=['fixed_owner_residual_rank.py','fixed_owner_residual_tiny_controls.py','fixed_owner_existing_subset_screen.py',
             'run_fixed_owner_residual_bounded.py','verify_fixed_owner_residual_tiny.py','verify_fixed_owner_residual_physical.py',
             'verify_fixed_owner_existing_subset_screen.py','OWNER-FLOW-FIXED-NEIGHBOR-RANK.md','FIXED-OWNER-RESIDUAL-RESULT.md',Path(__file__).name]
    new=set(sources)|{str(p.relative_to(ROOT)) for p in ROOT.glob(PREFIX+'*')}
    new.update(['two-basis-results/fixed-owner-residual-tiny-v1.json.gz','two-basis-results/fixed-owner-residual-tiny-v1-independent.json','two-basis-results/fixed-owner-residual-first-selection.json'])
    inputs={};external=[]
    for name in sorted(new):
        digest(name)
        if not name.endswith(('.json','.json.gz')):continue
        obj=read(name)
        for key in ('source_hashes','dependencies'):
            for p,h in obj.get(key,{}).items():
                assert digest(p)==h,(name,p);bindings+=1
                if p in inputs:assert inputs[p]==h
                inputs[p]=h
    f=read(PREFIX+'.frozen.json');r=read(PREFIX+'-independent.json');run=read(PREFIX+'.run.json')
    assert r['status']=='PASS_INDEPENDENT_FIXED_OWNER_RESIDUAL_PHYSICAL_ENDPOINT' and r['exact_fixed_owner_membership'] is True
    assert r['certificate_sha256']==digest(PREFIX+'.json.gz') and r['frozen_sha256']==digest(PREFIX+'.frozen.json')
    assert run['returncode']==0 and not run['external_timeout'] and run['candidate_status']=='EXACT_COLORED_BASE_MIXTURE'
    assert run['endpoint_sha256']==r['certificate_sha256']
    runtime=read(PREFIX+'.run-frozen.json');assert digest(runtime['executable'])==runtime['executable_sha256']
    external.append(dict(path=runtime['executable'],sha256=runtime['executable_sha256'],required_for_independent_endpoint_replay=False))
    records=[dict(path=p,sha256=digest(p),bytes=(ROOT/p).stat().st_size) for p in sorted(new)]
    result=dict(status='PASS_FIXED_OWNER_RESIDUAL_COMPLETED_GATE_INVENTORY',files=records,
                input_bindings=inputs,existing_input_bindings_checked=bindings,external_runtime=external,
                source_C16_answered=False,global_target_exclusion_proved=False,
                exact_scope=dict(point_sha256=f['point_sha256'],mask=2,probe_side='X',probe=614,opposite_side='Z',
                                 exact_fixed_owner_basis_decomposition=True,other_patterns_certified=False,all_cross_pattern_probe_moments_certified=False),
                counts=dict(tiny_cases=420,tiny_all_subset_checks=67552,existing_subsets=256,positive_existing_subset_rows=0,
                            physical_colored_queries=1,literal_colored_bases=680,exact_target_coordinates=721),
                all_owned_processes_finished=True,no_retry=True,priority=19,elapsed_seconds=time.monotonic()-start)
    a.output.write_text(json.dumps(result,sort_keys=True,indent=2)+'\n');print(dict(status=result['status'],files=len(records),bindings=bindings,sha256=digest(a.output),seconds=result['elapsed_seconds']),flush=True)

if __name__=='__main__':main()
