"""Validate recorded Lean build evidence and its source hashes; does not rerun Lean."""
import hashlib, json, pathlib, re
R = pathlib.Path(__file__).resolve().parent.parent
P = R / 'formalization/dyadic-rank'
v = json.loads((P / 'verification.json').read_text())
assert v['build_exit_code'] == v['axiom_check_exit_code'] == 0
assert v['general_conjecture_proved'] is True
assert [c['ell'] for c in v['checked_cases']] == [0, 1, 2]
assert [c['signatures'] for c in v['checked_cases']] == [2, 4, 16]
allowed = {'propext', 'Classical.choice', 'Quot.sound'}
for declaration, axioms in v['declaration_axioms'].items():
    assert set(axioms) <= allowed, (declaration, axioms)
for name in ['rankSupportAt_one', 'rankSupportAt_two', 'rankSupportAt_le_two']:
    assert 'DyadicRank.' + name in v['declaration_axioms']
assert v['structural_new_theorems'] == len(v['structural_declarations']) == 29
assert set(v['structural_declarations']) <= v['declaration_axioms'].keys()
assert v['general_proof_declaration'] == 'DyadicRank.rankSupportConjecture_proved'
assert v['general_proof_declaration'] in v['declaration_axioms']
assert v['generic_ksv_proposition_formalized'] is False
assert v['general_proof_uses_ksv_proposition'] is False
assert len(v['recursive_declarations']) == 26
assert set(v['recursive_declarations']) <= v['declaration_axioms'].keys()
assert v['computational_search']['lean_verified'] is False
assert v['computational_search']['distinct_signatures'] == 45543
for rel, sha in v['sha256'].items():
    assert hashlib.sha256((P / rel).read_bytes()).hexdigest() == sha, rel
for source in list(P.glob('*.lean')) + list((P / 'DyadicRank').glob('*.lean')):
    assert not re.search(r'^\s*(axiom|opaque)\s|\b(sorry|native_decide|ofReduceBool)\b', source.read_text(), re.M), source
rows = json.loads((R / 'literature/open-problems.json').read_text())
target = next(r for r in rows if r['id'] == v['claim_id'])
assert target['lean_statement_status'] == 'verified_lean_statement'
assert target['lean_proof_status'] == 'verified_complete_lean_proof'
assert target['verified_artifact']['checked_dimensions'] == 'all_natural_dimensions'
print('Verified source hashes, successful-build records, standard axioms, and ledger scope for the dyadic Lean pilot and the unrestricted dyadic rank/support proof. Rerun lake build and Checks.lean to independently recheck proofs.')
