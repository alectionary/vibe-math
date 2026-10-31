#!/usr/bin/env python3
"""Hard600-second process-tree cap for the single authorized orbit40 gate."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):os.environ[k]='1'
os.environ['PYTHONDONTWRITEBYTECODE']='1'
import hashlib,json,subprocess,sys,time
from pathlib import Path
import psutil
ROOT=Path(__file__).resolve().parent
PREFIX=ROOT/'two-basis-results/singleton-cg-point22-o40'
def main():
    log=Path(str(PREFIX)+'.supervisor.log');out=Path(str(PREFIX)+'.supervisor.json');assert not log.exists() and not out.exists()
    command=[sys.executable,'-B','singleton_exact_column_gate.py','--initial-manifest','two-basis-results/singleton-archive-point22-o40.json',
             '--initial-receipt','two-basis-results/singleton-archive-point22-o40-independent.json','--prefix',str(PREFIX.relative_to(ROOT))]
    start=time.monotonic()
    with log.open('w') as stream:
        p=subprocess.Popen(command,cwd=ROOT,env=os.environ,stdout=stream,stderr=subprocess.STDOUT);assert psutil.Process(p.pid).nice()==19
        try:code=p.wait(timeout=600)
        except subprocess.TimeoutExpired:
            for child in reversed(psutil.Process(p.pid).children(recursive=True)):
                try:child.kill()
                except psutil.NoSuchProcess:pass
            p.kill();p.wait();code='HARD_TOTAL_600_SECOND_CAP'
    record=dict(status='BOUNDED_SINGLETON_CG_SUPERVISOR_FINISHED',returncode=code,seconds=time.monotonic()-start,
                external_cap_seconds=600,nice=19,threads=1,command=command,
                producer_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
                log_sha256=hashlib.sha256(log.read_bytes()).hexdigest(),no_automatic_retry=True)
    out.write_text(json.dumps(record,indent=2)+'\n');print(json.dumps(record),flush=True)
    if code!=0:sys.exit(1)
if __name__=='__main__':main()
