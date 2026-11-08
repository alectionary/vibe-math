"""UNRUN control harness for colored membership and physical representations.

Writing this file launches nothing. Its main function imports the new drafts
only when a future explicitly authorized control run invokes this script.
All subset ranks and endpoint masses are independently recomputed. Positive
cuts need not maximize the defect. No large physical instance is included.
"""
from pathlib import Path
from fractions import Fraction as Q
from itertools import combinations, product
from collections import Counter
import argparse
import copy
import gzip
import hashlib
import json
import time


def low_rank(vectors):
    rows = {}
    for value in vectors:
        while value:
            bit = value & -value
            if bit in rows:
                value ^= rows[bit]
            else:
                rows[bit] = value
                break
    return len(rows)


def weighted_subset_scan(pools, masses, target):
    defects = []
    for bits in range(1 << len(target)):
        S = [j for j in range(len(target)) if bits >> j & 1]
        ranks = [low_rank(pool[j] for j in S) for pool in pools]
        gap = sum(target[j] for j in S)-sum(m*r for m, r in zip(masses, ranks))
        if gap > 0:
            defects.append((S, ranks, gap))
    return defects


def check_generic(pools, masses, target, endpoint, allow_inconclusive=False):
    masses, target = list(map(Q, masses)), list(map(Q, target))
    n, colors = len(target), len(pools)
    ranks = [low_rank(pool) for pool in pools]
    positives = [c for c, m in enumerate(masses) if m]
    r = ranks[positives[0]]
    assert all(ranks[c] == r for c in positives)
    assert min(masses) >= 0 and sum(masses) == 1
    assert min(target, default=0) >= 0 and sum(target) == r
    D = int(endpoint['denominator'])
    assert D > 0 and all((q*D).denominator == 1 for q in masses+target)
    expected_masses = [int(m*D) for m in masses]
    expected = [int(q*D) for q in target]
    assert endpoint['ground_size'] == n and endpoint['color_count'] == colors
    assert endpoint['common_rank'] == r and endpoint['full_ranks_by_color'] == ranks
    assert list(map(Q, endpoint['color_masses'])) == masses
    assert list(map(int, endpoint['color_mass_numerators'])) == expected_masses
    assert list(map(int, endpoint['target_numerators'])) == expected
    actual_masses, actual, seen = [0]*colors, [0]*n, set()
    for row in endpoint['bases']:
        c, B, weight = row['color'], row['indices'], int(row['weight_numerator'])
        assert type(c) is int and 0 <= c < colors and masses[c] > 0
        assert B == sorted(set(B)) and len(B) == r
        assert all(type(j) is int and 0 <= j < n for j in B)
        assert low_rank(pools[c][j] for j in B) == r and weight > 0
        assert (c, tuple(B)) not in seen
        seen.add((c, tuple(B)))
        actual_masses[c] += weight
        for j in B:
            actual[j] += weight
    assert actual_masses == expected_masses
    assert list(map(int, endpoint['achieved_color_mass_numerators'])) == actual_masses
    assert list(map(int, endpoint['achieved_numerators'])) == actual
    defects = weighted_subset_scan(pools, masses, target)
    status, cut = endpoint['status'], endpoint['violated_weighted_rank']
    if status == 'EXACT_COLORED_BASE_MIXTURE':
        assert not defects and actual == expected and cut is None
    elif status == 'EXACT_WEIGHTED_RANK_VIOLATION':
        S = cut['indices']
        assert S == sorted(set(S)) and all(type(j) is int and 0 <= j < n for j in S)
        rr = [low_rank(pool[j] for j in S) for pool in pools]
        bound = sum(m*rank for m, rank in zip(masses, rr))
        mass = sum(target[j] for j in S)
        assert defects and mass > bound and cut['ranks_by_color'] == rr
        assert Q(cut['weighted_rank']) == bound
        assert int(cut['weighted_rank_numerator']) == int(bound*D)
        assert Q(cut['target_mass']) == mass and Q(cut['exact_violation']) == mass-bound
    else:
        assert status == 'BOUNDED_COLORED_PUSH_RELABEL_INCONCLUSIVE'
        assert allow_inconclusive and cut is None
    return dict(status=status, exhaustive_subsets=1 << n, basis_records=len(seen))


