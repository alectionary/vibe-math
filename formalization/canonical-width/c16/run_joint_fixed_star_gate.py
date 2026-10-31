"""One frozen joint fixed-law owner-star gate, with a hard external limit."""
from pathlib import Path
import hashlib
import json
import os
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parent
PREFIX = ROOT / 'two-basis-results/joint-fixed-star-original-cuts-point22'
ARGS = [sys.executable, '-u', 'two_basis_joint_fixed_star.py',
        '--point', 'coupling-results/two-basis-integer-witness22-rational.json.gz',
        '--x-config', 'two-basis-results/two-basis-direct-X-closedrank-point22.frozen.json',
        '--z-config', 'two-basis-results/two-basis-direct-Z-closedrank-point22.frozen.json',
        '--star-bank', 'two-basis-results/conditional-owner-star-original-point22.json.gz',
        '--star-receipt', 'two-basis-results/conditional-owner-star-original-point22-independent.json',
        '--output', str(PREFIX) + '.json', '--seconds', '120']


def main():
    output = Path(str(PREFIX) + '.launch.json')
    assert not output.exists()
    output.write_text(json.dumps(dict(args=ARGS, internal_seconds=120,
                                     external_seconds=180, retries=0,
                                     source_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest()),
                                 indent=2)+'\n')
    env = dict(os.environ)
    for name in ['OPENBLAS_NUM_THREADS', 'OMP_NUM_THREADS', 'MKL_NUM_THREADS',
                 'VECLIB_MAXIMUM_THREADS']:
        env[name] = '1'
    start = time.monotonic()
    with Path(str(PREFIX) + '.log').open('w') as log:
        try:
            p = subprocess.run(ARGS, cwd=ROOT, env=env, stdout=log,
                               stderr=subprocess.STDOUT, timeout=180)
            result = dict(returncode=p.returncode, external_timeout=False)
        except subprocess.TimeoutExpired:
            result = dict(returncode=None, external_timeout=True)
    result['elapsed_seconds'] = time.monotonic()-start
    Path(str(PREFIX) + '.exit.json').write_text(json.dumps(result, indent=2)+'\n')
    print(result, flush=True)


if __name__ == '__main__':
    main()
