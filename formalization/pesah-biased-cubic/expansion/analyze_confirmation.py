"""Post-inspection wider grids: single-arm exploratory fit diagnostics."""
import json
import numpy as np
from analyze_families import R,combine
from refit_families import fit
for i,name in enumerate(json.loads((R/'confirmation-plan.json').read_text())['configs']):
 data=json.loads((R/name.replace('-config.json','.json')).read_text());assert data['complete']
 rows=combine(data['rows']);base=fit(rows);rng=np.random.default_rng(202690000+i);fits=[]
 for _ in range(400):
  sub=[dict(r) for r in rows]
  for r in sub:r['failures']=int(rng.binomial(r['shots'],r['failures']/r['shots']))
  fits.append(fit(sub,start=base['parameters']))
 rates=sorted({r['p'] for r in rows});sens={k:fit(v) for k,v in [('drop_low_p',[r for r in rows if r['p']!=rates[0]]),('drop_high_p',[r for r in rows if r['p']!=rates[-1]]),('drop_L4',[r for r in rows if r['L']!=4]),('drop_L10',[r for r in rows if r['L']!=10])]}
 samples=[f['threshold'] for f in fits]
 result=dict(config_sha256=data['config_sha256'],rows=rows,fit=base,conditional_interval95=np.quantile(samples,[.025,.975]).tolist(),standard_error=float(np.std(samples,ddof=1)),bootstrap=dict(draws=400,failed=sum(not f['success'] for f in fits),boundary=sum(f['boundary'] for f in fits)),sensitivity=sens,limit='Exploratory wider grid chosen after boundary fits; not independent confirmatory hypothesis testing. Source uncertainty and model discrepancy excluded.')
 (R/name.replace('-config.json','-analysis.json')).write_text(json.dumps(result,indent=2)+'\n');print(name,base,result['conditional_interval95'],flush=True)
