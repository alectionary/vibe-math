#!/usr/bin/env python3
"""Bounded heuristic refresh of seven unbalanced universal integer-form templates.

Float proposals are accepted only by the existing exact independent consumers.
An empty result is not an exhaustive separation or membership certificate.
"""
from pathlib import Path
import argparse
import datetime
import hashlib
import json
import subprocess
import sys
import time

from physical_integer_form_rows import coordinate
from verify_projected_profile_moment_rows import point_vector

ROOT = Path(__file__).resolve().parent
TEMPLATES = [
    [1, 1, 1, -1],
    [1, 1, 1, 1, -1],
    [1, 1, 1, 1, -1, -1],
    [1, 1, 1, 1, 1, -1, -1],
    [1, 1, 1, 1, 1, -1, -1, -1],
    [2, 1, 1, -1],
    [2, 1, 1, -1, -1],
]


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--prefix', type=Path, required=True)
    ap.add_argument('--binary', type=Path, required=True)
    ap.add_argument('--restarts', type=int, default=1000)
    ap.add_argument('--seconds', type=float, default=30)
    ap.add_argument('--seed', type=int, default=202610301450)
    a = ap.parse_args()
    assert a.restarts > 0 and a.seconds > 0
    def path(suffix):
        p = Path(str(a.prefix) + suffix)
        assert not p.exists(), ('Preserve prior attempt', p)
        return p
    a.prefix.parent.mkdir(exist_ok=True)
    inp = path('-input.txt')
    point = point_vector(a.point)
    with inp.open('w') as f:
        f.write('90 16\n' + ' '.join(format(float(point[i % 45]), '.17g') for i in range(90)) + '\n')
        for h in range(16):
            f.write(' '.join(format(float(point[coordinate(16*i, 16*j+h)]), '.17g')
                             for i in range(90) for j in range(90)) + '\n')
    commands = [[str(a.binary), str(inp), str(path(f'-{i}.json')),
                 ','.join(map(str, w)), str(a.restarts), str(a.seconds), str(a.seed+i), '0']
                for i, w in enumerate(TEMPLATES)]
    sources = [Path(__file__), Path('separate_higher_integer_forms.cpp'), a.point,
               Path('physical_integer_form_rows.py'), Path('verify_projected_profile_moment_rows.py'),
               Path('accept_physical_integer_forms.py'), Path('verify_physical_integer_forms.py'), inp]
    hashes = {str(p): sha(p) for p in sources}
    frozen = path('-frozen.json')
    frozen.write_text(json.dumps(dict(status='FROZEN_BEFORE_HIGHER_INTEGER_FORM_REFRESH',
        utc=datetime.datetime.now(datetime.timezone.utc).isoformat(), source_C16_answered=False,
        commands=commands, source_hashes=hashes, binary_sha256=sha(a.binary),
        scope='Seven unbalanced heuristic integer-form templates; not complete separation.'), indent=2)+'\n')
    start = time.monotonic()
    results = []
    cuts = []
    for i, cmd in enumerate(commands):
        with path(f'-{i}.log').open('w') as log:
            process = subprocess.run(cmd, stdout=log, stderr=subprocess.STDOUT,
                                     timeout=a.seconds+15, check=True)
        proposal = json.loads(Path(cmd[2]).read_text())
        cuts.extend(proposal['cuts'])
        results.append({k: proposal[k] for k in ['maximum_violation', 'restarts', 'moves', 'seconds']}
                       | {'template': i, 'proposals': len(proposal['cuts']), 'returncode': process.returncode})
    merged = path('-candidates.json')
    merged.write_text(json.dumps(dict(status='MERGED_HEURISTIC_PROPOSALS', source_C16_answered=False,
                                     cuts=cuts, frozen_sha256=sha(frozen)), indent=2)+'\n')
    bank = path('-bank.json')
    with path('-accept.log').open('w') as log:
        subprocess.run([sys.executable, 'accept_physical_integer_forms.py', '--candidates', str(merged),
                        '--point', str(a.point), '--output', str(bank)], stdout=log,
                       stderr=subprocess.STDOUT, timeout=60, check=True)
    accepted = json.loads(bank.read_text())['cuts']
    receipt = None
    if accepted:
        receipt = path('-independent.json')
        with path('-independent.log').open('w') as log:
            subprocess.run([sys.executable, 'verify_physical_integer_forms.py', '--bank', str(bank),
                            '--point', str(a.point), '--output', str(receipt)], stdout=log,
                           stderr=subprocess.STDOUT, timeout=90, check=True)
        assert json.loads(receipt.read_text())['status'] == 'PASS'
    assert all(sha(p)==v for p, v in hashes.items())
    out = dict(status='ACCEPTED_EXACT_INTEGER_FORM_ROWS' if accepted else 'BOUNDED_REFRESH_NO_CUT',
               source_C16_answered=False, stages=results, raw_proposals=len(cuts),
               accepted_unique_rows=len(accepted), bank_sha256=sha(bank),
               independent_sha256=sha(receipt) if receipt else None,
               sources_unchanged=True, frozen_sha256=sha(frozen), seconds=time.monotonic()-start)
    path('-summary.json').write_text(json.dumps(out, indent=2)+'\n')
    print(json.dumps(out), flush=True)


if __name__ == '__main__':
    main()
