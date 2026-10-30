#!/usr/bin/env python3
"""Freeze and run a bounded coupled-moment trial, preserving failures."""
from pathlib import Path
import argparse,datetime,hashlib,json,os,subprocess,sys,time
ROOT=Path(__file__).resolve().parent

def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--name',required=True)
    ap.add_argument('--seconds',type=float,default=180)
    ap.add_argument('--outer-seconds',type=float,default=300)
    ap.add_argument('--witness-margin',type=float,default=0)
    ap.add_argument('--extra',nargs=argparse.REMAINDER,default=[])
    a=ap.parse_args();folder=ROOT/'coupling-results';folder.mkdir(exist_ok=True)
    output=folder/(a.name+'.json');frozen=folder/(a.name+'-frozen.json')
    assert not output.exists() and not frozen.exists()
    old='moment-resumption-results/'
    cmd=[sys.executable,'-u','unified_coupling_moment_model.py',
         '--hulls','algebraic-results/hulls-16-rank.json.gz',
         '--capacity-cuts','algebraic-results/orbit-rank-profiles-independent.json',
         '--conditional-matrix','algebraic-results/conditional-capacity/independent.json',
         '--conditional-cross-matrix','algebraic-results/conditional-cross-capacity/independent.json',
         '--conditional-linear-cuts','algebraic-results/conditional-facets-round1-independent.json',old+'all-pair-moment-faces.json',
         '--forbidden-patterns','relevant-results/seed-cuts.json',old+'all-pair-word-cuts.json',
         '--active-cuts',old+'boolean-active1.json',
         '--matroid-cuts',old+'closed-rank-bank-augmented.json',old+'final-point-rank-probe.json',
         '--matroid-replays',old+'closed-rank-bank-augmented-independent.json',old+'final-point-rank-probe-independent.json',
         '--boolean-cuts',old+'consolidated-all-triples.json',old+'boolean-all-triples0.json',
         '--projected-cuts',old+'common-profile32-projected-pruned.json',
         '--projected-replays',old+'common-profile32-projected-pruned-independent.json',
         '--warm-point',old+'boolean-interior1.npz','--eps','1e-11','--iterations','100000',
         '--seconds',str(a.seconds),'--psd-interior-epsilon',str(a.witness_margin),
         '--boolean-margin',str(a.witness_margin/10),'--projected-margin',str(a.witness_margin/10),
         '--output',str(output.relative_to(ROOT)),*a.extra]
    modules=['unified_coupling_moment_model.py','run_coupling_trial.py',
             'canonical_forbidden_moment_matrix.py','physical_owner_moment_matrix.py',
             'physical_circuit_moment_matrix.py','physical_legacy_linear_moments.py',
             'conditional_matroid_moment_matrix.py','complete_boolean_triples.py',
             'projected_profile_moment_matrix.py','verify_algebraic_model.py',
             'pools/xcoords.txt','pools/zcoords.txt',old+'physical-rank-moment-bank.json']
    paths=modules+[x for x in cmd if x.endswith(('.json','.gz','.npz')) and x!=str(output.relative_to(ROOT))]
    hashes={p:sha(ROOT/p) for p in dict.fromkeys(paths)}
    limits={k:'1' for k in ['OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','VECLIB_MAXIMUM_THREADS','MKL_NUM_THREADS']}
    frozen.write_text(json.dumps({'status':'FROZEN_BEFORE_COUPLING_TRIAL','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
                     'command':cmd,'input_and_source_hashes':hashes,'thread_limits':limits,'outer_seconds':a.outer_seconds,
                     'source_C16_answered':False,'mode':'necessary_numeric' if a.witness_margin==0 else 'sufficient_witness_search',
                     'concurrent_context':'Other independent research/verification tasks may run; wall times are not matched speedup evidence.'},indent=2)+'\n')
    env=os.environ.copy();env.update(limits);start=time.monotonic()
    with (folder/(a.name+'.log')).open('w') as log:
        try:
            process=subprocess.run(cmd,cwd=ROOT,env=env,stdout=log,stderr=subprocess.STDOUT,timeout=a.outer_seconds)
            result={'returncode':process.returncode,'outer_timeout':False}
        except subprocess.TimeoutExpired:result={'returncode':None,'outer_timeout':True}
    result.update(elapsed_seconds=time.monotonic()-start,finished_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                  frozen_sha256=sha(frozen),sources_unchanged={p:sha(ROOT/p)==digest for p,digest in hashes.items()})
    (folder/(a.name+'-exit.json')).write_text(json.dumps(result,indent=2)+'\n')
    if output.exists():
        report=json.loads(output.read_text())
        if report.get('status')=='RUNNING':
            report['status']='UNKNOWN_OUTER_LIMIT' if result['outer_timeout'] else 'FAILED_BEFORE_RESULT'
            output.write_text(json.dumps(report,indent=2)+'\n')
    print({k:v for k,v in result.items() if k!='sources_unchanged'},flush=True)
    assert all(result['sources_unchanged'].values()),'A frozen dependency changed during the trial'

if __name__=='__main__':main()
