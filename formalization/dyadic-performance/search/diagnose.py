"""Explicitly post-hoc ablations of the frozen pilot, not confirmatory tests."""
from pathlib import Path
import argparse
import hashlib
import json
import math
from pilot import predictions

HERE = Path(__file__).resolve().parent
parser = argparse.ArgumentParser()
parser.add_argument('--followup', action='store_true')
args = parser.parse_args()
input_name = 'followup-results.json' if args.followup else 'results.json'
output_name = 'followup-diagnostics.json' if args.followup else 'diagnostics.json'
data = json.loads((HERE/input_name).read_text())
analyses = []
for population in (('all_codes',) if args.followup else ('all_codes', 'no_weight_two_codewords')):
    codes = [c for c in data['codes'] if population == 'all_codes' or c['absorbing_features'][1] == 0]
    groups = [json.dumps([c['cycles'], c['absorbing_spectrum']], sort_keys=True) for c in codes]
    rows = [c['cycles']+c['absorbing_features'] for c in codes]
    for idx, condition in enumerate(data['analysis']):
        y = [math.log((c['conditions'][idx]['failures']+.5)/
                      (3000-c['conditions'][idx]['failures']+.5)) for c in codes]
        models = {}
        for name, indices in [('intercept', []), ('cycles', [0, 1, 2]),
                              ('positive_b_only', [3, 5, 7]), ('zero_b_only', [4, 6, 8]),
                              ('cycles_plus_positive_b', [0, 1, 2, 3, 5, 7]),
                              ('combined', list(range(9)))]:
            pred = predictions([[math.log1p(row[j]) for j in indices] for row in rows], y, groups)
            models[name] = math.sqrt(sum((u-v)**2 for u, v in zip(y, pred))/len(y))
        analyses.append({'population': population, 'codes': len(codes), 'alpha': condition['alpha'],
                         'p': condition['p'], 'rmse_logit': models})
result = {'status': 'post_hoc_exploratory_diagnostics_after_inspecting_pilot',
          'not_a_predeclared_confirmatory_analysis': True, 'analysis': analyses,
          'results_sha256': hashlib.sha256((HERE/input_name).read_bytes()).hexdigest(),
          'script_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
(HERE/output_name).write_text(json.dumps(result, indent=2)+'\n')
for row in analyses:
    print(row['population'], row['codes'], row['alpha'], row['p'],
          {k: round(v, 4) for k, v in row['rmse_logit'].items()})
