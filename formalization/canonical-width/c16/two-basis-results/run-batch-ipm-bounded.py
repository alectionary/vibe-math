"""External150-second cap for the single approved120-second X-sector IPM."""
from pathlib import Path
import hashlib,json,os,signal,subprocess,time
ROOT=Path(__file__).resolve().parent.parent
prefix=ROOT/'two-basis-results'/'two-basis-batch-ipm-X-nearest-point15'
supervisor=Path(str(prefix)+'.supervisor.json');assert not supervisor.exists()
cmd=['/private/tmp/c16-venv/bin/python','-B','two_basis_batch_ipm.py','--output',str(prefix)+'.json']
env=os.environ.copy()
for name in ['OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','VECLIB_MAXIMUM_THREADS','MKL_NUM_THREADS']:env[name]='1'
start=time.monotonic()
with Path(str(prefix)+'.log').open('x') as log:
 p=subprocess.Popen(cmd,cwd=ROOT,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
 try:code=p.wait(timeout=150);status='PROCESS_EXITED'
 except subprocess.TimeoutExpired:
  os.killpg(p.pid,signal.SIGKILL);code=p.wait();status='HARD_WALL_CLOCK_CAP_KILLED_PROCESS'
out=dict(status=status,source_C16_answered=False,command=cmd,returncode=code,
 supervisor_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
 driver_sha256=hashlib.sha256((ROOT/'two_basis_batch_ipm.py').read_bytes()).hexdigest(),
 requested_solver_seconds=120,external_wall_clock_cap_seconds=150,actual_process_seconds=time.monotonic()-start,
 report_exists=Path(str(prefix)+'.json').exists(),strict_initial_witness_exists=Path(str(prefix)+'.initial-exact.json').exists(),
 matrix_data_exists=Path(str(prefix)+'.lp-data.npz').exists())
supervisor.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out))
