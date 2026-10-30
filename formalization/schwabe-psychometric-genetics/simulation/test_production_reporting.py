"""Independent denominator/export fixtures; copied rows are never scientific evidence."""
import csv,importlib.util,json,pathlib,subprocess,sys,tempfile,gzip
root=pathlib.Path('.').resolve();spec=importlib.util.spec_from_file_location('runner',root/'simulation/production_runner.py');runner=importlib.util.module_from_spec(spec);spec.loader.exec_module(runner)
checks=[]
with tempfile.TemporaryDirectory(prefix='schwabe-report-fixtures-')as td:
 ns=pathlib.Path(td);(ns/'jobs').mkdir();(ns/'runs').mkdir();identity=runner.freeze_manifest(root);runner.atomic_json(ns/'identity.json',identity)
 originals={m:list(csv.DictReader(open('/tmp/schwabe-independent-guard-check/independent-q2-MCAR-'+m+'.csv')))for m in ['full','deletion']}
 def create(rep,state):
  job=list(runner.jobs(rep,rep+1))[3];jd=ns/'jobs'/job['tag'];jd.mkdir();runner.atomic_json(jd/'request.json',{'job':job,'identity':identity,'run_id':'fixture'})
  if state=='inflight':return
  for method in ['full','deletion']:
   if state=='process_failed_or_interrupted'and method=='deletion':continue
   rows=[dict(r)for r in originals[method]]
   for r in rows:
    r['seed']=job['seed']
    if rep==20 and method=='deletion':r.update(valid='FALSE',invalid_reasons='fixture_numerical_failure')
   with open(jd/(job['tag']+'-'+method+'.csv'),'w')as f:w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
  if state=='completed':
   with open(jd/'completed.csv','w')as f:w=csv.DictWriter(f,fieldnames=['tag','elapsed_seconds','error']);w.writeheader();w.writerow(dict(tag=job['tag'],elapsed_seconds=1,error=''))
   record={'job':job,'identity':identity,'state':state,'outputs':runner.validate_outputs(jd,job)}
  else:record={'job':job,'identity':identity,'state':state,'error':'fixture interrupted after full method','attempt_started':True}
  runner.atomic_json(jd/'checkpoint.json',record)
 create(0,'inflight');create(1,'completed');create(20,'completed');create(21,'process_failed_or_interrupted')
 subprocess.run([sys.executable,'simulation/production_status.py','--namespace',str(ns),'--export'],check=True,stdout=subprocess.DEVNULL)
 report=json.load(open(ns/'reports/progress.json'));counts=list(csv.DictReader(open(ns/'reports/condition-counts.csv')))
 checks.append({'test':'requested_includes_complete_failed_inflight','passed':len(counts)==2 and all(int(r['requested'])==4 for r in counts)})
 checks.append({'test':'no_baseline_audit_double_count','passed':report['new_completed_datasets']==1 and report['guarded_baseline_replay_datasets']==1 and report['unique_method_fits_completed_including_preserved_baseline']==1922})
 checks.append({'test':'guard_valid_and_invalid_both_retained','passed':report['guard_valid_method_fits']==3 and report['guard_invalid_method_fits']==1})
 checks.append({'test':'process_failed_and_uncheckpointed_counts','passed':report['process_failed_datasets']==1 and report['in_flight_or_uncheckpointed_requested']==1})
 with gzip.open(ns/'reports/guarded-trials.csv.gz','rt')as f:rows=list(csv.DictReader(f))
 checks.append({'test':'completed_valid_and_invalid_parameter_rows_exported','passed':len(rows)==24 and sum(r['valid'].lower()=='false'for r in rows)==6})
 # Partial output must remain in a separate evidence archive, never promoted to completed.
 partial=[p.name for p in (ns/'reports').iterdir() if 'partial'in p.name or 'unverified'in p.name]
 checks.append({'test':'partial_process_failure_evidence_archived','passed':bool(partial),'files':partial})
 result={'passed':all(c['passed']for c in checks),'checks':checks,'scope':'Temporary synthetic bookkeeping fixtures only; not simulation evidence.','fixture_report':{k:report[k]for k in ['new_completed_datasets','guarded_baseline_replay_datasets','guard_valid_method_fits','guard_invalid_method_fits','process_failed_datasets','in_flight_or_uncheckpointed_requested']},'condition_rows':counts}
(root/'outputs/production-reporting-validation.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2));raise SystemExit(not result['passed'])
