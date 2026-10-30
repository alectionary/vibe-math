"""Monitor an existing bounded supervisor and periodically save authorized branch artifacts.
No model starts, PR operations or scientific stopping decisions. Stops when supervisor exits.
"""
import argparse,concurrent.futures,fcntl,hashlib,json,os,pathlib,subprocess,sys,time,urllib.request
p=argparse.ArgumentParser();p.add_argument('--pid',type=int,required=True);p.add_argument('--namespace',default='production/chapter6-v1');p.add_argument('--publish-every-runs',type=int,default=4);a=p.parse_args()
ns=pathlib.Path(a.namespace);root=pathlib.Path('.').resolve();prefix='formalization/schwabe-psychometric-genetics/';branch='replication/slot3-latent-20261030';last_published=-1;publication_failed=False;started=time.monotonic();auditpath=pathlib.Path('provenance/production-publications.json');audits=json.load(open(auditpath))if auditpath.exists()else[]
def git(*args):return subprocess.check_output(['git',*args],text=True).strip()
def alive():
 try:os.kill(a.pid,0);return True
 except ProcessLookupError:return False

def publish():
 global audits
 with open(ns/'publication.lock','a')as lock:
  fcntl.flock(lock,fcntl.LOCK_EX)
  if git('branch','--show-current')!=branch:raise RuntimeError('Branch changed; stop publication')
  if git('diff','--cached','--name-only'):raise RuntimeError('Existing staged work; stop rather than mix commits')
  subprocess.run([sys.executable,'simulation/save_production_checkpoint.py','--namespace',str(ns)],check=True,stdout=subprocess.DEVNULL)
  paths=['.gitignore','simulation/save_production_checkpoint.py','simulation/watch_production.py','provenance/baseline-full-guard-audit.json',str(ns/'archives'),str(ns/'archive-index.json'),str(ns/'reports')]
  if auditpath.exists():paths.append(str(auditpath))
  for pattern in ['*/plan.json','*/progress.json','*/summary.json']:paths.extend(str(x)for x in (ns/'supervision').glob(pattern))
  git('add','--',*[p for p in paths if pathlib.Path(p).exists()]);changed=git('diff','--cached','--name-only').splitlines()
  if not changed:return
  if any(not p.startswith(prefix)for p in changed):raise RuntimeError('Unexpected staged path')
  git('diff','--cached','--check');git('commit','-m','Checkpoint guarded Schwabe production and retained run evidence');rev=git('rev-parse','HEAD')
  subprocess.run(['git','push','origin',branch],check=True,stdout=subprocess.DEVNULL,stderr=subprocess.PIPE)
  if git('ls-remote','origin','refs/heads/'+branch).split()[0]!=rev:raise RuntimeError('Remote head mismatch')
  def verify(path):
   b=urllib.request.urlopen(f'https://raw.githubusercontent.com/alectionary/vibe-math/{rev}/{path}',timeout=60).read();local=subprocess.check_output(['git','show',rev+':'+path]);assert b==local,path
   return {'path':path,'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
  with concurrent.futures.ThreadPoolExecutor(max_workers=4)as pool:verified=list(pool.map(verify,changed))
  record={'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'revision':rev,'verified':verified,'scope':'Changed scoped artifacts downloaded and compared to immutable Git blobs; source fits continue separately.'};audits.append(record);auditpath.write_text(json.dumps(audits,indent=2)+'\n')
  print(json.dumps({'publication':rev,'verified_files':len(verified)}),flush=True)

while True:
 running=alive();runs=len(list((ns/'runs').glob('*/summary.json')))
 if not publication_failed and (last_published<0 or runs-last_published>=a.publish_every_runs or not running):
  try:publish();last_published=runs
  except Exception as e:
   publication_failed=True;print(json.dumps({'publication_stopped':str(e),'retry':'No automatic retry; inspect actual outcome before further action.','supervisor_still_monitored':running}),flush=True)
 checkpoints=list((ns/'jobs').glob('*/checkpoint.json'));new=base=invalid=failed=0
 for path in checkpoints:
  r=json.load(open(path))
  if r['state']=='completed':
   if r['job']['baseline_replay']:base+=2
   else:new+=2
   invalid+=sum(not m['valid']for m in r['outputs']['methods'].values())
  else:failed+=1
 print(json.dumps({'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'supervisor_running':running,'completed_runs':runs,'new_method_fits':new,'baseline_guard_refits':base,'guard_invalid':invalid,'process_failed_datasets':failed,'publication_failure':publication_failed}),flush=True)
 if not running:break
 # Short sleeps permit signal handling; no new scientific work is launched here.
 for _ in range(6):
  time.sleep(10)
  if not alive():break
