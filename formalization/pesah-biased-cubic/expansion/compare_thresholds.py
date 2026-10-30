"""All source-supported signed contrasts; original fits retained as primary."""
import json,sys,pathlib
from decimal import Decimal,ROUND_HALF_UP
from scipy.stats import norm
from analyze_families import R
sys.path.insert(0,str(R.parents[2]/'.agents/skills/replication-paper/scripts'))
from contrast_checks import contrast,source_band,validate_contrast_coverage
source=json.loads((R/'source-bias-curves.json').read_text())['records'];families=[]
for code in ['cubic','rhombic']:
 for axis in ['X','Z']:
  for eta in [1,3,10,30,100]:
   points=[next(x for x in source if x['code']==code and x['axis']==axis and x['deformed']==d and x['bias_label']==str(eta)) for d in [False,True]]
   families.append((f'{code}-{axis}-eta{eta}',[x['threshold'] for x in points],.001,'figure'))
for name,values in [('cubic-depolarizing',[.043,.042]),('rhombic-depolarizing',[.015,.017]),('rhombic-X-pure',[.01,.017]),('rhombic-Z-pure',[.284,.065]),('sweep-X',[.029,.071]),('sweep-Z',[.147,.222]),('sweep-depolarizing',[.044,.047])]:families.append((name,values,.0005,'table'))
rows=[];contrasts=[]
def verdict(ours,src,kind):
 if kind=='figure':return 'withheld: figure extraction is not original rounding precision'
 q=lambda v:Decimal(str(v*100)).quantize(Decimal('.1'),rounding=ROUND_HALF_UP)
 difference=abs(q(ours)-q(src));return 'match' if difference==0 else 'close' if difference==Decimal('.1') else 'mismatch'
for name,values,bound,kind in families:
 a=json.loads((R/f'{name}-analysis.json').read_text());b=json.loads((R/f'{name}-normalized-analysis.json').read_text());s=values+[values[1]-values[0]]
 for i,label in enumerate(['U','D','D-U']):
  ours=a['thresholds_and_D_minus_U'][i];se=a['standard_errors'][i];issues=[]
  if a['bootstrap']['failed'] or a['bootstrap']['boundaries']:issues.append('bootstrap fits failed or reached bounds')
  if any(f['boundary'] for f in a['fits']):issues.append('primary boundary fit')
  if any(f.get('outside_prediction_range') or f.get('nonmonotone') or not f.get('inside_sampled_probability_window',True) for f in b['fits']):issues.append('normalized diagnostic physically invalid or outside grid')
  band=source_band(ours-s[i],se,bound*(2 if i==2 else 1),82)
  band['unadjusted_endpoints']=[ours-s[i]-norm.ppf(.975)*se-bound*(2 if i==2 else 1),ours-s[i]+norm.ppf(.975)*se+bound*(2 if i==2 else 1)]
  band['inference']='withheld: '+ '; '.join(issues) if issues else 'Approximate conditional normal band using bootstrap SE; model, source MC error and historical-setting uncertainty excluded.'
  row=dict(family=name,quantity=label,source=s[i],ours=ours,deviation_ours_minus_source=ours-s[i],normalized_diagnostic=b['thresholds_and_D_minus_U'][i],numerical=verdict(ours,s[i],kind) if i<2 else 'withheld: difference of rounded/extracted inputs',scope='limited',conditional_band=band)
  rows.append(row)
  if i==2:contrasts.append(dict(analysis=name,condition='D-U',**contrast(s[i],ours,'Deformed minus undeformed threshold, probability; positive favors deformation.')))
z=json.loads((R/'pure-z-analysis.json').read_text());ours=z['fits']['False:failures']['primary']['threshold'];se=z['undeformed_bootstrap']['standard_error'];band=source_band(ours-.217,se,.0005,82);band['unadjusted_endpoints']=[ours-.217-norm.ppf(.975)*se-.0005,ours-.217+norm.ppf(.975)*se+.0005];band['inference']='Conditional approximation only; 4 bootstrap boundary fits and size/window sensitivity prevent robust threshold inference.';rows.append(dict(family='cubic-Z-pure',quantity='U',source=.217,ours=ours,deviation_ours_minus_source=ours-.217,numerical=verdict(ours,.217,'table'),scope='limited',conditional_band=band))
result=dict(family_size=82,source_comparisons_so_far=len(rows),pending_one_cubic_Z_U=False,rows=rows,contrasts=contrasts,coverage_errors=validate_contrast_coverage(contrasts,[(n,'D-U') for n,_,_,_ in families]),reversals=[r['analysis'] for r in contrasts if r['point_reversal']])
(R/'threshold-comparisons.json').write_text(json.dumps(result,indent=2)+'\n');print('reversals',result['reversals'])
