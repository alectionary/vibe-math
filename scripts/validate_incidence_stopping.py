"""Validate checkpoint provenance and inventory; Lean validates mathematical proofs."""
from pathlib import Path
import json,hashlib,re
R=Path(__file__).resolve().parents[1];D=R/'literature';A=R/'formalization/stopping-bound/incidence'
load=lambda p:json.loads(p.read_text());sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
s=load(D/'incidence-stopping-source-screening.json');rec=load(D/'research-reconciliation.json');rows=load(D/'open-problems.json');by={x['id']:x for x in rows}
e=next(x for x in rec['indexing_extensions'] if x['id']==s['id']);later=rec['indexing_extensions'][rec['indexing_extensions'].index(e)+1:]
assert len(rows)==267+sum(x['added_entries'] for x in later)
assert sum(x['eligible_for_coverage'] for x in rows)==135+sum(x['added_eligible_targets'] for x in later)
assert len(s['added_target_ids'])==s['added_entries']==e['added_entries']==5
assert s['added_eligible_targets']==e['added_eligible_targets']==s['completed_targets_added']==e['completed_targets_added']==0
assert len(s['papers'])==s['new_paper_records']==4
assert sum(p['status']=='full_text_screened' for p in s['papers'])==s['full_text_screens_added']==3
assert sum(p['target_count'] is None for p in s['papers'])==1
linked=[]
for p in s['papers']:
 for i in p['new_target_ids']:
  linked.append(i);x=by[i]
  assert not x['eligible_for_coverage']
  assert x['lean_statement_status']==x['lean_proof_status']=='not_assessed_in_this_extension'
  assert x['current_resolution_status']=='not_independently_established'
  o=next(o for o in x['occurrences'] if o['source_id']==p['paper_id']);lo,hi=o['extracted_text_lines']
  assert 0<lo<=hi<=p['extracted_lines'] and o['source_sha256']==p['source_sha256']
 if p['status']=='full_text_screened':
  assert p['target_count']==len(p['recorded_target_ids'])
  assert sha(R/p['source_local_file'])==p['source_sha256']
  assert sha(R/p['extracted_text_file'])==p['extracted_text_sha256']
 else:assert p['target_count'] is None and not p['recorded_target_ids']
assert sorted(linked)==sorted(s['added_target_ids'])
t=by['L-F16-stopping-bound'];assert t['current_resolution_status']=='answered_negatively_for_prop51_useful_parameter_question' and t['lean_proof_status']=='verified_complete_lean_proof'
assert sum(x['eligible_for_coverage'] and x['lean_proof_status']=='verified_complete_lean_proof' for x in rows)==5
v=load(A/'verification.json');assert v['status']=='passed' and v['build']['exit_code']==v['axiom_audit']['exit_code']==0
assert v['declarations_audited']==100 and v['new_source_modules']==12 and v['canonical_completion_delta']==0
for path,m in v['files'].items():assert sha(A/path)==m['sha256'],path
assert sha(A/'dependencies/Spectral.lean')==sha(A.parent/'Spectral.lean')=='a3e712b2a206bd7743408ecc122e66e7d980dbd4689c6d49977536dfe9bb469d'
names=load(A/'audit-declarations.json');log=(A/'axiom-audit.log').read_text();assert len(names)==len(set(names))==100
assert 'error:' not in log and 'sorryAx' not in log and 'Lean.ofReduceBool' not in log
assert set(v['axiom_audit']['axioms'])<=set(['propext','Classical.choice','Quot.sound'])
for p in A.glob('Incidence*.lean'):assert not re.search(r'\b(sorry|admit|axiom|native_decide)\b|Lean\.ofReduceBool',p.read_text())
for n in ['positive_family','source_B1_stopping_distance_six','second_lower_twelve','zhu_chugg_bounds_negative','normalized_roots_reject','stopping_cover_image','HX2_incidence','six_is_HZ_row','css']:assert n in log,n
c=load(A/'crosscheck.json');assert len(c['domains'])==8 and c['domains'][0]['search']['roots']==882
assert all(p['search']['stopping_supports_at_most_five']==0 for p in c['domains'])
assert load(A/'source-screening.json')==s
print('PASS:12 checked proof modules, complete100-declaration audit, source/CSS/cover/spectral bridges;5 directions,3 screens,1 gap; canonical completion delta0.')
