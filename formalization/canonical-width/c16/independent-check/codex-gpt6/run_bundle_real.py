#!/usr/bin/env python3
"""Recorded portfolio continuation; the clean reproduction driver is separate."""
import hashlib,json,os,pathlib,time
from solve import BASE,read,check
from bundle_backend import run
HERE=pathlib.Path(__file__).resolve().parent
if hasattr(os,'sched_getaffinity'):os.sched_setaffinity(0,sorted(os.sched_getaffinity(0))[:2])
out=HERE/'bundle-outputs';out.mkdir(exist_ok=True);(out/'tests-passed.json').unlink(missing_ok=True)
provenance=json.loads((HERE/'provenance.json').read_text())
for name,digest in provenance['sha256'].items():assert hashlib.sha256((BASE/name).read_bytes()).hexdigest()==digest
expected={'test-real-blocks01':43046721,'test-real-blocks23':0,'test-planted1-A':1,'test-planted1-B':1,'test-planted1-C':1,'test-real-quarter':0}
for name,n in expected.items():
    r=json.loads((HERE/'final-outputs'/f'{name}.json').read_text());assert r['status']=='COMPLETE' and r['frames_found']==n
    if r['frame'] is not None:
        x,z=read(r['pools']);check(x,z,r['frame'],r['class'],32 if r['class'].startswith('blocks') else 128)
for kind in ('B','C'):
    r=run('planted1',kind,7200,out/f'test-planted1-{kind}.json');assert r['status']=='COMPLETE' and r['frames_found']==1
assert json.loads((HERE/'bundle-unit-tests.json').read_text())['status']=='PASS'
(out/'tests-passed.json').write_text(json.dumps({'all_passed':True,'time_unix':time.time(),'inherited_gate':'../final-outputs/tests-passed.json','rerun_planted':['B','C'],'source_sha256':{f:hashlib.sha256((HERE/f).read_bytes()).hexdigest() for f in ['bundle_backend.py','bundle_clique.cpp']}},indent=2)+'\n')
original=json.loads((HERE/'final-outputs/tests-passed.json').read_text())['time_unix']
remaining=max(.001,7200-(time.time()-original))
print('START real B; remaining original budget',remaining,flush=True)
run('real','B',remaining,out/'real-B.json')
print('START real C',flush=True)
run('real','C',7200,out/'real-C.json')
