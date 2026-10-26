"""Audit exact-source build records and finite-case coverage; never infer the main theorem."""
from pathlib import Path
import argparse,datetime,hashlib,json,re
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
 ap=argparse.ArgumentParser();ap.add_argument('--final',action='store_true');a=ap.parse_args()
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
 gaps=[]
 if modules.get('SourceSeven',{}).get('status')!='PASS':
  gaps.append('Complete actual source support-to-pattern construction and full catalog application for the seven-singleton profile.')
 gaps.append('Complete actual source support-to-labeled-pattern maps for the weight-ten and weight-eleven profiles, including pair matching and graph/color extraction.')
 if modules.get('ConstantRows',{}).get('status')!='PASS':
  gaps.append('Complete actual constant-label stabilizer-row identification and cancellation.')
 if not all(modules.get(n,{}).get('status')=='PASS' for n in ['ClassicalTransport','EntryTestTransport']):
  gaps.append('Complete permutation/normalization transport of all entry tests and both classical distance predicates.')
 if not coverage[10]['all_closed_cases_admitted']:
  gaps.append('Finish the deferred complete weight-ten closed-case kernel replay.')
 if not coverage[11]['all_closed_cases_admitted']:
  gaps.append('Finish any pending weight-eleven closed-case kernel replay.')
 gaps.append('Assemble uniform finite-catalog coverage, all source transports, the remaining profiles, and the final min(D,12) source distance/Pauli theorem.')
 intermediate=[]
 if modules.get('ThroughNine',{}).get('status')=='PASS':
  intermediate.append(dict(bound='min(D,10)',theorem='source_pauli_bound_ten',source='ThroughNine.lean',scope='Actual expanded source matrices, both full stabilizer spans and Pauli union weight; ClassicalAtLeast e D and TransposeAtLeast e D under the normalized girth/entry tests. This is strictly weaker than the requested min(D,12) result.'))
 out=dict(checked_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),round_status='closed_with_partial_formalization' if a.final else 'in_progress',canonical_target_id='L-F25-distance-preservation',bounded_followup_id='RQ-F25-truncated-distance-12',issue='https://github.com/alectionary/vibe-math/issues/1',study_started_utc='2026-10-25T21:58:56Z',deadline_utc='2026-10-26T01:58:56Z',main_source_distance_theorem_completed=False,canonical_completion_delta=0,full_canonical_lean_completion_delta=0,claim_boundary='Written certificate-assisted argument and checked structural bridges. Closed synthetic pattern identities do not by themselves prove every actual source support is represented or establish the final distance theorem.',independent_integer_replay=dict(status='PASS',patterns=183312,report='catalog-verification.json'),integer_lift_report='catalog-lift.json',kernel_cases={str(k):v for k,v in coverage.items()},modules=modules,remaining_formal_gaps=gaps,completed_intermediate_source_bounds=intermediate,literature_ledger='../../../literature/truncated-distance12-source-screening.json',prior_art_coverage_limit='Bounded primary/GitHub searches; native X unavailable. No exhaustive novelty or current-resolution claim.',verifier_sha256=sha(Path(__file__)))
 (R/'verification.json').write_text(json.dumps(out,indent=2)+'\n')
 print(json.dumps(dict(round_status=out['round_status'],kernel_cases={str(w):(v['admitted_patterns'],v['expected_patterns']) for w,v in coverage.items()},main_source_distance_theorem_completed=False,passed_modules=sum(x['status']=='PASS' for x in modules.values())),indent=2))
if __name__=='__main__':main()
