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
assert summary['eligible_targets']==cov['eligible_targets']==108
# Keep the discovery audit's original counts, and account for the later checked P34 proof.
assert cov['verified_lean_proofs']==1 and summary['eligible_verified_lean_proofs']==2
assert cov['verified_lean_statements']==1 and summary['eligible_verified_lean_statements']==2
assert summary['eligible_identified_unverified_lean_statements']==cov['identified_unverified_lean_statements_without_proof']==1
assert summary['eligible_lean_discovery_unassessed']==cov['lean_discovery_unassessed']==0
assert sum(r['eligible_for_coverage'] and r['lean_statement_status']=='no_exact_statement_identified' for r in rows.values())==105
assert cov['no_exact_statement_identified_in_bounded_search']==106
for href in re.findall(r'\]\(([^)]+)\)',(D/'LEAN-COVERAGE.md').read_text()):
 u=urlparse(href)
 if not u.scheme and u.path:assert (D/u.path).exists(),href
print('Validated assessment of 12 eligible targets and nine directions, 32 pinned searches, ten successful GitHub queries, 57 candidate comparisons and 66 successful dyadic axiom reports.')
