"""Rebuild the preserved base proofs and the complex bridge from source.

Run with Python >= 3.9 after installing the pinned Lean/mathlib dependencies.
An existing pinned project can be supplied with --project PATH. Research .olean
files are generated locally; none are distributed in the source archive.
"""
import argparse,hashlib,json,os,re,subprocess,sys,time
from pathlib import Path
ROOT=Path(__file__).resolve().parent
ALLOWED={'propext','Classical.choice','Quot.sound'}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 parser=argparse.ArgumentParser(description=__doc__)
 parser.add_argument('--project',type=Path,default=ROOT)
 parser.add_argument('--skip-base',action='store_true',help='For iterative local work only; not a fresh full check.')
 args=parser.parse_args();project=args.project.resolve()
 m=json.loads((ROOT/'verification.json').read_text())
 assert (project/'lean-toolchain').read_text().strip()==m['toolchain']
 dep=json.loads((project/'lake-manifest.json').read_text())
 assert next(p for p in dep['packages'] if p['name']=='mathlib')['rev']==m['mathlib_revision']
 for name,h in m['payload_sha256'].items():assert sha(ROOT/name)==h,('Payload changed',name)
 if not args.skip_base:
  subprocess.run([sys.executable,str(ROOT/'first-block/verify_lean.py'),'--project',str(project)],check=True,cwd=ROOT)
 paths=subprocess.check_output(['lake','env','printenv','LEAN_PATH'],cwd=project,text=True).strip()
 lean=subprocess.check_output(['lake','env','which','lean'],cwd=project,text=True).strip()
 env=dict(os.environ,LEAN_PATH=str(ROOT)+':'+str(ROOT/'first-block')+':'+paths)
 records=[]
 for row in m['new_lean_modules']:
  name=row['module'];source=ROOT/(name+'.lean');before=sha(source)
  assert before==row['source_sha256']
  body=source.read_text()
  assert not re.search(r'\b(?:sorry|admit|native_decide)\b',body)
  assert not re.search(r'^\s*(?:axiom|constant)\s',body,re.M)
  command=[lean,'-R',str(ROOT),'-M','6000','-o',str(source.with_suffix('.olean')),str(source)]
  start=time.monotonic()
  with source.with_suffix('.log').open('w') as log:
   result=subprocess.run(command,cwd=ROOT,env=env,stdout=log,stderr=subprocess.STDOUT)
  log=source.with_suffix('.log').read_text();axioms=set()
  for group in re.findall(r'depends on axioms:\s*\[([^\]]*)\]',log,re.S):
   axioms.update(x.strip() for x in group.split(',') if x.strip())
  rec=dict(module=name,exit_code=result.returncode,seconds=time.monotonic()-start,
    source_sha256=before,unchanged_during_check=sha(source)==before,
    printed_axioms=sorted(axioms),log_sha256=sha(source.with_suffix('.log')))
  records.append(rec)
  (ROOT/'recheck-results.json').write_text(json.dumps(dict(base_rebuilt=not args.skip_base,modules=records),indent=2)+'\n')
  print(name,'exit',result.returncode,'seconds',round(rec['seconds'],2),flush=True)
  assert rec['unchanged_during_check'] and axioms<=ALLOWED and 'sorryAx' not in log
  if result.returncode:print(log[-8000:],flush=True);raise SystemExit(result.returncode)
 if not args.skip_base:
  base=json.loads((ROOT/'first-block/recheck-results.json').read_text())
  assert len(base)==len(m['unchanged_base_lean_modules']) and all(r['exit_code']==0 for r in base)
  records=dict(fresh_full_check=True,toolchain=m['toolchain'],mathlib_revision=m['mathlib_revision'],
    base_modules=base,new_modules=records,finished_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
  (ROOT/'fresh-recheck.json').write_text(json.dumps(records,indent=2)+'\n')
  print('Fresh full source rebuild passed:',len(base)+len(records['new_modules']),'modules.',flush=True)
if __name__=='__main__':main()
