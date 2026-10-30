#!/usr/bin/env python3
"""Freeze one geometry-only singleton LP and its single physical pricing check."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,hashlib,json,os,time
ROOT=Path(__file__).resolve().parent

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(k)=='1'
    ap=argparse.ArgumentParser();ap.add_argument('--output',required=True);a=ap.parse_args()
    destination=ROOT/a.output;assert not destination.exists();start=time.monotonic();cache={};inputs={};bindings=0
    def sha(p):
        p=Path(p);p=p if p.is_absolute() else ROOT/p
        if p not in cache:cache[p]=hashlib.sha256(p.read_bytes()).hexdigest()
        return cache[p]
    def read(p):
        raw=(ROOT/p).read_bytes();return json.loads(gzip.decompress(raw) if str(p).endswith('.gz') else raw)
    prefix='two-basis-results/singleton-geometry-archive-point22-o32'
    seed=read('two-basis-results/singleton-geometry-point22-o32.json.gz')
    sr=read('two-basis-results/singleton-geometry-point22-o32-independent.json')
    model=read(prefix+'.model.json.gz');m=read(prefix+'.json');prep=read(prefix+'-independent.json')
    farkas=read(prefix+'-farkas-independent.json');pr=read(prefix+'-pricing-independent-v2.json')
    price=read(prefix+'-pricing.json');solve=read(prefix+'-solve.json')
    assert seed['status']=='GEOMETRY_SEED' and sr['status']=='PASS_EXACT_SINGLETON_GEOMETRY_SEED'
    assert model['physical_bases']==seed['physical_bases'] and len(model['physical_bases'])==203
    assert model['anchor_orbit']==32 and len(model['physical_zero_ground_indices'])==522
    assert set().union(*map(set,model['physical_bases']))==set(model['physical_zero_ground_indices'])
    assert prep['status']=='PASS_EXACT_SINGLETON_GEOMETRY_ARCHIVE_LP_TEXT_AND_PHYSICAL_COLUMNS'
    assert farkas['status']=='PASS_EXACT_RESTRICTED_SINGLETON_ARCHIVE_INFEASIBILITY'
    assert pr['status']=='PASS_EXACT_SINGLETON_PHYSICAL_BASIS_PRICING' and pr['pricing_sha256']==sha(prefix+'-pricing.json')
    assert price['global_rank_cut_candidate'] is None and price['missing_archive_column'] and Q(price['minimum_affine_value'])<0
    assert tuple(price['minimizing_physical_basis']) not in set(map(tuple,model['physical_bases']))
    assert all(r['manifest_sha256']==sha(prefix+'.json') for r in (prep,farkas,pr))
    names=set()
    for pattern in ('two-basis-results/singleton-geometry*','two-basis-results/legacy-singleton-point12-geometry*'):
        names.update(str(p.relative_to(ROOT)) for p in ROOT.glob(pattern) if p.is_file())
    names.update([Path(__file__).name,'prepare_singleton_geometry_seed.py','verify_singleton_geometry_seed.py',
                  'export_singleton_geometry_archive_lp.py','make_singleton_geometry_context.py',
                  'verify_singleton_geometry_archive.py','run_singleton_geometry_archive_soplex.py',
                  'price_singleton_geometry_archive.py','verify_singleton_geometry_pricing.py',
                  'SINGLETON-GEOMETRY-SEED.md','SINGLETON-GEOMETRY32-RESULT.md',
                  'SINGLETON-PHASE-I-REVIEW.md','SINGLETON-INVENTORY-CLOSURE-CLARIFICATION.md'])
    for p in sorted(names):
        sha(p)
        if not p.endswith(('.json','.json.gz')):continue
        obj=read(p)
        for key in ('source_hashes','dependencies'):
            for name,h in obj.get(key,{}).items():
                assert sha(name)==h,(p,name);bindings+=1
                if name in inputs:assert inputs[name]==h
                inputs[name]=h
    out=dict(status='PASS_BOUNDED_SINGLETON_GEOMETRY_ARCHIVE_GATE_CLOSURE',
             files=[dict(path=p,sha256=sha(p),bytes=(ROOT/p).stat().st_size) for p in sorted(names)],
             input_bindings=inputs,input_bindings_checked=bindings,
             point_sha256=model['point_sha256'],anchor_orbit=32,legacy_records=390,
             archive_columns=203,coverage_additions=0,last_solved_columns=203,discovered_columns=204,
             missing_unsolved_basis=price['minimizing_physical_basis'],
             exact_restricted_archive_infeasibility=True,exact_membership_proved=False,
             global_rank_cut_proved=False,source_C16_answered=False,
             solver_runs=1,physical_pricing_queries=1,old_status_guard_failure_preserved=True,
             all_owned_processes_finished=True,automatic_retry=False,
             transitive_import_closure_claimed=False,
             checkpoint_copy_rule='Union files and input_bindings; preserve inherited scientific source closure.',
             priority=19,elapsed_seconds=time.monotonic()-start)
    destination.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n')
    print(dict(status=out['status'],files=len(names),bindings=bindings,sha256=sha(destination),seconds=out['elapsed_seconds']))

if __name__=='__main__':main()
