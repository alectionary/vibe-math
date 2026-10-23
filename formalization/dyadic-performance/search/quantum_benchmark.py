"""Literal P11 CSS families, exact small logical distance, fresh Pauli noise."""
from collections import Counter
from itertools import combinations
from pathlib import Path
import hashlib
import json
import math
import random
import subprocess
import tempfile
import pilot as p
import quantum_css as q
from optimize import percentile

HERE = Path(__file__).resolve().parent
ARMS = ('baseline', 'cycle_first', 'absorbing', 'joint', 'cycle_aggregate')
FAMILIES = ({'family': '3.10', 'ell': 2, 'v': 4, 'rank': 12, 'n': 32, 'k': 8},
            {'family': '3.11', 'ell': 3, 'v': 6, 'rank': 28, 'n': 96, 'k': 40})
FEATURE_NAMES = ('cycles4', 'cycles6', 'cycles8', 'abs2_positive', 'abs2_zero',
                 'abs3_positive', 'abs3_zero', 'abs4_positive', 'abs4_zero')


def graph_metrics(binary, h, vn):
    data = [f'{len(vn)} {len(h)}']+[str(len(row))+' '+' '.join(map(str, row)) for row in h]
    lines = subprocess.run([str(binary)], input='\n'.join(data)+'\n', text=True,
                           capture_output=True, check=True).stdout.splitlines()
    cycles = list(map(int, lines[0].split()))
    spectrum = []
    for line in lines[1:]:
        a, b, elementary, connected, count = map(int, line.split())
        spectrum.append({'a': a, 'b': b, 'elementary': bool(elementary),
                         'connected': bool(connected), 'count': count})
    return {'cycles': cycles, 'absorbing_spectrum': spectrum, 'absorbing_features': p.abs_features(spectrum)}


def graph_counter_checks(binary):
    matrices = [[[0]*6 for _ in range(3)], [[0, 0, 0, 0], [0, 1, 2, 3], [0, 2, 3, 1]]]
    for B, ell in zip(matrices, (0, 2)):
        h, vn = p.construction(B, ell)
        actual = graph_metrics(binary, h, vn)
        assert actual['cycles'] == p.cycle_counts(h, vn)
        assert actual['absorbing_spectrum'] == p.absorbing(vn)
    return 2


def quick_logical_two(vn, stab):
    return any(vn[a] == vn[b] and not p.decoder.in_span((1 << a)|(1 << b), stab)
               for a, b in combinations(range(len(vn)), 2))


def feature_values(code):
    return code['cycles_total']+code['absorbing_features_total']


def scaling(calibration):
    rows = [[math.log1p(v) for v in feature_values(code)] for code in calibration]
    mean = [sum(row[j] for row in rows)/len(rows) for j in range(9)]
    std = [0. if len({row[j] for row in rows}) == 1 else
           math.sqrt(sum((row[j]-mean[j])**2 for row in rows)/len(rows)) for j in range(9)]
    return {'names': FEATURE_NAMES, 'mean_log1p': mean, 'std_log1p': std}


def scores(code, scale):
    z = [(math.log1p(v)-mean)/std if std else None
         for v, mean, std in zip(feature_values(code), scale['mean_log1p'], scale['std_log1p'])]
    mean_nonconstant = lambda values: sum(v for v in values if v is not None)/sum(v is not None for v in values) if any(v is not None for v in values) else 0.
    cycles, absorbing = mean_nonconstant(z[:3]), mean_nonconstant(z[3:])
    return {'cycle_aggregate': cycles, 'absorbing': absorbing, 'joint': (cycles+absorbing)/2}


