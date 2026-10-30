"""Consolidate all trial-level evidence and compute predeclared paired contrasts."""
import csv,glob,json,pathlib,math,statistics,collections,argparse
import numpy as np
from scipy.stats import t
p=argparse.ArgumentParser();p.add_argument('--include-full',action='store_true');p.add_argument('--output-dir',default='outputs');args=p.parse_args()
OUT=pathlib.Path(args.output_dir)
if args.include_full and OUT.resolve()==pathlib.Path('outputs').resolve():p.error('Continuation summaries require a distinct output directory to preserve baseline')
OUT.mkdir(parents=True,exist_ok=True)
rows=[];errors=[]
files=sorted(glob.glob('outputs/pilot-c6-*-full.csv')+glob.glob('outputs/pilot-c6-*-deletion.csv'))
if args.include_full: files+=sorted(glob.glob('outputs/full-c6-*-full.csv')+glob.glob('outputs/full-c6-*-deletion.csv'))
for f in files:
 trial=pathlib.Path(f).name.split('-r')[-1].split('-')[0]
 for r in csv.DictReader(open(f)):
  if 'error'in r:errors.append(dict(file=f,**r));continue
  r['replicate']=int(trial);r['file']=f
  for k in ['estimate','se','elapsed_seconds','missing']:r[k]=float(r[k])
  for k in ['q','N','seed','status']:r[k]=int(r[k])
  r['path_se']=r['se']/(2*math.sqrt(r['estimate'])) if r['parameter'] in ['A','C','E'] and r['estimate']>0 else ''
  rows.append(r)
# Exact seed/condition/parameter duplicates are the same dataset, not extra replication.
unique={}
for r in rows:
 key=tuple(r[k] for k in ['mechanism','q','missing','seed','parameter','method'])
 if key in unique and any(r[k]!=unique[key][k]for k in ['estimate','se','status']): raise ValueError('Conflicting duplicate: '+str(key))
 unique[key]=r
rows=list(unique.values())
def save(path,rs):
 path=OUT/pathlib.Path(path).name
 if not rs:return
 with open(path,'w')as f:w=csv.DictWriter(f,fieldnames=list(rs[0]));w.writeheader();w.writerows(rs)
save('outputs/trial-records.csv',rows);(OUT/'fit-errors.json').write_text(json.dumps(errors,indent=2))
groups=collections.defaultdict(list)
for r in rows:groups[(r['mechanism'],r['q'],r['missing'],r['parameter'],r['method'])].append(r)
summary=[]
for (mechanism,q,missing,param,method),rs in sorted(groups.items()):
 good=[r for r in rs if r['status']==0];d=dict(mechanism=mechanism,q=q,missing=missing,parameter=param,method=method,requested=len(rs),converged=len(good),failed=len(rs)-len(good))
 for metric in ['estimate','se','path_se']:
  x=[r[metric]for r in good if r[metric]!=''];d[metric+'_mean']=np.mean(x)if x else '';d[metric+'_mcse']=np.std(x,ddof=1)/math.sqrt(len(x))if len(x)>1 else ''
 summary.append(d)
save('outputs/condition-summary.csv',summary)
contrasts=[]
for mechanism,q,missing,param,method in sorted(groups):
 if method!='full' or param not in ['A','C','E']:continue
 full={r['replicate']:r for r in groups[(mechanism,q,missing,param,'full')]if r['status']==0};delete={r['replicate']:r for r in groups[(mechanism,q,missing,param,'deletion')]if r['status']==0};ids=sorted(full.keys()&delete.keys())
 for metric in ['se','path_se']:
  x=np.array([delete[i][metric]-full[i][metric]for i in ids]);n=len(x);mean=float(np.mean(x));mcse=float(np.std(x,ddof=1)/np.sqrt(n))if n>1 else math.nan;family=36 if missing==.03 else 108;half=float(t.ppf(1-.05/(2*family),n-1)*mcse)if n>1 else math.nan
  contrasts.append(dict(mechanism=mechanism,q=q,missing=missing,parameter=param,metric=metric,n=n,contrast_delete_minus_full=mean,mcse=mcse,two_se_low=mean-2*mcse,two_se_high=mean+2*mcse,adjusted_low=mean-half,adjusted_high=mean+half,family_size=family,positive_means='Full-information SE lower',point_sign='positive'if mean>0 else 'nonpositive',band_status='positive'if mean-half>0 else 'negative'if mean+half<0 else 'not separated'))
