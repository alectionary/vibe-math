"""External45-second wall-clock supervisor for each approved30-second pilot."""
from pathlib import Path
import argparse,hashlib,json,os,signal,subprocess,time

ROOT=Path(__file__).resolve().parent.parent
ap=argparse.ArgumentParser();ap.add_argument('--side',choices=['X','Z'],required=True);a=ap.parse_args()
prefix=ROOT/'two-basis-results'/f'two-basis-inner-v2-32x27-{a.side}-point15'
supervisor=Path(str(prefix)+'.supervisor.json');assert not supervisor.exists()
cmd=['/private/tmp/c16-venv/bin/python','-B','two_basis_inner_sector_v2.py','--side',a.side,
     '--X','80','512','--Z','186','433','--point','coupling-results/integer-witness15-rational.json.gz',
     '--lambda-source','two-basis-results/two-basis-structure-zonotope-32x27-point15.lambda.json',
     '--archive-report','two-basis-results/two-sided-full-basis-32x27-wolfe-point15.json',
     '--archive-receipt','two-basis-results/two-sided-full-basis-32x27-endpoint-independent.json',
     '--controls','two-basis-results/two-sided-full-basis-controls-v3-independent.json',
     '--output',str(prefix)+'.json','--seconds','30']
env=os.environ.copy()
for name in ['OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','VECLIB_MAXIMUM_THREADS','MKL_NUM_THREADS']:env[name]='1'
start=time.monotonic()
with Path(str(prefix)+'.log').open('x') as log:
 p=subprocess.Popen(cmd,cwd=ROOT,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
 try:code=p.wait(timeout=45);status='PROCESS_EXITED'
 except subprocess.TimeoutExpired:
  os.killpg(p.pid,signal.SIGKILL);code=p.wait();status='HARD_WALL_CLOCK_CAP_KILLED_PROCESS'
result=dict(status=status,source_C16_answered=False,command=cmd,returncode=code,
            supervisor_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
            driver_sha256=hashlib.sha256((ROOT/'two_basis_inner_sector_v2.py').read_bytes()).hexdigest(),
            requested_solver_gate_seconds=30,external_wall_clock_cap_seconds=45,
            actual_process_seconds=time.monotonic()-start,report_exists=Path(str(prefix)+'.json').exists(),
            frozen_exists=Path(str(prefix)+'.frozen.json').exists(),
            initial_exact_phase_I_state_exists=Path(str(prefix)+'.initial-exact.json').exists())
supervisor.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))
