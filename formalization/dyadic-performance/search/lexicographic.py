"""Fresh-noise sensitivity to the cycle objective; original results preserved."""
from pathlib import Path
import hashlib
import json
import random
import subprocess
import tempfile
import optimize as o
import pilot as p

HERE = Path(__file__).resolve().parent


def samples(pool_id):
    rng = random.Random(20261030+100*pool_id)
    return {prob: [''.join('1' if rng.random() < prob else '0' for _ in range(48))
                   for _ in range(5000)] for prob in (.02, .05, .08)}


def run():
    original = json.loads((HERE/'optimization-selection.json').read_text())
    choices = []
    for pool in original['pools']:
        selected = dict(pool['selected'])
        selected['cycles'] = min(pool['candidates'], key=lambda c: (tuple(c['cycles']), o.lex_array(c)))['id']
        choices.append({'id': pool['id'], 'selected': selected})
    paths = [Path(__file__), HERE/'optimize.py', HERE/'pilot.py', HERE.parent/'LEXICOGRAPHIC-PROTOCOL.md',
             HERE/'optimization-selection.json']
    manifest = {'status': 'shortest_cycle_first_choices_saved_before_fresh_decoding', 'pools': choices,
                'sha256': {str(path.relative_to(p.ROOT)): hashlib.sha256(path.read_bytes()).hexdigest()
                           for path in paths}}
    (HERE/'lexicographic-selection.json').write_text(json.dumps(manifest, indent=2)+'\n')
    output, actual_decodes, checks = [], 0, 0
    with tempfile.TemporaryDirectory(prefix='dyadic-lexicographic-') as temp:
        binary = Path(temp)/'minsum'
        subprocess.run(['c++', '-std=c++17', '-O2', str(p.OLD/'minsum.cpp'), '-o', str(binary)], check=True)
        for pool, choice in zip(original['pools'], choices):
            errors_by_p, cache = samples(pool['id']), {}
            for code_id in sorted(set(choice['selected'].values())):
                code = pool['candidates'][code_id]
                h, _ = p.construction(code['B'], 3)
                masks, conditions = list(map(p.decoder.rowmask, h)), []
                for alpha in (.8, 1.):
                    trials = [(.05, p.decoder.bit_string(mask, 48)) for mask in (1, 3)]
                    for trial, actual in zip(trials, p.decoder.engine(binary, h, 48, trials, 50, alpha)):
                        assert actual == p.decoder.reference_decode(h, 48, trial[1], .05, 50, alpha)
                        checks += 1
                    for prob, errors in errors_by_p.items():
                        out = p.decoder.engine(binary, h, 48, [(prob, e) for e in errors], 50, alpha)
                        fail = [e != r[2] for e, r in zip(errors, out)]
                        assert all(r[1] == (p.decoder.syndrome(masks, p.decoder.string_mask(r[2])) ==
                                            p.decoder.syndrome(masks, p.decoder.string_mask(e)))
                                   for e, r in zip(errors, out))
                        nonconv = sum(not r[1] for r in out)
                        conditions.append({'alpha': alpha, 'p': prob, 'frames': 5000,
                            'failures': sum(fail), 'nonconverged': nonconv,
                            'wrong_converged': sum(fail)-nonconv, 'fer': sum(fail)/5000,
                            'wilson95': p.wilson(sum(fail), 5000), 'failure_bitmap_zlib_base64': p.pack(fail)})
                        actual_decodes += 5000
                cache[code_id] = conditions
            output.append({'id': pool['id'], 'noise_seed': 20261030+100*pool['id'],
                'sample_sha256': {str(prob): hashlib.sha256(''.join(errors).encode()).hexdigest()
                                  for prob, errors in errors_by_p.items()},
                'arms': {arm: cache[choice['selected'][arm]] for arm in o.ARMS}})
            print(f'lexicographic sensitivity pool {pool["id"]+1}/16', flush=True)
    result = {'status': 'followup_shortest_cycle_first_sensitivity_same_candidate_pools_fresh_noise',
              'not_original_prespecified_primary_comparison': True,
              'selection_sha256': hashlib.sha256((HERE/'lexicographic-selection.json').read_bytes()).hexdigest(),
              'nominal_arm_decodes': 1920000, 'actual_decoder_executions': actual_decodes,
              'reference_checks': checks, 'pools': output, 'analysis': o.analyze(output)}
    (HERE/'lexicographic-results.json').write_text(json.dumps(result, indent=2)+'\n')
    for a in result['analysis']:
        print(a['alpha'], a['p'], a['mean_fer'])


if __name__ == '__main__':
    run()
