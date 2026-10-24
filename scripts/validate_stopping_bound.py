"""Validate the dated obstruction artifact and source-screen delta; Lean checks the proofs."""
from pathlib import Path
import json,hashlib,re
R=Path(__file__).resolve().parents[1];D=R/'literature';A=R/'formalization/stopping-bound'
load=lambda p:json.loads(p.read_text());sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
s=load(D/'stopping-bound-source-screening.json');rec=load(D/'research-reconciliation.json')
e=next(x for x in rec['indexing_extensions'] if x['id']==s['id'])
rows=load(D/'open-problems.json');by={x['id']:x for x in rows};ids=s['added_target_ids']
assert len(ids)==len(set(ids))==s['added_entries']==e['added_entries']==10
assert not any(by[i]['eligible_for_coverage'] for i in ids)
assert e['added_eligible_targets']==s['added_eligible_targets']==0
later=rec['indexing_extensions'][rec['indexing_extensions'].index(e)+1:]
assert len(rows)==262+sum(x['added_entries'] for x in later) and sum(x['eligible_for_coverage'] for x in rows)==135+sum(x['added_eligible_targets'] for x in later)
assert len(s['papers'])==s['new_paper_records']==len(e['added_paper_ids'])==6
assert sum(x['status']=='full_text_screened' for x in s['papers'])==s['full_text_screens_added']==4
assert sum(x['target_count'] is None for x in s['papers'])==2
assert s['completed_targets_added']==e['completed_targets_added']==0
linked=[]
for p in s['papers']:
 for i in p['new_target_ids']:
  linked.append(i);x=by[i]
  assert x['source_screening']=='literature/stopping-bound-source-screening.json'
  assert x['lean_statement_status']==x['lean_proof_status']=='not_assessed_in_this_extension'
  assert x['current_resolution_status']=='not_independently_established'
  o=next(o for o in x['occurrences'] if o['source_id']==p['paper_id'])
  lo,hi=o['extracted_text_lines'];assert 0<lo<=hi<=p['extracted_lines']
  assert o['source_sha256']==p['source_sha256']
 if p['status']=='full_text_screened':
  assert p['target_count']==len(p['recorded_target_ids'])
  assert sha(R/p['source_local_file'])==p['source_sha256']
  assert sha(R/p['extracted_text_file'])==p['extracted_text_sha256']
 else:assert p['target_count'] is None and not p['recorded_target_ids']
assert sorted(linked)==sorted(ids)
t=by['L-F16-stopping-bound'];assert t['lean_proof_status']=='verified_complete_lean_proof'
assert t['current_resolution_status']=='answered_negatively_for_prop51_useful_parameter_question'
assert sum(x['eligible_for_coverage'] and x['lean_proof_status']=='verified_complete_lean_proof' for x in rows)==5
v=load(A/'verification.json');assert v['status']=='passed'
assert v['build']['exit_code']==v['axiom_audit']['exit_code']==0
assert sha(A/'Spectral.lean')==v['files']['Spectral.lean']['sha256']
assert sha(A/'Audit.lean')==v['files']['Audit.lean']['sha256']
text=(A/'Spectral.lean').read_text();assert not re.search(r'\b(sorry|admit|axiom)\b',text)
assert len(re.findall(r'^(?:noncomputable )?(?:lemma|theorem|def) (\w+)',text,re.M))==v['declarations_audited']
log=(A/'axiom-audit.log').read_text();assert 'sorryAx' not in log and 'error:' not in log
assert set(v['axiom_audit']['axioms'])<=set(['propext','Classical.choice','Quot.sound'])
for name in ['qc_scalar_factor_no_source_regime','scalar_one_row_source_obstruction','running_882_scalar_obstruction','denseExample_source_certificate']:
 assert name in text and name in log
print('PASS: actual-matrix obstruction artifact, all-declaration audit, 10 broad directions, 6 sources, 4 full-text screens, 2 named gaps; no canonical completion increment.')
