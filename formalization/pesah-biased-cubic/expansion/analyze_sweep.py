"""Analyze Sweep reconstruction, preserving both specified fit parameterizations."""
import json
import analyze_families as a
from refit_families import fit as normalized
original=a.fit
for i,axis in enumerate(['X','Z','depolarizing']):
 data=json.loads((a.R/f'sweep-{axis}.json').read_text());assert data['complete']
 for suffix,fit in [('analysis',original),('normalized-analysis',normalized)]:
  a.fit=fit
  result=a.analyze(data,202680000+i)
  result['engine_limit']='Historical Sweep with PyMatching 2.3.1 reconstruction; original PyMatching 0.2.4 could not be built because its LEMON download was denied.'
  result['fit_method']='Original bounded polynomial' if fit is original else 'Exploratory normalized polynomial with relaxed bounds; original retained.'
  (a.R/f'sweep-{axis}-{suffix}.json').write_text(json.dumps(result,indent=2)+'\n')
  print(axis,suffix,result['thresholds_and_D_minus_U'],flush=True)
a.fit=original
