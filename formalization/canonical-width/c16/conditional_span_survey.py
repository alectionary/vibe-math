#!/usr/bin/env python3
"""Bounded exact span survey of the already proved428 sufficient anchors."""
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor,as_completed
import argparse,datetime,json,subprocess,time
ROOT=Path(__file__).resolve().parent

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--binary',type=Path,required=True);ap.add_argument('--seconds',type=float,default=2400);ap.add_argument('--workers',type=int,default=2);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();stop=start+a.seconds;cases=json.loads((ROOT/'theory-loop-results/final-independent.json').read_text())['cases'];folder=a.output.parent/'span-cases';folder.mkdir(exist_ok=True)
 def task(case):
  path=folder/(case['id']+'.json')
  if path.exists():
   try:
    old=json.loads(path.read_text())
    if old['anchor']==[case['X_index'],case['Z_index']] and isinstance(old['target_in_span'],bool):return {'id':case['id'],'status':'FINISHED','reused':True,'target_in_span':old['target_in_span'],'atom_span_rank':old.get('atom_span_rank'),'certificate_file':str(path.relative_to(a.output.parent))}
   except (ValueError,KeyError):pass
  if time.monotonic()>=stop:return {'id':case['id'],'status':'UNRUN_TIME_GATE'}
  path=folder/(case['id']+'.json');t=time.monotonic();cmd=[str(a.binary),str(ROOT/'pools/xcoords.txt'),str(ROOT/'pools/zcoords.txt'),str(case['X_index']),str(case['Z_index']),str(path)]
  try:p=subprocess.run(cmd,capture_output=True,text=True,timeout=min(120,max(.01,stop-time.monotonic())));d=json.loads(path.read_text()) if path.exists() else {};return {'id':case['id'],'returncode':p.returncode,'status':'FINISHED' if p.returncode==0 else 'FAILED','target_in_span':d.get('target_in_span'),'atom_span_rank':d.get('atom_span_rank'),'elapsed_seconds':time.monotonic()-t,'certificate_file':str(path.relative_to(a.output.parent)),'stdout':p.stdout,'stderr':p.stderr}
  except subprocess.TimeoutExpired:return {'id':case['id'],'status':'TIMEOUT','elapsed_seconds':time.monotonic()-t}
 records=[]
 with ThreadPoolExecutor(max_workers=a.workers) as pool:
  for f in as_completed([pool.submit(task,c) for c in cases]):
   records.append(f.result());d={'status':'RUNNING','source_C16_answered':False,'records':records,'cases_total':len(cases),'elapsed_seconds':time.monotonic()-start,'workers':a.workers,'wall_limit_seconds':a.seconds};a.output.write_text(json.dumps(d,indent=2)+'\n')
   if len(records)%8==0:print('SPAN SURVEY',len(records),'positive',sum(r.get('target_in_span') is True for r in records),'negative',sum(r.get('target_in_span') is False for r in records),'seconds',time.monotonic()-start,flush=True)
 d['status']='COMPLETE' if all(r['status']=='FINISHED' for r in records) else 'INCOMPLETE';d['scope']='Full inverse linear equations conditioned on each retained single anchor, without mutual compatibility among free atoms. Positive XOR combinations are not frames; each requires independent physical replay.';a.output.write_text(json.dumps(d,indent=2)+'\n');print(d['status'],len(records),flush=True)
if __name__=='__main__':main()
