#!/usr/bin/env python3
"""Freeze the completed conditional-union and direct8-event exact-law gate."""
from pathlib import Path
import argparse,gzip,hashlib,json,os,time
ROOT=Path(__file__).resolve().parent
def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(key)=='1'
    ap=argparse.ArgumentParser();ap.add_argument('--output',required=True);a=ap.parse_args();destination=ROOT/a.output;assert not destination.exists();start=time.monotonic()
    cache={};inputs={};bindings=0
    def sha(p):
        p=Path(p);p=p if p.is_absolute() else ROOT/p
        if p not in cache:cache[p]=hashlib.sha256(p.read_bytes()).hexdigest()
        return cache[p]
    def read(p):
        b=(ROOT/p).read_bytes();return json.loads(gzip.decompress(b) if str(p).endswith('.gz') else b)
    prefix='two-basis-results/global-eight-probe-point22'
    m=read(prefix+'.json');prep=read(prefix+'-independent.json');end=read(prefix+'-primal-independent.json');run=read(prefix+'-solve.json')
    peer=read('two-basis-results/global-eight-probe-source-peer-review.json')
    union=read('two-basis-results/owner-k22-conditional-union-point22.json');ur=read('two-basis-results/owner-k22-conditional-union-point22-independent.json')
    assert prep['status']=='PASS_EXACT_GLOBAL_EIGHT_PROBE_LP' and end['status']=='PASS_EXACT_GLOBAL_EIGHT_PROBE_LOCAL_LAW'
    assert end['positive_atoms']==37 and end['features_checked']==37 and end['allowed_mask_count']==152
    assert end['manifest_sha256']==prep['manifest_sha256']==sha(prefix+'.json')
    assert run['returncode']==0 and run['external_stop'] is None and run['reported_solver_status']=='problem is solved [optimal]'
    assert peer['status']=='PASS_READ_ONLY_GLOBAL_EIGHT_PROBE_SOURCE_AND_DUAL_REVIEW'
    assert ur['status']=='PASS_EXACT_CONDITIONAL_BOOLEAN_UNION_AUXILIARY_ROW'
    assert union['provided_allocation_excluded'] is True and union['global_moment_point_excluded'] is False
    names=set()
    for pattern in ('two-basis-results/global-eight-probe*','two-basis-results/owner-global-k22-point22*','two-basis-results/owner-k22-conditional-union-point22*'):
        names.update(str(p.relative_to(ROOT)) for p in ROOT.glob(pattern) if p.is_file())
    names.update([Path(__file__).name,'audit_owner_global_k22.py','extract_owner_k22_union_cut.py','verify_owner_k22_conditional_union.py',
                  'export_global_eight_probe_law.py','verify_global_eight_probe_law.py','run_global_eight_probe_law_soplex.py',
                  'OWNER-K22-CONDITIONAL-PAIR-LAW.md','GLOBAL-EIGHT-PROBE-GATE.md','OWNER-K22-EIGHT-PROBE-RESULT.md'])
    for p in sorted(names):
        sha(p)
        if not p.endswith(('.json','.json.gz')):continue
        obj=read(p)
        for key in ('source_hashes','dependencies','source_bindings'):
            for name,h in obj.get(key,{}).items():
                assert isinstance(h,str) and sha(name)==h,(p,name);bindings+=1
                if name in inputs:assert inputs[name]==h
                inputs[name]=h
    out=dict(status='PASS_OWNER_K22_AND_GLOBAL_EIGHT_PROBE_CLOSURE',
             files=[dict(path=p,sha256=sha(p),bytes=(ROOT/p).stat().st_size) for p in sorted(names)],
             input_bindings=inputs,input_bindings_checked=bindings,
             conditional_auxiliary_cut_independently_accepted=True,global_eight_event_law_independently_accepted=True,
             global_point_excluded=False,source_C16_answered=False,physical_frame_constructed=False,
             point_sha256=m['point_sha256'],state_count=256,allowed_states=152,exact_features=37,positive_atoms=37,
             solver_calls=1,automatic_retry=False,owned_processes_remaining=False,preparation_collision_preserved=True,
             full_conditional_pair_extension_implemented=False,
             checkpoint_copy_rule='Union files and input_bindings; preserve inherited shared source closure. External runtime binaries are recorded separately in the solve frozen manifest.',
             transitive_import_closure_claimed=False,priority=19,elapsed_seconds=time.monotonic()-start)
    destination.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n')
    print(dict(status=out['status'],files=len(names),bindings=bindings,sha256=sha(destination),seconds=out['elapsed_seconds']))
if __name__=='__main__':main()
