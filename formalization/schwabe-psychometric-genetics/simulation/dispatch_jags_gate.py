"""Study-specific, bounded dispatcher. No sampling in check or fixture commands."""
import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path
import signal
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]
PROTOCOL = ROOT / 'provenance/jags-dispatch-protocol.json'
OWNED_NS = None
RSCRIPT = '/workspace/slot3-runtime/bin/Rscript'
WRAPPER = 'simulation/jags_convergence_gate.R'
DIAGNOSTIC = 'simulation/diagnose_jags_gate.R'
BUSY = {'production_supervisor.py', 'production_runner.py', 'production_batch.R',
        'openmx_production.R', 'jags_convergence_gate.R', 'jags_replication.R'}
ENV = {k: '1' for k in ('OMP_NUM_THREADS', 'OPENBLAS_NUM_THREADS', 'MKL_NUM_THREADS',
                       'VECLIB_MAXIMUM_THREADS', 'NUMEXPR_NUM_THREADS')}
ENV['R_LIBS_USER'] = '/workspace/slot3-posterior-library'


def sha(path):
    h = hashlib.sha256()
    with open(path, 'rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def write(path, value):
    tmp = path.with_suffix(path.suffix + '.tmp')
    tmp.write_text(json.dumps(value, indent=2) + '\n')
    tmp.replace(path)


def utc():
    return time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())


def blocked_processes(exclude=()):
    blocked = []
    for entry in Path('/proc').iterdir():
        if not entry.name.isdigit() or int(entry.name) in {*exclude, os.getpid()}:
            continue
        try:
            args = (entry / 'cmdline').read_bytes().decode().split('\0')
            # Match argv tokens, not shell source strings or monitor text.
            names = {Path(a.removeprefix('--file=')).name for a in args if a}
            if names & BUSY:
                blocked.append({'pid': int(entry.name), 'argv': args})
        except FileNotFoundError:
            continue
        except PermissionError as error:
            raise RuntimeError('Cannot inspect process table safely') from error
    return blocked


def cpu_capacity(cgroup_root=Path('/sys/fs/cgroup'), membership=Path('/proc/self/cgroup')):
    entries = membership.read_text().splitlines()
    unified = [line.split(':', 2)[2] for line in entries if line.startswith('0::')]
    if len(unified) != 1:
        raise RuntimeError('Verified cgroup v2 CPU quota required')
    current = cgroup_root / unified[0].lstrip('/')
    if not current.is_dir():
        raise RuntimeError('Cannot resolve current cgroup CPU quota')
    limits = []
    while True:
        path = current / 'cpu.max'
        if not path.exists():
            raise RuntimeError('Cannot inspect cgroup CPU quota: ' + str(path))
        quota, period = path.read_text().split()
        if quota != 'max':
            limits.append(int(quota) / int(period))
        if current == cgroup_root:
            break
        current = current.parent
    affinity = len(os.sched_getaffinity(0))
    return {'affinity_slots': affinity, 'quota_limits': limits,
            'effective_capacity': min([affinity, *limits])}


def memory_headroom(cgroup_root=Path('/sys/fs/cgroup'), membership=Path('/proc/self/cgroup')):
    unified = [line.split(':', 2)[2] for line in membership.read_text().splitlines() if line.startswith('0::')]
    if len(unified) != 1:
        raise RuntimeError('Verified cgroup v2 memory limit required')
    current = cgroup_root / unified[0].lstrip('/')
    limits = []
    while True:
        maximum = (current/'memory.max').read_text().strip()
        usage = int((current/'memory.current').read_text())
        limits.append({'path':str(current), 'max_bytes':None if maximum=='max' else int(maximum), 'current_bytes':usage})
        if current == cgroup_root:
            break
        current = current.parent
    finite = [r['max_bytes']-r['current_bytes'] for r in limits if r['max_bytes'] is not None]
    if not finite:
        raise RuntimeError('Finite cgroup memory limit required for this resource policy')
    return {'limits':limits, 'available_bytes':min(finite), 'required_policy_bytes':1024**3,
            'basis':'Operational allocation floor of 1 GiB per chain; not measured peak RSS or a guarantee of sufficient memory.'}


