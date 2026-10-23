"""Best-of-48 graph-objective intervention; see OPTIMIZATION-PROTOCOL.md."""
from collections import Counter, defaultdict
from itertools import combinations
from pathlib import Path
import hashlib
import json
import math
import random
import subprocess
import tempfile
import pilot as p

HERE = Path(__file__).resolve().parent
ARMS = ('baseline', 'cycles', 'absorbing', 'joint')
FEATURES = ('cycles4', 'cycles6', 'cycles8', 'abs2_positive_b',
            'abs3_positive_b', 'abs4_positive_b', 'abs4_zero_b')
CONTRASTS = (('cycles', 'baseline'), ('absorbing', 'baseline'), ('joint', 'baseline'),
             ('absorbing', 'cycles'), ('joint', 'cycles'), ('joint', 'absorbing'))


def feature_values(code):
    a = code['absorbing_features']
    return code['cycles']+[a[0], a[2], a[4], a[5]]


def distance_four(vn):
    """Given nonzero distinct weight-three columns: count weight-four words."""
    masks = [sum(1 << c for c in cs) for cs in vn]
    pairs = defaultdict(list)
    for a, b in combinations(range(len(vn)), 2):
        pairs[masks[a] ^ masks[b]].append((a, b))
    count, witness = 0, None
    for entries in pairs.values():
        if len(entries) > 1:
            for left, right in combinations(entries, 2):
                assert not (set(left) & set(right)), 'distinct columns are required'
                count += 1
                if witness is None:
                    witness = sorted(left+right)
    assert count % 3 == 0  # Three two-pair partitions per weight-four support.
    return count//3, witness


def fingerprint(code):
    return json.dumps([code['cycles'], code['absorbing_spectrum']], sort_keys=True)


def reference_scaling(reference):
    rows = [[math.log1p(v) for v in feature_values(c)] for c in reference['codes']]
    mean = [sum(row[j] for row in rows)/len(rows) for j in range(7)]
    std = [math.sqrt(sum((row[j]-mean[j])**2 for row in rows)/len(rows)) for j in range(7)]
    return {'feature_names': FEATURES, 'mean_log1p': mean, 'std_log1p': std}


def scores(code, scaling):
    z = [(math.log1p(v)-mean)/std if std else None
         for v, mean, std in zip(feature_values(code), scaling['mean_log1p'], scaling['std_log1p'])]
    cycle = [v for v in z[:3] if v is not None]
    absorbing = [v for v in z[3:] if v is not None]
    c, a = sum(cycle)/len(cycle), sum(absorbing)/len(absorbing)
    return {'cycles': c, 'absorbing': a, 'joint': (c+a)/2}


def lex_array(code):
    return tuple(v for row in code['B'] for v in row)


def selection():
    reference = json.loads((HERE/'followup-results.json').read_text())
    scaling = reference_scaling(reference)
    prior = json.loads((HERE/'results.json').read_text())
    prior_fingerprints = {fingerprint(c) for c in reference['codes']+prior['codes']}
    rng = random.Random(20261027)
    seen, pools, total_rejected, all_fingerprints = set(), [], Counter(), []
    for pool_id in range(16):
        candidates, rejected, attempts = [], Counter(), 0
        while len(candidates) < 48:
            attempts += 1
            B = [[0]*6]+[[0]+[rng.randrange(8) for _ in range(5)] for _ in range(2)]
            key = tuple(map(tuple, B))
            if key in seen:
                rejected['duplicate_array'] += 1; continue
            h, vn = p.construction(B, 3)
            if not p.connected(h, vn):
                rejected['disconnected'] += 1; continue
            if len(p.decoder.basis(list(map(p.decoder.rowmask, h)))) != 20:
                rejected['rank_mismatch'] += 1; continue
            if len(set(map(tuple, vn))) != 48:
                rejected['duplicate_columns'] += 1; continue
            words4, witness = distance_four(vn)
            if not words4:
                rejected['distance_above_four'] += 1; continue
            spectrum = p.absorbing(vn)
            code = {'id': len(candidates), 'B': B, 'n': 48, 'rank': 20, 'k': 28, 'd': 4,
                    'weight_four_count': words4, 'weight_four_witness': witness,
                    'cycles': p.cycle_counts(h, vn), 'absorbing_spectrum': spectrum,
                    'absorbing_features': p.abs_features(spectrum)}
            assert code['absorbing_features'][1] == 0 and code['absorbing_features'][5] == words4
            code['scores'] = scores(code, scaling)
            candidates.append(code)
            seen.add(key)
        selected = {'baseline': 0}
        for arm in ARMS[1:]:
            selected[arm] = min(candidates, key=lambda c: (c['scores'][arm], lex_array(c)))['id']
        fps = {fingerprint(c) for c in candidates}
        pools.append({'id': pool_id, 'attempts': attempts, 'rejected': dict(rejected),
                      'candidate_fingerprints': len(fps), 'fingerprints_overlapping_prior': len(fps & prior_fingerprints),
                      'selected': selected, 'candidates': candidates})
        total_rejected.update(rejected)
        all_fingerprints.extend(fps)
        print(f'selected pool {pool_id+1}/16: {selected}', flush=True)
    paths = [Path(__file__), HERE/'pilot.py', HERE.parent/'OPTIMIZATION-PROTOCOL.md',
             HERE/'followup-results.json', HERE/'results.json', p.OLD/'minsum.cpp',
             p.OLD/'benchmark_decoding.py', p.OLD/'decoding.py', p.OLD/'optimize_absorbing.py', p.OLD/'scan.py']
    result = {'status': 'selection_frozen_before_decoding', 'construction_seed': 20261027,
              'scaling': scaling, 'pools': pools, 'total_rejected': dict(total_rejected),
              'distinct_fingerprints_across_pools': len(set(all_fingerprints)),
              'sha256': {str(path.relative_to(p.ROOT)): hashlib.sha256(path.read_bytes()).hexdigest()
                         for path in paths}}
    (HERE/'optimization-selection.json').write_text(json.dumps(result, indent=2)+'\n')
    return result


