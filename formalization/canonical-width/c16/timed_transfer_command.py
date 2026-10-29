#!/usr/bin/env python3
"""Measure one frozen call without the sandbox-incompatible macOS time -l."""
from pathlib import Path
import datetime,json,resource,subprocess,sys,time
ROOT=Path(__file__).resolve().parent
if __name__=='__main__':
    out=ROOT/'transfer-results'; f=json.loads((out/'comparison-frozen.json').read_text()); t=f['trials'][int(sys.argv[1])]
    started=datetime.datetime.now(datetime.timezone.utc).isoformat(); began=time.monotonic()
    with (out/(t['name']+'.log')).open('w') as stream:
        r=subprocess.run(t['command'],cwd=ROOT,stdout=stream,stderr=subprocess.STDOUT,timeout=1020)
    usage=resource.getrusage(resource.RUSAGE_CHILDREN)
    record={'started_utc':started,'elapsed_seconds':time.monotonic()-began,'returncode':r.returncode,
            'maximum_resident_set_size_bytes':usage.ru_maxrss,'user_seconds':usage.ru_utime,'system_seconds':usage.ru_stime,
            'measurement':'Fresh helper process per trial; macOS resource.getrusage(RUSAGE_CHILDREN). ru_maxrss in bytes.'}
    (out/(t['name']+'-timing.json')).write_text(json.dumps(record,indent=2)+'\n')
    sys.exit(r.returncode)
