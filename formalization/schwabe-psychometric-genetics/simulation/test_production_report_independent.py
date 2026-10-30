"""Independent baseline, bookkeeping, digest and adversarial report checks; no fits.
Run from the study directory. Writes only temporary fixtures and /tmp evidence.
"""
import pathlib,importlib.util,tempfile,json,csv,copy,hashlib
root=pathlib.Path.cwd()
s=(root/'simulation/test_production_analysis.py').read_text(); f={};exec(compile(s.split("run('preserved20repbaseline_numeric_and_inventory'")[0],'baseline-fixture','exec'),f)
exec(compile(s[s.index('small_records=[]'):s.index("run('invalid_failed_inflight_denominators_and_paired_filter'")],'tiny-fixture','exec'),f)
spec=importlib.util.spec_from_file_location('builder',root/'simulation/build_production_report.py');b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
checks=[]
def record(name): checks.append({'test':name,'passed':True})
baselinepaths=[root/'outputs/trial-records.csv',root/'outputs/condition-summary.csv'];before={str(p):b.sha(p) for p in baselinepaths}
with tempfile.TemporaryDirectory(prefix='independent-report-') as td:
 p=pathlib.Path(td)
 for label,rs,rows,counts in [('baseline',f['records'],f['rows'],f['counts']),('tiny',f['small_records'],f['small_rows'],f['small_counts'])]:
  reports=p/(label+'-reports');analysis=p/(label+'-analysis');out=p/(label+'-paper')
  f['write'](reports,rs,rows,counts);f['a'].analyze(reports,analysis,root/'outputs/source-figure-values.csv',root/'production/analysis-plan.json')
  m=b.build(analysis,out);x=m['numeric_macros']
  assert all(b.sha(analysis/n)==h for n,h in m['input_sha256'].items());assert all(b.sha(out/n)==h for n,h in m['output_sha256'].items());record(label+'_input_output_hashes')
  if label=='baseline':
   assert [x[k] for k in ['CompletedFits','ValidFits','VarianceOutside','PathOutside','PositivePoints','PositiveBands','BiasReversals']]==['1920','1920','191','0','108','104','23']
   assert (x['CompletedMinRep'],x['CompletedMaxRep'])==('20','20');assert x['HbiasGeneratingTruth']=='0.5';assert x['AvarianceOurs']!=x['ApathOurs'];record('baseline_counts_estimands_and_signed_bias')
  else:
   assert [x[k] for k in ['RequestedFits','CompletedFits','ValidFits','InvalidFits','FailedSlots','PendingSlots']]==['8','4','3','1','2','2']
   assert (x['CompletedMinRep'],x['CompletedMaxRep'])==('0','2');assert x['AvarianceOurs']=='NA';record('tiny_failure_pending_counts_and_nonestimability')
  try:b.build(analysis,out)
  except ValueError:record(label+'_overwrite_rejected')
  else:raise AssertionError('overwrite accepted')
 analysis=p/'baseline-analysis'
 def csv_mutate(name,mutation,label):
  path=analysis/name;original=path.read_bytes();rows=list(csv.DictReader(path.open()));mutation(rows)
  with path.open('w')as h:w=csv.DictWriter(h,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
  try:
   try:b.build(analysis,p/label)
   except ValueError:record(label)
   else:raise AssertionError(label+' accepted')
  finally:path.write_bytes(original)
 csv_mutate('signed-SE-contrasts.csv',lambda r:r.__setitem__(-1,r[-2].copy()),'duplicate_contrast_rejected')
 csv_mutate('signed-bias-contrasts.csv',lambda r:r.__setitem__(-1,r[-2].copy()),'duplicate_bias_rejected')
 csv_mutate('source-comparisons.csv',lambda r:r.__setitem__(-1,r[-2].copy()),'duplicate_comparison_rejected')
 csv_mutate('signed-SE-contrasts.csv',lambda r:r[0].update(family_size='1'),'wrong_family_rejected')
 csv_mutate('condition-summary.csv',lambda r:r[0].update(guard_invalid='-1'),'negative_denominator_rejected')
 sp=analysis/'summary.json';old=sp.read_bytes();summary=json.loads(old);summary['MAR_bias_point_reversals']=999;sp.write_text(json.dumps(summary))
 try:
  try:b.build(analysis,p/'wrong-summary')
  except ValueError:record('mismatched_summary_reversal_rejected')
  else:raise AssertionError('summary mismatch accepted')
 finally:sp.write_bytes(old)
assert before=={str(p):b.sha(p)for p in baselinepaths};record('baseline_files_unchanged')
result={'checks':checks,'passed':True,'scope':'Preserved baseline and synthetic bookkeeping only; no live production effects or fits.'}
pathlib.Path('/tmp/production-report-independent-validation.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
