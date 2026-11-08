#!/usr/bin/env python3
"""Run with `lake env python3 kernel-only/packed/check.py` after lake build.
Compile in a temporary module directory; report actual Lean exit codes.
"""
import json,os,shutil,subprocess,tempfile,time
from pathlib import Path
ROOT=Path(__file__).resolve().parent
results=[]
with tempfile.TemporaryDirectory(prefix='c16-packed-prototype-') as tmp:
 tmp=Path(tmp);env=dict(os.environ);env['LEAN_PATH']=str(tmp)+os.pathsep+env.get('LEAN_PATH','')
 for module in ['PackedCore','PackedData','RootProbe']:
  shutil.copy2(ROOT/(module+'.lean'),tmp/(module+'.lean'))
  start=time.monotonic()
  try:
   run=subprocess.run(['lean','-j','1','-M','2048','-R',str(tmp),'-o',str(tmp/(module+'.olean')),str(tmp/(module+'.lean'))],env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,timeout=90)
   row=dict(module=module,exit_code=run.returncode,output=run.stdout)
  except subprocess.TimeoutExpired as e:
   row=dict(module=module,exit_code=None,timeout_seconds=90,output=(e.stdout or b'').decode())
  row['wall_seconds']=time.monotonic()-start;results.append(row);print(json.dumps(row),flush=True)
  (ROOT/'validation.json').write_text(json.dumps(results,indent=2)+'\n')
  if row['exit_code']!=0:raise SystemExit(1)
