#!/usr/bin/env python3
import json,os,pathlib,time
from solve import run
# Affinity bounds the entire process, including solver helper threads, to two CPUs.
if hasattr(os,'sched_getaffinity'):os.sched_setaffinity(0,sorted(os.sched_getaffinity(0))[:2])
out=pathlib.Path(__file__).parent/'outputs';out.mkdir(exist_ok=True)
(out/'tests-passed.json').unlink(missing_ok=True)
tests=[('real','blocks01',43046721),('real','blocks23',0),('planted1','A',1),('planted1','B',1),('planted1','C',1),('real','quarter',0)]
for pools,kind,expected in tests:
    print(f'START test {pools} {kind}',flush=True)
    r=run(pools,kind,7200,out/f'test-{pools}-{kind}.json')
    assert r['status']=='COMPLETE' and r['frames_found']==expected,(pools,kind,'known-answer test failed; real runs prohibited')
(out/'tests-passed.json').write_text(json.dumps({'all_passed':True,'tests':tests,'time_unix':time.time()},indent=2)+'\n')
for kind in ('A','B','C'):
    print(f'START real {kind}',flush=True)
    run('real',kind,7200,out/f'real-{kind}.json')
