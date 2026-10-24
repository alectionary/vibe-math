"""Check coverage evidence and bookkeeping, not the semantic correctness of external code."""
from pathlib import Path
import hashlib,json,re
from urllib.parse import urlparse
R=Path(__file__).resolve().parent.parent;D=R/'literature'
load=lambda f:json.loads((D/f).read_text())
audit=load('lean-coverage-review.json');rows={r['id']:r for r in load('open-problems.json')}
assessed=audit['assessed_entries']
assert len(assessed)==audit['assessed_entry_count']==21
assert len({r['target_id'] for r in assessed})==21
assert sum(r['eligible_for_coverage'] for r in assessed)==audit['assessed_eligible_count']==12
for r in assessed:
 current=rows[r['target_id']]
 assert r['before_statement_status']==r['before_proof_status']=='not_assessed_in_this_extension'
 assert current['eligible_for_coverage']==r['eligible_for_coverage']
 if r['target_id']=='L-P34-girth-eight':
  assert current['lean_statement_status']=='verified_lean_statement'
  assert current['lean_proof_status']=='verified_complete_lean_proof'
  assert current['verified_artifact']['verification']=='formalization/cyclic-lifts/verification.json'
 else:
  assert current['lean_statement_status']=='no_exact_statement_identified'
  assert current['lean_proof_status']=='no_exact_proof_identified'
 assert 'lean-coverage-review.json' in current['supplementary_search_evidence']
local=load('lean-coverage-local-searches.json')['searches']
assert len(local)==audit['local_queries']==32
sources={s['id']:s for s in load('../audit/sources.json')}
for q in local:assert q['revision']==sources[q['repository']]['revision'] and q['exit_code'] in (0,1)
queries=load('lean-coverage-github-searches.json')['searches']
assert len(queries)==audit['github_queries_attempted']==12
assert sum(q['status']=='retrieved' for q in queries)==audit['github_queries_successful']==10
assert [q['query'] for q in queries if q['hit_cap_reached']]==audit['github_capped_queries']
assert len(audit['github_capped_queries'])==2 and len(audit['github_failed_queries'])==2
candidates=load('lean-coverage-candidates.json')
assert len(candidates)==audit['github_candidate_files']==57
for r in candidates+load('lean-coverage-background.json')['sources']:
 assert r.get('comparison_status') or r.get('comparison')
 p=R/r['local_file']
 if p.exists():assert hashlib.sha256(p.read_bytes()).hexdigest()==r['sha256']
log=R/audit['dyadic_recheck']['log'];t=log.read_text()
assert hashlib.sha256(log.read_bytes()).hexdigest()==audit['dyadic_recheck']['log_sha256']
assert audit['dyadic_recheck']['exit_code']==0
assert sum('depends on axioms:' in l for l in t.splitlines())==audit['dyadic_recheck']['axiom_report_count']==66
assert 'sorryAx' not in t and 'error:' not in t
for group in re.findall(r'\[(.*?)\]',t):
 assert {a.strip() for a in group.split(',') if a.strip()}<={'propext','Classical.choice','Quot.sound'}
summary=load('open-problem-summary.json');cov=audit['coverage']
reconciliation=load('research-reconciliation.json')
delta=reconciliation['added_eligible_targets']+sum(e['added_eligible_targets'] for e in reconciliation.get('indexing_extensions',[]))
assert cov['eligible_targets']==108
assert summary['eligible_targets']==cov['eligible_targets']+delta
# Keep the discovery audit's original counts, and account for the later checked P34 proof.
assert cov['verified_lean_proofs']==1 and summary['eligible_verified_lean_proofs']==4
assert cov['verified_lean_statements']==1 and summary['eligible_verified_lean_statements']==4
assert summary['eligible_identified_unverified_lean_statements']==cov['identified_unverified_lean_statements_without_proof']==1
assert cov['lean_discovery_unassessed']==0
assert summary['eligible_lean_discovery_unassessed']==delta
assert sum(r['eligible_for_coverage'] and r['lean_statement_status']=='no_exact_statement_identified' for r in rows.values())==103
assert summary['eligible_targets_with_supporting_lean_proofs']==0
assert rows['L-P11-forbidden']['lean_proof_status']=='verified_complete_lean_proof'
assert cov['no_exact_statement_identified_in_bounded_search']==106
for href in re.findall(r'\]\(([^)]+)\)',(D/'LEAN-COVERAGE.md').read_text()):
 u=urlparse(href)
 if not u.scheme and u.path:assert (D/u.path).exists(),href
print('Validated assessment of 12 eligible targets and nine directions, 32 pinned searches, ten successful GitHub queries, 57 candidate comparisons and 66 successful dyadic axiom reports.')

