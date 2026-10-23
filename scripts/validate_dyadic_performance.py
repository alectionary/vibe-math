"""Audit the dyadic pilot, paired outcomes, features and held-out predictions."""
from pathlib import Path
from itertools import combinations
from collections import Counter
import base64
import hashlib
import importlib.util
import json
import math
import random
import sys
import zlib

sys.dont_write_bytecode = True
R = Path(__file__).resolve().parent.parent
P = R/'formalization/dyadic-performance'
spec = importlib.util.spec_from_file_location('dyadic_pilot', P/'search/pilot.py')
pilot = importlib.util.module_from_spec(spec)
spec.loader.exec_module(pilot)
d = json.loads((P/'search/results.json').read_text())
assert d['status'] == 'exploratory_classical_pilot_not_full_P11_resolution'
for name, sha in d['sha256'].items():
    assert hashlib.sha256((R/name).read_bytes()).hexdigest() == sha, name
assert len(d['codes']) == d['fingerprint_groups'] == 32
assert d['reference_checks'] == 32
assert d['attempts'] == 74 and d['rejected'] == {'rank_mismatch': 42}
assert {c['rank'] for c in d['codes']} == {20}
assert {c['k'] for c in d['codes']} == {28}


def unpack(value, count):
    raw = zlib.decompress(base64.b64decode(value))
    return [int(x) for x in ''.join(f'{v:08b}' for v in raw)[:count]]


noise = random.Random(d['noise_seed'])
samples = {}
for p in (.02, .05, .08):
    errors = [''.join('1' if noise.random() < p else '0' for _ in range(48)) for _ in range(3000)]
    assert hashlib.sha256(''.join(errors).encode()).hexdigest() == d['sample_sha256'][str(p)]
    samples[p] = errors
for code in d['codes']:
    h, vn = pilot.construction(code['B'], 3)
    assert pilot.connected(h, vn)
    assert len(pilot.decoder.basis(list(map(pilot.decoder.rowmask, h)))) == code['rank']
    # Independent pair-of-variables formula for four-cycles.
    c4 = sum(math.comb(len(set(vn[a]) & set(vn[b])), 2) for a, b in combinations(range(48), 2))
    assert c4 == code['cycles'][0]
    # Independent full pair spectrum using induced check degree dictionaries.
    pairs = Counter()
    for support in combinations(range(48), 2):
        degrees = Counter(c for v in support for c in vn[v])
        b = sum(value % 2 for value in degrees.values())
        if all(sum(degrees[c] % 2 == 0 for c in vn[v]) >
               sum(degrees[c] % 2 == 1 for c in vn[v]) for v in support):
            pairs[b] += 1
    assert dict(pairs) == {b: sum(s['count'] for s in code['absorbing_spectrum']
                                  if s['a'] == 2 and s['b'] == b) for b in pairs}
    assert code['absorbing_features'] == pilot.abs_features(code['absorbing_spectrum'])
    for a in code['conditions']:
        bits = unpack(a['failure_bitmap_zlib_base64'], 3000)
        assert sum(bits) == a['failures'] == a['wrong_converged']+a['nonconverged']
        assert a['fer'] == a['failures']/3000
        assert a['wilson95'] == pilot.wilson(a['failures'], 3000)
        # The all-zero injected error is always recovered immediately.
        assert all(not fail for error, fail in zip(samples[a['p']], bits) if '1' not in error)
    for a in code['exact_weight_le2']:
        bits = unpack(a['failure_bitmap_zlib_base64'], 1177)
        assert not bits[0]
        assert sum(bits[1:49]) == a['failures_by_weight']['1']
        assert sum(bits[49:]) == a['failures_by_weight']['2']
    # Fully recompute cycle and size <= 4 absorbing spectra on two graphs.
    if code['id'] < 2:
        assert pilot.cycle_counts(h, vn) == code['cycles']
        assert pilot.absorbing(vn) == code['absorbing_spectrum']
groups = [json.dumps([c['cycles'], c['absorbing_spectrum']], sort_keys=True) for c in d['codes']]
rows = [c['cycles']+c['absorbing_features'] for c in d['codes']]
for idx, analysis in enumerate(d['analysis']):
    y = [math.log((c['conditions'][idx]['failures']+.5)/(3000-c['conditions'][idx]['failures']+.5))
         for c in d['codes']]
    for name, ids in [('intercept', []), ('cycles', list(range(3))),
                      ('absorbing', list(range(3, 9))), ('combined', list(range(9)))]:
        predictions = pilot.predictions([[math.log1p(row[j]) for j in ids] for row in rows], y, groups)
        assert predictions == analysis['models'][name]['held_out_predictions']
        rmse = math.sqrt(sum((u-v)**2 for u, v in zip(y, predictions))/len(y))
        assert rmse == analysis['models'][name]['rmse_logit']
