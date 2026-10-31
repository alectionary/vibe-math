import csv,gzip,json,hashlib,math,datetime
from pathlib import Path
import numpy as np
from scipy.stats import t
P=Path('.'); D=P/'production/chapter6-v1/terminal-analysis'; R=P/'production/chapter6-v1/reports'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def rows(p):return list(csv.DictReader(open(p)))
def key(r):return (r['mechanism'],int(r['q']),float(r['missing']),r['method'],r['parameter'])
def close(a,b):
 assert math.isclose(float(a),float(b),rel_tol=2e-11,abs_tol=2e-13),(a,b)
groups={key(r):np.full((1000,3),np.nan) for r in rows(D/'condition-summary.csv')}; seen=set(); count=0
with gzip.open(R/'guarded-trials.csv.gz','rt') as f:
 for r in csv.DictReader(f):
  k=key(r); rep=int(r['replicate']); ident=k+(rep,); assert ident not in seen;seen.add(ident)
  assert r['valid']=='TRUE' and not r['invalid_reasons'];assert (r['baseline_replay']=='True')==(rep<20)
  assert int(r['seed'])==34000+48*rep+['MCAR','MAR','MNAR'].index(k[0])*16+(k[1]-2)*4+[.02,.03,.06,.1].index(k[2])
  e,s=float(r['estimate']),float(r['se']); close(s*s,r['delta_variance'])
  groups[k][rep]=[e,s,s/(2*math.sqrt(e)) if k[4] in 'ACE' else np.nan];count+=1
assert count==720000 and len(groups)==720
ledger=set();replays=0
with gzip.open(R/'checkpoint-ledger.jsonl.gz','rt') as f:
 for line in f:
  r=json.loads(line);j=r['job'];k=(j['mechanism'],j['q'],j['missing'],j['replicate']);assert k not in ledger;ledger.add(k)
  assert r['state']=='completed' and r['process_returncode']==0
  assert all(x['valid'] and not x['invalid_reasons'] for x in r['outputs']['methods'].values());replays+=j['baseline_replay']
assert len(ledger)==48000 and replays==960
for r in rows(D/'condition-summary.csv'):
 a=groups[key(r)];truth={'A':.5,'C':.3,'E':.2,'h2':.5}.get(r['parameter'],math.sqrt(.64/(int(r['q'])*(2+.6*(int(r['q'])-1)))))
 close(truth,r['generating_truth']); assert np.isfinite(a[:,:2]).all()
 for i,m in enumerate(['estimate','se','path_se']):
  if i==2 and r['parameter'] not in 'ACE':continue
  close(a[:,i].mean(),r[m+'_mean']);close(a[:,i].std(ddof=1),r[m+'_sd']);close(a[:,i].std(ddof=1)/math.sqrt(1000),r[m+'_mcse']);assert int(r[m+'_n'])==1000
 close(a[:,0].mean()-truth,r['bias']);close(np.sqrt(np.mean((a[:,0]-truth)**2)),r['rmse'])
source={ (r['mechanism'],int(r['q']),(.02 if r['missing']=='low' else float(r['missing'])),r['method'],r['parameter'],r['measure']):r for r in rows(P/'outputs/source-figure-values.csv') }; assert len(source)==288
paired=rows(D/'signed-SE-contrasts.csv'); positive=0
for r in paired:
 k=(r['mechanism'],int(r['q']),float(r['missing']));p=r['parameter'];i=1 if r['metric']=='se' else 2
 x=groups[k+('deletion',p)][:,i]-groups[k+('full',p)][:,i];mu=x.mean();se=x.std(ddof=1)/math.sqrt(1000);family=36 if k[2]==.03 else 108;h=t.ppf(1-.05/(2*family),999)*se
 for field,val in [('contrast_delete_minus_full',mu),('sd',x.std(ddof=1)),('mcse',se),('adjusted_low',mu-h),('adjusted_high',mu+h)]:close(val,r[field])
 assert int(r['valid_pairs'])==1000 and int(r['family_size'])==family
 if k[2]!=.03:
  s1=source[k+('deletion',p,'se')];s2=source[k+('full',p,'se')];close(float(s1['value'])-float(s2['value']),r['source_deletion_minus_full']);close(float(s1['extraction_bound'])+float(s2['extraction_bound']),r['source_contrast_extraction_bound'])
 if i==1 and k[2]!=.03:positive+=mu-h>0
assert positive==108
outside={'se':0,'path_se':0,'estimate':0}
for r in rows(D/'source-comparisons.csv'):
 k=key(r);m=r['metric'];s=source[k+('estimate' if m=='estimate' else 'se',)];assert r['figure']==s['figure'];close(s['value'],r['source']);close(s['extraction_bound'],r['source_extraction_bound'])
 i={'estimate':0,'se':1,'path_se':2}[m];a=groups[k][:,i];mu=a.mean();se=a.std(ddof=1)/math.sqrt(1000);family=72 if m=='estimate' else 216;delta=mu-float(s['value']);h=t.ppf(1-.05/(2*family),999)*se+float(s['extraction_bound'])
 for field,val in [('ours',mu),('ours_minus_source',delta),('mcse',se),('conditional_halfwidth',h),('conditional_adjusted_low',delta-h),('conditional_adjusted_high',delta+h)]:close(val,r[field])
 out=abs(delta)>h;assert (r['conditional_status']=='outside')==out;outside[m]+=out
