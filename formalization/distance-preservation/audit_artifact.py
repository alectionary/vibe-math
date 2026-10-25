"""Build a source-bound verification manifest from successful Lean records.

This checks reproducibility bookkeeping; it does not replace Lean or independently
establish the semantic match to the cited paper. See SOURCE-TO-PROOF.txt.
"""
from pathlib import Path
import datetime,hashlib,json,re,subprocess
R=Path(__file__).resolve().parent
MODULES='BinaryWords ClassicalEnum11 Source11 ClassicalDistance11 QuantumRows11 QuantumWitness11 CSS11 VoltageCycles Hypotheses11 Counterexample11 FamilyRing ParametricRing FamilyWords SmallStopping TannerSix FamilyEnum11 FamilySource11 FamilyDistance11 FamilyStopping11 CoverWeight CyclicCover CoverDistance FamilyBaseGraph FamilyDotRows11 BinaryFinite FamilyNoShort FamilyGirth FamilyTreeStopping FamilyBaseDistance FamilyTheorem ClassicalUpper20 FamilyCoverAlternative SourceModel SourceSectors SourceCoordinates SourceDistance SourceWordBridge SourceSymmetry GeneralLP ParametricWords GeneralLPPhysical ParametricSource ParametricProjection ParametricSpecialization FamilyTranspose TransposeConstant TransposeDistance FamilyBounds FamilyConnected FinalAudit'.split()
HEADLINES={
 'Source11.diagnostic_refuted':'Concrete Lean certificate: original finite counterexample, dC=12 and dQ<=11.',
 'DistanceFamily.infinite_counterfamily':'General Lean proof: all positive L divisible by11, no4/6 voltage, no RCPC, dQ<=11<12<=dC.',
 'SourceDistance.source_counterfamily':'General Lean proof: actual coefficient matrices and arbitrary stabilizer row span.',
 'SourceWordBridge.source_distance_drop':'General Lean proof: distances minimize over all actual source words and both full stabilizer spans.',
 'DistanceFamily.stronger_counterfamily':'General Lean proof: transpose-code distance cannot explain away the mixed logical.',
 'FamilyGirth.exact_eight_certificate':'General Lean certificate: no4/6 voltage and explicit distinct8-cycle vertices, with edges checked separately.',
 'ParametricWords.source_parametric_obstruction':'General Lean proof: every positive cyclic L and all parameters a,b give an actual nontrivial source logical of weight<=11 for the explicit template.',
 'ParametricProjection.projected_counterfamily':'General Lean proof: additive projection sending(a,b) to(1,5) preserves the classical lower bound and the girth/RCPC exclusions.',
 'FamilyConnected.connected':'General Lean proof: actual classical Tanner graph connected for every positive L.',
 'ClassicalUpper20.classical_distance_upper':'General Lean proof: the fixed family has a nonzero classical codeword of weight<=20 for every positive L divisible by11.',
 'FamilyTranspose.distance_characterization':'General Lean proof: every nonzero transpose codeword has weight2L.'}
