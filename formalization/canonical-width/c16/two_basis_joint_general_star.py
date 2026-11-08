"""UNRUN adapter: append accepted owner stars to the general five-law model.

No module import launches computation. Preparation and solving are explicit
CLI modes. Target expressions are lifted from the 7211 retained features to
[constant1, canonical owner_vector], because arbitrary star T coordinates need
not belong to the 7211-feature subset. All numeric columns have free bounds;
the modeled inequalities supply their probability bounds.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse
import gzip
import json
import math
import time

from two_basis_joint_general_model import (
    ROOT, sha, read, empty, term, plus, encoded, decoded, value,
    decode_model, encode_model, row_expression as base_row_expression,
)
from verify_two_sided_full_basis_oracle import columns, point_owner, target


def owner_expression(expression, feature_map):
    out = empty()
    for j, coefficient in expression[0].items():
        out = plus(out, term(0, feature_map[j], coefficient))
    out[1].update(expression[1])
    return out


def lift_model(base, point):
    owner = point_owner(point)
    feature_map = [0 if j is None else j+1
                   for j in columns(base['X_anchors'], base['Z_anchors'])]
    extended = [Q(1), *owner]
    assert [extended[j] for j in feature_map] == target(
        point, base['X_anchors'], base['Z_anchors'])
    result = dict(base)
    result['source_feature_layout'] = base['feature_layout']
    result['feature_layout'] = 'constant1,canonical_owner_vector[36495]'
    result['feature_count'] = 36496
    result['source_feature_to_owner_target'] = feature_map
    result['lambda_expressions'] = [owner_expression(e, feature_map)
                                    for e in base['lambda_expressions']]
    result['sectors'] = {}
    for side, sector in base['sectors'].items():
        saved = dict(sector)
        saved['allocations'] = [[owner_expression(e, feature_map) for e in row]
                                for row in sector['allocations']]
        saved['local_consistency'] = [owner_expression(e, feature_map)
                                      for e in sector['local_consistency']]
        result['sectors'][side] = saved
    result['inequalities'] = list(base['inequalities'])
    result['source_hashes'] = dict(base['source_hashes'])
    result['star_rows'] = []
    result['star_bindings'] = []
    return result, extended


def compile_star(model, cut):
    assert type(cut['rhs']) is int and cut['rhs'] == 0
    expression = empty()
    for m, coefficient in cut['lambda_coefficients']:
        assert type(m) is int and 0 <= m < 16 and type(coefficient) is int
        expression = plus(expression, model['lambda_expressions'][m], coefficient)
    for side in ('X', 'Z'):
        for m, j, coefficient in cut[side+'_coefficients']:
            assert all(type(v) is int for v in (m, j, coefficient))
            assert 0 <= m < 16 and 0 <= j < 720
            expression = plus(expression,
                              model['sectors'][side]['allocations'][m][j],
                              coefficient)
    for coordinate, coefficient in cut['T_coefficients']:
        assert type(coordinate) is int and 18270 <= coordinate < 36495
        assert type(coefficient) is int
        expression = plus(expression, term(0, coordinate+1, coefficient))
    return expression


def append_stars(model, bindings):
    for bank_path, receipt_path in bindings:
        bank, receipt = read(bank_path), read(receipt_path)
        assert receipt['status'] == 'PASS_EXACT_CONDITIONAL_OWNER_STAR_CUTS'
        assert receipt['bank_sha256'] == sha(bank_path)
        consumers = ['verify_conditional_owner_star.py',
                     'verify_conditional_owner_star_v2.py']
        consumer = next((p for p in consumers
                         if receipt['consumer_sha256'] == sha(ROOT/p)), None)
        assert consumer is not None
        assert bank['X_anchors'] == model['X_anchors']
        assert bank['Z_anchors'] == model['Z_anchors']
        assert bank['source_hashes'] == receipt['source_hashes']
        assert all(sha(ROOT/p) == h for p, h in receipt['source_hashes'].items())
        model['source_hashes'].update(receipt['source_hashes'])
        for path in (bank_path, receipt_path, ROOT/consumer):
            model['source_hashes'][str(path)] = sha(path)
        binding_index = len(model['star_bindings'])
        model['star_bindings'].append(dict(
            bank=str(bank_path), bank_sha256=sha(bank_path),
            receipt=str(receipt_path), receipt_sha256=sha(receipt_path),
            consumer=consumer, consumer_sha256=sha(ROOT/consumer)))
        for index, cut in enumerate(bank['cuts']):
            expression = compile_star(model, cut)
            model['star_rows'].append(dict(binding=binding_index,
                                          cut_index=index,
                                          expression=expression))
            model['inequalities'].append(dict(
                kind='owner_star', star_index=len(model['star_rows'])-1))
    return model


def row_expression(model, descriptor):
    if descriptor['kind'] == 'owner_star':
        return model['star_rows'][descriptor['star_index']]['expression']
    return base_row_expression(model, descriptor)


def encode(model):
    result = encode_model(model)
    result['star_rows'] = [dict(row, expression=encoded(row['expression']))
                           for row in model['star_rows']]
    return result


def decode(model):
    result = decode_model(model)
    result['star_rows'] = [dict(row, expression=decoded(row['expression']))
                           for row in model['star_rows']]
    return result


def probability_bound_guard(model):
    """Exact semantic proof that every retained coordinate lies in [0,1]."""
    total = empty()
    for expression in model['lambda_expressions']:
        total = plus(total, expression)
    assert total == term(0, 0)
    lambda_rows = {d['mask'] for d in model['inequalities']
                   if d['kind'] == 'lambda_nonnegative'}
    boxes = {(d['side'], d['mask'], d['index'], d['bound'])
             for d in model['inequalities'] if d['kind'] == 'box'}
    assert lambda_rows == set(range(16))
    for index, variable in enumerate(model['variables']):
        if variable['kind'] == 'tau':
            expression = empty()
            for mask in range(16):
                if mask & variable['mask'] == variable['mask']:
                    expression = plus(expression, model['lambda_expressions'][mask])
            assert expression == term(1, index)
        else:
            assert variable['kind'] == 'allocation'
            side, mask, j = (variable[k] for k in ('side', 'mask', 'index'))
            assert model['sectors'][side]['allocations'][mask][j] == term(1, index)
            assert all((side, mask, j, bound) in boxes for bound in ('lower', 'upper'))


def exact_projected_combination(model, equality_weights, inequality_weights,
                                residual_correction=False, deadline=None):
    """Return an exact source-valid owner row, or reject uncancelled variables.

    All reduced variables are literal probabilities: tau is a triple/quad
    expectation and each remaining coordinate is an actual y[m,j]. Thus
    0<=x<=1 follows from lambda>=0, sum(lambda)=1 and modeled boxes. If a
    combination is p(owner)+r*x<=0, its valid projection is
    p(owner)+sum(min(0,r_j))<=0. This does not use a numerical variable bound.
    """
    result = empty()
    count = 0
    for kind, weights in [('equalities', equality_weights),
                          ('inequalities', inequality_weights)]:
        for index, weight in weights:
            assert type(index) is int and 0 <= index < len(model[kind])
            weight = Q(weight)
            assert kind == 'equalities' or weight >= 0
            result = plus(result, row_expression(model, model[kind][index]), weight)
            count += 1
            if deadline is not None and count % 100 == 0:
                assert time.monotonic() <= deadline, 'exact-combination deadline'
    remainder = dict(result[1])
    correction = Q(0)
    if remainder:
        assert residual_correction, 'uncancelled free variables'
        probability_bound_guard(model)
        correction = sum((min(Q(0), v) for v in remainder.values()), Q(0))
        result = plus(result, term(0, 0, correction))
        result[1].clear()
    return dict(owner_target_coefficients=[[j, str(v)]
                                           for j, v in sorted(result[0].items())],
                residual_coefficients=[[j, str(v)]
                                       for j, v in sorted(remainder.items())],
                residual_bound_interval=['0', '1'],
                exact_residual_correction=str(correction),
                exact_cancellation=not remainder)


def integer_owner_row(result):
    terms = [(j, Q(v)) for j, v in result['owner_target_coefficients']]
    denominator = math.lcm(*(v.denominator for _, v in terms))
    integer = [(j, int(v*denominator)) for j, v in terms]
    divisor = math.gcd(*(abs(v) for _, v in integer)) or 1
    integer = [(j, v//divisor) for j, v in integer]
    constant = next((v for j, v in integer if j == 0), 0)
    coefficients = [[j-1, v] for j, v in integer if j]
    maximum = max([abs(constant), *[abs(v) for _, v in coefficients]])
    return dict(compiled_owner_coefficients=coefficients,
                compiled_owner_rhs=-constant,
                integer_row_fits_signed_int64=maximum < (1 << 63))


def matrix(model, features):
    import numpy as np
    from scipy.sparse import csr_matrix
    arrays = {}
    for kind, prefix in [('equalities', 'eq'), ('inequalities', 'ub')]:
        indices, values, starts, rhs = [], [], [0], []
        for descriptor in model[kind]:
            expression = row_expression(model, descriptor)
            rhs.append(float(-sum((v*features[j]
                                   for j, v in expression[0].items()), Q(0))))
            for j, v in sorted(expression[1].items()):
                indices.append(j)
                values.append(float(v))
            starts.append(len(indices))
        A = csr_matrix((np.array(values), np.array(indices, dtype=np.int32),
                        np.array(starts, dtype=np.int64)),
                       shape=(len(rhs), len(model['variables'])))
        arrays[prefix] = (A, np.array(rhs))
    return arrays


def ray_candidates(model, features, ray, seconds=30):
    neq = len(model['equalities'])
    assert len(ray) == neq+len(model['inequalities'])
    assert all(math.isfinite(float(v)) for v in ray)
    norm = max(map(abs, ray), default=0)
    if not norm:
        return [], []
    deadline = time.monotonic()+seconds
    accepted, attempts = [], []
    for sign in (-1, 1):
        for scale in (1, 4, 16, 256, 65536, 16777216, 1099511627776):
            if time.monotonic() > deadline:
                return accepted, attempts
            integers = [round(sign*(float(v)/norm)*scale) for v in ray]
            if min(integers[neq:], default=0) < 0:
                attempts.append(dict(sign=sign, scale=scale,
                                     status='REJECTED_NEGATIVE_INEQUALITY_MULTIPLIER'))
                continue
            eq = [(i, v) for i, v in enumerate(integers[:neq]) if v]
            ub = [(i, v) for i, v in enumerate(integers[neq:]) if v]
            try:
                result = exact_projected_combination(
                    model, eq, ub, residual_correction=True, deadline=deadline)
            except AssertionError as error:
                attempts.append(dict(sign=sign, scale=scale,
                                     status='EXACT_COMBINATION_NOT_COMPLETED',
                                     error=str(error)))
                continue
            exact_value = sum((Q(v)*features[j]
                               for j, v in result['owner_target_coefficients']), Q(0))
            attempts.append(dict(sign=sign, scale=scale,
                                 status='EXACT_ROW_EVALUATED',
                                 exact_value=str(exact_value),
                                 exact_cancellation=result['exact_cancellation'],
                                 correction=result['exact_residual_correction']))
            if exact_value > 0:
                accepted.append(dict(
                    **result, **integer_owner_row(result), sign=sign, scale=scale,
                    equality_multipliers=[[i, str(v)] for i, v in eq],
                    inequality_multipliers=[[i, str(v)] for i, v in ub],
                    exact_target_violation=str(exact_value),
                    status='EXACT_OWNER_ROW_CANDIDATE_REQUIRES_INDEPENDENT_REPLAY'))
    return accepted, attempts


def solve(model, features, args, prefix):
    import numpy as np
    import highspy
    arrays = matrix(model, features)
    n = len(model['variables'])
    H = highspy.Highs()
    for key, value in [('output_flag', False), ('threads', 1),
                       ('solver', args.solver), ('presolve', 'off'),
                       ('time_limit', args.seconds),
                       ('primal_feasibility_tolerance', 1e-10),
                       ('dual_feasibility_tolerance', 1e-10)]:
        assert H.setOptionValue(key, value) == highspy.HighsStatus.kOk
    # No implicit nonnegativity or unit upper bound: all are semantic rows.
    assert H.addVars(n, np.full(n, -highspy.kHighsInf),
                     np.full(n, highspy.kHighsInf)) == highspy.HighsStatus.kOk
    for kind in ('eq', 'ub'):
        A, rhs = arrays[kind]
        lower = rhs if kind == 'eq' else np.full(len(rhs), -highspy.kHighsInf)
        assert H.addRows(len(rhs), lower, rhs, A.nnz,
                         A.indptr.astype(np.int32), A.indices.astype(np.int32),
                         A.data) == highspy.HighsStatus.kOk
    run_status = H.run()
    status = H.getModelStatus()
    solution = H.getSolution()
    basis = H.getBasis()
    exported = dict(primal=np.array(solution.col_value),
                    row_values=np.array(solution.row_value),
                    row_dual=np.array(solution.row_dual),
                    column_dual=np.array(solution.col_dual),
                    basis_columns=np.array([int(v) for v in basis.col_status]),
                    basis_rows=np.array([int(v) for v in basis.row_status]))
    out = dict(status='NUMERICAL_GENERAL_STAR_ENDPOINT_REQUIRES_REPLAY',
               highs_run_status=str(run_status), highs_model_status=str(status),
               primal_value_valid=bool(solution.value_valid),
               dual_value_valid=bool(solution.dual_valid),
               numerical_flags_are_not_feasibility_certificates=True,
               variable_bounds='all free; bounds only from modeled inequalities',
               numerical_runtime=H.getRunTime(), exact_cuts=[])
    if status == highspy.HighsModelStatus.kInfeasible:
        ray_status, exists, ray = H.getDualRay()
        out.update(dual_ray_status=str(ray_status), dual_ray_exists=bool(exists))
        if exists:
            exported['dual_ray'] = np.array(ray)
            cuts, attempts = ray_candidates(model, features, ray, args.exact_seconds)
            out.update(exact_cuts=cuts, exact_ray_attempts=attempts)
    np.savez_compressed(str(prefix)+'.numeric.npz', **exported)
    out['numeric_packet_sha256'] = sha(Path(str(prefix)+'.numeric.npz'))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('mode', choices=['prepare', 'solve'])
    ap.add_argument('--base-model', type=Path, required=True)
    ap.add_argument('--model-review', type=Path)
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--star-bank', type=Path, nargs='+', required=True)
    ap.add_argument('--star-receipt', type=Path, nargs='+', required=True)
    ap.add_argument('--output-prefix', type=Path, required=True)
    ap.add_argument('--solver', choices=['ipm', 'simplex'], default='ipm')
    ap.add_argument('--seconds', type=float, default=120)
    ap.add_argument('--exact-seconds', type=float, default=30)
    args = ap.parse_args()
    assert len(args.star_bank) == len(args.star_receipt)
    assert 0 < args.seconds <= 120 and 0 < args.exact_seconds <= 60
    prefix = args.output_prefix
    model_path = Path(str(prefix)+'.model.json.gz')
    output = Path(str(prefix)+'.json')
    assert not model_path.exists() and not output.exists()
    base = decode_model(read(args.base_model))
    assert base['point_sha256'] == sha(args.point)
    assert all(sha(ROOT/p) == h for p, h in base['source_hashes'].items())
    if args.mode == 'solve':
        assert args.model_review is not None, 'independent general-model review required'
        review = read(args.model_review)
        assert review['status'] == 'PASS_EXACT_GENERAL_SHARED_LAW_MODEL'
        assert review['model_sha256'] == sha(args.base_model)
        assert review['point_sha256'] == sha(args.point)
        assert review['consumer_sha256'] == sha(ROOT/'verify_two_basis_joint_general.py')
    model, features = lift_model(base, args.point)
    append_stars(model, zip(args.star_bank, args.star_receipt))
    model.update(status='FROZEN_GENERAL_SHARED_LAW_WITH_OWNER_STARS',
                 base_model=str(args.base_model), base_model_sha256=sha(args.base_model))
    for path in [args.base_model, Path(__file__)]:
        model['source_hashes'][str(path)] = sha(path)
    if args.model_review is not None:
        model['source_hashes'][str(args.model_review)] = sha(args.model_review)
    model_path.write_bytes(gzip.compress(
        (json.dumps(encode(model), separators=(',', ':'))+'\n').encode(), mtime=0))
    out = dict(status='GENERAL_OWNER_STAR_MODEL_PREPARED',
               model_sha256=sha(model_path), base_model_sha256=sha(args.base_model),
               point_sha256=sha(args.point), producer_sha256=sha(__file__),
               variable_count=len(model['variables']), equality_count=len(model['equalities']),
               inequality_count=len(model['inequalities']), star_rows=len(model['star_rows']),
               owner_target_dimension=len(features), lp_run=args.mode == 'solve',
               source_C16_answered=False,
               scope='Source-valid auxiliary rows; numerical solver status is discovery only.')
    if args.mode == 'solve':
        out.update(solve(model, features, args, prefix))
    assert all(sha(ROOT/p) == h for p, h in model['source_hashes'].items())
    output.write_text(json.dumps(out, indent=2)+'\n')
    print(json.dumps(out, indent=2), flush=True)


if __name__ == '__main__':
    main()
