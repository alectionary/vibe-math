"""Compile named modules using the existing pinned mathlib project; preserve logs."""
from pathlib import Path
import argparse,datetime,hashlib,json,os,re,subprocess,time
R=Path(__file__).resolve().parent
P=R.parent/'dyadic-rank'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
if __name__=='__main__':
 ap=argparse.ArgumentParser();ap.add_argument('modules',nargs='+');ap.add_argument('--timeout',type=int,default=1800);a=ap.parse_args()
 cache=R/'.lean-runtime.json'
 if cache.exists():
  runtime=json.loads(cache.read_text());paths=runtime['LEAN_PATH'];lean=runtime['lean']
 else:
  paths=subprocess.check_output(['lake','env','printenv','LEAN_PATH'],cwd=P,text=True).strip()
  lean=subprocess.check_output(['lake','env','which','lean'],cwd=P,text=True).strip()
  cache.write_text(json.dumps({'lean':lean,'LEAN_PATH':paths},indent=2)+'\n')
 env=dict(os.environ,LEAN_PATH=str(R)+':'+paths)
 (R/'logs').mkdir(exist_ok=True)
 for mod in a.modules:
  src=R/(mod+'.lean');start=time.monotonic();log=R/'logs'/(mod+'.log')
  with log.open('w') as f:
   process=subprocess.Popen([lean,'-M','6000','-o',str(R/(mod+'.olean')),str(src)],cwd=R,env=env,stdout=f,stderr=subprocess.STDOUT)
   (R/'logs'/(mod+'.pid')).write_text(str(process.pid)+'\n')
   try:process.wait(timeout=a.timeout)
   except BaseException:
    process.terminate()
    try:process.wait(timeout=5)
    except subprocess.TimeoutExpired:process.kill();process.wait()
    raise
   res=process
  body=log.read_text();bad=('sorryAx' in body or '._native.' in body or 'error:' in body)
  record={'module':mod,'source_sha256':sha(src),'exit_code':res.returncode,'seconds':time.monotonic()-start,'finished_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'unexpected_axiom_or_error':bad,'log_sha256':sha(log)}
  (R/'logs'/(mod+'.json')).write_text(json.dumps(record,indent=2)+'\n')
  print(json.dumps(record),flush=True)
  if res.returncode or bad:print(body[-5000:]);raise SystemExit(1)
