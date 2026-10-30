"""Compare 20 values and inventory all 20 signed scientific contrasts."""
import csv,json,sys
from pathlib import Path
ROOT=Path('formalization/moss-score-reliability')
sys.path.insert(0,'.agents/skills/replication-paper/scripts')
from checks import numerical_verdict,comparability,validate_ledger
from contrast_checks import contrast,validate_inventory,validate_contrast_coverage
read=lambda p:list(csv.DictReader((ROOT/p).open()))
pub={(r['trait'],r['metric']):r for r in read('inputs/published.csv')}
ours={(r['trait'],r['metric']):r for r in read('outputs/results.csv')}
rows=[];comp=[]
for key,p in pub.items():
 o=ours[key];a=float(o['ours']);b=float(p['published']);t,m=key
 common=dict(estimator='normal ML',missingness='trait-wise listwise',n=int(o['n']),normalizer='N',
 mean_structure=False,variable_set=[t+str(i) for i in range(1,6)],df=5,baseline='not used for reliability',robust_correction='none',fit_index='model-based weighted-score reliability')
 c=comparability(common,common,'reliability')
 comp.append(dict(trait=t,metric=m,source=common,ours=common,result=c,
 source_basis='Recovered code and psychTools 1.9.12 data; source N/default engine inferred by replay, not printed in Table3'))
 assert c['verdict_allowed']
 rows.append(dict(trait=t,metric=m,published=b,ours=a,ours_minus_source=a-b,decimals=3,
 numerical=numerical_verdict(b,a,3),scope='limited',reason='Same named data and recovered procedure; historical engine/data snapshot not pinned by thesis.'))
contrasts=[];expected=[]
for t in 'ACENO':
 for a,b,role in [('sigma','R','headline'),('sigma','S','headline'),('H','sigma','supporting'),('S','R','supporting')]:
  name=a+'-minus-'+b;expected.append((name,t))
  s=float(pub[t,a]['published'])-float(pub[t,b]['published'])
  o=float(ours[t,a]['ours'])-float(ours[t,b]['ours'])
  definition=f'{a} minus {b}, reliability units; positive favors {a}, conditional on the fitted model'
  contrasts.append(dict(analysis=name,condition=t,claim=t+': '+definition,role=role,kind='contrast',
    source_contrast=s,ours_contrast=o,ours_minus_source_contrast=o-s,
    source_rounding_bound=.001,numerical='withheld',scope='limited',
    uncertainty_decision='Descriptive only; source contrast is difference of rounded cells, not independently printed precision; no population CI',
    **contrast(s,o,definition)))
errors=validate_inventory(contrasts)+validate_contrast_coverage(contrasts,expected)
ind=read('outputs/independent.csv'); replay=read('outputs/original-replay.csv')
summary=dict(values=len(rows),matches=sum(r['numerical']=='match' for r in rows),
 max_absolute_rounding_gap=max(abs(r['ours_minus_source']) for r in rows),
 contrasts=len(contrasts),point_reversals=sum(r['point_reversal'] for r in contrasts),
 max_openmx_gap=max(abs(float(r['difference'])) for r in ind),
 max_covariance_gap=max(float(r['max_covariance_gap']) for r in ind),
 max_original_replay_gap=max(abs(float(r['replay'])-float(ours[r['trait'],r['metric']]['ours'])) for r in replay),
 errors=errors)
for name,obj in [('comparison',rows),('comparability',comp),('contrasts',contrasts),('validation',summary)]:
 (ROOT/'outputs'/f'{name}.json').write_text(json.dumps(obj,indent=2)+'\n')
assert not errors
assert len(rows)==20 and all(r['numerical']=='match' for r in rows)
assert summary['max_openmx_gap']<1e-5 # diagnostic: 1% of one printed .001 unit
print(json.dumps(summary,indent=2))
