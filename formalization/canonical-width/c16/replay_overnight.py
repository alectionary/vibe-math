#!/usr/bin/env python3
"""Replay the overnight exact results and source-question accounting; no solve."""
from pathlib import Path
import argparse
import hashlib
import json
import os
import subprocess
import sys
import tempfile

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
RESULTS=HERE/'overnight-results'


def load(p):return json.loads(p.read_text())
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    checks=[]
    with tempfile.TemporaryDirectory(prefix='c16-exact-replay-') as temp:
        temp=Path(temp)
        jobs=[
          ('joint034','verify_exchange_dual.py',[str(RESULTS/'joint034-dual-no-cap.json.gz'),'--psd',str(RESULTS/'joint034-dual.json.PSD.json.gz')]),
          ('anchor-cover','verify_anchor_cover.py',[]),
          ('anchor-certificate','verify_anchor_cover_certificate.py',[]),
          ('asymptotic-barrier','verify_asymptotic_barrier.py',[]),
          ('omega-moments','screen_omega_moment_cuts.py',[]),
          ('support-field','verify_support_field_scope.py',[]),
          ('partial-maximality','verify_partial_maximality.py',[]),
          ('corruptions','verify_exchange_dual_controls.py',[])]
        results={}
        for name,script,args in jobs:
            p=temp/(name+'.json');cmd=[sys.executable,str(HERE/script),*args,'--output',str(p)]
            run=subprocess.run(cmd,cwd=ROOT,text=True,capture_output=True,timeout=240)
            assert run.returncode==0,(name,run.stdout,run.stderr)
            d=load(p);assert d['status']=='PASS' and d['source_C16_answered'] is False
            results[name]=d;checks.append({'name':name,'status':'PASS','stdout':run.stdout.strip()})
        assert results['joint034']['strict_gap']=='-1093420454219/1099511627776'
        assert results['joint034']['critical_monomial_cap_used'] is False
        assert results['joint034']['source_coordinate_bridge']['full_pool_pairings_checked']==518400
        assert results['anchor-cover']['optimal_anchor_orbit_count']==12
        assert results['anchor-certificate']['selected_pair_cover']['optimal_basis_cover_case_count']==1082
        assert results['omega-moments']['violated_cut_count']==0
        assert len(results['corruptions']['rejected_corruptions'])==6
        run=subprocess.run([sys.executable,str(HERE/'verify_partial_frame.py'),str(HERE/'partial-frame-88.json')],cwd=ROOT,text=True,capture_output=True,timeout=60)
        assert run.returncode==0 and '88 pairs' in run.stdout
        checks.append({'name':'physical88','status':'PASS','stdout':run.stdout.strip()})
    # Historical frozen evidence is unchanged, not silently regenerated.
    history=[]
    for directory in ['structural-results','inversion-results','inverse-four-hour-results','literature-techniques-results']:
        manifest=HERE/directory/'manifest.json';d=load(manifest)
        files=d['files'] if 'files' in d else [{'path':str((HERE/k).relative_to(ROOT)),'sha256':v} for k,v in d['SHA256'].items()]
        for row in files:assert digest(ROOT/row['path'])==row['sha256'],row['path']
        history.append({'manifest':str(manifest.relative_to(ROOT)),'files_checked':len(files)})
    entries=load(ROOT/'literature/open-problems.json');papers=load(ROOT/'literature/downstream-paper-coverage.json')
    assert len(entries)==398 and sum(r['eligible_for_coverage'] for r in entries)==160
    assert len(papers)==190 and sum(r['coverage_status'].endswith('full_text_screened') for r in papers)==158
    screen=load(RESULTS/'paper-screening.json');assert screen['canonical_new_entries']==15 and screen['eligible_source_targets']==6
    missing=[]
    for paper in screen['papers']:
        ids={r['id'] for r in entries if any(o['source_id']==paper['paper_id'] for o in r['occurrences'])}
        assert set(paper['target_ids'])==ids and paper['question_count']==len(ids)
        cov=next(r for r in papers if r['paper_id']==paper['paper_id'])
        assert set(cov['recorded_target_ids'])==ids and cov['coverage_status']=='full_text_screened'
        for field,sha in [('source_local_file','source_sha256'),('text_local_file','text_sha256')]:
            p=ROOT/paper[field]
            if p.exists():assert digest(p)==paper[sha]
            else:missing.append(paper[field])
    for suffix in ['mimsup-support-functional','strict-mimsup-support']:
        r=next(r for r in entries if r['id']=='L-F153-'+suffix);assert not r['eligible_for_coverage']
    support=load(RESULTS/'support-regimes.json');assert support['remaining_exchange_representatives']==90 and support['remaining_ordered_cases']==168
    receipts=[]
    for p in RESULTS.glob('*.exit.json'):
        d=load(p)
        if d['status']=='RUNNING' and d.get('child_pid')==os.getpid():continue
        assert d['status']!='RUNNING',p.name
        if d['status'] in ['WALL_LIMIT','MEMORY_LIMIT','MEMORY_MONITOR_FAILURE']:assert d.get('termination_confirmed'),p.name
        receipts.append({'file':p.name,'status':d['status'],'exit_code':d.get('exit_code')})
    manifest=RESULTS/'manifest.json';frozen=0
    if manifest.exists():
        for row in load(manifest)['files']:assert digest(ROOT/row['path'])==row['sha256'];frozen+=1
    output={'status':'PASS','source_C16_answered':False,'width_options':[16,18],'best_physical_pairs':88,
        'exact_checks':checks,'historical_manifests':history,'frozen_overnight_files_checked':frozen,
        'inventory':{'entries':398,'eligible':160,'papers':190,'full_text_screens':158,'complete_Lean_targets':6},
        'paper_source_cache_unavailable':missing,'paper_cache_limit':'Missing optional local caches are explicit gaps in byte rechecking, not successful retrievals. Exact C16 proofs do not require the literature caches.',
        'terminal_receipts':receipts,'remaining_support_representatives':90,'unresolved_anchor_cases':12}
    a.output.write_text(json.dumps(output,indent=2)+'\n')
    print('PASS: exact joint certificate, source bridge,12-anchor cover, two method barriers, field scope,6 corruptions, physical88 and source accounting.',flush=True)


if __name__=='__main__':main()
