"""Fresh no-weight-two population; see FOLLOWUP-PROTOCOL.md."""
from collections import Counter
from pathlib import Path
import hashlib
import json
import math
import random
import subprocess
import tempfile
import pilot as p

HERE = Path(__file__).resolve().parent


def run():
    rng = random.Random(20261025)
    codes, seen, rejected, attempts = [], set(), Counter(), 0
    while len(codes) < 32:
        attempts += 1
        B = [[0]*6]+[[0]+[rng.randrange(8) for _ in range(5)] for _ in range(2)]
        h, vn = p.construction(B, 3)
        if not p.connected(h, vn):
            rejected['disconnected'] += 1; continue
        if len(p.decoder.basis(list(map(p.decoder.rowmask, h)))) != 20:
            rejected['rank_mismatch'] += 1; continue
        if len(set(map(tuple, vn))) != 48:
            rejected['duplicate_binary_columns'] += 1; continue
        key = tuple(map(tuple, B))
        if key in seen:
            rejected['duplicate_array'] += 1; continue
        seen.add(key)
        spectrum = p.absorbing(vn)
        assert not any(s['a'] == 2 and s['b'] == 0 for s in spectrum)
        codes.append({'id': len(codes), 'B': B, 'n': 48, 'rank': 20, 'k': 28,
                      'cycles': p.cycle_counts(h, vn), 'absorbing_spectrum': spectrum,
                      'absorbing_features': p.abs_features(spectrum), 'conditions': []})
        print(f'follow-up graph {len(codes)}/32', flush=True)
    noise = random.Random(20261026)
    samples = {prob: [''.join('1' if noise.random() < prob else '0' for _ in range(48))
                      for _ in range(3000)] for prob in (.02, .05, .08)}
    checks = 0
    with tempfile.TemporaryDirectory(prefix='dyadic-performance-followup-') as temp:
        binary = Path(temp)/'minsum'
        subprocess.run(['c++', '-std=c++17', '-O2', str(p.OLD/'minsum.cpp'), '-o', str(binary)], check=True)
        for alpha in (.8, 1.):
            for code in codes:
                h, _ = p.construction(code['B'], 3)
                if code['id'] < 2:
                    trials = [(.05, p.decoder.bit_string(mask, 48)) for mask in (1, 3, 7, 0x1000101)]
                    for trial, actual in zip(trials, p.decoder.engine(binary, h, 48, trials, 50, alpha)):
                        assert actual == p.decoder.reference_decode(h, 48, trial[1], .05, 50, alpha)
                        checks += 1
                masks = list(map(p.decoder.rowmask, h))
                for prob in (.02, .05, .08):
                    errors = samples[prob]
                    out = p.decoder.engine(binary, h, 48, [(prob, e) for e in errors], 50, alpha)
                    fail = [e != result[2] for e, result in zip(errors, out)]
                    nonconv = [not result[1] for result in out]
                    assert all(result[1] == (p.decoder.syndrome(masks, p.decoder.string_mask(result[2]))
                                            == p.decoder.syndrome(masks, p.decoder.string_mask(e)))
                               for e, result in zip(errors, out))
                    code['conditions'].append({'alpha': alpha, 'p': prob,
                        'failures': sum(fail), 'nonconverged': sum(nonconv),
                        'wrong_converged': sum(fail)-sum(nonconv), 'fer': sum(fail)/3000,
                        'wilson95': p.wilson(sum(fail), 3000), 'failure_bitmap_zlib_base64': p.pack(fail)})
                print(f'follow-up decoder {alpha}: graph {code["id"]+1}/32', flush=True)
    groups = [json.dumps([c['cycles'], c['absorbing_spectrum']], sort_keys=True) for c in codes]
    rows = [c['cycles']+c['absorbing_features'] for c in codes]
    analyses = []
    for idx, condition in enumerate(codes[0]['conditions']):
        y = [math.log((c['conditions'][idx]['failures']+.5)/
                      (3000-c['conditions'][idx]['failures']+.5)) for c in codes]
        models = {}
        for name, ids in [('intercept', []), ('cycles', list(range(3))),
                          ('absorbing', list(range(3, 9))), ('combined', list(range(9)))]:
            pred = p.predictions([[math.log1p(row[j]) for j in ids] for row in rows], y, groups)
            models[name] = {'rmse_logit': math.sqrt(sum((u-v)**2 for u, v in zip(y, pred))/len(y)),
                            'held_out_predictions': pred}
        analyses.append({'alpha': condition['alpha'], 'p': condition['p'], 'models': models})
    # Compare fingerprints with the original population as an additional provenance check.
    original = json.loads((HERE/'results.json').read_text())
    oldgroups = {json.dumps([c['cycles'], c['absorbing_spectrum']], sort_keys=True) for c in original['codes']}
    paths = [Path(__file__), HERE/'pilot.py', HERE.parent/'FOLLOWUP-PROTOCOL.md', p.OLD/'minsum.cpp',
             p.OLD/'benchmark_decoding.py', p.OLD/'decoding.py', p.OLD/'optimize_absorbing.py', p.OLD/'scan.py']
    result = {'status': 'prospective_classical_followup_not_full_P11_resolution',
              'seed': 20261025, 'noise_seed': 20261026, 'attempts': attempts, 'rejected': dict(rejected),
              'fingerprint_groups': len(set(groups)), 'fingerprints_overlapping_original': len(set(groups)&oldgroups),
              'reference_checks': checks, 'codes': codes, 'analysis': analyses,
              'sample_sha256': {str(prob): hashlib.sha256(''.join(errors).encode()).hexdigest()
                                for prob, errors in samples.items()},
              'sha256': {str(path.relative_to(p.ROOT)): hashlib.sha256(path.read_bytes()).hexdigest()
                         for path in paths}}
    (HERE/'followup-results.json').write_text(json.dumps(result, indent=2)+'\n')
    for a in analyses:
        print(a['alpha'], a['p'], {k: round(v['rmse_logit'], 5) for k, v in a['models'].items()})


if __name__ == '__main__':
    run()
