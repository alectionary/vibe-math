"""Check inventory bookkeeping, hashes and links, not mathematical correctness."""
import collections,hashlib,json,pathlib,re
from urllib.parse import urlparse
R=pathlib.Path(__file__).resolve().parent.parent;D=R/'literature';load=lambda n:json.loads((D/n).read_text())
rows=load('open-problems.json');coverage=load('downstream-paper-coverage.json');summary=load('open-problem-summary.json');manifest={m['paper_id']:m for m in load('downstream-source-manifest.json')}
expansion=load('scholarly-expansion-review.json')
browser=load('browser-search-review.json')
assert len(rows)==len({r['id'] for r in rows})==expansion['baseline']['canonical_entries']+len(expansion['added_target_ids'])+len(browser['added_target_ids'])
assert set(expansion['baseline']['canonical_ids'])|set(expansion['added_target_ids'])|set(browser['added_target_ids'])=={r['id'] for r in rows}
ids={r['id'] for r in rows};by={r['id']:r for r in rows};papers={p['id']:p for p in load('papers.json')+load('followups.json') if p['id'].startswith(('P','F'))}
assert len(coverage)==len(papers)==len(manifest)==expansion['baseline']['paper_records']+len(expansion['added_paper_ids'])+len(browser['added_paper_ids'])
assert {p['paper_id'] for p in coverage}==set(papers)
legacy={c['id']:c for c in json.loads((R/'audit/claims.json').read_text()) if c['kind']=='open_question'}
assert len(legacy)==40
for id,c in legacy.items():
 assert by[id]['origin']=='dissertation_inventory'
 assert by[id]['eligible_for_coverage']==c['in_denominator']
 assert by[id]['occurrences'][0]['pdf_pages']==c['pdf_pages']
for r in rows:
 assert r['title'] and r['eligibility_note'] and r['occurrences']
 assert set(r['related_target_ids']) <= ids and r['id'] not in r['related_target_ids']
 if r['id']=='L-P11-rank-converse':
  assert r['lean_statement_status']=='verified_lean_statement'
  assert r['lean_proof_status']=='verified_complete_lean_proof'
  assert (R/r['verified_artifact']['readme']).exists()
 elif r['id']=='L-P32-Conway-existence':
  assert r['lean_statement_status']=='identified_lean_statement_not_build_verified'
  assert r['lean_proof_status']=='no_exact_proof_identified'
  assert 'proof_wanted' in r['related_formalization_evidence'][0]['finding']
 elif r.get('added_on')=='2026-10-22':
  assert r['lean_statement_status'] in ('no_exact_statement_identified','not_assessed_in_this_extension')
  assert r['lean_proof_status'] in ('no_exact_proof_identified','not_assessed_in_this_extension')
  assert r['supplementary_search_evidence']
 else:
  assert r['lean_statement_status']=='no_exact_statement_identified'
  assert r['lean_proof_status']=='no_exact_proof_identified'
 if r['origin']=='article_inventory_extension' and r['id']!='L-P32-triangle-bound':assert r['eligible_for_coverage']==(r['written_math_status']=='precise_math_in_source' and r['status_as_of_source']!='withdrawn_historical_only')
 if r['id']=='L-P32-triangle-bound':assert not r['eligible_for_coverage'] and r['current_resolution_status']=='counterexample_checked_in_python_not_lean'
 for o in r['occurrences']:
  assert urlparse(o['url']).scheme=='https' and len(o['source_sha256'])==64
  if o['source_id'] in papers:
   assert manifest[o['source_id']]['sha256']==o['source_sha256']
   a,b=o['extracted_text_lines'];assert 0<a<=b
   p=R/'local-extraction/literature'/f"{o['source_id']}.txt"
   if p.exists():assert b<=len(p.read_text().splitlines()),(r['id'],o)
  else:assert o['source_id']==legacy[r['id']]['dissertation_id']
