"""Compare fresh all-size sector curves to factual source figure coordinates."""
import json,collections
from scipy.stats import beta
from analyze_families import R,combine
source=json.loads((R/'source-crossovers.json').read_text());m=sum(len(c['points']) for c in source['curves']);alpha=.05/m
lookup={};summaries=[]
for name in json.loads((R/'broad-plan.json').read_text())['configs']:
 data=json.loads((R/name.replace('-config.json','.json')).read_text());assert data['complete'],name
 for row in combine(data['rows']):lookup[row['code'],row['axis'],row['L'],row['deformed'],round(row['p'],5)]=row
 summaries.append(dict(config=name,trials=sum(r['shots'] for r in data['rows']),invalid=sum(r['invalid'] for r in data['rows']),seconds=sum(r['seconds'] for r in data['rows'])))
comparisons=[]
for c in source['curves']:
 for p in c['points']:
  key=c['code'],c['axis'],c['L'],c['deformed'],round(round(p['p']/.005)*.005,5);r=lookup[key];k=r[dict(total='failures',point='point_failures',loop='loop_failures')[c['sector']]];n=r['shots']
  lo=float(beta.ppf(alpha/2,k,n-k+1)) if k else 0;hi=float(beta.ppf(1-alpha/2,k+1,n-k)) if k<n else 1
  # Below the visible .01 boundary, the plotted point supplies only an upper bound.
  ulo=float(beta.ppf(.025,k,n-k+1)) if k else 0;uhi=float(beta.ppf(.975,k+1,n-k)) if k<n else 1
  visible=p['within_vertical_clip'];sl=max(0,p['failure']-.005) if visible else 0;sh=min(1,p['failure']+.005) if visible else .015
  comparisons.append(dict(code=c['code'],axis=c['axis'],L=c['L'],deformed=c['deformed'],sector=c['sector'],p=r['p'],source=p['failure'],source_visible=visible,source_interval=[sl,sh],ours=k/n,failures=k,shots=n,unadjusted_interval=[ulo,uhi],unadjusted_outside=uhi<sl or ulo>sh,simultaneous_interval=[lo,hi],outside=hi<sl or lo>sh))
result=dict(family_size=m,alpha=.05,method='Bonferroni two-sided Clopper-Pearson intervals for fresh binomial counts; factual source extraction interval +/- .005, below-axis points conservatively [0,.015]. Source Monte Carlo uncertainty unknown: outside is descriptive incompatibility with digitized value, not a test of scientific reproducibility.',runs=summaries,comparisons=comparisons,outside=sum(x['outside'] for x in comparisons),visible=sum(x['source_visible'] for x in comparisons))
(R/'curve-analysis.json').write_text(json.dumps(result,indent=2)+'\n');print({k:v for k,v in result.items() if k!='comparisons'})
