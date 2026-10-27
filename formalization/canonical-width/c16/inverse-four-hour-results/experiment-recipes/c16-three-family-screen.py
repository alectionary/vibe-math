from itertools import combinations
from pathlib import Path
import subprocess,json,os,time
records=[]
for families in combinations(range(5),3):
 name=''.join(map(str,families));out=Path('/private/tmp/c16-new-three-family-'+name+'.json');log=out.with_suffix('.log')
 if name!='034':
  with log.open('w') as f:
   try:proc=subprocess.run(['/private/tmp/c16-venv/bin/python','formalization/canonical-width/c16/rectangular_moment_sdp.py','--families',*map(str,families),'--seconds','90','--output',str(out)],stdout=f,stderr=subprocess.STDOUT,timeout=120,env={**os.environ,'OPENBLAS_NUM_THREADS':'1','OMP_NUM_THREADS':'1','VECLIB_MAXIMUM_THREADS':'1'})
   except subprocess.TimeoutExpired:f.write('OWNED_PROCESS_TIME_LIMIT\n')
 if out.exists():records.append(json.loads(out.read_text()))
 else:records.append({'families':families,'status':'OWNED_PROCESS_TIME_LIMIT_OR_ERROR','source_C16_answered':False})
 Path('/private/tmp/c16-new-three-family-screen.json').write_text(json.dumps(records,indent=2)+'\n');print(json.dumps(records[-1]),flush=True)
