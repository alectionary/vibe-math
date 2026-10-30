#!/usr/bin/env python3
"""Run independent consumers from an immutable clean checkout, outside its tree."""
from pathlib import Path
import argparse, datetime, hashlib, json, os, subprocess, sys, time
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--checkout',type=Path,required=True)
    ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    repo=a.checkout.resolve();cwd=repo/'formalization/canonical-width/c16';out=a.output.resolve()
    assert not out.exists();out.mkdir(parents=True)
    assert not subprocess.check_output(['git','status','--porcelain'],cwd=repo)
    commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=repo,text=True).strip()
    r='coupling-results/';old='moment-resumption-results/';point=r+'witness2-rational.json.gz'
    steps=[
        ('conditional32','verify_conditional_profile_compatibility.py',['--bank',r+'conditional-compat-orbit32.json']),
        ('conditional27','verify_conditional_profile_compatibility.py',['--bank',r+'conditional-compat-orbit27.json']),
        ('joint-matched','verify_joint_anchor_profile_bound.py',['--certificate',r+'joint-anchor-matched-exact.json','--parent',old+'common-profile32-projected-pruned.json','--point',old+'boolean-rational1.json.gz']),
        ('joint-conditional','verify_joint_anchor_profile_bound.py',['--certificate',r+'joint-anchor-conditional-exact.json','--parent',old+'common-profile32-projected-pruned.json','--point',old+'boolean-rational1.json.gz']),
        ('unified','verify_unified_moment_point.py',['--certificate',point,'--old-replay',r+'witness2-old-replay.json','--matroid-cuts',old+'closed-rank-bank-augmented.json',old+'final-point-rank-probe.json','--matroid-replays',old+'closed-rank-bank-augmented-independent.json',old+'final-point-rank-probe-independent.json']),
        ('projected','verify_projected_profile_moment_rows.py',['--point',point,'--banks',old+'common-profile32-projected-pruned.json',r+'joint-anchor-matched-exact.json',r+'joint-anchor-conditional-exact.json','--replays',old+'common-profile32-projected-pruned-independent.json',str(out/'joint-matched.json'),str(out/'joint-conditional.json'),'--require-feasible']),
        ('global','check_global_conditioned_moments.py',['--point',point,'--global-certificate',old+'global-four-trial.json','--global-replay',old+'global-four-trial-independent.json']),
        ('triples','verify_all_triple_distributions.py',['--point',point]),
        ('full-basis','verify_full_partner_basis_oracle.py',['--bank',r+'full-partner-orbit32.json']),
        ('first-full-cut','verify_full_partner_projection.py',['--certificate',r+'full-partner-projection-existing11T-necessary0.json','--point',r+'necessary0-rational.json.gz']),
        ('pair-pilot','verify_full_partner_pair_lagrange.py',['--bank',r+'pair-price-capped.json']),
        ('pair-template','verify_full_partner_pair_lagrange.py',['--bank',r+'full-partner-pair-template11-refrozen.json']),
        ('absent','verify_absent_anchor_rank_cuts.py',['--certificate',r+'absent-rank-witness2-seed-only.json','--point',point]),
        ('anchored','verify_anchored_full_partner_template.py',['--bank',r+'anchored-full-template-witness2.json.gz','--point',point]),
        ('full-phase','verify_full_phase_anchor_partner.py',['--bank',r+'full-phase-anchor-baseline.json.gz','--point',point]),
        ('full-phase-q','verify_full_phase_anchor_partner.py',['--bank',r+'full-phase-anchor-q-profile.json.gz','--point',point]),
        ('full-phase-ratio','verify_full_phase_anchor_ratio.py',['--bank',r+'full-phase-anchor-ratio.json','--support-replay',str(out/'full-phase.json'),'--point',point]),
    ]
    commands=[[sys.executable,'-u',script,*args,'--output',str(out/(name+'.json'))] for name,script,args in steps]
    frozen={'status':'FROZEN_BEFORE_CLEAN_COUPLING_REPLAY','commit':commit,
            'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'commands':commands,
            'controller_sha256':sha(Path(__file__)),'source_C16_answered':False,
            'scope':'New independently callable consumers. Unchanged inherited global physical/CNF source proof remains bound to its earlier immutable accepted replay.'}
    (out/'frozen.json').write_text(json.dumps(frozen,indent=2)+'\n')
    env=os.environ.copy();env.update({k:'1' for k in ['OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS']})
    records=[];start=time.monotonic()
    for (name,script,args),cmd in zip(steps,commands):
        t=time.monotonic()
        with (out/(name+'.log')).open('w') as log:
            try:code=subprocess.run(cmd,cwd=cwd,env=env,stdout=log,stderr=subprocess.STDOUT,timeout=240).returncode
            except subprocess.TimeoutExpired:code=None
        path=out/(name+'.json');receipt=json.loads(path.read_text()) if path.exists() else {}
        rec={'stage':name,'returncode':code,'status':receipt.get('status'),'seconds':time.monotonic()-t,
             'receipt_sha256':sha(path) if path.exists() else None};records.append(rec);print(rec,flush=True)
    clean=not subprocess.check_output(['git','status','--porcelain'],cwd=repo)
    passed=clean and all(r['returncode']==0 and r['status']=='PASS' for r in records)
    summary={'status':'PASS' if passed else 'REPLAY_FAILURES','source_C16_answered':False,'commit':commit,
             'worktree_clean_before_and_after':clean,'stages':records,'seconds':time.monotonic()-start,
             'frozen_sha256':sha(out/'frozen.json'),'point_sha256':sha(cwd/point)}
    (out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n');print(summary['status'],flush=True)
if __name__=='__main__':main()
