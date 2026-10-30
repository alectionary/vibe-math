"""Frozen-plan analysis of guarded Chapter6 exports. Never controls fit dispatch."""
import argparse,collections,csv,gzip,hashlib,itertools,json,math,pathlib,sys
import numpy as np
from scipy.stats import t
MECH=('MCAR','MAR','MNAR'); MISS=(.02,.03,.06,.1); METHODS=('full','deletion')
def digest(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
def iter_csv(p):
 with (gzip.open(p,'rt',newline='')if str(p).endswith('.gz')else open(p,newline=''))as f:yield from csv.DictReader(f)
def read_csv(p):return list(iter_csv(p))
def flag(x):
 if str(x).lower()not in ('true','false','1','0'):raise ValueError('Nonboolean flag')
 return str(x).lower()in ('true','1')
def cond(r):return (r['mechanism'],int(r['q']),float(r['missing']))
def expected_seed(c,rep):return 34000+rep*48+MECH.index(c[0])*16+(c[1]-2)*4+MISS.index(c[2])
def parameters(q):return ['A','C','E','h2']+['beta'+str(k)for k in range(1,q+1)]
def truth(param,q):return {'A':.5,'C':.3,'E':.2,'h2':.5}.get(param,math.sqrt(.64/(q*(2+.6*(q-1)))))
def stats(x,family=None):
 x=np.asarray(x,dtype=float);n=len(x)
 if not np.all(np.isfinite(x)):raise ValueError('Nonfinite valid numeric values')
 mean=float(x.mean())if n else None;sd=float(x.std(ddof=1))if n>=2 else None;mcse=sd/math.sqrt(n)if sd is not None else None
 d=dict(n=n,mean=mean,sd=sd,mcse=mcse)
 if family:
  half=float(t.ppf(1-.05/(2*family),n-1)*mcse)if n>=2 else None
  d.update(two_se_low=mean-2*mcse if mcse is not None else None,two_se_high=mean+2*mcse if mcse is not None else None,adjusted_low=mean-half if half is not None else None,adjusted_high=mean+half if half is not None else None,adjusted_halfwidth=half)
 return d
def write_csv(p,rows):
 if not rows:return
 with open(p,'w',newline='')as f:
  w=csv.DictWriter(f,fieldnames=list(rows[0]),lineterminator='\n');w.writeheader();w.writerows(rows)
def analyze(reports,output,source_path,plan_path):
 reports=pathlib.Path(reports).resolve();output=pathlib.Path(output).resolve();source_path=pathlib.Path(source_path).resolve();plan_path=pathlib.Path(plan_path).resolve()
 if output==reports or output==pathlib.Path('outputs').resolve():raise ValueError('Use a distinct analysis output directory; baseline/input overwrite forbidden')
 if output.exists()and any(output.iterdir()):raise ValueError('Analysis output already exists; preserve it and use a fresh directory')
 plan=json.load(open(plan_path));assert plan['version']=='chapter6-guarded-analysis-v1'
 export=json.load(open(reports/'export.json'))
 for name in ['guarded-trials.csv.gz','checkpoint-ledger.jsonl.gz']:
  if export.get('files',{}).get(name)!=digest(reports/name):raise ValueError('Export digest mismatch: '+name)
 expected_conditions=list(itertools.product(MECH,range(2,6),MISS));expected_methods=[(*c,m)for c in expected_conditions for m in METHODS]
 countrows=read_csv(reports/'condition-counts.csv');counts={}
 fields=('requested','completed','guard_valid','guard_invalid','process_failed','in_flight_or_uncheckpointed')
 for r in countrows:
  k=(*cond(r),r['method'])
  if k not in expected_methods or k in counts:raise ValueError('Unexpected/duplicate condition denominator')
  d={x:int(r[x])for x in fields};d['target']=int(r['target'])
  if d['target']!=1000 or any(v<0 for v in d.values())or d['requested']>1000:raise ValueError('Invalid requested denominator')
  if d['completed']!=d['guard_valid']+d['guard_invalid']or d['requested']!=d['completed']+d['process_failed']+d['in_flight_or_uncheckpointed']:raise ValueError('Denominator partition failed')
  counts[k]=d
 for k in expected_methods:counts.setdefault(k,dict(target=1000,**{f:0 for f in fields}))
 ledger={};identities=set();ledger_counts=collections.Counter();failed_records=[]
 with gzip.open(reports/'checkpoint-ledger.jsonl.gz','rt')as f:
  for line in f:
   r=json.loads(line);j=r['job'];c=cond(j);rep=int(j['replicate']);key=(*c,rep)
   if c not in expected_conditions or not 0<=rep<1000 or int(j['seed'])!=expected_seed(c,rep)or not isinstance(j['baseline_replay'],bool)or j['baseline_replay']!=(rep<20):raise ValueError('Wrong condition/seed/baseline classification')
   if int(j.get('N',0))!=1000 or j.get('beta_shape')!='equal' or j['tag']!=f'production-c6-{c[0]}-q{c[1]}-m{c[2]}-r{rep}':raise ValueError('Wrong ledger design/tag')
   if key in ledger:raise ValueError('Duplicate dataset checkpoint; retry selection requires separate audited policy')
   identities.add(json.dumps(r['identity'],sort_keys=True));ledger[key]=r
   if r['state']=='completed':
    if r.get('process_returncode')!=0 or r['outputs'].get('process_error'):raise ValueError('Completed ledger has process error')
    if set(r['outputs']['methods'])!=set(METHODS):raise ValueError('Missing method ledger')
    for m in METHODS:
     ledger_counts[(*c,m,'completed')]+=1;ledger_counts[(*c,m,'guard_valid'if flag(r['outputs']['methods'][m]['valid'])else'guard_invalid')]+=1
   elif r['state']=='process_failed_or_interrupted':
    failed_records.append(r)
    for m in METHODS:ledger_counts[(*c,m,'process_failed')]+=1
   else:raise ValueError('Unknown checkpoint state')
 if len(identities)>1:raise ValueError('Mixed frozen identities')
 for k,d in counts.items():
  for field in ('completed','guard_valid','guard_invalid','process_failed'):
   if ledger_counts[(*k,field)]!=d[field]:raise ValueError('Ledger/denominator mismatch: '+str((*k,field)))
 groups=collections.defaultdict(dict);fit_params=collections.defaultdict(set);invalid_rows=[]
 for r in iter_csv(reports/'guarded-trials.csv.gz'):
  c=cond(r);rep=int(r['replicate']);m=r['method'];param=r['parameter'];key=(*c,rep);fitkey=(*c,rep,m)
  if key not in ledger or ledger[key]['state']!='completed' or m not in METHODS:raise ValueError('Unverified or unknown fit row')
  j=ledger[key]['job'];expected=ledger[key]['outputs']['methods'][m]
  if int(r['seed'])!=int(j['seed'])or int(r['N'])!=1000 or r['tag']!=j['tag']or flag(r['baseline_replay'])!=(rep<20):raise ValueError('Row/ledger identity mismatch')
  if param not in parameters(c[1])or param in fit_params[fitkey]:raise ValueError('Duplicate/unexpected parameter row')
  fit_params[fitkey].add(param);valid=flag(r['valid'])
  if valid!=flag(expected['valid'])or r['invalid_reasons']!=expected['invalid_reasons']:raise ValueError('Row/ledger validity mismatch')
  if 'status'in expected and str(r['status'])!=str(expected['status']):raise ValueError('Row/ledger optimizer status mismatch')
  if valid:
   if int(r['status'])!=0 or r['invalid_reasons']:raise ValueError('Contradictory guard-valid row')
   est=float(r['estimate']);se=float(r['se']);delta=float(r['delta_variance'])
   if not all(math.isfinite(v)for v in [est,se,delta,float(r['minus2loglik'])])or se<=0 or delta<0 or not math.isclose(se*se,delta,rel_tol=1e-10,abs_tol=1e-14):raise ValueError('Invalid numeric guard-valid row')
   if param in ('A','C','E')and est<=0:raise ValueError('Nonpositive variance estimate')
   groups[(*c,m,param)][rep]={'estimate':est,'se':se,'path_se':se/(2*math.sqrt(est))if param in ('A','C','E')else None}
  else:invalid_rows.append(dict(mechanism=c[0],q=c[1],missing=c[2],replicate=rep,method=m,parameter=param,invalid_reasons=r['invalid_reasons'],error=r.get('error','')))
 for key,r in ledger.items():
  if r['state']=='completed':
   for m in METHODS:
    if fit_params[(*key,m)]!=set(parameters(key[1])):raise ValueError('Missing parameter row in completed fit')
 for c,m in itertools.product(expected_conditions,METHODS):
  for param in parameters(c[1]):
   if len(groups[(*c,m,param)])!=counts[(*c,m)]['guard_valid']:raise ValueError('Valid numeric/denominator mismatch')
 source=read_csv(source_path)
 if len(source)!=288:raise ValueError('Expected all288 source curve coordinates')
 index={}
 for s in source:
  missing=.02 if s['missing']=='low'else float(s['missing']);k=(s['mechanism'],int(s['q']),missing,s['method'],s['parameter'],s['measure'])
  if k in index:raise ValueError('Duplicate source cell')
  expected_figure={'MCAR':'6.3','MAR':'6.4','MNAR':'6.6'}.get(s['mechanism'])if s['measure']=='se'else'6.5'
  if s['figure']!=expected_figure or not math.isfinite(float(s['value']))or not math.isfinite(float(s['extraction_bound']))or float(s['extraction_bound'])<0:raise ValueError('Invalid source figure/value/extraction bound')
  index[k]=s
 expected_source=set((mech,q,miss,m,param,'se')for mech,q,miss,m,param in itertools.product(MECH,range(2,6),(.02,.06,.1),METHODS,('A','C','E')))
 expected_source.update(('MAR',q,miss,m,param,'estimate')for q,miss,m,param in itertools.product(range(2,6),(.02,.06,.1),METHODS,('A','C','h2')))
 if set(index)!=expected_source:raise ValueError('Source condition inventory mismatch')
 def denominators(c,m):return dict(counts[(*c,m)],not_yet_requested=1000-counts[(*c,m)]['requested'])
 summaries=[]
 for c in expected_conditions:
  for m in METHODS:
   for param in parameters(c[1]):
    rs=groups[(*c,m,param)];xs=[r['estimate']for r in rs.values()];tr=truth(param,c[1]);row=dict(mechanism=c[0],q=c[1],missing=c[2],method=m,parameter=param,generating_truth=tr,**denominators(c,m))
    for metric in ('estimate','se','path_se'):
     ss=stats([r[metric]for r in rs.values()if r[metric]is not None]);row.update({metric+'_'+k:v for k,v in ss.items()})
    row.update(bias=row['estimate_mean']-tr if xs else None,rmse=float(np.sqrt(np.mean((np.asarray(xs)-tr)**2)))if xs else None,scope='Conditional on guard-valid fits; all requested denominators retained')
    summaries.append(row)
 contrasts=[]
 for c in expected_conditions:
  for param in ('A','C','E'):
   full=groups[(*c,'full',param)];dele=groups[(*c,'deletion',param)];ids=sorted(full.keys()&dele.keys());requested=counts[(*c,'full')]['requested']
   if requested!=counts[(*c,'deletion')]['requested']:raise ValueError('Method request sets differ')
   sc=(*c[:2],.02 if c[2]==.03 else c[2]);sv={m:float(index[(*sc,m,param,'se')]['value'])for m in METHODS};bound=sum(float(index[(*sc,m,param,'se')]['extraction_bound'])for m in METHODS);source_contrast=sv['deletion']-sv['full']
   for metric in ('se','path_se'):
    family=36 if c[2]==.03 else 108;ss=stats([dele[i][metric]-full[i][metric]for i in ids],family);mean=ss['mean'];row=dict(mechanism=c[0],q=c[1],missing=c[2],parameter=param,metric=metric,target_pairs=1000,requested_pairs=requested,valid_pairs=len(ids),excluded_or_pending_pairs=requested-len(ids),not_yet_requested_pairs=1000-requested,full_valid=len(full),deletion_valid=len(dele),contrast_delete_minus_full=mean,source_deletion_minus_full=source_contrast,source_contrast_extraction_bound=bound,source_sign_robust_to_extraction=abs(source_contrast)>bound,point_sign_reversal=(mean*source_contrast<0)if mean is not None else None,positive_means='Full-information estimated SE lower',family_size=family,alpha=.05,correction='Bonferroni Student t; path metric exploratory',source_scope='Source point ordering only; .03 compares alternative reading of same low-missing curve'if c[2]==.03 else'Source point ordering only; unknown source Monte Carlo error',**{k:v for k,v in ss.items()if k not in ('mean','n')})
    row['adjusted_status']='positive'if ss['adjusted_low']is not None and ss['adjusted_low']>0 else'negative'if ss['adjusted_high']is not None and ss['adjusted_high']<0 else'not separated'if ss['adjusted_low']is not None else'not estimable';contrasts.append(row)
 comparisons=[];biases=[]
 for s in source:
  c=(s['mechanism'],int(s['q']),.02 if s['missing']=='low'else float(s['missing']));m=s['method'];param=s['parameter'];rs=groups[(*c,m,param)];bound=float(s['extraction_bound']);val=float(s['value'])
  for metric in (('se','path_se')if s['measure']=='se'else('estimate',)):
   family=216 if metric!='estimate' else 72;ss=stats([r[metric]for r in rs.values()],family);dev=ss['mean']-val if ss['mean']is not None else None;half=ss['adjusted_halfwidth']+bound if ss['adjusted_halfwidth']is not None else None
   comparisons.append(dict(figure=s['figure'],mechanism=c[0],q=c[1],missing=c[2],method=m,parameter=param,metric=metric,**denominators(c,m),n=ss['n'],source=val,ours=ss['mean'],ours_minus_source=dev,mcse=ss['mcse'],source_extraction_bound=bound,two_se_low=dev-2*ss['mcse']-bound if ss['mcse']is not None else None,two_se_high=dev+2*ss['mcse']+bound if ss['mcse']is not None else None,conditional_adjusted_low=dev-half if half is not None else None,conditional_adjusted_high=dev+half if half is not None else None,conditional_halfwidth=half,conditional_status='inside'if half is not None and abs(dev)<=half else'outside'if half is not None else'not estimable',family_size=family,alpha=.05,numerical='withheld: figure has no printed precision',metric_comparable='no: exploratory different-estimand path-SE reconstruction'if metric=='path_se'else'yes under printed source labels',source_MC_uncertainty='Unknown; conditional band is not a complete two-sample comparison'))
  if s['measure']=='estimate':
   tr=truth(param,c[1]);ss=stats([r['estimate']-tr for r in rs.values()],72);sb=val-tr;ob=ss['mean'];biases.append(dict(figure=s['figure'],mechanism=c[0],q=c[1],missing=c[2],method=m,parameter=param,**denominators(c,m),generating_truth=tr,source_estimate=val,ours_estimate=ob+tr if ob is not None else None,source_bias_estimate_minus_truth=sb,ours_bias_estimate_minus_truth=ob,positive_means='Overestimation of generating truth',point_sign_reversal=sb*ob<0 if ob is not None else None,source_extraction_bound=bound,source_sign_robust_to_extraction=abs(sb)>bound,ours_minus_source=ob+tr-val if ob is not None else None,family_size=72,alpha=.05,**{k:v for k,v in ss.items()if k!='mean'},scope='Exploratory signed bias; source Monte Carlo uncertainty unknown'))
 inventory={'condition_methods':len(counts),'parameter_groups':len(summaries),'paired_SE_contrasts':len(contrasts),'source_comparisons':len(comparisons),'MAR_signed_bias_cells':len(biases)}
 if inventory!=plan['inventory']:raise ValueError('Analysis inventory incomplete')
 requested=sum(d['requested']for d in counts.values());completed=sum(d['completed']for d in counts.values());valid=sum(d['guard_valid']for d in counts.values());invalid=sum(d['guard_invalid']for d in counts.values())
 summary=dict(target_method_fits=96000,requested_method_fits=requested,completed_method_fits=completed,guard_valid_method_fits=valid,guard_invalid_method_fits=invalid,process_failed_method_slots=sum(d['process_failed']for d in counts.values()),in_flight_or_uncheckpointed_method_slots=sum(d['in_flight_or_uncheckpointed']for d in counts.values()),not_yet_requested_method_slots=96000-requested,guarded_baseline_replay_datasets=sum(r['state']=='completed'and r['job']['baseline_replay']for r in ledger.values()),new_completed_datasets=sum(r['state']=='completed'and not r['job']['baseline_replay']for r in ledger.values()),complete_attempted_grid=completed==96000,all_fits_guard_valid=valid==96000,inventory=inventory,source_variance_SE_outside=sum(r['conditional_status']=='outside'for r in comparisons if r['metric']=='se'),source_path_SE_outside=sum(r['conditional_status']=='outside'for r in comparisons if r['metric']=='path_se'),primary_variance_SE_positive_points=sum(r['contrast_delete_minus_full']is not None and r['contrast_delete_minus_full']>0 for r in contrasts if r['metric']=='se'and r['missing']!=.03),primary_variance_SE_adjusted_positive=sum(r['adjusted_status']=='positive'for r in contrasts if r['metric']=='se'and r['missing']!=.03),MAR_bias_point_reversals=sum(r['point_sign_reversal']is True for r in biases),MAR_bias_reversals_with_adjusted_ours_excluding_zero=sum(r['point_sign_reversal']is True and r['adjusted_low']is not None and(r['adjusted_low']>0 or r['adjusted_high']<0)for r in biases),interpretation='Conditional valid-fit summaries; full failure denominators visible. Interim fixed-n descriptive intervals, not sequential tests, equivalence or power. Whole dissertation remains incomplete.')
 output.mkdir(parents=True,exist_ok=True)
 for filename,rows in [('condition-summary.csv',summaries),('signed-SE-contrasts.csv',contrasts),('source-comparisons.csv',comparisons),('signed-bias-contrasts.csv',biases),('invalid-parameter-rows.csv',invalid_rows)]:write_csv(output/filename,rows)
 (output/'process-failures.json').write_text(json.dumps(failed_records,indent=2)+'\n');(output/'summary.json').write_text(json.dumps(summary,indent=2,allow_nan=False)+'\n')
 inputs=[reports/n for n in ['guarded-trials.csv.gz','checkpoint-ledger.jsonl.gz','condition-counts.csv','export.json']]+[source_path,plan_path,pathlib.Path(__file__).resolve()]
 (output/'provenance.json').write_text(json.dumps({'files':{str(p):digest(p)for p in inputs},'plan_version':plan['version'],'frozen_identity':json.loads(next(iter(identities)))if identities else None,'output_scope':'Separate guarded continuation; baseline originals untouched; full inventory retained'},indent=2)+'\n')
 return summary

def main():
 p=argparse.ArgumentParser();p.add_argument('--reports',required=True);p.add_argument('--output-dir',required=True);p.add_argument('--source',default='outputs/source-figure-values.csv');p.add_argument('--plan',default='production/analysis-plan.json');a=p.parse_args();print(json.dumps(analyze(a.reports,a.output_dir,a.source,a.plan),indent=2))
if __name__=='__main__':main()
