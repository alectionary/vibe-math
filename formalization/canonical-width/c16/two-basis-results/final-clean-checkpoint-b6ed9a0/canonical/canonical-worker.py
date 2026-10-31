#!/usr/bin/env python3
"""Read-only Git archive export and five canonical validators, with guarded reads."""
from pathlib import Path
import argparse,hashlib,json,os,runpy,shutil,signal,subprocess,sys,tarfile,tempfile,time
THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
VALIDATORS=['validate_literature.py','validate_open_problems.py','validate_current_difficulty.py','validate_research_question_screening.py','validate_difficulty.py']
def guard():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    assert all(os.environ.get(k)=='1' for k in THREADS)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def worker(root,script,output):
    root=root.resolve();output=output.resolve();opened=set();denied=[]
    runtime={Path(sys.prefix).resolve(),Path(sys.base_prefix).resolve(),Path(sys.exec_prefix).resolve(),Path(os.__file__).resolve().parent}
    os_files={Path(p).resolve() for p in ['/dev/null','/dev/urandom','/dev/random','/etc/localtime','/System/Library/CoreServices/SystemVersion.plist']}
    def audit(event,args):
        if event!='open' or not args or not isinstance(args[0],(str,bytes,os.PathLike)):return
        p=Path(os.fsdecode(args[0])).resolve();mode=args[1] if len(args)>1 else None;flags=args[2] if len(args)>2 else 0
        writing=(isinstance(mode,str) and any(c in mode for c in 'wa+')) or (isinstance(flags,int) and bool(flags&(os.O_WRONLY|os.O_RDWR|os.O_CREAT|os.O_TRUNC|os.O_APPEND)))
        if p.is_relative_to(output):return
        if p.is_relative_to(root) and not writing:opened.add(str(p.relative_to(root)));return
        if not writing and (p in os_files or any(p.is_relative_to(r) for r in runtime)):return
        denied.append(str(p));raise PermissionError('outside clean canonical export: '+str(p))
    os.chdir(root);tempfile.tempdir=str(output);os.environ['TMPDIR']=str(output)
    sys.path=[str(root/'scripts'),*[str(p) for p in map(Path,sys.path) if p.is_absolute() and any(p.resolve().is_relative_to(r) for r in runtime)]]
    sys.addaudithook(audit);completed=False
    try:runpy.run_path(str(root/'scripts'/script),run_name='__main__');completed=True
    finally:
        record=dict(status='PASS_CLEAN_CANONICAL_VALIDATOR' if completed else 'CANONICAL_VALIDATOR_REJECTED',validator=script,
            copied_files_opened=sorted(opened),denied_outside_reads=denied,original_research_reads=0,
            runtime_read_prefixes=sorted(map(str,runtime)),os_read_allowlist=sorted(map(str,os_files)),priority=19)
        (output/(script+'.reads.json')).write_text(json.dumps(record,indent=2,sort_keys=True)+'\n')
