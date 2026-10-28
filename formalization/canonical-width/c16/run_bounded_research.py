#!/usr/bin/env python3
"""Run one research child with a wall limit, durable logs and an exit receipt."""
import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import subprocess
import time


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--wall-seconds', type=float, required=True)
    ap.add_argument('--deadline', default='2026-10-28T12:30:00+00:00')
    ap.add_argument('--log', type=Path, required=True)
    ap.add_argument('--receipt', type=Path, required=True)
    ap.add_argument('command', nargs=argparse.REMAINDER)
    a = ap.parse_args()
    command = a.command[1:] if a.command[:1] == ['--'] else a.command
    assert command and a.wall_seconds > 0
    now = datetime.now(timezone.utc)
    allowance = min(a.wall_seconds, (datetime.fromisoformat(a.deadline) - now).total_seconds())
    assert allowance > 0, 'Experiment deadline already passed'
    a.log.parent.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ)
    env.update(OPENBLAS_NUM_THREADS='1', OMP_NUM_THREADS='1', VECLIB_MAXIMUM_THREADS='1', MKL_NUM_THREADS='1')
    result = dict(status='STARTING', started_utc=now.isoformat(), command=command,
                  wall_allowance=allowance, hard_deadline=a.deadline)
    a.receipt.write_text(json.dumps(result, indent=2)+'\n')
    start = time.monotonic()
    with a.log.open('w') as log:
        child = subprocess.Popen(command, stdout=log, stderr=subprocess.STDOUT, env=env)
        result.update(status='RUNNING', child_pid=child.pid)
        a.receipt.write_text(json.dumps(result, indent=2)+'\n')
        try:
            code = child.wait(timeout=allowance)
            result.update(status='EXITED', exit_code=code)
        except subprocess.TimeoutExpired:
            child.terminate()
            try:
                code = child.wait(timeout=5)
            except subprocess.TimeoutExpired:
                child.kill()
                code = child.wait(timeout=5)
            result.update(status='WALL_LIMIT', exit_code=code, termination_confirmed=True)
    result.update(wall_seconds=time.monotonic()-start,
                  finished_utc=datetime.now(timezone.utc).isoformat())
    a.receipt.write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps(result), flush=True)


if __name__ == '__main__':
    main()
