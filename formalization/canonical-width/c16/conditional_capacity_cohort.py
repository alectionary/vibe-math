#!/usr/bin/env python3
"""Bounded two-worker cohort of X-only quotient phase certificates."""
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor,as_completed
import argparse,datetime,gzip,hashlib,json,subprocess,sys,tempfile,time
ROOT=Path(__file__).resolve().parent
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--binary',type=Path,required=True);ap.add_argument('--selected-sector',choices=['X','Z'],default='X');ap.add_argument('--quotient-cohort',type=Path);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=1200);ap.add_argument('--workers',type=int,default=2);a=ap.parse_args();start=time.monotonic();stop=start+a.seconds;a.output.parent.mkdir(exist_ok=True);X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in ['x','z']];records=[];prior_meta={}
 if a.quotient_cohort:
  prior_cohort=json.loads(a.quotient_cohort.read_text());assert prior_cohort['status']=='COMPLETE_GENERATION_REQUIRES_PHYSICAL_REPLAY';prior_meta={r['orbit']:ROOT/r['quotient_metadata_c16_path'] for r in prior_cohort['records']}
 def task(orbit):
  fixed=16*orbit;folder=a.output.parent;profile=folder/f'case-{orbit:02d}.json.gz';meta=folder/f'case-{orbit:02d}-quotient.json';t=time.monotonic()
  if time.monotonic()>=stop:return {'orbit':orbit,'status':'UNRUN_TIME_GATE'}
  reused=a.selected_sector=='X' and fixed in [48,192];prior=ROOT/f'algebraic-results/xonly-{fixed}-rank-profiles.json'
  if reused:
   d=json.loads(prior.read_text());meta=ROOT/f'algebraic-results/xonly-{fixed}-quotient.json';gauge=json.loads(meta.read_text())['dual_gauge_Z_index']
  else:
   gauge=next(j for j,z in enumerate(Z) if (X[fixed]&z).bit_count()%2)
   if orbit in prior_meta:meta=prior_meta[orbit]
   else:subprocess.run([sys.executable,str(ROOT/'anchor_quotient_pools.py'),'--x-only','--anchor',str(fixed),str(gauge),'--output',str(meta)],capture_output=True,text=True,check=True,timeout=15)
   with tempfile.TemporaryDirectory(prefix=f'c16-capacity-{orbit:02d}-') as temp:
    raw=Path(temp)/'profile.json';remaining=max(.1,stop-time.monotonic());coord=json.loads(meta.read_text())['files'];sides=['x','z'] if a.selected_sector=='X' else ['z','x'];cmd=[str(a.binary),str(meta.parent/coord[sides[0]]['file']),str(meta.parent/coord[sides[1]]['file']),str(raw),str(min(180,remaining)),'0','45','127']
    try:run=subprocess.run(cmd,capture_output=True,text=True,timeout=min(190,remaining+5),check=True)
    except subprocess.TimeoutExpired:return {'orbit':orbit,'status':'TIME_LIMIT','elapsed_seconds':time.monotonic()-t}
    d=json.loads(raw.read_text())
  if d['completed_orbits']!=45:return {'orbit':orbit,'status':'INCOMPLETE_NATIVE_COHORT','completed_suborbits':d['completed_orbits']}
  d.update(conditioned_on_X_index=fixed,selected_quotient_sector=a.selected_sector,quotient_metadata_c16_path=str(meta.resolve().relative_to(ROOT)),quotient_metadata_sha256=hashlib.sha256(meta.read_bytes()).hexdigest(),scope='X-only source condition. The Z index in quotient metadata is only a dual-coordinate gauge, not assumed selected. All45 one-orbit negative phase certificates are independently replayable.')
  payload=json.dumps(d,separators=(',',':')).encode();profile.write_bytes(gzip.compress(payload,mtime=0));return {'orbit':orbit,'anchor_X_index':fixed,'selected_quotient_sector':a.selected_sector,'dual_gauge_Z_index':gauge,'status':'GENERATED_REQUIRES_PHYSICAL_REPLAY','certificate_file':profile.name,'certificate_sha256':hashlib.sha256(profile.read_bytes()).hexdigest(),'quotient_metadata_c16_path':str(meta.resolve().relative_to(ROOT)),'reused_initial_pilot':reused,'elapsed_seconds':time.monotonic()-t,'phase_witnesses':sum(len(r['minimal_bad_certificates']) for r in d['records'])}
 with ThreadPoolExecutor(max_workers=a.workers) as pool:
  for f in as_completed([pool.submit(task,o) for o in range(45)]):
   record=f.result();records.append(record);out={'status':'RUNNING','source_C16_answered':False,'cases_total':45,'selected_quotient_sector':a.selected_sector,'records':sorted(records,key=lambda r:r['orbit']),'workers':a.workers,'wall_limit_seconds':a.seconds,'elapsed_seconds':time.monotonic()-start};a.output.write_text(json.dumps(out,indent=2)+'\n');print('CONDITIONAL CAPACITY',len(records),record['orbit'],record['status'],'seconds',round(time.monotonic()-start,2),flush=True)
 out['status']='COMPLETE_GENERATION_REQUIRES_PHYSICAL_REPLAY' if all(r['status']=='GENERATED_REQUIRES_PHYSICAL_REPLAY' for r in records) else 'INCOMPLETE';a.output.write_text(json.dumps(out,indent=2)+'\n')
if __name__=='__main__':main()