assert rows['L-F16-other-absorbing']['lean_proof_status']=='verified_complete_lean_proof'
assert rows['L-F16-other-absorbing']['partial_artifact']['source_component']=='(4,2) only'


# Standard-complex (4,2) supporting artifact audit.
# The historical discovery cohort remains unchanged above. This checks the
# current supporting source archive and does not increment complete targets.
artifact=R/rows['L-F16-other-absorbing']['partial_artifact']['verification']
component=json.loads(artifact.read_text());root=artifact.parent
assert component['canonical_target_id']=='L-F16-other-absorbing'
assert component['canonical_complete'] is False
assert component['fresh_full_source_rebuild'] is True
assert all(v==0 for v in component['cohort_delta'].values())
for name,expected in component['payload_sha256'].items():
 assert hashlib.sha256((root/name).read_bytes()).hexdigest()==expected,name
allowed={'propext','Classical.choice','Quot.sound'}
for module in component['new_lean_modules']:
 source=root/(module['module']+'.lean')
 assert hashlib.sha256(source.read_bytes()).hexdigest()==module['source_sha256']
 assert module['exit_code']==0 and module['unchanged_during_check']
 assert set(module['printed_axioms'])<=allowed
fresh=json.loads((root/'fresh-recheck.json').read_text())
assert fresh['fresh_full_check']
assert len(fresh['new_modules'])==len(component['new_lean_modules'])
assert len(fresh['base_modules'])==len(component['unchanged_base_lean_modules'])
assert all(m['exit_code']==0 for m in fresh['new_modules']+fresh['base_modules'])
old=root.parent/'verification.json'
assert hashlib.sha256(old.read_bytes()).hexdigest()==component['preserved_base']['manifest_sha256']
assert (root/'first-block/verification.json').read_bytes()==old.read_bytes()
print('Validated the current standard-complex (4,2) supporting proofs, fresh source rebuild, payload hashes and preserved first-block manifest; no complete-target increment.')

# The new supporting (4,0) block is audited separately from frozen complex artifacts.
artifact40=R/rows['L-F16-other-absorbing']['four_zero_artifact']['verification']
m40=json.loads(artifact40.read_text());root40=artifact40.parent
assert m40['canonical_target_id']=='L-F16-other-absorbing' and m40['canonical_complete']
assert m40['fresh_full_source_rebuild']
assert m40['cohort_delta']==dict(canonical_entries=0,eligible_targets=0,complete_canonical_Lean_targets=1)
for name,h in m40['payload_sha256'].items():assert hashlib.sha256((root40/name).read_bytes()).hexdigest()==h,name
for module in m40['new_lean_modules']:
 assert module['exit_code']==0 and module['unchanged_during_check']
 assert set(module['printed_axioms'])<={'propext','Classical.choice','Quot.sound'}
 assert hashlib.sha256((root40/(module['module']+'.lean')).read_bytes()).hexdigest()==module['source_sha256']
print('Validated complete recorded F16 count/obstruction artifact and fresh source check; exactly one existing target promoted.')

# All dependencies are rebuilt from source; helper modules do not add targets.
fresh40=json.loads((root40/'fresh-recheck.json').read_text())
assert fresh40['fresh_full_check'] and fresh40['frozen_payload_preserved']
assert fresh40['total_modules']==len(fresh40['modules'])==61
assert len({x['module'] for x in fresh40['modules']})==61
groups={'base_lean_modules':'prior/first-block','prior_complex_lean_modules':'prior','new_lean_modules':'.'}
for group,prefix in groups.items():
 expected={x['module']:x['source_sha256'] for x in m40[group]}
 actual={x['module']:x['source_sha256'] for x in fresh40['modules'] if x['group']==group}
 assert expected==actual
 for row in fresh40['modules']:
  if row['group']!=group:continue
  assert row['exit_code']==0 and row['unchanged_during_check']
  assert set(row['printed_axioms'])<={'propext','Classical.choice','Quot.sound'}
  assert hashlib.sha256((root40/prefix/(row['module']+'.lean')).read_bytes()).hexdigest()==row['source_sha256']
  log=root40/'fresh-logs'/(row['module']+'.log')
  assert hashlib.sha256(log.read_bytes()).hexdigest()==row['log_sha256']
standalone=json.loads((root40/'standalone-entry-check.json').read_text())
assert standalone['exit_code']==0 and standalone['unchanged_during_check']
assert standalone['fresh_generated_research_objects']==61 and not standalone['manually_added_research_import_paths']
assert hashlib.sha256((root40/'standalone-entry.log').read_bytes()).hexdigest()==standalone['log_sha256']
print('Validated61fresh source checks and the standalone Lake entry, including all preserved dependencies.')
