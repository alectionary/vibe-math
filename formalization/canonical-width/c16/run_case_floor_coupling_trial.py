#!/usr/bin/env python3
"""Freeze and run one selected-pair-conditioned necessary numerical pilot."""
from pathlib import Path
import argparse,datetime,hashlib,json,os,subprocess,sys,time
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--case',nargs=3,type=int,required=True)
    ap.add_argument('--name',required=True);a=ap.parse_args()
    basepath=ROOT/'coupling-results/multi-witness8-frozen.json';base=json.loads(basepath.read_text())
    summary_path=ROOT/'coupling-results/multi-witness8-checks-summary.json';summary=json.loads(summary_path.read_text())
    assert all(stage['status']=='PASS' and stage['returncode']==0 for stage in summary['stages'])
    assert all(sha(ROOT/p)==s for p,s in base['input_and_source_hashes'].items())
    folder=ROOT/'coupling-results';output=folder/(a.name+'.json');frozen=folder/(a.name+'-frozen.json')
    assert not output.exists() and not frozen.exists()
    bridge=folder/'cover-case-moment-bridge-witness8.json';proof=json.loads(bridge.read_text())
    condition=next(r for r in proof['records'] if r['case']==a.case)
    # Preserve every original family/list option, replacing only the solver
    # scalar settings, warm seed, output, and the one required case floor.
    scalar={'--psd-interior-epsilon':'0','--boolean-margin':'0','--projected-margin':'0',
        '--seconds':'120','--warm-point':'coupling-results/multi-witness8.npz',
        '--output':str(output.relative_to(ROOT))}
    command=[];old=base['command'];i=0
    while i<len(old):
        if old[i] in scalar:i+=2
        else:command.append(old[i]);i+=1
    command[command.index('unified_multi_orbit_coupling_model.py')]='case_floor_coupling_model.py'
    for flag,value in scalar.items():command.extend([flag,value])
    command.extend(['--case',*map(str,a.case),'--case-bridge',str(bridge.relative_to(ROOT))])
    sources=dict(base['input_and_source_hashes'])
    for p in ['case_floor_coupling_model.py','run_case_floor_coupling_trial.py','cover_case_moment_bridge.py',
        str(basepath.relative_to(ROOT)),str(summary_path.relative_to(ROOT)),str(bridge.relative_to(ROOT)),
        'coupling-results/multi-witness8.npz','coupling-results/multi-witness8-rational.json.gz']:
        sources[p]=sha(ROOT/p)
    frozen.write_text(json.dumps({'status':'FROZEN_CASE_CONDITIONED_NECESSARY_PILOT','source_C16_answered':False,
        'source_anchor_excluded':False,'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
        'command':command,'input_and_source_hashes':sources,'case_condition':condition,
        'effective_margins':{k:0 for k in ('psd','boolean','projected')},'solver_seconds':120,'outer_seconds':240,
        'scope':'One selected cover-pair floor added to a copy of the latest necessary model. Numerical outcome alone proves neither conditioned feasibility nor source exclusion.'},indent=2)+'\n')
    env=os.environ.copy();env.update({k:'1' for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','VECLIB_MAXIMUM_THREADS','MKL_NUM_THREADS')})
    started=time.monotonic()
    with (folder/(a.name+'.log')).open('w') as log:
        try:
            result=subprocess.run(command,cwd=ROOT,env=env,stdout=log,stderr=subprocess.STDOUT,timeout=240)
            exit_status={'returncode':result.returncode,'outer_timeout':False}
        except subprocess.TimeoutExpired:exit_status={'returncode':None,'outer_timeout':True}
    exit_status.update(status='NUMERICAL_CASE_PILOT_ONLY',source_C16_answered=False,source_anchor_excluded=False,
        elapsed_seconds=time.monotonic()-started,frozen_sha256=sha(frozen),
        sources_unchanged={p:sha(ROOT/p)==s for p,s in sources.items()})
    (folder/(a.name+'-exit.json')).write_text(json.dumps(exit_status,indent=2)+'\n')
    print(json.dumps({k:v for k,v in exit_status.items() if k!='sources_unchanged'},indent=2))


if __name__=='__main__':main()
