#!/usr/bin/env python3
"""Replay the review's cheap graph/coverage diagnostics; never run a solver."""
from pathlib import Path
import collections
import hashlib
import itertools
import json

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
data = json.loads((HERE / 'diagnostic.json').read_text())
pools = HERE.parent / 'pools'
values = []
for name in ['xcoords.txt', 'zcoords.txt']:
    p = pools / name
    assert hashlib.sha256(p.read_bytes()).hexdigest() == data['pool_sha256'][name]
    values.append([int(s, 16) for s in p.read_text().split()])
x, z = values
degrees = [sum((a & b).bit_count() % 2 for b in z) for a in x]
assert sum(degrees) == data['edges'] == 99808
assert {str(k): v for k, v in collections.Counter(degrees).items()} == data['X_degree_histogram']
assert len(x) == data['X'] == len(z) == data['Z'] == 720
excluded = {(0, 1, 2), (0, 1, 4), (1, 2, 4)}
supports = [list(s) for k in [3, 4, 5] for s in itertools.combinations(range(5), k)
            if s not in excluded]
assert supports == data['admissible_exact_supports'] and len(supports) == 13
assert len(supports) ** 2 == data['ordered_support_pairs'] == 169
assert len(supports) * (len(supports) + 1) // 2 == data['exchange_representatives'] == 91
assert data['endpoint_unordered_triples'] == 1440 * 1439 * 1438 // 6
assert data['cyclic_triple_orbits'] == data['endpoint_unordered_triples'] // 16
assert data['conflict_graph_dense_bit_bytes'] == data['edges'] ** 2 // 8
sources = json.loads((HERE / 'sources.json').read_text())
rows = json.loads((ROOT / 'literature/open-problems.json').read_text())
for source in sources['papers']:
    expected = {r['id'] for r in rows if any(
        o['source_id'] == source['paper_id'] for o in r['occurrences'])}
    assert set(source['target_ids']) == expected
    assert source['question_count'] == len(expected)
    assert len(source['source_sha256']) == len(source['text_sha256']) == 64
    # Source files are locally cached and not distributed with this review.
    # Missing a cache is not a successful source-hash replay.
    for field, digest in [('source_local_file', 'source_sha256'),
                          ('text_local_file', 'text_sha256')]:
        p = ROOT / source[field]
        if p.exists():
            assert hashlib.sha256(p.read_bytes()).hexdigest() == source[digest]
        else:
            print('Source cache unavailable:', source['paper_id'], field)
assert sources['deltas']['new_C16_answers'] == 0
assert sources['deltas']['new_Lean_completed_targets'] == 0
print('PASS: exact pool graph, support-cover counts and source-question links; no new C16 resolution.')