def fixtures():
    return [
        ([[]], [Q(1)]),
        ([[], []], [Q(1, 3), Q(2, 3)]),
        ([[0, 0], [0, 0]], [Q(2, 5), Q(3, 5)]),
        ([[1, 1, 2, 2], [1, 2, 1, 2]], [Q(1, 3), Q(2, 3)]),
        ([[1, 1, 2, 2], [1, 2, 1, 2], [0, 0, 0, 0]],
         [Q(1, 3), Q(2, 3), Q(0)]),
        ([[0, 1, 1, 2, 3], [1, 0, 2, 2, 3]], [Q(2, 7), Q(5, 7)]),
        ([list(range(1, 8)), [1, 2, 4, 3, 5, 6, 7]], [Q(1, 5), Q(4, 5)]),
        ([[1, 2, 3], [1, 2, 3]], [Q(7, 11), Q(4, 11)]),
    ]


def cache_collision_controls(producer):
    pools = [[1, 1, 2, 2], [1, 2, 1, 2]]
    masses, target = [Q(1, 3), Q(2, 3)], [Q(1, 2)]*4
    # The same basis {0,3} has different fundamental circuits for entering1:
    # color0 uses {0,1}; color1 uses {1,3}. A cache keyed only by basis bits is wrong.
    assert pools[0][1] == pools[0][0] and pools[1][1] == pools[1][3]
    warm = [(0, [0, 3], Q(1, 6)), (0, [0, 3], Q(1, 6)),
            (1, [0, 3], Q(1, 5)), (1, [0, 3], Q(7, 15))]
    endpoint = producer.solve(pools, masses, target, initial=warm,
                              verify_invariants=True, seconds=2)
    check_generic(pools, masses, target, endpoint)
    assert endpoint['status'] == 'EXACT_COLORED_BASE_MIXTURE'
    assert int(endpoint['denominator']) == 30 and endpoint['cache_builds'] >= 2
    caps = []
    for name, options, reason in [
        ('time', dict(seconds=1e-300), 'TIME_LIMIT'),
        ('step', dict(maximum_steps=1), 'STEP_LIMIT'),
        ('active', dict(maximum_bases=2), 'ACTIVE_BASIS_LIMIT_BEFORE_SPLIT'),
        ('initial-active', dict(maximum_bases=1), 'INITIAL_ACTIVE_BASIS_LIMIT'),
    ]:
        out = producer.solve(pools, masses, target, initial=warm,
                             verify_invariants=True, **options)
        check_generic(pools, masses, target, out, True)
        assert out['status'] == 'BOUNDED_COLORED_PUSH_RELABEL_INCONCLUSIVE'
        assert out['stop_reason'] == reason
        caps.append(dict(name=name, result=out))
    return endpoint, caps


def physical_controls(producer, representation, consumer):
    domain_count = subset_count = basis_count = endpoint_count = 0
    maximum_ambient = 0
    for dimension in (2, 3):
        pool = list(range(1, 1 << dimension))
        physical_bases = [list(B) for B in combinations(range(len(pool)), dimension)
                          if low_rank(pool[j] for j in B) == dimension]
        for mask in range(16):
            own = [j for j in (0, 1) if mask >> j & 1]
            absent = [j for j in (0, 1) if not mask >> j & 1]
            W = [j for j in (0, 1) if mask >> (j+2) & 1]
            specifications, domains, proxies, allowed_bases = [], [], [], []
            for selected in [W, sorted(W+[2])]:
                spec = dict(selected_opposite=selected, selected_own=own, absent_own=absent)
                pd = representation.source_domain(pool, pool, selected, own, absent, dimension)
                cd = consumer.rebuild_domain(pool, pool, spec, dimension)
                accepted = [B for B in physical_bases
                            if set(own) <= set(B) and not set(absent) & set(B)
                            and all(sum((pool[j] & pool[w]).bit_count() % 2 for j in B) == 1
                                    for w in selected)
                            and all(sum((pool[j] & pool[w]).bit_count() % 2
                                        for w in selected) <= 1 for j in B)]
                assert pd['feasible'] == cd['feasible'] == bool(accepted)
                specifications.append(spec)
                domains.append(cd)
                allowed_bases.append(accepted)
                domain_count += 1
                if not accepted:
                    proxies.append([0]*len(pool))
                    continue
                encoded = representation.represent(pool, pd)
                proxy = encoded['vectors']
                proxies.append(proxy)
                maximum_ambient = max(maximum_ambient, encoded['ambient_bit_width'])
                assert low_rank(proxy) == dimension
                for bits in range(1 << len(pool)):
                    S = [j for j in range(len(pool)) if bits >> j & 1]
                    assert low_rank(proxy[j] for j in S) == consumer.physical_domain_rank(pool, cd, S)
                    subset_count += 1
                proxy_bases = [list(B) for B in combinations(range(len(pool)), dimension)
                               if low_rank(proxy[j] for j in B) == dimension]
                assert proxy_bases == accepted
                for B in proxy_bases:
                    consumer.check_full_basis(pool, pool, cd, B)
                    basis_count += 1
            if not domains[0]['feasible']:
                continue
            masses = [Q(1, 3), Q(2, 3)] if domains[1]['feasible'] else [Q(1), Q(0)]
            target = [sum(masses[c]*int(j in allowed_bases[c][0])
                          for c in range(2) if masses[c]) for j in range(len(pool))]
            for q in [target, [Q(dimension)]+[Q(0)]*(len(pool)-1)]:
                out = producer.solve(proxies, masses, q, seconds=2, verify_invariants=True)
                check_generic(proxies, masses, q, out)
                consumer.check_endpoint(pool, pool, specifications, masses, q, out, dimension)
                endpoint_count += 1
    return dict(physical_domain_cases=domain_count, exact_subset_rank_identities=subset_count,
                physical_full_bases_checked=basis_count, colored_physical_endpoints=endpoint_count,
                maximum_tiny_proxy_ambient_bits=maximum_ambient)


