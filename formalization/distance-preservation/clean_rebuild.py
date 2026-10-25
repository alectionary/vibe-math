"""Bounded isolated authored-source rebuild against the pinned cached dependencies."""
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor,wait,FIRST_COMPLETED
import datetime,hashlib,json,os,re,subprocess,threading,time
R=Path(__file__).resolve().parent
DEADLINE=datetime.datetime(2026,10,25,6,0,0,tzinfo=datetime.timezone.utc).timestamp()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def now():return datetime.datetime.now(datetime.timezone.utc).isoformat()

def main():
    manifest=json.loads((R/'verification.json').read_text());mods=manifest['module_order']
    runtime=json.loads((R/'.lean-runtime.json').read_text());lean=runtime['lean']
    paths=[p for p in runtime['LEAN_PATH'].split(':') if 'dyadic-rank' not in p and str(R) not in p]
    scratch=Path('/private/tmp/distance-preservation-clean-20261025')
    scratch.mkdir(exist_ok=False)
    logdir=R/'clean-rebuild-logs';logdir.mkdir(exist_ok=True)
    deps={};sources={}
    for m in mods:
        src=R/(m+'.lean');sources[m]=sha(src);(scratch/src.name).write_bytes(src.read_bytes())
        imports=re.findall(r'^import ([A-Za-z0-9_]+)\s*$',src.read_text(),re.M)
        deps[m]={d for d in imports if (R/(d+'.lean')).exists()}
        assert deps[m]<=set(mods),(m,deps[m]-set(mods))
    env=dict(os.environ,LEAN_PATH=str(scratch)+':'+':'.join(paths))
    assert str(R) not in env['LEAN_PATH'] and 'dyadic-rank' not in env['LEAN_PATH']
    started=now();lock=threading.Lock();processes=set();records=[];done=set();pending=list(mods);running={}
    allowed={'propext','Classical.choice','Quot.sound'}
    def stop_children():
        with lock:
            for p in list(processes):
                if p.poll() is None:p.terminate()
    def build(m):
        start=time.monotonic();log=logdir/(m+'.log')
        with log.open('w') as f:
            p=subprocess.Popen([lean,'-M','6000','-o',str(scratch/(m+'.olean')),str(scratch/(m+'.lean'))],cwd=scratch,env=env,stdout=f,stderr=subprocess.STDOUT)
            with lock:processes.add(p)
            try:p.wait(timeout=max(1,DEADLINE-time.time()))
            except BaseException:
                p.terminate()
                try:p.wait(timeout=5)
                except subprocess.TimeoutExpired:p.kill();p.wait()
                raise
            finally:
                with lock:processes.discard(p)
        body=log.read_text();bad='sorryAx' in body or '_native.' in body or 'error:' in body
        for group in re.findall(r'depends on axioms: \[([^]]*)\]',body):
            bad|=not {a.strip() for a in group.split(',') if a.strip()}<=allowed
        rec={'module':m,'exit_code':p.returncode,'seconds':time.monotonic()-start,'unexpected_axiom_or_error':bool(bad),
             'source_sha256':sha(scratch/(m+'.lean')),'log_sha256':sha(log),'finished_utc':now()}
        print(json.dumps(rec),flush=True);return rec
    status='PASS';reason=None
    pool=ThreadPoolExecutor(max_workers=3)
    try:
        while pending or running:
            if time.time()>=DEADLINE:
                status='TIME_LIMIT';reason='06:00 UTC closeout reserve reached';stop_children();break
            ready=[m for m in pending if deps[m]<=done]
            for m in ready[:3-len(running)]:
                pending.remove(m);running[pool.submit(build,m)]=m
            if not running:
                if pending:raise RuntimeError('Dependency deadlock')
                break
            finished,_=wait(running,timeout=10,return_when=FIRST_COMPLETED)
            for f in finished:
                m=running.pop(f);rec=f.result();records.append(rec)
                if rec['exit_code'] or rec['unexpected_axiom_or_error']:
                    status='FAILED';reason=m;stop_children();break
                done.add(m)
            if status!='PASS':break
    except BaseException as ex:
        status='INTERRUPTED';reason=repr(ex);stop_children()
    finally:
        if status!='PASS':stop_children()
        pool.shutdown(wait=True,cancel_futures=True)
        for f,m in list(running.items()):
            if f.done() and not f.cancelled():
                try:records.append(f.result())
                except BaseException:pass
    changed=[m for m in mods if sha(R/(m+'.lean'))!=sources[m]]
    if changed:status='FAILED';reason='Sources changed during rebuild'
    if status=='PASS' and (len(done)!=len(mods) or 'FinalAudit' not in done):
        status='FAILED';reason='Incomplete closure'
    source_set=hashlib.sha256(json.dumps(sources,sort_keys=True).encode()).hexdigest()
    out={'status':status,'reason':reason,'started_utc':started,'finished_utc':now(),'deadline_utc':'2026-10-25T06:00:00+00:00',
         'scope':'Every admitted authored Lean module copied into an isolated scratch directory and rebuilt. Original research and dyadic-rank compiled objects excluded from LEAN_PATH. Pinned cached mathlib/dependency/std modules reused; mathlib itself not rebuilt.',
         'scratch_path':str(scratch),'jobs':3,'source_set_sha256':source_set,'source_sha256':sources,'changed_sources':changed,
         'lean_toolchain':manifest['lean_toolchain'],'mathlib_commit':manifest['mathlib_commit'],'allowed_axioms':sorted(allowed),
         'completed':len(done),'total':len(mods),'unstarted':pending,'records':sorted(records,key=lambda x:mods.index(x['module']))}
    (R/'clean-rebuild.json').write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps({'status':status,'completed':len(done),'total':len(mods),'reason':reason}),flush=True)
    return 0 if status=='PASS' else 1
if __name__=='__main__':raise SystemExit(main())
