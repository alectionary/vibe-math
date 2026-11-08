#!/usr/bin/env python3
"""Freeze and execute one bounded necessary or strict-witness moment pilot."""
from pathlib import Path
import argparse,datetime,hashlib,json,os,resource,subprocess,sys,time
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--mode',choices=['necessary','strict'],required=True);ap.add_argument('--seconds',type=float,default=600);ap.add_argument('--name',required=True);a=ap.parse_args();out=ROOT/'moment-resumption-results';target=out/(a.name+'.json');frozen=out/(a.name+'-frozen.json');assert not target.exists() and not frozen.exists()
    f=json.loads((ROOT/'transfer-results/moment-pair-corrected-frozen.json').read_text());cmd=f['command'].copy();cmd[0]=sys.executable;cmd[1]='moment_pattern_model.py'
    cmd[cmd.index('--conditional-linear-cuts')+2]='moment-resumption-results/all-pair-moment-faces.json';cmd[cmd.index('--seconds')+1]=str(a.seconds);cmd[cmd.index('--output')+1]=str(target.relative_to(ROOT))
    if a.mode=='necessary':cmd.remove('--certificate-margin')
    cmd+=['--forbidden-patterns','relevant-results/seed-cuts.json','moment-resumption-results/all-pair-word-cuts.json']
    paths=['moment_pattern_model.py','canonical_forbidden_moment_matrix.py','run_resumed_moment_gate.py','moment-resumption-results/preparation.json']+[x for x in cmd if x.endswith(('.json','.gz')) and x!=str(target.relative_to(ROOT))]
    env=os.environ.copy();limits={k:'1' for k in ['OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','VECLIB_MAXIMUM_THREADS','MKL_NUM_THREADS']};env.update(limits)
    contract={'status':'FROZEN_BEFORE_PILOT','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_C16_answered':False,'mode':a.mode,'command':cmd,'seconds':a.seconds,'outer_limit_seconds':a.seconds+120,'environment_thread_limits':limits,'input_and_source_hashes':{p:sha(ROOT/p) for p in dict.fromkeys(paths)},'scope':'All four checked pair classes, old rank-profile/capacity/weighted rows, and all distinct conditioned forbidden-pattern inequalities. A necessary-model numerical status is unproved until exact replay; strict-margin infeasibility would not imply necessary-model infeasibility.'}
    frozen.write_text(json.dumps(contract,indent=2)+'\n');start=time.monotonic();log=out/(a.name+'.log')
    with log.open('w') as stream:
        try:r=subprocess.run(cmd,cwd=ROOT,env=env,stdout=stream,stderr=subprocess.STDOUT,timeout=a.seconds+120);status={'returncode':r.returncode,'outer_timeout':False}
        except subprocess.TimeoutExpired:status={'returncode':None,'outer_timeout':True}
    usage=resource.getrusage(resource.RUSAGE_CHILDREN);status.update(elapsed_seconds=time.monotonic()-start,peak_child_rss_bytes=usage.ru_maxrss,frozen_sha256=sha(frozen),log_sha256=sha(log),finished_utc=datetime.datetime.now(datetime.timezone.utc).isoformat())
    (out/(a.name+'-exit.json')).write_text(json.dumps(status,indent=2)+'\n');print(status,flush=True)
if __name__=='__main__':main()