reversals=exclusions=0
for r in rows(D/'signed-bias-contrasts.csv'):
 a=groups[key(r)][:,0];truth=float(r['generating_truth']);b=a.mean()-truth;sb=float(r['source_estimate'])-truth;se=a.std(ddof=1)/math.sqrt(1000);h=t.ppf(1-.05/144,999)*se
 for field,val in [('ours_bias_estimate_minus_truth',b),('source_bias_estimate_minus_truth',sb),('adjusted_low',b-h),('adjusted_high',b+h)]:close(val,r[field])
 rev=b*sb<0;assert (r['point_sign_reversal']=='True')==rev;reversals+=rev;exclusions+=rev and abs(b)>h
assert outside['se']==216 and outside['path_se']==20 and reversals==11 and exclusions==0
mapping=json.load(open('handoff/chapter6-result-mapping.json')); hashes={f:sha(D/f) for f in mapping['analysis_file_sha256']};assert hashes==mapping['analysis_file_sha256'];snap=hashlib.sha256(json.dumps(hashes,sort_keys=True,separators=(',',':')).encode()).hexdigest();assert snap==mapping['analysis_snapshot_sha256']
claims=mapping['claims'];assert len(claims)==len({r['claim_id'] for r in claims})==408
for f,h in [('simulation/analyze_production.py',mapping['analyzer_sha256']),('simulation/build_production_report.py',mapping['builder_validation_sha256']),('handoff/map_chapter6_results.py',mapping['mapper_sha256'])]:assert sha(f)==h
out={'reviewed_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'scope':'Independent terminal arithmetic and scientific-interpretation review; no model fits, no manuscript/editorial approval.','result':'accepted_with_explicit_scientific_limits','checks':{'raw_parameter_rows':count,'unique_datasets':len(ledger),'method_fits':96000,'baseline_replay_datasets':replays,'new_datasets':len(ledger)-replays,'parameter_groups_recomputed':720,'paired_contrasts_recomputed':len(paired),'primary_adjusted_positive':int(positive),'source_comparisons_recomputed':504,'source_conditional_outside':{k:int(v) for k,v in outside.items()},'MAR_bias_recomputed':72,'MAR_point_reversals':int(reversals),'MAR_reversals_adjusted_excluding_zero':int(exclusions),'mapped_unique_source_ids':len(claims)},'analysis_snapshot_sha256':snap,'analysis_file_sha256':hashes,'input_sha256':{str(p):sha(p) for p in [R/'guarded-trials.csv.gz',R/'checkpoint-ledger.jsonl.gz',R/'condition-counts.csv',P/'outputs/source-figure-values.csv',P/'production/analysis-plan.json',P/'handoff/chapter6-result-mapping.json',P/'simulation/analyze_production.py',P/'simulation/build_production_report.py',P/'handoff/map_chapter6_results.py']},'findings':[],'limits':[]}
Path('/tmp/terminal-review-numeric.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out['checks'],indent=2))

import json,csv,hashlib
from pathlib import Path
m=json.load(open('handoff/chapter6-result-mapping.json'));s=json.load(open('handoff/claim-specification.json'));spec={c['id']:c for c in s['claims']};D=Path(m['analysis_directory']);D=Path('production/chapter6-v1/terminal-analysis')
tables={p.name:list(csv.DictReader(p.open())) for p in D.glob('*.csv')};counts={};seen={}
def walk(x):
 if isinstance(x,dict):
  if 'table' in x and 'row_key' in x and 'row' in x:
   matches=[r for r in tables[x['table']] if all(str(r[k])==str(v) for k,v in x['row_key'].items())];assert len(matches)==1,(x['table'],x['row_key']);assert matches[0]==x['row'];counts[x['table']]=counts.get(x['table'],0)+1;seen.setdefault(x['table'],set()).add(tuple(sorted(x['row_key'].items())))
   if x.get('computed_value') is not None:assert float(x['row'][x['value_field']])==x['computed_value']
  for v in x.values():walk(v)
 elif isinstance(x,list):
  for v in x:walk(v)
for c in m['claims']:
 src=spec[c['claim_id']]
 for k in ['published','conditions','source_locator','parent_claim_ids','component_claim_ids','component_contrast_refs']:assert c[k]==src[k],(c['claim_id'],k)
 assert c['adjudication_required'] and 'status' not in c
 if c['computed_value'] is None:assert c['missing_reason']
walk(m)
p=json.load(open(D/'provenance.json'))
for f,h in p['files'].items():assert hashlib.sha256(Path(f).read_bytes()).hexdigest()==h,f
print(json.dumps({'mapped_row_occurrences':counts,'unique_mapped_rows':{k:len(v) for k,v in seen.items()},'all_source_fields_preserved':True,'all_frozen_input_hashes_verified':True},indent=2))
Path('/tmp/terminal-mapcheck.json').write_text(json.dumps({'mapped_row_occurrences':counts,'unique_mapped_rows':{k:len(v) for k,v in seen.items()},'all_source_fields_preserved':True,'all_frozen_input_hashes_verified':True},indent=2))
