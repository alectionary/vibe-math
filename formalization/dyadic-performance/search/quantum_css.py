"""Literal P11 Constructions 3.10 and 3.11 and exact small logical spectra.

Rows are check-block rows. Finite computations, not Lean certificates.
"""
from collections import Counter, defaultdict
from itertools import combinations, permutations
import pilot as p


def four_cycles():
    """All permutations of order four on four symbols, in fixed order."""
    out = []
    for cycle in permutations((1, 2, 3)):
        order = (0,)+cycle
        tau = [0]*4
        for a, b in zip(order, order[1:]+order[:1]):
            tau[a] = b
        out.append(tau)
    return out


def source310(x, y, tau):
    """Equation (8)'s arrays, sigma=(0 1 2 3); commutation must be checked."""
    assert len(x) == len(y) == 4 and tau in four_cycles()
    index = list(range(4))
    bx, bz = [], []
    for i in range(4):
        bx.append([x[(j+i) % 4] for j in range(4)]+[y[(j+i) % 4] for j in range(4)])
        bz.append([y[j] for j in index]+[x[j] for j in index])
        index = [tau[j] for j in index]
    return bx, bz


def source311(x):
    """Equation (9), fixed P=P_0, all four displayed rows retained."""
    v = len(x)
    assert v >= 2
    alternating = lambda left, right: [entry for pair in zip(left, right) for entry in pair]
    zeros = [0]*v
    h = [alternating(zeros, x),
         alternating(x[-1:]+x[:-1], zeros),
         alternating(zeros, list(reversed(x))),
         alternating(x[:1]+list(reversed(x[1:])), zeros)]
    return h, [row[:] for row in h]


def block_commutes(bx, bz):
    return all(not any(value % 2 for value in Counter(a ^ b for a, b in zip(rx, rz)).values())
               for rx in bx for rz in bz)


def expansion(bx, bz, ell):
    hx, vx = p.construction(bx, ell)
    hz, vz = p.construction(bz, ell)
    xm, zm = list(map(p.decoder.rowmask, hx)), list(map(p.decoder.rowmask, hz))
    assert block_commutes(bx, bz) == all(p.popcount(x & z) % 2 == 0 for x in xm for z in zm)
    return hx, hz, vx, vz


def logical_spectrum(vn, stabilizers):
    """Enumerate every kernel support of weights 1..4, quotient by row span.

    Pair-syndrome buckets find triples and quadruples without iterating C(n,4).
    A zero syndrome is only a candidate logical: row-span membership decides.
    """
    columns = [sum(1 << c for c in cs) for cs in vn]
    by_column, pairs = defaultdict(list), defaultdict(list)
    for v, column in enumerate(columns):
        by_column[column].append(v)
    counts = {str(w): {'stabilizer': 0, 'logical': 0} for w in range(1, 5)}
    witnesses = {}

    def record(support):
        word = sum(1 << v for v in support)
        kind = 'stabilizer' if p.decoder.in_span(word, stabilizers) else 'logical'
        counts[str(len(support))][kind] += 1
        if kind == 'logical':
            witnesses.setdefault(str(len(support)), list(support))

    for v, column in enumerate(columns):
        if not column:
            record((v,))
    for a, b in combinations(range(len(columns)), 2):
        syndrome = columns[a] ^ columns[b]
        if not syndrome:
            record((a, b))
        for c in by_column[syndrome]:
            if c > b:
                record((a, b, c))
        pairs[syndrome].append((a, b))
    seen = set()
    for entries in pairs.values():
        for ab, cd in combinations(entries, 2):
            support = tuple(sorted(ab+cd))
            if len(set(support)) == 4 and support not in seen:
                seen.add(support)
                record(support)
    distance = next((w for w in range(1, 5) if counts[str(w)]['logical']), None)
    return {'kernel_supports': counts, 'distance_if_at_most_four': distance,
            'logical_witness': witnesses.get(str(distance)),
            'logical_witnesses_by_weight': witnesses}


def sample_parameters(rng, family, ell, v=4):
    if family == '3.10':
        return {'x': [0]+[rng.randrange(1 << ell) for _ in range(3)],
                'y': [rng.randrange(1 << ell) for _ in range(4)],
                'tau': rng.choice(four_cycles())}
    return {'x': [rng.randrange(1 << ell) for _ in range(v)]}


def arrays(family, parameters):
    return source310(**parameters) if family == '3.10' else source311(**parameters)
