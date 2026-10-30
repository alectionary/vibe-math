#!/usr/bin/env python3
"""Independent shared higher-moment/local-box finite-model consumer.

Rebuilds physical count statuses, all local facet directions and row witnesses;
checks the exact common higher moments and every induced pattern law. This
does not certify either full-basis or source-frame membership.
"""
from collections import Counter, defaultdict
from fractions import Fraction as Q
from functools import lru_cache
from itertools import combinations
from pathlib import Path
import argparse
import json
import time
from verify_two_sided_full_basis_oracle import ROOT, read, sha, physical_source, point_owner, columns
from verify_two_basis_local_box import SUBSETS, qrank, nullspace, canonical, moment_inverse, g


def monomial(events):
    assert len(events) in (3, 4) and len(set(events)) == len(events)
    assert all(type(e) is int and 0 <= e < 1440 for e in events)
    orbit = []
    for exchange in range(2):
        for phase in range(16):
            translated = []
            for event in events:
                side, index = divmod(event, 720); base, old_phase = divmod(index, 16)
                translated.append(720*(side ^ exchange)+16*base+(old_phase-phase) % 16)
            orbit.append(tuple(sorted(translated)))
    return min(orbit)


def count_status_groups(X, Z, xx, zz):
    assert len(xx) == len(set(xx)) == len(zz) == len(set(zz)) == 2
    states = [[-1]*16 for _ in range(1440)]
    for m in range(16):
        selected = [[j for k, j in enumerate(xx) if m >> k & 1],
                    [j for k, j in enumerate(zz) if m >> (k+2) & 1]]
        for side in range(2):
            U, V = (X, Z) if side == 0 else (Z, X)
            own = xx if side == 0 else zz; forced = set(selected[side]); W = selected[1-side]
            signatures = [tuple(j for j in W if (u & V[j]).bit_count() & 1) for u in U]
            assert all(len(signatures[j]) <= 1 for j in forced), 'infeasible count pattern: forced multibit'
            buckets = [((), 128-len(W))]+[((j,), 1) for j in W]
            for signature, capacity in buckets:
                pool = [j for j, s in enumerate(signatures) if s == signature]
                fixed = forced.intersection(pool); free = [j for j in pool if j not in own]
                remaining = capacity-len(fixed)
                assert 0 <= remaining <= len(free), 'infeasible count pattern'
                for j in fixed:
                    states[720*side+j][m] = 1
                if remaining:
                    for j in free:
                        assert states[720*side+j][m] == -1
                        states[720*side+j][m] = 0
    groups = defaultdict(list)
    for j, state in enumerate(states):
        groups[tuple(state)].append(j)
    return sorted(groups.items())


@lru_cache(None)
def normals(status):
    G = [g(m) for m in range(16) if status[m] == 0]
    r = qrank(G, 5); coords = []
    for j in range(5):
        if qrank([[v[k] for k in coords+[j]] for v in G], len(coords)+1) > len(coords):
            coords.append(j)
    facets = set()
    if r:
        for subset in combinations(G, r-1):
            A = [[v[j] for j in coords] for v in subset]
            if qrank(A, r) != r-1:
                continue
            vector, = nullspace(A, r); lifted = [0]*5
            for j, value in zip(coords, vector):
                lifted[j] = value
            facets.add(canonical(lifted))
    return r, facets, G