def require_memory():
    record = memory_headroom()
    if record['available_bytes'] < record['required_policy_bytes']:
        raise RuntimeError('Less than 1 GiB cgroup memory headroom; refuse initial/serial chain allocation')
    return record


def require_idle(exclude=()):
    busy = blocked_processes(exclude)
    if busy:
        raise RuntimeError('Conflicting OpenMx/JAGS processes: ' + json.dumps(busy))
    if cpu_capacity()['effective_capacity'] < 4:
        raise RuntimeError('Four CPU slots required after affinity and cgroup quota limits')


def validate():
    p = json.loads(PROTOCOL.read_text())
    if (p['chain_ids'], p['per_chain_wall_seconds'], p['planned_worker_seconds']) != ([1, 2, 3, 4], 1800, 7200):
        raise RuntimeError('Unexpected fixed allocation')
    if (p['preparation_wall_seconds'], p['diagnostic_wall_seconds'], p['termination_grace_seconds']) != (120, 300, 5):
        raise RuntimeError('Unexpected preparation/diagnostic/cleanup allocation')
    expected = {
        'pinned_files': {'simulation/jags_convergence_gate.R', 'simulation/diagnose_jags_gate.R',
            'simulation/jags_replication.R', 'provenance/bayesian-convergence-plan.json',
            'provenance/posterior-runtime-packages.json', 'provenance/runtime-packages.json'},
        'pinned_runtime': {'/workspace/slot3-runtime/bin/Rscript',
            '/workspace/slot3-runtime/usr/lib/R/bin/exec/R', '/workspace/slot3-runtime/usr/lib/R/lib/libR.so'}}
    for field in ('pinned_files', 'pinned_runtime'):
        if set(p[field]) != expected[field]:
            raise RuntimeError('Incomplete or unexpected pinned identity set: ' + field)
        for name, digest in p[field].items():
            if sha(ROOT / name) != digest:
                raise RuntimeError('Pinned identity mismatch: ' + name)
    return p


def terminate_group(process, grace):
    """Kill descendants even if leader has already exited; never rely on poll alone."""
    try:
        os.killpg(process.pid, signal.SIGTERM)
    except ProcessLookupError:
        process.wait()
        return
    deadline = time.monotonic() + grace
    while time.monotonic() < deadline:
        process.poll()
        try:
            os.killpg(process.pid, 0)
        except ProcessLookupError:
            break
        time.sleep(.05)
    try:
        os.killpg(process.pid, signal.SIGKILL)
    except ProcessLookupError:
        pass
    process.wait()


def process_tree_rss(pid):
    processes = {}
    for entry in Path('/proc').iterdir():
        if not entry.name.isdigit():
            continue
        try:
            stat = (entry/'stat').read_text().split(') ', 1)[1].split()
            processes[int(entry.name)] = (int(stat[1]), int((entry/'statm').read_text().split()[1])*os.sysconf('SC_PAGE_SIZE'))
        except (FileNotFoundError, ProcessLookupError):
            continue
    children = {pid}
    while True:
        expanded = children | {p for p, (parent, rss) in processes.items() if parent in children}
        if expanded == children:
            break
        children = expanded
    return {'rss_bytes':sum(processes[p][1] for p in children if p in processes), 'pids':sorted(children)}


