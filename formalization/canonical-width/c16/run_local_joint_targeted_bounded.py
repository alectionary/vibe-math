#!/usr/bin/env python3
"""External150s supervisor for the authorized fixed local-hull discovery gate."""
from pathlib import Path
import hashlib,json,os,subprocess,sys,time
ROOT=Path(__file__).resolve().parent
PREFIX=ROOT/'two-basis-results/local-joint-targeted-matched-v1'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
    out=Path(str(PREFIX)+'.supervisor.json');assert not out.exists()
    producer=ROOT/'local_joint_targeted_probe.py';before=sha(producer);started=time.monotonic();env=os.environ.copy()
    env.update({k:'1' for k in ['OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','VECLIB_MAXIMUM_THREADS','MKL_NUM_THREADS']});env['PYTHONDONTWRITEBYTECODE']='1'
    with Path(str(PREFIX)+'.log').open('w') as log:
        try:r=subprocess.run([sys.executable,'-u',str(producer)],cwd=ROOT,env=env,stdout=log,stderr=subprocess.STDOUT,timeout=150);code=r.returncode
        except subprocess.TimeoutExpired:code=None
    result=dict(status='BOUNDED_LOCAL_JOINT_DISCOVERY_SUPERVISOR',source_C16_answered=False,producer_sha256=before,producer_unchanged=sha(producer)==before,supervisor_sha256=sha(__file__),returncode=code,external_timeout=code is None,external_seconds=150,elapsed_seconds=time.monotonic()-started)
    resultpath=Path(str(PREFIX)+'.json')
    if resultpath.exists():result['report_sha256']=sha(resultpath);result['reported_status']=json.loads(resultpath.read_text())['status']
    out.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2),flush=True)
if __name__=='__main__':main()
