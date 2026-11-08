#!/usr/bin/env python3
"""Preserve the bounded orbit15 exact-CG calibration and every accepted round."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,hashlib,json,os,time
ROOT=Path(__file__).resolve().parent

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(k)=='1'
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic()
    cache={};bindings=0;inputs={}
    def sha(p):
        p=Path(p);p=p if p.is_absolute() else ROOT/p
        if p not in cache:cache[p]=hashlib.sha256(p.read_bytes()).hexdigest()
        return cache[p]
    def read(p):
        raw=(ROOT/p).read_bytes();return json.loads(gzip.decompress(raw) if str(p).endswith('.gz') else raw)
    prefix='two-basis-results/singleton-cg-point22-o15';gate=read(prefix+'.json');f=read(prefix+'.frozen.json');sup=read(prefix+'.supervisor.json')
    assert gate['stop_reason']=='MAXIMUM_20_ROUNDS' and gate['result'] is None and len(gate['records'])==20
    assert gate['frozen_sha256']==sha(prefix+'.frozen.json') and sup['returncode']==0
    assert f['anchor_orbit']==gate['anchor_orbit']==15 and f['initial_columns']==gate['initial_columns']==3140
    seed=read('two-basis-results/singleton-archive-point22-o15.model.json.gz')
    B=list(seed['physical_bases']);seen=set(map(tuple,B))
    for row in f['seed_columns']:
        b=row['basis']
        if tuple(b) not in seen:B.append(b);seen.add(tuple(b))
    assert len(B)==3141==f['seeded_columns']
    rounds=[]
    for record in gate['records']:
        i=record['iteration'];stem=prefix+f'-r{i:02d}';cols=read(record['column_bank'])
        assert cols['physical_bases']==B and record['columns']==len(B) and record['column_bank_sha256']==sha(record['column_bank'])
        manifest=read(stem+'.json');prep=read(stem+'-independent.json');ray=read(stem+'-farkas-independent.json')
        price=read(stem+'-pricing.json');pr=read(stem+'-pricing-independent.json')
        assert prep['status']=='PASS_EXACT_SINGLETON_ARCHIVE_LP_TEXT_AND_PHYSICAL_COLUMNS' and prep['manifest_sha256']==sha(stem+'.json')
        assert ray['status']=='PASS_EXACT_RESTRICTED_SINGLETON_ARCHIVE_INFEASIBILITY' and ray['manifest_sha256']==sha(stem+'.json')
        assert pr['status']=='PASS_EXACT_SINGLETON_PHYSICAL_BASIS_PRICING' and pr['pricing_sha256']==sha(stem+'-pricing.json')
        assert price['global_rank_cut_candidate'] is None and price['missing_archive_column'] and Q(price['minimum_affine_value'])<0
        b=price['minimizing_physical_basis'];assert tuple(b) not in seen;B.append(b);seen.add(tuple(b))
        rounds.append(dict(iteration=i,solved_columns=record['columns'],manifest_sha256=sha(stem+'.json'),farkas_receipt_sha256=sha(stem+'-farkas-independent.json'),pricing_receipt_sha256=sha(stem+'-pricing-independent.json')))
    assert len(B)==3161==gate['final_columns'] and gate['records'][-1]['columns']==3160
    names=set()
    for pattern in ('two-basis-results/singleton-global-point22-o15*','two-basis-results/singleton-archive-point22-o15*',prefix+'*','two-basis-results/singleton-cg-generic*'):
        names.update(str(p.relative_to(ROOT)) for p in ROOT.glob(pattern))
    names.update([Path(__file__).name,'make_singleton_cg_generic.py','singleton_exact_column_gate_generic.py','run_singleton_exact_column_gate_generic.py','run_singleton_archive_cg_soplex_generic.py','GLOBAL-RANK-REASSESSMENT.md'])
    for p in sorted(names):
        sha(p)
        if not p.endswith(('.json','.json.gz')):continue
        obj=read(p)
        for key in ('source_hashes','dependencies'):
            for name,h in obj.get(key,{}).items():
                assert sha(name)==h,(p,name);bindings+=1
                if name in inputs:assert inputs[name]==h
                inputs[name]=h
    out=dict(status='PASS_BOUNDED_ORBIT15_EXACT_CG_CALIBRATION_CLOSURE',
             files=[dict(path=p,sha256=sha(p),bytes=(ROOT/p).stat().st_size) for p in sorted(names)],
             input_bindings=inputs,input_bindings_checked=bindings,rounds=rounds,
             point_sha256=gate['point_sha256'],anchor_orbit=15,initial_columns=3140,coverage_seed_columns=1,
             priced_missing_columns=20,last_solved_columns=3160,final_discovered_columns=3161,
             final_unsolved_priced_basis=B[-1],final_unsolved_pricing_receipt=prefix+'-r20-pricing-independent.json',
             exact_membership_proved=False,global_rank_cut_proved=False,stop_reason=gate['stop_reason'],
             original_push_cap_preserved=True,all_owned_processes_finished=True,automatic_retry=False,
             source_C16_answered=False,priority=19,elapsed_seconds=time.monotonic()-start,
             scope='Every finite archive failure and full-domain pricing is exactly accepted; the20-round cap leaves the global orbit15 rank question unresolved.')
    a.output.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n');print(dict(status=out['status'],files=len(names),bindings=bindings,sha256=sha(a.output),seconds=out['elapsed_seconds']),flush=True)

if __name__=='__main__':main()
