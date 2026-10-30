#!/usr/bin/env python3
"""Freeze a bounded selected-case moment maximization of the integer-row model."""
from pathlib import Path
import argparse
import datetime
import hashlib
import json
import os
import subprocess
import sys
import time
from run_integer_coupling_trial import local_imports

ROOT = Path(__file__).resolve().parent


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--parent', type=Path, required=True)
    ap.add_argument('--warm-point', type=Path, required=True)
    ap.add_argument('--name', required=True)
    ap.add_argument('--case', type=int, nargs=3, required=True)
    ap.add_argument('--margin', type=float, default=0)
    ap.add_argument('--floor-multiplier', type=float, required=True)
    ap.add_argument('--seconds', type=float, default=120)
    ap.add_argument('--outer-seconds', type=float, default=240)
    a = ap.parse_args()
    assert a.margin == 0 and 0 < a.seconds <= 120 and a.outer_seconds <= 240
    assert '/' not in a.name
    folder = ROOT/'coupling-results'
    output = folder/(a.name+'.json')
    frozen = folder/(a.name+'-frozen.json')
    assert not output.exists() and not frozen.exists()
    parent = json.loads(a.parent.read_text())
    assert all(sha(ROOT/p) == v for p, v in parent['input_and_source_hashes'].items())
    old = parent['command']
    assert old[2] == 'unified_integer_coupling_model.py'
    def values(flag):
        i = max(i for i, v in enumerate(old) if v == flag)+1
        j = i
        while j < len(old) and not old[j].startswith('--'):
            j += 1
        return old[i:j]
    keys = list(dict.fromkeys(v for v in old[3:] if v.startswith('--')))
    replacements = {'--warm-point': [str(a.warm_point)], '--output': [str(output.relative_to(ROOT))],
                    '--seconds': [str(a.seconds)], '--psd-interior-epsilon': [str(a.margin)],
                    '--boolean-margin': [str(a.margin/10)], '--projected-margin': [str(a.margin/10)]}
    command = [sys.executable, '-u', 'case_floor_integer_coupling_maximize.py']
    for k in keys:
        command += [k, *replacements.get(k, values(k))]
    bridge = Path('coupling-results/cover-case-moment-bridge-witness8.json')
    replay = Path('two-basis-results/case-floor-bridge-independent.json')
    condition = next(r for r in json.loads(bridge.read_text())['records'] if r['case'] == a.case)
    command += ['--floor-multiplier', str(a.floor_multiplier), '--case', *map(str, a.case), '--case-bridge', str(bridge), '--case-replay', str(replay)]
    sources = dict(parent['input_and_source_hashes'])
    closure = set()
    local_imports(Path(__file__).resolve(), closure)
    local_imports(ROOT/'case_floor_integer_coupling_maximize.py', closure)
    for p in closure:
        sources[str(p.relative_to(ROOT))] = sha(p)
    for p in [a.parent, a.warm_point, bridge, replay, Path('verify_cover_case_moment_bridge.py')]:
        sources[str(p)] = sha(p)
    write = dict(status='FROZEN_LATEST_INTEGER_CASE_FOLLOWUP', source_C16_answered=False,
                 source_anchor_excluded=False, utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                 command=command, input_and_source_hashes=sources, case_condition=condition,
                 mode='necessary_zero_margin' if a.margin == 0 else 'sufficient_witness_search',
                 effective_margins={k: float(replacements[k][0]) for k in
                                   ['--psd-interior-epsilon', '--boolean-margin', '--projected-margin']},
                 seconds=a.seconds, outer_seconds=a.outer_seconds, trial_floor_multiplier=a.floor_multiplier,
                 scope='One source-valid selected-pair floor. A numerical outcome requires exact primal or dual replay.')
    frozen.write_text(json.dumps(write, indent=2)+'\n')
    env = os.environ.copy()
    env.update({k: '1' for k in ['OPENBLAS_NUM_THREADS', 'OMP_NUM_THREADS', 'VECLIB_MAXIMUM_THREADS', 'MKL_NUM_THREADS']})
    t = time.monotonic()
    with (folder/(a.name+'.log')).open('w') as log:
        try:
            result = subprocess.run(command, stdout=log, stderr=subprocess.STDOUT, env=env, cwd=ROOT,
                                    timeout=a.outer_seconds)
            code = result.returncode
        except subprocess.TimeoutExpired:
            code = None
    unchanged = {p: sha(ROOT/p) == h for p, h in sources.items()}
    out = dict(status='NUMERICAL_CASE_FOLLOWUP_ONLY', source_C16_answered=False, source_anchor_excluded=False,
               returncode=code, outer_timeout=code is None, seconds=time.monotonic()-t,
               sources_unchanged=unchanged, frozen_sha256=sha(frozen))
    (folder/(a.name+'-exit.json')).write_text(json.dumps(out, indent=2)+'\n')
    assert all(unchanged.values())
    print({k: v for k, v in out.items() if k != 'sources_unchanged'}, flush=True)


if __name__ == '__main__':
    main()
