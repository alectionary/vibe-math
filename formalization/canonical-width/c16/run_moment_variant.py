#!/usr/bin/env python3
"""Freeze a distinct bounded variant of an already frozen moment experiment."""
from pathlib import Path
import argparse,datetime,hashlib,json,os,resource,subprocess,sys,time
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--parent',type=Path,required=True);ap.add_argument('--model',required=True);ap.add_argument('--name',required=True);ap.add_argument('--seconds',type=float,required=True);ap.add_argument('--outer-seconds',type=float,required=True);ap.add_argument('--scope',required=True);ap.add_argument('--extra',nargs=argparse.REMAINDER,default=[]);a=ap.parse_args();out=ROOT/'moment-resumption-results';target=out/(a.name+'.json');frozen=out/(a.name+'-frozen.json');assert not target.exists() and not frozen.exists()
 parent=json.loads(a.parent.read_text());cmd=parent['command'].copy();cmd[0]=sys.executable
 if cmd[1]=='-u':cmd[2]=a.model
 else:cmd[1]=a.model;cmd.insert(1,'-u')
 cmd[cmd.index('--seconds')+1]=str(a.seconds);cmd[cmd.index('--output')+1]=str(target.relative_to(ROOT));cmd+=a.extra
 paths=[a.model,Path(__file__).name,'canonical_forbidden_moment_matrix.py','physical_owner_moment_matrix.py','physical_circuit_moment_matrix.py','physical_legacy_linear_moments.py','moment-resumption-results/physical-rank-moment-bank.json']+[x for x in cmd if x.endswith(('.json','.gz')) and x!=str(target.relative_to(ROOT))]
 env=os.environ.copy();limits={k:'1' for k in ['OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','VECLIB_MAXIMUM_THREADS','MKL_NUM_THREADS']};env.update(limits)
 f={'status':'FROZEN_BEFORE_MOMENT_VARIANT','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'command':cmd,'parent_frozen_sha256':sha(a.parent),'seconds':a.seconds,'outer_seconds':a.outer_seconds,'input_and_source_hashes':{p:sha(ROOT/p) for p in dict.fromkeys(paths)},'scope':a.scope,'source_C16_answered':False,'environment_thread_limits':limits};frozen.write_text(json.dumps(f,indent=2)+'\n');start=time.monotonic();log=out/(a.name+'.log')
 with log.open('w') as stream:
  try:r=subprocess.run(cmd,cwd=ROOT,env=env,stdout=stream,stderr=subprocess.STDOUT,timeout=a.outer_seconds);status={'returncode':r.returncode,'outer_timeout':False}
  except subprocess.TimeoutExpired:status={'returncode':None,'outer_timeout':True}
 status.update(elapsed_seconds=time.monotonic()-start,peak_child_rss_bytes=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss,frozen_sha256=sha(frozen),log_sha256=sha(log),finished_utc=datetime.datetime.now(datetime.timezone.utc).isoformat());exitpath=out/(a.name+'-exit.json');exitpath.write_text(json.dumps(status,indent=2)+'\n')
 if target.exists():
  d=json.loads(target.read_text())
  if d.get('status')=='RUNNING':d.update(status='UNKNOWN_OUTER_WALL_LIMIT' if status['outer_timeout'] else 'FAILED_BEFORE_TERMINAL_RESULT',original_status='RUNNING',source_C16_answered=False,exit_record_sha256=sha(exitpath));target.write_text(json.dumps(d,indent=2)+'\n')
 print(status,flush=True)
if __name__=='__main__':main()
