#!/usr/bin/env python3
"""UNRUN v2 final explicit-binding/import-closure replay; requires an explicit frozen checkpoint.

This performs no search, optimization, Git checkout, commit, or remote write.
The caller creates a new copy/output location and explicitly chooses the
committed checkpoint. All scientific input bytes must match both an accepted
inventory and that checkpoint's Git blob. Frozen consumers run sequentially.
"""
from pathlib import Path
import argparse,gzip,hashlib,json,os,shutil,signal,subprocess,sys,time

ROOT=Path(__file__).resolve().parent
THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS',
         'VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
INVENTORIES=[
 'two-basis-results/owner-flow-capacity-zero-face-inventory.json',
 'two-basis-results/joint-capacity-rank-closure-supplement.json',
 'two-basis-results/fixed-owner-residual-capacity-point22-Z-m02-X614-v1-inventory.json',
 'two-basis-results/singleton-global-point22-o40-complete-inventory.json',
 'two-basis-results/final-owner-checkpoint-import-closure.json']
POINT='coupling-results/two-basis-integer-witness22-rational.json.gz'
def guard():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    assert all(os.environ.get(k)=='1' for k in THREADS)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);b=p.read_bytes();return json.loads(gzip.decompress(b) if p.suffix=='.gz' else b)
def git(repo,*args):return subprocess.check_output(['git',*args],cwd=repo).decode().strip()

def stages():
    R='two-basis-results/';out=[]
    def add(name,consumer,args,status,seconds=180):out.append(dict(name=name,consumer=consumer,arguments=args,accepted_statuses=status if isinstance(status,list) else [status],seconds=seconds))
    add('flow-preparation','verify_owner_star_flow_extension.py',['--manifest',R+'joint-owner-flow-k22-pinned-point22.json'],'PASS_EXACT_COMPLETE_SELECTED_OWNER_FLOW_MODEL')
    add('capacity-preparation','verify_owner_star_capacity_extension.py',['--manifest',R+'joint-owner-flow-capacity-k22-pinned-point22.json'],'PASS_EXACT_COMPLETE_SELECTED_OWNER_FLOW_CAPACITY_MODEL')
    add('zero-face-map','verify_owner_capacity_zero_face.py',['--manifest',R+'joint-owner-capacity-zero-face-point22.json'],'PASS_EXACT_OWNER_CAPACITY_ZERO_FACE_REDUCTION')
    add('capacity-literal-endpoint','verify_owner_capacity_joint_literal.py',['--certificate',R+'joint-owner-capacity-zero-face-point22-exact.json'],'PASS_EXACT_LITERAL_OWNER_FLOW_CAPACITY_JOINT_ALLOCATION')
    add('capacity-exact-handoff','verify_capacity_joint_sector_handoff.py',['--joint',R+'joint-owner-capacity-zero-face-point22-exact.json','--joint-receipt',R+'joint-owner-capacity-zero-face-point22-exact-independent.json','--sector-prefix',R+'joint-capacity-sector-point22'],'PASS_EXACT_CAPACITY_JOINT_TO_SECTOR_HANDOFF')
    for side in ('X','Z'):
        add('capacity-sector-'+side,'verify_two_basis_rank_closed_allocation.py',['allocation','--certificate',R+'joint-capacity-sector-point22-'+side+'.json.gz','--point',POINT],'PASS_EXACT_DIRECT_COUNT_AND_LISTED_RANK_ROWS')
        for mask in (0,1,2,3,4,5,6,8,9,10,12):
            add(f'capacity-rank-{side}-{mask:02d}','two_basis_structure_verify_physical_push_closed.py',['--certificate',R+f'joint-capacity-ranks-point22-{side}-m{mask:02d}.json.gz','--point',POINT],['PASS_EXACT_PHYSICAL_SINGLE_PATTERN_BASIS_MIXTURE','PASS_EXACT_PHYSICAL_SINGLE_PATTERN_RANK_VIOLATION'])
    prefix=R+'fixed-owner-residual-capacity-point22-Z-m02-X614-v1'
    add('fixed-owner-tiny','verify_fixed_owner_residual_tiny.py',['--bank',R+'fixed-owner-residual-tiny-v1.json.gz'],'PASS_INDEPENDENT_FIXED_OWNER_RESIDUAL_TINY_CONTROLS')
    add('fixed-owner-preparation','verify_fixed_owner_residual_physical.py',['prepare','--frozen',prefix+'.frozen.json'],'PASS_INDEPENDENT_FIXED_OWNER_RESIDUAL_PREPARATION')
    add('fixed-owner-existing-subsets','verify_fixed_owner_existing_subset_screen.py',['--certificate',prefix+'-existing-subsets.json.gz'],'PASS_INDEPENDENT_FIXED_OWNER_EXISTING_SUBSET_SCREEN')
    add('fixed-owner-physical-endpoint','verify_fixed_owner_residual_physical.py',['endpoint','--frozen',prefix+'.frozen.json','--preparation-receipt',prefix+'-preparation-independent.json','--certificate',prefix+'.json.gz'],'PASS_INDEPENDENT_FIXED_OWNER_RESIDUAL_PHYSICAL_ENDPOINT')
    add('orbit40-direct-terminal','verify_singleton_exchange_terminal.py',['--certificate',R+'singleton-cg-point22-o40-terminal.json','--point',POINT],'PASS_DIRECT_TERMINAL_SINGLETON_BASIS_MIXTURE_REVIEW')
    return out

