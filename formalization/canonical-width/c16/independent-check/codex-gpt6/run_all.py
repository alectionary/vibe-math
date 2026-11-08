#!/usr/bin/env python3
"""Reproduce final methods: orbit clique A/quarter, weighted bundles B/C."""
import concurrent.futures,hashlib,json,os,pathlib,time
from solve import BASE,run as count_run
from bundle_backend import run as bundle_run
from orbit_backend import run as orbit_run
HERE=pathlib.Path(__file__).resolve().parent
OUT=HERE/'reproduction-outputs'

def real_run(kind):
    print('START real',kind,flush=True)
    return (orbit_run if kind=='A' else bundle_run)('real',kind,7200,OUT/f'real-{kind}.json')

def main():
    if hasattr(os,'sched_getaffinity'):os.sched_setaffinity(0,sorted(os.sched_getaffinity(0))[:2])
    OUT.mkdir(exist_ok=True);(OUT/'tests-passed.json').unlink(missing_ok=True)
    provenance=json.loads((HERE/'provenance.json').read_text())
    for name,digest in provenance['sha256'].items():
        assert hashlib.sha256((BASE/name).read_bytes()).hexdigest()==digest,name
    for kind,expected in [('blocks01',43046721),('blocks23',0)]:
        print('START test real',kind,flush=True)
        r=count_run('real',kind,7200,OUT/f'test-real-{kind}.json')
        assert r['status']=='COMPLETE' and r['frames_found']==expected
    for kind in ('A','B','C'):
        print('START test planted1',kind,flush=True)
        r=(orbit_run if kind=='A' else bundle_run)('planted1',kind,7200,OUT/f'test-planted1-{kind}.json')
        assert r['status']=='COMPLETE' and r['frames_found']==1
    print('START test real quarter',flush=True)
    r=orbit_run('real','quarter',7200,OUT/'test-real-quarter.json')
    assert r['status']=='COMPLETE' and r['frames_found']==0
    (OUT/'tests-passed.json').write_text(json.dumps({'all_passed':True,'time_unix':time.time(),'backends':{'A':'orbit clique','B':'weighted bundle clique','C':'weighted bundle clique','quarter':'orbit clique','blocks':'exact component polynomial count'}},indent=2)+'\n')
    with concurrent.futures.ProcessPoolExecutor(max_workers=2) as pool:
        list(pool.map(real_run,['A','B','C']))

if __name__=='__main__':main()
