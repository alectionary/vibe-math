#!/usr/bin/env python3
"""UNRUN draft: exact colored basis mixtures and literal weighted-rank cuts.

This file has not been imported, run, or tested. It is a standalone successor
draft; no frozen one-matroid implementation is changed. The weighted base
polytope identity motivating it is recorded in CONDITIONAL-OWNER-LIFT.md.

Each positive-mass color has a binary matroid on the same indexed ground set,
with a common full rank r. A colored mixture has exactly the prescribed mass
in each color. Its marginal belongs to sum_c mass[c]*B(M_c). All exchanges
preserve color. A reported cut is checked literally against
sum_c mass[c]*rank_c(S), without a maximum-defect or runtime claim.

Zero-mass colors are retained in the input/output inventory, never acquire
positive basis weight, and may have a different rank because their weighted
contribution is zero. Positive-mass colors must have common rank.
"""
from fractions import Fraction
import math
import time


def indices(bits):
    while bits:
        low = bits & -bits
        yield low.bit_length()-1
        bits ^= low


def binary_rank(vectors):
    rows = {}
    for value in vectors:
        while value:
            pivot = value.bit_length()-1
            if pivot not in rows:
                rows[pivot] = value
                break
            value ^= rows[pivot]
    return len(rows)


def exchange_cached_rows(rows, old_expression, removed, inserted):
    assert old_expression >> removed & 1
    assert not old_expression >> inserted & 1
    delta = old_expression ^ (1 << inserted)
    return {
        pivot: (value, coefficients ^ delta
                if coefficients >> removed & 1 else coefficients)
        for pivot, (value, coefficients) in rows.items()
    }


