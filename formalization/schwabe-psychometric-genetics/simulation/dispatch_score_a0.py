"""Fixed A0 dispatcher. `check` never runs R. `launch` requires external approval."""
import argparse
import fcntl
import json
import os
from pathlib import Path
import shutil
import signal
import subprocess
import sys
import time
from dispatch_jags_centered_extended_guarded import (ROOT, ENV, RSCRIPT, sha, write,
    memory_headroom, cpu_capacity, blocked_processes, BUSY, runtime_inventory)

MANIFEST = ROOT/'provenance/score-a0-dispatch-manifest.json'
NAMESPACE = ROOT/'production/score-a0-v1'
BUSY.add('score_a0_prepare_run.R')
CAPS = dict(chain_seconds=1600, summed_seconds=6420, all_seconds=7740,
            elapsed_seconds=3600, grace=5, poll=.1, rss=1024**3,
            total_rss=4*1024**3, reserve=2*1024**3, output=1024**3, log=16*1024**2)


def group_rss(pgid):
    total = 0
    for entry in Path('/proc').iterdir():
        if not entry.name.isdigit():
            continue
        try:
            fields = (entry/'stat').read_text().rsplit(') ',1)[1].split()
            if int(fields[2]) == pgid:
                total += int((entry/'statm').read_text().split()[1])*os.sysconf('SC_PAGE_SIZE')
        except (FileNotFoundError, ProcessLookupError):
            continue
    return total


def size_tree(directory):
    return sum(p.stat().st_size for p in directory.rglob('*') if p.is_file())


def signal_group(pid, sig):
    try:
        os.killpg(pid, sig)
    except ProcessLookupError:
        pass


