"""UNRUN independent colored endpoint consumer, using physical data only.

No proxy-representation or colored-solver import is used for acceptance.
A future source-bound wrapper must bind the actual pools, domain specifications,
color masses and target. This module supplies the literal mathematical replay.
"""
from fractions import Fraction as Q


def rank(vectors):
    rows = {}
    for value in vectors:
        assert type(value) is int and value >= 0
        while value:
            pivot = value & -value
            if pivot in rows:
                value ^= rows[pivot]
            else:
                rows[pivot] = value
                break
    return len(rows)


def checked_indices(values, size):
    values = list(values)
    assert values == sorted(set(values))
    assert all(type(j) is int and 0 <= j < size for j in values)
    return values


def rebuild_domain(pool, opposite, spec, dimension):
    W = checked_indices(spec['selected_opposite'], len(opposite))
    selected = checked_indices(spec['selected_own'], len(pool))
    absent = checked_indices(spec['absent_own'], len(pool))
    assert not set(selected) & set(absent)
    result = dict(selected=selected, absent=absent, opposite=W, feasible=False)
    if rank(opposite[j] for j in W) != len(W):
        return result
    hits = [tuple(w for w in W if (u & opposite[w]).bit_count() % 2)
            for u in pool]
    if any(len(hits[j]) > 1 for j in selected):
        return result
    F = [j for j in selected if not hits[j]]
    E = [j for j in range(len(pool))
         if not hits[j] and j not in selected and j not in absent]
    if rank(pool[j] for j in F) != len(F):
        return result
    bins = []
    for w in W:
        forced = [j for j in selected if hits[j] == (w,)]
        if len(forced) > 1:
            return result
        allowed = forced if forced else [j for j in range(len(pool))
                                        if hits[j] == (w,) and j not in absent]
        if not allowed:
            return result
        bins.append(allowed)
    zero_rank = dimension-len(W)
    if rank(pool[j] for j in F+E) != zero_rank:
        return result
    return dict(result, feasible=True, F=F, E=E, bins=bins,
                zero_rank=zero_rank, dimension=dimension)


def physical_domain_rank(pool, domain, subset):
    """Independent contraction/direct-sum formula; no proxy rank is consulted."""
    assert domain['feasible']
    S = set(checked_indices(subset, len(pool)))
    F = domain['F']
    zero_part = [j for j in domain['E'] if j in S]
    return (len(S & set(F)) + rank(pool[j] for j in F+zero_part)-len(F)
            + sum(bool(S & set(B)) for B in domain['bins']))


def check_full_basis(pool, opposite, domain, basis):
    assert domain['feasible']
    B = checked_indices(basis, len(pool))
    S = set(B)
    assert len(B) == domain['dimension'] and rank(pool[j] for j in B) == len(B)
    assert set(domain['selected']) <= S and not set(domain['absent']) & S
    allowed = set(domain['F']+domain['E']) | {j for C in domain['bins'] for j in C}
    assert S <= allowed and set(domain['F']) <= S
    assert all(len(S & set(C)) == 1 for C in domain['bins'])
    assert len(S & set(domain['F']+domain['E'])) == domain['zero_rank']
    # Replay actual pairings, independently of the derived bucket descriptions.
    assert all(sum((pool[j] & opposite[w]).bit_count() % 2 for j in B) == 1
               for w in domain['opposite'])
    assert all(sum((pool[j] & opposite[w]).bit_count() % 2
                   for w in domain['opposite']) <= 1 for j in B)
    return B


