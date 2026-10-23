"""Audit selection, matched distances, paired noise and decoding contrasts."""
from pathlib import Path
from itertools import combinations
import base64
import hashlib
import json
import math
import sys
import zlib

sys.dont_write_bytecode = True
R = Path(__file__).resolve().parent.parent
P = R/'formalization/dyadic-performance'
sys.path.insert(0, str(P/'search'))
import optimize as experiment
import pilot

s = json.loads((P/'search/optimization-selection.json').read_text())
d = json.loads((P/'search/optimization-results.json').read_text())
assert s['status'] == 'selection_frozen_before_decoding'
assert d['status'] == 'controlled_classical_objective_intervention'
assert len(s['pools']) == len(d['pools']) == 16
assert d['selection_sha256'] == hashlib.sha256((P/'search/optimization-selection.json').read_bytes()).hexdigest()
for name, sha in s['sha256'].items():
    assert hashlib.sha256((R/name).read_bytes()).hexdigest() == sha, name
reference = json.loads((P/'search/followup-results.json').read_text())
scaling = experiment.reference_scaling(reference)
# JSON serializes the feature-name tuple as a list.
assert scaling['mean_log1p'] == s['scaling']['mean_log1p']
assert scaling['std_log1p'] == s['scaling']['std_log1p']
assert list(scaling['feature_names']) == s['scaling']['feature_names']
seen = set()
selected_unique = 0
for pool, decoded in zip(s['pools'], d['pools']):
    assert pool['id'] == decoded['id']
    assert len(pool['candidates']) == 48
    assert pool['attempts'] == 48+sum(pool['rejected'].values())
    assert pool['selected']['baseline'] == 0
    selected_ids = set(pool['selected'].values())
    selected_unique += len(selected_ids)
    for arm in experiment.ARMS[1:]:
        winner = min(pool['candidates'], key=lambda c: (c['scores'][arm], experiment.lex_array(c)))
        assert pool['selected'][arm] == winner['id']
    for code in pool['candidates']:
        key = experiment.lex_array(code)
        assert key not in seen
        seen.add(key)
        h, vn = pilot.construction(code['B'], 3)
        assert pilot.connected(h, vn)
        assert all(len(row) == 6 for row in h) and all(len(cs) == 3 for cs in vn)
        assert len(set(map(tuple, vn))) == 48
        masks = list(map(pilot.decoder.rowmask, h))
        assert len(pilot.decoder.basis(masks)) == code['rank'] == 20
        assert (code['n'], code['k'], code['d']) == (48, 28, 4)
        word = sum(1 << v for v in code['weight_four_witness'])
        assert pilot.popcount(word) == 4 and not any(pilot.decoder.syndrome(masks, word))
        # Nonzero, distinct, odd-weight columns exclude weights 1, 2 and 3.
        words4, witness = experiment.distance_four(vn)
        assert words4 == code['weight_four_count'] == code['absorbing_features'][5] > 0
        assert witness == code['weight_four_witness']
        assert code['absorbing_features'][1] == 0
        assert code['absorbing_features'] == pilot.abs_features(code['absorbing_spectrum'])
        assert experiment.scores(code, scaling) == code['scores']
        assert sum(math.comb(len(set(vn[a]) & set(vn[b])), 2)
                   for a, b in combinations(range(48), 2)) == code['cycles'][0]
        if code['id'] in selected_ids:
            assert pilot.cycle_counts(h, vn) == code['cycles']
            assert pilot.absorbing(vn) == code['absorbing_spectrum']
    samples = experiment.noise_samples(pool['id'])
    for prob, errors in samples.items():
        assert hashlib.sha256(''.join(errors).encode()).hexdigest() == decoded['sample_sha256'][str(prob)]
    for arm, conditions in decoded['arms'].items():
        assert len(conditions) == 6
        for condition in conditions:
            count = condition['frames']
            assert count == 5000
            raw = zlib.decompress(base64.b64decode(condition['failure_bitmap_zlib_base64']))
            bits = [int(v) for v in ''.join(f'{byte:08b}' for byte in raw)[:count]]
            assert sum(bits) == condition['failures']
            assert condition['failures'] == condition['nonconverged']+condition['wrong_converged']
            assert condition['fer'] == sum(bits)/count
            assert condition['wilson95'] == pilot.wilson(sum(bits), count)
            assert all(not fail for error, fail in zip(samples[condition['p']], bits) if '1' not in error)
    for left, right in combinations(experiment.ARMS, 2):
        if pool['selected'][left] == pool['selected'][right]:
            assert decoded['arms'][left] == decoded['arms'][right]
assert len(seen) == 768
assert d['nominal_arm_decodes'] == 1920000
assert d['actual_decoder_executions'] == selected_unique*30000
assert d['reference_checks'] == selected_unique*4
assert d['analysis'] == experiment.analyze(d['pools'])
assert sum(a['primary'] for a in d['analysis']) == 1

import lexicographic
lex_s = json.loads((P/'search/lexicographic-selection.json').read_text())
lex_d = json.loads((P/'search/lexicographic-results.json').read_text())
assert lex_d['not_original_prespecified_primary_comparison']
assert lex_d['selection_sha256'] == hashlib.sha256((P/'search/lexicographic-selection.json').read_bytes()).hexdigest()
for name, sha in lex_s['sha256'].items():
    assert hashlib.sha256((R/name).read_bytes()).hexdigest() == sha, name
unique_lex = 0
for pool, choice, decoded in zip(s['pools'], lex_s['pools'], lex_d['pools']):
    assert choice['id'] == decoded['id'] == pool['id']
    winner = min(pool['candidates'], key=lambda c: (tuple(c['cycles']), experiment.lex_array(c)))
    assert choice['selected']['cycles'] == winner['id']
    for arm in ('baseline', 'absorbing', 'joint'):
        assert choice['selected'][arm] == pool['selected'][arm]
    h, vn = pilot.construction(winner['B'], 3)
    assert winner['cycles'] == pilot.cycle_counts(h, vn)
    assert winner['absorbing_spectrum'] == pilot.absorbing(vn)
    unique_lex += len(set(choice['selected'].values()))
    samples = lexicographic.samples(pool['id'])
    for prob, errors in samples.items():
        sha = hashlib.sha256(''.join(errors).encode()).hexdigest()
        assert sha == decoded['sample_sha256'][str(prob)]
        assert sha != d['pools'][pool['id']]['sample_sha256'][str(prob)]
    for conditions in decoded['arms'].values():
        for condition in conditions:
            raw = zlib.decompress(base64.b64decode(condition['failure_bitmap_zlib_base64']))
            bits = [int(v) for v in ''.join(f'{byte:08b}' for byte in raw)[:5000]]
            assert sum(bits) == condition['failures'] == condition['nonconverged']+condition['wrong_converged']
            assert condition['fer'] == sum(bits)/5000
            assert condition['wilson95'] == pilot.wilson(sum(bits), 5000)
    for left, right in combinations(experiment.ARMS, 2):
        if choice['selected'][left] == choice['selected'][right]:
            assert decoded['arms'][left] == decoded['arms'][right]
assert lex_d['actual_decoder_executions'] == unique_lex*30000
assert lex_d['reference_checks'] == unique_lex*4
assert lex_d['analysis'] == experiment.analyze(lex_d['pools'])
print(f'Dyadic optimization: 768 admissible candidates, 16 matched pools, '
      f'{d["actual_decoder_executions"]+lex_d["actual_decoder_executions"]} actual Monte Carlo decodes; '
      'original policies and shortest-cycle-first sensitivity, selected spectra, '
      'distances, paired samples and contrasts pass.')
