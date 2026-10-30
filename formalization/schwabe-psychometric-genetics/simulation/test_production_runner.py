"""Independent adversarial tests. Temporary fixtures never enter scientific outputs."""
import csv,hashlib,importlib.util,json,pathlib,shutil,tempfile
root=pathlib.Path('.').resolve()
spec=importlib.util.spec_from_file_location('production_runner',root/'simulation/production_runner.py');runner=importlib.util.module_from_spec(spec);spec.loader.exec_module(runner)
checks=[]
def check(name,fn,reject=False):
 try:fn();passed=not reject;error='accepted'
 except (ValueError,KeyError,FileNotFoundError,TypeError)as e:passed=reject;error=type(e).__name__+': '+str(e)
 checks.append(dict(test=name,passed=passed,result=error))
with tempfile.TemporaryDirectory(prefix='schwabe-runner-fixture-')as td:
 tmp=pathlib.Path(td);job=list(runner.jobs(0,1))[3];jd=tmp/'job';jd.mkdir()
 original={m:list(csv.DictReader(open('/tmp/schwabe-independent-guard-check/independent-q2-MCAR-'+m+'.csv')))for m in ['full','deletion']}
 def setup():
  for p in jd.iterdir():p.unlink()
  for m,rows in original.items():
   with open(jd/(job['tag']+'-'+m+'.csv'),'w')as f:w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
  with open(jd/'completed.csv','w')as f:w=csv.DictWriter(f,fieldnames=['tag','elapsed_seconds','error']);w.writeheader();w.writerow(dict(tag=job['tag'],elapsed_seconds='2',error=''))
 def alter(field,value,method='full'):
  p=jd/(job['tag']+'-'+method+'.csv');rows=list(csv.DictReader(open(p)))
  for row in rows:row[field]=value
  with open(p,'w')as f:w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
 def validate():return runner.validate_outputs(jd,job)
 setup();check('complete_guard_valid_receipt',validate)
 for field,value in [('estimate','NaN'),('se','NaN'),('se','0'),('delta_variance','-1'),('delta_variance','NaN'),('delta_variance','2'),('status','6'),('seed','1'),('parameter_alignment_valid','FALSE')]:
  setup();alter(field,value);check('reject_'+field+'_'+value,validate,True)
 setup();alter('valid','FALSE');alter('invalid_reasons','deliberate_fixture_failure')
 def invalid_retained():
  d=validate();assert not d['methods']['full']['valid'] and d['methods']['deletion']['valid'];assert d['methods']['full']['parameter_rows']==6
 check('invalid_fit_retained_in_two_method_denominator',invalid_retained)
 setup();(jd/(job['tag']+'-deletion.csv')).unlink();check('missing_method_rejected',validate,True)
 setup();(jd/'completed.csv').unlink();check('missing_receipt_rejected',validate,True)
 # Manifest binds each source/protocol file and launcher; mutations reject resume.
 frozen=tmp/'source';frozen.mkdir()
 for p in runner.FILES:
  target=frozen/p;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(root/p,target)
 identity=runner.freeze_manifest(frozen);check('matching_frozen_identity',lambda:runner.validate_identity(frozen,identity))
 for p in ['simulation/production_guards.R','production/protocol.json']:
  target=frozen/p;old=target.read_bytes();target.write_bytes(old+b'\nmutation');check('frozen_hash_reject_'+p,lambda:runner.validate_identity(frozen,identity),True);target.write_bytes(old)
 setup();out=validate();record=dict(job=job,identity=identity,state='completed',outputs=out);runner.atomic_json(jd/'checkpoint.json',record)
 check('unchanged_checkpoint_resumes',lambda:runner.load_checkpoint(jd,job,identity))
 alter('estimate','0.987');check('tampered_output_digest_rejected',lambda:runner.load_checkpoint(jd,job,identity),True)
 setup();record=dict(job=job,identity=identity,state='process_failed_or_interrupted',error='fixture timeout',attempt_started=True);runner.atomic_json(jd/'checkpoint.json',record)
 check('failed_attempt_preserved',lambda:runner.load_checkpoint(jd,job,identity))
 record['state']='invented_state';runner.atomic_json(jd/'checkpoint.json',record);check('unknown_checkpoint_state_rejected',lambda:runner.load_checkpoint(jd,job,identity),True)
 checks.append(dict(test='48_unique_seeded_conditions_per_replicate',passed=len(list(runner.jobs(20,21)))==48 and len({j['seed']for j in runner.jobs(20,21)})==48,result='seed/condition inventory'))
result=dict(checks=checks,passed=all(c['passed']for c in checks),scope='Temporary adversarial fixtures only; no new scientific fits or altered baseline.')
(root/'outputs/production-runner-validation.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2));raise SystemExit(not result['passed'])
