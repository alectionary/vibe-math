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
    ap.add_argument('--max-address-mb', type=int, default=0)
    ap.add_argument('--max-rss-mb', type=int, default=0)
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
                  wall_allowance=allowance, hard_deadline=a.deadline,
                  max_address_mb=a.max_address_mb or None,max_rss_mb=a.max_rss_mb or None)
    a.receipt.write_text(json.dumps(result, indent=2)+'\n')
    start = time.monotonic()
    with a.log.open('w') as log:
        def address_limit():
            import resource
            limit=a.max_address_mb*1024*1024
            resource.setrlimit(resource.RLIMIT_AS,(limit,limit))
        try:
            child = subprocess.Popen(command, stdout=log, stderr=subprocess.STDOUT, env=env,
                                     preexec_fn=address_limit if a.max_address_mb else None)
        except Exception as error:
            result.update(status='FAILED_TO_START',error=type(error).__name__+': '+str(error),
                          wall_seconds=time.monotonic()-start,
                          finished_utc=datetime.now(timezone.utc).isoformat())
            a.receipt.write_text(json.dumps(result,indent=2)+'\n')
            print(json.dumps(result),flush=True)
            return
        result.update(status='RUNNING', child_pid=child.pid)
        a.receipt.write_text(json.dumps(result, indent=2)+'\n')
        limit_status=None
        peak_rss=0
        last_snapshot=start
        while child.poll() is None:
            if time.monotonic()-start>=allowance:
                limit_status='WALL_LIMIT'
                break
            if a.max_rss_mb:
                try:
                    import psutil
                    proc=psutil.Process(child.pid)
                    rss=proc.memory_info().rss+sum(p.memory_info().rss for p in proc.children(recursive=True))
                    peak_rss=max(peak_rss,rss)
                    if rss>a.max_rss_mb*1024*1024:
                        limit_status='RSS_LIMIT'
                        break
                except psutil.NoSuchProcess:
                    break
                except Exception as error:
                    result['monitoring_error']=type(error).__name__+': '+str(error)
                    limit_status='MEMORY_MONITOR_FAILURE'
                    break
            if time.monotonic()-last_snapshot>=15:
                result.update(peak_rss_mb=peak_rss/1024/1024,elapsed_seconds=time.monotonic()-start)
                a.receipt.write_text(json.dumps(result,indent=2)+'\n')
                last_snapshot=time.monotonic()
            try:
                child.wait(timeout=min(1,max(0.001,allowance-(time.monotonic()-start))))
            except subprocess.TimeoutExpired:
                pass
        if limit_status:
            child.terminate()
            try:
                code = child.wait(timeout=5)
            except subprocess.TimeoutExpired:
                child.kill()
                code = child.wait(timeout=5)
            result.update(status=limit_status, exit_code=code, termination_confirmed=True)
        else:
            result.update(status='EXITED',exit_code=child.wait())
        result['peak_rss_mb']=peak_rss/1024/1024 if a.max_rss_mb else None
    result.update(wall_seconds=time.monotonic()-start,
                  finished_utc=datetime.now(timezone.utc).isoformat())
    a.receipt.write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps(result), flush=True)


if __name__ == '__main__':
    main()
