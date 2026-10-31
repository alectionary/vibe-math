#!/usr/bin/env python3
"""Cache-update successor of the frozen exact binary-matroid membership solver.

The target has total mass equal to the matroid rank. No Caratheodory compression
is used: integer-unit pushes preserve a common rational denominator. Only an
independently checked basis mixture or a literal positive rank defect is proof.
Source: https://andrasfrank.web.elte.hu/cikkek/FrankJ62.PDF , pages4--5.
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
            p = value.bit_length()-1
            if p not in rows:
                rows[p] = value
                break
            value ^= rows[p]
    return len(rows)


def exchange_cached_rows(rows, old_expression, removed, inserted):
    """Keep physical echelon rows; substitute the exchanged coordinate."""
    assert old_expression >> removed & 1 and not old_expression >> inserted & 1
    delta = old_expression ^ (1 << inserted)
    return {pivot: (value, coefficients ^ delta if coefficients >> removed & 1 else coefficients)
            for pivot, (value, coefficients) in rows.items()}


def solve(vectors, target, *, seconds=60, maximum_steps=1000000,
          maximum_bases=5000, verify_invariants=False, initial=None):
    """Return exact endpoint evidence or an explicitly bounded inconclusive state.

    vectors: nonnegative Python integers representing GF(2) columns.
    target: nonnegative rational entries summing to the full binary rank.
    initial: optional list of (basis-index-list, rational-weight) pairs.
    Local indices, not physical pool indices, occur in the returned certificate.
    """
    start = time.monotonic()
    vectors = list(vectors)
    g = list(map(Fraction,target))
    n = len(vectors)
    assert n == len(g) and all(type(v) is int and v >= 0 for v in vectors)
    assert all(v >= 0 for v in g)
    r = binary_rank(vectors)
    assert sum(g) == r, ('Target must have total rank',sum(g),r)
    assert seconds > 0 and maximum_steps > 0 and maximum_bases > 0
    D = math.lcm(*(v.denominator for v in g)) if g else 1
    if initial is None:
        rows = {}
        B = 0
        for i in sorted(range(n),key=lambda j:(-g[j],j)):
            value = vectors[i]
            while value:
                p = value.bit_length()-1
                if p not in rows:
                    rows[p] = value
                    B |= 1 << i
                    break
                value ^= rows[p]
        assert B.bit_count() == r
        initial = [(list(indices(B)),Fraction(1))]
    else:
        initial = [(list(B),Fraction(w)) for B,w in initial]
        assert all(w >= 0 for B,w in initial) and sum(w for B,w in initial) == 1
        D = math.lcm(D,*(w.denominator for B,w in initial))
    weights = {}
    x = [0]*n
    for B,w in initial:
        assert len(B) == len(set(B)) == r and all(type(i) is int and 0 <= i < n for i in B)
        assert binary_rank(vectors[i] for i in B) == r
        bits = sum(1 << i for i in B)
        w = int(w*D)
        if w:
            weights[bits] = weights.get(bits,0)+w
            for i in B:
                x[i] += w
    gi = [int(v*D) for v in g]
    level = [0]*n
    cache = {}
    steps = pushes = lifts = neutralizations = circuit_queries = 0
    maximum_active = len(weights)
    cache_builds = cache_updates = cache_hits = 0
    maximum_cache_entries = 0
    status = 'BOUNDED_PUSH_RELABEL_INCONCLUSIVE'
    reason = None
    violated = None

    def circuit(B,s):
        nonlocal circuit_queries, cache_builds, cache_hits, maximum_cache_entries
        circuit_queries += 1
        assert not (B >> s & 1)
        if B not in cache:
            cache_builds += 1
            rows = {}
            for j in indices(B):
                v = vectors[j]
                mask = 1 << j
                while v:
                    p = v.bit_length()-1
                    if p not in rows:
                        rows[p] = (v,mask)
                        break
                    row, combination = rows[p]
                    v ^= row
                    mask ^= combination
                assert v, 'Dependent alleged basis'
            assert len(rows) == r
            cache[B] = rows
            maximum_cache_entries = max(maximum_cache_entries, len(cache))
        else:
            cache_hits += 1
        rows = cache[B]
        v = vectors[s]
        mask = 0
        while v:
            p = v.bit_length()-1
            assert p in rows, 'Alleged basis fails to span the ground set'
            row, combination = rows[p]
            v ^= row
            mask ^= combination
        return mask | (1 << s)

    def invariants():
        assert sum(weights.values()) == D and all(w > 0 for w in weights.values())
        check = [0]*n
        for B,w in weights.items():
            assert B.bit_count() == r and binary_rank(vectors[i] for i in indices(B)) == r
            for i in indices(B):
                check[i] += w
        assert x == check and sum(x) == r*D
        assert all(0 <= h <= n for h in level)
        assert all(level[i] == 0 for i in range(n) if x[i] > gi[i])
        for B in weights:
            for s in range(n):
                if not (B >> s & 1):
                    assert min(level[j] for j in indices(circuit(B,s))) >= level[s]-1

    while True:
        if verify_invariants:
            invariants()
        deficient = [i for i in range(n) if x[i] < gi[i]]
        if not deficient:
            assert x == gi
            status = 'EXACT_BASE_MIXTURE'
            reason = 'NO_DEFICIENT_COORDINATE'
            break
        occupied = set(level)
        lowest_deficit = min(level[i] for i in deficient)
        empty = next((h for h in range(lowest_deficit) if h not in occupied),None)
        if empty is not None:
            S = [i for i in range(n) if level[i] > empty]
            rank = binary_rank(vectors[i] for i in S)
            gap = sum(gi[i] for i in S)-D*rank
            assert gap > 0, ('Gap endpoint does not give an exact rank violation',gap)
            violated = dict(indices=S,rank=rank,exact_violation=str(Fraction(gap,D)),empty_level=empty)
            status = 'EXACT_RANK_VIOLATION'
            reason = 'EMPTY_LEVEL_CUT'
            break
        if time.monotonic()-start >= seconds or steps >= maximum_steps or len(weights) > maximum_bases:
            reason = 'TIME_LIMIT' if time.monotonic()-start >= seconds else ('STEP_LIMIT' if steps >= maximum_steps else 'ACTIVE_BASIS_LIMIT')
            break
        eligible = [i for i in deficient if level[i] < n]
        assert eligible, 'Missing empty-level stopping condition'
        s = max(eligible,key=lambda i:(level[i],-i))
        chosen = None
        for B,w in weights.items():
            if B >> s & 1:
                continue
            C = circuit(B,s)
            if verify_invariants:
                assert min(level[i] for i in indices(C)) >= level[s]-1
            t = next((i for i in indices(C & B) if level[i] == level[s]-1),None)
            if t is not None:
                chosen = (B,w,t)
                break
        if chosen is None:
            level[s] += 1
            lifts += 1
        else:
            B,w,t = chosen
            deficit = gi[s]-x[s]
            delta = min(deficit,w)
            newB = (B ^ (1 << t)) | (1 << s)
            if newB not in cache:
                cache[newB] = exchange_cached_rows(cache[B], C ^ (1 << s), t, s)
                cache_updates += 1
                maximum_cache_entries = max(maximum_cache_entries, len(cache))
            if delta == w:
                del weights[B]
                cache.pop(B,None)
            else:
                weights[B] -= delta
            weights[newB] = weights.get(newB,0)+delta
            x[s] += delta
            x[t] -= delta
            pushes += 1
            neutralizations += int(delta == deficit)
            maximum_active = max(maximum_active,len(weights))
        steps += 1
    assert sum(weights.values()) == D and all(w > 0 for w in weights.values())
    return dict(status=status,stop_reason=reason,ground_size=n,rank=r,
                denominator=str(D),target_numerators=list(map(str,gi)),
                achieved_numerators=list(map(str,x)),levels=level,
                bases=[dict(indices=list(indices(B)),weight_numerator=str(w)) for B,w in weights.items()],
                violated_rank=violated,steps=steps,pushes=pushes,lifts=lifts,
                neutralizations=neutralizations,maximum_active_bases=maximum_active,
                circuit_queries=circuit_queries,seconds=time.monotonic()-start,
                cache_builds=cache_builds,cache_updates=cache_updates,cache_hits=cache_hits,maximum_cache_entries=maximum_cache_entries,
                compression_used=False,source_C16_answered=False,
                scope='Exact local binary-matroid endpoint certificate requires independent replay; bounded unfinished state is not membership.')
