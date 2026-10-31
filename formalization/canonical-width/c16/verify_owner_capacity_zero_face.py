#!/usr/bin/env python3
"""Independent exact face map/text/proof replay; no producer or solver import."""
import os
assert os.nice(0) == 19
for key in ['OPENBLAS_NUM_THREADS', 'OMP_NUM_THREADS', 'MKL_NUM_THREADS',
            'VECLIB_MAXIMUM_THREADS', 'NUMEXPR_NUM_THREADS', 'BLIS_NUM_THREADS']:
    assert os.environ.get(key) == '1'
from fractions import Fraction as Q
from pathlib import Path
import argparse
import copy
import hashlib
import json
import time
from verify_owner_star_capacity_extension import labels_and_rows
from verify_owner_star_flow_extension import decode_model, empty, term, add, read
from verify_two_sided_full_basis_oracle import point_owner

ROOT = Path(__file__).resolve().parent
def sha(p): return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def rational(s):
    assert type(s) is str
    q = Q(s); assert str(q) == s
    return q
def at(e, features): return sum((v*features[j] for j, v in e[0].items()), Q(0))

def partition(mapping, n):
    keep = mapping['retained_variables']; records = mapping['eliminated']
    gone = [r['variable'] for r in records]
    assert all(type(i) is int and 0 <= i < n for i in keep+gone)
    assert keep == sorted(set(keep)) and gone == sorted(set(gone))
    assert not set(keep) & set(gone) and sorted(keep+gone) == list(range(n))
    return keep, records

def proof_sum(proof, rows):
    total = empty(); assert proof
    for name, weight in proof:
        assert type(name) is str and name in rows
        relation, expression, _ = rows[name]
        assert relation == '<='
        weight = rational(weight); assert weight >= 0
        total = add(total, expression, weight)
    return total

def validate_zero_proofs(M, features, rows, mapping):
    keep, records = partition(mapping, len(M['variables']))
    tau = {i for i, v in enumerate(M['variables']) if v['kind'] == 'tau'}
    assert len(tau) == 5
    zero = []
    for m, mass in enumerate(M['lambda_expressions']):
        assert set(mass[1]) <= tau and at(mass, features) >= 0
        if at(mass, features) == 0: zero.append(m)
    assert mapping['zero_masks'] == zero and mapping['zero_tau_pins'] is True
    meta = M['owner_flow_extension']; edges = {tuple(p):i for i, p in enumerate(meta['physical_pairs'])}
    structural = {(d['mask'], d['edge']) for d in M['inequalities']
                  if d['kind'] == 'owner_flow_bound' and d['bound'] == 'structural_zero'}
    expected = {}
    for i, v in enumerate(M['variables']):
        if v['kind'] == 'tau': expected[i] = ('explicit_zero_tau_pin', None)
        elif v['kind'] == 'allocation':
            if v['mask'] in zero:
                assert M['sectors'][v['side']]['allocations'][v['mask']][v['index']] == term(1, i)
                expected[i] = ('zero_pattern_mass_allocation', M['lambda_expressions'][v['mask']])
        else:
            assert v['kind'] == 'owner_joint'
            edge = edges[v['X_index'], v['Z_index']]
            if (v['mask'], edge) in structural: expected[i] = ('explicit_structural_zero', empty())
            elif v['mask'] in zero: expected[i] = ('zero_pattern_mass_joint', M['lambda_expressions'][v['mask']])
    assert [r['variable'] for r in records] == list(expected)
    counts = {}
    for record in records:
        i = record['variable']; reason, mass = expected[i]
        assert record['reason'] == reason
        counts[reason] = counts.get(reason, 0)+1
        if reason == 'explicit_zero_tau_pin':
            assert record['pin'] == 'zero_tau'+str(i)
            relation, e, constant = rows[record['pin']]
            assert relation == '=' and e == term(1, i) and constant == 0
        else:
            assert proof_sum(record['lower'], rows) == term(1, i, -1)
            assert proof_sum(record['upper'], rows) == add(term(1, i), mass, -1)
            assert set(mass[1]) <= tau and at(mass, features) == 0
            assert record['zero_mass_mask'] == (None if mass == empty() else M['variables'][i]['mask'])
    return keep, records, counts

def lift_residual(expression, records, rows):
    """Independent signed lift of omitted-variable residuals into full rows."""
    out = copy.deepcopy(expression); used = []
    for record in records:
        if record['reason'] == 'explicit_zero_tau_pin': continue
        r = out[1].get(record['variable'], Q(0))
        if not r: continue
        branch = record['lower'] if r > 0 else record['upper']
        for name, weight in branch:
            coefficient = abs(r)*rational(weight)
            assert rows[name][0] == '<=' and coefficient >= 0
            out = add(out, rows[name][1], coefficient)
            used.append((name, coefficient))
        assert record['variable'] not in out[1]
    for record in records:
        if record['reason'] != 'explicit_zero_tau_pin': continue
        r = out[1].get(record['variable'], Q(0))
        if r:
            assert rows[record['pin']][0] == '='
            out = add(out, rows[record['pin']][1], -r)
            used.append((record['pin'], -r))
    assert not out[1], 'unproved or retained residual remains'
    return out, used