def check_endpoint(pool, opposite_pool, domain_specs, color_masses, target,
                   endpoint, dimension=128, allow_inconclusive=False):
    pool, opposite = list(pool), list(opposite_pool)
    assert type(dimension) is int and dimension >= 0
    assert all(type(v) is int and 0 <= v < (1 << dimension)
               for v in pool+opposite)
    masses, q = list(map(Q, color_masses)), list(map(Q, target))
    colors, n = len(masses), len(pool)
    assert colors > 0 and len(domain_specs) == colors and len(q) == n
    assert min(masses) >= 0 and sum(masses) == 1
    assert min(q, default=0) >= 0 and sum(q) == dimension
    domains = [rebuild_domain(pool, opposite, spec, dimension) for spec in domain_specs]
    assert all(domain['feasible'] or not masses[c] for c, domain in enumerate(domains))
    D = int(endpoint['denominator'])
    assert D > 0 and all((v*D).denominator == 1 for v in masses+q)
    color_units = [int(v*D) for v in masses]
    wanted = [int(v*D) for v in q]
    assert endpoint['ground_size'] == n and endpoint['color_count'] == colors
    assert endpoint['common_rank'] == dimension
    assert list(map(Q, endpoint['color_masses'])) == masses
    assert list(map(int, endpoint['color_mass_numerators'])) == color_units
    assert list(map(int, endpoint['target_numerators'])) == wanted
    # Infeasible zero-mass colors have the explicitly declared rank-zero proxy.
    full_ranks = [dimension if domain['feasible'] else 0 for domain in domains]
    assert endpoint['full_ranks_by_color'] == full_ranks
    assert endpoint['positive_mass_colors'] == [c for c, m in enumerate(masses) if m]
    assert endpoint['zero_mass_colors'] == [c for c, m in enumerate(masses) if not m]
    achieved, actual_masses, seen = [0]*n, [0]*colors, set()
    for row in endpoint['bases']:
        color = row['color']
        assert type(color) is int and 0 <= color < colors and masses[color] > 0
        B = check_full_basis(pool, opposite, domains[color], row['indices'])
        key = color, tuple(B)
        assert key not in seen
        seen.add(key)
        weight = int(row['weight_numerator'])
        assert str(weight) == row['weight_numerator'] and weight > 0
        actual_masses[color] += weight
        for j in B:
            achieved[j] += weight
    assert actual_masses == color_units
    assert list(map(int, endpoint['achieved_color_mass_numerators'])) == actual_masses
    assert list(map(int, endpoint['achieved_numerators'])) == achieved
    assert sum(achieved) == dimension*D
    status = endpoint['status']
    cut = endpoint['violated_weighted_rank']
    if status == 'EXACT_COLORED_BASE_MIXTURE':
        assert achieved == wanted and cut is None
    elif status == 'EXACT_WEIGHTED_RANK_VIOLATION':
        assert cut is not None
        S = checked_indices(cut['indices'], n)
        ranks = [physical_domain_rank(pool, d, S) if d['feasible'] else 0
                 for d in domains]
        weighted = sum(w*r for w, r in zip(color_units, ranks))
        wanted_mass = sum(wanted[j] for j in S)
        gap = wanted_mass-weighted
        assert gap > 0 and cut['ranks_by_color'] == ranks
        assert int(cut['weighted_rank_numerator']) == weighted
        assert Q(cut['weighted_rank']) == Q(weighted, D)
        assert Q(cut['target_mass']) == Q(wanted_mass, D)
        assert Q(cut['exact_violation']) == Q(gap, D)
    else:
        assert status == 'BOUNDED_COLORED_PUSH_RELABEL_INCONCLUSIVE'
        assert allow_inconclusive and cut is None
    return dict(status='PASS_LITERAL_COLORED_PHYSICAL_ENDPOINT',
                endpoint_status=status, colors=colors,
                physical_full_bases_checked=len(seen),
                ground_marginals_checked=n, color_masses_checked=colors,
                uses_proxy_rank_for_acceptance=False,
                exact_membership=status == 'EXACT_COLORED_BASE_MIXTURE',
                exact_rank_rejection=status == 'EXACT_WEIGHTED_RANK_VIOLATION',
                cross_pattern_owner_lift_proved=False, source_C16_answered=False)
