"""Audit exact sources, standard axioms, finite coverage and the assembled main theorem."""
from pathlib import Path
import argparse,datetime,hashlib,json,re
from replay_round import local_import_order
R=Path(__file__).resolve().parent
ALLOWED={'propext','Classical.choice','Quot.sound'}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(p.read_text())
def build_status(src):
 p=R/'round-logs'/(src.stem+'.json');log=p.with_suffix('.log')
 if not p.exists() or not log.exists():return dict(status='not_checked',source_sha256=sha(src))
 try:x=read(p)
 except json.JSONDecodeError:return dict(status='record_write_in_progress',source_sha256=sha(src))
 matched=x['source_sha256']==sha(src) and x['log_sha256']==sha(log)
 good=matched and x['exit_code']==0 and not x['unexpected_axiom_or_error'] and not x.get('source_changed_during_build',False)
 text=log.read_text();axioms=set()
 for a in re.findall(r'depends on axioms: \[([^\]]*)\]',text):axioms.update(v.strip() for v in a.split(',') if v.strip())
 good=good and axioms<=ALLOWED and not any(s in text for s in ['sorryAx','._native.','error:'])
 return dict(status='PASS' if good else 'not_admitted',source_sha256=sha(src),source_change_capture='before_and_after' if 'source_changed_during_build' in x else 'legacy_record_current_hash_matched',record=str(p.relative_to(R)),log_sha256=sha(log),axioms=sorted(axioms),finished_utc=x['finished_utc'],seconds=x['seconds'])

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--final',action='store_true');ap.add_argument('--round-number',type=int,choices=[1,2],default=2);a=ap.parse_args()
 modules={p.stem:build_status(p) for p in sorted(R.glob('*.lean'))}
 for p in R.parent.glob('*.lean'):
  if (R/'round-logs'/(p.stem+'.json')).exists():modules[p.stem]=build_status(p)
 plan=read(R/'kernel-chunk-plan.json');coverage={w:dict(expected_patterns=n,admitted_patterns=0,admitted_intervals=[],pending_modules=[]) for w,n in [(7,144),(10,124416),(11,58752)]}
 for c in plan['modules']:
  src=R/'catalog-chunks'/(c['module']+'.lean')
  if not src.exists():
   coverage[c['weight']]['pending_modules'].append(c['module']);modules[c['module']]=dict(status='not_materialized',source_sha256=c['source_sha256']);continue
  assert sha(src)==c['source_sha256']
  found=re.findall(r'^theorem fastCase(\d+)_(\d+) : checkCertificateFast (\d+) (\d+) fastCert',src.read_text(),re.M)
  assert [(int(w),int(i),int(w2),int(i2)) for w,i,w2,i2 in found]==[(c['weight'],i,c['weight'],i) for i in range(c['start'],c['start']+c['count'])]
  st=build_status(src);modules[c['module']]=st;v=coverage[c['weight']]
  if st['status']=='PASS':
   assert 'aggregate_'+c['module'] in (R/'round-logs'/(c['module']+'.log')).read_text()
   v['admitted_patterns']+=c['count'];v['admitted_intervals'].append([c['start'],c['start']+c['count']])
  else:v['pending_modules'].append(c['module'])
 for w,v in coverage.items():
  parts=sorted((x['start'],x['start']+x['count']) for x in plan['modules'] if x['weight']==w)
  assert parts[0][0]==0 and parts[-1][1]==v['expected_patterns']
  assert all(a[1]==b[0] for a,b in zip(parts,parts[1:]))
  v['all_closed_cases_admitted']=v['admitted_patterns']==v['expected_patterns']
 independent=read(R/'catalog-verification.json');assert independent['status']=='PASS'
 assert independent['verifier_sha256']==sha(R/'verify_catalog.py')
 for x in independent['reports']:
  name={7:'completed-patterns-7.jsonl.gz',10:'final-patterns-10.jsonl.gz',11:'completed-patterns-11.jsonl.gz'}[x['weight']]
  assert x['catalog_sha256']==sha(R/name)
 lift=read(R/'catalog-lift.json');assert lift['status']=='integer_lift_verified'
 for x in lift['reports']:assert x['encoded_sha256']==sha(R/f"encoded-catalog-{x['weight']}.json.gz")
 required_main=['SourceProfiles','SourceSeven','TenEncoding','CoverageCore','Catalog10','Coverage10','Catalog11','Coverage11','CatalogExclusion11','SourceEleven','ProfileTransport','CountCanonical','SourceTen','TwelveConditional','ThroughEleven','DistanceMinima','DistanceTwelve','CriterionScope']
 admitted=lambda n:modules.get(n,{}).get('status')=='PASS'
 closure=local_import_order(['DistanceTwelve','CriterionScope'])
 pending_imports=[n for n in closure if not admitted(n)]
 main_done=all(admitted(n) for n in required_main) and not pending_imports and all(x['all_closed_cases_admitted'] for x in coverage.values())
 gaps=[]
 if not admitted('TenEncoding'):gaps.append('Complete the actual canonical weight-ten support-to-pattern map.')
 if not admitted('SourceEleven'):gaps.append('Complete the actual canonical weight-eleven support map and both stabilizer branches.')
 if not admitted('ProfileTransport') or not admitted('CountCanonical'):gaps.append('Complete transport and canonical ordering for arbitrary actual profiles.')
 if not admitted('TwelveConditional'):gaps.append('Assemble the full source/Pauli reduction conditional on the independent weight-ten finite coverage.')
 for w in [10,11]:
  if not coverage[w]['all_closed_cases_admitted']:gaps.append(f'Finish the complete weight-{w} closed-case kernel replay.')
  if not admitted(f'Coverage{w}'):gaps.append(f'Assemble quantified finite coverage for the weight-{w} catalog.')
 if not admitted('ThroughEleven'):gaps.append('Discharge all finite coverage in the unconditional general min(D,12) source Pauli theorem.')
 if not admitted('DistanceMinima') or not admitted('DistanceTwelve'):gaps.append('Complete the literal source-distance minimum theorem and transpose infinity convention.')
 if not admitted('CriterionScope'):gaps.append('Check that the strengthened triple-row test subsumes full-row RCPC.')
 if pending_imports:gaps.append('Admit every exact-source research dependency in the final theorem import closure; see main_import_closure.pending_modules.')
 if main_done:assert not gaps
 bounded_result=(dict(bound='dQ >= min(dC,12)',pauli_theorem='source_pauli_bound_twelve',pauli_source='ThroughEleven.lean',distance_theorem='source_distance_bound_twelve',distance_source='DistanceTwelve.lean',scope='Arbitrary positive cyclic modulus, normalized fully populated monomial3x4 base, classical no-four/no-six, exact column/triple-row tests, transpose distance at least classical distance, both full spans and ordinary Pauli union weight. The broader full-equality question is not settled.') if main_done else None)
 intermediate=[]
 if modules.get('ThroughNine',{}).get('status')=='PASS':
  intermediate.append(dict(bound='min(D,10)',theorem='source_pauli_bound_ten',source='ThroughNine.lean',scope='Actual expanded source matrices, both full stabilizer spans and Pauli union weight; ClassicalAtLeast e D and TransposeAtLeast e D under the normalized girth/entry tests. This is strictly weaker than the requested min(D,12) result.'))
 out=dict(checked_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),round_status=('closed_with_completed_bounded_followup' if main_done else 'closed_with_partial_formalization') if a.final else 'in_progress',canonical_target_id='L-F25-distance-preservation',bounded_followup_id='RQ-F25-truncated-distance-12',issue='https://github.com/alectionary/vibe-math/issues/1',study_round=a.round_number,study_started_utc={1:'2026-10-25T21:58:56Z',2:'2026-10-26T01:40:59Z'}[a.round_number],deadline_utc={1:'2026-10-26T01:58:56Z',2:'2026-10-26T05:40:59Z'}[a.round_number],main_source_distance_theorem_completed=main_done,completed_bounded_followup=bounded_result,canonical_completion_delta=0,full_canonical_lean_completion_delta=0,claim_boundary=('General Lean truncated distance12 theorem completed, including actual support coverage and literal source minima; broader dQ=dC remains open.' if main_done else 'The min(D,10) theorem is complete. Current min(D,12) source reduction and case coverage remain explicitly separated; no unconditional stronger result is claimed until every required source and finite-coverage proof passes.'),independent_integer_replay=dict(status='PASS',patterns=183312,report='catalog-verification.json'),integer_lift_report='catalog-lift.json',kernel_cases={str(k):v for k,v in coverage.items()},modules=modules,remaining_formal_gaps=gaps,completed_intermediate_source_bounds=intermediate,literature_ledger='../../../literature/truncated-distance12-source-screening.json',prior_art_coverage_limit='Bounded primary/GitHub searches; native X unavailable. No exhaustive novelty or current-resolution claim.',verifier_sha256=sha(Path(__file__)))
 out['main_import_closure']=dict(roots=['DistanceTwelve','CriterionScope'],modules=len(closure),admitted_modules=len(closure)-len(pending_imports),pending_modules=pending_imports,all_exact_sources_admitted=not pending_imports)
 (R/'verification.json').write_text(json.dumps(out,indent=2)+'\n')
 print(json.dumps(dict(round_status=out['round_status'],kernel_cases={str(w):(v['admitted_patterns'],v['expected_patterns']) for w,v in coverage.items()},main_source_distance_theorem_completed=main_done,passed_modules=sum(x['status']=='PASS' for x in modules.values())),indent=2))
if __name__=='__main__':main()
