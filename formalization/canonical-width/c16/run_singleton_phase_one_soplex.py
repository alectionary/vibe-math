#!/usr/bin/env python3
"""One capped exact L1 phase-I solve after independent preparation acceptance."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):os.environ[k]='1'
from pathlib import Path
import argparse,hashlib,json,re,signal,subprocess,time
import psutil
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):return json.loads(Path(p).read_text())
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--manifest',type=Path,required=True);ap.add_argument('--receipt',type=Path,required=True);ap.add_argument('--output-prefix',type=Path,required=True);a=ap.parse_args()
    m=read(a.manifest);r=read(a.receipt)
    assert m['status']=='EXACT_SINGLETON_PHASE_ONE_LP_REQUIRES_REPLAY'
    assert r['status']=='PASS_EXACT_SINGLETON_PHASE_ONE_LP_AND_PHYSICAL_COLUMNS'
    assert r['manifest_sha256']==sha(a.manifest) and r['consumer_sha256']==sha(ROOT/'verify_singleton_phase_one.py')
    assert r['lp_sha256']==m['lp_sha256']==sha(m['lp'])
    assert m['basis_count']==3225 and m['anchor_orbit']==15 and m['variable_count']==m['basis_count']+2*m['ground_count']
    assert m['row_count']==1+m['ground_count']+m['variable_count']
    assert all(sha(ROOT/p)==h for p,h in m['source_hashes'].items())
    assert sha(ROOT/m['peer_receipt'])==m['peer_receipt_sha256']
    peer=read(ROOT/m['peer_receipt'])
    assert peer['status']=='PASS_READ_ONLY_EXACT_SINGLETON_PHASE_ONE_MATHEMATICAL_REVIEW'
    assert all(sha(ROOT/p)==h for p,h in peer['source_hashes'].items())
    assert sha(ROOT/m['proof_note'])==m['proof_note_sha256']
    setup=ROOT/'two-basis-results/soplex-setup/setup-ready.json';s=read(setup)
    assert s['status']=='PASS_SOPLEX_SETUP_AND_SUPPLEMENTAL_EXACT_CONTROLS'
    tiny=ROOT/'two-basis-results/soplex-setup/tiny-independent.json'
    assert sha(tiny)==s['tiny_receipt_sha256'] and read(tiny)['status']=='PASS_TINY_EXACT_SOPLEX_PRIMAL_FARKAS_CONTROLS'
    assert all(sha(p)==h for p,h in s['runtime_files'].items())
    os.environ['DYLD_LIBRARY_PATH']=s['environment']['DYLD_LIBRARY_PATH']
    prefix=a.output_prefix.resolve();suffixes=['.json','.frozen.json','.log','.primal','.dual','.bas','.rss.jsonl']
    assert all(not Path(str(prefix)+suffix).exists() for suffix in suffixes)
    command=[s['binary'],'--readmode=1','--solvemode=2','--int:syncmode=1','--int:checkmode=2','-f0','-o0','-s0','-t60',
             f'-X={prefix}.primal',f'-Y={prefix}.dual',f'--writebas={prefix}.bas',str(Path(m['lp']).resolve())]
    frozen=dict(status='FROZEN_SINGLE_EXACT_SINGLETON_PHASE_ONE_TRIAL',command=command,
                input_manifest=str(a.manifest),input_manifest_sha256=sha(a.manifest),input_lp_sha256=m['lp_sha256'],
                parent_manifest=m['parent_manifest'],parent_manifest_sha256=m['parent_manifest_sha256'],
                prep_receipt=str(a.receipt),prep_receipt_sha256=sha(a.receipt),consumer_sha256=r['consumer_sha256'],
                peer_receipt=m['peer_receipt'],peer_receipt_sha256=m['peer_receipt_sha256'],proof_note=m['proof_note'],proof_note_sha256=m['proof_note_sha256'],
                setup=str(setup.relative_to(ROOT)),setup_sha256=sha(setup),tiny_receipt_sha256=sha(tiny),
                runner_sha256=sha(__file__),runtime_files=s['runtime_files'],source_hashes=m['source_hashes'],priority=19,threads=1,
                internal_seconds=60,external_seconds=90,soft_rss_bytes=2*1024**3,no_automatic_retry=True,
                objective='Sum of positive and negative coordinate errors; zero cost for basis weights',
                scope='Exact restricted L1 distance requires primal/dual replay; a positive value is not a source obstruction.')
    Path(str(prefix)+'.frozen.json').write_text(json.dumps(frozen,indent=2)+'\n')
    start=time.monotonic();peak=0;stop=None
    with open(str(prefix)+'.log','w') as log,open(str(prefix)+'.rss.jsonl','w') as rsslog:
        p=subprocess.Popen(command,cwd=ROOT,env=os.environ,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        process=psutil.Process(p.pid);assert process.nice()==19
        while p.poll() is None:
            elapsed=time.monotonic()-start
            try:rss=process.memory_info().rss
            except psutil.NoSuchProcess:break
            peak=max(peak,rss);rsslog.write(json.dumps(dict(seconds=elapsed,rss_bytes=rss))+'\n');rsslog.flush()
            if rss>2*1024**3:stop='SOFT_RSS_LIMIT'
            if elapsed>=90:stop='EXTERNAL_WALL_LIMIT'
            if stop:
                os.killpg(p.pid,signal.SIGTERM)
                try:p.wait(timeout=3)
                except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait()
                break
            time.sleep(.5)
        p.wait()
    status=re.findall(r'^SoPlex status\s*:\s*(.+)$',Path(str(prefix)+'.log').read_text(),re.M)
    out=dict(status='EXACT_PHASE_ONE_SOLVER_ENDPOINT_REQUIRES_REPLAY',reported_solver_status=status[-1] if status else None,
             returncode=p.returncode,external_stop=stop,seconds=time.monotonic()-start,maximum_sampled_rss_bytes=peak,
             frozen_sha256=sha(str(prefix)+'.frozen.json'),source_C16_answered=False,
             outputs={suffix:dict(path=str(prefix)+suffix,sha256=sha(str(prefix)+suffix)) for suffix in suffixes[2:] if Path(str(prefix)+suffix).exists()})
    Path(str(prefix)+'.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
if __name__=='__main__':main()
