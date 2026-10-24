"""Build pinned, hash-checked Lean sources and audit every authored proof.
Rebuild ../absorbing-four-zero first, or supply its previously freshly built,
unchanged sixty-one-source library with --prior-lib. No objects are distributed.
"""
from pathlib import Path
import argparse,concurrent.futures,datetime,hashlib,json,os,re,subprocess,time
ROOT=Path(__file__).resolve().parent
ALLOWED={'propext','Classical.choice','Quot.sound'}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser(description=__doc__)
 ap.add_argument('--project',required=True,type=Path);ap.add_argument('--prior',type=Path,default=ROOT.parent/'absorbing-four-zero')
 ap.add_argument('--prior-lib',type=Path);ap.add_argument('--modules-file',type=Path)
 ap.add_argument('--phase',default='all');ap.add_argument('--workers',type=int,default=2);ap.add_argument('--timeout',type=int,default=1800)
 args=ap.parse_args();prior=args.prior.resolve();project=args.project.resolve();priorlib=(args.prior_lib or prior/'.recheck/lib').resolve()
 m=json.loads((prior/'verification.json').read_text());assert (project/'lean-toolchain').read_text().strip()==m['toolchain']
 deps=json.loads((project/'lake-manifest.json').read_text());assert next(p for p in deps['packages'] if p['name']=='mathlib')['rev']==m['mathlib_revision']
 prior_records=[]
 for prefix,group in [('prior/first-block','base_lean_modules'),('prior','prior_complex_lean_modules'),('','new_lean_modules')]:
  for r in m[group]:
   src=prior/prefix/(r['module']+'.lean');assert sha(src)==r['source_sha256'];assert (priorlib/(r['module']+'.olean')).exists()
   prior_records.append(dict(module=r['module'],source_sha256=sha(src)))
 manifest=json.loads((ROOT/'verification.json').read_text())
 if args.modules_file:
  names=json.loads(args.modules_file.read_text())
 else:
  for name,h in manifest['payload_sha256'].items():assert sha(ROOT/name)==h,name
  assert sha(prior/'verification.json')==manifest['prior_manifest_sha256']
  names=[r['module'] for r in manifest['new_lean_modules']]
  for r in manifest['new_lean_modules']:assert sha(ROOT/(r['module']+'.lean'))==r['source_sha256']
 assert len(names)==len(set(names)) and args.workers>=1
 sources={n:ROOT/(n+'.lean') for n in names};hashes={n:sha(p) for n,p in sources.items()}
 all_local={p.stem for p in ROOT.glob('*.lean') if p.stem!='AuditAll'}
 imports={n:re.findall(r'^import\s+(\S+)',p.read_text(),re.M) for n,p in sources.items()}
 required={n:set(imports[n])&all_local for n in names}
 # Previously fresh dependencies may be reused only with their current phase
 # record and exactly matching source/object hashes. Prototype objects are absent
 # from LEAN_PATH.
 build=ROOT/'.recheck';lib=build/'lib';logs=build/'logs';lib.mkdir(parents=True,exist_ok=True);logs.mkdir(exist_ok=True)
 records_dir=build/'records';records_dir.mkdir(exist_ok=True)
 for n in names:
  s=sources[n].read_text();assert not re.search(r'\b(sorry|admit|native_decide)\b',s);assert not re.search(r'^\s*(axiom|constant)\s',s,re.M)
 external=set().union(*required.values())-set(names)
 for n in external:
  r=json.loads((records_dir/(n+'.json')).read_text())
  assert r['source_sha256']==sha(ROOT/(n+'.lean')) and r['object_sha256']==sha(lib/(n+'.olean')) and r['exit_code']==0
 paths=subprocess.check_output(['lake','env','printenv','LEAN_PATH'],cwd=project,text=True).strip()
 lean=subprocess.check_output(['lake','env','which','lean'],cwd=project,text=True).strip()
 env=dict(os.environ,LEAN_PATH=str(lib)+':'+str(priorlib)+':'+paths)
 def compile_one(n):
  p=sources[n];assert sha(p)==hashes[n];started=time.monotonic();wall=datetime.datetime.now(datetime.timezone.utc).isoformat();log=logs/(n+'.log')
  with log.open('w') as f:r=subprocess.run([lean,'-R',str(ROOT),'-M','6000','-o',str(lib/(n+'.olean')),str(p)],cwd=build,env=env,stdout=f,stderr=subprocess.STDOUT,timeout=args.timeout)
  t=log.read_text().replace(str(ROOT),'.');log.write_text(t)
  ax=set()
  for a in re.findall(r'depends on axioms:\s*\[([^\]]*)\]',t,re.S):ax.update(x.strip() for x in a.split(',') if x.strip())
  assert r.returncode==0 and 'sorryAx' not in t and 'error:' not in t and ax<=ALLOWED,t[-7000:]
  assert sha(p)==hashes[n]
  rec=dict(module=n,source_sha256=hashes[n],object_sha256=sha(lib/(n+'.olean')),exit_code=0,unchanged_during_check=True,printed_axioms=sorted(ax),seconds=time.monotonic()-started,started_utc=wall,log_sha256=sha(log),phase=args.phase)
  (records_dir/(n+'.json')).write_text(json.dumps(rec,indent=2)+'\n');print(n,'passed',flush=True);return rec
 pending=set(names);done=set(external);running={};records=[]
 with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as pool:
  while pending or running:
   ready=sorted(n for n in pending if required[n]<=done)
   for n in ready[:args.workers-len(running)]:running[pool.submit(compile_one,n)]=n;pending.remove(n)
   assert running,'Missing dependency or import cycle: '+str(sorted(pending))
   completed,_=concurrent.futures.wait(running,return_when=concurrent.futures.FIRST_COMPLETED)
   for f in completed:
    n=running.pop(f);records.append(f.result());done.add(n)
 assert all(sha(sources[n])==hashes[n] for n in names)
 out=dict(fresh_new_module_check=True,new_modules=records,prior_checked_sources=prior_records,
  prior_manifest_sha256=sha(prior/'verification.json'),prior_objects='Previously freshly rebuilt from the unchanged sixty-one-source manifest; only the new sources are built in this run.',
  toolchain=m['toolchain'],mathlib_revision=m['mathlib_revision'],phase=args.phase,workers=args.workers,
  finished_utc=datetime.datetime.now(datetime.timezone.utc).isoformat())
 (build/(args.phase+'-fresh-recheck.json')).write_text(json.dumps(out,indent=2)+'\n')
 if args.phase=='all':
  # The checked-in audit names every authored theorem, lemma and named definition.
  # It must import exactly this freshly built mathematical module set.
  decl=json.loads((ROOT/'authored-declarations.json').read_text())
  audit=ROOT/'AuditAll.lean';ah=sha(audit)
  assert set(re.findall(r'^import\s+(\S+)',audit.read_text(),re.M))==set(names)
  log=logs/'AuditAll.log';started=time.monotonic();wall=datetime.datetime.now(datetime.timezone.utc).isoformat()
  with log.open('w') as f:
   result=subprocess.run([lean,'-R',str(ROOT),'-M','6000','-o',str(lib/'AuditAll.olean'),str(audit)],cwd=build,env=env,stdout=f,stderr=subprocess.STDOUT,timeout=args.timeout)
  body=log.read_text().replace(str(ROOT),'.');log.write_text(body);assert result.returncode==0 and 'error:' not in body and 'sorryAx' not in body
  found=dict(re.findall(r"'([^']+)' (?:depends on axioms:\s*(\[[^\]]*\])|does not depend on any axioms)",body,re.S))
  assert {r['name'] for r in decl['declarations']}<=found.keys()
  for name,value in found.items():assert {x.strip() for x in value.strip('[]').split(',') if x.strip()}<=ALLOWED,(name,value)
  assert sha(audit)==ah
  axioms=sorted(set().union(*({x.strip() for x in v.strip('[]').split(',') if x.strip()} for v in found.values())))
  rec=dict(module='AuditAll',source_sha256=ah,object_sha256=sha(lib/'AuditAll.olean'),exit_code=0,unchanged_during_check=True,printed_axioms=axioms,seconds=time.monotonic()-started,started_utc=wall,log_sha256=sha(log),phase=args.phase)
  (records_dir/'AuditAll.json').write_text(json.dumps(rec,indent=2)+'\n')
  (build/'all-axiom-audit.json').write_text(json.dumps(dict(passed=True,named_authored_declarations=len(decl['declarations']),allowed_axioms=axioms),indent=2)+'\n')
  print('PASS: all',len(decl['declarations']),'named authored declarations axiom-audited.',flush=True)

if __name__=='__main__':main()
