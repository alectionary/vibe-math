#!/usr/bin/env python3
"""Independent exact full-basis support and literal low-dimensional controls.

Physical acceptance imports no producer elimination or support routine. It
rebuilds source pools, evaluation bins and ranks by low-pivot elimination. A
sorted-prefix rank upper bound certifies every arbitrary signed objective; the
saved128-vector physical basis attains it. The producer is called only inside
small exhaustive controls, where every opposite basis is literally enumerated.
"""
from pathlib import Path
from fractions import Fraction
from itertools import combinations
import argparse
import gzip
import hashlib
import json
import time
from verify_algebraic_model import physical

ROOT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    raw = Path(path).read_bytes()
    return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)


def extend(rows, value):
    while value:
        low = value & -value
        if low in rows:
            value ^= rows[low]
        else:
            rows[low] = value
            return True
    return False


def dimension(vectors):
    rows = {}
    for value in vectors:
        extend(rows, value)
    return len(rows)


def rotate(mask, h):
    return ((mask << h) & 65535) | (mask >> (16-h))


def rebuild_domain(X, Z, selected, n):
    k = len(selected)
    selected_rank = dimension(X[i] for i in selected)
    if selected_rank != k:
        return {'status': 'EXCLUDED_DEPENDENT_SELECTED_X', 'selected_rank': selected_rank}
    signatures = [sum(((X[i] & z).bit_count() % 2) << h for h, i in enumerate(selected)) for z in Z]
    zero = [j for j, signature in enumerate(signatures) if signature == 0]
    bins = [[j for j, signature in enumerate(signatures) if signature == 1 << h] for h in range(k)]
    zero_rank = dimension(Z[j] for j in zero)
    assert zero_rank <= n-k
    status = 'FULL_PARTNER_BASIS_DOMAIN'
    if zero_rank != n-k:
        status = 'EXCLUDED_DEFICIENT_ZERO_POOL'
    elif any(not b for b in bins):
        status = 'EXCLUDED_EMPTY_REQUIRED_OWNER'
    return {'status': status, 'selected_rank': selected_rank, 'zero_rank': zero_rank,
            'zero': zero, 'bins': bins, 'signatures': signatures}


def check_support(Z, selected, n, domain, weights, record):
    if domain['status'] != 'FULL_PARTNER_BASIS_DOMAIN':
        assert record['status'] == domain['status'] and record['value'] is None
        assert not record['selected_Z_indices']
        return 0
    assert record['status'] == 'EXACT_FULL_PARTNER_BASIS_SUPPORT'
    chosen = record['selected_Z_indices']
    assert len(chosen) == len(set(chosen)) == n
    assert all(0 <= j < len(Z) for j in chosen)
    assert dimension(Z[j] for j in chosen) == n
    zeros = record['zero_basis_indices']
    owners = record['owner_indices']
    assert list(chosen) == list(zeros)+list(owners)
    assert len(zeros) == n-len(selected) and len(owners) == len(selected)
    assert all(j in domain['zero'] for j in zeros)
    assert all(j in b for j, b in zip(owners, domain['bins']))
    exact = Fraction(record['value'])
    assert exact == sum(weights[j] for j in chosen)
    # Any full zero basis I satisfies |I intersection prefix_t| <= rank(prefix_t).
    # Telescoping includes the final (possibly negative) weight times FULL rank.
    ordered = sorted(domain['zero'], key=lambda j: (-weights[j], j))
    rows = {}
    ranks = []
    for j in ordered:
        extend(rows, Z[j])
        ranks.append(len(rows))
    assert len(rows) == n-len(selected)
    upper = Fraction(0)
    if ordered:
        upper = weights[ordered[-1]]*len(rows)
        upper += sum((weights[ordered[t]]-weights[ordered[t+1]])*ranks[t] for t in range(len(ordered)-1))
    upper += sum(max(weights[j] for j in b) for b in domain['bins'])
    assert exact == upper, ('support_not_optimal', exact, upper)
    return len(ordered)


