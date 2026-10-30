"""Extract printed arrays and targets from the complete Library text, not the audit."""
import re,csv,json
from pathlib import Path
base=Path(__file__).resolve().parents[1]
s=(base.parents[1]/'source/kupzyk-library-text.txt').read_text()
for name,width in [('normsizes',11),('skewsizes',8)]:
 raw=re.search(name+r'=\{(.*?)\};',s,re.S).group(1)
 rows=[[int(x) for x in r.split()] for r in raw.split(',')]
 assert len(rows)==29 and all(len(r)==width and sum(r)==j for j,r in enumerate(rows,13))
 with (base/'outputs'/f'{name}.csv').open('w') as f:
  csv.writer(f).writerows(rows)
raw=s.split('Table 1. Exemplary dataset power estimates for each cell of the design.')[1].split('<PARSED TEXT FOR PAGE: 103')[0]
rows=[]
for line in raw.splitlines():
 vals=re.findall(r'\.\d{5}\b',line)
 if len(vals)==6: rows.append(vals)
assert len(rows)==9
js=[13,19,25]; targets=[]
for k,row in enumerate(rows):
 for col,v in enumerate(row): targets.append([len(targets)+1,[.05,.10,.15][k//3],[0,.05,.15][k%3],[.5,.7][col//3],col%3+1,js[k//3],v])
with (base/'outputs/targets.csv').open('w') as f:
 w=csv.writer(f);w.writerow(['cell','icc','attrition','treat','size','J','published']);w.writerows(targets)
raw=s.split('Table 5. Actual number of clusters needed for sufficient power.')[1].split('<PARSED TEXT FOR PAGE: 108')[0]
jrows=[]
for line in raw.splitlines():
 if '%' in line and '(' in line:
  nums=re.findall(r'\b\d+\b',line.split(')')[-1]);assert len(nums)==6;jrows.extend(map(int,nums))
assert len(jrows)==54
with (base/'outputs/threshold-targets.csv').open('w') as f:
 w=csv.writer(f);w.writerow(['cell','required_J']);w.writerows(enumerate(jrows,1))
