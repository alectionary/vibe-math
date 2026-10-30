"""Bounded Chapter6 continuation; immutable identity and checked per-dataset receipts.
Never infer valid fits from process success. No scientific outcome controls dispatch.
"""
import argparse,concurrent.futures,csv,fcntl,hashlib,json,math,os,pathlib,subprocess,time,uuid
FILES=['simulation/openmx_production.R','simulation/production_guards.R','simulation/production_batch.R','simulation/production_runner.py','production/protocol.json','provenance/runtime-packages.json']
def hash_file(path):return hashlib.sha256(pathlib.Path(path).read_bytes()).hexdigest()
def freeze_manifest(root):
 root=pathlib.Path(root)
 return {'schema':1,'files':{p:hash_file(root/p)for p in FILES},'Rscript':os.environ.get('RSCRIPT','/workspace/slot3-runtime/bin/Rscript'),'Rscript_sha256':hash_file(os.environ.get('RSCRIPT','/workspace/slot3-runtime/bin/Rscript')),'environment':{'OPENMX_OPTIMIZER':'SLSQP','MEAN_MODE':'','OMP_NUM_THREADS':'1','OPENBLAS_NUM_THREADS':'1','MKL_NUM_THREADS':'1','VECLIB_MAXIMUM_THREADS':'1','NUMEXPR_NUM_THREADS':'1','SAVE_DIAGNOSTICS':'0'}}
def validate_identity(root,record):
 if freeze_manifest(root)!=record:raise ValueError('Frozen code/protocol/runtime identity mismatch; no dispatch or resume allowed')
def atomic_json(path,obj):
 path=pathlib.Path(path);tmp=path.with_suffix(path.suffix+'.tmp');tmp.write_text(json.dumps(obj,indent=2,allow_nan=False)+'\n');tmp.replace(path)
def jobs(start,end):
 for rep in range(start,end):
  for mi,mech in enumerate(['MCAR','MAR','MNAR']):
   for q in [2,3,4,5]:
    for xi,missing in enumerate([.02,.03,.06,.1]):
     seed=34000+rep*48+mi*16+(q-2)*4+xi;tag=f'production-c6-{mech}-q{q}-m{missing}-r{rep}'
     yield dict(tag=tag,replicate=rep,q=q,missing=missing,mechanism=mech,seed=seed,N=1000,beta_shape='equal',baseline_replay=rep<20)
def truth(s):return str(s).lower()in ('true','1')
def validate_outputs(jobdir,job):
 jobdir=pathlib.Path(jobdir);receipt=jobdir/'completed.csv'
 if not receipt.exists():raise ValueError('Missing completion receipt')
 rr=list(csv.DictReader(open(receipt)))
 if len(rr)!=1 or rr[0]['tag']!=job['tag']:raise ValueError('Invalid completion receipt')
 result={'methods':{},'files':{receipt.name:hash_file(receipt)},'process_error':rr[0].get('error',''),'elapsed_seconds':float(rr[0]['elapsed_seconds'])}
 if not math.isfinite(result['elapsed_seconds']) or result['elapsed_seconds']<0:raise ValueError('Invalid elapsed time')
 for method in ['full','deletion']:
  p=jobdir/(job['tag']+'-'+method+'.csv')
  if not p.exists():raise ValueError('Missing method output '+method)
  rows=list(csv.DictReader(open(p)));expected=['A','C','E','h2']+['beta'+str(k)for k in range(1,job['q']+1)]
  if len(rows)!=len(expected) or set(r['parameter']for r in rows)!=set(expected):raise ValueError('Incomplete/duplicate parameter rows '+method)
  flags=[]
  for r in rows:
   for k in ['q','seed','N']:
    if int(r[k])!=job[k]:raise ValueError('Wrong '+k)
   if float(r['missing'])!=job['missing'] or r['mechanism']!=job['mechanism'] or r['method']!=method:raise ValueError('Wrong condition/method')
   if str(r['valid']).lower()not in ('true','false','1','0'):raise ValueError('Invalid validity flag')
   ok=truth(r['valid']);flags.append(ok)
   if r.get('guard_version','1.0')!='1.0':raise ValueError('Unknown guard version')
   if ok:
    if int(r['status'])!=0 or any(not math.isfinite(float(r[k]))for k in ['estimate','se','minus2loglik','delta_variance','gradient_max_abs','hessian_covariance_inverse_residual']) or float(r['se'])<=0 or r['invalid_reasons']:raise ValueError('Contradictory valid output')
    delta=float(r['delta_variance'])
    if delta<0 or not math.isclose(float(r['se'])**2,delta,rel_tol=1e-10,abs_tol=1e-14):raise ValueError('Invalid delta variance or SE relationship')
    if r.get('guard_version')!='1.0' or not truth(r.get('parameter_alignment_valid')):raise ValueError('Missing guard version/alignment')
    if float(r['hessian_covariance_inverse_residual'])>1e-4:raise ValueError('Hessian-covariance mismatch')
    for prefix in ['hessian','covariance','expected_MZ','expected_DZ']:
     if not truth(r.get(prefix+'_finite_square')):raise ValueError('Invalid '+prefix)
     vals={k:float(r[prefix+'_'+k])for k in ['relative_asymmetry','scaled_relative_asymmetry','scaled_min_eigenvalue','scaled_condition']}
     if any(not math.isfinite(v)for v in vals.values()) or vals['relative_asymmetry']>1e-8 or vals['scaled_relative_asymmetry']>1e-8 or vals['scaled_min_eigenvalue']<=1e-10 or not 1<=vals['scaled_condition']<1e10:raise ValueError('Invalid matrix diagnostics '+prefix)
  if len(set(flags))!=1:raise ValueError('Inconsistent fit-level validity')
  result['methods'][method]={'valid':flags[0],'invalid_reasons':rows[0]['invalid_reasons'],'parameter_rows':len(rows),'status':rows[0]['status']}
  result['files'][p.name]=hash_file(p)
 # Include retained diagnostics in identity, including all invalid-fit evidence.
 for p in jobdir.glob('*.rds'):result['files'][p.name]=hash_file(p)
 return result

