#!/usr/bin/env python3
"""Coherent selected degree-three moments on the literal C16 source pools.

Selected principal localizing matrices are a necessary relaxation only. Cyclic
averaging constrains moments, never the frame. All overlapping triple moments
share a variable after canonicalizing the actual simultaneous cyclic action.
"""
from pathlib import Path
from itertools import combinations, product
from collections import defaultdict
import argparse
import gzip
import hashlib
import json
import math
import time

import numpy as np
from scipy.sparse import coo_matrix

ROOT = Path(__file__).resolve().parent
P = 16
N = 90
BASE = N + 9 * N * N


def read(p):
    return json.loads(gzip.decompress(p.read_bytes()) if p.suffix == '.gz' else p.read_text())


def pair_index(a, b):
    i, hi = divmod(a, P)
    j, hj = divmod(b, P)
    h = (hj - hi) % P
    if a == b:
        return i
    if h > 8:
        i, j, h = j, i, P - h
    return N + h * N * N + i + N * j


def canonical(events):
    events = sorted(set(events))
    if len(events) < 3:
        return tuple(events)
    least = events[0] // P
    shifts = [v % P for v in events if v // P == least]
    return min(tuple(sorted((v // P) * P + (v % P - h) % P for v in events)) for h in shifts)


def source_data():
    from pool_inverse_structure import rank_one, rotate_s
    from rectangular_moment_sdp import source_patterns
    source = read(ROOT / 'inversion-results/normal-form.json')
    q = source['dictionary']
    pack = lambda v: tuple(tuple(w) for w in v)
    originals = []
    mapping = []
    for side in ['X', 'Z']:
        coords = source['tensor'][side + '_tensor_coordinates']
        lookup = {pack(v): i for i, v in enumerate(coords)}
        ids = []
        for c in range(5):
            for a in range(9):
                for h in range(P):
                    v = rank_one([rotate_s(w, h) for w in q['X_left_dictionary'][a]], q['X_right_factors'][c]) if side == 'X' else rank_one(q['Z_left_factors'][c], [rotate_s(w, h) for w in q['Z_right_dictionary'][a]])
                    ids.append(lookup[pack(v)])
        assert len(set(ids)) == 720
        old = [int(s, 16) for s in (ROOT / 'pools' / (side.lower() + 'coords.txt')).read_text().split()]
        originals.extend(old[i] for i in ids)
        mapping.append(ids)
    patterns = source_patterns(source, list(range(5)))
    graph = np.zeros((1440, 1440), dtype=np.int8)
    for i in range(720):
        for j in range(720):
            value = (originals[i] & originals[720 + j]).bit_count() % 2
            a, h = divmod(i, P)
            b, k = divmod(j, P)
            assert value == (patterns[a][b] >> ((k - h) % P) & 1)
            graph[i, 720 + j] = graph[720 + j, i] = value
    return source, patterns, originals, mapping, graph


class Lift:
    def __init__(self, values, graph, anchors, rows, degree=True):
        self.values = values
        self.graph = graph
        self.anchors = anchors
        self.rows = rows
        self.keys = set()
        self.zero = set()
        self.degree_rows = []
        self.matrices = []
        for a in anchors:
            matrix = []
            for i in [None] + rows:
                for j in [None] + rows:
                    matrix.append(self.ref([v for v in [a, i, j] if v is not None]))
            self.matrices.append(matrix)
            if degree:
                for v in rows:
                    terms = [self.ref([a, v, int(w)]) for w in np.flatnonzero(graph[v])]
                    self.degree_rows.append((terms, pair_index(a, v)))
        self.keys = sorted(self.keys)
        self.ids = {key: BASE + i for i, key in enumerate(self.keys)}
        self.all_keys = sorted(set(self.keys) | self.zero)

    def ref(self, events):
        key = canonical(events)
        if len(key) == 1:
            return key[0] // P
        if len(key) == 2:
            return pair_index(*key)
        assert len(key) == 3
        # A selected induced subgraph is1-regular. Any two edges in a
        # three-vertex induced subgraph therefore forbid joint selection.
        forbidden = sum(int(self.graph[a, b]) for a, b in combinations(key, 2)) >= 2
        same = all((v < 720) == (key[0] < 720) for v in key)
        forbidden |= same and not (self.values[key[0]] ^ self.values[key[1]] ^ self.values[key[2]])
        if forbidden:
            self.zero.add(key)
            return None
        self.keys.add(key)
        return key

    def resolve(self, ref):
        return self.ids[ref] if isinstance(ref, tuple) else ref

    def selector(self, refs, width):
        ri, ci = [], []
        for i, ref in enumerate(refs):
            j = self.resolve(ref)
            if j is not None:
                ri.append(i)
                ci.append(j)
        return coo_matrix((np.ones(len(ri)), (ri, ci)), shape=(len(refs), width)).tocsr()

    def linear_rows(self):
        eq, iq = [], []
        for terms, rhs in self.degree_rows:
            d = defaultdict(int)
            d[rhs] -= 1
            for ref in terms:
                j = self.resolve(ref)
                if j is not None:
                    d[j] += 1
            eq.append((dict(d), 0))
        for key in self.all_keys:
            a, b, c = key
            ia, ib, ic = [v // P for v in key]
            ab, ac, bc = pair_index(a, b), pair_index(a, c), pair_index(b, c)
            t = self.ids.get(key)
            # The eight probabilities of three Boolean variables are >=0.
            # Keeping forbidden triples at0 still imposes their other cells.
            rows = [([(t, -1)], 0), ([(t, 1), (ab, -1)], 0),
                    ([(t, 1), (ac, -1)], 0), ([(t, 1), (bc, -1)], 0),
                    ([(ab, 1), (ac, 1), (ia, -1), (t, -1)], 0),
                    ([(ab, 1), (bc, 1), (ib, -1), (t, -1)], 0),
                    ([(ac, 1), (bc, 1), (ic, -1), (t, -1)], 0),
                    ([(t, 1), (ia, 1), (ib, 1), (ic, 1),
                      (ab, -1), (ac, -1), (bc, -1)], 1)]
            for terms, rhs in rows:
                d = defaultdict(int)
                for j, v in terms:
                    if j is not None:
                        d[j] += v
                iq.append((dict(d), rhs))
        return eq, iq


def sparse_rows(rows, width):
    ri, ci, val, rhs = [], [], [], []
    for r, (terms, b) in enumerate(rows):
        rhs.append(b)
        for j, a in terms.items():
            if a:
                ri.append(r); ci.append(j); val.append(a)
    return coo_matrix((val, (ri, ci)), shape=(len(rows), width)).tocsr(), np.array(rhs)


def add_frozen_base(prob, p, C, patterns, target, mapping):
    import cvxpy as cp
    from scipy.sparse import csc_matrix
    from moment_triangle_cuts import expression as triangle
    from moment_integer_form_cuts import expression as form
    from moment_owner_cuts import model_constraint as owners
    folder = ROOT / 'inverse-four-hour-results'
    con = list(prob.constraints)
    conditional = {(r['sector'], r['thin_mask'], r['thick_mask']) for r in read(folder / 'lattice-source-rankcuts.json.gz')}
    rectangles = []
    for side in ['X', 'Z']:
        for r in read(folder / ('rank-rectangle-' + side + '.json')):
            cols = [(0 if side == 'X' else 45) + 9 * c + a for c in range(5) if r['thin_mask'] >> c & 1 for a in range(9) if r['thick_mask'] >> a & 1]
            rectangles.append({**r, 'sector': side, 'columns': cols, 'conditional': (side, r['thin_mask'], r['thick_mask']) in conditional})
    K = csc_matrix((np.ones(sum(len(c['columns']) for c in rectangles)), ([j for c in rectangles for j in c['columns']], [k for k, c in enumerate(rectangles) for j in c['columns']])), shape=(N, len(rectangles)))
    rank = np.array([c['rank'] for c in rectangles])
    con.append(P * K.T @ p <= rank)
    chosen = [i for i, r in enumerate(rectangles) if r['conditional']]
    con.append(sum(C.values()) @ K[:, chosen] <= cp.reshape(p, (N, 1), order='C') @ rank[chosen].reshape(1, -1))
    triangles = read(folder / 'lattice-source-triangles.json.gz')
    forms = read(folder / 'lattice-source-integer-forms.json.gz')
    con.extend(triangle(r, p, C, P) for r in triangles)
    con.extend(form(r, p, C, P) for r in forms)
    owner_cuts = read(folder / 'all-owner-cuts.json.gz')
    con.append(owners(owner_cuts, patterns, p, C, P))
    # Previously frozen conditional short-circuit rank inequalities.
    circuits = []
    for r in read(folder / 'lattice-source-circuits.json.gz'):
        d = defaultdict(int)
        d[r['anchor']] -= len(r['circuit']) - 1
        for v in r['circuit']:
            event = (0 if r['sector'] == 'X' else 720) + (v // P) * P + (v % P + r['phase']) % P
            d[pair_index(r['anchor'] * P, event)] += 1
        circuits.append((dict(d), 0))
    A, b = sparse_rows(circuits, BASE)
    vec = cp.hstack([p] + [cp.vec(C[h], order='F') for h in range(9)])
    con.append(A @ vec <= b)
    cap_types = []
    if target == 128:
        for side in range(2):
            ids = [i for i, old in enumerate(mapping[side]) if old // P == 12]
            assert len(ids) == 16 and len({v // P for v in ids}) == 1
            a = side * 45 + ids[0] // P
            con.append(P * p[a] <= 11)
            cap_types.append(a)
    return con, {'rank_rectangles': len(rectangles), 'conditional_rank_rectangles': len(chosen), 'triangles': len(triangles), 'integer_forms': len(forms), 'owner_cuts': len(owner_cuts), 'conditional_circuit_cuts': len(circuits), 'critical_monomial_cap_types': cap_types}


def orbit_moments(masks):
    from cyclic_moment_sdp import moments_from_masks
    p, C = moments_from_masks(masks, P)
    return np.hstack([p] + [C[h].reshape(-1, order='F') for h in range(9)])


def triple_value(key, masks):
    return sum(all(masks[v // P] >> ((v % P + h) % P) & 1 for v in key) for h in range(P)) / P


def literal_controls(lift, eq, iq, mapping):
    # Physical88-frame controls every compiled new row and both conditional
    # PSD blocks, including cyclic averaging and overlapping triple sharing.
    frame = read(ROOT / 'partial-frame-88.json')
    pairs = frame.get('pool_pairs')
    if pairs is None:
        from audit_pools import exchange
        from verify_partial_frame import mask, shift
        source = read(ROOT / 'physical-pool-source.json')
        Z = [shift(mask(r), h) for r in source['Z_orbit_representatives'] for h in range(P)]
        X = [exchange(z) for z in Z]
        xi, zi = {v:i for i,v in enumerate(X)}, {v:i for i,v in enumerate(Z)}
        pairs = [(xi[mask(r['X'])], zi[mask(r['Z'])]) for r in frame['pairs']]
    inverse = [{v: i for i, v in enumerate(ids)} for ids in mapping]
    masks = [0] * N
    for a, b in pairs:
        for side, v in enumerate([a, b]):
            event = inverse[side][v]
            masks[side * 45 + event // P] |= 1 << (event % P)
    assert sum(m.bit_count() for m in masks) == 176
    x0 = orbit_moments(masks)
    x = np.r_[x0, [triple_value(k, masks) for k in lift.keys]]
    A, b = sparse_rows(eq, len(x))
    B, c = sparse_rows(iq, len(x))
    er = float(np.max(abs(A @ x - b))) if len(b) else 0.
    iv = float(max(0, np.max(B @ x - c))) if len(c) else 0.
    assert er == iv == 0
    q = len(lift.rows) + 1
    base_refs = [pair_index(i, j) if i is not None and j is not None else (j if i is None else i) // P if (i is not None or j is not None) else None for i in [None] + lift.rows for j in [None] + lift.rows]
    M0 = np.array([1. if j is None else x[j] for j in base_refs]).reshape(q, q)
    mins = []
    for refs in lift.matrices:
        M = (lift.selector(refs, len(x)) @ x).reshape(q, q)
        mins += [float(np.linalg.eigvalsh(M)[0]), float(np.linalg.eigvalsh(M0 - M)[0])]
    assert min(mins) > -1e-12
    # Literal third-moment cell checks on all assignments to three selectors.
    for a, b, c in product([0, 1], repeat=3):
        t = a * b * c
        assert min(t, a*b-t, a*c-t, b*c-t, a-a*b-a*c+t, b-a*b-b*c+t, c-a*c-b*c+t, 1-a-b-c+a*b+a*c+b*c-t) >= 0
    return {'status': 'PASS', 'physical88_pairs': len(pairs), 'new_degree_equalities': len(eq), 'new_Boolean_cell_inequalities': len(iq), 'exact_linear_residual': er, 'PSD_numerical_minimum': min(mins), 'PSD_interpretation': 'Matrices are exact orbit averages of nonnegative weighted outer products; eigenvalues are an additional numerical check.'}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--mode', choices=['control', 'base', 'linear', 'psd'], default='control')
    ap.add_argument('--seconds', type=float, default=120)
    ap.add_argument('--target', type=int, default=128)
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--direct', action='store_true')
    a = ap.parse_args()
    start = time.monotonic()
    source, patterns, values, mapping, graph = source_data()
    # Frozen before the first solve: two cyclic anchor orbits and97-row blocks.
    anchors = [39 * P, 84 * P]
    rows = sorted(set([i * P for i in range(N)] + [39*P+h for h in [1, 2, 4, 8]] + [84*P+h for h in [1, 2]]))
    lift = Lift(values, graph, anchors, rows)
    eq, iq = lift.linear_rows()
    protocol = {'anchors': anchors, 'rows': rows, 'matrix_order': len(rows)+1, 'triple_variables': len(lift.keys), 'forbidden_triples': len(lift.zero), 'degree_equations': len(eq), 'Boolean_cell_inequalities': len(iq), 'omitted_strength': 'Only selected principal blocks and selected degree localizers; no full cubic cardinality localizers or full hierarchy claimed.'}
    a.output.parent.mkdir(parents=True, exist_ok=True)
    controls = literal_controls(lift, eq, iq, mapping)
    result = {'status': 'CONTROLS_PASS', 'source_C16_answered': False, 'exact_exclusion_certificate': False, 'mode': a.mode, 'protocol': protocol, 'controls': controls, 'source_pool_pairs': int(graph.sum() // 2)}
    a.output.write_text(json.dumps(result, indent=2)+'\n')
    print('CONTROLS_PASS', json.dumps({k: protocol[k] for k in ['matrix_order', 'triple_variables', 'degree_equations']}), flush=True)
    if a.mode == 'control':
        return
    import cvxpy as cp
    from rectangular_moment_sdp import model
    prob, p, C = model(patterns, P, a.target)
    con, old = add_frozen_base(prob, p, C, patterns, a.target, mapping)
    v0 = cp.hstack([p] + [cp.vec(C[h], order='F') for h in range(9)])
    if a.mode != 'base':
        t = cp.Variable(len(lift.keys), name='third')
        v = cp.hstack([v0, t])
        A, b = sparse_rows(eq, BASE+len(lift.keys))
        B, c = sparse_rows(iq, BASE+len(lift.keys))
        con.extend([A @ v == b, B @ v <= c])
        if a.mode == 'psd':
            q = len(rows)+1
            refs = [pair_index(i, j) if i is not None and j is not None else (j if i is None else i) // P if (i is not None or j is not None) else None for i in [None]+rows for j in [None]+rows]
            mat = lift.selector(refs, BASE+len(lift.keys))
            constant = np.array([float(i is None and j is None) for i in [None]+rows for j in [None]+rows]).reshape(q, q)
            M0 = cp.reshape(mat @ v, (q, q), order='C') + constant
            for refs in lift.matrices:
                M = cp.reshape(lift.selector(refs, BASE+len(lift.keys)) @ v, (q, q), order='C')
                con.extend([M >> 0, M0-M >> 0])
    prob = cp.Problem(cp.Minimize(0), con)
    result.update(status='MODEL_BUILT', base_cuts=old, build_seconds=time.monotonic()-start)
    a.output.write_text(json.dumps(result, indent=2)+'\n')
    print('MODEL_BUILT', result['build_seconds'], flush=True)
    solve_start = time.monotonic()
    prob.solve(solver='SCS', use_indirect=not a.direct, eps=1e-7, max_iters=50000, time_limit_secs=a.seconds, verbose=True)
    violations = []
    if p.value is not None:
        for c in con:
            try:
                violations.append(float(np.max(c.violation())))
            except Exception:
                pass
        np.savez_compressed(a.output.with_suffix('.moments.npz'), first=p.value, **{f'C{h}':C[h].value for h in range(9)}, **({'third':t.value} if a.mode != 'base' else {}))
    extra = prob.solver_stats.extra_stats
    if isinstance(extra, dict):
        np.savez_compressed(a.output.with_suffix('.scs.npz'), **{k:v for k,v in extra.items() if k in ['x','y','s']})
    result.update(status=prob.status, solve_seconds=time.monotonic()-solve_start, total_seconds=time.monotonic()-start, maximum_constraint_violation=max(violations) if violations else None, scs_info=extra.get('info') if isinstance(extra, dict) else None, evidence='Numerical producer only. Neither solver status nor residuals are an exact exclusion or exact feasible certificate.')
    a.output.write_text(json.dumps(result, indent=2)+'\n')
    print('RESULT', json.dumps(result), flush=True)


if __name__ == '__main__':
    main()
