"""Check inventory bookkeeping, hashes and links, not mathematical correctness."""
import collections,hashlib,json,pathlib,re
from urllib.parse import urlparse
R=pathlib.Path(__file__).resolve().parent.parent;D=R/'literature';load=lambda n:json.loads((D/n).read_text())
rows=load('open-problems.json');coverage=load('downstream-paper-coverage.json');summary=load('open-problem-summary.json');manifest={m['paper_id']:m for m in load('downstream-source-manifest.json')}
expansion=load('scholarly-expansion-review.json')
browser=load('browser-search-review.json')
reconciliation=load('research-reconciliation.json');historical_added=set(reconciliation['added_target_ids'])
extensions=reconciliation.get('indexing_extensions',[])
ext_ids={i for e in extensions for i in e['added_target_ids']}
assert len(ext_ids)==sum(e['added_entries'] for e in extensions)
assert historical_added.isdisjoint(ext_ids)
added=historical_added|ext_ids
ext_n=sum(e['added_entries'] for e in extensions);ext_e=sum(e['added_eligible_targets'] for e in extensions)
ext_p=sum(len(e['added_paper_ids']) for e in extensions);ext_full=sum(e['full_text_screens_added'] for e in extensions)
assert len(rows)==len({r['id'] for r in rows})==expansion['baseline']['canonical_entries']+len(expansion['added_target_ids'])+len(browser['added_target_ids'])+len(added)
assert set(expansion['baseline']['canonical_ids'])|set(expansion['added_target_ids'])|set(browser['added_target_ids'])|added=={r['id'] for r in rows}
ids={r['id'] for r in rows};by={r['id']:r for r in rows};papers={p['id']:p for p in load('papers.json')+load('followups.json') if p['id'].startswith(('P','F'))}
assert len(coverage)==len(papers)==len(manifest)==expansion['baseline']['paper_records']+len(expansion['added_paper_ids'])+len(browser['added_paper_ids'])+len(reconciliation['added_paper_ids'])+ext_p
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
 if r['id'] in ('L-P11-rank-converse','L-P34-girth-eight','L-P11-forbidden'):
  assert r['lean_statement_status']=='verified_lean_statement'
  assert r['lean_proof_status']=='verified_complete_lean_proof'
  assert (R/r['verified_artifact']['readme']).exists()
 elif r['id']=='L-F16-other-absorbing':
  assert r['lean_statement_status']=='verified_lean_statement'
  assert r['lean_proof_status']=='verified_complete_lean_proof'
  assert r['current_resolution_status']=='proved_in_lean_for_incidence_corrected_counts_and_spectral_only_obstruction'
  assert r['verified_artifact']['statement_declaration']=='AbsorbingFourCounts.explicit_cubic_cyclic_four_counts'
  assert (R/r['verified_artifact']['verification']).is_file()
  assert r['partial_artifact']['source_component']=='(4,2) only'
  assert (R/r['partial_artifact']['verification']).is_file()
 elif r['id']=='L-P32-Conway-existence':
  assert r['lean_statement_status']=='identified_lean_statement_not_build_verified'
  assert r['lean_proof_status']=='no_exact_proof_identified'
  assert 'proof_wanted' in r['related_formalization_evidence'][0]['finding']
 elif r['id'] in added:
  assert r['lean_statement_status']==r['lean_proof_status']=='not_assessed_in_this_extension'
  assert r['current_resolution_status']=='not_independently_established'
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
 assert p['target_count']==(len(expected) if p['coverage_status'].endswith('full_text_screened') or p['coverage_status']=='relevant_sections_screened' else None)
 if not p['coverage_status'].endswith('full_text_screened') and p['coverage_status']!='relevant_sections_screened':assert not expected
for m in manifest.values():
 if m['status']=='retrieved':
  p=R/m['local_file']
  if p.exists():assert hashlib.sha256(p.read_bytes()).hexdigest()==m['sha256']
