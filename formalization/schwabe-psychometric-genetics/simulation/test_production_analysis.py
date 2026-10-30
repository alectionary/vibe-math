"""Independent baseline and adversarial guarded-analysis checks; no fits performed."""
import collections,csv,gzip,hashlib,importlib.util,json,math,pathlib,subprocess,sys,tempfile,copy
ROOT=pathlib.Path('.').resolve();spec=importlib.util.spec_from_file_location('analysis',ROOT/'simulation/analyze_production.py');a=importlib.util.module_from_spec(spec);spec.loader.exec_module(a)
checks=[]
def job(mech,q,missing,rep):
 seed=34000+48*rep+['MCAR','MAR','MNAR'].index(mech)*16+(q-2)*4+[.02,.03,.06,.1].index(missing)
 return dict(tag=f'production-c6-{mech}-q{q}-m{missing}-r{rep}',replicate=rep,q=q,missing=missing,mechanism=mech,seed=seed,N=1000,beta_shape='equal',baseline_replay=rep<20)
def ledger(j,flags=None,state='completed'):
 flags=flags or dict(full=True,deletion=True)
 return dict(job=j,identity={'fixture':'independent-analysis-validation; not scientific fit evidence'},state=state,process_returncode=0,outputs={'process_error':'','methods':{m:{'valid':v,'invalid_reasons':''if v else'fixture_invalid','status':0 if v else 6}for m,v in flags.items()}})
def write(reports,records,rows,counts):
 reports.mkdir()
 with gzip.open(reports/'checkpoint-ledger.jsonl.gz','wt')as f:
  for r in records:f.write(json.dumps(r)+'\n')
 fields=list(dict.fromkeys(k for r in rows for k in r))
 with gzip.open(reports/'guarded-trials.csv.gz','wt')as f:
  w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows(rows)
 with open(reports/'condition-counts.csv','w')as f:
  w=csv.DictWriter(f,fieldnames=list(counts[0]));w.writeheader();w.writerows(counts)
 (reports/'export.json').write_text(json.dumps({'files':{name:hashlib.sha256((reports/name).read_bytes()).hexdigest()for name in ['guarded-trials.csv.gz','checkpoint-ledger.jsonl.gz']}}))
def run(label,records,rows,counts,assertion=None,reject=False,source=None):
 with tempfile.TemporaryDirectory(prefix='schwabe-independent-analysis-')as td:
  p=pathlib.Path(td);write(p/'reports',records,rows,counts)
  try:
   s=a.analyze(p/'reports',p/'analysis',source or ROOT/'outputs/source-figure-values.csv',ROOT/'production/analysis-plan.json')
   if reject:raise AssertionError('Expected rejection')
   if assertion:assertion(s,p/'analysis')
   checks.append({'test':label,'passed':True})
  except (ValueError,AssertionError,KeyError)as e:
   if not reject:raise
   if isinstance(e,AssertionError)and str(e)=='Expected rejection':raise
   checks.append({'test':label,'passed':True,'rejection':str(e)})
# Repackage preserved20-replicate outputs as explicit fixture-only guarded records.
original=list(csv.DictReader(open(ROOT/'outputs/trial-records.csv')));records_by_key={};rows=[];counter=collections.Counter()
for old in original:
 r=dict(old);j=job(r['mechanism'],int(r['q']),float(r['missing']),int(r['replicate']));key=(j['mechanism'],j['q'],j['missing'],j['replicate'])
 records_by_key[key]=ledger(j);r.update(tag=j['tag'],baseline_replay=True,valid=True,invalid_reasons='',delta_variance=float(r['se'])**2)
 rows.append(r)
for record in records_by_key.values():
 j=record['job']
 for m in ['full','deletion']:counter[(j['mechanism'],j['q'],j['missing'],m)]+=1
counts=[dict(mechanism=k[0],q=k[1],missing=k[2],method=k[3],target=1000,requested=n,completed=n,guard_valid=n,guard_invalid=0,process_failed=0,in_flight_or_uncheckpointed=0)for k,n in counter.items()]
records=list(records_by_key.values())
def baseline(s,out):
 assert s['completed_method_fits']==1920 and s['guarded_baseline_replay_datasets']==960 and s['new_completed_datasets']==0
 expected={'source_variance_SE_outside':191,'source_path_SE_outside':0,'primary_variance_SE_positive_points':108,'primary_variance_SE_adjusted_positive':104,'MAR_bias_point_reversals':23}
 for key,val in expected.items():assert s[key]==val,(key,s[key])
 new=list(csv.DictReader(open(out/'condition-summary.csv')));old=list(csv.DictReader(open(ROOT/'outputs/condition-summary.csv')));lookup={(r['mechanism'],int(r['q']),float(r['missing']),r['parameter'],r['method']):r for r in old}
 for r in new:
  b=lookup[(r['mechanism'],int(r['q']),float(r['missing']),r['parameter'],r['method'])]
  for m in ['estimate','se','path_se']:
   if b[m+'_mean']!='':assert math.isclose(float(r[m+'_mean']),float(b[m+'_mean']),rel_tol=1e-12,abs_tol=1e-12)
