from pathlib import Path
from fractions import Fraction
import ast,concurrent.futures,hashlib,json,os,subprocess,time
REPO=Path('/private/tmp/c16-coupling-clean-043a5bd');C=REPO/'formalization/canonical-width/c16';O=Path(__file__).resolve().parent;PY='/private/tmp/c16-venv/bin/python';D=C/'coupling-results';OLD=D/'final-clean-checkpoint0957'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):return json.loads(Path(p).read_text())
def write(n,d):
 p=O/n;assert not p.exists();p.write_text(json.dumps(d,indent=2)+'\n')
assert not subprocess.check_output(['git','status','--porcelain'],cwd=REPO)
commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=REPO,text=True).strip();assert commit=='043a5bdca1b1691dee56e8ea164d959776729680'
core=read(OLD/'frozen.json');core_checks={p:sha(C/p)==h for p,h in core['input_and_source_hashes'].items()};assert len(core_checks)==689 and all(core_checks.values())
old=read(OLD/'declared-source-bindings.json');aliases=read(OLD/'resolved-source-bindings.json');key=lambda r:(r['owner'],r['field'],r['input']);resolved={key(r['original']):r['resolved_path'] for r in aliases['alias_records']};old_checks=[]
for r in old['records']:
 p=r['input'] if r['match'] else resolved[key(r)];assert sha(C/p)==r['expected'];old_checks.append({'owner':r['owner'],'field':r['field'],'declared_input':r['input'],'resolved_path':p,'sha256':r['expected']})
assert len(old_checks)==1422
joint=read(OLD/'joint-extra-frozen.json');assert all(sha(C/p)==h for p,h in joint['input_and_source_hashes'].items())
assert all(sha(OLD/p)==h for p,h in read(OLD/'inventory.json')['files'].items())
invnames=['singleton-exchange-witness12-inventory.json','singleton-exchange-witness15-inventory.json','singleton-exchange-union17-inventory.json','basis-exchange-repair-proof-review.json','portable-point15-replay1032/inventory.json','two-sided-count-recovery-frozen-inventory.json'];pending=['coupling-results/'+p for p in invnames]+['coupling-results/singleton-exchange-witness15-o40.frozen.json','coupling-results/singleton-exchange-witness12-cohort-supplement.json','coupling-results/exchange-endpoint-audit1021.json'];seen=set();newchecks=[]
while pending:
 owner=pending.pop()
 if owner in seen:continue
 seen.add(owner);obj=read(C/owner)
 mappings=[]
 for field in ['files_sha256','bindings','source_hashes','dependencies','actual_local_import_closure','input_and_source_hashes']:
  if isinstance(obj.get(field),dict):mappings.extend((field,p,h) for p,h in obj[field].items() if isinstance(h,str) and len(h)==64)
 if isinstance(obj.get('files'),list):mappings.extend(('files',r['path'],r['sha256']) for r in obj['files'])
 for field,p,h in mappings:
  assert (C/p).is_file(),(owner,field,p);assert sha(C/p)==h,(owner,field,p);newchecks.append({'owner':owner,'field':field,'path':p,'sha256':h})
  if p.endswith('.json') and p not in seen:pending.append(p)
