"""Separate six-contrast family: undeformed rhombic versus three alternatives."""
import json,math,sys
from analyze_families import R
sys.path.insert(0,str(R.parents[2]/'.agents/skills/replication-paper/scripts'))
from contrast_checks import source_band,contrast,validate_contrast_coverage
s=json.loads((R/'source-bias-curves.json').read_text())['records'];records=[]
for eta in [30,100]:
 def source(code,d):return next(x['threshold'] for x in s if x['code']==code and x['axis']=='Z' and x['deformed']==d and x['bias_label']==str(eta))
 a=json.loads((R/f'rhombic-Z-eta{eta}-analysis.json').read_text())
 for code,d in [('cubic',False),('cubic',True),('rhombic',True)]:
  b=json.loads((R/f'{code}-Z-eta{eta}-analysis.json').read_text());src=source('rhombic',False)-source(code,d);ours=a['thresholds_and_D_minus_U'][0]-b['thresholds_and_D_minus_U'][int(d)];se=math.hypot(a['standard_errors'][0],b['standard_errors'][int(d)])
  records.append(dict(analysis=f'Z-eta{eta}',condition=f'rhombic-U minus {code}-'+('D' if d else 'U'),source_contrast=src,ours_contrast=ours,**contrast(src,ours,'Undeformed rhombic minus alternative threshold, probability; positive favors undeformed rhombic.'),conditional_band=source_band(ours-src,se,.002,6),inference='Exploratory fitted ranking, not established: configuration and fit-bound/model uncertainty remain. Independent simulation seeds, shared BP/OSD implementation and fitting family.'))
result=dict(family_size=6,alpha=.05,records=records,coverage_errors=validate_contrast_coverage(records,[(f'Z-eta{e}',f'rhombic-U minus {c}-'+('D' if d else 'U')) for e in [30,100] for c,d in [('cubic',False),('cubic',True),('rhombic',True)]]))
(R/'ranking-comparisons.json').write_text(json.dumps(result,indent=2)+'\n');print([(x['analysis'],x['condition'],x['ours_contrast'],x['point_reversal']) for x in records])