def small_controls():
    from full_partner_basis_oracle import FullPartnerBasisOracle
    n = 3
    X = list(range(1, 8))
    pools = [list(range(1, 8)), [2, 4, 6], [1, 2, 3]]
    cases = rejected = feasible = negative = zero = 0
    statuses = {}
    for Z in pools:
        oracle = FullPartnerBasisOracle(X, Z, n)
        bases = [b for b in combinations(range(len(Z)), n) if dimension(Z[j] for j in b) == n]
        weights_list = [[0]*len(Z), [-1-j for j in range(len(Z))],
                        [(5*j+2) % 9-4 for j in range(len(Z))],
                        [Fraction((-1)**j*(j+1), 3) for j in range(len(Z))]]
        for size in range(4):
            for selected in combinations(range(len(X)), size):
                domain = oracle.prepare_selected(selected)
                independent_domain = rebuild_domain(X, Z, selected, n)
                assert domain['status'] == independent_domain['status']
                statuses[domain['status']] = statuses.get(domain['status'], 0)+1
                possible = []
                for b in bases:
                    matrix = [[(X[i] & Z[j]).bit_count() % 2 for j in b] for i in selected]
                    if all(sum(row) == 1 for row in matrix) and all(sum(matrix[i][j] for i in range(size)) <= 1 for j in range(n)):
                        possible.append(b)
                for weights in weights_list:
                    observed = oracle.support(domain, weights)
                    best = max((sum(weights[j] for j in b) for b in possible), default=None)
                    assert observed['value'] == best
                    check_support(Z, selected, n, independent_domain, weights, observed)
                    if best is None:
                        rejected += 1
                    else:
                        feasible += 1
                        assert len(observed['selected_Z_indices']) == n
                        negative += all(w < 0 for w in weights) and best < 0
                        zero += all(w == 0 for w in weights) and best == 0
                    cases += 1
    # A float must never silently enter an exact support certificate.
    oracle = FullPartnerBasisOracle(X, pools[0], n)
    try:
        oracle.support(oracle.prepare_selected([]), [0.0]*7)
    except TypeError:
        float_rejected = True
    else:
        raise AssertionError('inexact support weights accepted')
    assert negative and zero
    assert all(status in statuses for status in ['EXCLUDED_DEPENDENT_SELECTED_X', 'EXCLUDED_DEFICIENT_ZERO_POOL', 'EXCLUDED_EMPTY_REQUIRED_OWNER'])
    return {'literal_exhaustive_support_cases': cases, 'feasible_cases': feasible,
            'excluded_cases': rejected, 'strictly_negative_full_basis_controls': negative,
            'zero_weight_full_basis_controls': zero, 'domain_status_counts': statuses,
            'inexact_float_weights_rejected': float_rejected,
            'rational_weight_controls': True}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--bank', type=Path, required=True)
    ap.add_argument('--frozen', type=Path)
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    start = time.monotonic()
    bank = read(args.bank)
    frozen_path = args.frozen or args.bank.with_suffix('.frozen.json')
    frozen = read(frozen_path)
    assert bank['frozen_sha256'] == sha(frozen_path)
    assert bank['producer_sha256'] == frozen['producer_sha256'] == sha(ROOT / 'full_partner_basis_oracle.py')
    assert frozen['source_sha256'] == sha(ROOT / 'physical-pool-source.json')
    assert all(frozen['pool_sha256'][s] == sha(ROOT / f'pools/{s}coords.txt') for s in 'xz')
    profile_path = ROOT / 'algebraic-results/orbit-rank-profiles.json.gz'
    hull_path = ROOT / 'algebraic-results/hulls-16-rank.json.gz'
    assert frozen['profiles_sha256'] == sha(profile_path) and frozen['hulls_sha256'] == sha(hull_path)
    X, Z, A = physical()
    for side, values in [('x', X), ('z', Z)]:
        assert values == [int(v, 16) for v in (ROOT / f'pools/{side}coords.txt').read_text().split()]
    assert dimension(X) == dimension(Z) == 128
    orbit = bank['orbit']
    assert orbit == frozen['orbit']
    assert bank['extra_X_indices'] == frozen['extra_X_indices']
    profiles = read(profile_path)
    row = next(r for r in profiles['records'] if r['orbit'] == orbit)
    forbidden = [c['mask'] for c in row['minimal_bad_certificates']]
    allowed = [m for m in range(65536) if not (orbit == 12 and m.bit_count() > 11) and not any(m & b == b for b in forbidden)]
    assert len(allowed) == frozen['allowed_mask_count'] == next(r for r in read(hull_path)['records'] if r['orbit'] == orbit)['phase_patterns']
    representatives = sorted({min(rotate(m, h) for h in range(16)) for m in allowed})
    assert representatives == frozen['representatives'] == [r['mask'] for r in bank['records']]
    assert len(representatives) == bank['representatives']
    weight_sets = {r['name']: list(map(Fraction, r['weights'])) for r in frozen['weight_sets']}
    assert len(weight_sets) == bank['weight_sets']
    queries = prefix_checks = negative_queries = feasible = 0
    negative_controls = 0
    for record in bank['records']:
        mask = record['mask']
        selected = sorted(set([16*orbit+h for h in range(16) if mask >> h & 1]+frozen['extra_X_indices']))
        saved_domain = record['domain']
        assert saved_domain['selected_X_indices'] == selected and saved_domain['dimension'] == 128
        assert saved_domain['zero_basis_required'] == 128-len(selected)
        domain = rebuild_domain(X, Z, selected, 128)
        assert saved_domain['status'] == domain['status']
        assert saved_domain['selected_rank'] == domain['selected_rank']
        if 'zero' in domain:
            assert record['zero_count'] == len(domain['zero'])
            assert record['owner_counts'] == list(map(len, domain['bins']))
            assert saved_domain['zero_rank'] == domain['zero_rank']
        if domain['status'] == 'FULL_PARTNER_BASIS_DOMAIN':
            feasible += 1
        assert {r['weight_set'] for r in record['supports']} == set(weight_sets)
        assert len(record['supports']) == len(weight_sets)
        for support in record['supports']:
            weights = weight_sets[support['weight_set']]
            prefix_checks += check_support(Z, selected, 128, domain, weights, support)
            queries += 1
            if all(w < 0 for w in weights) and support['value'] is not None:
                assert Fraction(support['value']) < 0 and len(support['selected_Z_indices']) == 128
                negative_queries += 1
            if not negative_controls and support['value'] is not None:
                for mode in ('empty_basis', 'short_basis', 'wrong_objective'):
                    corrupt = dict(support)
                    if mode == 'empty_basis':
                        corrupt['selected_Z_indices'] = []
                    elif mode == 'short_basis':
                        corrupt['selected_Z_indices'] = corrupt['selected_Z_indices'][:-1]
                    else:
                        corrupt['value'] = str(Fraction(corrupt['value'])+1)
                    try:
                        check_support(Z, selected, 128, domain, weights, corrupt)
                    except AssertionError:
                        negative_controls += 1
                    else:
                        raise AssertionError(('corruption accepted', mode))
    assert queries == bank['support_queries'] and feasible == bank['feasible_domains']
    controls = small_controls()
    out = {'status': 'PASS', 'source_C16_answered': False, 'bank_sha256': sha(args.bank),
           'frozen_sha256': sha(frozen_path), 'producer_sha256': bank['producer_sha256'],
           'consumer_sha256': sha(Path(__file__)), 'source_sha256': frozen['source_sha256'],
           'pool_sha256': frozen['pool_sha256'], 'orbit': orbit,
           'extra_X_indices': frozen['extra_X_indices'], 'allowed_masks_independently_enumerated': len(allowed),
           'rotation_representatives_checked': len(representatives), 'empty_mask_included': 0 in representatives,
           'feasible_full_partner_domains': feasible, 'exact_signed_support_queries_checked': queries,
           'exact_prefix_rank_checks': prefix_checks, 'strictly_negative_full128_basis_queries': negative_queries,
           'corrupted_support_controls_rejected': negative_controls, 'literal_small_controls': controls,
           'physical_reconstruction_dependencies': {p: sha(ROOT/p) for p in ['verify_algebraic_model.py', 'verify_partial_frame.py', 'audit_pools.py']},
           'elapsed_seconds': time.monotonic()-start,
           'scope': 'Exact support for the one-sided full128-Z-basis necessity at the stated rotation representatives and frozen signed weights. Generic benchmark weights are not claimed rotation-equivariant; this receipt is not a support cut over all4597 masks or a physical full dual frame.'}
    args.output.write_text(json.dumps(out, indent=2)+'\n')
    print(out, flush=True)


if __name__ == '__main__':
    main()
