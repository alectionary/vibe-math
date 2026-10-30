#!/usr/bin/env python3
"""UNRUN post-b6 supplemental exact checkpoint replay; requires an explicit frozen checkpoint.

This performs no search, optimization, Git checkout, commit, or remote write.
The caller creates a new copy/output location and explicitly chooses the
committed checkpoint. All scientific input bytes must match both an accepted
inventory and that checkpoint's Git blob. Frozen consumers run sequentially.
"""
from pathlib import Path
import argparse,ast,gzip,hashlib,json,os,shutil,signal,subprocess,sys,time
from fractions import Fraction as Q

ROOT=Path(__file__).resolve().parent
THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS',
         'VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
INVENTORIES=['two-basis-results/singleton-o15-phase-one-complete-inventory.json', 'two-basis-results/singleton-phase-one-matched-complete-inventory.json', 'two-basis-results/singleton-geometry-point22-o32-complete-inventory.json', 'two-basis-results/owner-k22-eight-probe-complete-inventory.json', 'two-basis-results/joint-owner-k22-eight-point22-complete-inventory-v2.json', 'two-basis-results/shared-basis-phase-one-point22-seed-complete-inventory.json']
PLAN='two-basis-results/final-supplement-checkpoint-replay-plan.json'
IMPORT_CLOSURE='two-basis-results/final-supplement-checkpoint-import-closure.json'
POINT='coupling-results/two-basis-integer-witness22-rational.json.gz'
def guard():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    assert all(os.environ.get(k)=='1' for k in THREADS)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);b=p.read_bytes();return json.loads(gzip.decompress(b) if p.suffix=='.gz' else b)
def git(repo,*args):return subprocess.check_output(['git',*args],cwd=repo).decode().strip()

def stages():
    plan=read(ROOT/PLAN);assert plan['status']=='UNRUN_POST_B6_SUPPLEMENTAL_REPLAY_PLAN'
    assert plan['inventory_files']==INVENTORIES
    assert plan['static_import_closure']==IMPORT_CLOSURE
    return plan['stages']

def closure():
    files={};external={}
    def add(name,h):
        p=Path(name)
        if p.is_absolute():
            if not p.is_relative_to(ROOT):
                assert external.get(name)==h,('undeclared external research binding',name)
                assert sha(p)==h;return
            p=p.relative_to(ROOT)
        assert '..' not in p.parts;name=p.as_posix()
        assert name not in files or files[name]==h,('inconsistent accepted inventories',name)
        files[name]=h
    for name in INVENTORIES:
        d=read(ROOT/name);add(name,sha(ROOT/name))
        for p,h in d.get('external_runtime_bindings',{}).items():
            assert p not in external or external[p]==h
            external[p]=h
        for key in ('files','additional_files'):
            rows=d.get(key,{})
            if isinstance(rows,dict):rows=[dict(v,path=k) for k,v in rows.items()]
            for row in rows:add(row['path'],row['sha256'])
        for key in ('input_bindings','repository_input_bindings'):
            for p,h in d.get(key,{}).items():add(p,h)
    todo=[r['consumer'] for r in stages()];seen=set()
    while todo:
        name=todo.pop()
        if name in seen:continue
        seen.add(name);add(name,sha(ROOT/name))
        for node in ast.walk(ast.parse((ROOT/name).read_text())):
            mods=[a.name for a in node.names] if isinstance(node,ast.Import) else [node.module] if isinstance(node,ast.ImportFrom) and node.module else []
            for mod in mods:
                local=mod.replace('.','/')+'.py'
                if (ROOT/local).is_file():todo.append(local)
    ic=read(ROOT/IMPORT_CLOSURE)
    assert ic['status']=='PASS_NO_IMPORT_SUPPLEMENTAL_CLOSURE_PREFLIGHT' and ic['plan_sha256']==sha(ROOT/PLAN)
    assert ic['inventory_hashes']=={n:sha(ROOT/n) for n in INVENTORIES}
    assert set(ic['static_local_modules'])==seen
    assert ic['producer_sha256']==sha(ROOT/'prepare_final_supplement_import_closure.py')
    for name,h in ic['input_bindings'].items():add(name,h)
    for name in [Path(__file__).name,'final_owner_replay_worker_v2.py',PLAN,IMPORT_CLOSURE,'prepare_final_supplement_import_closure.py']:add(name,sha(ROOT/name))
    return files