def run_batch(commands, directory, seconds, grace, guard=None, pilot_ready=None,
              memory_probe=memory_headroom, rss_probe=process_tree_rss):
    """Generic process mechanics, tested with harmless commands; no model knowledge."""
    directory.mkdir()
    records = [{'id': i + 1, 'command': cmd, 'state': 'not_launched', 'returncode': None}
               for i, cmd in enumerate(commands)]
    active = {}
    error = None
    batch_started = time.monotonic()
    pending = list(records)
    scheduling = {'mode':'pilot' if pilot_ready else 'parallel', 'pilot_peak_rss_bytes':0,
                  'max_concurrency':0, 'batch_wall_bound_seconds':len(commands)*(seconds+grace),
                  'reason':'Prescribed chain1 RSS through adaptation before any additional chain' if pilot_ready else 'Concurrent fixed commands'}
    last_sample = 0.0
    old_handlers = {}
    def interrupted(signum, frame):
        raise InterruptedError('Dispatcher received signal ' + str(signum))
    def save():
        write(directory / 'outcomes.json', {'requested': len(commands), 'outcomes': records,
                                           'error': error, 'scheduling':scheduling, 'updated_utc': utc()})
    try:
        for sig in (signal.SIGTERM, signal.SIGINT, signal.SIGHUP):
            old_handlers[sig] = signal.signal(sig, interrupted)
        save()
        def launch(record):
            if pilot_ready and time.monotonic()-batch_started >= scheduling['batch_wall_bound_seconds']-grace:
                raise TimeoutError('Fixed batch wall bound reached before launch')
            if guard:
                guard([p.pid for p, _, _ in active.values()])
            log = open(directory / ('process-%s.log' % record['id']), 'xb')
            launch_started = time.monotonic()
            try:
                process = subprocess.Popen(record['command'], cwd=ROOT,
                    env=dict(os.environ, **ENV), stdout=log, stderr=subprocess.STDOUT,
                    start_new_session=True)
            except BaseException:
                log.close()
                raise
            active[record['id']] = (process, log, launch_started)
            record.update(state='running', pid=process.pid, started_utc=utc())
            scheduling['max_concurrency'] = max(scheduling['max_concurrency'], len(active))
            save()
        if pilot_ready:
            launch(pending.pop(0))
        else:
            while pending:
                launch(pending.pop(0))
        while active or pending:
            if pilot_ready and time.monotonic()-batch_started >= scheduling['batch_wall_bound_seconds']-grace:
                raise TimeoutError('Fixed batch wall bound reached; pending chains remain not_launched')
            if guard:
                guard([p.pid for p, _, _ in active.values()])
            if pilot_ready and scheduling['mode']=='pilot':
                if 1 in active and time.monotonic()-last_sample >= .2:
                    sampled = rss_probe(active[1][0].pid)
                    last_sample = time.monotonic()
                    scheduling['pilot_peak_rss_bytes'] = max(scheduling['pilot_peak_rss_bytes'], sampled['rss_bytes'])
                    with open(directory/'pilot-rss.jsonl', 'a') as stream:
                        stream.write(json.dumps(dict(sampled, phase='initialization_or_adaptation', utc=utc(), elapsed_seconds=last_sample-batch_started))+'\n')
                ready = pilot_ready.exists()
                if ready or 1 not in active:
                    ready_sample = rss_probe(active[1][0].pid) if ready and 1 in active else {'rss_bytes':0, 'pids':[]}
                    scheduling['readiness_rss_bytes'] = ready_sample['rss_bytes']
                    scheduling['pilot_peak_rss_bytes'] = max(scheduling['pilot_peak_rss_bytes'], ready_sample['rss_bytes'])
                    with open(directory/'pilot-rss.jsonl', 'a') as stream:
                        stream.write(json.dumps(dict(ready_sample, phase='readiness_observation', utc=utc(), elapsed_seconds=time.monotonic()-batch_started))+'\n')
                    memory = memory_probe()
                    per_chain = max(2*scheduling['pilot_peak_rss_bytes'], 1024**3)
                    concurrent = ready and ready_sample['rss_bytes']>0 and memory['available_bytes']>=len(pending)*per_chain
                    scheduling.update(mode='parallel' if concurrent else 'serial',
                        adaptation_record_observed=ready, release_memory=memory,
                        per_additional_chain_policy_bytes=per_chain,
                        reason='Measured adaptation-stage RSS with 2x safety factor and 1 GiB floor supports remaining chains' if concurrent else 'Insufficient measured parallel headroom or adaptation record absent; serialize remaining prescribed chains')
                    save()
            if pending and scheduling['mode']=='parallel':
                while pending:
                    launch(pending.pop(0))
            elif pending and scheduling['mode']=='serial' and not active:
                memory = memory_probe()
                if memory['available_bytes'] < scheduling['per_additional_chain_policy_bytes']:
                    raise RuntimeError('Insufficient serial memory headroom; pending outcomes retained')
                launch(pending.pop(0))
            for ident, (process, log, started) in list(active.items()):
                record = records[ident - 1]
                elapsed = time.monotonic() - started
                rc = process.poll()
                if rc is None and elapsed < seconds:
                    continue
                timed_out = record.get('timeout_sent', False) or rc is None
                if timed_out and not record.get('timeout_sent'):
                    try:
                        os.killpg(process.pid, signal.SIGTERM)
                    except ProcessLookupError:
                        pass
                    record.update(timeout_sent=True, kill_deadline=time.monotonic()+grace)
                    save()
                    continue
                if timed_out and time.monotonic() < record['kill_deadline']:
                    continue
                terminate_group(process, 0)
                log.close()
                record.update(state='timed_out' if timed_out else 'exited',
                    returncode=process.returncode, elapsed_seconds=time.monotonic()-started,
                    ended_utc=utc(), log_sha256=sha(directory / ('process-%s.log' % ident)))
                del active[ident]
                save()
            time.sleep(.05)
    except BaseException as exc:
        error = type(exc).__name__ + ': ' + str(exc)
    finally:
        # Ignore repeated interrupts during bounded cleanup so logs/accounting survive.
        for sig in old_handlers:
            signal.signal(sig, signal.SIG_IGN)
        for process, _, _ in active.values():
            try:
                os.killpg(process.pid, signal.SIGTERM)
            except ProcessLookupError:
                pass
        if active:
            time.sleep(grace)
        for ident, (process, log, started) in active.items():
            terminate_group(process, 0)
            log.close()
            records[ident-1].update(state='cancelled', returncode=process.returncode,
                elapsed_seconds=time.monotonic()-started, ended_utc=utc(),
                log_sha256=sha(directory / ('process-%s.log' % ident)))
        save()
        for sig, handler in old_handlers.items():
            signal.signal(sig, handler)
    return not error and all(r['state']=='exited' and r['returncode']==0 for r in records)


