"""Read guarded checkpoints; report all denominators without changing dispatch."""
import argparse,collections,csv,gzip,hashlib,json,math,pathlib,time,tarfile
from production_runner import load_checkpoint

def main():
 p=argparse.ArgumentParser();p.add_argument('--namespace',default='production/chapter6-v1');p.add_argument('--export',action='store_true');a=p.parse_args();ns=pathlib.Path(a.namespace);identity=json.load(open(ns/'identity.json'));output=ns/'reports';output.mkdir(exist_ok=True)
 records=[];states=collections.Counter();invalid=collections.Counter();conditions=collections.defaultdict(lambda:collections.Counter());paths=[];new=0;baseline=0;processfail=0;failed_dirs=[]
 checkpoint_paths=sorted((ns/'jobs').glob('*/checkpoint.json'))
 for req in (ns/'jobs').glob('*/request.json'):
  j=json.load(open(req))['job']
  for method in ['full','deletion']:conditions[(j['mechanism'],j['q'],j['missing'],method)]['requested']+=1
 for f in checkpoint_paths:
  r=json.load(open(f));j=r['job'];records.append(r);states[r['state']]+=1
  if r['state']!='completed':
   processfail+=1;failed_dirs.append(f.parent)
   for method in ['full','deletion']:conditions[(j['mechanism'],j['q'],j['missing'],method)]['process_failed']+=1
   continue
  if a.export:load_checkpoint(f.parent,j,identity)
  new+=not j['baseline_replay'];baseline+=j['baseline_replay']
  for method,m in r['outputs']['methods'].items():
   key=(j['mechanism'],j['q'],j['missing'],method);conditions[key]['completed']+=1;conditions[key]['valid'if m['valid']else'invalid']+=1
   if not m['valid']:invalid[m['invalid_reasons']]+=1
   paths.append((f.parent/(j['tag']+'-'+method+'.csv'),j,method))
 started=sum(1 for _ in (ns/'jobs').glob('*/started.csv'));requested=sum(1 for _ in (ns/'jobs').glob('*/request.json'));runs=[]
 for path in sorted((ns/'runs').glob('*/summary.json')):
  s=json.load(open(path));manifest=json.load(open(path.parent/'manifest.json'));s['workers']=manifest['arguments']['workers'];s['datasets_per_second']=s['completed_datasets']/s['elapsed_seconds'];runs.append(s)
 valid=sum(c['valid']for c in conditions.values());bad=sum(c['invalid']for c in conditions.values());remaining=47040-new
 estimate_runs=[r for r in runs if r['workers']==4 and r['completed_datasets']>=48 and r['stop_reason']in ['fixed job count','fixed walltime reserve','fixed walltime']]
 rate=sum(r['completed_datasets']for r in estimate_runs)/sum(r['elapsed_seconds']for r in estimate_runs)if estimate_runs else None
 report={'time_utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'namespace':str(ns),'code_identity':identity,'target_unique_datasets':48000,'target_method_fits':96000,'preserved_baseline_method_fits':1920,'new_completed_datasets':new,'new_completed_method_fits':2*new,'unique_method_fits_completed_including_preserved_baseline':1920+2*new,'guarded_baseline_replay_datasets':baseline,'guard_valid_method_fits':valid,'guard_invalid_method_fits':bad,'guard_validity_is_not_global_convergence':True,'process_failed_datasets':processfail,'requested_dataset_directories':requested,'started_dataset_receipts':started,'completed_dataset_checkpoints':states['completed'],'in_flight_or_uncheckpointed_requested':requested-len(records),'new_datasets_remaining':remaining,'new_method_fits_remaining':2*remaining,'baseline_datasets_still_needing_guard_audit':960-baseline,'invalid_reasons':dict(invalid),'four_worker_measured_datasets_per_second':rate,'estimated_remaining_new_wall_hours':remaining/rate/3600 if rate else None,'completed_runs':runs,'stopping':'All1000datasetspercondition remain targeted. Operational checkpoints and invalidfits do not trigger favorable-significance stopping.'}
 (output/'progress.json').write_text(json.dumps(report,indent=2)+'\n')
 with open(output/'condition-counts.csv','w')as f:
  w=csv.writer(f,lineterminator='\n');w.writerow(['mechanism','q','missing','method','target','requested','completed','guard_valid','guard_invalid','process_failed','in_flight_or_uncheckpointed'])
  for k,c in sorted(conditions.items()):w.writerow([*k,1000,c['requested'],c['completed'],c['valid'],c['invalid'],c['process_failed'],c['requested']-c['completed']-c['process_failed']])
 if a.export:
  headers={'replicate','baseline_replay','tag'}
  for path,j,m in paths:
   with open(path)as f:headers.update(next(csv.reader(f)))
  headers=['tag','replicate','baseline_replay']+sorted(headers-{'tag','replicate','baseline_replay'})
  tmp=output/'guarded-trials.csv.gz.tmp'
  with gzip.open(tmp,'wt',newline='')as f:
   w=csv.DictWriter(f,fieldnames=headers,lineterminator='\n');w.writeheader()
   for path,j,m in paths:
    for r in csv.DictReader(open(path)):w.writerow(dict(r,tag=j['tag'],replicate=j['replicate'],baseline_replay=j['baseline_replay']))
  tmp.replace(output/'guarded-trials.csv.gz')
  # Partial process failures are preserved even when no verified completion exists.
  partial=[]
  with tarfile.open(output/'partial-failure-evidence.tar.gz','w:gz')as archive:
   for folder in failed_dirs:
    for f in sorted(folder.iterdir()):
     if f.is_file():
      archive.add(f,arcname=folder.name+'/'+f.name,recursive=False)
      partial.append({'path':str(f),'sha256_at_export':hashlib.sha256(f.read_bytes()).hexdigest(),'scope':'retained process-failure evidence; not guard-valid completion'})
  (output/'partial-failure-manifest.json').write_text(json.dumps(partial,indent=2)+'\n')
  with gzip.open(output/'checkpoint-ledger.jsonl.gz','wt')as f:
   for r in records:f.write(json.dumps(r,separators=(',',':'))+'\n')
  (output/'export.json').write_text(json.dumps({'time_utc':report['time_utc'],'datasets':len(records),'files':{name:hashlib.sha256((output/name).read_bytes()).hexdigest()for name in ['guarded-trials.csv.gz','checkpoint-ledger.jsonl.gz']},'scope':'Includes all completed valid and invalid fits; process failures retained in checkpoint ledger. Original baseline files unchanged.'},indent=2)+'\n')
 print(json.dumps({k:v for k,v in report.items()if k not in ['code_identity','completed_runs']},indent=2))
if __name__=='__main__':main()
