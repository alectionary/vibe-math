"""Independent finite checks for P11 forbidden labels in single-permutation blocks.
Labels are integers encoding F_2^ell and compose by XOR. None means an absent block.
"""
from itertools import product
from collections import deque
from pathlib import Path
import json
import random


def graph(B, ell):
    m, n, N = len(B), len(B[0]), 1 << ell
    adj = {('c', i, a): set() for i in range(m) for a in range(N)}
    adj.update({('v', j, a): set() for j in range(n) for a in range(N)})
    for i, row in enumerate(B):
        for j, s in enumerate(row):
            if s is not None:
                for a in range(N):
                    u, v = ('c', i, a), ('v', j, a ^ s)
                    adj[u].add(v); adj[v].add(u)
    return adj


def girth(adj):
    best = None
    for root in adj:
        dist, parent, todo = {root: 0}, {root: None}, deque([root])
        while todo:
            u = todo.popleft()
            for v in adj[u]:
                if v not in dist:
                    dist[v] = dist[u] + 1; parent[v] = u; todo.append(v)
                elif parent[u] != v:
                    length = dist[u] + dist[v] + 1
                    best = length if best is None else min(best, length)
    return best


def patterns(B, half):
    """All supported projected cyclically nonbacktracking words, rooted at a check."""
    m, n = len(B), len(B[0])
    for rows in product(range(m), repeat=half):
        if any(rows[t] == rows[(t+1) % half] for t in range(half)):
            continue
        for cols in product(range(n), repeat=half):
            if any(cols[t] == cols[(t+1) % half] for t in range(half)):
                continue
            cells = tuple(cell for t in range(half)
                          for cell in ((rows[t], cols[t]), (rows[(t+1) % half], cols[t])))
            if all(B[i][j] is not None for i, j in cells):
                yield rows, cols, cells


def trace(B, rows, cols):
    a = 0
    vertices = [('c', rows[0], 0)]
    for t, j in enumerate(cols):
        a ^= B[rows[t]][j]
        vertices.append(('v', j, a))
        a ^= B[rows[(t+1) % len(rows)]][j]
        vertices.append(('c', rows[(t+1) % len(rows)], a))
    return vertices