# Source contrasts are added below after the source vector records are loaded.
source=list(csv.DictReader(open('outputs/source-figure-values.csv')));comparisons=[]
for r in contrasts:
 miss='low' if r['missing'] in [.02,.03] else f"{r['missing']:.2f}".lstrip("0")
 src=[s for s in source if s['measure']=='se' and s['mechanism']==r['mechanism'] and int(s['q'])==r['q'] and s['parameter']==r['parameter'] and s['missing']==miss]
 vals={s['method']:float(s['value'])for s in src}
 r['source_deletion_minus_full']=vals['deletion']-vals['full']
 r['source_positive_means']='Full-information SE lower according to printed labels'
 r['same_point_sign']=(r['contrast_delete_minus_full']>0)==(r['source_deletion_minus_full']>0)
 r['source_uncertainty']='Unknown; point ordering only'
save('outputs/signed-contrasts.csv',contrasts)

for s in source:
 missing=.02 if s['missing']=='low'else float(s['missing']);key=(s['mechanism'],int(s['q']),missing,s['parameter'],s['method'])
 if key not in groups:continue
 good=[r for r in groups[key]if r['status']==0]
 for metric in (['se','path_se']if s['measure']=='se'else['estimate']):
  x=np.array([r[metric]for r in good]);n=len(x);mean=float(np.mean(x));mcse=float(np.std(x,ddof=1)/math.sqrt(n))if n>1 else math.nan;bound=float(s['extraction_bound']);family=216 if s['measure']=='se' else 72;half=float(t.ppf(1-.05/(2*family),n-1)*mcse)+bound if n>1 else math.nan;delta=mean-float(s['value'])
  comparisons.append(dict(figure=s['figure'],mechanism=s['mechanism'],q=s['q'],missing=missing,parameter=s['parameter'],method=s['method'],metric=metric,source=float(s['value']),ours=mean,ours_minus_source=delta,n=n,mcse=mcse,source_extraction_bound=bound,conditional_halfwidth=half,conditional_status='inside'if abs(delta)<=half else 'outside',numerical='not judged: figure has no printed precision',scope='limited',source_MC_uncertainty='not reported',metric_comparable='no: exploratory path-SE reconstruction'if metric=='path_se'else'yes under printed labels',family_size=family))
save('outputs/source-comparisons.csv',comparisons)
# Cost is explicitly an extrapolation, not observed production runtime.
timing=list(csv.DictReader(open('outputs/timing-c5-largest-timing.csv')))[0];rate=(float(timing['burn_seconds'])+float(timing['draw_seconds']))/20
cost={'largest_Chapter5_observed_seconds_per_sampling_iteration':rate,'source_iterations_per_replication':80000,'source_replications':250,'projected_single_worker_days_for_N8000_condition_sampling_only':rate*80000*250/86400,'caveat':'Extrapolated from10burn+10retained iterations; adaptation, compile, parallel scaling and mixing can change cost; not a hard execution denial. Full production remains unresolved.'}
(OUT/'resource-projection.json').write_text(json.dumps(cost,indent=2))
info={'trial_fits':len(set((r['mechanism'],r['q'],r['missing'],r['method'],r['replicate'])for r in rows)),'failed_fit_files':len(errors),'min_replicates':min(r['requested']for r in summary),'max_replicates':max(r['requested']for r in summary),'source_SE_variance_outside':sum(r['conditional_status']=='outside'for r in comparisons if r['metric']=='se'),'source_SE_path_outside':sum(r['conditional_status']=='outside'for r in comparisons if r['metric']=='path_se'),'published_grid_nonpositive_variance_SE_contrasts':sum(r['contrast_delete_minus_full']<=0 for r in contrasts if r['metric']=='se' and r['missing']!=.03),'published_grid_simultaneously_positive_variance_SE_contrasts':sum(r['adjusted_low']>0 for r in contrasts if r['metric']=='se' and r['missing']!=.03),'inventory_groups':len(list(csv.DictReader(open('coverage.csv'))))}
(OUT/'summary.json').write_text(json.dumps(info,indent=2));print(json.dumps(info,indent=2))
