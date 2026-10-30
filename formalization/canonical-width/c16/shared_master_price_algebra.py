"""Exact source-row and pattern-cost algebra; no solver or physical oracle.

The caller supplies independently reconstructed symbolic parent rows and
normalized min-LP duals (inequality duals nonpositive). All expressions are
(owner-feature coefficients, finite-variable coefficients), with rows <=0.
"""
from fractions import Fraction as Q
from functools import reduce
from math import gcd, lcm

HIGH = (7, 11, 13, 14, 15)
LOW = (0, 1, 2, 4, 8, 3, 5, 9, 6, 10, 12)


def add(a, b, scale=1):
    scale = Q(scale)
    result = (dict(a[0]), dict(a[1]))
    for side in (0, 1):
        for j, value in b[side].items():
            v = result[side].get(j, Q(0)) + scale * Q(value)
            if v:
                result[side][j] = v
            else:
                result[side].pop(j, None)
    return result


def reconstruct(parent_rows, lambdas, allocations, dual, variable_metadata,
                basis_columns, error_columns, remove_pin_names=()):
    """Combine -dual*source_rows, evaluating artificial link errors at zero.

    parent_rows yields (name, relation, symbolic_expression).
    basis_columns entries contain side, mask, indices, variable_index.
    error_columns contain side, mask, index, plus_variable, minus_variable.
    Inputs may be toy-sized, but production callers must require all32 blocks.
    """
    result = ({}, {})
    removed = {}
    count = 0
    pin_names = set(remove_pin_names)
    seen = set()
    for name, relation, expression in parent_rows:
        assert name not in seen and relation in ('=', '<=')
        seen.add(name)
        pi = Q(dual[name])
        if relation == '<=':
            assert pi <= 0, 'min-LP inequality dual has wrong sign'
        if name in pin_names:
            assert relation == '='
            removed[name] = str(-pi)
        else:
            result = add(result, expression, -pi)
        count += 1
    assert pin_names <= seen
    blocks = []
    by_key = {}
    for side in sorted(allocations):
        for mask, row in enumerate(allocations[side]):
            pmass = Q(dual[f'sm_mass_{side}_{mask}'])
            result = add(result, lambdas[mask], pmass)
            weights = []
            for j, expression in enumerate(row):
                plink = Q(dual[f'sm_link_{side}_{mask}_{j}'])
                result = add(result, expression, plink)
                weights.append(-plink)
            block = dict(side=side, mask=mask, constant=-pmass, weights=weights)
            blocks.append(block)
            by_key[side, mask] = block
    basis_checks = 0
    for column in basis_columns:
        block = by_key[column['side'], column['mask']]
        score = block['constant'] + sum((block['weights'][j] for j in column['indices']), Q(0))
        pi = Q(dual['sm_nonneg_'+str(column['variable_index'])])
        assert pi <= 0 and score == -pi, 'archive column stationarity failed'
        basis_checks += 1
    error_checks = 0
    for error in error_columns:
        side, mask, j = (error[k] for k in ('side', 'mask', 'index'))
        pi = Q(dual[f'sm_link_{side}_{mask}_{j}'])
        pe = Q(dual['sm_nonneg_'+str(error['plus_variable'])])
        me = Q(dual['sm_nonneg_'+str(error['minus_variable'])])
        assert pe <= 0 and me <= 0
        assert pi - pe == 1 and -pi - me == 1, 'error objective stationarity failed'
        assert -1 <= pi <= 1
        error_checks += 2
    residual = {}
    for j, coefficient in result[1].items():
        assert 0 <= j < len(variable_metadata)
        variable = variable_metadata[j]
        assert variable['kind'] == 'tau', 'uncancelled finite variable'
        h = variable['mask']
        assert h in HIGH and h not in residual
        residual[h] = coefficient
    if not pin_names:
        assert not residual, 'unpinned full master must cancel every finite variable'
    return dict(owner_coefficients=result[0], tau_residual=residual,
                blocks=blocks, parent_rows_checked=count,
                archive_column_stationarity_checks=basis_checks,
                error_stationarity_checks=error_checks,
                removed_pin_source_multipliers=removed)


def pattern_cost(minima, tau_residual):
    assert set(minima) == {(s, m) for s in ('X', 'Z') for m in range(16)}
    assert set(tau_residual) <= set(HIGH)
    rho = [sum((Q(v) for h, v in tau_residual.items() if m & h == h), Q(0))
           for m in range(16)]
    costs = [Q(minima['X', m])+Q(minima['Z', m])+rho[m] for m in range(16)]
    return costs, rho


def check_minorant(costs, coefficients):
    costs = list(map(Q, costs)); coefficients = list(map(Q, coefficients))
    assert len(costs) == 16 and len(coefficients) == 11
    values = [sum((coefficients[i] for i, h in enumerate(LOW) if m & h == h), Q(0))
              for m in range(16)]
    assert all(a <= b for a, b in zip(values, costs)), 'invalid pattern minorant'
    return values


def owner_projection(owner_coefficients, low_owner_map, coefficients):
    assert len(low_owner_map) == len(coefficients) == 11 and low_owner_map[0] == 0
    out = {int(j): Q(v) for j, v in owner_coefficients.items() if v}
    for j, v in zip(low_owner_map, coefficients):
        out[j] = out.get(j, Q(0)) + Q(v)
        if not out[j]:
            del out[j]
    denominator = lcm(*(v.denominator for v in out.values())) if out else 1
    integers = {j: int(v*denominator) for j, v in out.items()}
    divisor = reduce(gcd, (abs(v) for v in integers.values()), 0) or 1
    integers = {j: v//divisor for j, v in integers.items()}
    return dict(rational_owner_feature_coefficients=out,
                integer_owner_coefficients=[[j-1, v] for j, v in sorted(integers.items()) if j],
                integer_rhs=-integers.get(0, 0),
                positive_scale=Q(denominator, divisor))
