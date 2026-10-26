"""Validate SEM source bookkeeping and suitability gates, not mathematical truth."""
import collections,hashlib,json,pathlib
R=pathlib.Path(__file__).resolve().parents[1];D=R/'literature/unl-sem'
load=lambda p:json.loads(p.read_text())
s=load(D/'dissertations.json');a=load(D/'authors.json');w=load(D/'works.json');q=load(D/'questions.json');screen=load(D/'screening.json');search=load(D/'searches.json')
assert len(s)==len(a)==58 and len({x['id'] for x in s})==58
assert len({x['url'] for x in s})==58
assert {x['seed_id'] for x in a}=={x['id'] for x in s}
assert all(x['question_count'] is None and x['full_text_screen_status']=='not_screened_access_gap' for x in s)
assert all(x['year']>=2001 and x['record_kind']=='doctoral_dissertation' for x in s)
assert all(x['search_ids'] for x in a)
searchids={x['id'] for x in search};assert all(set(x['search_ids'])<=searchids for x in a)
assert len(w)==26 and len({x['id'] for x in w})==26
by={x['id']:x for x in w};seedids={x['id'] for x in s}
assert all(set(x['seed_ids'])<=seedids and x['authors'] and x['title'] and x['url'].startswith('https://') for x in w)
assert sum(x['screen_status']=='full_text_screened' for x in w)==screen['full_text_paper_screens']==14
assert sum(x['screen_status']=='full_text_access_gap' for x in w)==screen['access_gap_papers']==12
assert len(q)==8 and not any(x['eligible_for_coverage'] for x in q)
main={x['id']:x for x in load(R/'literature/open-problems.json')}
plans={x['target_id']:x for x in load(R/'planning/current-difficulty-estimates.json')}
manifest={x['paper_id']:x for x in load(R/'literature/downstream-source-manifest.json')}
coverage={x['paper_id']:x for x in load(R/'literature/downstream-paper-coverage.json')}
for x in q:
 assert main[x['id']]==x and x['kind']=='method_request'
 assert x['formalization_suitability']['objects_and_gate'] and plans[x['id']]['gate']
 assert x['lean_proof_status']=='not_assessed_in_this_extension'
 for o in x['occurrences']:
  source=by[o['source_id']];assert source['screen_status']=='full_text_screened'
  assert o['source_sha256']==source['source_sha256']==manifest[source['id']]['sha256']
  assert o['locator'] and len(o['source_sha256'])==64
  lo,hi=o['extracted_text_lines'];assert 0<lo<=hi
  path=R/f'local-extraction/literature/{source["id"]}.txt'
  if path.exists():assert hi<=len(path.read_text().splitlines())
for source in w:
 expected=[x['id'] for x in q if any(o['source_id']==source['id'] for o in x['occurrences'])]
 assert set(expected)==set(source['recorded_target_ids'])==set(coverage[source['id']]['recorded_target_ids'])
 if source['screen_status']=='full_text_screened':
  assert source['question_count']==len(expected)
  path=R/source['retrieval']['local_file']
  if path.exists():assert hashlib.sha256(path.read_bytes()).hexdigest()==source['source_sha256']
 else:assert source['question_count'] is None and not expected
e=load(R/'literature/research-reconciliation.json')['indexing_extensions'][-1]
assert e['id']=='unl-sem-seed-2026-10-26' and e['added_entries']==8 and e['added_eligible_targets']==0
assert e['full_text_screens_added']==14 and e['incomplete_paper_records_added']==12
assert e['seed_records_added']==58 and e['completed_targets_added']==0
assert len(screen['excluded_passages'])==11
print('PASS:58 dissertation seeds;58 authors searched;26 verified works;14 full-text screens;8 gated method directions;0 invented precise conjectures.')
