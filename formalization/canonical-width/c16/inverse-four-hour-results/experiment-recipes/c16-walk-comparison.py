from pathlib import Path
import subprocess,json
records=[]
for seed in [20261027,20261028]:
 for name,sec,thin in [('hits_only',0,0),('three_thin',0,3),('three_thin_shortword',1,3)]:
  prefix=Path(f'/private/tmp/c16-new-walk-{seed}-{name}');args=['/private/tmp/c16-inverse-basis-walk','formalization/canonical-width/c16/pools/xcoords.txt','formalization/canonical-width/c16/pools/zcoords.txt','/private/tmp/c16-new-inverse-basis-start.txt','/private/tmp/c16-new-X-thin-labels.txt',str(prefix),'300',str(seed),str(sec),str(thin),'200000']
  with prefix.with_suffix('.log').open('w') as f:
   try:r=subprocess.run(args,stdout=f,stderr=subprocess.STDOUT,timeout=315);code=r.returncode
   except subprocess.TimeoutExpired:code=-15;f.write('OWNED_PROCESS_TIME_LIMIT\n')
  summary=prefix.with_suffix('.summary.json');d=json.loads(summary.read_text()) if summary.exists() else {'status':'PROCESS_TIME_LIMIT_OR_ERROR'};d.update(mode=name,seed=seed,returncode=code,prefix=str(prefix));records.append(d);Path('/private/tmp/c16-new-walk-comparison.json').write_text(json.dumps(records,indent=2)+'\n');print(json.dumps(d),flush=True)