ALLOWED={'propext','Classical.choice','Quot.sound'}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 records=[]
 for name in MODULES:
  src=R/(name+'.lean');log=R/'logs'/(name+'.log');rec=json.loads((R/'logs'/(name+'.json')).read_text())
  assert rec['exit_code']==0 and not rec['unexpected_axiom_or_error'],name
  assert rec['source_sha256']==sha(src),('changed source',name)
  assert rec['log_sha256']==sha(log),('changed log',name)
  body=log.read_text();assert 'sorryAx' not in body and 'error:' not in body and '_native.' not in body,name
  for group in re.findall(r'depends on axioms: \[([^]]*)\]',body):
   found={x.strip() for x in group.split(',') if x.strip()}
   assert found<=ALLOWED,(name,found-ALLOWED)
  records.append(rec)
 final=(R/'logs/FinalAudit.log').read_text()
 for name in HEADLINES:
  assert "'"+name+"' depends on axioms:" in final,name
  assert name in final,name
 # Each local research import in the admitted modules must also be admitted.
 for name in MODULES:
  for dep in re.findall(r'^import ([A-Za-z0-9_]+)\s*$',(R/(name+'.lean')).read_text(),re.M):
   if (R/(dep+'.lean')).exists():assert dep in MODULES,(name,dep)
 data=json.loads((R/'independent-family-verification.json').read_text())
 assert [(x['L'],x['classical']['distance'],x['quantum_logical_weight']) for x in data['instances']]==[(11,12,11),(22,18,11)]
 assert all(x['augmented_rank_X']==x['rank_X']+1 for x in data['instances'])
 excluded=[{'path':'CircuitSearch.lean','reason':'Generic circuit-search lemma not instantiated for quantum lower bounds.'},{'path':'ClassicalSat11.lean','reason':'Prototype native bv_decide proof; excluded native axiom.'},{'path':'DotTest.lean','reason':'Development test.'},{'path':'EncodeTest.lean','reason':'Development test.'},{'path':'RowTest.lean','reason':'Development test.'},{'path':'sources/QuantumWitness11-monolithic.lean','reason':'Superseded development proof.'}]
 inputs=['PROTOCOL.txt','RESEARCH-NOTE.txt','SOURCE-TO-PROOF.txt','prior-art.json','independent_verify.py','independent_family.py','independent-family-verification.json','independent-verification.json','family-regression.json','transpose-regression.json','research.py','classify_bases.py','support_search.cpp','run_search.py','build_lean.py','audit_artifact.py']
 data_files=list(R.glob('*.json'))+list(R.glob('*.jsonl'))+list((R/'inputs').glob('*.txt'))
 data_files=[p for p in data_files if p.name not in ['verification.json','.lean-runtime.json']]
 evidence_files={R/f for f in inputs}|set(data_files)|set(R.glob('*.py'))|{p for p in R.glob('*.txt') if p.name!='SESSION-STATE.txt'}
 artifact_hashes={str(p.relative_to(R)):sha(p) for p in sorted(evidence_files)}
 repair=json.loads((R/'search-repair.json').read_text())
 assert repair['status']=='PASS_REPLAYED'
 assert sha(R/repair['previous_manifest_snapshot'])==repair['previous_manifest_sha256']
 assert sha(R/repair['archived_source_path'])==repair['old_source_sha256']
 for archived in [repair['previous_manifest_snapshot'],repair['archived_source_path']]:artifact_hashes[archived]=sha(R/archived)
 regression=json.loads((R/'search-regression-tests.json').read_text())
 assert regression['status']=='PASS' and regression['cpp_sha256']==sha(R/'support_search.cpp')
 assert regression['old_binary_regression']['witness']==[] and regression['regression']['witness']==[0,1]
 matrix_check=json.loads((R/'frozen-matrix-crosschecks.json').read_text())
 assert matrix_check['status']=='PASS' and matrix_check['instances']==104
 assert matrix_check['frozen_input_sha256']==sha(R/'fresh-candidates.json')
 degenerate=json.loads((R/'independent-degenerate.json').read_text())
 assert degenerate['status']=='PASS' and degenerate['parameter_pairs']==285
 catalog=json.loads((R/'pattern-certificate-verification.json').read_text())
 assert catalog['status']=='PASS' and catalog['cases']==144
 assert catalog['catalog_sha256']==sha(R/'permutation-patterns.json')
 assert json.loads((R/'low-weight-sharpness.json').read_text())['status']=='PASS'
 previous=json.loads((R/repair['previous_manifest_snapshot']).read_text())
 for path,h in previous['artifact_sha256'].items():
  if path.startswith('inputs/'):assert sha(R/path)==h,('Frozen search input changed',path)
 fresh=[json.loads(s) for s in (R/'fresh-corrected-results.jsonl').read_text().splitlines()]
 original=[json.loads(s) for s in (R/'fresh-results.jsonl').read_text().splitlines()]
 assert len(fresh)==len(original)==104
 for x,y in zip(original,fresh):
  assert (x['id'],x['E'],x['L'],x['classical'],x['transpose'])==(y['id'],y['E'],y['L'],y['classical'],y['transpose'])
  assert (x['search']['bound'],x['search']['node_limit'])==(y['search']['bound'],y['search']['node_limit'])
 replayed_input_hashes=set()
 for path in ['fresh-corrected-results.jsonl','search-results-corrected.json','search-through-ten-corrected.json','exhaustive-representative-search-corrected.json','witness-L11-bound9-corrected.json','witness-L11-bound10-corrected.json','witness-L11-bound11-corrected.json','intermediate-corrected.json']:
  if path.endswith('.jsonl'):xs=[json.loads(s)['search'] for s in (R/path).read_text().splitlines()]
  else:
   xs=json.loads((R/path).read_text());xs=xs if isinstance(xs,list) else [xs['search']]
  for x in xs:
   assert sha(R/x['input_file'])==x['input_sha256']
   replayed_input_hashes.add(x['input_sha256'])
 assert all(h in replayed_input_hashes for path,h in previous['artifact_sha256'].items() if path.startswith('inputs/'))
 sat_audit={'status':'running_or_not_recorded','record':'sat-crosscheck.json'}
 if (R/'sat-crosscheck.json').exists():
  sat=json.loads((R/'sat-crosscheck.json').read_text());sat_audit={'status':sat['bounded_search']['status'],'record':'sat-crosscheck.json','scope':sat['scope']}
  assert sat['known_upper_sanity']['status']=='SAT'
  for p in list((R/'sat-inputs').glob('*.cnf'))+list((R/'sat-logs').glob('*.log')):
   artifact_hashes[str(p.relative_to(R))]=sha(p)
  for result in [sat['known_upper_sanity'],sat['bounded_search']]:
   assert result['cnf_sha256']==sha(R/'sat-inputs'/(result['name']+'.cnf'))
   assert result['log_sha256']==sha(R/'sat-logs'/(result['name']+'.log'))
 auxiliaries=[]
 for aux_path in [R/'auxiliary-verification.json',R/'auxiliary-fixed-columns-verification.json']:
  if not aux_path.exists():continue
  aux=json.loads(aux_path.read_text());auxiliaries.append(aux)
  assert aux['status']=='PASS' and aux['exit_code']==0 and not aux['unexpected_axiom_or_error']
  assert aux['source_sha256']==sha(R/(aux['module']+'.lean'))
  assert aux['isolated_log_sha256']==sha(R/aux['isolated_log'])
  main_aux=json.loads((R/aux['main_build_record']).read_text())
  assert main_aux['exit_code']==0 and not main_aux['unexpected_axiom_or_error']
  assert main_aux['source_sha256']==aux['source_sha256']
  assert main_aux['log_sha256']==sha(R/'logs'/(aux['module']+'.log'))
  for dep,h in aux['authored_dependency_sources'].items():assert dep in MODULES and sha(R/(dep+'.lean'))==h
  for path in [R/aux['isolated_log'],R/(aux['module']+'.lean'),R/aux['main_build_record'],R/'logs'/(aux['module']+'.log')]:
   artifact_hashes[str(path.relative_to(R))]=sha(path)
  for path in [R/aux['isolated_log'],R/'logs'/(aux['module']+'.log')]:
   body=path.read_text();assert not any(s in body for s in ['sorryAx','error:','_native.'])
   for group in re.findall(r'depends on axioms: \[([^]]*)\]',body):
    assert {x.strip() for x in group.split(',') if x.strip()}<=ALLOWED
 runtime=json.loads((R/'.lean-runtime.json').read_text())
 lean_version=subprocess.check_output([runtime['lean'],'--version'],text=True).strip()
 roots={Path(v).parents[3] for v in runtime['LEAN_PATH'].split(':') if v.endswith('/.lake/build/lib/lean') and (Path(v).parents[3]/'Mathlib').is_dir()}
 assert len(roots)==1,roots
 mathlib_root=next(iter(roots))
 actual_commit=subprocess.check_output(['git','-C',str(mathlib_root),'rev-parse','HEAD'],text=True).strip()
 assert actual_commit=='5f7b4198d22a9c82e1c698a379334fe128095c82'
 tracked_changes=subprocess.check_output(['git','-C',str(mathlib_root),'diff','HEAD','--name-only'],text=True).splitlines()
 assert not tracked_changes,tracked_changes
 environment={'lean_version':lean_version,'mathlib_checkout_commit':actual_commit,'mathlib_tracked_changes':tracked_changes,
              'mathlib_lake_manifest_sha256':sha(mathlib_root/'lake-manifest.json'),
              'dependency_spec_sha256':sha(R.parent/'dyadic-rank/lakefile.toml'),
              'toolchain_spec_sha256':sha(R.parent/'dyadic-rank/lean-toolchain')}
 isolated={'status':'not_recorded_yet','record':'clean-rebuild.json'}
 if (R/'clean-rebuild.json').exists():
  clean=json.loads((R/'clean-rebuild.json').read_text());isolated={'status':clean['status'],'record':'clean-rebuild.json','scope':clean['scope']}
  if clean['status']=='PASS':
   assert clean['completed']==clean['total']==len(MODULES)
   assert clean['source_sha256']=={m:sha(R/(m+'.lean')) for m in MODULES}
   for rec in clean['records']:
    assert rec['exit_code']==0 and not rec['unexpected_axiom_or_error']
    assert rec['log_sha256']==sha(R/'clean-rebuild-logs'/(rec['module']+'.log'))
  else:assert clean['status']=='TIME_LIMIT',('Investigate isolated rebuild failure',clean.get('reason'))
 manifest={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'canonical_target_id':'L-F25-distance-preservation','canonical_completion_delta':0,
 'scope':'Our proposed criterion refuted. Source sufficient-condition problem remains open in this project.',
 'lean_toolchain':'leanprover/lean4:v4.36.0-rc1','mathlib_commit':'5f7b4198d22a9c82e1c698a379334fe128095c82',
 'build_environment':environment,'isolated_authored_source_rebuild':isolated,'separate_auxiliary_lean_proofs':auxiliaries,
 'allowed_axioms':sorted(ALLOWED),'headlines':HEADLINES,'module_order':MODULES,
 'records':records,'artifact_sha256':artifact_hashes,'excluded_from_proof_closure':excluded,
 'external_computation_scope':'Independent dense selected-instance kernel/rank/girth checks atL11,L16,L22; all285 parameter pairs atL1..9 and all104 frozen fresh matrices also cross-checked. Complete classical/transpose kernels are enumerated where stated. C++ quantum exclusions, orbit enumeration, the144-pattern integer catalog and the finite sharpness example are external evidence, not universal Lean source-classification certificates.',
 'search_audit':'prior-art.json','search_implementation_audit':'search-repair.json','independent_sat_crosscheck':sat_audit,
 'question_screening':'../../literature/distance-preservation-source-screening.json',
 'source_translation':'SOURCE-TO-PROOF.txt','publication':'No commit, push or external announcement authorized or performed.'}
 (R/'verification.json').write_text(json.dumps(manifest,indent=2)+'\n')
 print(json.dumps({'status':'PASS','admitted_modules':len(MODULES),'headlines':len(HEADLINES),'canonical_completion_delta':0}))
if __name__=='__main__':main()
