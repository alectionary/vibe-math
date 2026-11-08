"""External150-second supervisor for the approved120-second L2 sector pilot."""
from pathlib import Path
import argparse,hashlib,json,os,signal,subprocess,time

ROOT=Path(__file__).resolve().parent.parent
ap=argparse.ArgumentParser();ap.add_argument('--side',choices=['X','Z'],required=True)
ap.add_argument('--initial-receipt',required=True);a=ap.parse_args()
prefix=ROOT/'two-basis-results'/f'two-basis-fixed-lambda-wolfe-32x27-{a.side}-point15'
supervisor=Path(str(prefix)+'.supervisor.json');assert not supervisor.exists()
initial=f'two-basis-results/two-basis-inner-v3-32x27-{a.side}-nearest-point15.last-feasible-exact.json'
cmd=['/private/tmp/c16-venv/bin/python','-B','two_basis_fixed_lambda_wolfe.py',
     '--point','coupling-results/integer-witness15-rational.json.gz','--initial',initial,
     '--initial-receipt',a.initial_receipt,'--controls','two-basis-results/two-sided-full-basis-controls-v3-independent.json',
     '--output',str(prefix)+'.json','--seconds','120']
env=os.environ.copy()
for name in ['OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','VECLIB_MAXIMUM_THREADS','MKL_NUM_THREADS']:env[name]='1'
start=time.monotonic()
with Path(str(prefix)+'.log').open('x') as log:
 p=subprocess.Popen(cmd,cwd=ROOT,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
 try:code=p.wait(timeout=150);status='PROCESS_EXITED'
 except subprocess.TimeoutExpired:
  os.killpg(p.pid,signal.SIGKILL);code=p.wait();status='HARD_WALL_CLOCK_CAP_KILLED_PROCESS'
result=dict(status=status,source_C16_answered=False,command=cmd,returncode=code,
            supervisor_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
            driver_sha256=hashlib.sha256((ROOT/'two_basis_fixed_lambda_wolfe.py').read_bytes()).hexdigest(),
            requested_solver_gate_seconds=120,external_wall_clock_cap_seconds=150,
            actual_process_seconds=time.monotonic()-start,report_exists=Path(str(prefix)+'.json').exists(),
            frozen_exists=Path(str(prefix)+'.frozen.json').exists())
supervisor.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))
