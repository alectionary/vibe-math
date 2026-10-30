from pathlib import Path
import concurrent.futures,datetime,gzip,hashlib,json,os,shutil,subprocess,sys,time
REPO=Path('/private/tmp/c16-coupling-clean-0957');C=REPO/'formalization/canonical-width/c16';O=Path(__file__).resolve().parent;PY='/private/tmp/c16-venv/bin/python';r='coupling-results/'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def load(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def write(n,d):(O/n).write_text(json.dumps(d,indent=2)+'\n')
assert not subprocess.check_output(['git','status','--porcelain'],cwd=REPO)
commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=REPO,text=True).strip();assert commit=='1e852eea43956cbc38759e5182e6f3df9bb782d7'
stages=[];point=r+'integer-witness15-rational.json.gz';checks=r+'integer-witness15-checks-frozen.json'
def add(name,script,args):stages.append((name,[PY,'-u',script,*args,'--output',str(O/(name+'.json'))]))
for n,command in enumerate(load(C/checks)['commands']):
 cmd=command.copy();name='point15-'+['old-replay','unified-exact','projected-exact','basis-exact','global-moment-screen','all-triples','triple-distributions'][n];cmd[cmd.index('--output')+1]=str(O/(name+'.json'))
 if n==0:cmd[cmd.index('--certificate')+1]=str(O/'point15-recovered.json.gz')
 if n==1:cmd[cmd.index('--old-replay')+1]=str(O/'point15-old-replay.json')
 stages.append((name,cmd))
banks=[('raw32-first','verify_full_partner_projection.py','full-partner-projection-wolfe-witness2.json','witness2-rational.json.gz',[]),('raw32-strengthen','verify_full_partner_projection.py','full-partner-projection-wolfe-strengthen-witness2.json','witness2-rational.json.gz',[]),('priced-cap-first','verify_full_partner_orbit_cap_lagrange.py','orbit-cap-price-wolfe-all.json','witness2-rational.json.gz',[]),('priced-cap-strengthen','verify_full_partner_orbit_cap_lagrange.py','orbit-cap-price-wolfe-strengthen0.json','witness2-rational.json.gz',[]),('raw27','verify_full_partner_projection_generic.py','full-partner-orbit27-wolfe-witness5.json','basis-witness5-rational.json.gz',['--orbit','27']),('raw24','verify_full_partner_projection_multi_orbit.py','full-partner-orbit24-wolfe-witness7.json','partner-witness7-rational.json.gz',['--orbit','24']),('anchored1512','verify_anchor_partner_projection.py','anchor-projection-witness8.json.gz','multi-witness8-rational.json.gz',[]),('anchor-drop775','verify_full_partner_projection.py','anchor-projection-witness8-old775-only.json.gz','multi-witness8-rational.json.gz',[]),('native9-raw','verify_full_partner_projection.py','native775-witness9-recovered.json.gz','anchor-witness9-rational.json.gz',[]),('native9-rounded','verify_full_partner_projection.py','native775-witness9-gauge-rounded.json.gz','anchor-witness9-rational.json.gz',[]),('native10-raw','verify_full_partner_projection.py','native775-witness10.json.gz','anchor-witness10-rational.json.gz',[]),('native10-rounded','verify_full_partner_projection.py','native775-witness10-gauge-rounded.json.gz','anchor-witness10-rational.json.gz',[])]
for name,script,bank,p,extra in banks:add(name,script,[('--bank' if name=='anchored1512' or name.startswith('priced') else '--certificate'),r+bank,'--point',r+p,*extra])
add('orbit-cap-source45','verify_orbit_rank_profiles.py',['--certificate','algebraic-results/orbit-rank-profiles.json'])
add('rank-refresh12','verify_weighted_matroid_cuts.py',['--certificate',r+'singleton-rank-refresh-witness12-closed-rank-bank.json'])
for base in ['anchor-witness12','integer-witness13','integer-witness14']:
 add(base+'-integer','verify_physical_integer_forms.py',['--bank',r+base+'-pentagon-bank.json','--point',r+base+'-rational.json.gz'])
 add(base+'-symbolic',str(O/'symbolic_review.py'),['--bank',r+base+'-pentagon-bank.json','--point',r+base+'-rational.json.gz','--receipt',r+base+'-pentagon-independent.json'])
add('unconditional45-basis','verify_unconditional_basis_mixture.py',['--certificate',r+'unconditional-basis-mixture-witness12.json.gz','--point',r+'anchor-witness12-rational.json.gz'])
for tag,version in [('h5','v2'),('h8','v3')]:add('fourX-'+tag,'verify_four_anchor_count_exact.py',['--certificate',r+f'four-anchor-{tag}-count-exact-{version}-witness10.json.gz','--point',r+'anchor-witness10-rational.json.gz'])
for tag,version in [('32x27','v4'),('27x32','v2')]:add('twoXtwoZ-'+tag,'verify_two_sided_count_exact.py',['--certificate',r+f'two-sided-count-{tag}-exact-{version}-witness12.json.gz','--point',r+'anchor-witness12-rational.json.gz'])
add('prefix-model','audit_full_partner_prefix_extension.py',['--prefix',r+'prefix-extension-witness12','--point',r+'anchor-witness12-rational.json.gz'])
D=O/'full-selector';D.mkdir()
for name in ['frozen.json.gz','baseline.cnf.gz','small64.cnf.gz']:shutil.copy2(C/r/'full-selector-case32-pilot'/name,D/name)
stages.append(('full-selector-bridge',[PY,'-u','verify_full_selector_case_bridge.py','--directory',str(D)]))
files={str(p.relative_to(C)) for p in C.glob('*.py')};files|={checks,point,r+'integer-witness15-checks-summary.json',r+'orbit-cap-price-source-profiles-independent.json',r+'prefix-extension-witness12.frozen.json',r+'prefix-extension-witness12.json',r+'prefix-extension-witness12.equalities.npz',r+'prefix-extension-witness12.inequalities.npz',r+'prefix-extension-witness12.rank-rows.json.gz',r+'full-selector-case32-pilot/frozen.json.gz',r+'full-selector-case32-inventory.json'}
for _,cmd in stages:
 for arg in cmd[2:]:
  p=C/arg
  if not Path(arg).is_absolute() and p.is_file():
   files.add(arg)
   for frozen in [p.with_suffix('.frozen.json'),Path(str(p).replace('.json.gz','.frozen.json'))]:
    if frozen.is_file():files.add(str(frozen.relative_to(C)))
