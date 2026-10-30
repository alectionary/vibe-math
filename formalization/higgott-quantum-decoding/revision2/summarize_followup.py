import json,math,csv
from pathlib import Path
from scipy.stats import norm
p=Path(__file__).parent;r=json.loads((p/'confirmation.json').read_text());source=list(csv.DictReader((p.parent/'source/figure_7_14a_vector_values.csv').open()))
rows=[]
for prob in sorted({x['p'] for x in r}):
 vals={}
 for family in ['b1','q2']:
  a=[x for x in r if x['p']==prob and x['family']==family];v=[x['failures']/x['shots'] for x in a]
  rate=sum(v)/2 if family=='b1' else sum(1-(1-x)**4 for x in v)/2
  variance=sum(x*(1-x)/1000000*(1 if family=='b1' else (4*(1-x)**3)**2) for x in v)/4
  vals[family]=(rate,variance)
  series='bolza' if family=='b1' else 'honeycomb_4copies';s=min([x for x in source if x['series']==series],key=lambda x:abs(float(x['physical_error_rate'])-prob))
  rows.append(dict(p=prob,family=family,rate=rate,se=math.sqrt(variance),source=float(s['logical_block_error_rate']),difference=rate-float(s['logical_block_error_rate'])))
 gap=vals['b1'][0]-vals['q2'][0];se=math.sqrt(vals['b1'][1]+vals['q2'][1]);rows[-1]['bolza_minus_planar']=gap;rows[-1]['gap_simultaneous_halfwidth']=float(norm.ppf(1-.05/10)*se)
(p/'followup_summary.json').write_text(json.dumps(rows,indent=2)+'\n')
lines=[r'\begin{tabular}{rrrrr}',r'\toprule $p$ & Bolza & Four planar copies & Difference & Simultaneous half-width\\\midrule']
for prob in sorted({x['p'] for x in r}):
 b,q=[x for x in rows if x['p']==prob];lines.append(f"{prob:.5f} & {b['rate']:.5f} & {q['rate']:.5f} & {q['bolza_minus_planar']:.5f} & {q['gap_simultaneous_halfwidth']:.5f}"+r'\\')
lines.append(r'\bottomrule\end{tabular}');(p.parent/'paper/confirmation_table.tex').write_text('\n'.join(lines)+'\n');print(json.dumps(rows,indent=2))
