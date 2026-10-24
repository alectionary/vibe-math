"""Validate source-question harvesting coverage and provenance, not mathematical truth."""
from pathlib import Path
import json,hashlib,re,collections
R=Path(__file__).resolve().parents[1];D=R/'literature';load=lambda n:json.loads((D/n).read_text());sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
a=load('research-question-screening.json');rows=load('open-problems.json');by={r['id']:r for r in rows};index={s['id']:s for s in load('research-source-index.json')['sources']};manifest={s['paper_id']:s for s in load('downstream-source-manifest.json')};coverage={c['paper_id']:c for c in load('downstream-paper-coverage.json')};rec=load('research-reconciliation.json');e=next(e for e in rec['indexing_extensions'] if e['id']==a['id'])
origins={'formalization/absorbing-four-two/prior-art.json','formalization/absorbing-four-two/followup-complex/literature-followup.json','formalization/absorbing-four-zero/prior-art.json','formalization/lift-label-elimination/prior-art.json'}
expected={s['id'] for s in index.values() if s.get('provenance_ledger') in origins}
for ledger in origins:
 expected.update(s['id'] for s in json.loads((R/ledger).read_text())['sources'])
accounted={p['source_index_id'] for p in a['papers']}|{p['source_index_id'] for p in a['non_papers']}
assert expected<=accounted and len(expected)==39
assert len(a['papers'])==len({p['source_index_id'] for p in a['papers']})==a['paper_works_reviewed']
assert a['full_text_paper_works_screened']==sum(p['status']=='full_text_screened' for p in a['papers'])
assert a['paper_works_with_access_gaps']==sum(p['status']=='full_text_unavailable' for p in a['papers'])
assert a['additional_later_version_gaps']==len(a['later_version_gaps']) and all(p['target_count'] is None for p in a['later_version_gaps'])
assert a['non_paper_records_excluded']==len(a['non_papers'])==2
assert a['unverified_leads']==len(a['unverified_paper_leads'])==1
assert all(p['paper_id'] is None and p['target_count'] is None for p in a['unverified_paper_leads'])
ids=a['added_target_ids'];assert len(ids)==len(set(ids))==a['added_entries']==e['added_entries']
assert set(ids)==set(e['added_target_ids'])
assert sum(by[i]['eligible_for_coverage'] for i in ids)==a['added_eligible_targets']==e['added_eligible_targets']
assert a['completed_targets_added']==e['completed_targets_added']==0
later=rec['indexing_extensions'][rec['indexing_extensions'].index(e)+1:]
assert len(rows)==a['baseline']['canonical_entries']+a['added_entries']+sum(x['added_entries'] for x in later)
assert sum(r['eligible_for_coverage'] for r in rows)==a['baseline']['eligible_targets']+a['added_eligible_targets']+sum(x['added_eligible_targets'] for x in later)
assert len(coverage)==a['baseline']['paper_records']+a['new_paper_records']+sum(len(x['added_paper_ids']) for x in later)
assert sum(c['coverage_status'].endswith('full_text_screened') for c in coverage.values())==a['baseline']['full_text_screens']+a['full_text_screens_added']+sum(x['full_text_screens_added'] for x in later)
assert a['baseline']['verified_complete_lean_targets']==4
assert sum(r['eligible_for_coverage'] and r['lean_proof_status']=='verified_complete_lean_proof' for r in rows)==a['baseline']['verified_complete_lean_targets']+1  # later parameter-question completion
linked=[]
for p in a['papers']:
 assert p['paper_id'] in coverage and p['source_index_id'] in index
 assert index[p['source_index_id']]['question_screening']['status']==p['status']
 assert p['recorded_target_ids']==sorted(set(p['recorded_target_ids']))
 if p['status']=='full_text_screened':
  assert p['target_count']==len(p['recorded_target_ids'])
  assert p.get('source_sha256') and p.get('extracted_text_sha256') and p.get('extracted_lines',0)>100
  assert p['target_count']>0 or p['outcome']=='no_additional_explicit_question_identified'
 else:
  assert p['target_count'] is None and not p['new_target_ids'] and p['outcome']=='access_gap_not_zero_questions'
 for f,h in [('source_local_file','source_sha256'),('extracted_text_file','extracted_text_sha256')]:
  if p.get(f) and (R/p[f]).exists():assert sha(R/p[f])==p[h],p['source_index_id']
 for i in p['recorded_target_ids']:
  assert i in by
  assert any(o['source_id']==p['paper_id'] for o in by[i]['occurrences']),(p['source_index_id'],i)
 for i in p['new_target_ids']:
  linked.append(i);r=by[i];assert i in ids and r['current_resolution_status']=='not_independently_established'
  assert r['lean_statement_status']==r['lean_proof_status']=='not_assessed_in_this_extension'
  assert r['source_screening']=='literature/research-question-screening.json'
  o=next(o for o in r['occurrences'] if o['source_id']==p['paper_id']);assert o['source_sha256']==p['source_sha256']
  lo,hi=o['extracted_text_lines'];assert 0<lo<=hi<=p['extracted_lines']
assert sorted(linked)==sorted(ids)
assert a['new_question_contributing_papers']==sum(bool(p['new_target_ids']) for p in a['papers'])
assert a['all_question_contributing_papers']==sum(bool(p['recorded_target_ids']) for p in a['papers'])
assert a['full_text_papers_without_additional_questions']==sum(p['status']=='full_text_screened' and not p['recorded_target_ids'] for p in a['papers'])
for m in a['merged_occurrences']:assert any(o['source_id']==index[m['source_index_id']]['bibliography_id'] for o in by[m['target_id']]['occurrences'])
for x in a['excluded_or_resolved_passages']:assert x['source_index_id'] in index and x['locator'] and x['reason']
assert a['held_conjectures']==[i for i in ids if by[i]['kind']=='conjecture' and not by[i]['eligible_for_coverage']]
doc=(D/'RESEARCH-QUESTION-SCREENING.md').read_text()
for p in a['papers']:assert p['paper_id'] in doc and p['title'] in doc
for i in ids:assert i in doc
for href in re.findall(r'\]\(([^)]+)\)',doc):
 if not href.startswith(('http:','https:','#')):assert (D/href.split('#')[0]).exists(),href
print(f"PASS: {a['paper_works_reviewed']} paper works accounted for; {a['full_text_paper_works_screened']} full texts, {a['paper_works_with_access_gaps']} paper gaps, {a['additional_later_version_gaps']} version gaps; {len(ids)} additions, {a['added_eligible_targets']} eligible; no new proof claims.")