def noise_samples(pool_id):
    rng = random.Random(20261028+100*pool_id)
    return {prob: [''.join('1' if rng.random() < prob else '0' for _ in range(48))
                   for _ in range(5000)] for prob in (.02, .05, .08)}


def percentile(ordered, fraction):
    pos = (len(ordered)-1)*fraction
    lo, hi = math.floor(pos), math.ceil(pos)
    return ordered[lo]+(ordered[hi]-ordered[lo])*(pos-lo)


def analyze(pool_results):
    bootstrap = random.Random(20261029)
    blocks = [[bootstrap.randrange(16) for _ in range(16)] for _ in range(20000)]
    analyses = []
    for index in range(6):
        condition = pool_results[0]['arms']['baseline'][index]
        values = {arm: [pool['arms'][arm][index]['failures']/5000 for pool in pool_results] for arm in ARMS}
        contrasts = []
        for left, right in CONTRASTS:
            diffs = [u-v for u, v in zip(values[left], values[right])]
            boot = sorted(sum(diffs[i] for i in block)/16 for block in blocks)
            contrasts.append({'left': left, 'right': right, 'mean_fer_difference': sum(diffs)/16,
                'pool_differences': diffs, 'ci95': [percentile(boot, .025), percentile(boot, .975)],
                'primary_family_ci99_1667': [percentile(boot, .05/12), percentile(boot, 1-.05/12)]
                    if condition['alpha'] == .8 and condition['p'] == .05 else None,
                'pools_better': sum(d < 0 for d in diffs), 'pools_equal': sum(d == 0 for d in diffs),
                'pools_worse': sum(d > 0 for d in diffs)})
        analyses.append({'alpha': condition['alpha'], 'p': condition['p'],
            'primary': condition['alpha'] == .8 and condition['p'] == .05,
            'mean_fer': {arm: sum(v)/16 for arm, v in values.items()}, 'contrasts': contrasts})
    return analyses


def decode(selected):
    output, reference_checks, actual_decodes = [], 0, 0
    with tempfile.TemporaryDirectory(prefix='dyadic-objective-optimization-') as temp:
        binary = Path(temp)/'minsum'
        subprocess.run(['c++', '-std=c++17', '-O2', str(p.OLD/'minsum.cpp'), '-o', str(binary)], check=True)
        for pool in selected['pools']:
            samples = noise_samples(pool['id'])
            cache = {}
            for code_id in sorted(set(pool['selected'].values())):
                code = pool['candidates'][code_id]
                h, _ = p.construction(code['B'], 3)
                masks, results = list(map(p.decoder.rowmask, h)), []
                for alpha in (.8, 1.):
                    trials = [(.05, p.decoder.bit_string(mask, 48)) for mask in (1, 3)]
                    for trial, result in zip(trials, p.decoder.engine(binary, h, 48, trials, 50, alpha)):
                        assert result == p.decoder.reference_decode(h, 48, trial[1], .05, 50, alpha)
                        reference_checks += 1
                    for prob, errors in samples.items():
                        out = p.decoder.engine(binary, h, 48, [(prob, e) for e in errors], 50, alpha)
                        fail, nonconv = [], 0
                        for error, result in zip(errors, out):
                            matched = (p.decoder.syndrome(masks, p.decoder.string_mask(result[2])) ==
                                       p.decoder.syndrome(masks, p.decoder.string_mask(error)))
                            assert matched == result[1]
                            fail.append(error != result[2])
                            nonconv += not matched
                            assert matched or fail[-1]
                        actual_decodes += len(errors)
                        results.append({'alpha': alpha, 'p': prob, 'frames': len(errors),
                            'failures': sum(fail), 'nonconverged': nonconv,
                            'wrong_converged': sum(fail)-nonconv, 'fer': sum(fail)/len(errors),
                            'wilson95': p.wilson(sum(fail), len(errors)),
                            'failure_bitmap_zlib_base64': p.pack(fail)})
                cache[code_id] = results
            output.append({'id': pool['id'], 'noise_seed': 20261028+100*pool['id'],
                'sample_sha256': {str(prob): hashlib.sha256(''.join(errors).encode()).hexdigest()
                                  for prob, errors in samples.items()},
                'arms': {arm: cache[pool['selected'][arm]] for arm in ARMS}})
            print(f'decoded pool {pool["id"]+1}/16', flush=True)
    result = {'status': 'controlled_classical_objective_intervention',
              'nominal_arm_decodes': 16*4*6*5000, 'actual_decoder_executions': actual_decodes,
              'reference_checks': reference_checks, 'bootstrap_seed': 20261029, 'bootstrap_samples': 20000,
              'selection_sha256': hashlib.sha256((HERE/'optimization-selection.json').read_bytes()).hexdigest(),
              'pools': output, 'analysis': analyze(output)}
    (HERE/'optimization-results.json').write_text(json.dumps(result, indent=2)+'\n')
    for analysis in result['analysis']:
        print(analysis['alpha'], analysis['p'], analysis['mean_fer'])
    return result


if __name__ == '__main__':
    decode(selection())