def run_guarded(commands, directory, caps, *, memory_probe=memory_headroom,
                rss_probe=group_rss, start=None, charged=0, environment=None, idle_probe=None):
    """Bounded subprocess mechanics; tests inject harmless commands/probes only.

    Caps are sampled; reserve one poll plus cleanup per active worker before
    budget ceilings. No hard realtime or kernel-level RSS ceiling is claimed.
    """
    directory.mkdir()
    start = time.monotonic() if start is None else start
    rows = [dict(id=i+1, command=c, state='not_launched') for i,c in enumerate(commands)]
    active, spent, error = {}, 0., None
    old = {}
    def save():
        write(directory/'outcomes.json', dict(requested=len(rows), outcomes=rows,
            error=error, summed_process_seconds=spent, charged_before=charged,
            elapsed_seconds=time.monotonic()-start))
    def interrupt(sig, frame):
        raise InterruptedError('Signal '+str(sig))
    try:
        for sig in (signal.SIGINT,signal.SIGTERM,signal.SIGHUP):
            old[sig]=signal.signal(sig,interrupt)
        save()
        if memory_probe()['available_bytes'] < caps['reserve']+len(commands)*caps['rss']:
            raise RuntimeError('Insufficient prelaunch cgroup headroom')
        for row in rows:
            now=time.monotonic()
            accrued=spent+sum(now-t for _,_,t in active.values())
            safety=(len(active)+1)*(caps['grace']+caps['poll'])
            if (accrued+safety>=caps['summed_seconds'] or charged+accrued+safety>=caps['all_seconds']
                    or now-start+caps['grace']+caps['poll']>=caps['elapsed_seconds']):
                raise TimeoutError('Prelaunch budget or deadline exhausted')
            if memory_probe()['available_bytes']<caps['reserve']+caps['rss']:
                raise MemoryError('Prelaunch allocation unavailable')
            if size_tree(directory.parent)>caps['output']:raise RuntimeError('Prelaunch output cap breached')
            if idle_probe and idle_probe([p.pid for p,_,_ in active.values()]):raise RuntimeError('Competing worker')
            log=open(directory/f"process-{row['id']}.log",'xb')
            begun=time.monotonic()
            try:
                p=subprocess.Popen(row['command'],cwd=ROOT,env=environment or dict(os.environ,**ENV),
                    stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
            except BaseException:
                log.close();raise
            active[row['id']]=(p,log,begun)
            row.update(state='running',pid=p.pid)
            save()
        while active:
            if idle_probe and idle_probe([p.pid for p,_,_ in active.values()]):raise RuntimeError('Competing worker')
            now=time.monotonic()
            accrued=spent+sum(now-t for _,_,t in active.values())
            safety=len(active)*(caps['grace']+caps['poll'])
            if accrued+safety >= caps['summed_seconds'] or charged+accrued+safety>=caps['all_seconds']:
                raise TimeoutError('Summed process budget stop')
            if now-start+caps['grace']+caps['poll']>=caps['elapsed_seconds']:
                raise TimeoutError('Elapsed deadline stop')
            if memory_probe()['available_bytes']<caps['reserve']:
                raise MemoryError('Cgroup free reserve breached')
            rss=[rss_probe(p.pid) for p,_,_ in active.values()]
            if any(r>caps['rss'] for r in rss) or sum(rss)>caps['total_rss']:
                raise MemoryError('Owned process-group RSS cap breached')
            if size_tree(directory.parent)>caps['output']:
                raise RuntimeError('Namespace output cap breached')
            for ident,(p,log,t) in list(active.items()):
                if (directory/f'process-{ident}.log').stat().st_size>caps['log']:
                    raise RuntimeError('Log cap breached')
                if now-t+caps['poll']>=caps['chain_seconds']:
                    raise TimeoutError('Per-process wall cap reached')
                rc=p.poll()
                if rc is not None:
                    # Kill any lingering descendants even after successful leader exit.
                    signal_group(p.pid,signal.SIGKILL)
                    p.wait();log.close();duration=time.monotonic()-t;spent+=duration
                    rows[ident-1].update(state='completed' if rc==0 else 'failed',returncode=rc,elapsed_seconds=duration)
                    del active[ident];save()
                    if rc!=0:
                        raise RuntimeError('Worker failed; no replacement or pending expansion')
            if active: time.sleep(caps['poll'])
    except BaseException as exc:
        error=type(exc).__name__+': '+str(exc)
    finally:
        for sig in old: signal.signal(sig,signal.SIG_IGN)
        for p,_,_ in active.values():signal_group(p.pid,signal.SIGTERM)
        if active:time.sleep(caps['grace'])
        for ident,(p,log,t) in active.items():
            signal_group(p.pid,signal.SIGKILL);p.wait();log.close()
            duration=time.monotonic()-t;spent+=duration
            rows[ident-1].update(state='cancelled',returncode=p.returncode,elapsed_seconds=duration)
        save()
        for sig,handler in old.items():signal.signal(sig,handler)
    return dict(ok=error is None and all(r['state']=='completed' for r in rows),
                spent=spent,error=error,outcomes=rows)


def validate():
    m=json.loads(MANIFEST.read_text())
    if m['caps'] != CAPS: raise RuntimeError('Fixed cap mismatch')
    required={'simulation/dispatch_score_a0.py','simulation/score_a0_prepare_run.R','simulation/diagnose_score_a0.R',
        'simulation/dispatch_jags_centered_extended_guarded.py','simulation/jags_replication.R',
        'provenance/score-a0-reuse-evidence.json','provenance/score-pilot-source-and-resource-plan.json'}
    required.update(str(p.relative_to(ROOT)) for p in (ROOT/'production/jags-centered-extended-recovery-v1/prepared').rglob('*') if p.is_file())
    if not required.issubset(m['files']):raise RuntimeError('Missing mandatory identity')
    actual_prepared={p.name:sha(p) for p in (ROOT/'outputs/score-a0-prepared').iterdir() if p.is_file()}
    if not {'data.rds','model.jags','initials.rds','protocol.rds','prepared-hashes.csv'}.issubset(actual_prepared):raise RuntimeError('Incomplete prepared files')
    if m['prepared']!=actual_prepared:raise RuntimeError('Prepared inventory mismatch')
    if m['runtime']!=runtime_inventory():raise RuntimeError('Complete runtime inventory mismatch')
    for name,digest in m['files'].items():
        if sha(ROOT/name)!=digest:raise RuntimeError('Identity mismatch '+name)
    for name,digest in m['runtime'].items():
        if sha(name)!=digest:raise RuntimeError('Runtime mismatch '+name)
    if cpu_capacity()['effective_capacity']<4:raise RuntimeError('Four CPU slots required')
    if blocked_processes():raise RuntimeError('Competing model process')
    if memory_headroom()['available_bytes']<6*1024**3:raise RuntimeError('6GiB free cgroup capacity required')
    if NAMESPACE.exists():raise RuntimeError('Namespace exists; no retry or resume')
    return m


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('action',choices=['check','launch','stop'])
    ap.add_argument('--approval-reference')
    args=ap.parse_args()
    if args.action=='stop':
        r=json.loads((NAMESPACE/'dispatch.json').read_text());pid=r['pid']
        stat=Path(f'/proc/{pid}/stat')
        if not stat.exists():print('Supervisor absent; no PID signalled.');return
        current=stat.read_text().rsplit(') ',1)[1].split()[19]
        if current!=r['pid_start_ticks']:raise RuntimeError('PID reused; refuse signal')
        os.kill(pid,signal.SIGTERM);print('Sent TERM to verified supervisor; bounded group cleanup follows.');return
    if args.action=='check':
        validate();print('PASS: pinned inputs/runtime, CPU, memory and idle checks; no R started.');return
    if not args.approval_reference:raise RuntimeError('Explicit external sampling approval reference required')
    with open(ROOT/'production/.jags-dispatch.lock','a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        start=time.monotonic()
        def validation_timeout(sig,frame):raise TimeoutError('600-second read-only validation cap')
        previous=signal.signal(signal.SIGALRM,validation_timeout);signal.alarm(600)
        try:m=validate()
        finally:signal.alarm(0);signal.signal(signal.SIGALRM,previous)
        validation_seconds=time.monotonic()-start
        NAMESPACE.mkdir()
        write(NAMESPACE/'dispatch.json',dict(manifest=m,approval_reference=args.approval_reference,
            pid=os.getpid(),pid_start_ticks=Path('/proc/self/stat').read_text().rsplit(') ',1)[1].split()[19],requested_chain_ids=[1,2,3,4],validation_seconds=validation_seconds,meaning='No automatic retry or expansion'))
        # Copy only existing fixed inputs; never regenerate a dataset.
        commands=[[RSCRIPT,'simulation/score_a0_prepare_run.R','run',str(NAMESPACE/'prepared'),str(i)] for i in range(1,5)]
        write(NAMESPACE/'requested-chains.json',dict(requested=4,commands=commands,state='not_launched',meaning='Initial snapshot only; chains/outcomes.json is authoritative once created; absent chains means none launched'))
        prep=[sys.executable,'-c',"import shutil;shutil.copytree('outputs/score-a0-prepared','production/score-a0-v1/prepared')"]
        pc=dict(CAPS,chain_seconds=115,summed_seconds=120)
        result=run_guarded([prep],NAMESPACE/'preparation',pc,start=start,charged=validation_seconds)
        charged=validation_seconds+result['spent']
        if not result['ok']:raise RuntimeError('Preparation copy failed; all four chains not launched')
        for name,digest in m['prepared'].items():
            if sha(NAMESPACE/'prepared'/name)!=digest:raise RuntimeError('Copied prepared input mismatch')
        env=dict(os.environ,**ENV,SCORE_A0_SAMPLING_AUTHORIZED='1')
        result=run_guarded(commands,NAMESPACE/'chains',CAPS,start=start,charged=charged,environment=env,idle_probe=blocked_processes)
        charged+=result['spent']
        if not result['ok']:raise RuntimeError('Chain stage stopped; partials retained, no further sampling')
        diag=[RSCRIPT,'simulation/diagnose_score_a0.R',str(NAMESPACE/'prepared')]
        dc=dict(CAPS,chain_seconds=595,summed_seconds=600)
        result=run_guarded([diag],NAMESPACE/'diagnostic',dc,start=start,charged=charged)
        write(NAMESPACE/'terminal.json',dict(diagnostic_completed=result['ok'],summed_process_seconds=charged+result['spent'],
            manual_review='required; no automatic convergence/scientific verdict',sampling_expansion=False))
        if not result['ok']:raise RuntimeError('Diagnostic stage failed; no retry')

if __name__=='__main__':main()
