#!/usr/bin/env python3
"""Recover and independently screen a bounded coupled-moment candidate.

The result is a certificate for the listed relaxation only. A failed recovery
or separated candidate never establishes infeasibility of the source problem.
"""
from pathlib import Path
import argparse, ast, datetime, hashlib, json, os, subprocess, sys, time

ROOT = Path(__file__).resolve().parent
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def local_imports(path, found):
    if path in found:
        return
    found.add(path)
    for node in ast.walk(ast.parse(path.read_text())):
        modules = ([node.module] if isinstance(node, ast.ImportFrom) else
                   [a.name for a in node.names] if isinstance(node, ast.Import) else [])
        for module in modules:
            if module:
                candidate = ROOT / (module.split('.')[0] + '.py')
                if candidate.exists():
                    local_imports(candidate, found)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--name', required=True)
    ap.add_argument('--direct-triples', action='store_true')
    a = ap.parse_args()
    base = 'coupling-results/' + a.name
    old = 'moment-resumption-results/'
    point = base + '-rational.json.gz'
    trial = json.loads((ROOT / (base + '-frozen.json')).read_text())
    command = trial['command']
    def values(flag):
        i = max(i for i, v in enumerate(command) if v == flag) + 1
        j = i
        while j < len(command) and not command[j].startswith('--'):
            j += 1
        return command[i:j]
    steps = [
        ('old-replay', 'recover_small_positive_moment_point.py',
         ['--numeric', base + '.npz', '--certificate', point]),
        ('unified-exact', 'verify_unified_moment_point.py',
         ['--certificate', point, '--old-replay', base + '-old-replay.json',
          '--matroid-cuts', *values('--matroid-cuts'),
          '--matroid-replays', *values('--matroid-replays')]),
        ('projected-exact', 'verify_projected_profile_moment_rows.py',
         ['--point', point, '--banks', *values('--projected-cuts'),
          '--replays', *values('--projected-replays'), '--require-feasible']),
        ('basis-exact', 'verify_anchor_coupling_rows.py',
         ['--point', point, '--banks', *values('--basis-cuts'),
          '--replays', *values('--basis-replays'), '--require-feasible']),
        ('global-moment-screen', 'check_global_conditioned_moments.py',
         ['--point', point, '--global-certificate', old + 'global-four-trial.json',
          '--global-replay', old + 'global-four-trial-independent.json']),
        ('all-triples', 'complete_boolean_triples.py', ['--point', point]),
    ]
    if a.direct_triples:
        steps.append(('triple-distributions', 'verify_all_triple_distributions.py', ['--point', point]))
    frozen_path = ROOT / (base + '-checks-frozen.json')
    assert not frozen_path.exists(), 'Preserve previous acceptance attempts'
    source_paths = set()
    local_imports(Path(__file__).resolve(), source_paths)
    for _, script, _ in steps:
        local_imports(ROOT / script, source_paths)
    inputs = {str(p.relative_to(ROOT)): sha(p) for p in sorted(source_paths)}
    for path, digest in trial['input_and_source_hashes'].items():
        assert sha(ROOT / path) == digest, ('trial dependency changed', path)
        inputs[path] = digest
    for path in [base + '.npz', base + '-frozen.json', old + 'global-four-trial.json', old + 'global-four-trial-independent.json']:
        inputs[path] = sha(ROOT / path)
    commands = [[sys.executable, '-u', script, *args, '--output', base + '-' + name + '.json']
                for name, script, args in steps]
    frozen_path.write_text(json.dumps({'status': 'FROZEN_BEFORE_EXACT_CHECKS',
        'utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
        'commands': commands, 'input_and_source_hashes': inputs,
        'source_C16_answered': False}, indent=2) + '\n')
    env = os.environ.copy()
    env.update({k: '1' for k in ['OPENBLAS_NUM_THREADS', 'OMP_NUM_THREADS', 'VECLIB_MAXIMUM_THREADS', 'MKL_NUM_THREADS']})
    records = []
    start = time.monotonic()
    for (name, _, _), cmd in zip(steps, commands):
        output = ROOT / (base + '-' + name + '.json')
        assert not output.exists(), output
        t = time.monotonic()
        with (ROOT / (base + '-' + name + '.log')).open('w') as log:
            try:
                result = subprocess.run(cmd, cwd=ROOT, env=env, stdout=log, stderr=subprocess.STDOUT, timeout=180)
                code = result.returncode
            except subprocess.TimeoutExpired:
                code = None
        receipt = json.loads(output.read_text()) if output.exists() else {}
        rec = {'stage': name, 'returncode': code, 'status': receipt.get('status'),
               'seconds': time.monotonic() - t, 'receipt_sha256': sha(output) if output.exists() else None}
        records.append(rec)
        print(rec, flush=True)
        if name == 'old-replay' and (code != 0 or receipt.get('status') != 'PASS'):
            break
    unchanged = {p: sha(ROOT / p) == d for p, d in inputs.items()}
    accepted = len(records) == len(steps) and all(r['returncode'] == 0 and r['status'] == 'PASS' for r in records) and all(unchanged.values())
    summary = {'status': 'PASS_LISTED_RELAXATION' if accepted else 'NOT_FULLY_ACCEPTED',
               'source_C16_answered': False, 'stages': records, 'sources_unchanged': unchanged,
               'seconds': time.monotonic() - start, 'frozen_sha256': sha(frozen_path)}
    (ROOT / (base + '-checks-summary.json')).write_text(json.dumps(summary, indent=2) + '\n')
    print(summary['status'], flush=True)

if __name__ == '__main__':
    main()
