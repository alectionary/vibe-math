"""Check the all-parameter answer artifact's bookkeeping; Lean checks its proofs."""
from pathlib import Path
import json,hashlib,re
R=Path(__file__).resolve().parents[1];A=R/'formalization/stopping-bound/source-answer'
load=lambda p:json.loads(p.read_text());sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
v=load(A/'verification.json');assert v['status']=='passed'
for rel,x in v['files'].items():assert sha(A/rel)==x['sha256'],rel
assert v['build']['exit_code']==v['axiom_audit']['exit_code']==0
assert v['build']['jobs']==5470
assert v['parameter_component_status']=='resolved_negative'
assert sha(A/'dependencies/Spectral.lean')==sha(R/'formalization/stopping-bound/Spectral.lean')
text=(A/'SourceQuestionAnswer.lean').read_text();assert not re.search(r'\b(sorry|admit|axiom|native_decide)\b|Lean\.ofReduceBool',text)
assert len(re.findall(r'^theorem ',text,re.M))==2
assert '¬ (eigs' in text and '2 < sourceLargeRoot' in text
log=(A/'axiom-audit.log').read_text();assert 'sorryAx' not in log and 'error:' not in log
assert set(v['axiom_audit']['axioms'])<=set(['propext','Classical.choice','Quot.sound'])
t=next(x for x in load(R/'literature/open-problems.json') if x['id']=='L-F16-stopping-bound')
assert t['parameter_question_status']=='answered_negatively_by_universal_checked_nonexistence_proof'
assert t['scope_components'][0]['status']=='resolved_negative_for_every_parameter_in_prop51_stated_model'
assert t['remaining_source_direction']['distinct_from_answered_parameter_question']
assert t['scope_components'][1]['status']=='not_resolved'
assert v['new_question_delta']==v['new_paper_delta']==v['new_full_text_screen_delta']==v['canonical_completion_delta']==0
print('PASS: universal nonexistence theorem, both cases and small-branch coverage, unchanged parent source, source scope and separate incidence-positive and restricted spectral follow-up tracked.')
