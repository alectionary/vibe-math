"""External150-second supervisor for each approved120-second inner pilot."""
from pathlib import Path
import argparse,hashlib,json,os,re,signal,subprocess,time

ROOT=Path(__file__).resolve().parent.parent
ap=argparse.ArgumentParser();ap.add_argument('--side',choices=['X','Z'],required=True)
ap.add_argument('--lambda-source',required=True);ap.add_argument('--label',required=True);a=ap.parse_args()
assert re.fullmatch('[a-z0-9-]+',a.label)
prefix=ROOT/'two-basis-results'/f'two-basis-inner-v3-32x27-{a.side}-{a.label}-point15'
supervisor=Path(str(prefix)+'.supervisor.json');assert not supervisor.exists()
cmd=['/private/tmp/c16-venv/bin/python','-B','two_basis_inner_sector_v3.py','--side',a.side,
     '--X','80','512','--Z','186','433','--point','coupling-results/integer-witness15-rational.json.gz',
     '--lambda-source',a.lambda_source,
     '--archive-report','two-basis-results/two-sided-full-basis-32x27-wolfe-point15.json',
     '--archive-receipt','two-basis-results/two-sided-full-basis-32x27-endpoint-independent.json',
     '--controls','two-basis-results/two-sided-full-basis-controls-v3-independent.json',
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
            driver_sha256=hashlib.sha256((ROOT/'two_basis_inner_sector_v3.py').read_bytes()).hexdigest(),
            requested_solver_gate_seconds=120,external_wall_clock_cap_seconds=150,
            actual_process_seconds=time.monotonic()-start,report_exists=Path(str(prefix)+'.json').exists(),
            frozen_exists=Path(str(prefix)+'.frozen.json').exists(),
            initial_exact_phase_I_state_exists=Path(str(prefix)+'.initial-exact.json').exists(),
            last_feasible_numeric_state_exists=Path(str(prefix)+'.last-feasible.npz').exists(),
            last_feasible_exact_state_exists=Path(str(prefix)+'.last-feasible-exact.json').exists())
supervisor.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))
