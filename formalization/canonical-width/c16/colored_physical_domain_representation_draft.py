"""UNRUN binary representation of a conditioned physical sector domain.

No imports or tests of this draft have been performed. All indices refer to
the original physical pool. The representation is a direct sum: private
coloops for the jointly forced zero vectors, their physical quotient shifted
above all private bits, and one private parallel class per effective owner
bin. Other indices are loops. Ambient bit width may exceed the physical
dimension; the full matroid rank remains exactly that dimension.
"""


def high_basis(vectors):
    rows = {}
    for value in vectors:
        while value:
            pivot = value.bit_length()-1
            if pivot not in rows:
                rows[pivot] = value
                break
            value ^= rows[pivot]
    return rows


def remainder(value, rows):
    for pivot in sorted(rows, reverse=True):
        if value >> pivot & 1:
            value ^= rows[pivot]
    return value


def source_domain(pool, opposite_pool, selected_opposite, selected_own,
                  absent_own, dimension=128):
    """Construct one domain from literal physical pairings, without a solver."""
    pool, opposite_pool = list(pool), list(opposite_pool)
    assert type(dimension) is int and dimension >= 0
    assert all(type(v) is int and 0 <= v < (1 << dimension)
               for v in pool+opposite_pool)
    selected_opposite, selected_own, absent_own = (
        list(selected_opposite), list(selected_own), list(absent_own))
    for values, size in [(selected_opposite, len(opposite_pool)),
                         (selected_own, len(pool)), (absent_own, len(pool))]:
        assert values == sorted(set(values))
        assert all(type(j) is int and 0 <= j < size for j in values)
    assert not set(selected_own) & set(absent_own)
    base = dict(selected_opposite=selected_opposite, selected_own=selected_own,
                absent_own=absent_own, dimension=dimension, ground_size=len(pool))
    if len(high_basis(opposite_pool[j] for j in selected_opposite)) != len(selected_opposite):
        return dict(base, feasible=False, reason='DEPENDENT_OPPOSITE')
    signatures = [tuple(j for j in selected_opposite
                        if (value & opposite_pool[j]).bit_count() & 1)
                  for value in pool]
    if any(len(signatures[j]) > 1 for j in selected_own):
        return dict(base, feasible=False, reason='FORCED_MULTIBIT')
    forced_zero = [j for j in selected_own if not signatures[j]]
    own = set(selected_own) | set(absent_own)
    zero_free = [j for j, signature in enumerate(signatures)
                 if not signature and j not in own]
    if len(high_basis(pool[j] for j in forced_zero)) != len(forced_zero):
        return dict(base, feasible=False, reason='DEPENDENT_FORCED_ZERO')
    bins = []
    for opposite in selected_opposite:
        forced = [j for j in selected_own if signatures[j] == (opposite,)]
        if len(forced) > 1:
            return dict(base, feasible=False, reason='FORCED_OWNER_COLLISION')
        choices = forced or [j for j, signature in enumerate(signatures)
                             if signature == (opposite,) and j not in absent_own]
        if not choices:
            return dict(base, feasible=False, reason='EMPTY_OWNER_BIN')
        bins.append(choices)
    required = dimension-len(selected_opposite)
    if len(high_basis(pool[j] for j in forced_zero+zero_free)) != required:
        return dict(base, feasible=False, reason='DEFICIENT_ZERO_POOL')
    return dict(base, feasible=True, reason=None, zero_forced=forced_zero,
                zero_free=zero_free, zero_required=required, owner_bins=bins)


def represent(pool, domain):
    """Return an exact binary direct-sum proxy for one feasible domain.

    An infeasible zero-mass color should instead be handled by the caller's
    explicit zero-color convention. This function never represents an empty
    positive-mass domain as a rank-zero matroid.
    """
    assert domain['feasible']
    pool = list(pool)
    n, dimension = len(pool), domain['dimension']
    assert n == domain['ground_size']
    forced, free, bins = (domain[k] for k in ('zero_forced', 'zero_free', 'owner_bins'))
    assert forced == sorted(set(forced)) and free == sorted(set(free))
    assert not set(forced) & set(free)
    pieces = [set(forced), set(free), *map(set, bins)]
    assert sum(map(len, pieces)) == len(set().union(*pieces))
    assert all(B == sorted(set(B)) and B for B in bins)
    assert all(type(j) is int and 0 <= j < n for piece in pieces for j in piece)
    forced_rows = high_basis(pool[j] for j in forced)
    assert len(forced_rows) == len(forced)
    private_bits = len(forced)+len(bins)
    vectors = [0]*n
    for k, j in enumerate(forced):
        vectors[j] = 1 << k
    for j in free:
        vectors[j] = remainder(pool[j], forced_rows) << private_bits
    for k, choices in enumerate(bins):
        for j in choices:
            vectors[j] = 1 << (len(forced)+k)
    quotient_rank = len(high_basis(remainder(pool[j], forced_rows) for j in free))
    assert quotient_rank == domain['zero_required']-len(forced)
    assert len(high_basis(vectors)) == dimension
    return dict(implementation_status='UNRUN_DRAFT_REQUIRES_INDEPENDENT_CONTROLS',
                vectors=vectors, ground_size=n, full_rank=dimension,
                ambient_bit_width=max((v.bit_length() for v in vectors), default=0),
                private_bits=private_bits, forced_coloop_indices=forced,
                quotient_zero_indices=free, effective_owner_bins=bins,
                scope='Auxiliary domain matroid on physical indices; its subset '
                      'rank is not generally the ordinary physical subset rank.')