def select(metric_binary):
    families = []
    for fi, config in enumerate(FAMILIES):
        rng = random.Random(20261101+100000*fi)
        seen, rejected, attempted = set(), Counter(), 0

        def sample():
            nonlocal attempted
            while True:
                attempted += 1
                parameters = q.sample_parameters(rng, config['family'], config['ell'], config['v'])
                key = json.dumps(parameters, sort_keys=True)
                if key in seen:
                    rejected['duplicate_parameters'] += 1; continue
                bx, bz = q.arrays(config['family'], parameters)
                if not q.block_commutes(bx, bz):
                    rejected['noncommuting'] += 1; continue
                hx, hz, vx, vz = q.expansion(bx, bz, config['ell'])
                if not p.connected(hx, vx) or not p.connected(hz, vz):
                    rejected['disconnected'] += 1; continue
                xb = p.decoder.basis(list(map(p.decoder.rowmask, hx)))
                zb = p.decoder.basis(list(map(p.decoder.rowmask, hz)))
                if (len(xb), len(zb)) != (config['rank'], config['rank']):
                    rejected['rank_mismatch'] += 1; continue
                if quick_logical_two(vx, zb) or quick_logical_two(vz, xb):
                    rejected['logical_distance_two'] += 1; continue
                dz, dx = q.logical_spectrum(vx, zb), q.logical_spectrum(vz, xb)
                if (dx['distance_if_at_most_four'], dz['distance_if_at_most_four']) != (4, 4):
                    rejected['logical_distance_not_four'] += 1; continue
                mx = graph_metrics(metric_binary, hx, vx)
                mz = mx if hx == hz else graph_metrics(metric_binary, hz, vz)
                seen.add(key)
                return {'parameters': parameters, 'bx': bx, 'bz': bz, 'rank_x': len(xb), 'rank_z': len(zb),
                    'n': len(vx), 'k': len(vx)-len(xb)-len(zb), 'd_x': 4, 'd_z': 4,
                    'logical_x': dx, 'logical_z': dz, 'graph_x': mx, 'graph_z': mz,
                    'cycles_total': [a+b for a, b in zip(mx['cycles'], mz['cycles'])],
                    'absorbing_features_total': [a+b for a, b in zip(mx['absorbing_features'], mz['absorbing_features'])]}

        calibration = [sample() for _ in range(24)]
        scale = scaling(calibration)
        pools = []
        for pool_id in range(16):
            candidates = [sample() for _ in range(24)]
            for i, code in enumerate(candidates):
                code['id'], code['scores'] = i, scores(code, scale)
            selected = {'baseline': 0,
                'cycle_first': min(range(24), key=lambda i: (candidates[i]['cycles_total'], i))}
            for arm in ('absorbing', 'joint', 'cycle_aggregate'):
                selected[arm] = min(range(24), key=lambda i: (candidates[i]['scores'][arm], i))
            pools.append({'id': pool_id, 'candidates': candidates, 'selected': selected})
            print(f'CSS {config["family"]}: selected pool {pool_id+1}/16', flush=True)
        families.append({'configuration': config, 'construction_seed': 20261101+100000*fi,
                         'attempted': attempted, 'rejected': dict(rejected),
                         'calibration': calibration, 'scaling': scale, 'pools': pools})
    paths = [Path(__file__), HERE/'quantum_css.py', HERE/'graph_metrics.cpp', HERE/'pilot.py',
             HERE/'optimize.py', HERE.parent/'QUANTUM-PROTOCOL.md',
             p.OLD/'minsum.cpp', p.OLD/'benchmark_decoding.py', p.OLD/'decoding.py',
             p.OLD/'optimize_absorbing.py', p.OLD/'scan.py']
    manifest = {'status': 'literal_css_selections_frozen_before_quantum_decoding',
        'source': {'url': 'https://arxiv.org/html/2605.01942v1', 'locators': ['Construction 3.10, Equation (8)', 'Construction 3.11, Equation (9)']},
        'families': families, 'graph_counter_checks': 2,
        'sha256': {str(path.relative_to(p.ROOT)): hashlib.sha256(path.read_bytes()).hexdigest() for path in paths}}
    (HERE/'quantum-selection.json').write_text(json.dumps(manifest, indent=2)+'\n')
    return manifest


def noise_samples(family_index, pool_id):
    rng = random.Random(20261103+100000*family_index+100*pool_id)
    n = FAMILIES[family_index]['n']
    return {prob: [(''.join('1' if rng.random() < prob else '0' for _ in range(n)),
                    ''.join('1' if rng.random() < prob else '0' for _ in range(n))) for _ in range(5000)]
            for prob in (.01, .02, .05)}


