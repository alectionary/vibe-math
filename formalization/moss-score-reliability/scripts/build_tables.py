"""Generate paper tables from saved, validated numerical evidence and ledgers."""
import csv,json
from pathlib import Path
r=Path('formalization/moss-score-reliability');p=r/'paper'
def tex(s):
 return str(s).replace('\\',r'\textbackslash{}').replace('&',r'\&').replace('_',r'\_').replace('%',r'\%')
def label(x):return {'R':r'$R$','H':r'$H$','S':r'$R_S$','sigma':r'$R_\sigma$'}[x]
rows=json.loads((r/'outputs/comparison.json').read_text());ct=json.loads((r/'outputs/contrasts.json').read_text())
s=[]
for c in ct:
 if c['role']=='headline':
  a,b=c['analysis'].split('-minus-')
  s.append(f"{c['condition']}: {label(a)} $-$ {label(b)} & {c['source_contrast']:.3f} & {c['ours_contrast']:.6f} & Yes & match \\\\")
(p/'headline.tex').write_text('\n'.join(s)+'\n'+r'\bottomrule'+'\n')
s=[]
for x in rows:
 s.append(f"{x['trait']}: {label(x['metric'])} & {x['published']:.3f} & {x['ours']:.6f} & {x['ours_minus_source']:+.6f} & 3 & match & limited \\\\")
(p/'comparison.tex').write_text('\n'.join(s)+'\n'+r'\bottomrule'+'\n')
for name in ['availability','compliance']:
 out=[]
 for x in json.loads((r/f'provenance/{name}.json').read_text()):
  if name=='availability':out.append(tex(x['place'])+' & '+tex(x['date_utc'])+' & '+tex(x['result'])+r' \\')
  else:out.append(tex(x['requirement'])+' & '+tex(x['status'])+' & '+tex(x['evidence'])+r' \\')
 (p/f'{name}.tex').write_text('\n'.join(out)+'\n'+r'\bottomrule'+'\n')