def closure():
    files={}
    def add(name,h):
        p=Path(name);assert not p.is_absolute() and '..' not in p.parts
        assert name not in files or files[name]==h,('inconsistent frozen inventories',name)
        files[name]=h
    for name in INVENTORIES:
        d=read(ROOT/name);add(name,sha(ROOT/name))
        for key in ('files','additional_files'):
            rows=d.get(key,{})
            if isinstance(rows,dict):rows=[dict(v,path=k) for k,v in rows.items()]
            for row in rows:add(row['path'],row['sha256'])
    for name in [Path(__file__).name,'replay_final_owner_checkpoint.py','final_owner_replay_worker.py','two-basis-results/final-owner-checkpoint-replay-plan.json','two-basis-results/final-owner-checkpoint-replay-plan-v2.json']:
        add(name,sha(ROOT/name))
    return files

def main():
    guard();start=time.monotonic();ap=argparse.ArgumentParser()
    ap.add_argument('--checkpoint',required=True);ap.add_argument('--copy-root',type=Path,required=True);ap.add_argument('--output-dir',type=Path,required=True)
    ap.add_argument('--total-seconds',type=int,default=1200);a=ap.parse_args()
    assert 0<a.total_seconds<=1800
    repo=Path(git(ROOT,'rev-parse','--show-toplevel'));commit=git(repo,'rev-parse',a.checkpoint+'^{commit}')
    assert git(repo,'rev-parse','HEAD')==commit,'checkpoint must be the explicitly frozen current HEAD'
    assert not git(repo,'status','--porcelain','--untracked-files=no'),'tracked worktree differs from checkpoint'
    copied=a.copy_root.resolve();output=a.output_dir.resolve()
    assert not copied.exists() and not output.exists() and not copied.is_relative_to(ROOT) and not output.is_relative_to(ROOT)
    assert not output.is_relative_to(copied) and not copied.is_relative_to(output)
    names=closure();assert len(names)<=2500
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
    assert sum(r['bytes'] for r in records)<2_000_000_000
    copied.mkdir(parents=True);output.mkdir(parents=True)
    for row in records:
        p=copied/row['path'];p.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(ROOT/row['path'],p);assert sha(p)==row['sha256']
    jobs=stages();manifest=dict(status='FROZEN_FINAL_OWNER_CHECKPOINT_CLEAN_COPY',checkpoint=commit,recorded_root=str(ROOT),copy_root=str(copied),output_dir=str(output),files=records,stages=jobs,
        inventory_hashes={p:sha(ROOT/p) for p in INVENTORIES},worker_sha256=sha(copied/'final_owner_replay_worker.py'),producer_sha256=sha(__file__),priority=19,threads=1,
        scope='Declared owner-flow/capacity/face, both22-rank outcomes, fixed-owner and orbit40terminal proofs. No solver replay or new mathematical search.')
    (output/'closure.json').write_text(json.dumps(manifest,sort_keys=True,indent=2)+'\n')
    env=dict(os.environ,PYTHONDONTWRITEBYTECODE='1');env.pop('PYTHONPATH',None)
    results=[];deadline=time.monotonic()+a.total_seconds
    for stage in jobs:
        remaining=deadline-time.monotonic()
        if remaining<=0:break
        receipt=output/(stage['name']+'.json');portability=output/(stage['name']+'-portability.json');log=output/(stage['name']+'.log')
        command=[sys.executable,'-B',str(copied/'final_owner_replay_worker.py'),'--copy-c16',str(copied),'--recorded-c16',str(ROOT),'--output-dir',str(output),
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
            row.update(status=r['status'],receipt_sha256=sha(receipt),portability_sha256=sha(portability),path_rewrites=len(pr['explicit_path_rewrites']))
        results.append(row);print(json.dumps(row),flush=True)
        if code!=0:break
    unchanged=all(sha(copied/r['path'])==r['sha256']==sha(ROOT/r['path']) for r in records)
    passed=unchanged and len(results)==len(jobs) and all(r['returncode']==0 for r in results)
    out=dict(status='PASS_FINAL_OWNER_CHECKPOINT_CLEAN_COPY_REPLAY' if passed else 'FINAL_OWNER_CHECKPOINT_REPLAY_REQUIRES_FOLLOWUP',checkpoint=commit,
             closure_sha256=sha(output/'closure.json'),declared_files=len(records),declared_bytes=sum(r['bytes'] for r in records),
             stages=results,expected_stage_count=len(jobs),all_source_bytes_unchanged=unchanged,elapsed_seconds=time.monotonic()-start,
             priority=19,source_C16_answered=False,solver_executed=False,canonical_validators_run=False)
    (output/'summary.json').write_text(json.dumps(out,sort_keys=True,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='stages'}),flush=True)
    assert passed
if __name__=='__main__':main()
