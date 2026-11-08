#!/usr/bin/env python3
import argparse,hashlib,json,os,pathlib,shutil,time
from solve import BASE,run as count_run
from sat_backend import run
HERE=pathlib.Path(__file__).resolve().parent
if hasattr(os,'sched_getaffinity'):os.sched_setaffinity(0,sorted(os.sched_getaffinity(0))[:2])
p=argparse.ArgumentParser();p.add_argument('--reuse-quarter',type=pathlib.Path);a=p.parse_args()
out=HERE/'sat-outputs';out.mkdir(exist_ok=True);(out/'tests-passed.json').unlink(missing_ok=True)
for kind,expected in [('blocks01',43046721),('blocks23',0)]:
    print('START test real',kind,flush=True)
    r=count_run('real',kind,7200,out/f'test-real-{kind}.json')
    assert r['status']=='COMPLETE' and r['frames_found']==expected
for kind in ('A','B','C'):
    print('START test planted1',kind,flush=True)
    r=run('planted1',kind,7200,out/f'test-planted1-{kind}.json')
    assert r['status']=='COMPLETE' and r['frames_found']==1
if a.reuse_quarter:
    manifest=json.loads(a.reuse_quarter.with_name('manifest.json').read_text())
    assert manifest['sat_source_sha256']==hashlib.sha256((HERE/'sat_backend.py').read_bytes()).hexdigest()
    for name,digest in manifest['input_sha256'].items():assert hashlib.sha256((BASE/name).read_bytes()).hexdigest()==digest
    print('WAIT existing quarter diagnostic',flush=True)
    wait_until=time.monotonic()+7500
    while not (a.reuse_quarter.exists() and a.reuse_quarter.with_suffix('.log').exists()):
        if time.monotonic()>wait_until:raise TimeoutError('Quarter diagnostic did not produce a result; real runs prohibited')
        time.sleep(1)
    r=json.loads(a.reuse_quarter.read_text())
    assert r['pools']=='real' and r['class']=='quarter'
    shutil.copyfile(a.reuse_quarter,out/'test-real-quarter.json')
    shutil.copyfile(a.reuse_quarter.with_suffix('.log'),out/'test-real-quarter.log')
else:
    print('START test real quarter',flush=True)
    r=run('real','quarter',7200,out/'test-real-quarter.json')
assert r['status']=='COMPLETE' and r['frames_found']==0,'quarter known-answer test failed; real runs prohibited'
(out/'tests-passed.json').write_text(json.dumps({'all_passed':True,'time_unix':time.time(),'reused_quarter':str(a.reuse_quarter) if a.reuse_quarter else None},indent=2)+'\n')
for kind in ('A','B','C'):
    print('START real',kind,flush=True)
    run('real',kind,7200,out/f'real-{kind}.json')
