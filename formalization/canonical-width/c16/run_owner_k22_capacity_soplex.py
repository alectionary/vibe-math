#!/usr/bin/env python3
"""One60/90-second exact shared8-event capacity trial, after independent prep."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(key)=='1'
from pathlib import Path
import argparse,hashlib,json,re,signal,subprocess,time
import psutil
ROOT=Path(__file__).resolve().parent
def read(p):return json.loads(Path(p).read_bytes())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--manifest',required=True);ap.add_argument('--receipt',required=True);ap.add_argument('--peer-review',required=True);ap.add_argument('--output-prefix',required=True);a=ap.parse_args()
    m,r=read(a.manifest),read(a.receipt);peer=read(a.peer_review)
    assert m['status']=='PASS_EXACT_OWNER_K22_CAPACITY_LP_TEXT_ROUNDTRIP' and r['status']=='PASS_EXACT_OWNER_K22_CAPACITY_MODEL'
    assert r['manifest_sha256']==sha(a.manifest) and r['consumer_sha256']==sha('verify_owner_k22_capacity_extension.py')
    assert r['lp_sha256']==m['lp_sha256']==sha(m['lp']) and m['semantic_sha256']==sha(m['semantic'])
    assert m['variable_count']==12655 and m['row_count']==64835 and m['zero_tau_pins'] is True
    assert peer['status'].startswith('PASS')
    w=read(m['semantic']);assert all(sha(p)==h for p,h in w['source_hashes'].items())
    assert m['point_sha256']==w['point_sha256']==sha(w['point'])
    setup='two-basis-results/soplex-setup/setup-ready.json';s=read(setup);tiny='two-basis-results/soplex-setup/tiny-independent.json'
    assert s['status']=='PASS_SOPLEX_SETUP_AND_SUPPLEMENTAL_EXACT_CONTROLS' and sha(tiny)==s['tiny_receipt_sha256']
    assert read(tiny)['status']=='PASS_TINY_EXACT_SOPLEX_PRIMAL_FARKAS_CONTROLS' and all(sha(p)==h for p,h in s['runtime_files'].items())
    os.environ['DYLD_LIBRARY_PATH']=s['environment']['DYLD_LIBRARY_PATH']
    prefix=Path(a.output_prefix).resolve();suffixes=['.json','.frozen.json','.log','.primal','.dual','.bas','.rss.jsonl'];assert all(not Path(str(prefix)+z).exists() for z in suffixes)
    command=[s['binary'],'--readmode=1','--solvemode=2','--int:syncmode=1','--int:checkmode=2','-f0','-o0','-s0','-t60',f'-X={prefix}.primal',f'-Y={prefix}.dual',f'--writebas={prefix}.bas',str(Path(m['lp']).resolve())]
    frozen=dict(status='FROZEN_SINGLE_EXACT_OWNER_K22_CAPACITY_SOPLEX_TRIAL',command=command,input_manifest=a.manifest,input_manifest_sha256=sha(a.manifest),
        input_lp_sha256=m['lp_sha256'],semantic_sha256=m['semantic_sha256'],preparation_receipt=a.receipt,preparation_receipt_sha256=sha(a.receipt),
        peer_review=a.peer_review,peer_review_sha256=sha(a.peer_review),setup_sha256=sha(setup),tiny_sha256=sha(tiny),runtime_files=s['runtime_files'],
        runner_sha256=sha(__file__),priority=19,threads=1,internal_seconds=60,external_seconds=90,soft_rss_bytes=2*1024**3,
        zero_tau_pins=True,no_automatic_retry=True,source_C16_answered=False)
    Path(str(prefix)+'.frozen.json').write_text(json.dumps(frozen,sort_keys=True,indent=2)+'\n')
    start=time.monotonic();peak=0;samples=0;stop=None
    with open(str(prefix)+'.log','w') as log,open(str(prefix)+'.rss.jsonl','w') as rsslog:
        p=subprocess.Popen(command,cwd=ROOT,env=os.environ,stdout=log,stderr=subprocess.STDOUT,start_new_session=True);task=psutil.Process(p.pid);assert task.nice()==19
        while p.poll() is None:
            elapsed=time.monotonic()-start
            try:rss=task.memory_info().rss
            except psutil.NoSuchProcess:break
            samples+=1;peak=max(peak,rss);rsslog.write(json.dumps(dict(seconds=elapsed,rss_bytes=rss))+'\n');rsslog.flush()
            if rss>2*1024**3:stop='SOFT_RSS_LIMIT'
            if elapsed>=90:stop='EXTERNAL_WALL_LIMIT'
            if stop:
                os.killpg(p.pid,signal.SIGTERM)
                try:p.wait(timeout=3)
                except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait()
                break
            time.sleep(.5)
        p.wait()
    assert all(sha(p)==h for p,h in w['source_hashes'].items())
    status=re.findall(r'^SoPlex status\s*:\s*(.+)$',Path(str(prefix)+'.log').read_text(),re.M)
    out=dict(status='SOPLEX_OWNER_K22_CAPACITY_ENDPOINT_REQUIRES_REPLAY',reported_solver_status=status[-1] if status else None,returncode=p.returncode,
        external_stop=stop,seconds=time.monotonic()-start,maximum_sampled_rss_bytes=peak,rss_samples=samples,peak_memory_claimed=False,
        frozen_sha256=sha(str(prefix)+'.frozen.json'),source_C16_answered=False,
        outputs={z:dict(path=str(prefix)+z,sha256=sha(str(prefix)+z)) for z in suffixes[2:] if Path(str(prefix)+z).exists()})
    Path(str(prefix)+'.json').write_text(json.dumps(out,sort_keys=True,indent=2)+'\n');print(out)
if __name__=='__main__':main()
