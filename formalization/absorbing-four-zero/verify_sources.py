"""Rebuild every listed checked research module from source without changing frozen payloads.

Use --project PATH for an existing pinned Lean/mathlib project. Otherwise run
`lake exe cache get` in the extracted artifact first. Objects/logs go only to
.recheck/. Historical manifests and sources remain byte-for-byte unchanged.
"""
import argparse,datetime,hashlib,json,os,re,subprocess,time
from pathlib import Path
ROOT=Path(__file__).resolve().parent
ALLOWED={'propext','Classical.choice','Quot.sound'}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=ROOT);ap.add_argument('--module-timeout',type=int,default=600);args=ap.parse_args();project=args.project.resolve()
 m=json.loads((ROOT/'verification.json').read_text())
 assert (project/'lean-toolchain').read_text().strip()==m['toolchain']
 deps=json.loads((project/'lake-manifest.json').read_text())
 assert next(p for p in deps['packages'] if p['name']=='mathlib')['rev']==m['mathlib_revision']
 for name,h in m['payload_sha256'].items():assert sha(ROOT/name)==h,('Payload changed',name)
 checked=[]
 for prefix,group in [('prior/first-block','base_lean_modules'),('prior','prior_complex_lean_modules'),('','new_lean_modules')]:
  for r in m[group]:checked.append((prefix,group,r))
 assert len({r['module'] for _,_,r in checked})==len(checked)
 paths=subprocess.check_output(['lake','env','printenv','LEAN_PATH'],cwd=project,text=True).strip()
 lean=subprocess.check_output(['lake','env','which','lean'],cwd=project,text=True).strip()
 build=ROOT/'.recheck';lib=build/'lib';logs=build/'logs';lib.mkdir(parents=True,exist_ok=True);logs.mkdir(exist_ok=True)
 # Only the freshly generated object directory precedes pinned library paths.
 env=dict(os.environ,LEAN_PATH=str(lib)+':'+paths)
 records=[];startall=time.monotonic()
 for prefix,group,row in checked:
  name=row['module'];source=ROOT/prefix/(name+'.lean');before=sha(source)
  assert before==row['source_sha256'],name
  body=source.read_text();assert not re.search(r'\b(?:sorry|admit|native_decide)\b',body),name
  assert not re.search(r'^\s*(?:axiom|constant)\s',body,re.M),name
  command=[lean,'-R',str(source.parent),'-M','6000','-o',str(lib/(name+'.olean')),str(source)]
  started=time.monotonic();logfile=logs/(name+'.log')
  with logfile.open('w') as log:
   try:done=subprocess.run(command,cwd=source.parent,env=env,stdout=log,stderr=subprocess.STDOUT,timeout=args.module_timeout)
   except subprocess.TimeoutExpired:done=subprocess.CompletedProcess(command,124);log.write('\nBounded module check timed out.\n')
  bodylog=logfile.read_text().replace(str(ROOT),'.').replace(str(project),'<pinned-project>');logfile.write_text(bodylog);axioms=set()
  for a in re.findall(r'depends on axioms:\s*\[([^\]]*)\]',bodylog,re.S):axioms.update(x.strip() for x in a.split(',') if x.strip())
  rec=dict(module=name,group=group,source_sha256=before,exit_code=done.returncode,seconds=time.monotonic()-started,
   unchanged_during_check=sha(source)==before,printed_axioms=sorted(axioms),log_sha256=sha(logfile))
  records.append(rec);(build/'results.json').write_text(json.dumps(records,indent=2)+'\n')
  print(name,'exit',done.returncode,'seconds',round(rec['seconds'],2),flush=True)
  assert rec['unchanged_during_check'] and axioms<=ALLOWED and 'sorryAx' not in bodylog
  if done.returncode:print(bodylog[-8000:],flush=True);raise SystemExit(done.returncode)
 for name,h in m['payload_sha256'].items():assert sha(ROOT/name)==h,('Frozen payload mutated',name)
 report=dict(fresh_full_check=True,research_object_imports='Only this run .recheck/lib, plus pinned project dependency paths; no earlier research object paths supplied',toolchain=m['toolchain'],mathlib_revision=m['mathlib_revision'],
  modules=records,total_modules=len(records),total_seconds=time.monotonic()-startall,finished_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),frozen_payload_preserved=True)
 (build/'fresh-recheck.json').write_text(json.dumps(report,indent=2)+'\n');print('Fresh full source rebuild passed:',len(records),'checked modules.',flush=True)
if __name__=='__main__':main()
