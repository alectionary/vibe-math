"""Verify Git blobs, copy a declared input closure, and replay exact new gates.

No optimization or research search is performed. The old supplemental closure
supplies preserved dependencies; only the explicitly listed new gates run.
"""
from pathlib import Path
import argparse,ast,gzip,hashlib,json,os,re,shutil,signal,subprocess,sys,time

ROOT=Path(__file__).resolve().parent
THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
OLD=(Path('/private/tmp/c16-two-basis-20261030T1438/formalization/canonical-width/c16'),Path('/private/tmp/c16-coupling-20261030T0514/formalization/canonical-width/c16'))
BASE='two-basis-results/final-supplement-checkpoint-4587314/closure.json'
HEX=re.compile('[0-9a-f]{64}\\Z')

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);b=p.read_bytes();return json.loads(gzip.decompress(b) if p.suffix=='.gz' else b)
def local(name):
    p=Path(name)
    if p.is_absolute():
        for root in (ROOT,*OLD):
            if p.is_relative_to(root):return p.relative_to(root).as_posix()
        return None
    if '..' in p.parts:return None
    return p.as_posix()

def collect(plan):
    files={};queue=[];external={}
    def add(name,h=None,scan=True):
        rel=local(name)
        if rel is None:
            if h:external[name]=h
            return
        p=ROOT/rel;assert p.is_file(),('Missing declared input',rel)
        actual=sha(p);assert h is None or actual==h,('Changed bound input',rel)
        if rel in files:assert files[rel]==actual;return
        files[rel]=actual
        if scan:queue.append(rel)
    base=read(ROOT/BASE);assert base['status']=='FROZEN_FINAL_OWNER_CHECKPOINT_CLEAN_COPY'
    for r in base['files']:add(r['path'],r['sha256'],False)
    add(BASE,scan=False)
    for p in ROOT.glob('shared-master-results/*'):
        if p.is_file():add(p.relative_to(ROOT).as_posix())
    for pattern in ('shared_master*.py','verify_shared_master*.py'):
        for p in ROOT.glob(pattern):add(p.name)
    for name in [Path(__file__).name,'shared_master_replay_worker.py',plan]:add(name)
    def walk(obj):
        if isinstance(obj,list):
            for x in obj:walk(x)
        elif isinstance(obj,dict):
            if isinstance(obj.get('path'),str) and isinstance(obj.get('sha256'),str) and HEX.fullmatch(obj['sha256']):add(obj['path'],obj['sha256'])
            for k,v in obj.items():
                if k in ['source_hashes','dependencies','repository_input_bindings','input_bindings','source_bindings'] and isinstance(v,dict):
                    for path,h in v.items():
                        if isinstance(h,str) and HEX.fullmatch(h):add(path,h)
                if isinstance(v,str) and HEX.fullmatch(v):
                    if k.endswith('_sha256') and isinstance(obj.get(k[:-7]),str):add(obj[k[:-7]],v)
                    elif ('/' in k or k.endswith(('.py','.json','.md','.lp','.gz','.npz'))) and (local(k) is None or (ROOT/local(k)).is_file()):add(k,v)
                if isinstance(v,(dict,list)):walk(v)
    while queue:
        rel=queue.pop();p=ROOT/rel
        if p.suffix=='.py':
            for node in ast.walk(ast.parse(p.read_text())):
                modules=[x.name for x in node.names] if isinstance(node,ast.Import) else [node.module] if isinstance(node,ast.ImportFrom) and node.module else []
                for module in modules:
                    name=module.replace('.','/')+'.py'
                    if (ROOT/name).is_file():add(name)
        elif p.name.endswith(('.json','.json.gz')):walk(read(p))
    return files,external

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19 and all(os.environ.get(k)=='1' for k in THREADS)
    ap=argparse.ArgumentParser()
    for key in ['checkpoint','plan','copy-root','output']:ap.add_argument('--'+key,required=True)
    a=ap.parse_args();start=time.monotonic();copied=Path(a.copy_root).resolve();out=ROOT/a.output
    assert not copied.exists() and not out.exists() and not copied.is_relative_to(ROOT)
    repo=Path(subprocess.check_output(['git','rev-parse','--show-toplevel'],cwd=ROOT,text=True).strip())
    commit=subprocess.check_output(['git','rev-parse',a.checkpoint+'^{commit}'],cwd=repo,text=True).strip()
    assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=repo,text=True).strip()==commit
    assert not subprocess.check_output(['git','status','--porcelain','--untracked-files=no'],cwd=repo,text=True).strip()
    files,external=collect(a.plan);assert len(files)<4000
    tree={}
    for row in subprocess.check_output(['git','ls-tree','-r','-z',commit],cwd=repo).split(b'\0'):
        if row:
            meta,path=row.split(b'\t',1);mode,kind,oid=meta.decode().split();tree[path.decode()]=(mode,kind,oid)
    records=[];prefix=ROOT.relative_to(repo).as_posix()
    for name,h in sorted(files.items()):
        b=(ROOT/name).read_bytes();mode,kind,oid=tree[prefix+'/'+name]
        assert kind=='blob' and mode!='120000' and hashlib.sha256(b).hexdigest()==h
        assert hashlib.sha1(b'blob '+str(len(b)).encode()+b'\0'+b).hexdigest()==oid
        records.append(dict(path=name,sha256=h,bytes=len(b),git_blob=oid))
    assert sum(r['bytes'] for r in records)<3_000_000_000
    copied.mkdir(parents=True)
    for r in records:
        p=copied/r['path'];p.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(ROOT/r['path'],p);assert sha(p)==r['sha256']
    output=copied/'_replay_outputs';output.mkdir()
    jobs=read(ROOT/a.plan)['stages'];results=[];env=dict(os.environ,PYTHONDONTWRITEBYTECODE='1');env.pop('PYTHONPATH',None)
    for stage in jobs:
        receipt=output/(stage['name']+'.json');portable=output/(stage['name']+'-portability.json');log=output/(stage['name']+'.log')
        command=[sys.executable,'-B',str(copied/'shared_master_replay_worker.py'),'--copy-root',str(copied),'--recorded-root',str(ROOT),
            '--consumer',stage['consumer'],'--portability-output',str(portable),'--',*stage['arguments'],'--output',str(receipt)]
        t=time.monotonic()
        with log.open('x') as stream:
            task=subprocess.Popen(command,cwd=copied,env=env,stdout=stream,stderr=subprocess.STDOUT,start_new_session=True)
            try:code=task.wait(timeout=stage.get('seconds',120))
            except subprocess.TimeoutExpired:os.killpg(task.pid,signal.SIGKILL);task.wait();code='TIME_LIMIT'
        row=dict(name=stage['name'],returncode=code,elapsed_seconds=time.monotonic()-t,log_sha256=sha(log))
        if code==0:
            r=read(receipt);p=read(portable);assert r['status']==stage['accepted_status'] and p['status']=='PASS_EXPLICIT_SHARED_MASTER_CLEAN_REPLAY'
            assert p['original_research_reads']==0
            row.update(status=r['status'],receipt_sha256=sha(receipt),portability_sha256=sha(portable))
        results.append(row);print(json.dumps(row),flush=True)
        if code!=0:break
    unchanged=all(sha(ROOT/r['path'])==r['sha256']==sha(copied/r['path']) for r in records)
    passed=unchanged and len(results)==len(jobs) and all(r['returncode']==0 for r in results)
    result=dict(status='PASS_SHARED_MASTER_CHECKPOINT_CLEAN_REPLAY' if passed else 'SHARED_MASTER_CLEAN_REPLAY_REQUIRES_FOLLOWUP',
        checkpoint=commit,plan_sha256=sha(ROOT/a.plan),worker_sha256=sha(ROOT/'shared_master_replay_worker.py'),controller_sha256=sha(__file__),
        copy_root=str(copied),output_directory=str(output),declared_files=len(records),declared_bytes=sum(r['bytes'] for r in records),
        files=records,external_runtime_bindings=external,stages=results,expected_stages=len(jobs),all_source_bytes_unchanged=unchanged,
        original_research_reads=0 if passed else None,solver_executed=False,source_C16_answered=False,elapsed_seconds=time.monotonic()-start,priority=19,threads=1)
    out.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k not in ['files','external_runtime_bindings','stages']},indent=2))
    assert passed

if __name__=='__main__':main()
