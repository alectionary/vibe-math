#!/usr/bin/env python3
"""One frozen capacity-allocation rank cohort, with a hard 600-second cap."""
import os
assert os.getpriority(os.PRIO_PROCESS, 0) == 19
for key in ('OPENBLAS_NUM_THREADS', 'OMP_NUM_THREADS', 'MKL_NUM_THREADS',
            'VECLIB_MAXIMUM_THREADS', 'NUMEXPR_NUM_THREADS', 'BLIS_NUM_THREADS'):
    os.environ[key] = '1'
os.environ['PYTHONDONTWRITEBYTECODE'] = '1'
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import time
import psutil

ROOT = Path(__file__).resolve().parent
PREFIX = ROOT/'two-basis-results/joint-capacity-ranks-point22'
CONFIG = ROOT/'two-basis-results/joint-capacity-ranks-point22-config.json'

def main():
    log = Path(str(PREFIX)+'.supervisor.log')
    result = Path(str(PREFIX)+'.supervisor.json')
    assert not log.exists() and not result.exists()
    started = time.monotonic()
    command = [sys.executable, '-B', 'two_basis_physical_capacity_batch.py',
               '--config', str(CONFIG.relative_to(ROOT)),
               '--output-prefix', str(PREFIX.relative_to(ROOT))]
    with log.open('w') as stream:
        child = subprocess.Popen(command, cwd=ROOT, env=os.environ,
                                 stdout=stream, stderr=subprocess.STDOUT)
        assert psutil.Process(child.pid).nice() == 19
        try:
            code = child.wait(timeout=600)
        except subprocess.TimeoutExpired:
            descendants = psutil.Process(child.pid).children(recursive=True)
            for process in reversed(descendants):
                try: process.kill()
                except psutil.NoSuchProcess: pass
            child.kill()
            child.wait()
            code = 'EXTERNAL_TOTAL_TIME_LIMIT'
    record = dict(status='CAPACITY_RANK_COHORT_SUPERVISOR_FINISHED',
                  returncode=code, elapsed_seconds=time.monotonic()-started,
                  external_cap_seconds=600, nice=19, threads=1,
                  config_sha256=hashlib.sha256(CONFIG.read_bytes()).hexdigest(),
                  producer_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
                  log_sha256=hashlib.sha256(log.read_bytes()).hexdigest(),
                  no_star_cohort=True, automatic_repair_performed=False)
    result.write_text(json.dumps(record, indent=2)+'\n')
    print(json.dumps(record), flush=True)
    if code != 0: sys.exit(1)

if __name__ == '__main__': main()
