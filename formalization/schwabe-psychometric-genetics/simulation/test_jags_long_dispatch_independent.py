"""Independent dispatcher checks. No R or model process is started."""
import copy,importlib.util,json,os,pathlib,subprocess,sys,tempfile,time
root=pathlib.Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('checked_dispatcher',root/'simulation/dispatch_jags_long_gate.py')
d=importlib.util.module_from_spec(spec);spec.loader.exec_module(d)
checks=[]
def require(name,condition):
 assert condition,name
 checks.append({'test':name,'passed':True})
def rejects(name,fn):
 try:fn()
 except (RuntimeError,ValueError,KeyError):checks.append({'test':name,'passed':True})
 else:raise AssertionError(name)
with tempfile.TemporaryDirectory(prefix='schwabe-independent-dispatch-')as td:
 temp=pathlib.Path(td)
 original=d.PROTOCOL;base=json.loads(original.read_text());fake=temp/'protocol.json'
 for field,value in [('chain_ids',[1,2,3]),('per_chain_wall_seconds',3001),('planned_worker_seconds',12001),('preparation_wall_seconds',121),('diagnostic_wall_seconds',301),('termination_grace_seconds',6),('pinned_runtime',{})]:
  obj=copy.deepcopy(base);obj[field]=value;fake.write_text(json.dumps(obj));d.PROTOCOL=fake
  rejects('refuse_protocol_'+field,d.validate)
  d.PROTOCOL=original
 obj=copy.deepcopy(base);obj['pinned_files']['simulation/jags_long_gate.R']='0'*64;fake.write_text(json.dumps(obj));d.PROTOCOL=fake
 rejects('refuse_changed_pinned_wrapper',d.validate);d.PROTOCOL=original
 require('actual_fixed_protocol_valid',d.validate()['chain_ids']==[1,2,3,4])
 original_root=d.ROOT;d.ROOT=temp/'mock-study';(d.ROOT/'production').mkdir(parents=True)
 (d.ROOT/'production/link').symlink_to(temp,target_is_directory=True)
 rejects('refuse_symlink_namespace',lambda:d.namespace_path('production/link/study'))
 rejects('refuse_parent_production_namespace',lambda:d.namespace_path('production'))
 rejects('refuse_outside_namespace',lambda:d.namespace_path(str(temp/'outside')))
 require('normal_namespace_resolution_no_creation',d.namespace_path('production/fresh')==d.ROOT/'production/fresh' and not (d.ROOT/'production/fresh').exists());d.ROOT=original_root
 cg=temp/'cg';(cg/'child').mkdir(parents=True);membership=temp/'membership';membership.write_text('0::/child\n')
 (cg/'cpu.max').write_text('200000 100000');(cg/'child/cpu.max').write_text('400000 100000')
 require('ancestor_cpu_quota_not_host_affinity',d.cpu_capacity(cg,membership)['effective_capacity']<=2)
 (cg/'memory.max').write_text(str(8*1024**3));(cg/'memory.current').write_text(str(6*1024**3));(cg/'child/memory.max').write_text(str(16*1024**3));(cg/'child/memory.current').write_text(str(2*1024**3))
 require('ancestor_memory_headroom_not_host_memory',d.memory_headroom(cg,membership)['available_bytes']==2*1024**3)
 envcode='import json,os;print(json.dumps({k:os.environ.get(k) for k in '+repr(list(d.ENV))+'}))'
 require('harmless_env_process',d.run_batch([[sys.executable,'-c',envcode]],temp/'env',3,.1))
 actual=json.loads((temp/'env/process-1.log').read_text());require('single_thread_overrides_inherited',actual==d.ENV)
 # Existing files must not be overwritten even by generic process mechanics.
 before=(temp/'env/outcomes.json').read_bytes()
 try:d.run_batch([[sys.executable,'-c','print(1)']],temp/'env',3,.1)
 except FileExistsError:checks.append({'test':'existing_namespace_refused','passed':True})
 else:raise AssertionError('existing directory was replaced')
 require('existing_ledger_unchanged',(temp/'env/outcomes.json').read_bytes()==before)
 # Small wall-budget fixture exercises queued cancellation without any model.
 start=time.monotonic()
 result=d.run_batch([[sys.executable,'-c','import time;time.sleep(2)']]*4,temp/'bounded-serial',.12,.02,
  pilot_ready=temp/'no-readiness',memory_probe=lambda:{'available_bytes':16*1024**3},
  rss_probe=lambda pid:{'rss_bytes':1024**2,'pids':[pid]})
 elapsed=time.monotonic()-start;outcome=json.loads((temp/'bounded-serial/outcomes.json').read_text())
 require('small_fixed_wall_bound_no_extension',not result and elapsed<1.0 and outcome['scheduling']['batch_wall_bound_seconds']==4*(.12+.02))
 require('bounded_abort_four_denominators',outcome['requested']==4 and len(outcome['outcomes'])==4 and all(x['state']!='running'for x in outcome['outcomes']))
 require('no_unmeasured_parallel_release',outcome['scheduling']['max_concurrency']==1)
 print(json.dumps({'checks':checks,'new_R_JAGS_OpenMx_processes':0,'fixtures_only':True},indent=2))