pending=list(files);seen=set();declared=[];fields=['source_hashes','input_and_source_hashes','additional_source_hashes','input_hashes','dependencies','pool_sha256','independent_consumer_local_import_closure']
while pending:
 owner=pending.pop()
 if owner in seen:continue
 seen.add(owner)
 if Path(owner).suffix not in ['.json','.gz']:continue
 try:d=load(C/owner)
 except Exception:continue
 if not isinstance(d,dict):continue
 for field in fields:
  if not isinstance(d.get(field),dict):continue
  for name,wanted in d[field].items():
   if not isinstance(wanted,str) or len(wanted)!=64:continue
   p=C/name
   if p.is_file():
    actual=sha(p);declared.append(dict(owner=owner,field=field,input=name,expected=wanted,actual=actual,match=actual==wanted))
    if not Path(name).is_absolute() and name not in files:files.add(name);pending.append(name)
   else:declared.append(dict(owner=owner,field=field,input=name,expected=wanted,actual=None,match=False))
hashes={p:sha(C/p) for p in sorted(files)};write('declared-source-bindings.json',dict(records=declared,mismatches=[d for d in declared if not d['match']]))
write('frozen.json',dict(status='FROZEN_BEFORE_REPLAY',commit=commit,worktree_clean_before=True,utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),commands=stages,input_and_source_hashes=hashes,controller_sha256=sha(__file__),symbolic_wrapper_sha256=sha(O/'symbolic_review.py'),source_C16_answered=False))
print('FROZEN',len(stages),'STAGES',len(hashes),'INPUTS',len(declared),'BINDINGS',len([d for d in declared if not d['match']]),'MISMATCHES',flush=True)
env=os.environ.copy();env.update({k:'1' for k in ['PYTHONDONTWRITEBYTECODE','OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS']});start=time.monotonic();records=[]
def run(stage):
 name,cmd=stage;t=time.monotonic()
 with (O/(name+'.log')).open('w') as log:
  try:code=subprocess.run(cmd,cwd=C,env=env,stdout=log,stderr=subprocess.STDOUT,timeout=300).returncode
  except subprocess.TimeoutExpired:code=None
 p=D/'bridge-controls.json' if name=='full-selector-bridge' else O/(name+'.json');d=load(p) if p.exists() else {};rec=dict(stage=name,returncode=code,status=d.get('status'),seconds=time.monotonic()-t,receipt_sha256=sha(p) if p.exists() else None);print(json.dumps(rec),flush=True);return rec
records.append(run(stages[0]))
identity=dict(status='PASS' if (O/'point15-recovered.json.gz').exists() and sha(O/'point15-recovered.json.gz')==sha(C/point) else 'RECOVERY_NOT_IDENTICAL',saved_point_sha256=sha(C/point),recovered_sha256=sha(O/'point15-recovered.json.gz') if (O/'point15-recovered.json.gz').exists() else None);write('point15-recovery-identity.json',identity)
with concurrent.futures.ThreadPoolExecutor(max_workers=3) as pool:
 for rec in pool.map(run,stages[1:]):records.append(rec)
clean=not subprocess.check_output(['git','status','--porcelain'],cwd=REPO);unchanged=all(sha(C/p)==h for p,h in hashes.items());passed=clean and unchanged and identity['status']=='PASS' and all(x['returncode']==0 and str(x['status']).startswith('PASS') for x in records) and all(d['match'] for d in declared)
summary=dict(status='PASS_DECLARED_REPLAY_SCOPE' if passed else 'REPLAY_FAILURES_PRESERVED',commit=commit,source_C16_answered=False,worktree_clean_before_and_after=clean,all_frozen_inputs_unchanged=unchanged,frozen_inputs=len(hashes),stages=records,seconds=time.monotonic()-start,point_sha256=sha(C/point),frozen_sha256=sha(O/'frozen.json'),recovery_identity=identity,declared_binding_mismatches=[d for d in declared if not d['match']],not_repeated=['Historical source CNF and cover-chain UNSAT proof replay, including original 405 cover derivation.','SAT searches and both full-selector 120-second solver trials; only their exact CNF bridge is replayed.','All 45 singleton numeric trajectories and 27 lattice certificates; the12 accepted new rank cuts are independently replayed.','Global optimization, Wolfe searches, transfer negatives, and partial SAT discovery.','Additional corrupt-input suites beyond controls invoked in listed consumers.']);write('summary.json',summary);print(json.dumps(dict(status=summary['status'],seconds=summary['seconds'],stages=len(records),binding_mismatches=len(summary['declared_binding_mismatches']))),flush=True)
