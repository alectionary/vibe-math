#!/usr/bin/env python3
"""One bounded exact shared-master phase-I solve after independent acceptance."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
assert all(os.environ.get(k)=='1' for k in THREADS)
from pathlib import Path
import argparse,gzip,hashlib,json,re,signal,subprocess,time
import psutil
ROOT=Path(__file__).resolve().parent
OLD_ROOTS=[Path('/private/tmp/c16-two-basis-20261030T1438/formalization/canonical-width/c16'),
           Path('/private/tmp/c16-coupling-20261030T0514/formalization/canonical-width/c16')]
def resolve(path):
    p=Path(path)
    if not p.is_absolute():return ROOT/p
    for old in OLD_ROOTS:
        try:return ROOT/p.relative_to(old)
        except ValueError:pass
    return p
def sha(path):return hashlib.sha256(resolve(path).read_bytes()).hexdigest()
def read(path):
    p=resolve(path);data=p.read_bytes()
    return json.loads(gzip.decompress(data) if p.suffix=='.gz' else data)
def write(path,obj):
    p=resolve(path);assert not p.exists();p.parent.mkdir(parents=True,exist_ok=True)
    p.write_text(json.dumps(obj,indent=2,sort_keys=True)+'\n')
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--manifest',required=True)
    ap.add_argument('--receipt',required=True);ap.add_argument('--prefix',required=True)
    a=ap.parse_args();m,r=read(a.manifest),read(a.receipt)
    assert m['status']=='EXACT_SHARED_BASIS_PHASE_ONE_LP_REQUIRES_REPLAY'
    assert r['status']=='PASS_EXACT_SHARED_BASIS_PHASE_ONE_MODEL'
    assert r['manifest_sha256']==sha(a.manifest)
    assert r['consumer_sha256']==sha('verify_shared_master_preparation.py')
    for key in ('lp','semantic','seed'):
        assert sha(m[key])==m[key+'_sha256']==r[key+'_sha256']
    assert m['zero_tau_pins'] is False and m['all_sixteen_patterns'] is True
    assert 32<=m['basis_count']<3000 and m['variable_count']==22513+m['basis_count']+46080
    semantic=read(m['semantic']);assert all(sha(p)==h for p,h in semantic['source_hashes'].items())
    assert sha(semantic['point'])==m['point_sha256']==semantic['point_sha256']
    setup_path='two-basis-results/soplex-setup/setup-ready.json';tiny_path='two-basis-results/soplex-setup/tiny-independent.json'
    setup=read(setup_path)
    assert setup['status']=='PASS_SOPLEX_SETUP_AND_SUPPLEMENTAL_EXACT_CONTROLS'
    assert sha(tiny_path)==setup['tiny_receipt_sha256']
    assert read(tiny_path)['status']=='PASS_TINY_EXACT_SOPLEX_PRIMAL_FARKAS_CONTROLS'
    assert all(sha(p)==h for p,h in setup['runtime_files'].items())
    os.environ['DYLD_LIBRARY_PATH']=setup['environment']['DYLD_LIBRARY_PATH']
    prefix=resolve(a.prefix).resolve();prefix.parent.mkdir(parents=True,exist_ok=True)
    suffixes=['.json','.frozen.json','.log','.primal','.dual','.bas','.rss.jsonl']
    assert not any(Path(str(prefix)+s).exists() for s in suffixes)
    command=[setup['binary'],'--readmode=1','--solvemode=2','--int:syncmode=1','--int:checkmode=2',
             '-f0','-o0','-s0','-t600',f'-X={prefix}.primal',f'-Y={prefix}.dual',
             f'--writebas={prefix}.bas',str(resolve(m['lp']).resolve())]
    frozen=dict(status='FROZEN_SINGLE_EXACT_SHARED_BASIS_PHASE_ONE_SOPLEX_TRIAL',command=command,
        manifest=a.manifest,manifest_sha256=sha(a.manifest),preparation_receipt=a.receipt,preparation_receipt_sha256=sha(a.receipt),
        semantic_sha256=m['semantic_sha256'],lp_sha256=m['lp_sha256'],seed_sha256=m['seed_sha256'],
        source_hashes=semantic['source_hashes'],geometry_bank_sha256=m['geometry_bank_sha256'],
        setup=setup_path,setup_sha256=sha(setup_path),tiny_receipt=tiny_path,tiny_receipt_sha256=sha(tiny_path),
        runtime_files=setup['runtime_files'],runner_sha256=sha(__file__),consumer_sha256=r['consumer_sha256'],
        variable_count=m['variable_count'],row_count=m['row_count'],basis_count=m['basis_count'],
        zero_tau_pins=False,all_sixteen_patterns=True,internal_seconds=600,external_seconds=660,
        sampled_rss_limit_bytes=4*1024**3,sample_interval_seconds=.5,priority=19,threads=1,
        no_automatic_retry=True,no_column_generation_loop=True,seed_is_feasibility_certificate_not_solver_warm_start=True,
        source_C16_answered=False,independent_endpoint_acceptance_required=True)
    write(str(prefix)+'.frozen.json',frozen)
    start=time.monotonic();peak=0;samples=0;stop=None
    with Path(str(prefix)+'.log').open('w') as log,Path(str(prefix)+'.rss.jsonl').open('w') as rsslog:
        process=subprocess.Popen(command,cwd=ROOT,env=os.environ.copy(),stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        task=psutil.Process(process.pid)
        try:
            assert task.nice()==19
            while process.poll() is None:
                elapsed=time.monotonic()-start
                try:
                    descendants=task.children(recursive=True)
                    rss=sum(p.memory_info().rss for p in [task,*descendants] if p.is_running())
                except psutil.NoSuchProcess:
                    if process.poll() is not None:break
                    continue
                samples+=1;peak=max(peak,rss)
                rsslog.write(json.dumps(dict(seconds=elapsed,rss_bytes=rss))+'\n');rsslog.flush()
                if rss>4*1024**3:stop='SAMPLED_RSS_LIMIT'
                if elapsed>=660:stop='EXTERNAL_WALL_LIMIT'
                if stop:
                    os.killpg(process.pid,signal.SIGTERM)
                    try:process.wait(timeout=3)
                    except subprocess.TimeoutExpired:os.killpg(process.pid,signal.SIGKILL);process.wait()
                    break
                time.sleep(.5)
            process.wait()
        except BaseException:
            if process.poll() is None:
                os.killpg(process.pid,signal.SIGKILL);process.wait()
            raise
    assert all(sha(p)==h for p,h in semantic['source_hashes'].items())
    status=re.findall(r'^SoPlex status\s*:\s*(.+)$',Path(str(prefix)+'.log').read_text(),re.M)
    out=dict(status='SOPLEX_SHARED_BASIS_PHASE_ONE_ENDPOINT_REQUIRES_REPLAY',
        reported_solver_status=status[-1] if status else None,returncode=process.returncode,external_stop=stop,
        seconds=time.monotonic()-start,maximum_sampled_rss_bytes=peak,rss_samples=samples,peak_memory_claimed=False,
        frozen=str(prefix)+'.frozen.json',frozen_sha256=sha(str(prefix)+'.frozen.json'),
        zero_tau_pins=False,exact_membership_claimed=False,global_separation_claimed=False,source_C16_answered=False,
        outputs={s:dict(path=str(prefix)+s,sha256=sha(str(prefix)+s)) for s in suffixes[2:] if Path(str(prefix)+s).exists()})
    write(str(prefix)+'.json',out);print(json.dumps(out),flush=True)
if __name__=='__main__':main()
