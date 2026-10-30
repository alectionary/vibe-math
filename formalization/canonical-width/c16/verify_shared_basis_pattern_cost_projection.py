"""Small exact algebra controls; no optimization, producer imports, or oracle."""
from pathlib import Path
from fractions import Fraction as Q
import gzip
import hashlib
import json
import os
import time

ROOT = Path(__file__).resolve().parent
HIGH = [7, 11, 13, 14, 15]
LOW = [0, 1, 2, 4, 8, 3, 5, 9, 6, 10, 12]
PREFIX = ROOT / 'two-basis-results/shared-basis-pattern-cost-projection'


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    path = Path(path)
    data = path.read_bytes()
    return json.loads(gzip.decompress(data) if path.suffix == '.gz' else data)


def expression(saved):
    return tuple({int(j): Q(v) for j, v in part} for part in saved)


def add(*expressions):
    out = ({}, {})
    for expr in expressions:
        for s in range(2):
            for j, v in expr[s].items():
                out[s][j] = out[s].get(j, Q(0)) + v
    return tuple({j: v for j, v in part.items() if v} for part in out)


def value(expr, features, variables):
    return sum((v * features.get(j, Q(0)) for j, v in expr[0].items()), Q(0)) + sum(
        (v * variables.get(j, Q(0)) for j, v in expr[1].items()), Q(0))


def moments(law):
    return {h: sum((law[m] for m in range(16) if m & h == h), Q(0)) for h in range(16)}


def reject(predicate):
    try:
        assert predicate()
    except AssertionError:
        return 1
    raise AssertionError('Mutation was not rejected')