write('source-bindings.json',{'status':'PASS_INHERITED_CORE_AND_NEW_INVENTORY_BINDINGS','core_inputs':689,'old_resolved_bindings':1422,'additional_joint_bindings':len(joint['input_and_source_hashes']),'new_inventory_bindings':len(newchecks),'core_checks':core_checks,'old_binding_records':old_checks,'additional_joint_input_and_source_hashes':joint['input_and_source_hashes'],'new_binding_records':newchecks,'prior36_stage_summary_sha256':sha(OLD/'accepted-summary.json'),'prior_archive_inventory_sha256':sha(OLD/'inventory.json'),'old_original_scanner_and_resolution_preserved':True})
oldtree=ast.parse((C/'singleton_basis_exchange_repair_lazy.py').read_text());newtree=ast.parse((C/'singleton_basis_exchange_transfer40.py').read_text());cls=lambda tree:next(n for n in tree.body if isinstance(n,ast.ClassDef) and n.name=='ExactRepair');assert ast.dump(cls(oldtree),include_attributes=False)==ast.dump(cls(newtree),include_attributes=False)
transfer=read(D/'singleton-exchange-point15-transfer-controls.json');assert transfer['old_source_sha256']==sha(C/'singleton_basis_exchange_repair_lazy.py') and transfer['new_source_sha256']==sha(C/'singleton_basis_exchange_transfer40.py') and transfer['fresh_target_sha256']==sha(D/'integer-witness15-rational.json.gz')
write('point15-transfer-controls.json',{'status':'PASS_FRESH_AST_EQUIVALENCE_AND_TARGET_BINDING','source_C16_answered':False,'old_source_sha256':transfer['old_source_sha256'],'new_source_sha256':transfer['new_source_sha256'],'class_AST_exactly_equal':True,'fresh_target_sha256':transfer['fresh_target_sha256']})
p12='coupling-results/anchor-witness12-rational.json.gz';p15='coupling-results/integer-witness15-rational.json.gz';steps=[('point12-anchor40-terminal','verify_singleton_exchange_terminal.py',['--certificate','coupling-results/singleton-exchange-witness12-o40.json','--point',p12]),('point12-anchor40-generic','coupling-results/full-partner-singleton-independent-generic.py',['--certificate','coupling-results/singleton-exchange-witness12-o40.json','--point',p12]),('point12-anchor17-state','verify_singleton_exchange_state.py',['--certificate','coupling-results/singleton-exchange-witness12-o17.json','--point',p12]),('point12-anchor17-lazy-state','verify_singleton_exchange_state.py',['--certificate','coupling-results/singleton-exchange-lazy-witness12-o17.json','--point',p12]),('local-lemma','verify_basis_exchange_repair_lemma.py',[]),('multiplicity','verify_basis_exchange_multiplicity_boundary.py',[]),('point15-anchor40-state','verify_singleton_exchange_state.py',['--certificate','coupling-results/singleton-exchange-witness15-o40.json','--point',p15])]
commands=[(n,[PY,'-u',s,*a,'--output',str(O/(n+'.json'))]) for n,s,a in steps];wrapper=[PY,'-u','replay_coupling_point15.py','--output-dir',str(O/'point15'),'--stage-seconds','150'];inputs=set(core['input_and_source_hashes'])|set(joint['input_and_source_hashes'])|{r['resolved_path'] for r in old_checks}|{r['path'] for r in newchecks}|set(seen)|{'replay_coupling_point15.py','verify_singleton_exchange_terminal.py','verify_singleton_exchange_state.py','verify_basis_exchange_repair_lemma.py','verify_basis_exchange_multiplicity_boundary.py','coupling-results/full-partner-singleton-independent-generic.py'}
frozen={p:sha(C/p) for p in sorted(inputs)};write('frozen.json',{'status':'FROZEN_BEFORE_COMMITTED_ENDPOINT_REPLAY','commit':commit,'checkout_clean_before':True,'commands':commands,'portable_wrapper_command':wrapper,'input_and_source_hashes':frozen,'controller_sha256':sha(__file__),'source_C16_answered':False});print('FROZEN',len(frozen),'inputs',len(newchecks),'new bindings',flush=True)
env=os.environ.copy();env.update({k:'1' for k in ['PYTHONDONTWRITEBYTECODE','OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS']});start=time.monotonic()
def run(stage):
 name,cmd=stage;t=time.monotonic()
 with (O/(name+'.log')).open('w') as log:
  try:rc=subprocess.run(cmd,cwd=C,env=env,stdout=log,stderr=subprocess.STDOUT,timeout=180 if name!='portable-point15' else 600).returncode
  except subprocess.TimeoutExpired:rc=None
 receipt=O/'point15/summary.json' if name=='portable-point15' else O/(name+'.json');d=read(receipt) if receipt.exists() else {};r={'stage':name,'returncode':rc,'status':d.get('status'),'seconds':time.monotonic()-t,'receipt_sha256':sha(receipt) if receipt.exists() else None};print(json.dumps(r),flush=True);return r
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
 future=pool.submit(run,('portable-point15',wrapper));records=[run(s) for s in commands];records.append(future.result())
clean=not subprocess.check_output(['git','status','--porcelain'],cwd=REPO);unchanged=all(sha(C/p)==h for p,h in frozen.items());passed=clean and unchanged and all(r['returncode']==0 and str(r['status']).startswith('PASS') for r in records)
portable=read(O/'point15/summary.json');assert len(portable['stages'])==7 and portable['byte_identical_recovery'] and portable['all_inputs_unchanged']
assert read(O/'point12-anchor40-terminal.json')['implicit_full_basis_components']==91776
for name in ['point12-anchor17-state','point12-anchor17-lazy-state','point15-anchor40-state']:
 d=read(O/(name+'.json'));assert not d['exact_target_mixture'] and Fraction(d['exact_positive_error'])>0
summary={'status':'PASS_COMMITTED_CORE_BINDINGS_AND_EXCHANGE_ENDPOINTS' if passed else 'FAILURE_PRESERVED','commit':commit,'source_C16_answered':False,'physical_full_frame':False,'source_cover':405,'checkout_clean_before_and_after':clean,'all_frozen_inputs_unchanged':unchanged,'frozen_input_count':len(frozen),'old_scientific_core_stages_inherited':36,'old_scientific_core_inputs_rechecked':689,'old_resolved_bindings_rechecked':1422,'additional_joint_bindings_rechecked':4,'new_inventory_bindings_rechecked':len(newchecks),'fresh_exchange_consumer_stages':7,'fresh_point15_wrapper_stages':7,'fresh_total_consumer_stages':14,'byte_identical_point15_recovery':True,'point12_anchor40':'Exact singleton conditional full-basis marginal membership','point12_anchor17':'Two valid exact partial mixtures; both nonzero residual and inconclusive','point15_anchor40':'Valid exact partial mixture; nonzero residual and inconclusive','fixed_union17':'UNKNOWN numeric result bound by inventory; no feasibility or infeasibility credit','stages':records,'seconds':time.monotonic()-start,'frozen_sha256':sha(O/'frozen.json'),'source_bindings_sha256':sha(O/'source-bindings.json'),'portable_summary_sha256':sha(O/'point15/summary.json'),'inherited_accepted_summary_sha256':sha(OLD/'accepted-summary.json'),'not_repeated':['The inherited36 scientific core stages were not all rerun; every689 input,1422 resolved declaration and4 additional-joint bindings remain byte-identical. Point15 seven acceptance stages were rerun.','Historical source CNF/cover-chain proof replay and all SAT searches remain omitted.','No exchange search, fixed-column LP search, numeric discovery trajectory or additional source theorem search was rerun.','The newer uncommitted saved-span affine diagnostic is outside checkpoint043a5bd and excluded here.']};write('summary.json',summary);print(json.dumps({'status':summary['status'],'fresh_stages':14,'seconds':summary['seconds']}),flush=True)
