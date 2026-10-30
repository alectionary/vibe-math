from pathlib import Path
import concurrent.futures,datetime,gzip,hashlib,json,os,subprocess,sys,time
REPO=Path('/private/tmp/c16-coupling-clean-0826'); C=REPO/'formalization/canonical-width/c16'; O=Path(__file__).resolve().parent
PY='/private/tmp/c16-venv/bin/python'
def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def load(p):
 p=Path(p); return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def write(name,data): (O/name).write_text(json.dumps(data,indent=2)+'\n')
assert not subprocess.check_output(['git','status','--porcelain'],cwd=REPO)
commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=REPO,text=True).strip();assert commit.startswith('2e5f314')
r='coupling-results/'; p8=r+'multi-witness8-rational.json.gz'
stages=[]
def add(name,script,args): stages.append((name,[PY,'-u',script,*args,'--output',str(O/(name+'.json'))]))
frozen=load(C/r/'multi-witness8-checks-frozen.json')
for number,command in enumerate(frozen['commands']):
 cmd=command.copy();name='point8-'+['old-replay','unified-exact','projected-exact','basis-exact','global-moment-screen','all-triples','triple-distributions'][number]
 cmd[cmd.index('--output')+1]=str(O/(name+'.json'))
 if number==0:cmd[cmd.index('--certificate')+1]=str(O/'point8-recovered.json.gz')
 if number==1:cmd[cmd.index('--old-replay')+1]=str(O/'point8-old-replay.json')
 stages.append((name,cmd))
for name,bank in [('rank15','full-partner-singleton-anchor15-closed-rank-bank.json'),('rank-batch9','full-partner-singleton-witness8-batch-closed-rank-bank.json'),('rank-tail1','full-partner-singleton-witness8-tail-closed-rank-bank.json')]:add(name,'verify_weighted_matroid_cuts.py',['--certificate',r+bank])
for name,script,bank,point,extra in [
 ('raw32-first','verify_full_partner_projection.py','full-partner-projection-wolfe-witness2.json','witness2-rational.json.gz',[]),
 ('raw32-strengthen','verify_full_partner_projection.py','full-partner-projection-wolfe-strengthen-witness2.json','witness2-rational.json.gz',[]),
 ('raw27','verify_full_partner_projection_generic.py','full-partner-orbit27-wolfe-witness5.json','basis-witness5-rational.json.gz',['--orbit','27']),
 ('raw24','verify_full_partner_projection_multi_orbit.py','full-partner-orbit24-wolfe-witness7.json','partner-witness7-rational.json.gz',['--orbit','24']),
 ('anchored1512','verify_anchor_partner_projection.py','anchor-projection-witness8.json.gz','multi-witness8-rational.json.gz',[]),
 ('anchor-drop775','verify_full_partner_projection.py','anchor-projection-witness8-old775-only.json.gz','multi-witness8-rational.json.gz',[]),
]:add(name,script,[('--bank' if name=='anchored1512' else '--certificate'),r+bank,'--point',r+point,*extra])
add('native-union','verify_full_partner_native.py',[])
add('cover-floor-bridge','cover_case_moment_bridge.py',['--point',p8])
add('word-new-clauses','verify_word_clause_application.py',['--bank',r+'word-clause-application-witness2.json'])
add('word-cover405-static','word_clause_cover_domain_gate.py',[])
# Freeze all directly invoked inputs, all clean Python consumer dependencies,
# and every explicitly declared source hash reachable from JSON inputs.
files={str(p.relative_to(C)) for p in C.glob('*.py')}
files|={'physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','partial-frame-88.json',r+'multi-witness8-checks-frozen.json',r+'multi-witness8-checks-summary.json',r+'native-full-partner-union-accepted.json'}
for _,cmd in stages:
 for a in cmd[2:]:
  if (C/a).is_file():files.add(a)