def solve(vectors_by_color, color_masses, target, *, seconds=60,
          maximum_steps=1000000, maximum_bases=5000,
          verify_invariants=False, initial=None):
    """Return a colored mixture, a weighted-rank violation, or bounded state.

    vectors_by_color: sequence of equal-length sequences of nonnegative ints.
    color_masses: nonnegative rational absolute masses, summing exactly to one.
    target: nonnegative rational marginal, total equal to the common rank of
            the positive-mass colors.
    initial: optional sequence (color_index, basis_index_list, absolute_weight).
             Weights must sum to color_masses[color] separately for every
             color. Duplicate (color,basis) records are combined. Zero-weight
             records are validated and then discarded.

    Caps limit discovery; a bounded endpoint is not a membership conclusion.
    The returned basis weights share one exact denominator with the target,
    color masses, and every warm-start weight. No compression is attempted.
    """
    started = time.monotonic()
    vectors = [list(pool) for pool in vectors_by_color]
    masses = list(map(Fraction, color_masses))
    g = list(map(Fraction, target))
    colors, n = len(vectors), len(g)
    assert colors > 0 and len(masses) == colors
    assert all(len(pool) == n for pool in vectors)
    assert all(type(v) is int and v >= 0 for pool in vectors for v in pool)
    assert all(m >= 0 for m in masses) and sum(masses) == 1
    assert all(v >= 0 for v in g)
    assert seconds > 0 and maximum_steps > 0 and maximum_bases > 0
    ranks = [binary_rank(pool) for pool in vectors]
    positive = [color for color, mass in enumerate(masses) if mass]
    common_rank = ranks[positive[0]]
    assert all(ranks[color] == common_rank for color in positive)
    assert sum(g) == common_rank

    if initial is None:
        initial = []
        for color in positive:
            rows, bits = {}, 0
            for j in sorted(range(n), key=lambda k: (-g[k], k)):
                value = vectors[color][j]
                while value:
                    pivot = value.bit_length()-1
                    if pivot not in rows:
                        rows[pivot] = value
                        bits |= 1 << j
                        break
                    value ^= rows[pivot]
            assert bits.bit_count() == common_rank
            initial.append((color, list(indices(bits)), masses[color]))
    else:
        initial = [(color, list(basis), Fraction(weight))
                   for color, basis, weight in initial]

    warm_masses = [Fraction(0)]*colors
    for color, basis, weight in initial:
        assert type(color) is int and 0 <= color < colors
        assert weight >= 0
        assert len(basis) == len(set(basis)) == ranks[color]
        assert all(type(j) is int and 0 <= j < n for j in basis)
        assert binary_rank(vectors[color][j] for j in basis) == ranks[color]
        warm_masses[color] += weight
    assert warm_masses == masses, 'warm-start mass must match every color'
    denominator = math.lcm(
        *[q.denominator for q in g+masses],
        *[weight.denominator for _, _, weight in initial])
    color_units = [int(mass*denominator) for mass in masses]
    target_units = [int(q*denominator) for q in g]
    weights, x = {}, [0]*n
    for color, basis, weight in initial:
        assert (weight*denominator).denominator == 1
        units = int(weight*denominator)
        if not units:
            continue
        assert masses[color] > 0 and len(basis) == common_rank
        bits = sum(1 << j for j in basis)
        key = (color, bits)
        weights[key] = weights.get(key, 0)+units
        for j in basis:
            x[j] += units

    level = [0]*n
    cache = {}
    steps = pushes = lifts = neutralizations = circuit_queries = 0
    cache_builds = cache_updates = cache_hits = gap_rank_checks = 0
    maximum_active = len(weights)
    maximum_cached = 0
    status = 'BOUNDED_COLORED_PUSH_RELABEL_INCONCLUSIVE'
    reason = None
    violation = None

    def circuit(color, bits, s):
        nonlocal circuit_queries, cache_builds, cache_hits, maximum_cached
        circuit_queries += 1
        assert not bits >> s & 1
        key = (color, bits)
        if key not in cache:
            cache_builds += 1
            rows = {}
            for j in indices(bits):
                value, expression = vectors[color][j], 1 << j
                while value:
                    pivot = value.bit_length()-1
                    if pivot not in rows:
                        rows[pivot] = (value, expression)
                        break
                    row, old_expression = rows[pivot]
                    value ^= row
                    expression ^= old_expression
                assert value, 'dependent alleged colored basis'
            assert len(rows) == common_rank
            cache[key] = rows
            maximum_cached = max(maximum_cached, len(cache))
        else:
            cache_hits += 1
        rows = cache[key]
        value, expression = vectors[color][s], 0
        while value:
            pivot = value.bit_length()-1
            assert pivot in rows, 'basis does not span its own color ground set'
            row, old_expression = rows[pivot]
            value ^= row
            expression ^= old_expression
        return expression | (1 << s)

    def invariants():
        assert all(weight > 0 for weight in weights.values())
        checked_masses = [0]*colors
        checked = [0]*n
        for (color, bits), weight in weights.items():
            assert color_units[color] > 0
            assert bits.bit_count() == common_rank
            assert binary_rank(vectors[color][j] for j in indices(bits)) == common_rank
            checked_masses[color] += weight
            for j in indices(bits):
                checked[j] += weight
        assert checked_masses == color_units
        assert sum(checked_masses) == denominator
        assert checked == x and sum(x) == common_rank*denominator
        assert all(0 <= height <= n for height in level)
        assert all(level[j] == 0 for j in range(n) if x[j] > target_units[j])
        for color, bits in weights:
            for s in range(n):
                if not bits >> s & 1:
                    C = circuit(color, bits, s)
                    assert min(level[j] for j in indices(C)) >= level[s]-1

    while True:
        if verify_invariants:
            invariants()
        deficient = [j for j in range(n) if x[j] < target_units[j]]
        if not deficient:
            assert x == target_units
            status = 'EXACT_COLORED_BASE_MIXTURE'
            reason = 'NO_DEFICIENT_COORDINATE'
            break

        occupied = set(level)
        highest_deficit = max(level[j] for j in deficient)
        for empty_level in range(highest_deficit):
            if empty_level in occupied:
                continue
            subset = [j for j in range(n) if level[j] > empty_level]
            subset_ranks = [binary_rank(pool[j] for j in subset) for pool in vectors]
            weighted_units = sum(mass*rank
                                 for mass, rank in zip(color_units, subset_ranks))
            target_mass_units = sum(target_units[j] for j in subset)
            gap = target_mass_units-weighted_units
            gap_rank_checks += 1
            # Only the literal positive weighted-rank inequality is a claim.
            if gap > 0:
                violation = dict(
                    indices=subset, ranks_by_color=subset_ranks,
                    weighted_rank_numerator=str(weighted_units),
                    weighted_rank=str(Fraction(weighted_units, denominator)),
                    target_mass=str(Fraction(target_mass_units, denominator)),
                    exact_violation=str(Fraction(gap, denominator)),
                    empty_level=empty_level)
                status = 'EXACT_WEIGHTED_RANK_VIOLATION'
                reason = 'EMPTY_LEVEL_LITERAL_POSITIVE_WEIGHTED_RANK_CUT'
                break
        if violation is not None:
            break
        if time.monotonic()-started >= seconds:
            reason = 'TIME_LIMIT'
            break
        if steps >= maximum_steps:
            reason = 'STEP_LIMIT'
            break
        if len(weights) > maximum_bases:
            reason = 'INITIAL_ACTIVE_BASIS_LIMIT'
            break
        eligible = [j for j in deficient if level[j] < n]
        if not eligible:
            reason = 'BOUNDED_LEVEL_CAP_WITHOUT_LITERAL_CERTIFICATE'
            break
        s = max(eligible, key=lambda j: (level[j], -j))
        chosen = None
        for (color, bits), weight in weights.items():
            if bits >> s & 1:
                continue
            C = circuit(color, bits, s)
            if verify_invariants:
                assert min(level[j] for j in indices(C)) >= level[s]-1
            t = next((j for j in indices(C & bits)
                      if level[j] == level[s]-1), None)
            if t is not None:
                chosen = (color, bits, weight, t, C)
                break
        if chosen is None:
            level[s] += 1
            lifts += 1
        else:
            color, bits, weight, t, C = chosen
            deficit = target_units[s]-x[s]
            delta = min(deficit, weight)
            new_bits = (bits ^ (1 << t)) | (1 << s)
            old_key, new_key = (color, bits), (color, new_bits)
            resulting_count = len(weights)+int(new_key not in weights)-int(delta == weight)
            if resulting_count > maximum_bases:
                reason = 'ACTIVE_BASIS_LIMIT_BEFORE_SPLIT'
                break
            if new_key not in cache:
                cache[new_key] = exchange_cached_rows(
                    cache[old_key], C ^ (1 << s), t, s)
                cache_updates += 1
                maximum_cached = max(maximum_cached, len(cache))
            if delta == weight:
                del weights[old_key]
                cache.pop(old_key, None)
            else:
                weights[old_key] -= delta
            weights[new_key] = weights.get(new_key, 0)+delta
            x[s] += delta
            x[t] -= delta
            pushes += 1
            neutralizations += int(delta == deficit)
            maximum_active = max(maximum_active, len(weights))
        steps += 1

    final_masses = [0]*colors
    for (color, bits), weight in weights.items():
        assert weight > 0
        final_masses[color] += weight
    assert final_masses == color_units and sum(final_masses) == denominator
    return dict(
        implementation_status='UNRUN_DRAFT_REQUIRES_INDEPENDENT_CONTROLS',
        status=status, stop_reason=reason, ground_size=n, common_rank=common_rank,
        color_count=colors, full_ranks_by_color=ranks,
        color_masses=list(map(str, masses)), positive_mass_colors=positive,
        zero_mass_colors=[c for c in range(colors) if not masses[c]],
        zero_mass_colors_ignored_for_common_rank=True,
        denominator=str(denominator),
        color_mass_numerators=list(map(str, color_units)),
        achieved_color_mass_numerators=list(map(str, final_masses)),
        target_numerators=list(map(str, target_units)),
        achieved_numerators=list(map(str, x)), levels=level,
        bases=[dict(color=color, indices=list(indices(bits)), weight_numerator=str(weight))
               for (color, bits), weight in weights.items()],
        violated_weighted_rank=violation,
        steps=steps, pushes=pushes, lifts=lifts, neutralizations=neutralizations,
        maximum_active_bases=maximum_active, circuit_queries=circuit_queries,
        cache_builds=cache_builds, cache_updates=cache_updates, cache_hits=cache_hits,
        maximum_cache_entries=maximum_cached, early_gap_rank_checks=gap_rank_checks,
        seconds=time.monotonic()-started, compression_used=False,
        maximum_defect_optimality_proved=False, runtime_guarantee_claimed=False,
        source_C16_answered=False,
        scope='Exact colored endpoint candidate requires independent replay. A bounded '
              'state proves no membership; a local weighted-rank result is not a '
              'cross-pattern owner-lift or full-frame conclusion.')
