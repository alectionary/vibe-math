#!/usr/bin/env python3
"""Pipeline independent physical replay of a bounded conditional cohort."""
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
import argparse,hashlib,json,subprocess,sys,time
ROOT=Path(__file__).resolve().parent
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--cohort',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=1500);ap.add_argument('--workers',type=int,default=2);a=ap.parse_args();start=time.monotonic();stop=start+a.seconds;folder=a.output.parent;seen=set();pending={};records=[];producer=None
 def task(record):
  o=record['orbit'];sector=record.get('selected_quotient_sector','X');assert sector in ['X','Z']
  if time.monotonic()>=stop:return {'orbit':o,'status':'UNRUN_REPLAY_TIME_GATE'}
  cert=a.cohort.parent/record['certificate_file'];assert hashlib.sha256(cert.read_bytes()).hexdigest()==record['certificate_sha256'];meta=ROOT/record['quotient_metadata_c16_path'];out=folder/f'case-{o:02d}-independent.json';cmd=[sys.executable,str(ROOT/'verify_orbit_rank_profiles.py'),'--certificate',str(cert),'--quotient-metadata',str(meta),'--output',str(out)];t=time.monotonic()
  try:
   run=subprocess.run(cmd,capture_output=True,text=True,timeout=min(180,max(.1,stop-time.monotonic())));(folder/f'case-{o:02d}-replay.log').write_text(run.stdout+run.stderr)
   if run.returncode:return {'orbit':o,'status':'REPLAY_FAILED','returncode':run.returncode}
   result=json.loads(out.read_text());assert result['status']=='PASS' and result['conditioned_on_X_index']==16*o and result['certificate_sha256']==record['certificate_sha256'] and result.get('selected_quotient_sector','X')==sector;rows=sorted(result['records'],key=lambda r:r['orbit']);assert [r['orbit'] for r in rows]==list(range(45));return {'orbit':o,'anchor_X_index':16*o,'selected_quotient_sector':sector,'status':'PASS','report_file':out.name,'report_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'certificate_file':record['certificate_file'],'certificate_sha256':record['certificate_sha256'],'bounds':[r['full_frame_count_upper_bound']+int(sector=='X' and r['orbit']==o) for r in rows],'elapsed_seconds':time.monotonic()-t}
  except subprocess.TimeoutExpired:return {'orbit':o,'status':'REPLAY_TIME_LIMIT'}
 with ThreadPoolExecutor(max_workers=a.workers) as pool:
  while time.monotonic()-start<a.seconds:
   try:producer=json.loads(a.cohort.read_text())
   except (FileNotFoundError,json.JSONDecodeError):time.sleep(1);continue
   for record in producer['records']:
    o=record['orbit']
    if o not in seen and record['status']=='GENERATED_REQUIRES_PHYSICAL_REPLAY':pending[pool.submit(task,record)]=o;seen.add(o)
   done=[f for f in pending if f.done()]
   for f in done:
    r=f.result();records.append(r);del pending[f];print('PHYSICAL CAPACITY CASE',len(records),r['orbit'],r['status'],'seconds',round(time.monotonic()-start,2),flush=True)
   result={'status':'RUNNING','source_C16_answered':False,'cases_total':45,'records':sorted(records,key=lambda r:r['orbit']),'elapsed_seconds':time.monotonic()-start,'workers':a.workers};a.output.write_text(json.dumps(result,indent=2)+'\n')
   if producer['status']!='RUNNING' and not pending:break
   time.sleep(1)
  # Every already-submitted bounded child is awaited by the executor context.
  for f,o in list(pending.items()):records.append(f.result())
 result={'status':'PASS' if len(records)==45 and all(r['status']=='PASS' for r in records) else 'INCOMPLETE_OR_FAILED','source_C16_answered':False,'cases_total':45,'records':sorted(records,key=lambda r:r['orbit']),'elapsed_seconds':time.monotonic()-start,'workers':a.workers,'scope':'Independent physical replay of all retained phase witnesses and monotone upper-bound coverage, separately in each X-only quotient. These are conditional capacity bounds, not completed full-frame cases.'}
 result['selected_quotient_sector']=producer.get('selected_quotient_sector','X') if producer else None
 if result['status']=='PASS':
  assert all(r['selected_quotient_sector']==result['selected_quotient_sector'] for r in records)
  result['capacity_matrix']=[r['bounds'] for r in result['records']]
 a.output.write_text(json.dumps(result,indent=2)+'\n');print(result['status'],'cases',len(records),flush=True)
if __name__=='__main__':main()