def controls(M, features, rows, mapping, records):
    rejected = []
    def reject(name, fn):
        try: fn()
        except (AssertionError, KeyError): rejected.append(name)
        else: raise AssertionError('accepted '+name)
    bad = dict(mapping, retained_variables=mapping['retained_variables'][:-1])
    reject('missing-partition-variable', lambda: partition(bad, len(M['variables'])))
    bad = dict(mapping, retained_variables=mapping['retained_variables']*2)
    reject('duplicate-partition-variable', lambda: partition(bad, len(M['variables'])))
    example = next(r for r in records if r['reason'] != 'explicit_zero_tau_pin')
    bad = copy.deepcopy(example['upper']); bad[0][1] = '-1'
    reject('negative-upper-proof-weight', lambda: proof_sum(bad, rows))
    reject('unknown-proof-row', lambda: proof_sum([['not-a-row', '1']], rows))
    reject('retained-residual', lambda: lift_residual(term(1, mapping['retained_variables'][0]), records, rows))
    examples = {}
    for r in records:
        if r['reason'] != 'explicit_zero_tau_pin': examples.setdefault(r['reason'], r)
    checks = []
    for reason, r in examples.items():
        for coefficient in [Q(-2, 3), Q(5, 7)]:
            before = add(term(0, 0, 7), term(1, r['variable'], coefficient))
            after, used = lift_residual(before, records, rows)
            assert at(before, features) == at(after, features) == 7
            checks.append(dict(reason=reason, coefficient=str(coefficient), added_rows=len(used)))
    # Synthetic zero mass includes a target term f with f(current)=0. A negative
    # residual must change the target coefficient by -|r|f, not silently erase it.
    toy = {'lower': ('<=', term(1, 1, -1), Q(0)),
           'upper': ('<=', add(add(term(1, 1), term(1, 0), -1), term(0, 1), -1), Q(0)),
           'pin': ('=', term(1, 0), Q(0))}
    toy_records = [dict(variable=0, reason='explicit_zero_tau_pin', pin='pin'),
                   dict(variable=1, reason='zero_pattern_mass_allocation',
                        lower=[['lower', '1']], upper=[['upper', '1']])]
    negative, added = lift_residual(add(term(0, 0), term(1, 1, -2)), toy_records, toy)
    assert negative == ({0: Q(1), 1: Q(-2)}, {})
    assert added == [('upper', Q(2)), ('pin', Q(2))]
    positive, _ = lift_residual(add(term(0, 0), term(1, 1, 3)), toy_records, toy)
    assert positive == term(0, 0)
    return dict(actual_residual_lifts=checks, target_dependent_negative_lift=[[j, str(v)] for j, v in negative[0].items()],
                negative_lift_pin_weight='2', corruptions_rejected=rejected)