def main():
    guard();ap=argparse.ArgumentParser();ap.add_argument('--repo',type=Path);ap.add_argument('--checkpoint');ap.add_argument('--copy-root',type=Path,required=True);ap.add_argument('--output-dir',type=Path,required=True);ap.add_argument('--worker');a=ap.parse_args()
    if a.worker:return worker(a.copy_root,a.worker,a.output_dir)
    start=time.monotonic();repo=a.repo.resolve();root=a.copy_root.resolve();output=a.output_dir.resolve()
    assert not root.exists() and not output.exists() and not root.is_relative_to(repo) and not output.is_relative_to(repo)
    assert not root.is_relative_to(output) and not output.is_relative_to(root)
    commit=subprocess.check_output(['git','rev-parse',a.checkpoint+'^{commit}'],cwd=repo,text=True).strip();assert commit==a.checkpoint
    raw=subprocess.check_output(['git','ls-tree','-r','-l','-z',commit],cwd=repo);tree={}
    for entry in raw.split(b'\0'):
        if not entry:continue
        meta,name=entry.split(b'\t',1);mode,kind,oid,size=meta.decode().split();name=name.decode()
        assert kind=='blob' and mode in ('100644','100755') and '..' not in Path(name).parts
        tree[name]=(mode,oid,int(size))
    size=sum(row[2] for row in tree.values());assert size<8_000_000_000 and len(tree)<30000
    assert shutil.disk_usage(root.parent).free>size+2_000_000_000
    root.mkdir(parents=True);output.mkdir(parents=True);records=[];deadline=time.monotonic()+240
    p=subprocess.Popen(['git','archive','--format=tar',commit],cwd=repo,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True)
    try:
        with tarfile.open(fileobj=p.stdout,mode='r|') as archive:
            for member in archive:
                assert time.monotonic()<deadline,'archive export cap'
                if member.isdir():continue
                assert member.isfile() and member.name in tree
                mode,oid,n=tree[member.name];assert n==member.size
                dest=root/member.name;dest.parent.mkdir(parents=True,exist_ok=True)
                content=hashlib.sha1() if len(oid)==40 else hashlib.sha256();content.update(b'blob '+str(n).encode()+b'\0');h=hashlib.sha256()
                stream=archive.extractfile(member);written=0
                with dest.open('xb') as sink:
                    while True:
                        block=stream.read(1024*1024)
                        if not block:break
                        assert time.monotonic()<deadline,'archive export cap'
                        sink.write(block);content.update(block);h.update(block);written+=len(block)
                assert written==n and content.hexdigest()==oid
                dest.chmod(int(mode[-3:],8));records.append(dict(path=member.name,bytes=n,git_blob=oid,sha256=h.hexdigest()))
        assert p.wait(timeout=10)==0 and len(records)==len(tree)
    except BaseException:
        if p.poll() is None:os.killpg(p.pid,signal.SIGKILL);p.wait()
        raise
    manifest=dict(status='FROZEN_CLEAN_CANONICAL_GIT_ARCHIVE',checkpoint=commit,files=records,bytes=size,driver_sha256=sha(__file__),source_repo=str(repo),copy_root=str(root),priority=19)
    (output/'archive.json').write_text(json.dumps(manifest,indent=2,sort_keys=True)+'\n')
    helper=output/'canonical-worker.py';shutil.copyfile(__file__,helper);results=[]
    for script in VALIDATORS:
        command=[sys.executable,'-B',str(helper),'--copy-root',str(root),'--output-dir',str(output),'--worker',script]
        log=output/(script+'.log');t=time.monotonic()
        with log.open('x') as stream:
            child=subprocess.Popen(command,cwd=root,stdout=stream,stderr=subprocess.STDOUT,start_new_session=True)
            try:code=child.wait(timeout=120)
            except subprocess.TimeoutExpired:os.killpg(child.pid,signal.SIGKILL);child.wait();code='TIMEOUT'
        readlog=output/(script+'.reads.json');assert readlog.is_file()
        readproof=json.loads(readlog.read_text());assert not readproof['denied_outside_reads']
        row=dict(validator=script,exit_code=code,seconds=time.monotonic()-t,log_sha256=sha(log),reads_sha256=sha(readlog),script_sha256=sha(root/'scripts'/script),original_research_reads=0)
        results.append(row);print(json.dumps(row),flush=True)
    out=dict(status='PASS_FOUR_CURRENT_CANONICAL_VALIDATORS_WITH_HISTORICAL_RESULT' if all(r['exit_code']==0 for r in results[:4]) else 'CURRENT_CANONICAL_VALIDATOR_REPLAY_FAILED',checkpoint=commit,
        archive_sha256=sha(output/'archive.json'),validator_results=results,historical_result_not_relabelled=True,source_files=len(tree),source_bytes=size,
        priority=19,threads=1,elapsed_seconds=time.monotonic()-start,source_mutated=False,original_research_reads=0)
    (output/'summary.json').write_text(json.dumps(out,indent=2,sort_keys=True)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='validator_results'}),flush=True)
if __name__=='__main__':main()
