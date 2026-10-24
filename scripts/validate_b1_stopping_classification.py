"""Validate the classification checkpoint and shared zero-delta records; Lean checks proofs."""
from pathlib import Path
import json,hashlib,re
R=Path(__file__).resolve().parents[1];D=R/'literature';A=R/'formalization/stopping-bound/classification'
load=lambda p:json.loads(p.read_text());sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
rows=load(D/'open-problems.json');by={x['id']:x for x in rows};rec=load(D/'research-reconciliation.json')
assert len(rows)==267 and sum(x['eligible_for_coverage'] for x in rows)==135
assert len(load(D/'downstream-paper-coverage.json'))==110
assert sum(x['eligible_for_coverage'] and x['lean_proof_status']=='verified_complete_lean_proof' for x in rows)==5
parent=by['L-F16-stopping-bound'];assert parent['lean_proof_status']=='verified_complete_lean_proof'
assert parent['current_resolution_status']=='answered_negatively_for_prop51_useful_parameter_question'
b=next(x for x in rec['research_blocks'] if x['id']=='b1-stopping-classification-2026-10-24')
assert b['canonical_entry_delta']==b['eligible_target_delta']==b['complete_canonical_lean_target_delta']==0
q=next(x for x in rec['project_derived_followups'] if x['id']=='RQ-F16-minimum-support-classification')
assert q['status']=='completed_for_the_exact_882_column_source_matrix' and not q['eligible_for_coverage'] and not q['source_authors_asked_this_exact_question']
v=load(A/'verification.json');assert v['status']=='passed' and v['build']['exit_code']==v['axiom_audit']['exit_code']==0
assert v['new_source_modules']==6 and v['declarations_audited']==45
for p,m in v['files'].items():assert sha(A/p)==m['sha256'],p
for p,m in v['inherited_sources'].items():
 assert sha(A/'dependencies'/p)==m['sha256']
 assert sha(R/m['parent_path'])==m['sha256']
assert len(v['inherited_sources'])==13
names=load(A/'audit-declarations.json');log=(A/'axiom-audit.log').read_text();assert len(names)==len(set(names))==45
assert 'error:' not in log and 'sorryAx' not in log and 'Lean.ofReduceBool' not in log
assert set(v['axiom_audit']['axioms'])<=set(['propext','Classical.choice','Quot.sound'])
for p in A.glob('Classification*.lean'):assert not re.search(r'\b(sorry|admit|axiom|native_decide)\b|Lean\.ofReduceBool',p.read_text())
for n in ['classifiesList_sound','normalized_classification_certificate','size_six_classification','rowSupport_injective','translation_free','minimumSupports_card','binary_source_classification','source_complete_certificate','binary_source_structure']:assert n in log,n
c=load(A/'full-root-check.json');assert c['roots']==882 and c['size_six_supports']==441 and c['equals_all_companion_rows']
assert len({tuple(x) for x in c['all_supports']})==441 and all(len(x)==6 for x in c['all_supports'])
p=load(A/'prior-art.json');assert p['new_full_texts_consulted']==p['new_full_text_screens']==p['new_paper_records']==p['new_source_questions']==0
assert v['canonical_completion_delta']==0
print('PASS: complete source-B1 classification, 45-declaration audit, 13 unchanged inherited modules, actual binary/count/free-orbit bridges; historical cohort267/135/110/97/4 preserved; current complete-target count5.')
