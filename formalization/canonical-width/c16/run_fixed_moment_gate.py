#!/usr/bin/env python3
"""Freeze a bounded fixed-positive-margin search, after a rejected boundary point."""
from pathlib import Path
import argparse,datetime,hashlib,json,os,resource,subprocess,sys,time
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--margin',type=float,default=1e-6);ap.add_argument('--seconds',type=float,default=300);ap.add_argument('--name',required=True);a=ap.parse_args();out=ROOT/'moment-resumption-results';frozen=out/(a.name+'-frozen.json');assert not frozen.exists()
    old=out/'necessary-all-patterns-frozen.json';f=json.loads(old.read_text());cmd=f['command'].copy();cmd[0]=sys.executable;cmd[1]='moment_pattern_fixed_model.py';cmd[cmd.index('--seconds')+1]=str(a.seconds);cmd[cmd.index('--eps')+1]='1e-9';cmd[cmd.index('--output')+1]=f'moment-resumption-results/{a.name}.json';cmd+=['--certificate-margin','--fixed-margin',str(a.margin)]
    f.update(status='FROZEN_FIXED_MARGIN_WITNESS_SEARCH',utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),mode='fixed_margin_sufficient_only',command=cmd,seconds=a.seconds,outer_limit_seconds=a.seconds+120,parent_frozen_sha256=sha(old),margin=a.margin)
    f['scope']='Sufficient feasible-point search with positive margin on the prior interior constraints and all four pair zero faces preserved. Failure or infeasibility does not exclude source frames. All forbidden-pattern rows are retained without demanding positive slack on forced equalities.'
    f['input_and_source_hashes'].update({p:sha(ROOT/p) for p in ['moment_pattern_fixed_model.py','run_fixed_moment_gate.py']});frozen.write_text(json.dumps(f,indent=2)+'\n');env=os.environ.copy();env.update(f['environment_thread_limits']);start=time.monotonic();log=out/(a.name+'.log')
    with log.open('w') as stream:
        try:p=subprocess.run(cmd,cwd=ROOT,env=env,stdout=stream,stderr=subprocess.STDOUT,timeout=a.seconds+120);result={'returncode':p.returncode,'outer_timeout':False}
        except subprocess.TimeoutExpired:result={'returncode':None,'outer_timeout':True}
    result.update(elapsed_seconds=time.monotonic()-start,peak_child_rss_bytes=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss,frozen_sha256=sha(frozen),log_sha256=sha(log),finished_utc=datetime.datetime.now(datetime.timezone.utc).isoformat())
    (out/(a.name+'-exit.json')).write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
