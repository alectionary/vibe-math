"""Finite production continuation through bounded runner invocations.
Stops at target or explicit operational limits; never inspects scientific effects.
"""
import argparse,json,pathlib,subprocess,sys,time,os,signal,hashlib
from production_runner import freeze_manifest,validate_identity

def main():
 p=argparse.ArgumentParser();p.add_argument('--namespace',default='production/chapter6-v1');p.add_argument('--hours',type=float,default=12);p.add_argument('--max-batches',type=int,default=110);p.add_argument('--batch-jobs',type=int,default=480);a=p.parse_args()
 if not 0<a.hours<=12 or not 1<=a.max_batches<=110 or not 1<=a.batch_jobs<=480:p.error('Bounds exceed declared maximum')
 ns=pathlib.Path(a.namespace);identity=json.load(open(ns/'identity.json'));validate_identity('.',identity)
 started=time.monotonic();deadline=started+a.hours*3600;sid=time.strftime('%Y%m%dT%H%M%SZ',time.gmtime());out=ns/'supervision'/sid;out.mkdir(parents=True);record={'start_utc':sid,'arguments':vars(a),'max_wall_seconds':a.hours*3600,'max_batches':a.max_batches,'identity':identity,'supervisor_sha256':hashlib.sha256(pathlib.Path(__file__).read_bytes()).hexdigest(),'stage_order':['audit baseline0-19 without adding unique datasets','new production20-999'],'stopping':'Fixed target/operational bounds only; no estimates or significance read','batches':[]};(out/'plan.json').write_text(json.dumps(record,indent=2)+'\n')
 reason='target reached'
 for n in range(a.max_batches):
  if a.hours*3600-(time.monotonic()-started)<1850:reason='fixed supervisor walltime reserve';break
  validate_identity('.',identity)
  # Status script is reporting only. The completed-range selector is outcome blind.
  done=set()
  failed=[]
  for f in (ns/'jobs').glob('*/checkpoint.json'):
   cp=json.load(open(f))
   if cp['identity']!=identity:raise ValueError('Checkpoint identity mismatch')
   if cp['state']=='completed':done.add(cp['job']['tag'])
   else:failed.append(str(f))
  if failed:reason='recorded process failure requires diagnosis';break
  from production_runner import jobs
  baseline=[j for j in jobs(0,20)if j['tag']not in done];new=[j for j in jobs(20,1000)if j['tag']not in done]
  if not baseline and not new:
   from production_runner import load_checkpoint
   for job in jobs(0,1000):
    if time.monotonic()>=deadline:raise TimeoutError('Final target audit deadline exceeded')
    cp=load_checkpoint(ns/'jobs'/job['tag'],job,identity)
    if not cp or cp['state']!='completed':raise ValueError('Final target audit failed')
   subprocess.run([sys.executable,'simulation/production_status.py','--namespace',str(ns),'--export'],stdout=subprocess.DEVNULL,check=True,timeout=min(600,max(1,deadline-time.monotonic())))
   break
  lo,hi=(0,20)if baseline else(20,1000)
  cmd=[sys.executable,'simulation/production_runner.py','--namespace',str(ns),'--start-replicate',str(lo),'--end-replicate',str(hi),'--max-jobs',str(a.batch_jobs),'--workers','4','--chunk-size','12','--wall-seconds','1800']
  t=time.monotonic()
  with open(out/f'batch-{n:03d}.log','w')as f:
   proc=subprocess.Popen(cmd,stdout=f,stderr=subprocess.STDOUT,start_new_session=True)
   try:rc=proc.wait(timeout=1830)
   except subprocess.TimeoutExpired:
    try:os.killpg(proc.pid,signal.SIGTERM)
    except ProcessLookupError:pass
    try:proc.wait(timeout=10)
    except subprocess.TimeoutExpired:pass
    # The leader may exit before descendants; always kill the remaining group.
    try:os.killpg(proc.pid,signal.SIGKILL)
    except ProcessLookupError:pass
    proc.wait();rc=-999
  item={'batch':n,'replicate_range':[lo,hi],'command':cmd,'elapsed_seconds':time.monotonic()-t,'returncode':rc};record['batches'].append(item);(out/'progress.json').write_text(json.dumps(record,indent=2)+'\n');print(json.dumps(item),flush=True)
  if rc!=0:reason='batch process failure';break
  subprocess.run([sys.executable,'simulation/production_status.py','--namespace',str(ns)],stdout=subprocess.DEVNULL,check=True,timeout=min(600,max(1,deadline-time.monotonic())))
 else:reason='fixed batch count'
 record.update(stop_reason=reason,elapsed_seconds=time.monotonic()-started,end_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()));(out/'summary.json').write_text(json.dumps(record,indent=2)+'\n');print(json.dumps({'stop_reason':reason,'elapsed_seconds':record['elapsed_seconds'],'batches':len(record['batches'])}),flush=True)
if __name__=='__main__':main()
