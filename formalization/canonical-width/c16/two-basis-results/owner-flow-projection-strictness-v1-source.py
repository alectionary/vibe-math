#!/usr/bin/env python3
"""Independent exact small controls for shared owner-flow projection.

No LP solve. The synthetic probability model tests actual projection code;
the strictness example is generic and makes no C16 physical/source claim.
"""
import os
assert os.getpriority(os.PRIO_PROCESS, 0) == 19
for key in ['OPENBLAS_NUM_THREADS', 'OMP_NUM_THREADS', 'MKL_NUM_THREADS',
            'VECLIB_MAXIMUM_THREADS', 'NUMEXPR_NUM_THREADS', 'BLIS_NUM_THREADS']:
    assert os.environ.get(key) == '1'
from fractions import Fraction as Q
from pathlib import Path
from itertools import product
import argparse
import copy
import hashlib
import json
import time
import two_basis_owner_star_extension as tested

ROOT = Path(__file__).resolve().parent
def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def expr(target=None, variables=None): return (target or {}, variables or {})

def small_model():
    lam = [expr({0: Q(1, 16)}) for _ in range(16)]
    allocations = {side: [[expr()] for _ in range(16)] for side in ['X', 'Z']}
    allocations['X'][0][0] = expr(variables={0: Q(1)})
    allocations['Z'][0][0] = expr(variables={1: Q(1)})
    base = dict(feature_layout='constant1,canonical_owner_vector[36495]',
        variables=[dict(kind='allocation', side=s, mask=0, index=0) for s in ['X', 'Z']],
        equalities=[], inequalities=[dict(kind='lambda_nonnegative', mask=m) for m in range(16)],
        lambda_expressions=lam, sectors={s: dict(allocations=allocations[s]) for s in ['X', 'Z']},
        source_hashes={}, X_anchors=[1, 2], Z_anchors=[1, 2])
    for s, m, bound in product(['X', 'Z'], range(16), ['lower', 'upper']):
        base['inequalities'].append(dict(kind='box', side=s, mask=m, index=0, bound=bound))
    pool = [1]+[0]*719
    return tested.append_owner_flows(base, [('X', 0), ('Z', 0)], pool, pool)

def projection_controls():
    model = small_model(); tested.probability_bound_guard(model)
    assert len(model['owner_flow_extension']['physical_pairs']) == 1
    assert len(model['owner_flow_extension']['shared_edges']) == 1
    assert len(model['variables']) == 18
    ub = model['inequalities']; eq = model['equalities']
    nn = [i for i, row in enumerate(ub) if row.get('kind') == 'owner_flow_bound'
          and row['bound'] == 'nonnegative']
    col = next(i for i, row in enumerate(eq) if row['kind'] == 'owner_flow_column')
    row0 = next(i for i, row in enumerate(eq) if row['kind'] == 'owner_flow_row' and row['mask'] == 0)
    results = []
    def check(e, u, correction, target, residual, canceled):
        got = tested.exact_projected_combination(model, e, u, residual_correction=True)
        assert Q(got['exact_residual_correction']) == correction
        assert {i: Q(v) for i, v in got['owner_target_coefficients']} == target
        assert {i: Q(v) for i, v in got['residual_coefficients']} == residual
        assert got['exact_cancellation'] is canceled
        results.append(got)
    owner_slot = 1+tested.coordinate(0, 0)
    check([], [(nn[0], 2)], Q(-2), {0: Q(-2)}, {2: Q(-2)}, False)
    check([(col, 1)], [], Q(0), {owner_slot: Q(-1)},
          {j: Q(1) for j in range(2, 18)}, False)
    check([(col, -1)], [], Q(-16), {0: Q(-16), owner_slot: Q(1)},
          {j: Q(-1) for j in range(2, 18)}, False)
    check([(col, 1)], [(i, 1) for i in nn], Q(0), {owner_slot: Q(-1)}, {}, True)
    check([(row0, -3)], [], Q(-3), {0: Q(-3)}, {0: Q(3), 2: Q(-3)}, False)
    rejected = []
    def reject(name, function):
        try: function()
        except (AssertionError, KeyError): rejected.append(name)
        else: raise AssertionError('accepted '+name)
    reject('negative-inequality-multiplier', lambda:
           tested.exact_projected_combination(model, [], [(nn[0], -1)], True))
    reject('uncancelled-joint-variable', lambda:
           tested.exact_projected_combination(model, [], [(nn[0], 1)], False))
    reject('pin-outside-general-equality-cohort', lambda:
           tested.exact_projected_combination(model, [(len(eq), 1)], [], True))
    predicates = {
        'missing-t-lower': lambda d: d.get('kind') == 'owner_flow_bound' and d['mask'] == 0 and d['bound'] == 'nonnegative',
        'missing-t-upper': lambda d: d.get('kind') == 'owner_flow_bound' and d['mask'] == 0 and d['bound'] == 'X_upper',
        'missing-allocation-box': lambda d: d.get('kind') == 'box' and d['side'] == 'X' and d['mask'] == 0 and d['bound'] == 'lower',
        'missing-lambda-bound': lambda d: d.get('kind') == 'lambda_nonnegative' and d['mask'] == 7,
    }
    for name, predicate in predicates.items():
        bad = copy.deepcopy(model)
        bad['inequalities'] = [d for d in bad['inequalities'] if not predicate(d)]
        reject(name, lambda bad=bad: tested.probability_bound_guard(bad))
    bad = copy.deepcopy(model); bad['owner_flow_extension']['cells'][0][3] += 1
    reject('wrong-shared-cell-index', lambda: tested.probability_bound_guard(bad))
    interval_checks = 0
    for coefficients in product([Q(-7, 2), Q(-1, 3), Q(0), Q(2, 5)], repeat=2):
        lower = sum(min(Q(0), c) for c in coefficients)
        vals = [sum(c*x for c, x in zip(coefficients, point))
                for point in product([Q(0), Q(1, 2), Q(1)], repeat=2)]
        assert min(vals) == lower
        interval_checks += len(vals)
    return dict(synthetic_physical_edges=1, shared_cells=16, variables=18,
                exact_projection_cases=results, mutations_rejected=rejected,
                independent_interval_checks=interval_checks,
                scope='Synthetic probability-model algebra only; no C16 source instance.')