for p in coverage:
 expected={r['id'] for r in rows if any(o['source_id']==p['paper_id'] for o in r['occurrences'])}
 assert set(p['recorded_target_ids'])==expected
 assert p['target_count']==(len(expected) if p['coverage_status'].endswith('full_text_screened') else None)
 if not p['coverage_status'].endswith('full_text_screened'):assert not expected
for m in manifest.values():
 if m['status']=='retrieved':
  p=R/m['local_file']
  if p.exists():assert hashlib.sha256(p.read_bytes()).hexdigest()==m['sha256']
new=[r for r in rows if r['origin']=='article_inventory_extension'];eligible=[r for r in rows if r['eligible_for_coverage']]
assert len(new)==summary['additional_entries']==74+expansion['added_entries']+browser['added_entries']
assert sum(r['eligible_for_coverage'] for r in new)==summary['additional_eligible_targets']==35+expansion['added_eligible_targets']+browser['added_eligible_targets']
assert len(eligible)==summary['eligible_targets']==74+expansion['added_eligible_targets']+browser['added_eligible_targets']
assert summary['new_written_math_statuses']==dict(collections.Counter(r['written_math_status'] for r in new))
assert summary['full_text_screened']==sum(p['coverage_status'].endswith('full_text_screened') for p in coverage)==30+len(expansion['added_paper_ids'])+len(browser['added_paper_ids'])
assert sum(r['origin']=='dissertation_inventory' and len(r['occurrences'])>1 for r in rows)==15
assert summary['historical_withdrawn_full_text_screened']==1 and summary['current_publication_full_text_screened']==29+len(expansion['added_paper_ids'])+len(browser['added_paper_ids'])
assert summary['not_fully_assessed']==1
assert summary['eligible_verified_lean_statements']==summary['eligible_verified_proof_assistant_statements']==1
assert summary['eligible_verified_lean_proofs']==1
assert summary['eligible_targets_with_verified_finite_cases']==0
assert all(not r['eligible_for_coverage'] for r in rows if r['status_as_of_source']=='withdrawn_historical_only')
assert next(p for p in coverage if p['paper_id']=='P10')['target_count'] is None
assert len(load('coverage-gap-lean-searches.json')['searches'])==8
mech=load('downstream-mechanization.json');assert len(mech)==1 and mech[0]['applies_to_open_target_ids']==[]
assert next(p for p in papers.values() if p['id']=='P20')['publication_status']=='withdrawn'
local=load('downstream-lean-searches.json');assert len(local['searches'])==44
sources={x['id']:x for x in json.loads((R/'audit/sources.json').read_text())}
for s in local['searches']:assert s['revision']==sources[s['repository']]['revision'] and s['exit_code'] in (0,1)
gh=load('downstream-github-searches.json');assert len(gh['searches'])==8
candidates=load('downstream-lean-candidates.json');assert len(candidates)==sum(len(s.get('results',[])) for s in gh['searches'])==32
for c in candidates:
 if c['status']=='retrieved':
  assert c['comparison_status']=='different_mathematical_objects' and c['comparison']
  p=R/c['local_file']
  if p.exists():assert hashlib.sha256(p.read_bytes()).hexdigest()==c['sha256']
report=(D/'OPEN-PROBLEMS.md').read_text();page=(D/'open-problems.html').read_text()
for r in rows:assert f"### {r['id']}\n" in report and r['id'] in page
for href in re.findall(r'\]\(([^)]+)\)',report):
 u=urlparse(href)
 if not u.scheme and u.path:assert (D/u.path).exists(),href
assert f"0/{len(eligible)}" in report and f"0/{len(eligible)}" in page
assert summary['eligible_identified_unverified_lean_statements']==1
assert summary['eligible_lean_discovery_unassessed']==5+browser['added_eligible_targets']-load('lean-coverage-review.json')['assessed_eligible_count']
print(f'Validated {len(rows)} canonical entries, {len(eligible)} eligible targets, {len(coverage)} paper records, preserved historical audit evidence, and distinct verified/unverified/unassessed Lean statuses.')