def main():
    guard();start=time.monotonic();ap=argparse.ArgumentParser()
    ap.add_argument('--checkpoint',required=True);ap.add_argument('--copy-root',type=Path,required=True);ap.add_argument('--output-dir',type=Path,required=True)
    ap.add_argument('--total-seconds',type=int,default=900);a=ap.parse_args()
    assert 0<a.total_seconds<=900
    repo=Path(git(ROOT,'rev-parse','--show-toplevel'));commit=git(repo,'rev-parse',a.checkpoint+'^{commit}')
    assert git(repo,'rev-parse','HEAD')==commit,'checkpoint must be the explicitly frozen current HEAD'
    assert not git(repo,'status','--porcelain','--untracked-files=no'),'tracked worktree differs from checkpoint'
    copied=a.copy_root.resolve();output=a.output_dir.resolve()
    assert not copied.exists() and not output.exists() and not copied.is_relative_to(ROOT) and not output.is_relative_to(ROOT)
    assert not output.is_relative_to(copied) and not copied.is_relative_to(output)
    names=closure();assert len(names)<=3500
    relative=ROOT.relative_to(repo).as_posix();tree={}
    raw=subprocess.check_output(['git','ls-tree','-r','-z',commit],cwd=repo)
    for entry in raw.split(b'\0'):
        if not entry:continue
        info,path=entry.split(b'\t',1);mode,kind,oid=info.decode().split()
        tree[path.decode()]=(mode,kind,oid)
    records=[]
    for name,h in sorted(names.items()):
        source=ROOT/name;b=source.read_bytes();assert hashlib.sha256(b).hexdigest()==h,('inventory bytes changed',name)
        key=relative+'/'+name;assert key in tree,('declared file not committed',key)
        mode,kind,oid=tree[key];assert kind=='blob' and mode!='120000','copied scientific symlink is not allowed'
        algo=hashlib.sha1 if len(oid)==40 else hashlib.sha256
        assert algo(b'blob '+str(len(b)).encode()+b'\0'+b).hexdigest()==oid,('checkpoint blob mismatch',name)
        records.append(dict(path=name,sha256=h,bytes=len(b),git_blob=oid,git_mode=mode))
    assert sum(r['bytes'] for r in records)<4_000_000_000
    copied.mkdir(parents=True);output.mkdir(parents=True)
    for row in records:
        p=copied/row['path'];p.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(ROOT/row['path'],p);assert sha(p)==row['sha256']
    jobs=stages();manifest=dict(status='FROZEN_FINAL_OWNER_CHECKPOINT_CLEAN_COPY',checkpoint=commit,recorded_root=str(ROOT),copy_root=str(copied),output_dir=str(output),files=records,stages=jobs,
        inventory_hashes={p:sha(ROOT/p) for p in INVENTORIES},worker_sha256=sha(copied/'final_owner_replay_worker_v2.py'),producer_sha256=sha(__file__),priority=19,threads=1,
        scope='Post-b6 phase-I, geometry32, union/global8, complete coupled8 endpoint proofs, and preparation-only shared-basis seed; no solver or new mathematical search.')
    (output/'closure.json').write_text(json.dumps(manifest,sort_keys=True,indent=2)+'\n')
    env=dict(os.environ,PYTHONDONTWRITEBYTECODE='1');env.pop('PYTHONPATH',None)
    results=[];deadline=start+a.total_seconds
    for stage in jobs:
        remaining=deadline-time.monotonic()
        if remaining<=0:break
        receipt=output/(stage['name']+'.json');portability=output/(stage['name']+'-portability.json');log=output/(stage['name']+'.log')
        command=[sys.executable,'-B',str(copied/'final_owner_replay_worker_v2.py'),'--copy-c16',str(copied),'--recorded-c16',str(ROOT),'--output-dir',str(output),
                 '--consumer',stage['consumer'],'--portability-output',str(portability),'--',*stage['arguments'],'--output',str(receipt)]
        t=time.monotonic()
        with log.open('x') as stream:
            p=subprocess.Popen(command,cwd=copied,env=env,stdout=stream,stderr=subprocess.STDOUT,start_new_session=True)
            try:code=p.wait(timeout=min(stage['seconds'],remaining))
            except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait();code='EXTERNAL_STAGE_TIMEOUT'
        row=dict(name=stage['name'],returncode=code,seconds=time.monotonic()-t,log_sha256=sha(log))
        if code==0:
            r=read(receipt);pr=read(portability)
            assert r['status'] in stage['accepted_statuses'] and pr['status']=='PASS_EXPLICIT_RELOCATED_FROZEN_CONSUMER'
            assert pr['original_research_reads']==0 and pr['current_root']==str(copied) and pr['recorded_root']==str(ROOT)
            if stage.get('requires_raw_path_adapter'):assert any(h['attribute']=='read_named_rational' for h in pr['adapted_helpers'])
            row.update(status=r['status'],receipt_sha256=sha(receipt),portability_sha256=sha(portability),path_rewrites=len(pr['explicit_path_rewrites']))
        results.append(row);print(json.dumps(row),flush=True)
        if code!=0:break
    unchanged=all(sha(copied/r['path'])==r['sha256']==sha(ROOT/r['path']) for r in records)
    passed=unchanged and len(results)==len(jobs) and all(r['returncode']==0 for r in results)
    comparison=None
    if passed:
        before=read(output/'phase-one-baseline.json');after=read(output/'phase-one-matched.json')
        assert before['point_sha256']==after['point_sha256'] and before['anchor_orbit']==after['anchor_orbit']==15
        a0=Q(before['exact_restricted_L1_distance']);a1=Q(after['exact_restricted_L1_distance']);assert 0<a1<a0
        comparison=dict(before=str(a0),after=str(a1),strict_improvement=str(a0-a1),relative_decrease=str((a0-a1)/a0),global_cut_claimed=False)
    out=dict(status='PASS_FINAL_SUPPLEMENT_CHECKPOINT_CLEAN_COPY_REPLAY' if passed else 'FINAL_SUPPLEMENT_CHECKPOINT_REPLAY_REQUIRES_FOLLOWUP',checkpoint=commit,
             closure_sha256=sha(output/'closure.json'),declared_files=len(records),declared_bytes=sum(r['bytes'] for r in records),
             stages=results,expected_stage_count=len(jobs),all_source_bytes_unchanged=unchanged,elapsed_seconds=time.monotonic()-start,
             priority=19,source_C16_answered=False,solver_executed=False,canonical_validators_run=False,exact_phase_one_comparison=comparison)
    (output/'summary.json').write_text(json.dumps(out,sort_keys=True,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='stages'}),flush=True)
    assert passed
if __name__=='__main__':main()
