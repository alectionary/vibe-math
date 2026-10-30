"""Exact reconstruction of a generalized joint LP endpoint; replay required."""
from pathlib import Path
from fractions import Fraction as Q
import argparse
import json
import os
import time

from two_basis_joint_general_star import ROOT, sha, read, decode, empty, plus
from verify_two_sided_full_basis_oracle import point_owner
from export_joint_general_exact_lp import semantic_rows
from read_soplex_exact_output import read_named_rational


def evaluate(expression, features, parameters):
    return sum((v*features[j] for j, v in expression[0].items()), Q(0)) + sum(
        (v*parameters[j] for j, v in expression[1].items()), Q(0))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--manifest', type=Path, required=True)
    ap.add_argument('--solver-frozen', type=Path, required=True)
    mode = ap.add_mutually_exclusive_group(required=True)
    mode.add_argument('--primal', type=Path)
    mode.add_argument('--farkas', type=Path)
    ap.add_argument('--output', type=Path, required=True)
    a = ap.parse_args(); start = time.monotonic()
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19 and not a.output.exists()
    manifest, solver = read(a.manifest), read(a.solver_frozen)
    assert manifest['status'] == 'PASS_EXACT_GENERAL_LP_FRACTION_TEXT_ROUNDTRIP'
    assert solver['status'] == 'FROZEN_SINGLE_EXACT_GENERAL_SOPLEX_TRIAL'
    assert solver['input_manifest_sha256'] == sha(a.manifest)
    assert solver['input_lp_sha256'] == manifest['lp_sha256'] == sha(manifest['lp'])
    assert solver['semantic_sha256'] == manifest['semantic_sha256'] == sha(manifest['semantic'])
    saved = read(manifest['semantic']); model = decode(saved['model'])
    assert saved['point_sha256'] == sha(saved['point'])
    assert all(sha(ROOT/p) == h for p, h in model['source_hashes'].items())
    features = list(map(Q, saved['feature_values']))
    assert features == [Q(1), *point_owner(saved['point'])]
    assert saved['zero_tau_pins'] == manifest['zero_tau_pins'] == solver['zero_tau_pins']
    rows = list(semantic_rows(model, features, saved['zero_tau_pins']))
    assert [dict(name=kind+str(index), kind=kind, index=index)
            for kind, index, relation, expression, constant in rows] == saved['row_labels']
    paths = [a.manifest, a.solver_frozen, Path(manifest['semantic']),
             Path(__file__), Path('read_soplex_exact_output.py')]
    out = dict(manifest=str(a.manifest), manifest_sha256=sha(a.manifest),
               semantic_sha256=manifest['semantic_sha256'], point=saved['point'],
               point_sha256=saved['point_sha256'], zero_tau_pins=saved['zero_tau_pins'],
               source_C16_answered=False, nice=os.getpriority(os.PRIO_PROCESS, 0))
    if a.primal:
        assert any(part == '-X='+str(a.primal.resolve()) for part in solver['command'])
        n = len(model['variables'])
        named = read_named_rational(a.primal, ['x'+str(j) for j in range(n)])
        x = [named['x'+str(j)] for j in range(n)]
        slacks = []
        for kind, index, relation, expression, constant in rows:
            v = evaluate(expression, features, x)
            assert v == 0 if relation == '=' else v <= 0, (kind, index, str(v))
            if relation == '<=': slacks.append(-v)
        lam = [evaluate(e, features, x) for e in model['lambda_expressions']]
        y = {side: [[evaluate(e, features, x) for e in row]
                    for row in model['sectors'][side]['allocations']] for side in ['X', 'Z']}
        out.update(status='EXACT_GENERAL_JOINT_ALLOCATION_REQUIRES_REPLAY',
                   lambda_masses=list(map(str, lam)),
                   exact_allocations={s: [list(map(str, row)) for row in y[s]] for s in y},
                   exact_parameters=list(map(str, x)), exact_rows_checked=len(rows),
                   minimum_exact_slack=str(min(slacks)),
                   maximum_parameter_denominator_bits=max(v.denominator.bit_length() for v in x),
                   scope='Exact finite listed-row allocation only; independent physical replay required.')
        paths.append(a.primal)
    else:
        assert any(part == '-Y='+str(a.farkas.resolve()) for part in solver['command'])
        named = read_named_rational(a.farkas, [r['name'] for r in saved['row_labels']], 'farkas')
        attempts = []
        proof = None
        for sign in [-1, 1]:
            weights = [sign*named[label['name']] for label in saved['row_labels']]
            if any(w < 0 for w, r in zip(weights, rows) if r[2] == '<='):
                attempts.append(dict(sign=sign, status='NEGATIVE_INEQUALITY_MULTIPLIER'))
                continue
            combined = empty()
            for w, r in zip(weights, rows):
                if w: combined = plus(combined, r[3], w)
            gap = sum((v*features[j] for j, v in combined[0].items()), Q(0))
            attempts.append(dict(sign=sign, residual_variables=len(combined[1]), exact_gap=str(gap)))
            if not combined[1] and gap > 0:
                proof = dict(sign=sign, exact_gap=str(gap),
                             row_multipliers=[[i, str(w)] for i, w in enumerate(weights) if w],
                             owner_target_coefficients=[[j, str(v)] for j, v in sorted(combined[0].items())],
                             exact_cancellation=True)
                break
        assert proof is not None, ('No exact Farkas contradiction', attempts)
        out.update(status='EXACT_GENERAL_JOINT_FARKAS_REQUIRES_REPLAY', proof=proof,
                   attempts=attempts,
                   scope=('Chosen zero-high anchor law excluded only' if saved['zero_tau_pins'] else
                          'General shared-law relaxation target exclusion candidate')+
                         '; independent source-row replay required.')
        paths.append(a.farkas)
    out['source_bindings'] = {str(p): sha(p) for p in paths}
    out['elapsed_seconds'] = time.monotonic()-start
    a.output.write_text(json.dumps(out, indent=2)+'\n')
    print({k: v for k, v in out.items() if k not in
           ['exact_allocations', 'exact_parameters', 'proof', 'source_bindings']}, flush=True)


if __name__ == '__main__': main()