def invalid_input_controls(producer):
    U = [[1, 1, 2, 2], [1, 2, 1, 2]]
    masses, q = [Q(1, 3), Q(2, 3)], [Q(1, 2)]*4
    cases = [
        ('negative-mass', U, [Q(-1), Q(2)], q, {}),
        ('wrong-mass-total', U, [Q(1), Q(1)], q, {}),
        ('negative-target', U, masses, [Q(-1), Q(1), Q(1), Q(1)], {}),
        ('wrong-target-total', U, masses, [Q(0)]*4, {}),
        ('different-ground-sizes', [U[0], [1, 2]], masses, q, {}),
        ('negative-vector', [[-1, 1, 2, 2], U[1]], masses, q, {}),
        ('different-positive-ranks', [[1, 1, 1, 1], U[1]], masses, q, {}),
        ('negative-warm-weight', U, masses, q,
         dict(initial=[(0, [0, 3], Q(-1)), (1, [0, 3], Q(2))])),
        ('wrong-warm-color-mass', U, masses, q,
         dict(initial=[(0, [0, 3], Q(2, 3)), (1, [0, 3], Q(1, 3))])),
        ('out-of-range-color', U, masses, q, dict(initial=[(2, [0, 3], Q(1))])),
        ('negative-color', U, masses, q, dict(initial=[(-1, [0, 3], Q(1))])),
        ('out-of-range-index', U, masses, q,
         dict(initial=[(0, [0, 4], Q(1, 3)), (1, [0, 3], Q(2, 3))])),
        ('duplicate-basis-index', U, masses, q,
         dict(initial=[(0, [0, 0], Q(1, 3)), (1, [0, 3], Q(2, 3))])),
        ('dependent-colored-basis', U, masses, q,
         dict(initial=[(0, [0, 1], Q(1, 3)), (1, [0, 3], Q(2, 3))])),
        ('positive-weight-in-zero-color', U+[[0]*4], masses+[Q(0)], q,
         dict(initial=[(0, [0, 3], Q(1, 3)), (1, [0, 3], Q(1, 3)), (2, [], Q(1, 3))])),
    ]
    rejected = []
    for name, pools, beta, target, options in cases:
        try:
            producer.solve(pools, beta, target, verify_invariants=True, **options)
        except (AssertionError, ValueError):
            rejected.append(name)
        else:
            raise AssertionError(('invalid colored input accepted', name))
    return rejected


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--output-prefix', type=Path, required=True)
    args = parser.parse_args()
    # These imports are deliberately deferred. Do not invoke during the load hold.
    import exact_colored_matroid_push_relabel_draft as producer
    import colored_physical_domain_representation_draft as representation
    import verify_colored_physical_endpoint_draft as consumer
    started = time.monotonic()
    records, outcomes, subset_checks = [], Counter(), 0
    for case_index, (pools, masses) in enumerate(fixtures()):
        n = len(pools[0])
        r = low_rank(pools[next(c for c, m in enumerate(masses) if m)])
        for denominator in ([2, 3] if n <= 4 else [2]):
            for numerators in product(range(denominator+1), repeat=n):
                if sum(numerators) != denominator*r:
                    continue
                target = [Q(v, denominator) for v in numerators]
                out = producer.solve(pools, masses, target, seconds=2,
                                     maximum_steps=100000, verify_invariants=True)
                checked = check_generic(pools, masses, target, out)
                outcomes[checked['status']] += 1
                subset_checks += checked['exhaustive_subsets']
                records.append(dict(case=case_index, pools=pools, masses=list(map(str, masses)),
                                    target=list(map(str, target)), endpoint=out))
    pools, masses = [[1, 1, 2, 2], [1, 2, 1, 2]], [Q(1, 3), Q(2, 3)]
    for denominator in [5, 7, 97, (1 << 100)+267]:
        epsilon = Q(1, denominator)
        for label, target in [
            ('near-weighted-cut', [Q(1), Q(2, 3)+epsilon, Q(1, 3)-epsilon, Q(0)]),
            ('near-weighted-feasible', [Q(1), Q(2, 3)-epsilon, Q(1, 3), epsilon]),
        ]:
            out = producer.solve(pools, masses, target, seconds=2,
                                 maximum_steps=100000, verify_invariants=True)
            checked = check_generic(pools, masses, target, out)
            outcomes[checked['status']] += 1
            subset_checks += checked['exhaustive_subsets']
            records.append(dict(case=f'{label}-{denominator}', pools=pools,
                                masses=list(map(str, masses)), target=list(map(str, target)),
                                endpoint=out))
    collision, caps = cache_collision_controls(producer)
    physical = physical_controls(producer, representation, consumer)
    invalid = invalid_input_controls(producer)
    mixture = next(r for r in records if r['endpoint']['status'] == 'EXACT_COLORED_BASE_MIXTURE'
                   and len(r['pools']) > 1 and r['endpoint']['common_rank'] > 0)
    cut = next(r for r in records if r['endpoint']['status'] == 'EXACT_WEIGHTED_RANK_VIOLATION')
    mutants = []
    for label in ['wrong-color', 'wrong-color-mass', 'out-of-range-index', 'negative-weight']:
        bad = copy.deepcopy(mixture)
        out = bad['endpoint']
        if label == 'wrong-color':
            out['bases'][0]['color'] = (out['bases'][0]['color']+1) % len(bad['pools'])
        elif label == 'wrong-color-mass':
            out['color_mass_numerators'][0] = str(int(out['color_mass_numerators'][0])+1)
        elif label == 'out-of-range-index':
            out['bases'][0]['indices'][0] = len(bad['target'])
        else:
            out['bases'][0]['weight_numerator'] = '-1'
        mutants.append((label, bad))
    for label in ['wrong-weighted-rank', 'wrong-gap', 'empty-cut']:
        bad = copy.deepcopy(cut)
        out = bad['endpoint']['violated_weighted_rank']
        if label == 'wrong-weighted-rank':
            out['ranks_by_color'][0] += 1
        elif label == 'wrong-gap':
            out['exact_violation'] = '0'
        else:
            out['indices'] = []
        mutants.append((label, bad))
    rejected = []
    for label, bad in mutants:
        try:
            check_generic(bad['pools'], bad['masses'], bad['target'], bad['endpoint'])
        except (AssertionError, IndexError, ValueError):
            rejected.append(label)
        else:
            raise AssertionError(('corrupt colored endpoint accepted', label))
    prefix = args.output_prefix
    bank, receipt = Path(str(prefix)+'.json.gz'), Path(str(prefix)+'-independent.json')
    assert not bank.exists() and not receipt.exists()
    bank.write_bytes(gzip.compress((json.dumps(dict(records=records, collision=collision,
                                                  caps=caps), indent=2)+'\n').encode(), mtime=0))
    root = Path(__file__).resolve().parent
    sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()
    report = dict(status='PASS_FINITE_COLORED_AND_PHYSICAL_CONTROLS',
                  source_hashes={p: sha(root/p) for p in [
                      'exact_colored_matroid_push_relabel_draft.py',
                      'colored_physical_domain_representation_draft.py',
                      'verify_colored_physical_endpoint_draft.py', Path(__file__).name]},
                  bank_sha256=sha(bank), cases=len(records), outcomes=dict(outcomes),
                  exhaustive_subset_checks=subset_checks, physical_controls=physical,
                  same_basis_bits_different_color_circuits=True, warm_common_denominator=30,
                  cap_exit_controls=4, invalid_inputs_rejected=invalid,
                  corrupt_endpoints_rejected=rejected, maximum_defect_required=False,
                  elapsed_seconds=time.monotonic()-started,
                  runtime_guarantee_proved=False, source_C16_answered=False,
                  scope='Finite tiny controls only; no large physical, cross-pattern '
                        'owner-lift, source-frame or global runtime result.')
    receipt.write_text(json.dumps(report, indent=2)+'\n')
    print(json.dumps(report, indent=2), flush=True)


if __name__ == '__main__':
    main()
