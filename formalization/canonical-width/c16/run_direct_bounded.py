#!/usr/bin/env python3
"""Bound one known direct child; no process-tree enumeration or global PID access."""
import argparse,datetime,json,os,subprocess,time
from pathlib import Path
import psutil

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--seconds',type=float,required=True);ap.add_argument('--memory-mib',type=float,required=True);ap.add_argument('--deadline',default='2026-10-29T02:10:04+00:00');ap.add_argument('--log',type=Path,required=True);ap.add_argument('--receipt',type=Path,required=True);ap.add_argument('--trace-prefix',type=Path);ap.add_argument('--trace-limit-bytes',type=int,default=0);ap.add_argument('command',nargs=argparse.REMAINDER);a=ap.parse_args();cmd=a.command[1:] if a.command[:1]==['--'] else a.command;start=time.monotonic();now=datetime.datetime.now(datetime.timezone.utc);allow=min(a.seconds,(datetime.datetime.fromisoformat(a.deadline)-now).total_seconds());assert allow>0
 d={'status':'STARTING','command':cmd,'started_utc':now.isoformat(),'wall_limit_seconds':allow,'memory_limit_MiB':a.memory_mib,'monitoring':'Direct known child RSS only; command must not spawn unreported grandchildren','peak_child_RSS_MiB':0};a.log.parent.mkdir(exist_ok=True,parents=True)
 with a.log.open('w') as out:
  p=subprocess.Popen(cmd,stdout=out,stderr=subprocess.STDOUT,env=dict(os.environ,OMP_NUM_THREADS='1',OPENBLAS_NUM_THREADS='1'));d['child_pid']=p.pid;d['status']='RUNNING';last=0;reason=None
  while p.poll() is None:
   elapsed=time.monotonic()-start
   if elapsed>=allow:reason='WALL_LIMIT';break
   try:rss=psutil.Process(p.pid).memory_info().rss/1048576;d['peak_child_RSS_MiB']=max(d['peak_child_RSS_MiB'],rss)
   except psutil.NoSuchProcess:break
   except Exception as err:reason='MEMORY_MONITOR_FAILURE';d['monitoring_error']=repr(err);break
   if rss>a.memory_mib:reason='RSS_LIMIT';break
   if a.trace_prefix and a.trace_limit_bytes:
    total=sum(p.stat().st_size for p in a.trace_prefix.parent.glob(a.trace_prefix.name+'*') if p.is_file());d['trace_bytes_seen']=total
    if total>a.trace_limit_bytes:reason='TRACE_LIMIT';break
   if elapsed-last>=15:d['elapsed_seconds']=elapsed;a.receipt.write_text(json.dumps(d,indent=2)+'\n');last=elapsed
   try:p.wait(timeout=.5)
   except subprocess.TimeoutExpired:pass
  if reason:
   p.terminate()
   try:p.wait(timeout=5)
   except subprocess.TimeoutExpired:p.kill();p.wait(timeout=5)
   d.update(status=reason,termination_confirmed=True)
  else:d['status']='EXITED'
  d.update(returncode=p.wait(),elapsed_seconds=time.monotonic()-start,finished_utc=datetime.datetime.now(datetime.timezone.utc).isoformat());a.receipt.write_text(json.dumps(d,indent=2)+'\n');print(json.dumps(d),flush=True)
if __name__=='__main__':main()
