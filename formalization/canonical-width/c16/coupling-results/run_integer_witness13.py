import json,os,subprocess,sys,time
from pathlib import Path
r=Path('coupling-results');name='integer-witness13';c=json.loads((r/(name+'-derived-command.json')).read_text())['command'];e=os.environ.copy()
for k in ['OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','VECLIB_MAXIMUM_THREADS','MKL_NUM_THREADS']:e[k]='1'
for label,command in [('numeric',c),('exact',[sys.executable,'-u','check_integer_coupling_trial.py','--name',name,'--direct-triples'])]:
 t=time.monotonic()
 with (r/(name+'-controller-'+label+'.log')).open('w') as f:
  try:rc=subprocess.run(command,env=e,stdout=f,stderr=subprocess.STDOUT,timeout=450).returncode
  except subprocess.TimeoutExpired:rc=124
 print(label,rc,time.monotonic()-t,flush=True)
 if rc!=0:break
