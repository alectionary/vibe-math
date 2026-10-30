"""Harmless process fixtures only: no R, model preparation or chains."""
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import time
spec=importlib.util.spec_from_file_location('dispatcher',Path(__file__).with_name('dispatch_jags_gate.py'))
d=importlib.util.module_from_spec(spec);spec.loader.exec_module(d)
checks=[]
def check(name,value):
    assert value,name
    checks.append({'test':name,'passed':True})
with tempfile.TemporaryDirectory(prefix='schwabe-dispatch-fixture-') as tmp:
    tmp=Path(tmp)
    commands=[[sys.executable,'-c','print("harmless fixture")'] for _ in range(4)]
    check('four_successful_processes',d.run_batch(commands,tmp/'success',2,.1))
    r=json.loads((tmp/'success/outcomes.json').read_text())
    check('four_denominators',r['requested']==4 and len(r['outcomes'])==4)
    childfile=tmp/'child.pid'
    code='import os,signal,time;signal.signal(signal.SIGTERM,signal.SIG_IGN);p=os.fork();open('+repr(str(childfile))+',"w").write(str(p)) if p else None;time.sleep(60)'
    check('timeout_failure',not d.run_batch([[sys.executable,'-c',code]],tmp/'timeout',.25,.1))
    child=int(childfile.read_text())
    time.sleep(.1)
    status=Path('/proc')/str(child)/'stat'
    check('grandchild_no_longer_running',not status.exists() or status.read_text().split()[2]=='Z')
    r=json.loads((tmp/'timeout/outcomes.json').read_text())
    check('timeout_recorded',r['outcomes'][0]['state']=='timed_out' and r['outcomes'][0]['returncode']==-9)
    check('launch_failure_preserves_four',not d.run_batch([['/nonexistent-fixture-program'],*commands[:3]],tmp/'launch-failed',1,.1))
    r=json.loads((tmp/'launch-failed/outcomes.json').read_text())
    check('failed_launch_denominators',r['requested']==4 and all(x['state']=='not_launched' for x in r['outcomes']))
    cancel_dir=tmp/'cancelled'
    helper=tmp/'helper.py'
    helper.write_text('import sys;sys.path.insert(0,'+repr(str(Path(__file__).resolve().parent))+');import dispatch_jags_gate as d;from pathlib import Path;d.run_batch([[sys.executable,"-c","import time;time.sleep(60)"]]*4,Path('+repr(str(cancel_dir))+'),30,.1)')
    supervisor=subprocess.Popen([sys.executable,str(helper)])
    deadline=time.monotonic()+5
    while time.monotonic()<deadline:
        ledger=cancel_dir/'outcomes.json'
        if ledger.exists() and all(x['state']=='running' for x in json.loads(ledger.read_text())['outcomes']):break
        time.sleep(.02)
    supervisor.terminate();supervisor.wait(timeout=3)
    r=json.loads(ledger.read_text())
    check('interrupt_preserves_four_cancelled',len(r['outcomes'])==4 and all(x['state']=='cancelled' for x in r['outcomes']))
    leaderfile=tmp/'orphan.pid'
    code='import os,time; p=os.fork(); open('+repr(str(leaderfile))+',"w").write(str(p)) if p else None; time.sleep(60) if p==0 else time.sleep(.15)'
    check('exited_leader_cleaned',d.run_batch([[sys.executable,'-c',code]],tmp/'leader-exit',2,.1))
    child=int(leaderfile.read_text());status=Path('/proc')/str(child)/'stat'
    check('exited_leader_descendant_stopped',not status.exists() or status.read_text().split()[2]=='Z')
    check('midlaunch_failure',not d.run_batch([[sys.executable,'-c','import time;time.sleep(60)'],['/nonexistent-fixture-program'],*commands[:2]],tmp/'midlaunch',2,.1))
    r=json.loads((tmp/'midlaunch/outcomes.json').read_text())
    check('midlaunch_four_denominators',r['requested']==4 and [x['state'] for x in r['outcomes']]==['cancelled','not_launched','not_launched','not_launched'])
    cg=tmp/'cgroup';(cg/'child').mkdir(parents=True)
    (cg/'cpu.max').write_text('300000 100000')
    (cg/'child/cpu.max').write_text('400000 100000')
    membership=tmp/'membership';membership.write_text('0::/child\n')
    check('ancestor_cgroup_quota',d.cpu_capacity(cg,membership)['effective_capacity']==min(3,len(os.sched_getaffinity(0))))
    original_inventory=d.runtime_inventory;original_validate=d.validate
    record={'dispatcher_protocol_sha256':d.sha(d.PROTOCOL),'dispatcher_sha256':d.sha(d.__file__),'runtime_files':{'fixture':'original'}}
    d.runtime_inventory=lambda:{'fixture':'changed'}
    d.validate=lambda:None
    try:d.verify_phase(record)
    except RuntimeError:checks.append({'test':'runtime_mutation_refused','passed':True})
    else:raise AssertionError('Runtime mutation accepted')
    finally:d.runtime_inventory=original_inventory;d.validate=original_validate
    original_protocol=d.PROTOCOL
    fixture_protocol=tmp/'protocol.json'
    baseline=json.loads(original_protocol.read_text())
    for name, mutate in [('empty_identity',lambda p:p.update(pinned_files={})),('changed_grace',lambda p:p.update(termination_grace_seconds=6))]:
        protocol=json.loads(json.dumps(baseline));mutate(protocol);fixture_protocol.write_text(json.dumps(protocol));d.PROTOCOL=fixture_protocol
        try:d.validate()
        except RuntimeError:checks.append({'test':name+'_refused','passed':True})
        else:raise AssertionError(name+' accepted')
        finally:d.PROTOCOL=original_protocol
    valid_record={'chain_commands':commands}
    valid_outcome={'requested':4,'outcomes':[{'id':i+1,'state':'not_launched','command':c} for i,c in enumerate(commands)]}
    for name, mutate in [('duplicate_ids',lambda o:o['outcomes'][0].update(id=2)),('unknown_state',lambda o:o['outcomes'][0].update(state='pending')),('changed_command',lambda o:o['outcomes'][0].update(command=['wrong']))]:
        outcome=json.loads(json.dumps(valid_outcome));mutate(outcome)
        try:d.validate_outcomes(outcome,valid_record)
        except RuntimeError:checks.append({'test':name+'_refused','passed':True})
        else:raise AssertionError(name+' accepted')
    (cg/'memory.max').write_text(str(16*1024**3));(cg/'memory.current').write_text(str(3*1024**3))
    (cg/'child/memory.max').write_text(str(8*1024**3));(cg/'child/memory.current').write_text(str(5*1024**3))
    check('minimum_ancestor_memory_headroom',d.memory_headroom(cg,membership)['available_bytes']==3*1024**3)
    original_memory=d.memory_headroom
    d.memory_headroom=lambda:{'available_bytes':3*1024**3,'required_policy_bytes':4*1024**3}
    try:d.require_memory()
    except RuntimeError:checks.append({'test':'low_headroom_refused','passed':True})
    else:raise AssertionError('Low headroom accepted')
    finally:d.memory_headroom=original_memory
    memory=lambda:{'available_bytes':16*1024**3,'required_policy_bytes':1024**3}
    rss=lambda pid:{'rss_bytes':32*1024**2,'pids':[pid]}
    for name, probe, first_code, expected_concurrency in [
        ('stagger_parallel',rss,'import pathlib,time;pathlib.Path(READY).touch();time.sleep(.3)',4),
        ('zero_rss_serial',lambda pid:{'rss_bytes':0,'pids':[pid]},'import pathlib,time;pathlib.Path(READY).touch();time.sleep(.3)',1),
        ('early_failure_serial',rss,'import sys;sys.exit(1)',1)]:
        ready=tmp/(name+'.ready')
        first_code=first_code.replace('READY',repr(str(ready)))
        staggered=[[sys.executable,'-c',first_code]]+[[sys.executable,'-c','import time;time.sleep(.1)'] for _ in range(3)]
        d.run_batch(staggered,tmp/name,2,.1,pilot_ready=ready,memory_probe=memory,rss_probe=probe)
        outcome=json.loads((tmp/name/'outcomes.json').read_text())
        check(name+'_concurrency',outcome['scheduling']['max_concurrency']==expected_concurrency)
        check(name+'_all_four_attempted',len(outcome['outcomes'])==4 and all(x['state']=='exited' for x in outcome['outcomes']))
    calls=[0]
    def fail_guard(exclude):
        calls[0]+=1
        if calls[0]>1:raise RuntimeError('synthetic resource guard failure')
    check('resource_guard_failure',not d.run_batch([[sys.executable,'-c','import time;time.sleep(60)']]*4,tmp/'resource-failed',2,.1,guard=fail_guard,pilot_ready=tmp/'never-ready',memory_probe=memory,rss_probe=rss))
    outcome=json.loads((tmp/'resource-failed/outcomes.json').read_text())
    check('resource_guard_four_outcomes',[x['state'] for x in outcome['outcomes']]==['cancelled','not_launched','not_launched','not_launched'])
    ready=tmp/'rss-growth.ready'
    probes=[0]
    def growth_rss(pid):
        probes[0]+=1
        return {'rss_bytes':32*1024**2 if probes[0]==1 else 2*1024**3,'pids':[pid]}
    # Marker preexists in this harmless fixture to force initial and readiness probes in one turn.
    ready.touch()
    staged=[[sys.executable,'-c','import time;time.sleep(.1)']]*4
    d.run_batch(staged,tmp/'rss-growth',2,.1,pilot_ready=ready,
                memory_probe=lambda:{'available_bytes':3*1024**3},rss_probe=growth_rss)
    outcome=json.loads((tmp/'rss-growth/outcomes.json').read_text())
    check('readiness_final_rss_recorded',outcome['scheduling']['readiness_rss_bytes']==2*1024**3)
    check('readiness_growth_blocks_parallel',outcome['scheduling']['mode']=='serial' and outcome['scheduling']['max_concurrency']==1)
    fake=tmp/'production_supervisor.py';fake.write_text('import time;time.sleep(60)\n')
    process=subprocess.Popen([sys.executable,str(fake)])
    try:
        time.sleep(.1)
        check('busy_process_detected',any(x['pid']==process.pid for x in d.blocked_processes()))
        try:d.require_idle()
        except RuntimeError:checks.append({'test':'busy_refused','passed':True})
        else:raise AssertionError('Busy not refused')
    finally:process.terminate();process.wait()
    check('namespace_escape_refused',not (tmp/'untouched').exists())
    try:d.namespace_path(str(tmp/'untouched'))
    except RuntimeError:checks.append({'test':'namespace_restriction','passed':True})
    else:raise AssertionError('Namespace escape allowed')
print(json.dumps({'checks':checks,'actual_R_or_JAGS_processes_started':0},indent=2))
