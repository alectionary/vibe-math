from pathlib import Path
import subprocess,os,time,json
root=Path('/private/tmp');start=time.monotonic()
with (root/'c16-new-all-owner-indirect.log').open('w') as log:
 p=subprocess.Popen(['/private/tmp/c16-venv/bin/python',str(root/'c16-all-owner-indirect.py')],stdout=log,stderr=subprocess.STDOUT,env={**os.environ,'OPENBLAS_NUM_THREADS':'1','OMP_NUM_THREADS':'1'})
 try:p.wait(timeout=600)
 except subprocess.TimeoutExpired:
  p.terminate()
  try:p.wait(timeout=3)
  except subprocess.TimeoutExpired:p.kill();p.wait()
  r={'status':'OWNED_PROCESS_TIME_LIMIT','source_C16_answered':False,'exact_certificate':False,'outer_wall_limit_seconds':600};(root/'c16-new-all-owner-indirect-SDP.json').write_text(json.dumps(r,indent=2)+'\n')
print(json.dumps({'returncode':p.returncode,'seconds':time.monotonic()-start}),flush=True)