def check_candidate(path):
    start = time.monotonic(); bank = read(path)
    assert bank['status'] == 'EXACT_FEASIBLE_SHARED_LOCAL_ROWS_CANDIDATE'
    point = ROOT/bank['point_c16_path']; assert bank['point_sha256'] == sha(point)
    frozen_path = path.with_name(path.name.removesuffix('.json.gz')+'.frozen.json')
    assert bank['frozen_sha256'] == sha(frozen_path)
    frozen = read(frozen_path)
    for key in ('source_hashes', 'quads', 'point_sha256', 'point_c16_path'):
        assert bank[key] == frozen[key]
    assert all(sha(ROOT/p) == h for p, h in bank['source_hashes'].items())
    X, Z, bridge = physical_source(); owner = point_owner(point); L, C = moment_inverse()
    labels = {}; quad_maps = []
    for xx, zz in bank['quads']:
        events = [*xx, *[720+j for j in zz]]; ids = []
        for subset in SUBSETS[11:]:
            label = monomial([event for k, event in enumerate(events) if subset >> k & 1])
            if label not in labels:
                labels[label] = len(labels)
            ids.append(labels[label])
        quad_maps.append(ids)
    assert [list(v) for v in labels] == bank['shared_variable_monomials']
    assert len(labels) == bank['shared_high_variables']
    assert bank['uncoupled_high_variables'] == 5*len(bank['quads'])
    q = list(map(Q, bank['solution']['higher_moments']))
    assert len(q) == len(labels) and all(0 <= value <= 1 for value in q)
    assert len(bank['quad_records']) == len(bank['quads'])
    slacks = []; local_laws = []; source_rows = 0; individual_bounds = 0
    facet_directions = equality_directions = 0; monomial_action_checks = 0
    for quad, ((xx, zz), ids, summary) in enumerate(zip(bank['quads'], quad_maps, bank['quad_records'])):
        assert summary['X_anchors'] == xx and summary['Z_anchors'] == zz and summary['high_variable_indices'] == ids
        assert summary['all16_count_domains'] is True
        wanted = [Q(1) if j is None else owner[j] for j in columns(xx, zz)]
        low = wanted[:11]; tau = [q[j] for j in ids]
        base = [sum(a*b for a, b in zip(row, low)) for row in L]
        lam = [v+sum(a*b for a, b in zip(row, tau)) for v, row in zip(base, C)]
        assert min(lam) >= 0 and sum(lam) == 1
        assert all(sum(lam[m] for m in range(16) if m&s == s) == value for s, value in zip(SUBSETS, low+tau))
        events = [*xx, *[720+j for j in zz]]
        for subset, index in zip(SUBSETS[11:], ids):
            original = [event for k, event in enumerate(events) if subset >> k & 1]
            for exchange in range(2):
                for phase in range(16):
                    transformed = []
                    for e in original:
                        side, j = divmod(e, 720)
                        transformed.append(720*(side ^ exchange)+16*(j//16)+(j % 16+phase) % 16)
                    assert monomial(transformed) == tuple(bank['shared_variable_monomials'][index])
                    monomial_action_checks += 1
        groups = count_status_groups(X, Z, xx, zz)
        assert len(groups) == summary['classes'] and sum(len(js) for status, js in groups) == 1440
        selected_rows = [row for row in bank['rows'] if row['quad'] == quad]
        assert len(selected_rows) == summary['rows'] and [row['local_index'] for row in selected_rows] == list(range(len(selected_rows)))
        seen_lambda = set(); seen_normals = defaultdict(lambda: {'facet':[], 'equality':[]})
        for saved in selected_rows:
            prov = saved['provenance']; kind = prov['kind']
            if kind == 'lambda_nonnegative':
                m = prov['mask']; assert 0 <= m < 16 and m not in seen_lambda; seen_lambda.add(m)
                h = [int(j == m) for j in range(16)]; terms = []
            else:
                assert kind in ('facet', 'equality'); cid = prov['class']; status, indices = groups[cid]
                v = prov['normal']; assert len(v) == 5 and all(type(x) is int for x in v) and any(v)
                r, complete_facets, G = normals(status)
                if kind == 'facet':
                    assert canonical(v) in complete_facets
                else:
                    assert all(sum(a*b for a, b in zip(v, generator)) == 0 for generator in G)
                seen_normals[cid][kind].append(tuple(v))
                values = [sum(Q(v[k])*wanted[11+j if k == 0 else 1451+1440*(k-1)+j] for k in range(5)) for j in indices]
                vector = indices[values.index(max(values))]; assert prov['vector'] == vector
                terms = [[11+vector if k == 0 else 1451+1440*(k-1)+vector, v[k]] for k in range(5) if v[k]]
                h = []
                for m in range(16):
                    score = sum(a*b for a, b in zip(v, g(m)))
                    h.append(score if status[m] == 1 else max(0, score) if status[m] == 0 else 0)
                bound = sum(a*b for a, b in zip(h, lam))
                assert all(value <= bound for value in values)
                individual_bounds += len(values)
            assert prov['h'] == h and prov['feature_terms'] == terms
            left = sum((Q(value)*wanted[j] for j, value in terms), Q(0))
            a = [-sum(h[m]*C[m][k] for m in range(16)) for k in range(5)]
            rhs = sum(h[m]*base[m] for m in range(16))-left
            assert list(map(Q, prov['a'])) == a and Q(prov['b']) == rhs == Q(saved['rhs'])
            collected = Counter()
            for index, coefficient in zip(ids, a):
                collected[index] += coefficient
            expected = [[j, value] for j, value in sorted(collected.items()) if value]
            assert saved['terms'] == expected
            slack = rhs-sum(value*q[j] for j, value in expected)
            assert slack >= 0; slacks.append(slack); source_rows += 1
        assert seen_lambda == set(range(16))
        for cid, (status, indices) in enumerate(groups):
            r, facets, G = normals(status)
            seen = seen_normals[cid]
            expected_facets = {tuple(sign*x for x in normal) for sign in (-1, 1) for normal in facets}
            assert len(seen['facet']) == len(set(seen['facet'])) and set(seen['facet']) == expected_facets
            eq = seen['equality']; assert len(eq) == len(set(eq)) == 2*(5-r)
            assert all(tuple(-x for x in normal) in eq for normal in eq)
            assert qrank(eq, 5) == 5-r
            facet_directions += len(seen['facet']); equality_directions += len(eq)
        local_laws.append(dict(quad=quad, X_anchors=xx, Z_anchors=zz, higher_variable_indices=ids,
                               lambda_masses=list(map(str, lam)), minimum_lambda=str(min(lam))))
    assert source_rows == len(bank['rows']) and min(slacks) == Q(bank['solution']['minimum_exact_slack'])
    return dict(status='PASS_EXACT_SHARED_LOCAL_BOX_ROWS_ONLY', source_C16_answered=False,
                candidate_sha256=sha(path), frozen_sha256=sha(frozen_path), point_sha256=sha(point),
                point_c16_path=bank['point_c16_path'], producer_source_hashes=bank['source_hashes'],
                physical_symmetry_bridge=bridge, quads_checked=len(local_laws), pattern_laws_checked=16*len(local_laws),
                low_moment_equalities_checked=11*len(local_laws), shared_higher_moments=len(q), uncoupled_higher_moments=5*len(local_laws),
                exact_rows_rebuilt=source_rows, signed_facet_directions_checked=facet_directions,
                annihilator_directions_checked=equality_directions, individual_vector_bounds_checked=individual_bounds,
                canonical_higher_monomial_action_checks=monomial_action_checks,
                minimum_exact_slack=str(min(slacks)), local_laws=local_laws, higher_moments=list(map(str, q)),
                facet_cache=normals.cache_info()._asdict(), exact_optimal_margin_claimed=False,
                latest_point_transfer_claimed=False, full_basis_membership_claimed=False, elapsed_seconds=time.monotonic()-start,
                scope='Exact feasibility of this frozen16-quad shared-higher-moment local-box row model at the named point only. Shared bucket counts, physical matroid rank constraints and unanchored X/Z compatibility remain omitted; no frame or source obstruction follows.')


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--candidate', type=Path, required=True); ap.add_argument('--output', type=Path, required=True)
    a = ap.parse_args(); assert not a.output.exists(); result = check_candidate(a.candidate)
    result['consumer_sha256'] = sha(__file__)
    result['dependencies'] = {p:sha(ROOT/p) for p in ['verify_two_basis_local_box.py', 'verify_two_sided_full_basis_oracle.py']}
    a.output.write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k not in ('producer_source_hashes', 'local_laws', 'higher_moments')}, indent=2), flush=True)


if __name__ == '__main__':
    main()