def load_checkpoint(jobdir,job,identity):
 path=pathlib.Path(jobdir)/'checkpoint.json'
 if not path.exists():return None
 r=json.load(open(path))
 if r['job']!=job or r['identity']!=identity:raise ValueError('Checkpoint identity mismatch')
 if r.get('state')not in ['completed','process_failed_or_interrupted']:raise ValueError('Unknown checkpoint state')
 for name,digest in r.get('outputs',{}).get('files',{}).items():
  if hash_file(path.parent/name)!=digest:raise ValueError('Checkpoint output hash mismatch')
 if r['state']=='completed':
  actual=validate_outputs(path.parent,job)
  if actual!=r['outputs']:raise ValueError('Checkpoint parsed-output mismatch')
 return r

def memory_fraction():
 try:return int(pathlib.Path('/sys/fs/cgroup/memory.current').read_text())/int(pathlib.Path('/sys/fs/cgroup/memory.max').read_text())
 except (OSError,ValueError):return 0

def cpu_limit():
 try:
  quota,period=pathlib.Path('/sys/fs/cgroup/cpu.max').read_text().split();return min(os.cpu_count()or 1,int(quota)//int(period))if quota!='max'else(os.cpu_count()or 1)
 except (OSError,ValueError):return 1

def main():
 p=argparse.ArgumentParser();p.add_argument('--namespace',required=True);p.add_argument('--start-replicate',type=int,default=20);p.add_argument('--end-replicate',type=int,default=1000);p.add_argument('--max-jobs',type=int,default=480);p.add_argument('--wall-seconds',type=int,default=1800);p.add_argument('--workers',type=int,default=4);p.add_argument('--chunk-size',type=int,default=12);p.add_argument('--dry-run',action='store_true');a=p.parse_args()
 if not 0<=a.start_replicate<a.end_replicate<=1000:p.error('Replicate range outside target')
 if not 1<=a.workers<=min(4,cpu_limit()):p.error('Workers exceed CPU quota/protocol')
 if not 1<=a.wall_seconds<=1800 or not 1<=a.chunk_size<=48 or a.max_jobs<1:p.error('Invalid bounded run parameters')
 root=pathlib.Path('.').resolve();ns=pathlib.Path(a.namespace).resolve();ns.mkdir(parents=True,exist_ok=True)
 lock=open(ns/'runner.lock','a');fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
 identity=freeze_manifest(root);ip=ns/'identity.json'
 if ip.exists():validate_identity(root,json.load(open(ip)))
 else:
  # Immutable source revision must contain every production input before real work.
  if not a.dry_run:
   changed=subprocess.check_output(['git','status','--porcelain','--',*FILES],text=True)
   if changed.strip():raise ValueError('Commit production inputs before freezing a real run')
  atomic_json(ip,identity)
  for src in FILES:
   dest=ns/'frozen'/src;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes((root/src).read_bytes())
 requested=list(jobs(a.start_replicate,a.end_replicate));pending=[];prior=[]
 for job in requested:
  jd=ns/'jobs'/job['tag'];cp=load_checkpoint(jd,job,identity)
  if cp:
   prior.append(cp)
   if cp['state']!='completed':raise ValueError('Recorded process failure requires explicit diagnosis/new attempt namespace: '+job['tag'])
  else:
   if jd.exists()and any(jd.iterdir()):raise ValueError('Uncheckpointed job directory; recover evidence explicitly before resume: '+str(jd))
   pending.append(job)
 selected=pending[:a.max_jobs];run_id=time.strftime('%Y%m%dT%H%M%SZ',time.gmtime())+'-'+uuid.uuid4().hex[:6];run=ns/'runs'/run_id;run.mkdir(parents=True)
 manifest={'run_id':run_id,'identity':identity,'git_revision':subprocess.check_output(['git','rev-parse','HEAD'],text=True).strip(),'arguments':vars(a),'selected':selected,'already_completed':len(prior),'stage':'declared before dispatch','counts_are_datasets_not_method_fits':True};atomic_json(run/'manifest.json',manifest)
 if a.dry_run:print(json.dumps({'run_id':run_id,'pending':len(pending),'selected':len(selected),'dry_run':True}));return
 start=time.monotonic();completed=[];stop_reason='fixed job count';maxmem=memory_fraction();chunks=[selected[i:i+a.chunk_size]for i in range(0,len(selected),a.chunk_size)]
 def worker(index,chunk):
  validate_identity(root,identity);folder=run/f'chunk-{index:05d}';folder.mkdir();tsv=folder/'manifest.tsv'
  with open(tsv,'w')as f:
   w=csv.writer(f,delimiter='\t',lineterminator='\n')
   for j in chunk:
    jd=ns/'jobs'/j['tag'];jd.mkdir(parents=True);atomic_json(jd/'request.json',{'job':j,'identity':identity,'run_id':run_id})
    w.writerow([j['q'],j['missing'],j['mechanism'],j['seed'],j['tag'],j['N'],j['beta_shape'],str(jd)])
  env=dict(os.environ,**identity['environment']);env['OUTPUT_DIR']=str(ns/'unused');cmd=[identity['Rscript'],'simulation/production_batch.R',str(tsv)];rc=None;error='';t=time.monotonic()
  try:
   with open(folder/'worker.log','w')as f:rc=subprocess.run(cmd,env=env,stdout=f,stderr=subprocess.STDOUT,timeout=min(600,max(1,a.wall_seconds-(time.monotonic()-start)))).returncode
  except subprocess.TimeoutExpired:error='bounded worker time limit'
  validate_identity(root,identity)
  results=[]
  for j in chunk:
   jd=ns/'jobs'/j['tag'];record={'job':j,'identity':identity,'run_id':run_id,'state':'completed','process_returncode':rc}
   try:
    record['outputs']=validate_outputs(jd,j)
    if rc!=0 or record['outputs']['process_error']:record.update(state='process_failed_or_interrupted',error='Nonzero process exit or receipt error',process_error=error)
   except Exception as e:record.update(state='process_failed_or_interrupted',error=str(e),process_error=error,attempt_started=(jd/'started.csv').exists())
   atomic_json(jd/'checkpoint.json',record);results.append(record)
  atomic_json(folder/'result.json',{'returncode':rc,'error':error,'elapsed_seconds':time.monotonic()-t,'requested':len(chunk),'completed':sum(r['state']=='completed'for r in results)})
  return results
 with concurrent.futures.ThreadPoolExecutor(max_workers=a.workers)as pool:
  active={};index=0
  while index<len(chunks)or active:
   maxmem=max(maxmem,memory_fraction())
   if maxmem>.85:stop_reason='memory threshold'
   if time.monotonic()-start>=a.wall_seconds:stop_reason='fixed walltime'
   while stop_reason=='fixed job count'and len(active)<a.workers and index<len(chunks):
    # Reserve enough time for a chunk; never start work at the last instant.
    if a.wall_seconds-(time.monotonic()-start)<min(300,a.wall_seconds/2):stop_reason='fixed walltime reserve';break
    future=pool.submit(worker,index,chunks[index]);active[future]=index;index+=1
   if not active:break
   done,_=concurrent.futures.wait(active,timeout=5,return_when=concurrent.futures.FIRST_COMPLETED)
   for future in done:
    del active[future];results=future.result();completed.extend(results)
    if any(r['state']!='completed'for r in results):stop_reason='systemic process/output failure'
    nvalid=sum(v['valid']for r in completed if r['state']=='completed'for v in r['outputs']['methods'].values())
    progress={'run_id':run_id,'elapsed_seconds':time.monotonic()-start,'requested_datasets':sum(len(chunks[k])for k in range(index)),'completed_datasets':sum(r['state']=='completed'for r in completed),'guard_valid_method_fits':nvalid,'retained_invalid_method_fits':sum(not v['valid']for r in completed if r['state']=='completed'for v in r['outputs']['methods'].values()),'stop_reason':stop_reason,'memory_peak_fraction':maxmem}
    atomic_json(run/'progress.json',progress);print(json.dumps(progress),flush=True)
  finished={'run_id':run_id,'elapsed_seconds':time.monotonic()-start,'selected_datasets':len(selected),'dispatched_datasets':sum(len(chunks[k])for k in range(index)),'completed_datasets':sum(r['state']=='completed'for r in completed),'new_unique_datasets':sum(r['state']=='completed'and not r['job']['baseline_replay']for r in completed),'baseline_replays':sum(r['state']=='completed'and r['job']['baseline_replay']for r in completed),'guard_valid_method_fits':sum(v['valid']for r in completed if r['state']=='completed'for v in r['outputs']['methods'].values()),'invalid_method_fits':sum(not v['valid']for r in completed if r['state']=='completed'for v in r['outputs']['methods'].values()),'stop_reason':stop_reason,'memory_peak_fraction':maxmem}
  atomic_json(run/'summary.json',finished);print(json.dumps(finished),flush=True)
if __name__=='__main__':main()