def success(residual_x, residual_z, xb, zb):
    return p.decoder.in_span(residual_x, xb) and p.decoder.in_span(residual_z, zb)


def analyze(families):
    rng = random.Random(20261104)
    blocks = [[rng.randrange(16) for _ in range(16)] for _ in range(20000)]
    output = []
    for family in families:
        conditions = []
        for index in range(6):
            example = family['pools'][0]['arms']['baseline'][index]
            values = {arm: [pool['arms'][arm][index]['failures']/5000 for pool in family['pools']] for arm in ARMS}
            contrasts = []
            primary = example['p'] == .02 and example['alpha'] == .8
            for left, right in combinations(ARMS, 2):
                diffs = [u-v for u, v in zip(values[left], values[right])]
                boot = sorted(sum(diffs[i] for i in block)/16 for block in blocks)
                contrasts.append({'left': left, 'right': right, 'difference': sum(diffs)/16,
                    'ci95': [percentile(boot, .025), percentile(boot, .975)],
                    'primary_family_ci99_5833': [percentile(boot, .05/24), percentile(boot, 1-.05/24)]
                        if primary and 'cycle_aggregate' not in (left, right) else None,
                    'pool_differences': diffs, 'pools_left_better': sum(d < 0 for d in diffs),
                    'pools_equal': sum(d == 0 for d in diffs), 'pools_left_worse': sum(d > 0 for d in diffs)})
            conditions.append({'alpha': example['alpha'], 'p': example['p'], 'primary': primary,
                'mean_quantum_fer': {arm: sum(v)/16 for arm, v in values.items()},
                'mean_exact_recovery_failure_fraction': {arm: sum(pool['arms'][arm][index]['exact_failures'] for pool in family['pools'])/80000 for arm in ARMS},
                'mean_nonexact_stabilizer_success_fraction': {arm: sum(pool['arms'][arm][index]['nonexact_stabilizer_successes'] for pool in family['pools'])/80000 for arm in ARMS},
                'contrasts': contrasts})
        output.append({'family': family['family'], 'conditions': conditions})
    return output