def main():
    started = time.monotonic()
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    thread_keys = ['OPENBLAS_NUM_THREADS', 'OMP_NUM_THREADS', 'MKL_NUM_THREADS',
                   'VECLIB_MAXIMUM_THREADS', 'NUMEXPR_NUM_THREADS', 'BLIS_NUM_THREADS']
    assert all(os.environ.get(k) == '1' for k in thread_keys)
    out = Path(str(PREFIX) + '-controls.json')
    inventory = Path(str(PREFIX) + '-inventory.json')
    assert not out.exists() and not inventory.exists()
    wrapper_path = ROOT / 'two-basis-results/joint-owner-k22-eight-point22.model.json'
    wrapper = read(wrapper_path)
    model_path = ROOT / wrapper['parent_semantic']
    assert sha(model_path) == wrapper['parent_semantic_sha256']
    saved = read(model_path)
    model = saved['model']
    lam = [expression(e) for e in model['lambda_expressions']]
    assert len(lam) == 16
    assert [v['mask'] for v in model['variables'][:5]] == HIGH
    assert all(v['kind'] == 'tau' for v in model['variables'][:5])
    assert add(*lam) == ({0: Q(1)}, {})
    for i, h in enumerate(HIGH):
        assert add(*(lam[m] for m in range(16) if m & h == h)) == ({}, {i: Q(1)})
    fmap = model['source_feature_to_owner_target'][:11]
    assert len(fmap) == len(set(fmap)) == 11 and fmap[0] == 0
    for m in range(16):
        expected = ({fmap[i]: Q((-1)**((h ^ m).bit_count()))
                     for i, h in enumerate(LOW) if h & m == m},
                    {i: Q((-1)**((h ^ m).bit_count()))
                     for i, h in enumerate(HIGH) if h & m == m})
        assert lam[m] == expected

    laws = [[Q(m == k) for m in range(16)] for k in range(16)]
    laws += [[Q(1, 16)] * 16,
             [Q(m + 1, 136) for m in range(16)],
             [Q(3, 4) if m == 0 else Q(1, 4) if m == 1 else Q(0) for m in range(16)],
             [Q(2, 7) if m == 7 else Q(3, 7) if m == 11 else Q(2, 7) if m == 15 else Q(0) for m in range(16)]]
    r = [Q(2, 3), Q(-5, 7), Q(11, 13), Q(-17, 19), Q(23, 29)]
    rho = [sum((r[i] for i, h in enumerate(HIGH) if m & h == h), Q(0)) for m in range(16)]
    assert rho[15] == sum(r) and all(rho[h] == r[i] for i, h in enumerate(HIGH[:-1]))
    pricing_comparisons = 0
    for law in laws:
        assert all(v >= 0 for v in law) and sum(law) == 1
        mu = moments(law)
        features = {fmap[i]: mu[h] for i, h in enumerate(LOW)}
        variables = {i: mu[h] for i, h in enumerate(HIGH)}
        assert [value(e, features, variables) for e in lam] == law
        residual = sum((r[i] * mu[h] for i, h in enumerate(HIGH)), Q(0))
        assert residual == sum((rho[m] * law[m] for m in range(16)), Q(0))
        pin = [-v for v in r]
        assert -sum((pin[i] * mu[h] for i, h in enumerate(HIGH)), Q(0)) == residual
        # Two synthetic columns per sector/pattern, including negative minima.
        # Explicit constants gamma are included in each finite toy cost.
        cost_sum = Q(0)
        lower = Q(0)
        for m in range(16):
            kappa = Q(-1 + 3 * (m & 1))
            for side, minimum in [('X', kappa - 2), ('Z', Q(2))]:
                gamma = Q(-7, 5) if side == 'X' else Q(9, 4)
                element_costs = [minimum - gamma, minimum - gamma + Q(m + 1, 17)]
                costs = [gamma + c for c in element_costs]
                exact_minimum = min(costs)
                assert exact_minimum == minimum
                weights = [law[m] / 3, 2 * law[m] / 3]
                assert sum(weights) == law[m]
                priced = sum((a * w for a, w in zip(costs, weights)), Q(0))
                assert priced >= exact_minimum * law[m]
                pricing_comparisons += 1
                cost_sum += priced
                lower += exact_minimum * law[m]
        assert cost_sum >= lower == -1 + 3 * mu[1]
        # Choosing G=-cost_sum makes a literal feasible toy source combination.
        assert -cost_sum + lower <= 0

    kappa = [Q(-1 + 3 * (m & 1)) for m in range(16)]
    b = kappa[:]
    assert all(b[m] <= kappa[m] for m in range(16))
    illustration = laws[18]
    q = moments(illustration)
    assert q[1] == Q(1, 4)
    expected = sum((b[m] * illustration[m] for m in range(16)), Q(0))
    assert expected == Q(-1, 4) > min(kappa) == -1
    # Matching explicit law and exact feasible quadratic minorant certify this
    # small example without invoking an LP or general optimization package.
    assert sum((kappa[m] * illustration[m] for m in range(16)), Q(0)) == expected
    mutants = 0
    mutants += reject(lambda: rho[15] == r[4])
    mutants += reject(lambda: r == [-v for v in r])
    mutants += reject(lambda: all(b[m] + Q(1, 100) <= kappa[m] for m in range(16)))
    mutated = [(dict(e[0]), dict(e[1])) for e in lam]
    mutated[15][1][4] = Q(2)
    mutants += reject(lambda: add(*(mutated[m] for m in range(16) if m & 7 == 7)) == ({}, {0: Q(1)}))
    mutants += reject(lambda: all(Q(-1 + 3 * (m & 1)) - 2 >= 0 for m in range(16)))
    mutants += reject(lambda: Q(-1) + Q(3) * q[1] == Q(-1) + Q(48) * q[1])

    inputs = [wrapper_path, model_path,
              ROOT / 'two_basis_structure.py', ROOT / 'two_basis_joint_general_model.py',
              ROOT / 'two_basis_joint_general_star.py', ROOT / 'two_basis_owner_star_capacity.py']
    sources = {str(p.relative_to(ROOT)): sha(p) for p in inputs}
    note = ROOT / 'SHARED-BASIS-PATTERN-COST-PROJECTION.md'
    result = dict(status='PASS_EXACT_PATTERN_COST_PROJECTION_ALGEBRA_CONTROLS',
                  scope='Theorem/preparation only; no optimization, physical pricing, or C16 source claim.',
                  consumer_sha256=sha(__file__), note_sha256=sha(note), source_hashes=sources,
                  actual_model_symbolic_mass_identities=1, actual_model_symbolic_high_identities=5,
                  actual_model_lambda_mobius_expressions=16, literal_unit_laws=16,
                  rational_mixture_laws=4, exact_pattern_law_reconstructions=20,
                  signed_toy_pricing_comparisons=pricing_comparisons,
                  minorant_pattern_checks=16, rejected_mutants=mutants,
                  illustration=dict(pattern_cost='-1+3*bit0', p0='1/4',
                                    expected_minorant=str(expected), constant_minimum=str(min(kappa)),
                                    exact_example_primal_dual_equality=True),
                  high_masks=HIGH, mask15_absorbs_all_five=True,
                  no_solver_called=True, no_matroid_oracle_called=True,
                  priority=os.getpriority(os.PRIO_PROCESS, 0), thread_environment={k: os.environ[k] for k in thread_keys},
                  elapsed_seconds=time.monotonic()-started)
    out.write_text(json.dumps(result, indent=2)+'\n')
    owned = [Path(__file__).resolve(), note, out]
    inv = dict(status='PASS_COMPLETED_THEOREM_PREPARATION_INVENTORY',
               scope=result['scope'], files=[dict(path=str(p.relative_to(ROOT)), sha256=sha(p), bytes=p.stat().st_size) for p in owned],
               repository_input_bindings=sources,
               excluded='No live logs, solver outputs, optimization runs, or new physical queries.')
    inventory.write_text(json.dumps(inv, indent=2)+'\n')
    print(json.dumps(dict(status=result['status'], receipt=str(out.relative_to(ROOT)),
                          receipt_sha256=sha(out), inventory=str(inventory.relative_to(ROOT)),
                          inventory_sha256=sha(inventory), elapsed_seconds=result['elapsed_seconds'])))


if __name__ == '__main__':
    main()