def word_cycles(B, length):
    out = []
    for rows, cols, cells in patterns(B, length // 2):
        vertices = trace(B, rows, cols)
        if vertices[-1] == vertices[0] and len(set(vertices[:-1])) == length:
            out.append((rows, cols, cells, vertices))
    return out


def exact_cycles_dfs(adj, length):
    """Canonical unoriented cycles, independently traversing the expanded graph."""
    found = set()
    def visit(path):
        u = path[-1]
        if len(path) == length:
            if path[0] in adj[u]:
                seq = tuple(path)
                rots = [s[k:] + s[:k] for s in (seq, tuple(reversed(seq))) for k in range(length)]
                found.add(min(rots))
            return
        for v in adj[u]:
            if v >= path[0] and v not in path:
                visit(path + [v])
    for root in sorted(adj):
        visit([root])
    return found


def replace(B, slot, a):
    out = [list(r) for r in B]
    out[slot[0]][slot[1]] = a
    return out


def forbidden(B, slot, ell, bound):
    actual, symbolic = set(), set()
    for a in range(1 << ell):
        filled = replace(B, slot, a)
        g = girth(graph(filled, ell))
        if g is not None and g <= bound:
            actual.add(a)
        if any(word_cycles(filled, k) for k in range(4, bound+1, 2)):
            symbolic.add(a)
    return actual, symbolic


def odd_occurrence_rule(B, slot, ell, bound):
    """Deliberately incomplete interpretation: solve only odd-coefficient equations.
This is a diagnostic alternative, NOT claimed to be the authors' implementation.
"""
    template = replace(B, slot, 0)
    out = set()
    for length in range(4, bound+1, 2):
        for _, _, cells in patterns(template, length // 2):
            if cells.count(slot) % 2:
                value = 0
                for i, j in cells:
                    if (i, j) != slot:
                        value ^= template[i][j]
                out.add(value)
    return out


# The 21 ordered-row representatives immediately preceding P11 Theorem A.6.
SOURCE_ROWS = [
    (0,1,0,1),(0,1,0,2),(0,1,0,3),(0,2,0,2),(0,2,0,3),(0,3,0,3),
    (0,2,1,2),(0,2,1,3),(0,3,1,3),(0,1,2,1),(0,1,2,3),(0,1,3,1),
    (0,1,3,2),(0,2,3,2),(0,3,2,3),(1,2,1,2),(1,2,1,3),(1,3,1,3),
    (1,3,2,3),(1,2,3,2),(2,3,2,3),
]

def canonical_rows(rows):
    rows = tuple(rows)
    return min(w[k:] + w[:k] for w in (rows, tuple(reversed(rows))) for k in range(4))

def source_pattern_audit():
    proper = [w for w in product(range(4), repeat=4) if all(w[i] != w[(i+1)%4] for i in range(4))]
    assert len(proper) == 84
    assert len({canonical_rows(w) for w in SOURCE_ROWS}) == 21
    assert {canonical_rows(w) for w in proper} == {canonical_rows(w) for w in SOURCE_ROWS}
    three = [i+1 for i,w in enumerate(SOURCE_ROWS) if max(w) < 3]
    two = [i+1 for i,w in enumerate(SOURCE_ROWS) if max(w) < 2]
    assert three == [1,2,4,7,10,16] and two == [1]
    return {'proper_four_step_row_words':84,'dihedral_classes':21,
            'three_row_pattern_ids':three,'two_row_pattern_ids':two,
            'scope':'Row-pattern completeness, not multiplicity or forbidden-routine equivalence.'}

def run():
    rng = random.Random(20261023)
    cases = []
    # Exhaust all partial labeled 2x2 arrays with a designated unassigned slot.
    # 1-, 2-, and 3-bit fibers; every other cell is absent or has any label.
    for ell in [0, 1, 2, 3]:
        choices = [None, *range(1 << ell)]
        for vals in product(choices, repeat=3):
            cases.append(([[vals[0], vals[1]], [vals[2], None]], (1, 1), ell, 'exhaustive_2x2'))
    # Every normalized 3x3, 2-bit array with arbitrary three assigned interior labels.
    for vals in product(range(4), repeat=3):
        cases.append(([[0,0,0],[0,vals[0],vals[1]],[0,vals[2],None]], (2,2), 2, 'exhaustive_normalized_3x3'))
    # Reproducible sparse/dense 3x3 and 4x4 partial arrays.
    for _ in range(90):
        m, n, ell = rng.choice([3,4]), rng.choice([3,4]), rng.choice([1,2,3])
        B = [[None if rng.random() < .35 else rng.randrange(1 << ell) for _ in range(n)] for _ in range(m)]
        slot = (rng.randrange(m), rng.randrange(n)); B[slot[0]][slot[1]] = None
        cases.append((B, slot, ell, 'sampled_3x3_4x4'))
    counts = {}
    assignments = 0
    for B, slot, ell, kind in cases:
        counts[kind] = counts.get(kind, 0) + 1
        for bound in [4,6,8]:
            actual, symbolic = forbidden(B, slot, ell, bound)
            assert actual == symbolic, (B,slot,ell,bound,actual,symbolic)
            assignments += 1 << ell
    # Independent exact-length DFS check and translation-orbit cycle counts.
    exact_checks = []
    for B, ell in [([[0,0],[0,0]],1), ([[0,0],[0,1]],1),
                   ([[0,0,0],[0,1,2],[0,2,1]],2), ([[0,0,0],[0,1,2],[0,2,3]],2)]:
        row = {'B':B,'ell':ell,'cycle_counts':{}}
        for length in [4,6,8]:
            dfs = len(exact_cycles_dfs(graph(B,ell),length))
            rooted = len(word_cycles(B,length))
            assert dfs * length == rooted * (1 << ell), (B,length,dfs,rooted)
            row['cycle_counts'][str(length)] = dfs
        exact_checks.append(row)
    B = [[0,0],[0,None]]; slot=(1,1)
    actual, symbolic = forbidden(B,slot,1,8)
    assert actual == symbolic == {0,1}
    assert odd_occurrence_rule(B,slot,1,8) == {0}
    repeated = next(trace([[0,0],[0,0]],r,c) for r,c,_ in patterns([[0,0],[0,0]],4))
    assert repeated[0] == repeated[-1] and len(set(repeated[:-1])) < 8
    result = {'source_row_pattern_audit':source_pattern_audit(), 'seed':20261023, 'partial_arrays':len(cases), 'families':counts,
              'candidate_label_bound_checks':assignments, 'bounds':[4,6,8],
              'complete_prefix_checker_mismatches':0, 'independent_exact_cycle_checks':exact_checks,
              'odd_coefficient_counterexample':{'B':B,'slot':slot,'ell':1,'bound':8,
                  'actual_forbidden':sorted(actual),'odd_only_forbidden':[0],
                  'missed_label':1,'missed_label_girth':girth(graph(replace(B,slot,1),1)),
                  'scope':'Counterexample to odd-occurrence-only interpretation; not a refutation of a supplied author implementation.'},
              'closure_not_simplicity':{'B':[[0,0],[0,0]],'ell':1,'closed_trace':repeated,
                  'exact_eight_cycles':0,'actual_girth':4},
              'scope':'Single permutation per occupied block; missing blocks allowed; no claim covers multi-edge protographs or all absorbing/decoder pathologies.'}
    target = Path(__file__).with_name('results.json');target.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ['partial_arrays','families','candidate_label_bound_checks','complete_prefix_checker_mismatches']},indent=2))

if __name__ == '__main__':
    run()
