"""Validate SEM source bookkeeping and suitability gates, not mathematical truth."""
import collections,hashlib,json,pathlib
R=pathlib.Path(__file__).resolve().parents[1];D=R/'literature/unl-sem'
load=lambda p:json.loads(p.read_text())
s=load(D/'dissertations.json');a=load(D/'authors.json');w=load(D/'works.json');q=load(D/'questions.json');screen=load(D/'screening.json');search=load(D/'searches.json')
exp=load(D/'cfa-expansion.json');tot=screen['cohort_totals']
assert len(s)==len(a)==tot['dissertations']==99 and len({x['id'] for x in s})==99
assert len({x['url'].rstrip('/') for x in s})==len(s)
assert len(s[:58])==58 and {x['id'] for x in s[58:]}==set(exp['added_seed_ids'])
assert sum(x['scope_class']=='adjacent_latent_measurement' for x in s)==exp['added_adjacent_records']==10
assert sum(x['scope_class']!='adjacent_latent_measurement' for x in s[58:])==exp['added_core_records']==31
assert any(x['id']=='UNL-SEM-D067' and 'AAI3402936' in x['alternate_urls'] for x in s)
assert {x['seed_id'] for x in a}=={x['id'] for x in s}
retrieval=load(D/'retrieval-audit.json')
seed_manifest={x['dissertation_id']:x for x in load(D/'seed-source-manifest.json')}
seed_screens=load(D/'seed-screening.json')
screens_by={x['dissertation_id']:x for x in seed_screens['full_text_screens']}
assert len(retrieval['rows'])==len({x['dissertation_id'] for x in retrieval['rows']})==len(s)
assert {x['dissertation_id'] for x in retrieval['rows']}=={x['id'] for x in s}
assert len(seed_manifest)==len(screens_by)==retrieval['complete_dissertations_screened']==7
assert sum(x['retrieval_status']=='front_matter_only_preview' for x in s)==1
for x in s:
 if x['id'] in seed_manifest:
  m=seed_manifest[x['id']];sc=screens_by[x['id']]
  assert x['full_text_screen_status']==sc['screen_status']=='full_text_screened'
  assert x['question_count']==sc['question_count']==0 and not sc['recorded_target_ids']
  assert x['source_pdf_sha256']==m['pdf_sha256']==sc['source_pdf_sha256']
  assert sc['source_stated_research_directions'] and sc['principal_locator']
  for path,hashkey in [('local_file','pdf_sha256'),('text_file','text_sha256')]:
   p=R/m[path]
   if p.exists():assert hashlib.sha256(p.read_bytes()).hexdigest()==m[hashkey]
 else:
  assert x['question_count'] is None
  assert x['full_text_screen_status'] in ('not_screened_retrieval_incomplete','not_screened_partial_preview')
 assert x['access_history'] and x['access']['scope_limit']
allowed_retrieval={'not_retrieved_in_checked_routes','complete_pdf_retrieved','front_matter_only_preview','acquisition_requested'}
assert {x['retrieval_status'] for x in s}<=allowed_retrieval
assert {x['access']['retrieval_status'] for x in s}<=allowed_retrieval
for x in s:
 if x['retrieval_status']=='acquisition_requested' or x['access']['retrieval_status']=='acquisition_requested':
  assert x['retrieval_status']==x['access']['retrieval_status']=='acquisition_requested'
  assert x['question_count'] is None and x['full_text_screen_status']=='not_screened_retrieval_incomplete'
  assert x['id'] not in seed_manifest
assert seed_manifest['UNL-SEM-D084']['text_method']=='tesseract_ocr_all_188_pages'
assert sum(x['publisher_open_access_notice'] is True for x in retrieval['rows'])==2
assert sum(x['publisher_page_title'] is not None for x in retrieval['rows'])==94
assert all(x['download_controls'] for x in retrieval['rows'])
assert all(a.get('response_kind')=='browser_challenge' for x in retrieval['rows'] for a in x['archive_attempts'] if a['status']==403)
queries=load(D/'retrieval-searches.json')
assert queries['query_count']==sum(len(x['queries']) for x in queries['batches'])==99
assert {i for x in queries['batches'] for i in x['seed_ids']}=={x['id'] for x in s}
for task in seed_screens['project_derived_followups']:
 assert not task['source_authors_asked_this_exact_mathematical_question'] and not task['eligible_for_coverage']
assert all(x['year']>=2001 and x['record_kind']=='doctoral_dissertation' for x in s)
assert all(x['search_ids'] for x in a)
searchids={x['id'] for x in search};assert all(set(x['search_ids'])<=searchids for x in a)
assert len(w)==tot['selected_works']==41 and len({x['id'] for x in w})==41
allowed_work_retrieval={'retrieved','access_gap','acquisition_requested'}
assert {x['retrieval']['status'] for x in w}<=allowed_work_retrieval
for x in w:
 if x['retrieval']['status']=='acquisition_requested':
  assert x['question_count'] is None and x['screen_status']=='full_text_access_gap'
by={x['id']:x for x in w};seedids={x['id'] for x in s}
assert all(set(x['seed_ids'])<=seedids and x['authors'] and x['title'] and x['url'].startswith('https://') for x in w)
assert sum(x['screen_status']=='full_text_screened' for x in w)==screen['full_text_paper_screens']==tot['full_text_screens']==24
assert sum(x['screen_status']=='full_text_access_gap' for x in w)==screen['access_gap_papers']==17
assert len(q)==tot['method_directions']==10 and not any(x['eligible_for_coverage'] for x in q)
for author in a:
 for id in author['selected_work_ids']:
  assert author['seed_id'] in by[id]['seed_ids']
  assert not by[id].get('relationship','').startswith('independent_citation')
 for id in author.get('citation_followup_ids',[]):
  assert by[id]['relationship'].startswith('independent_citation')
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
extensions=load(R/'literature/research-reconciliation.json')['indexing_extensions']
e=next(x for x in extensions if x['id']=='unl-sem-seed-2026-10-26')
assert e['id']=='unl-sem-seed-2026-10-26' and e['added_entries']==8 and e['added_eligible_targets']==0
assert e['full_text_screens_added']==14 and e['incomplete_paper_records_added']==12
assert e['seed_records_added']==58 and e['completed_targets_added']==0
later=next(x for x in extensions if x['id']=='unl-sem-cfa-expansion-2026-10-26')
assert later['id']=='unl-sem-cfa-expansion-2026-10-26'
assert later['baseline']==exp['baseline']
assert later['seed_records_added']==len(exp['added_seed_ids'])==41
assert later['added_target_ids']==exp['new_target_ids'] and later['added_entries']==2
assert later['full_text_screens_added']==7 and later['incomplete_paper_records_added']==6
assert set(later['added_paper_ids'])==set(exp['new_work_ids'])
repair=extensions[-1]
assert repair['id']=='unl-sem-retrieval-repair-2026-10-26'
assert repair['added_entries']==repair['added_eligible_targets']==0
assert repair['full_text_screens_added']==3 and repair['incomplete_paper_records_added']==-1
assert repair['existing_gap_sources_completed']==['F139']
assert len(screen['excluded_passages'])==19
assert by['F134']['retrieval']['hash_scope'].startswith('UTF8 transcript')
assert by['F132']['year']==2003 and by['F132']['relationship']=='pre_dissertation_background'
print('PASS:99 dissertation route rechecks;7 complete dissertation screens;1 partial preview excluded;41 associated sources;24 article/work screens;10 gated directions;0 invented precise conjectures.')