def decode(binary, manifest):
    families, frame_count, reference_checks, scoring_checks = [], 0, 0, 0
    for fi, family in enumerate(manifest['families']):
        pools = []
        config = family['configuration']
        for pool in family['pools']:
            samples, cache = noise_samples(fi, pool['id']), {}
            for code_id in sorted(set(pool['selected'].values())):
                code = pool['candidates'][code_id]
                hx, hz, vx, vz = q.expansion(code['bx'], code['bz'], config['ell'])
                xm, zm = list(map(p.decoder.rowmask, hx)), list(map(p.decoder.rowmask, hz))
                xb, zb = p.decoder.basis(xm), p.decoder.basis(zm)
                wx = sum(1 << v for v in code['logical_x']['logical_witness'])
                wz = sum(1 << v for v in code['logical_z']['logical_witness'])
                assert success(xm[0], zm[0], xb, zb) and success(0, 0, xb, zb)
                assert not success(wx, 0, xb, zb) and not success(0, wz, xb, zb)
                # Zero syndrome: the decoder returns zero; stabilizers succeed, logicals fail.
                for h, stabilizer, logical in ((hz, xm[0], wx), (hx, zm[0], wz)):
                    trials = [(.02, p.decoder.bit_string(e, code['n'])) for e in (stabilizer, logical)]
                    actual = p.decoder.engine(binary, h, code['n'], trials, 50, .8)
                    assert all(r == (0, True, '0'*code['n']) for r in actual)
                    scoring_checks += len(trials)
                results = []
                for alpha in (.8, 1.):
                    for h in (hx, hz):
                        trials = [(.02, p.decoder.bit_string(e, code['n'])) for e in (1, 3)]
                        for trial, actual in zip(trials, p.decoder.engine(binary, h, code['n'], trials, 50, alpha)):
                            assert actual == p.decoder.reference_decode(h, code['n'], trial[1], .02, 50, alpha)
                            reference_checks += 1
                    for prob, errors in samples.items():
                        xout = p.decoder.engine(binary, hz, code['n'], [(prob, x) for x, z in errors], 50, alpha)
                        zout = p.decoder.engine(binary, hx, code['n'], [(prob, z) for x, z in errors], 50, alpha)
                        fail, exact_fail, logical_fail, syndrome_fail = [], [], [], []
                        for (ex, ez), ox, oz in zip(errors, xout, zout):
                            rx = p.decoder.string_mask(ex) ^ p.decoder.string_mask(ox[2])
                            rz = p.decoder.string_mask(ez) ^ p.decoder.string_mask(oz[2])
                            matched_x = not any(p.decoder.syndrome(zm, rx))
                            matched_z = not any(p.decoder.syndrome(xm, rz))
                            assert (matched_x, matched_z) == (ox[1], oz[1])
                            good = success(rx, rz, xb, zb)
                            assert not good or (matched_x and matched_z)
                            fail.append(not good); exact_fail.append(bool(rx or rz))
                            logical_fail.append(matched_x and matched_z and not good)
                            syndrome_fail.append(not (matched_x and matched_z))
                        assert sum(fail) == sum(logical_fail)+sum(syndrome_fail)
                        frame_count += 5000
                        results.append({'alpha': alpha, 'p': prob, 'frames': 5000, 'failures': sum(fail),
                            'logical_syndrome_matched_failures': sum(logical_fail),
                            'syndrome_failures': sum(syndrome_fail), 'exact_failures': sum(exact_fail),
                            'nonexact_stabilizer_successes': sum(exact_fail)-sum(fail),
                            'quantum_fer': sum(fail)/5000, 'wilson95': p.wilson(sum(fail), 5000),
                            'failure_bitmap_zlib_base64': p.pack(fail),
                            'exact_failure_bitmap_zlib_base64': p.pack(exact_fail),
                            'logical_failure_bitmap_zlib_base64': p.pack(logical_fail),
                            'syndrome_failure_bitmap_zlib_base64': p.pack(syndrome_fail)})
                cache[code_id] = results
            pools.append({'id': pool['id'], 'noise_seed': 20261103+100000*fi+100*pool['id'],
                'sample_sha256': {str(prob): hashlib.sha256(''.join(x+z for x, z in errors).encode()).hexdigest() for prob, errors in samples.items()},
                'arms': {arm: cache[pool['selected'][arm]] for arm in ARMS}})
            print(f'CSS {config["family"]}: decoded pool {pool["id"]+1}/16', flush=True)
        families.append({'family': config['family'], 'configuration': config, 'pools': pools})
    result = {'status': 'literal_P11_CSS_two_sector_stabilizer_quotient_experiment',
        'selection_sha256': hashlib.sha256((HERE/'quantum-selection.json').read_bytes()).hexdigest(),
        'nominal_arm_frame_evaluations': 2*16*5*6*5000, 'actual_quantum_frames': frame_count,
        'actual_sector_decoder_executions': 2*frame_count, 'decoder_reference_checks': reference_checks,
        'stabilizer_logical_scoring_tests': scoring_checks, 'families': families,
        'analysis': analyze(families)}
    (HERE/'quantum-results.json').write_text(json.dumps(result, indent=2)+'\n')
    for family in result['analysis']:
        a = next(a for a in family['conditions'] if a['primary'])
        print(family['family'], a['mean_quantum_fer'], flush=True)


if __name__ == '__main__':
    with tempfile.TemporaryDirectory(prefix='p11-quantum-css-') as temp:
        metric_binary, decoder_binary = Path(temp)/'metrics', Path(temp)/'minsum'
        subprocess.run(['c++', '-std=c++17', '-O2', str(HERE/'graph_metrics.cpp'), '-o', str(metric_binary)], check=True)
        subprocess.run(['c++', '-std=c++17', '-O2', str(p.OLD/'minsum.cpp'), '-o', str(decoder_binary)], check=True)
        graph_counter_checks(metric_binary)
        decode(decoder_binary, select(metric_binary))