run('preserved20repbaseline_numeric_and_inventory',records,rows,counts,baseline)
run('duplicate_dataset_rejected',records+[records[0]],rows,counts,reject=True)
run('duplicate_parameter_rejected',records,rows+[rows[0]],counts,reject=True)
r=copy.deepcopy(rows);r[0]['seed']=1;run('wrong_seed_rejected',records,r,counts,reject=True)
r=copy.deepcopy(rows);r[0]['estimate']='NaN';run('nonfinite_valid_estimate_rejected',records,r,counts,reject=True)
r=copy.deepcopy(rows);r[0]['delta_variance']=-1;run('negative_delta_rejected',records,r,counts,reject=True)
r=copy.deepcopy(rows);r.pop(0);run('missing_parameter_rejected',records,r,counts,reject=True)
r=copy.deepcopy(records);r[0]['identity']={'different':'code'};run('mixed_frozen_identity_rejected',r,rows,counts,reject=True)
# Independent tiny fixture: two completed datasets(oneinvalidmethod),onefailed,oneinflight.
small_records=[];small_rows=[]
for rep in [0,20]:
 j=job('MCAR',2,.1,rep);small_records.append(ledger(j,dict(full=True,deletion=rep==0)))
 for m in ['full','deletion']:
  valid=rep==0 or m=='full'
  for param in ['A','C','E','h2','beta1','beta2']:
   est={'A':.5,'C':.3,'E':.2,'h2':.5,'beta1':.2,'beta2':.2}[param]+(.2 if rep==20 else 0)
   se=(.1 if rep==0 else .2)*(1 if m=='full'else 2)
   small_rows.append(dict(tag=j['tag'],replicate=rep,baseline_replay=rep<20,seed=j['seed'],N=1000,mechanism='MCAR',q=2,missing=.1,method=m,parameter=param,valid=valid,invalid_reasons=''if valid else'fixture_invalid',estimate=est if valid else'NA',se=se if valid else'NA',delta_variance=se**2 if valid else'NA',status=0 if valid else 6,minus2loglik=1 if valid else'NA'))
small_records.append(ledger(job('MCAR',2,.1,21),state='process_failed_or_interrupted'))
small_counts=[dict(mechanism='MCAR',q=2,missing=.1,method=m,target=1000,requested=4,completed=2,guard_valid=2 if m=='full'else 1,guard_invalid=0 if m=='full'else 1,process_failed=1,in_flight_or_uncheckpointed=1)for m in ['full','deletion']]
def tiny(s,out):
 assert (s['requested_method_fits'],s['completed_method_fits'],s['guard_valid_method_fits'],s['guard_invalid_method_fits'],s['process_failed_method_slots'],s['in_flight_or_uncheckpointed_method_slots'])==(8,4,3,1,2,2)
 assert s['guarded_baseline_replay_datasets']==1 and s['new_completed_datasets']==1
 cs=list(csv.DictReader(open(out/'condition-summary.csv')));r=next(r for r in cs if r['mechanism']=='MCAR'and r['q']=='2'and r['missing']=='0.1'and r['method']=='full'and r['parameter']=='A');assert abs(float(r['estimate_mean'])-.6)<1e-12 and abs(float(r['estimate_sd'])-math.sqrt(.02))<1e-12 and abs(float(r['estimate_mcse'])-.1)<1e-12
 se=list(csv.DictReader(open(out/'signed-SE-contrasts.csv')));r=next(r for r in se if r['mechanism']=='MCAR'and r['q']=='2'and r['missing']=='0.1'and r['parameter']=='A'and r['metric']=='se');assert r['requested_pairs']=='4'and r['valid_pairs']=='1'and r['excluded_or_pending_pairs']=='3'and r['adjusted_low']==''
 assert len(cs)==720 and len(se)==288
run('invalid_failed_inflight_denominators_and_paired_filter',small_records,small_rows,small_counts,tiny)
r=copy.deepcopy(small_records);r[1]['job']['baseline_replay']='False';run('string_baseline_boolean_rejected',r,small_rows,small_counts,reject=True)
r=copy.deepcopy(small_records);r[0]['job']['N']=2000;run('wrong_ledger_sample_size_rejected',r,small_rows,small_counts,reject=True)
with tempfile.TemporaryDirectory(prefix='schwabe-source-inventory-fixture-')as td:
 src=pathlib.Path(td)/'source.csv';sr=list(csv.DictReader(open(ROOT/'outputs/source-figure-values.csv')))
 next(r for r in sr if r['measure']=='estimate'and r['parameter']=='h2')['parameter']='E'
 with open(src,'w')as f:w=csv.DictWriter(f,fieldnames=list(sr[0]));w.writeheader();w.writerows(sr)
 run('wrong_source_condition_inventory_rejected',small_records,small_rows,small_counts,reject=True,source=src)
with tempfile.TemporaryDirectory(prefix='schwabe-export-digest-fixture-')as td:
 p=pathlib.Path(td);write(p/'reports',small_records,small_rows,small_counts)
 with open(p/'reports/guarded-trials.csv.gz','ab')as f:f.write(b'tampered')
 try:a.analyze(p/'reports',p/'analysis',ROOT/'outputs/source-figure-values.csv',ROOT/'production/analysis-plan.json')
 except ValueError as e:assert 'digest mismatch'in str(e);checks.append({'test':'tampered_export_digest_rejected','passed':True})
 else:raise AssertionError('Tampered export accepted')
result={'passed':True,'checks':checks,'scope':'Copied baseline and deliberately synthetic temporary fixtures; no new scientific fits or production outcome inspection.'}
(ROOT/'outputs/production-analysis-independent-validation.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