def verify(a):
    face = read(a.manifest)
    assert face['status'] == 'PASS_EXACT_ZERO_FACE_LP_TEXT_ROUNDTRIP'
    assert face['mapping_sha256'] == sha(face['mapping']) and face['lp_sha256'] == sha(face['lp'])
    mapping = read(face['mapping'])
    assert mapping['status'] == 'EXACT_ZERO_FACE_MAP_REQUIRE_INDEPENDENT_REPLAY'
    assert face['zero_tau_pins'] is mapping['zero_tau_pins'] is True
    assert face['full_manifest_sha256'] == mapping['full_manifest_sha256'] == sha(face['full_manifest'])
    assert face['full_manifest'] == mapping['full_manifest']
    full = read(face['full_manifest'])
    assert full['status'] == 'PASS_EXACT_OWNER_FLOW_CAPACITY_LP_FRACTION_TEXT_ROUNDTRIP'
    assert face['semantic'] == mapping['full_semantic'] == full['semantic']
    assert face['semantic_sha256'] == mapping['full_semantic_sha256'] == full['semantic_sha256'] == sha(full['semantic'])
    assert full['lp_sha256'] == sha(full['lp'])
    assert face['preparation_receipt'] == mapping['preparation_receipt']
    assert face['preparation_receipt_sha256'] == mapping['preparation_receipt_sha256'] == sha(face['preparation_receipt'])
    prep = read(face['preparation_receipt'])
    assert prep['status'] == 'PASS_EXACT_COMPLETE_SELECTED_OWNER_FLOW_CAPACITY_MODEL'
    assert prep['consumer_sha256'] == sha('verify_owner_star_capacity_extension.py')
    assert prep['manifest_sha256'] == sha(face['full_manifest'])
    assert prep['model_sha256'] == face['semantic_sha256'] and prep['lp_sha256'] == full['lp_sha256']
    saved = read(full['semantic']); assert saved['zero_tau_pins'] is full['zero_tau_pins'] is True
    M = decode_model(saved['model'])
    sources = dict(M['source_hashes'])
    for p, h in mapping['source_hashes'].items():
        assert p not in sources or sources[p] == h
        sources[p] = h
    for p, h in sources.items(): assert sha(p) == h
    features = [Q(1), *point_owner(ROOT/saved['point'])]
    assert features == list(map(rational, saved['feature_values']))
    assert saved['point_sha256'] == face['point_sha256'] == prep['point_sha256'] == sha(saved['point'])
    ordered = list(labels_and_rows(M, True)); rows = {}
    assert [label for label, _, _ in ordered] == saved['row_labels']
    for label, relation, e in ordered:
        assert label['name'] not in rows
        rows[label['name']] = relation, e, at(e, features)
    keep, records, counts = validate_zero_proofs(M, features, rows, mapping)
    renumber = {old:new for new, old in enumerate(keep)}
    def tokens():
        with (ROOT/face['lp']).open() as stream:
            for line in stream: yield from line.split()
    it = iter(tokens()); assert [next(it) for _ in range(7)] == ['Minimize', 'obj:', '+', '0', 'x0', 'Subject', 'To']
    kept_rows, dropped, nz = [], [], 0
    for name, (relation, e, constant) in rows.items():
        coeff = {renumber[j]:v for j, v in e[1].items() if j in renumber}
        if not coeff:
            assert constant == 0 if relation == '=' else constant <= 0
            dropped.append(dict(name=name, relation=relation, constant=str(constant)))
            continue
        kept_rows.append(name)
        assert next(it) == name+':'
        actual = {}; token = next(it)
        while token in ('+', '-'):
            q = Q(next(it))*(1 if token == '+' else -1)
            variable = next(it); assert variable.startswith('x')
            j = int(variable[1:]); assert 0 <= j < len(keep)
            actual[j] = actual.get(j, Q(0))+q; token = next(it)
        assert token == relation and Q(next(it)) == -constant
        assert {j:v for j, v in actual.items() if v} == coeff
        nz += len(coeff)
    assert kept_rows == mapping['retained_rows'] and dropped == mapping['dropped_rows']
    assert next(it) == 'Bounds'
    for j in range(len(keep)): assert [next(it), next(it)] == ['x'+str(j), 'free']
    assert next(it) == 'End' and next(it, None) is None
    assert len(M['variables']) == face['full_variable_count'] and len(keep) == face['variable_count']
    assert len(records) == face['eliminated_variables'] and len(rows) == face['full_row_count']
    assert len(kept_rows) == face['row_count'] and len(dropped) == face['dropped_constant_rows']
    assert nz == face['nonzeros'] and mapping['zero_masks'] == face['zero_masks']
    tiny = controls(M, features, rows, mapping, records)
    dependencies = ['verify_owner_star_capacity_extension.py', 'verify_owner_star_flow_extension.py',
                    'verify_two_sided_full_basis_oracle.py']
    for p in [a.manifest, Path(face['mapping']), Path(face['full_manifest']), Path(full['semantic']),
              Path(face['preparation_receipt']), *map(Path, dependencies), Path(__file__).resolve()]:
        key = str(p.relative_to(ROOT)) if p.is_absolute() else str(p)
        sources[key] = sha(p)
    assert all(sha(p) == h for p, h in sources.items())
    return dict(status='PASS_EXACT_OWNER_CAPACITY_ZERO_FACE_REDUCTION', manifest_sha256=sha(a.manifest),
        mapping_sha256=face['mapping_sha256'], semantic_sha256=face['semantic_sha256'],
        consumer_sha256=sha(Path(__file__).resolve()), source_hashes=sources,
        full_variables=len(M['variables']), retained_variables=len(keep), omitted_variables=len(records),
        omitted_reason_counts=counts, full_rows=len(rows), retained_rows=len(kept_rows),
        dropped_constant_rows=len(dropped), nonzeros=nz, zero_masks=mapping['zero_masks'],
        all_zero_proofs_reconstructed=True, all_reduced_LP_tokens_checked=True, controls=tiny,
        zero_tau_pins=True, target_specific_zero_masses=True, source_C16_answered=False,
        solver_run=False, priority=os.nice(0),
        scope='Equivalent exact face reduction at the given target and explicit zero-tau law; full source-row lift required for any Farkas certificate.')

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--manifest', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True); a = ap.parse_args()
    assert not a.output.exists(); started = time.monotonic()
    result = verify(a); result['elapsed_seconds'] = time.monotonic()-started
    a.output.write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps({k:v for k, v in result.items() if k not in ['source_hashes', 'controls']}), flush=True)

if __name__ == '__main__': main()