def runtime_inventory():
    # Snapshot all runtime and gate-library bytes, including symlink targets resolved by open.
    paths = [Path('/workspace/slot3-runtime'), Path('/workspace/slot3-posterior-library')]
    return {str(p): sha(p) for base in paths for p in sorted(base.rglob('*')) if p.is_file()}


def verify_phase(record):
    if sha(PROTOCOL) != record['dispatcher_protocol_sha256'] or sha(__file__) != record['dispatcher_sha256']:
        raise RuntimeError('Dispatcher/protocol changed since execution')
    validate()
    if runtime_inventory() != record['runtime_files']:
        raise RuntimeError('Installed runtime/library file identities changed since dispatch')


def validate_outcomes(outcome, record):
    rows = outcome['outcomes']
    if outcome['requested'] != 4 or len(rows) != 4 or sorted(r['id'] for r in rows) != [1,2,3,4]:
        raise RuntimeError('Four unique chain outcomes required')
    for row in rows:
        if row['state'] not in {'exited', 'timed_out', 'cancelled', 'not_launched'}:
            raise RuntimeError('Nonterminal or unknown chain state')
        if row['command'] != record['chain_commands'][row['id']-1]:
            raise RuntimeError('Chain command identity mismatch')


def namespace_path(value):
    raw = Path(value)
    if not raw.is_absolute():
        raw = ROOT / raw
    resolved = raw.resolve()
    if not resolved.is_relative_to(ROOT / 'production') or resolved == ROOT / 'production':
        raise RuntimeError('Namespace must be a study production subdirectory')
    if any(p.is_symlink() for p in [raw, *raw.parents]):
        raise RuntimeError('Symlink namespace refused')
    return resolved


