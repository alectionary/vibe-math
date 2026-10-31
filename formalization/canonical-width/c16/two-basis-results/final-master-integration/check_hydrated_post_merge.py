#!/usr/bin/env python3
"""Rerun the four validators in an exact-commit view without root hydration."""
import os
assert os.getpriority(os.PRIO_PROCESS, 0) == 19
THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
assert all(os.environ.get(k)=='1' for k in THREADS)
from pathlib import Path
import datetime,hashlib,json,subprocess,sys,tempfile,time
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[4]
COMMIT='85bdc843134579a842ebe97622747ac1a83c3d71'
NAMES=('validate_literature.py','validate_open_problems.py','validate_current_difficulty.py','validate_research_question_screening.py')
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def git(*args):return subprocess.check_output(['git','-C',str(ROOT),*args])
def write(name,obj):
    p=OUT/name;assert not p.exists()
    p.write_text(json.dumps(obj,indent=2)+'\n' if not isinstance(obj,str) else obj)
    return dict(path=str(p.relative_to(ROOT)),sha256=sha(p),bytes=p.stat().st_size)
def main():
    start=time.monotonic()
    assert git('rev-parse','HEAD').decode().strip()==COMMIT
    # Git understands skip-worktree absences; reject actual tracked changes.
    changed=git('diff','--name-only',COMMIT).decode().splitlines();assert not changed,changed
    sparse=json.loads((OUT/'receipt.json').read_text())
    assert sparse['status']=='FAIL_FOCUSED_POST_MERGE_INTEGRATION'
    entries=[]
    for raw in git('ls-tree','-rz',COMMIT).split(b'\0'):
        if not raw:continue
        info,name=raw.decode().split('\t',1);mode,kind,oid=info.split()
        assert kind=='blob',(name,kind)
        entries.append((name,mode,oid))
    view=Path(tempfile.mkdtemp(prefix='c16-final-integration-85bd-',dir='/private/tmp'))
    proc=subprocess.Popen(['git','-C',str(ROOT),'cat-file','--batch'],stdin=subprocess.PIPE,stdout=subprocess.PIPE)
    def blob(oid):
        proc.stdin.write((oid+'\n').encode());proc.stdin.flush()
        header=proc.stdout.readline().decode().split();assert header[0]==oid and header[1]=='blob'
        n=int(header[2]);data=proc.stdout.read(n);assert len(data)==n and proc.stdout.read(1)==b'\n'
        assert hashlib.sha1(b'blob '+str(n).encode()+b'\0'+data).hexdigest()==oid
        return data
    counts=dict(hardlinked_tracked_unchanged_files=0,git_blob_hydrated_files=0,git_blob_hydrated_bytes=0)
    for name,mode,oid in entries:
        target=view/name;target.parent.mkdir(parents=True,exist_ok=True);source=ROOT/name
        # Validator copies must resolve __file__ within the temporary view.
        if mode=='120000':
            target.symlink_to(blob(oid).decode());counts['git_blob_hydrated_files']+=1
        elif source.is_file() and name not in ['scripts/'+n for n in NAMES]:
            os.link(source,target);counts['hardlinked_tracked_unchanged_files']+=1
        else:
            data=blob(oid);target.write_bytes(data);target.chmod(0o755 if mode=='100755' else 0o644)
            counts['git_blob_hydrated_files']+=1;counts['git_blob_hydrated_bytes']+=len(data)
    proc.stdin.close();assert proc.wait(timeout=10)==0
    manifest=write('hydrated-view.json',dict(status='EXACT_MERGE_COMMIT_VALIDATOR_VIEW',commit=COMMIT,path=str(view),
        tree=git('rev-parse',COMMIT+'^{tree}').decode().strip(),counts=counts,
        entry_count=len(entries),entries=[dict(path=n,mode=m,blob=o) for n,m,o in entries],
        source_policy='Available tracked unchanged files are hardlinked read-only-in-use; absent sparse files and validator scripts are read directly from verified Git blobs. Validators do not write source files.'))
    runs=[];outputs=[manifest]
    for name in NAMES:
        source=view/'scripts'/name;t=time.monotonic()
        r=subprocess.run([sys.executable,'-B',str(source)],cwd=view,env=os.environ.copy(),capture_output=True,text=True,timeout=120)
        log=write('hydrated-'+name+'.log','command: '+sys.executable+' -B '+str(source)+'\nexit_code: '+str(r.returncode)+'\nstdout:\n'+r.stdout+'\nstderr:\n'+r.stderr)
        outputs.append(log);runs.append(dict(script='scripts/'+name,source_sha256=sha(source),exit_code=r.returncode,
            seconds=time.monotonic()-t,log=log))
    assert not git('diff','--name-only',COMMIT).decode().splitlines()
    passed=all(r['exit_code']==0 for r in runs)
    result=dict(status='PASS_HYDRATED_FOCUSED_POST_MERGE_C16_CANONICAL_INTEGRATION' if passed else 'FAIL_HYDRATED_FOCUSED_POST_MERGE_INTEGRATION',
        premerge_commit=sparse['premerge_commit'],merge_commit=COMMIT,incoming_master_commit=sparse['incoming_master_commit'],
        original_sparse_receipt=str((OUT/'receipt.json').relative_to(ROOT)),original_sparse_receipt_sha256=sha(OUT/'receipt.json'),
        sparse_failure_classification='Required tracked files omitted by sparse checkout. Initial failures are preserved; no initial validator pass claimed.',
        byte_identical_scoped_commit_files=sparse['exact_scoped_commit_file_count'],category_counts=sparse['category_counts'],
        readme_added_local_links_checked=sparse['readme_added_local_links_checked'],temporary_view=str(view),
        view_counts=counts,validators=runs,outputs=outputs,source_changes=False,root_hydrated=False,
        helper_path=str(Path(__file__).relative_to(ROOT)),helper_sha256=sha(__file__),nice=19,
        threads={k:os.environ[k] for k in THREADS},elapsed_seconds=time.monotonic()-start,
        utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),no_scientific_optimization=True,
        scope='Only the four named bookkeeping validators plus earlier exact commit-tree and new README-link checks. No blanket historical-validator pass, mathematical proof, source-case exclusion or new source result.')
    output=write('hydrated-receipt.json',result)
    print(json.dumps(dict(status=result['status'],receipt=output['path'],sha256=output['sha256'],
        validators=[(r['script'],r['exit_code']) for r in runs],view=str(view),counts=counts,elapsed_seconds=result['elapsed_seconds'])))
    raise SystemExit(0 if passed else 1)
if __name__=='__main__':main()