pending=list(files);seen=set();declared=[]
while pending:
 f=pending.pop()
 if f in seen:continue
 seen.add(f)
 if Path(f).suffix not in ('.json','.gz'):continue
 try:d=load(C/f)
 except Exception:continue
 for field in ['source_hashes','input_and_source_hashes','additional_source_hashes']:
  if isinstance(d,dict) and isinstance(d.get(field),dict):
   for name,expected in d[field].items():
    path=C/name
    if path.is_file():
     actual=sha(path);declared.append({'owner':f,'field':field,'input':name,'expected':expected,'actual':actual,'match':actual==expected})
     if name not in files:files.add(name);pending.append(name)
hashes={f:sha(C/f) for f in sorted(files)}
write('declared-source-bindings.json',{'records':declared,'mismatches':[x for x in declared if not x['match']]})
write('frozen.json',{'status':'FROZEN_BEFORE_REPLAY','commit':commit,'worktree_clean_before':True,'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'commands':stages,'input_and_source_hashes':hashes,'controller_sha256':sha(__file__),'source_C16_answered':False})
env=os.environ.copy();env.update({k:'1' for k in ['PYTHONDONTWRITEBYTECODE','OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS']})
start=time.monotonic();records=[]
def run(stage):
 name,cmd=stage;t=time.monotonic()
 with (O/(name+'.log')).open('w') as log:
  try:code=subprocess.run(cmd,cwd=C,env=env,stdout=log,stderr=subprocess.STDOUT,timeout=300).returncode
  except subprocess.TimeoutExpired:code=None
 path=O/(name+'.json');d=load(path) if path.exists() else {}
 rec={'stage':name,'returncode':code,'status':d.get('status'),'seconds':time.monotonic()-t,'receipt_sha256':sha(path) if path.exists() else None}
 print(json.dumps(rec),flush=True);return rec
# The old-point exact recovery is the only stage dependency.
records.append(run(stages[0]))
if (O/'point8-recovered.json.gz').exists():
 write('point8-recovery-identity.json',{'status':'PASS' if sha(O/'point8-recovered.json.gz')==sha(C/p8) else 'DIFFERENT_EXACT_POINT','saved_point_sha256':sha(C/p8),'recovered_sha256':sha(O/'point8-recovered.json.gz')})
with concurrent.futures.ThreadPoolExecutor(max_workers=3) as pool:
 for rec in pool.map(run,stages[1:]):records.append(rec)
unchanged={f:sha(C/f)==digest for f,digest in hashes.items()};clean=not subprocess.check_output(['git','status','--porcelain'],cwd=REPO)
passed=clean and all(unchanged.values()) and all(x['returncode']==0 and str(x['status']).startswith('PASS') for x in records)
summary={'status':'PASS_DECLARED_REPLAY_SCOPE' if passed else 'REPLAY_FAILURES_PRESERVED','commit':commit,'source_C16_answered':False,'worktree_clean_before_and_after':clean,'all_frozen_inputs_unchanged':all(unchanged.values()),'frozen_inputs':len(hashes),'stages':records,'seconds':time.monotonic()-start,'point_sha256':sha(C/p8),'frozen_sha256':sha(O/'frozen.json'),'declared_binding_mismatches':[x for x in declared if not x['match']],'not_repeated':['Earlier physical source/CNF/cover proof chain; remains an existing dependency.','Broad historical conditional-profile and word-subspace search completeness screens.','All singleton lattice cohorts and original optimization trajectories.','All negative-corruption suites beyond controls invoked by listed consumers.','Orbit-cap priced source supports: point8 exact listed-row replay includes accepted bank receipts, but the full priced-support source consumer is not repeated.','Anchor-witness9 is outside checkpoint2e5f314 and not included.']}
write('summary.json',summary);print(json.dumps({'status':summary['status'],'seconds':summary['seconds'],'stages':len(records),'declared_binding_mismatches':len(summary['declared_binding_mismatches'])}),flush=True)
