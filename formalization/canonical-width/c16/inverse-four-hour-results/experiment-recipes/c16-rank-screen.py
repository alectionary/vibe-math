import subprocess,os,json
from pathlib import Path
root=Path('/private/tmp');out=[]
for case in json.load(open(root/'c16-new-three-family-screen.json')):
 f=case['families']
 if f==[0,1,2]:continue
 name=''.join(map(str,f));dest=root/f'c16-new-rank-SDP{name}.json'
 with dest.with_suffix('.log').open('w') as log:
  try:p=subprocess.run(['/private/tmp/c16-venv/bin/python',str(root/'c16-rank-enhanced-sdp.py'),'--families',*map(str,f),'--seconds','75','--rounds','3','--output',str(dest)],stdout=log,stderr=subprocess.STDOUT,timeout=290,env={**os.environ,'OPENBLAS_NUM_THREADS':'1','OMP_NUM_THREADS':'1'});code=p.returncode
  except subprocess.TimeoutExpired:code='OWNED_PROCESS_TIME_LIMIT'
 result=json.loads(dest.read_text()) if dest.exists() else {'families':f,'status':'NO_RESULT'};result['returncode']=code;out.append(result);(root/'c16-new-rank-SDP-three-family-screen.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(result),flush=True)