diag = json.loads((P/'search/diagnostics.json').read_text())
assert diag['not_a_predeclared_confirmatory_analysis']
assert diag['results_sha256'] == hashlib.sha256((P/'search/results.json').read_bytes()).hexdigest()
assert diag['script_sha256'] == hashlib.sha256((P/'search/diagnose.py').read_bytes()).hexdigest()

follow = json.loads((P/'search/followup-results.json').read_text())
assert follow['status'] == 'prospective_classical_followup_not_full_P11_resolution'
assert len(follow['codes']) == 32 and follow['fingerprint_groups'] == 29
assert follow['fingerprints_overlapping_original'] == 1
assert follow['reference_checks'] == 16
assert follow['attempts'] == 247
assert follow['rejected'] == {'rank_mismatch': 172, 'duplicate_binary_columns': 41, 'disconnected': 2}
for name, sha in follow['sha256'].items():
    assert hashlib.sha256((R/name).read_bytes()).hexdigest() == sha, name
noise = random.Random(follow['noise_seed'])
for prob in (.02, .05, .08):
    errors = [''.join('1' if noise.random() < prob else '0' for _ in range(48)) for _ in range(3000)]
    assert hashlib.sha256(''.join(errors).encode()).hexdigest() == follow['sample_sha256'][str(prob)]
for code in follow['codes']:
    h, vn = pilot.construction(code['B'], 3)
    assert pilot.connected(h, vn) and len(set(map(tuple, vn))) == 48
    assert all(len(cs) == 3 for cs in vn) and all(len(row) == 6 for row in h)
    assert len(pilot.decoder.basis(list(map(pilot.decoder.rowmask, h)))) == code['rank'] == 20
    assert code['absorbing_features'] == pilot.abs_features(code['absorbing_spectrum'])
    assert code['absorbing_features'][1] == 0 and code['absorbing_features'][5] > 0
    # No weight-one/two/three codewords, and a weight-four codeword exists: d=4.
    for condition in code['conditions']:
        bits = unpack(condition['failure_bitmap_zlib_base64'], 3000)
        assert sum(bits) == condition['failures'] == condition['wrong_converged']+condition['nonconverged']
        assert condition['fer'] == sum(bits)/3000
        assert condition['wilson95'] == pilot.wilson(sum(bits), 3000)
    assert code['cycles'][0] == sum(math.comb(len(set(vn[a]) & set(vn[b])), 2)
                                     for a, b in combinations(range(48), 2))
    if code['id'] == 0:
        assert code['absorbing_spectrum'] == pilot.absorbing(vn)
        assert code['cycles'] == pilot.cycle_counts(h, vn)
groups = [json.dumps([c['cycles'], c['absorbing_spectrum']], sort_keys=True) for c in follow['codes']]
rows = [c['cycles']+c['absorbing_features'] for c in follow['codes']]
for idx, analysis in enumerate(follow['analysis']):
    y = [math.log((c['conditions'][idx]['failures']+.5)/(3000-c['conditions'][idx]['failures']+.5))
         for c in follow['codes']]
    for name, ids in [('intercept', []), ('cycles', list(range(3))),
                      ('absorbing', list(range(3, 9))), ('combined', list(range(9)))]:
        pred = pilot.predictions([[math.log1p(row[j]) for j in ids] for row in rows], y, groups)
        assert pred == analysis['models'][name]['held_out_predictions']
        assert math.sqrt(sum((u-v)**2 for u, v in zip(y, pred))/len(y)) == analysis['models'][name]['rmse_logit']
diag = json.loads((P/'search/followup-diagnostics.json').read_text())
assert diag['not_a_predeclared_confirmatory_analysis']
assert diag['results_sha256'] == hashlib.sha256((P/'search/followup-results.json').read_bytes()).hexdigest()
assert diag['script_sha256'] == hashlib.sha256((P/'search/diagnose.py').read_bytes()).hexdigest()
print('Dyadic performance: two 32-code populations, 1152000 paired Monte Carlo decodes, '
      '75328 exact low-weight decodes; provenance, features, outcomes and held-out predictions pass.')
