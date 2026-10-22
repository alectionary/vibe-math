"""Exact finite checks of two statements found during the literature expansion.

These checks are Python computations, not Lean proofs. The rook construction
refutes the triangle bound under the two forbidden-subgraph constraints written
in arXiv:2610.16266v1, Conjecture 5; it is not a Conway strongly regular graph.
"""
from itertools import combinations
import json


def rook_chain():
    adj = [set() for _ in range(99)]
    for block in range(11):
        for a, b in combinations(range(9), 2):
            if a // 3 == b // 3 or a % 3 == b % 3:
                u, v = 9 * block + a, 9 * block + b
                adj[u].add(v)
                adj[v].add(u)
    for block in range(10):
        u, v = 9 * block, 9 * (block + 1)
        adj[u].add(v)
        adj[v].add(u)
    return adj


def check():
    adj = rook_chain()
    seen, pending = {0}, [0]
    while pending:
        for v in adj[pending.pop()] - seen:
            seen.add(v)
            pending.append(v)
    triangles = sum(c in adj[a] and c in adj[b]
                    for a, b, c in combinations(range(99), 3) if b in adj[a])
    adjacent_common = max(len(adj[a] & adj[b]) for a, b in combinations(range(99), 2)
                          if b in adj[a])
    all_common = max(len(adj[a] & adj[b]) for a, b in combinations(range(99), 2))
    assert len(seen) == 99 and triangles == 66
    # A non-induced diamond has an adjacent pair with >=2 common neighbors.
    # A non-induced K_{2,3} has a pair with >=3 common neighbors.
    assert adjacent_common == 1 and all_common == 2
    assert set(map(len, adj)) != {14}
    # Under the source definition rho=0 if the initial graph never returns.
    # K_2 maps to the edgeless two-vertex graph and never returns, so
    # rho^2(K_2)=0, contradicting the literal 0 <= |V|-3 = -1.
    return dict(checked_on='2026-10-22',method='exact_finite_python_enumeration',
                lean_verified=False,
                rook_chain=dict(vertices=99,edges=sum(map(len,adj))//2,connected=True,
                                triangles=triangles,max_common_adjacent=adjacent_common,
                                max_common_any_pair=all_common,diamond_free=True,
                                K23_free=True,regular_degree_14=False,
                                refutes='P32 Conjecture 5 as written, not the existence of an SRG(99,14,1,2)'),
                periodicity=dict(graph='K2',periodicity=0,claimed_upper_bound=-1,
                                 finding='P29 Conjecture 1 needs an order restriction at minimum'))


if __name__ == '__main__':
    print(json.dumps(check(),indent=2))