def strictness_control():
    lam = [Q(1, 2)]*2; marginal = Q(1, 6); T = Q(1, 18)
    x0 = [Q(2, 15)]*3+[Q(1, 30)]*3
    z0 = [Q(1, 15)]*3+[Q(1, 10)]*3
    X = [x0, [marginal-v for v in x0]]
    Z = [z0, [marginal-v for v in z0]]
    assert all(sum(row) == Q(1, 2) for row in X+Z)
    bounds = {}
    for x in range(6):
        for z in range(6):
            if x//3 != z//3: continue
            lower = [max(Q(0), X[m][x]+Z[m][z]-lam[m]) for m in range(2)]
            upper = [min(X[m][x], Z[m][z]) for m in range(2)]
            assert lower == [0, 0]
            bounds[x, z] = (max(lower[0], T-upper[1]), min(upper[0], T-lower[1]))
    separate = []; literal_checks = 0
    for side, i in product(['X', 'Z'], range(6)):
        component = i//3
        value = ([Q(2, 45), Q(1, 90)] if side == 'X' else [Q(1, 45), Q(1, 30)])[component]
        for j in range(3*component, 3*component+3):
            x, z = (i, j) if side == 'X' else (j, i)
            low, upper = bounds[x, z]
            assert low <= value <= upper
            for m, w in enumerate([value, T-value]):
                assert 0 <= w <= min(X[m][x], Z[m][z])
                assert w >= X[m][x]+Z[m][z]-lam[m]
                literal_checks += 1
        wanted = X if side == 'X' else Z
        assert [3*value, 3*(T-value)] == [wanted[m][i] for m in range(2)]
        separate.append(dict(side=side, center=i, pattern0_edge_value=str(value),
                             pattern1_edge_value=str(T-value)))
    # Two selected rows/columns in component A share exactly four cells.
    # Remove the third-column edge using its upper bound, then remove the
    # third-row edge using its lower bound. The four-cell sum must meet both.
    lower = sum(X[0][x]-bounds[x, 2][1] for x in [0, 1])
    upper = sum(Z[0][z]-bounds[2, z][0] for z in [0, 1])
    assert lower == Q(7, 45) and upper == Q(4, 45)
    assert lower-upper == Q(1, 15)
    return dict(pattern_masses=list(map(str, lam)), separate_star_witnesses=separate,
                literal_bounds_checked=literal_checks, shared_K22_lower=str(lower),
                shared_K22_upper=str(upper), exact_contradiction=str(lower-upper),
                all_individual_stars_feasible=True, shared_four_centers_infeasible=True,
                C16_physical_instance=False)

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--output', type=Path, required=True)
    a = ap.parse_args(); assert not a.output.exists(); start = time.monotonic()
    paths = [Path(__file__), ROOT/'two_basis_owner_star_extension.py',
             ROOT/'two_basis_joint_general_star.py', ROOT/'two_basis_joint_general_model.py',
             ROOT/'export_owner_star_flow_lp.py', ROOT/'OWNER-STAR-EXTENSION.md']
    sources = {str(p.relative_to(ROOT)): sha(p) for p in paths}
    out = dict(status='PASS_INDEPENDENT_SHARED_OWNER_FLOW_PROJECTION_AND_STRICTNESS_CONTROLS',
               projection=projection_controls(), strictness=strictness_control(),
               source_hashes=sources, source_C16_answered=False, solver_run=False,
               priority=os.nice(0), elapsed_seconds=time.monotonic()-start)
    assert all(sha(ROOT/p) == h for p, h in sources.items())
    a.output.write_text(json.dumps(out, indent=2)+'\n')
    print(out['status'], out['elapsed_seconds'], flush=True)

if __name__ == '__main__': main()

