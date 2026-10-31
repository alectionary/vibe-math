"""Saved paired generation-only alpha-method sensitivity; no simulation."""
import csv,json,statistics,math,hashlib
from pathlib import Path
root=Path(__file__).resolve().parents[1]
p=root/'production/generator-alpha-sensitivity-v1/summaries.csv'
rows=list(csv.DictReader(p.open()));old={int(r['seed']):r for r in csv.DictReader((root/'production/generator-summary-v1/summaries.csv').open())}
assert len(rows)==len(old)==2650 and len({r['seed'] for r in rows})==2650
out=[]
for c in range(1,20):
 rs=[r for r in rows if int(r['condition'])==c];expected=100 if c<=14 else 250;assert len(rs)==expected
 for r in rs:
  o=old[int(r['seed'])];assert r['condition']==o['condition'] and r['replicate']==o['replicate'] and abs(float(r['alpha_raw'])-float(o['alpha_all']))<1e-12
 valid=[r for r in rs if r['alpha_standardized']!='NA'];raw=[float(r['alpha_raw']) for r in rs];std=[float(r['alpha_standardized']) for r in valid];diff=[float(r['alpha_standardized'])-float(r['alpha_raw']) for r in valid]
 source=.9 if c in [1,2,15,16,17,18] else .75 if c==19 else .92
 out.append(dict(condition=c,requested=expected,valid_standardized=len(valid),undefined_standardized=expected-len(valid),source_quoted_alpha=source,raw_mean=statistics.mean(raw),standardized_mean=statistics.mean(std) if std else None,paired_standardized_minus_raw_mean=statistics.mean(diff) if diff else None,paired_mcse=statistics.stdev(diff)/math.sqrt(len(diff)) if len(diff)>1 else None,raw_mean_minus_source=statistics.mean(raw)-source,standardized_mean_minus_source=statistics.mean(std)-source if std else None))
x={'input_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'analysis_script_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'conditions':out,'datasets_regenerated':2650,'additional_independent_datasets':0,'posterior_fits':0,'interpretation':'Formula sensitivity on identical responses, not a new source-estimand match. Standardization slightly reduces the two floor/ceiling mean deviations but neither mean rounds to.90; it increases the20-item deviation. Source procedure/aggregation remains unknown. No statistical significance/equivalence claim or post-hoc margin.'}
(root/'outputs/generator-alpha-sensitivity-analysis.json').write_text(json.dumps(x,indent=2)+'\n')
print('19 conditions,2650 paired rows; undefined:',sum(r['undefined_standardized'] for r in out))
