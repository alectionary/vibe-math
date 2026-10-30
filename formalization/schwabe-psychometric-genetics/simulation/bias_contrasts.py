"""Independent signed recovery inventory for every Figure 6.5 condition.
Run from the study directory. Reads preserved trial records, never rewrites them.
Bias means estimate minus generating truth; this differs from ours-minus-source.
Exploratory family declared after review of the 20-replicate checkpoint: 72
MAR condition/parameter/method means, Bonferroni Student t, alpha .05.
"""
import csv, collections, json, math
from pathlib import Path
import numpy as np
from scipy.stats import t

truths = {'A': .5, 'C': .3, 'h2': .5}
trials = list(csv.DictReader(open('outputs/trial-records.csv')))
source = [x for x in csv.DictReader(open('outputs/source-figure-values.csv')) if x['measure'] == 'estimate']
assert len(source) == 72
familysize = 72
rows = []
for s in source:
    missing = .02 if s['missing'] == 'low' else float(s['missing'])
    rs = [r for r in trials if r['mechanism'] == 'MAR' and r['parameter'] == s['parameter'] and r['method'] == s['method'] and int(r['q']) == int(s['q']) and float(r['missing']) == missing]
    good = [r for r in rs if int(r['status']) == 0 and math.isfinite(float(r['estimate']))]
    x = np.array([float(r['estimate']) for r in good]); n = len(x)
    assert n >= 2
    truth = truths[s['parameter']]; bias = float(x.mean()) - truth
    mcse = float(x.std(ddof=1) / math.sqrt(n)); half = float(t.ppf(1 - .05/(2*familysize), n-1) * mcse)
    sb = float(s['value']) - truth; bound = float(s['extraction_bound'])
    rows.append(dict(figure='6.5',mechanism='MAR',q=int(s['q']),missing=missing,source_missing_label=s['missing'],parameter=s['parameter'],method=s['method'],generating_truth=truth,requested=len(rs),successful=n,failed=len(rs)-n,source_estimate=float(s['value']),ours_estimate=float(x.mean()),source_bias_estimate_minus_truth=sb,ours_bias_estimate_minus_truth=bias,positive_means='Overestimation of generating truth',point_sign_reversal=sb*bias<0,source_extraction_bound=bound,source_sign_robust_to_extraction=abs(sb)>bound,ours_mcse=mcse,two_se_low=bias-2*mcse,two_se_high=bias+2*mcse,adjusted_low=bias-half,adjusted_high=bias+half,ours_adjusted_band_excludes_zero=abs(bias)>half,ours_minus_source=float(x.mean())-float(s['value']),family_size=familysize,alpha=.05,correction='Bonferroni Student t; exploratory after inspecting checkpoint',source_uncertainty='Unknown source Monte Carlo error; extraction bounds are not confidence intervals'))
assert len({(r['q'],r['missing'],r['parameter'],r['method']) for r in rows}) == 72
with open('outputs/bias-contrasts.csv','w') as f:
    w=csv.DictWriter(f,fieldnames=rows[0]);w.writeheader();w.writerows(rows)
summary={'expected_cells':72,'observed_cells':len(rows),'point_bias_sign_reversals':sum(r['point_sign_reversal'] for r in rows),'reversals_source_sign_robust_to_extraction':sum(r['point_sign_reversal'] and r['source_sign_robust_to_extraction'] for r in rows),'reversals_with_ours_adjusted_band_excluding_zero':sum(r['point_sign_reversal'] and r['ours_adjusted_band_excludes_zero'] for r in rows),'scope':'20-replicate checkpoint only; exploratory signed bias, not source-aware two-sample comparison or full dissertation replication','consequential_example':[r for r in rows if r['q']==5 and r['missing']==.1 and r['parameter']=='h2' and r['method']=='deletion'][0]}
Path('outputs/bias-contrast-validation.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps(summary,indent=2))
