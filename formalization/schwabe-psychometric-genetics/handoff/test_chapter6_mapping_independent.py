"""Independent baseline/synthetic mapper review; no live production inputs or fits."""
import pathlib,json,csv,copy,importlib.util,tempfile,hashlib
root=pathlib.Path.cwd();sp=root/'handoff/claim-specification.json'
source=(root/'simulation/test_production_analysis.py').read_text();f={}
exec(compile(source.split("run('preserved20repbaseline_numeric_and_inventory'")[0],'baseline-fixture','exec'),f)
exec(compile(source[source.index('small_records=[]'):source.index("run('invalid_failed_inflight_denominators_and_paired_filter'")],'tiny-fixture','exec'),f)
s=importlib.util.spec_from_file_location('mapper',root/'handoff/map_chapter6_results.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
checks=[]
def passed(name):checks.append({'test':name,'passed':True})
def reject(name,fn):
 try:fn()
 except (ValueError,KeyError):passed(name)
 else:raise AssertionError(name+' was accepted')
original=json.loads(sp.read_text());before=hashlib.sha256((root/'outputs/trial-records.csv').read_bytes()).hexdigest()
with tempfile.TemporaryDirectory(prefix='independent-c6-map-')as td:
 p=pathlib.Path(td)
 for label,records,rows,counts in [('baseline',f['records'],f['rows'],f['counts']),('tiny',f['small_records'],f['small_rows'],f['small_counts'])]:
  reports=p/(label+'-reports');analysis=p/(label+'-analysis');f['write'](reports,records,rows,counts);f['a'].analyze(reports,analysis,root/'outputs/source-figure-values.csv',root/'production/analysis-plan.json')
  digest=m.snapshot_sha(m.snapshot(analysis));mapped=m.map_results(sp,analysis,digest,fixture=True);by={r['claim_id']:r for r in mapped['claims']}
  expected={c['id']for c in original['claims']if any(l.startswith('C6')for l in c['legacy_ids'])};assert set(by)==expected and len(by)==408
  assert mapped['inventory']=={'source_claim_ids':408,'source_figure_points':288,'unique_primary_variance_SE_contrasts':108,'unique_MAR_bias_contrasts':72}
  assert len(by['H6.precision-grid']['contrasts'])==108 and len(by['C6-5.beta-recovery']['mappings'])==336 and len(mapped['sensitivity_SE_contrasts'])==72
  assert all('status'not in r and r['adjudication_required'] for r in by.values())
  sources={c['id']:c for c in original['claims']}
  for ident,r in by.items():
   for k in ['parent_claim_ids','component_claim_ids','component_contrast_refs']:assert r[k]==sources[ident].get(k,[])
   assert len(r['contrasts'])==len(sources[ident]['contrasts'])
  for ident in ['H6.power-assertion','H6.covariate-nondetection','C6-6.6.3.male']:
   assert by[ident]['computed_value']is None and by[ident]['missing_reason']
  passed(label+'_complete_inventory_relationships_and_no_verdicts')
  # Independently key every direct point and scientific contrast back to the analyzer CSV.
  comp={(r['mechanism'],r['q'],r['missing'],r['method'],r['parameter'],r['metric']):r for r in csv.DictReader((analysis/'source-comparisons.csv').open())}
  for r in by.values():
   for z in r['mappings']:
    if z['table']=='source-comparisons.csv':
     key=tuple(z['row_key'][k]for k in ['mechanism','q','missing','method','parameter','metric']);row=comp[key]
     assert z['computed_value']==(float(row['ours'])if row['ours']else None)
  ex=by['C6-2.fig6.3.q2.missing0.02.A.full']
  if label=='baseline':assert ex['computed_value']!=ex['exploratory_path_SE']['computed_value']
  else:assert ex['computed_value']is None and ex['missing_reason']
  tables={name:list(csv.DictReader((analysis/name).open()))for name in ['signed-SE-contrasts.csv','signed-bias-contrasts.csv']}
  for r in by.values():
   for z in r['contrasts']:
    if z.get('table') in tables:
     row=next(v for v in tables[z['table']]if all(v[k]==val for k,val in z['row_key'].items()))
     assert z['computed_value']==(float(row[z['value_field']])if row[z['value_field']]else None)
     assert z['row']==row
  passed(label+'_signed_contrast_values_and_full_denominators')
  passed(label+'_same_label_value_joins_and_metric_or_missingness')
 analysis=p/'baseline-analysis';digest=m.snapshot_sha(m.snapshot(analysis))
 def mutate_spec(name,fn):
  changed=copy.deepcopy(original);fn(changed);path=p/(name+'.json');path.write_text(json.dumps(changed));reject(name,lambda:m.map_results(path,analysis,digest,fixture=True))
 def claim(s,id):return next(c for c in s['claims']if c['id']==id)
 fid='C6-2.fig6.3.q2.missing0.02.A.full';pid='C6-2.precision.MCAR.A';bid='C6-3.MAR-bias.A'
 mutate_spec('wrong_source_method',lambda s:claim(s,fid)['conditions'].update(method='deletion'))
 mutate_spec('wrong_source_q',lambda s:claim(s,fid)['conditions'].update(q=3))
 mutate_spec('wrong_source_units',lambda s:claim(s,fid)['published'].update(units='path SE'))
 mutate_spec('wrong_precision_direction',lambda s:claim(s,pid)['contrasts'][0].update(positive_means='Deletion has smaller SE'))
 mutate_spec('wrong_MAR_parent_N',lambda s:claim(s,bid)['conditions'].update(N_pairs=999))
 mutate_spec('wrong_MAR_units',lambda s:claim(s,bid)['contrasts'][0].update(units='path units'))
 mutate_spec('wrong_source_value',lambda s:claim(s,fid)['published'].update(value=99))
 mutate_spec('duplicate_source_ID',lambda s:s['claims'].append(copy.deepcopy(claim(s,fid))))
 mutate_spec('missing_source_ID',lambda s:s['claims'].remove(claim(s,fid)))
 mutate_spec('duplicate_precision_source_cell',lambda s:claim(s,pid)['contrasts'].__setitem__(-1,copy.deepcopy(claim(s,pid)['contrasts'][-2])))
 mutate_spec('duplicate_bias_source_cell',lambda s:claim(s,bid)['contrasts'].__setitem__(-1,copy.deepcopy(claim(s,bid)['contrasts'][-2])))
 mutate_spec('cross_condition_precision_source_cell',lambda s:claim(s,pid)['contrasts'][0]['conditions'].update(mechanism='MAR'))
 def mutate_table(name,fn,label):
  path=analysis/name;old=path.read_bytes();rows=list(csv.DictReader(path.open()));fn(rows)
  with path.open('w')as h:w=csv.DictWriter(h,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
  try:reject(label,lambda:m.map_results(sp,analysis,m.snapshot_sha(m.snapshot(analysis)),fixture=True))
  finally:path.write_bytes(old)
 mutate_table('source-comparisons.csv',lambda rs:rs[0].update(figure='6.6'),'wrong_analysis_figure')
 mutate_table('source-comparisons.csv',lambda rs:rs.__setitem__(-1,copy.deepcopy(rs[-2])),'duplicate_analysis_row')
 mutate_table('signed-bias-contrasts.csv',lambda rs:rs.pop(),'missing_bias_row')
 mutate_table('source-comparisons.csv',lambda rs:rs[0].update(method='unknown'),'wrong_analysis_method')
 reject('snapshot_mismatch',lambda:m.map_results(sp,analysis,'0'*64,fixture=True))
 reject('absent_terminal',lambda:m.map_results(sp,analysis,digest))
 t={'state':'wall_time_cap','active_processes':0,'observed_utc':'2026-10-30T22:00:00+00:00','analysis_snapshot_sha256':digest}
 for name,change in [('null_terminal_state',{'state':None}),('active_worker',{'active_processes':1}),('boolean_process_count',{'active_processes':False}),('invalid_timestamp',{'observed_utc':['not-a-time']}),('completed_but_incomplete',{'state':'completed'}),('terminal_snapshot_mismatch',{'analysis_snapshot_sha256':'bad'})]:
  record={**t,**change};tp=p/(name+'.json');tp.write_text(json.dumps(record));reject(name,lambda:m.map_results(sp,analysis,digest,terminal_record=tp))
 tp=p/'valid-terminal.json';tp.write_text(json.dumps(t));r=m.map_results(sp,analysis,digest,terminal_record=tp);assert not r['fixture_only'];passed('synthetic_wallcap_terminal_accepts_partial_snapshot_without_success')
 # A fresh snapshot digest must not launder changed analyzer lineage.
 pp=analysis/'provenance.json';old=pp.read_bytes();pr=json.loads(old);ak=next(k for k in pr['files']if k.endswith('simulation/analyze_production.py'));pr['files'][ak]='0'*64;pp.write_text(json.dumps(pr))
 try:reject('wrong_analyzer_provenance',lambda:m.map_results(sp,analysis,m.snapshot_sha(m.snapshot(analysis)),fixture=True))
 finally:pp.write_bytes(old)
assert before==hashlib.sha256((root/'outputs/trial-records.csv').read_bytes()).hexdigest();passed('preserved_baseline_unchanged')
result={'passed':True,'scope':'Preserved baseline and synthetic temporary fixtures only; valid terminal record is synthetic, not actual production evidence.','checks':checks}
pathlib.Path('/tmp/chapter6-mapping-independent-validation.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
