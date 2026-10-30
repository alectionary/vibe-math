"""Archive completed immutable run chunks and export a dated production checkpoint.
Does not launch fits, alter scientific outputs, or publish automatically.
"""
import argparse,hashlib,json,pathlib,subprocess,tarfile,datetime
p=argparse.ArgumentParser();p.add_argument('--namespace',default='production/chapter6-v1');a=p.parse_args();ns=pathlib.Path(a.namespace);archives=ns/'archives';archives.mkdir(exist_ok=True)
records=[]
for summary in sorted((ns/'runs').glob('*/summary.json')):
 run=summary.parent;rid=run.name;archive=archives/(rid+'.tar.gz');manifest=json.load(open(run/'manifest.json'));jobs=[]
 for job in manifest['selected']:
  jd=ns/'jobs'/job['tag'];cp=jd/'checkpoint.json'
  if cp.exists()and json.load(open(cp))['run_id']==rid:jobs.append(jd)
 if not archive.exists():
  tmp=archive.with_suffix('.tmp')
  with tarfile.open(tmp,'w:gz',compresslevel=1)as t:
   t.add(run,arcname='runs/'+rid)
   for jd in jobs:t.add(jd,arcname='jobs/'+jd.name)
  tmp.replace(archive)
 records.append({'run_id':rid,'path':str(archive),'bytes':archive.stat().st_size,'sha256':hashlib.sha256(archive.read_bytes()).hexdigest(),'dataset_checkpoints':len(jobs),'run_summary':json.load(open(summary))})
subprocess.run(['python','simulation/production_status.py','--namespace',str(ns),'--export'],check=True,stdout=subprocess.DEVNULL)
snapshots=[]
for folder in (ns/'supervision').glob('*'):
 for log in folder.glob('batch-*.log'):
  target=ns/'reports'/'live-log-snapshots'/folder.name/log.name;target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(log.read_bytes())
  snapshots.append({'source':str(log),'saved':str(target),'sha256':hashlib.sha256(target.read_bytes()).hexdigest(),'scope':'Dated log snapshot; active final line may be incomplete'})
record={'log_snapshots':snapshots,'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'archive_scope':'Completed immutable runner invocations only; live chunks remain local and are not overwritten. Extract archives into namespace to restore per-dataset checkpoints. Archives may overlap initial recoverybundle; never extract older data over newer completed jobs.','archives':records,'completed_archive_datasets':sum(x['dataset_checkpoints']for x in records),'latest_progress':json.load(open(ns/'reports/progress.json'))}
(ns/'archive-index.json').write_text(json.dumps(record,indent=2)+'\n');print(json.dumps({'saved_utc':record['saved_utc'],'archives':len(records),'archived_datasets':record['completed_archive_datasets'],'new_method_fits':record['latest_progress']['new_completed_method_fits'],'baseline_guard_refits':record['latest_progress']['guarded_baseline_replay_datasets']*2,'guard_invalid':record['latest_progress']['guard_invalid_method_fits'],'process_failures':record['latest_progress']['process_failed_datasets']}))