def main():
    global OWNED_NS
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['check', 'dispatch', 'diagnose'])
    parser.add_argument('--namespace', default='production/jags-gate-v1')
    args = parser.parse_args()
    os.chdir(ROOT)
    protocol = validate()
    ns = namespace_path(args.namespace)
    require_idle()
    if args.action == 'check':
        if ns.exists() and any(ns.iterdir()):
            raise RuntimeError('Namespace is not empty')
        require_memory()
        print('Pinned inputs match; process scan idle; no namespace created or R started.')
        return
    # Single dispatcher lock across namespaces; does not modify the OpenMx lock/runtime.
    with open(ROOT / 'production/.jags-dispatch.lock', 'a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        require_idle()
        if args.action == 'diagnose':
            record = json.loads((ns / 'dispatch.json').read_text())
            verify_phase(record)
            outcome = json.loads((ns / 'chains/outcomes.json').read_text())
            validate_outcomes(outcome, record)
            ok = run_batch([[RSCRIPT, DIAGNOSTIC, str(ns/'prepared')]], ns/'diagnostic-dispatch',
                           protocol['diagnostic_wall_seconds'], protocol['termination_grace_seconds'], require_idle)
            sys.exit(0 if ok else 1)
        if ns.exists() and any(ns.iterdir()):
            raise RuntimeError('Refusing existing nonempty namespace; no resume or retries')
        ns.mkdir(parents=True, exist_ok=True)
        OWNED_NS = ns
        memory = require_memory()
        commands = [[RSCRIPT, WRAPPER, 'run', str(ns/'prepared'), str(i)] for i in range(1,5)]
        record = {'created_utc': utc(), 'dispatcher_sha256': sha(__file__),
            'dispatcher_protocol_sha256': sha(PROTOCOL), 'protocol': protocol,
            'environment_overrides': ENV, 'cpu_capacity': cpu_capacity(), 'initial_memory':memory, 'runtime_files': runtime_inventory(),
            'prepare_command': [RSCRIPT, WRAPPER, 'prepare', str(ns/'prepared')],
            'chain_commands': commands, 'diagnostic_command': [sys.executable, str(Path(__file__).resolve()), 'diagnose', '--namespace', str(ns)],
            'requested_chains': 4, 'meaning': 'Execution accounting only; no convergence classification.'}
        write(ns/'dispatch.json', record)
        # Preserve four denominators even if preparation fails before chain dispatch.
        write(ns/'requested-chains.json', {'requested':4, 'commands':commands, 'initial_state':'not_launched'})
        verify_phase(record)
        ok = run_batch([record['prepare_command']], ns/'preparation-dispatch',
            protocol['preparation_wall_seconds'], protocol['termination_grace_seconds'], require_idle)
        if not ok:
            (ns/'chains').mkdir()
            write(ns/'chains/outcomes.json', {'requested':4,'outcomes':[{'id':i+1,'command':c,'state':'not_launched','returncode':None} for i,c in enumerate(commands)],'error':'Preparation failed'})
            sys.exit(1)
        for file, key in [('data.rds','expected_data_sha256'),('model.jags','expected_model_sha256')]:
            if sha(ns/'prepared'/file) != protocol[key]:
                raise RuntimeError('Prepared identity mismatch: '+file)
        record['prepared_files'] = {p.name:sha(p) for p in (ns/'prepared').iterdir() if p.is_file()}
        write(ns/'dispatch.json', record)
        verify_phase(record)
        record['before_chains_memory'] = require_memory()
        write(ns/'dispatch.json', record)
        ok = run_batch(commands, ns/'chains', protocol['per_chain_wall_seconds'],
                       protocol['termination_grace_seconds'], require_idle,
                       pilot_ready=ns/'prepared/chain-1/adaptation.rds')
        print('Four requested outcomes retained. Run diagnostics separately; no convergence claim.')
        sys.exit(0 if ok else 1)


if __name__ == '__main__':
    try:
        main()
    except BaseException as error:
        # If preparation or validation aborts, retain an explicit four-outcome ledger.
        # Never overwrite an existing execution ledger or touch a check-only namespace.
        if OWNED_NS is not None:
            try:
                ns = OWNED_NS
                request = ns/'requested-chains.json'
                if request.exists() and not (ns/'chains').exists():
                    commands = json.loads(request.read_text())['commands']
                    (ns/'chains').mkdir()
                    write(ns/'chains/outcomes.json', {'requested':4,'outcomes':[{'id':i+1,'command':c,'state':'not_launched','returncode':None} for i,c in enumerate(commands)],'error':str(error)})
            except Exception:
                pass
        raise
