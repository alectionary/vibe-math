"""Decoding-related graph checks, independent of any decoder simulation.

Run from any directory. Standard library only. Finite Python evidence is
distinct from the companion kernel-checked CyclicDecoding.lean certificates.
"""
from collections import Counter, deque
from itertools import combinations, permutations
from pathlib import Path
import hashlib
import json
from scan import voltage_graph, matrix_graph, girth


def components(adj):
    unseen = set(adj)
    sizes = []
    while unseen:
        q = deque([unseen.pop()])
        size = 0
        while q:
            u = q.popleft()
            size += 1
            for v in adj[u]:
                if v in unseen:
                    unseen.remove(v)
                    q.append(v)
        sizes.append(size)
    return sorted(sizes)


def exclusions(B, r):
    m, n = len(B), len(B[0])
    rect = all((B[a][c]-B[a][d]+B[b][d]-B[b][c]) % r
               for a, b in combinations(range(m), 2)
               for c, d in combinations(range(n), 2))
    hexa = all((B[a][d]-B[a][e]+B[b][e]-B[b][f]+B[c][f]-B[c][d]) % r
               for a, b, c in permutations(range(m), 3)
               for d, e, f in permutations(range(n), 3))
    return bool(rect and hexa)


def cycles8_projection(adj):
    checks = sorted(u for u in adj if u[0] == 'c')
    projection = {c: {} for c in checks}
    for v in adj:
        if v[0] == 'c':
            continue
        for a, b in combinations(sorted(adj[v]), 2):
            assert b not in projection[a], 'four-cycle invalidates unique labels'
            projection[a][b] = projection[b][a] = v
    counts = Counter()
    for a, c in combinations(checks, 2):
        for b, d in combinations(sorted(projection[a].keys() & projection[c].keys()), 2):
            labels = [projection[a][b], projection[b][c], projection[c][d], projection[d][a]]
            if len(set(labels)) == 4:
                counts[sum(v[0] == 'l' for v in labels)] += 1
    assert all(n % 2 == 0 for n in counts.values())
    return {str(k): n // 2 for k, n in sorted(counts.items())}


def cycles8_dfs(adj):
    """Independent traversal of the Tanner graph, no projected graph formula."""
    counts = Counter()
    for root in sorted(u for u in adj if u[0] == 'c'):
        path = [root]
        seen = {root}

        def visit(u):
            if len(path) == 8:
                if root in adj[u]:
                    counts[sum(v[0] == 'l' for v in path)] += 1
                return
            for v in adj[u]:
                if v > root and v not in seen:
                    seen.add(v)
                    path.append(v)
                    visit(v)
                    path.pop()
                    seen.remove(v)
        visit(root)
    assert all(n % 2 == 0 for n in counts.values())
    return {str(k): n // 2 for k, n in sorted(counts.items())}


def profile(adj, S):
    degrees = {c: len(adj[c] & S) for c in adj if c[0] == 'c'}
    counts = Counter(d for d in degrees.values() if d)
    per_variable = sorted((sum(degrees[c] % 2 == 0 for c in adj[v]),
                           sum(degrees[c] % 2 == 1 for c in adj[v])) for v in S)
    return {'variables': len(S), 'positive_check_degree_counts': dict(sorted(counts.items())),
            'syndrome_weight': sum(d % 2 for d in degrees.values()),
            'even_odd_neighbors_per_variable': per_variable,
            'absorbing': all(e > o for e, o in per_variable),
            'stopping': 1 not in counts}


def cut_profile(adj, r):
    S = {u for u in adj if u[-1] < r // 2}
    boundary = sum(v not in S for u in S for v in adj[u])
    volume = sum(len(adj[u]) for u in S)
    complement_volume = sum(map(len, adj.values())) - volume
    return {'cut': 'all vertex types with fiber < floor(r/2)',
            'boundary_edges': boundary, 'volume': volume,
            'complement_volume': complement_volume,
            'conductance_upper_bound': boundary / min(volume, complement_volume)}


def run():
    records = []
    B0 = [[0, 0, 0], [0, 1, 2], [0, 3, 6]]
    cases = [('baseline7', 7, B0), ('baseline14', 14, B0),
             ('variant7-at14', 14, [[0, 0, 0], [0, 1, 2], [0, 3, 7]]),
             ('variant8-at14', 14, [[0, 0, 0], [0, 1, 2], [0, 3, 8]]),
             ('scaled14', 14, [[2*x for x in row] for row in B0])]
    for label, r, B in cases:
        adj = voltage_graph(B, r)
        assert adj == matrix_graph(B, r)
        assert exclusions(B, r)
        g = girth(adj)
        assert g == 8
        projected = cycles8_projection(adj)
        assert projected == cycles8_dfs(adj)
        records.append({'label': label, 'r': r, 'B': B, 'girth': g,
                        'components': components(adj),
                        'eight_cycles_by_left_variable_count': projected,
                        'eight_cycles_total': sum(projected.values())})
    witness = voltage_graph(B0, 7)
    S4 = {('l', 0, 0, 0), ('l', 0, 1, 0), ('r', 0, 0, 0), ('r', 1, 0, 0)}
    S6 = {('l', 0, j, 0) for j in range(3)} | {('r', i, 0, 0) for i in range(3)}
    p4, p6 = profile(witness, S4), profile(witness, S6)
    assert p4['absorbing'] and p4['syndrome_weight'] == 4 and not p4['stopping']
    assert p6['absorbing'] and p6['syndrome_weight'] == 0 and p6['stopping']
    cuts = []
    for r in [14, 28, 56]:
        adj = voltage_graph(B0, r)
        assert exclusions(B0, r) and components(adj) == [27*r]
        cut = cut_profile(adj, r)
        assert cut['boundary_edges'] == 144 and cut['volume'] == 108*(r//2)
        cuts.append({'r': r, **cut})
    return {'evidence': 'Exact finite Python computations; no decoder simulation or priority claim.',
            'methods': ['independent voltage and binary matrix constructions',
                        'BFS girth', 'projected check graph eight-cycle counting',
                        'independent simple Tanner walk DFS count, quotient by orientation',
                        'BFS connected components', 'direct induced degrees and cut edge counts'],
            'source_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
            'cycle_cases': records, 'four_variable_witness': p4,
            'six_variable_witness': p6, 'connected_family_cuts': cuts}


if __name__ == '__main__':
    result = run()
    Path(__file__).with_name('decoding-results.json').write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps(result, indent=2))