new=[r for r in rows if r['origin']=='article_inventory_extension'];eligible=[r for r in rows if r['eligible_for_coverage']]
assert len(new)==summary['additional_entries']==74+expansion['added_entries']+browser['added_entries']+reconciliation['added_entries']+ext_n
assert sum(r['eligible_for_coverage'] for r in new)==summary['additional_eligible_targets']==35+expansion['added_eligible_targets']+browser['added_eligible_targets']+reconciliation['added_eligible_targets']+ext_e
assert len(eligible)==summary['eligible_targets']==74+expansion['added_eligible_targets']+browser['added_eligible_targets']+reconciliation['added_eligible_targets']+ext_e
assert summary['new_written_math_statuses']==dict(collections.Counter(r['written_math_status'] for r in new))
assert summary['full_text_screened']==sum(p['coverage_status'].endswith('full_text_screened') for p in coverage)==30+len(expansion['added_paper_ids'])+len(browser['added_paper_ids'])+ext_full
assert sum(r['origin']=='dissertation_inventory' and len(r['occurrences'])>1 for r in rows)==15
assert summary['historical_withdrawn_full_text_screened']==1 and summary['current_publication_full_text_screened']==29+len(expansion['added_paper_ids'])+len(browser['added_paper_ids'])+ext_full
assert summary['not_fully_assessed']==1+reconciliation['added_relevant_section_screens']+sum(e.get('incomplete_paper_records_added',0) for e in extensions)
assert summary['eligible_verified_lean_statements']==summary['eligible_verified_proof_assistant_statements']==4
assert summary['eligible_verified_lean_proofs']==4
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
assert summary['eligible_lean_discovery_unassessed']==5+browser['added_eligible_targets']-load('lean-coverage-review.json')['assessed_eligible_count']+reconciliation['added_eligible_targets']+ext_e
print(f'Validated {len(rows)} canonical entries, {len(eligible)} eligible targets, {len(coverage)} paper records, preserved historical audit evidence, and distinct verified/unverified/unassessed Lean statuses.')

assert reconciliation['completed_targets_added']==0
assert len(historical_added)==6 and sum(by[t]['eligible_for_coverage'] for t in historical_added)==3
assert summary['eligible_targets']==reconciliation['baseline']['eligible_targets']+3+ext_e
for task in reconciliation['project_derived_followups']:
 assert task['origin']=='project_derived_followup' and not task['source_authors_asked_this_exact_question']
 assert not task['eligible_for_coverage'] and task['id'] not in ids
for source in load('research-source-index.json')['sources']:
 assert set(source['related_target_ids']) <= ids
 assert source['access'] and source['comparison_limit'] and source['record_kind']
 if source.get('bibliography_id'):assert source['bibliography_id'] in papers
for row in rows:
 for p in row.get('research_progress',[]):
  assert (R/p['report']).is_file()
  for source in p['lean_sources']:assert (R/source).is_file()
assert len(load('research-source-index.json')['sources'])==reconciliation['central_source_records']
for block in reconciliation.get('research_blocks',[]):
 assert block['canonical_entry_delta']==block['eligible_target_delta']==0
 assert block['complete_canonical_lean_target_delta']==(1 if block['id']=='absorbing-four-zero-2026-10-24' else 0)
 assert (R/block['report']).is_file() and (R/block['verification']).is_file()
print('Research reconciliation: earlier six-target expansion preserved; source index and zero-delta (4,2) research block PASS.')

# Beezer journal extension: exact independent delta, source hash and no invented Lean status.
assert extensions
e=extensions[0]
assert e['baseline']==dict(canonical_entries=187,eligible_targets=111,paper_records=60,full_text_screens=57,verified_complete_lean_targets=3)
assert e['added_entries']==3 and e['added_eligible_targets']==1 and e['full_text_screens_added']==1
assert e['added_paper_ids']==['F27'] and e['completed_targets_added']==0
assert len(e['added_target_ids'])==3 and sum(by[i]['eligible_for_coverage'] for i in e['added_target_ids'])==1
assert manifest['F27']['sha256']=='d904cb0ee96f4b3a8c09ef0d11e2c965454228fec027c91eeb6ca5d56762c810'
later=extensions[1:]
assert len(rows)==190+sum(x['added_entries'] for x in later)
assert len(eligible)==112+sum(x['added_eligible_targets'] for x in later)
assert len(coverage)==61+sum(len(x['added_paper_ids']) for x in later)
assert summary['full_text_screened']==58+sum(x['full_text_screens_added'] for x in later)
assert (R/e['report']).is_file()
print('Beezer extension:187→190 entries,111→112 eligible,60→61 papers,57→58 full-text screens; three historical complete Lean targets retained; one existing F16 target completed.')
