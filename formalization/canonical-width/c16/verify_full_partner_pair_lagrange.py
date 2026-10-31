#!/usr/bin/env python3
"""Independent source/physical acceptance of pair-priced partner-basis bounds.

For nonnegative edge prices lambda and a pair-avoiding basis B,
w(B)=(w-degree(lambda))(B)+sum_e lambda_e*|B intersect e|
     <= max_full_partner_basis(w-degree(lambda))+sum_e lambda_e.
The saved maximizing basis may violate pairs. This proves an upper bound,
never pair-constrained pricing optimality or existence of a pair-avoiding basis.

No producer pricing, support, or forbidden-edge routine is imported. The four
source pair witnesses are literally replayed; full-basis supports are checked
with independent physical low-pivot prefix ranks and an attaining128-basis.
"""
from pathlib import Path
from fractions import Fraction
from itertools import combinations
from collections import Counter
import argparse
import gzip
import hashlib
import json
import time
from verify_algebraic_model import physical
from verify_four_term_small import check as literal_pair_check
from verify_full_partner_basis_oracle import rebuild_domain, check_support, dimension, extend

ROOT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    raw = Path(path).read_bytes()
    return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)


def move(index, rotation):
    return 16*(index//16)+(index % 16+rotation) % 16


def support_upper(Z, domain, weights):
    assert domain['status'] == 'FULL_PARTNER_BASIS_DOMAIN'
    ordered = sorted(domain['zero'], key=lambda j: (-weights[j], j))
    rows = {}
    prefix_ranks = []
    for j in ordered:
        extend(rows, Z[j])
        prefix_ranks.append(len(rows))
    value = weights[ordered[-1]]*len(rows) if ordered else Fraction(0)
    value += sum((weights[ordered[t]]-weights[ordered[t+1]])*prefix_ranks[t] for t in range(len(ordered)-1))
    return value+sum(max(weights[j] for j in b) for b in domain['bins'])


def verify_record(Z, selected, domain, weights, edges, record, n=128):
    assert domain['status'] == 'FULL_PARTNER_BASIS_DOMAIN'
    prices = list(map(Fraction, record['edge_prices']))
    assert len(prices) == len(edges) and all(price >= 0 for price in prices)
    adjusted = list(map(Fraction, weights))
    for (i, j), price in zip(edges, prices):
        adjusted[i] -= price
        adjusted[j] -= price
    chosen = record['greedy_basis']
    assert len(chosen) == len(set(chosen)) == n
    zero = [j for j in chosen if domain['signatures'][j] == 0]
    owners = []
    for h in range(len(selected)):
        choices = [j for j in chosen if domain['signatures'][j] == 1 << h]
        assert len(choices) == 1
        owners.append(choices[0])
    assert set(zero+owners) == set(chosen)
    adapted = {'status': 'EXACT_FULL_PARTNER_BASIS_SUPPORT',
               'value': record['greedy_adjusted_value'], 'selected_Z_indices': zero+owners,
               'zero_basis_indices': zero, 'owner_indices': owners}
    prefix_checks = check_support(Z, selected, n, domain, adjusted, adapted)
    exact_adjusted = support_upper(Z, domain, adjusted)
    bound = exact_adjusted+sum(prices)
    baseline = support_upper(Z, domain, weights)
    assert Fraction(record['upper']) == bound
    assert Fraction(record['unrestricted_upper']) == baseline
    assert Fraction(record['improvement']) == baseline-bound >= 0
    return {'exact_upper': str(bound), 'exact_unrestricted_upper': str(baseline),
            'exact_improvement': str(baseline-bound), 'exact_price_sum': str(sum(prices)),
            'nonzero_prices': sum(p > 0 for p in prices), 'prefix_rank_checks': prefix_checks,
            'saved_greedy_basis_pair_violations': sum(i in chosen and j in chosen for i, j in edges)}


def literal_small_controls():
    """Enumerate every3-vector basis, every fixed selected X subset, and signs."""
    X = Z = list(range(1, 8))
    n = 3
    bases = [b for b in combinations(range(7), 3) if dimension(Z[j] for j in b) == 3]
    edge_sets = [[(0, 1)], [(0, 1), (0, 2)], [(0, 1), (2, 3)]]
    weight_sets = [[0]*7, [-j-1 for j in range(7)], [3, -4, 5, -2, 1, -6, 2]]
    prices_sets = [[Fraction(0), Fraction(0)], [Fraction(1, 2), Fraction(2, 3)], [Fraction(3), Fraction(2)]]
    cases = basis_inequalities = strict_improvements = no_avoiding_basis = 0
    for size in range(4):
        for selected in combinations((0, 1, 3), size):
            domain = rebuild_domain(X, Z, selected, n)
            assert domain['status'] == 'FULL_PARTNER_BASIS_DOMAIN'
            eligible = []
            for b in bases:
                matrix = [[(X[i] & Z[j]).bit_count() % 2 for j in b] for i in selected]
                if all(sum(row) == 1 for row in matrix) and all(sum(matrix[i][j] for i in range(size)) <= 1 for j in range(n)):
                    eligible.append(b)
            for edges in edge_sets:
                avoiding = [b for b in eligible if all(not (i in b and j in b) for i, j in edges)]
                for weights in weight_sets:
                    baseline = max(sum(weights[j] for j in b) for b in eligible)
                    assert baseline == support_upper(Z, domain, weights)
                    for proposed in prices_sets:
                        prices = proposed[:len(edges)]
                        adjusted = list(map(Fraction, weights))
                        for (i, j), price in zip(edges, prices):
                            adjusted[i] -= price
                            adjusted[j] -= price
                        exact = max(sum(adjusted[j] for j in b) for b in eligible)
                        assert exact == support_upper(Z, domain, adjusted)
                        upper = exact+sum(prices)
                        for b in avoiding:
                            actual = sum(weights[j] for j in b)
                            assert actual <= sum(adjusted[j] for j in b)+sum(prices) <= upper
                            basis_inequalities += 1
                        strict_improvements += upper < baseline
                        no_avoiding_basis += not avoiding
                        cases += 1
    assert strict_improvements > 0 and basis_inequalities > 0
    return {'literal_bound_cases': cases, 'literal_pair_avoiding_basis_inequalities': basis_inequalities,
            'strict_upper_improvements': strict_improvements,
            'cases_with_no_pair_avoiding_basis': no_avoiding_basis,
            'signed_and_rational_price_controls': True}


def source_edges(X, Z, A):
    path = ROOT / 'moment-resumption-results/all-pair-word-cuts.json'
    receipt_path = ROOT / 'moment-resumption-results/all-pair-moment-faces.json'
    bank, receipt = read(path), read(receipt_path)
    assert bank['status'] == receipt['status'] == 'PASS'
    assert receipt['source_pair_bank_sha256'] == sha(path)
    original = ROOT / bank['source_c16_path']
    assert sha(original) == bank['source_sha256']
    assert read(original)['cuts'] == bank['cuts']
    assert len(bank['cuts']) == 4
    checked = []
    expected_faces = []
    for cut in bank['cuts']:
        pair = cut['indices']
        cert = cut['certificate']
        assert cut['sector'] == 1 and len(pair) == len(set(pair)) == 2
        assert cert['side'] == 0 and cert['mandatory_opposite'] == pair
        result = literal_pair_check(X, Z, cert)
        checked.append({'indices': pair, 'order': cert['order'], **result})
        i, j = pair
        expected_faces.append({'sector': 'X', 'anchor_orbit': i//16, 'orbit': j//16,
                               'coefficients': [int(h == (j-i) % 16) for h in range(16)], 'bound': 0})
    assert receipt['cuts'] == expected_faces
    graph_ranks = [dimension([x | (z << 128) for x, z in zip(X, Z)]),
                   dimension([X[i] | (X[move(i, 1)] << 128) for i in range(720)]),
                   dimension([Z[i] | (Z[move(i, 1)] << 128) for i in range(720)])]
    assert dimension(X) == dimension(Z) == 128 and graph_ranks == [128, 128, 128]
    assert all((A[i] >> j & 1) == (A[j] >> i & 1) == (A[move(i, 1)] >> move(j, 1) & 1) for i in range(720) for j in range(720))
    edges = sorted({tuple(sorted(move(j, h) for j in cut['indices'])) for cut in bank['cuts'] for h in range(16)})
    assert len(edges) == 64
    assert all({tuple(sorted(move(j, h) for j in edge)) for edge in edges} == set(edges) for h in range(16))
    neighbors = {}
    for i, j in edges:
        assert 0 <= i < j < 720
        neighbors.setdefault(i, set()).add(j)
        neighbors.setdefault(j, set()).add(i)
    remaining = set(neighbors)
    components = []
    while remaining:
        component, frontier = set(), {min(remaining)}
        while frontier:
            component |= frontier
            frontier = set().union(*(neighbors[j] for j in frontier))-component
        remaining -= component
        components.append(sorted(component))
    histogram = Counter((len(c), sum(len(neighbors[j]) for j in c)//2) for c in components)
    assert histogram == {(2, 1): 32, (3, 2): 16}
    corrupt = dict(bank['cuts'][0]['certificate'])
    corrupt['witness_hex'] = '0'
    try:
        literal_pair_check(X, Z, corrupt)
    except AssertionError:
        source_negative = True
    else:
        raise AssertionError('zero source pair witness accepted')
    return edges, {'source_pair_checks': checked, 'source_graph_ranks': graph_ranks,
                   'edges': len(edges), 'K2_components': 32, 'P3_components': 16,
                   'nonisolated_vertices': len(neighbors), 'all16_edge_rotation_checks': True,
                   'source_zero_witness_rejected': source_negative,
                   'pair_bank_sha256': sha(path), 'pair_receipt_sha256': sha(receipt_path),
                   'original_positive_certificate_source_sha256': sha(original)}


def template_weights(mask, coefficients):
    assert len(coefficients) == 775 and all(type(c) is int for c in coefficients)
    phases = [h for h in range(16) if mask >> h & 1]
    return [Fraction(coefficients[10+j]+sum(coefficients[55+16*j+(b-h) % 16] for h in phases))
            for j in range(45) for b in range(16)]


def verify_price_rotation(mask, coefficients, edges, price_strings):
    """Transport a representative's valid price vector to every rotated mask."""
    prices = list(map(Fraction, price_strings))
    original = template_weights(mask, coefficients)
    original_degrees = [Fraction(0)]*720
    for (i, j), price in zip(edges, prices):
        original_degrees[i] += price
        original_degrees[j] += price
    edge_set = set(edges)
    comparisons = 0
    for rotation in range(16):
        rotated_mask = ((mask << rotation) | (mask >> (16-rotation))) & 65535
        rotated = template_weights(rotated_mask, coefficients)
        transported = {tuple(sorted((move(i, rotation), move(j, rotation)))): price
                       for (i, j), price in zip(edges, prices)}
        assert set(transported) == edge_set and sum(transported.values()) == sum(prices)
        degrees = [Fraction(0)]*720
        for (i, j), price in transported.items():
            degrees[i] += price
            degrees[j] += price
        assert all(rotated[move(j, rotation)] == original[j] and
                   degrees[move(j, rotation)] == original_degrees[j] and
                   rotated[move(j, rotation)]-degrees[move(j, rotation)] == original[j]-original_degrees[j]
                   for j in range(720))
        comparisons += 720
    return comparisons


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--bank', type=Path, required=True)
    ap.add_argument('--frozen', type=Path)
    ap.add_argument('--weight-source', type=Path, default=ROOT / 'coupling-results/full-partner-orbit32.frozen.json')
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    start = time.monotonic()
    bank = read(args.bank)
    frozen_path = args.frozen or args.bank.with_suffix('.frozen.json')
    frozen = read(frozen_path)
    assert bank['frozen_sha256'] == sha(frozen_path)
    assert all(sha(ROOT / p) == digest for p, digest in frozen['source_hashes'].items())
    assert frozen['weight_source_sha256'] == sha(args.weight_source)
    source = read(args.weight_source)
    assert source['orbit'] == 32 and source['extra_X_indices'] == []
    assert source['source_sha256'] == sha(ROOT / 'physical-pool-source.json')
    assert all(source['pool_sha256'][s] == sha(ROOT / f'pools/{s}coords.txt') for s in 'xz')
    X, Z, A = physical()
    assert X == [int(v, 16) for v in (ROOT / 'pools/xcoords.txt').read_text().split()]
    assert Z == [int(v, 16) for v in (ROOT / 'pools/zcoords.txt').read_text().split()]
    edges, bridge = source_edges(X, Z, A)
    assert frozen['edges'] == list(map(list, edges))
    masks = frozen['masks']
    assert len(masks) == len(set(masks)) and set(masks) <= set(source['representatives'])
    template_mode = frozen.get('weight_mode') == 'affine_phase_template'
    if template_mode:
        coefficients = frozen['coefficients']
        cohort_names = [frozen.get('cohort', 'template')]
        get_weights = lambda mask, name: template_weights(mask, coefficients)
    else:
        saved = source['weight_sets']
        if isinstance(saved, dict):
            cohorts = {str(name): list(map(Fraction, weights)) for name, weights in saved.items()}
        else:
            cohorts = {str(j): list(map(Fraction, row['weights'] if isinstance(row, dict) else row)) for j, row in enumerate(saved)}
        cohort_names = list(cohorts)
        get_weights = lambda mask, name: cohorts[name]
    records = {(r['mask'], r['cohort']): r for r in bank['records']}
    expected = {(mask, name) for mask in masks for name in cohort_names}
    assert len(records) == len(bank['records']) and set(records) == expected
    results = []
    negatives = 0
    rotation_comparisons = 0
    for mask in masks:
        selected = [512+h for h in range(16) if mask >> h & 1]
        domain = rebuild_domain(X, Z, selected, 128)
        assert domain['status'] == 'FULL_PARTNER_BASIS_DOMAIN'
        for name in cohort_names:
            record = records[mask, name]
            weights = get_weights(mask, name)
            result = verify_record(Z, selected, domain, weights, edges, record)
            if template_mode:
                rotation_comparisons += verify_price_rotation(mask, coefficients, edges, record['edge_prices'])
            results.append({'mask': mask, 'cohort': name, **result})
            if not negatives:
                for mode in ('negative_price', 'false_upper', 'false_adjusted_objective'):
                    corrupted = json.loads(json.dumps(record))
                    if mode == 'negative_price':
                        corrupted['edge_prices'][0] = '-1'
                    elif mode == 'false_upper':
                        corrupted['upper'] = str(Fraction(corrupted['upper'])-1)
                    else:
                        corrupted['greedy_adjusted_value'] = str(Fraction(corrupted['greedy_adjusted_value'])+1)
                    try:
                        verify_record(Z, selected, domain, weights, edges, corrupted)
                    except AssertionError:
                        negatives += 1
                    else:
                        raise AssertionError(('corruption accepted', mode))
    improved = sum(Fraction(r['exact_improvement']) > 0 for r in results)
    assert improved == bank['improved']
    controls = literal_small_controls()
    out = {'status': 'PASS', 'source_C16_answered': False, 'bank_sha256': sha(args.bank),
           'frozen_sha256': sha(frozen_path), 'weight_source_sha256': sha(args.weight_source),
           'consumer_sha256': sha(Path(__file__)), 'source_hashes': frozen['source_hashes'],
           'source_pair_bridge': bridge, 'weight_mode': 'affine_phase_template' if template_mode else 'fixed_weight_cohort',
           'queries_checked': len(results), 'masks_checked': len(masks), 'improved_upper_bounds': improved,
           'maximum_exact_improvement': str(max(Fraction(r['exact_improvement']) for r in results)),
           'actual_price_weight_rotation_comparisons': rotation_comparisons,
           'representative_bound_rotation_extension_checked': template_mode,
           'corrupted_price_and_objective_controls_rejected': negatives, 'literal_small_controls': controls,
           'results': results, 'elapsed_seconds': time.monotonic()-start,
           'dependencies': {p: sha(ROOT/p) for p in ['verify_full_partner_basis_oracle.py', 'verify_four_term_small.py', 'verify_algebraic_model.py', 'verify_partial_frame.py', 'audit_pools.py']},
           'scope': 'Every reported value is an exact source-valid upper bound for pair-avoiding full partner bases. Capped LP pricing is discovery only; pricing optimality, a pair-avoiding basis, projected separation and source infeasibility are not asserted.'}
    args.output.write_text(json.dumps(out, indent=2)+'\n')
    print({k: v for k, v in out.items() if k not in ['results', 'source_hashes', 'dependencies']}, flush=True)


if __name__ == '__main__':
    main()
