#!/usr/bin/env python3
"""Independent physical replay of absent-anchor rank inequalities.

The source proof uses independence only. On A_a=0, the selected same-sector
basis excludes a; for either counted sector, its intersection with K has at
most physical rank(K) elements. Multiplying this inequality by 1-A_a and
averaging gives the saved degree-two row. The exact cardinality128 is checked
for the point's conditional targets; it is not needed for individual cut
validity. This consumer imports the proposed compiler only as an object under
test against literal32-action averaging; it does not import producer ranks.
"""
from pathlib import Path
from fractions import Fraction as Q
from itertools import combinations
import argparse, gzip, hashlib, json, random, time, math
import numpy as np
from certify_profile_moment_point import layout
from verify_algebraic_model import physical
from verify_partial_frame import mask, shift
from audit_pools import exchange
from absent_anchor_rank_probe import row_terms

ROOT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def dimension(vectors):
    rows = {}
    for value in vectors:
        while value:
            low = value & -value
            if low in rows:
                value ^= rows[low]
            else:
                rows[low] = value
                break
    return len(rows)


def span_members(vectors, indices, available):
    rows = {}
    for j in indices:
        value = vectors[j]
        while value:
            low = value & -value
            if low in rows:
                value ^= rows[low]
            else:
                rows[low] = value
                break
    result = []
    for j in available:
        value = vectors[j]
        while value and (value & -value) in rows:
            value ^= rows[value & -value]
        if not value:
            result.append(j)
    return result


def small_controls():
    checked = 0
    for n in (2, 3):
        pool = list(range(1, 1 << n))
        subsets = [[pool[j] for j in range(len(pool)) if bits >> j & 1] for bits in range(1 << len(pool))]
        bases = [B for B in combinations(pool, n) if dimension(B) == n]
        for B in bases:
            dual = [next(z for z in pool if all((x & z).bit_count() % 2 == int(i == j) for j, x in enumerate(B))) for i in range(n)]
            for anchor in pool:
                if anchor in B:
                    continue
                for K in subsets:
                    same = [j for j in K if j != anchor]
                    assert len(set(B) & set(same)) <= dimension(same)
                    assert len(set(dual) & set(K)) <= dimension(K)
                    checked += 2
    return checked


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--certificate', type=Path, required=True)
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    a = ap.parse_args()
    start = time.monotonic()
    d = json.loads(a.certificate.read_text())
    assert d['status'] == 'CANDIDATE_ABSENT_RANK_CUTS' and d['anchor_condition_value'] == 0
    assert d['point_sha256'] == d['input_hashes']['point_sha256'] == sha(a.point)
    assert d['input_hashes']['physical_source_sha256'] == sha(ROOT / 'physical-pool-source.json')
    hp = ROOT / 'algebraic-results/hulls-16-rank.json.gz'
    assert d['input_hashes']['hulls_sha256'] == sha(hp)
    assert all(d['input_hashes']['pool_sha256'][s] == sha(ROOT / f'pools/{s}coords.txt') for s in 'xz')
    X, Z, pairing = physical()
    assert [X, Z] == [[int(v, 16) for v in (ROOT / f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
    assert dimension(X) == dimension(Z) == 128
    # Bind the cyclic/sector average to actual frame-preserving permutations.
    turn_index = lambda j: 16 * (j // 16) + (j % 16 + 1) % 16
    for i in range(720):
        assert all(((pairing[i] >> j) & 1) == ((pairing[j] >> i) & 1) for j in range(720))
        row = 0
        for orbit in range(45):
            block = (pairing[i] >> (16 * orbit)) & 65535
            row |= (((block << 1) & 65535) | (block >> 15)) << (16 * orbit)
        assert row == pairing[turn_index(i)]
    assert all(dimension([U[j] | (U[turn_index(j)] << 128) for j in range(720)]) == 128 for U in (X, Z))
    hulls = json.loads(gzip.decompress(hp.read_bytes()))
    _, index, moment = layout(hulls)
    v = list(map(Q, json.loads(gzip.decompress(a.point.read_bytes()))['values']))
    p = [v[index['p', o]] for o in range(45)]
    assert sum(p) * 16 == 128 and all(0 <= q < 1 for q in p)
    expected_queries = {(s, o) for s in d['input_hashes']['sectors'] for o in d['input_hashes']['anchors']}
    actual_queries = {(r['sector'], r['anchor_orbit']) for r in d['records']}
    assert len(actual_queries) == len(d['records']) == d['queries_completed']
    assert actual_queries <= expected_queries and len(expected_queries) == d['queries_requested']
    assert d['complete_requested_query_list'] == (actual_queries == expected_queries)
    targets = {}
    query_facts = []
    for side, anchor in sorted(actual_queries):
        numerator = [p[j // 16] - v[moment(side, j % 16, anchor, j // 16)] for j in range(720)]
        norm = 1 - p[anchor]
        assert all(0 <= q <= norm for q in numerator) and sum(numerator) == 128 * norm
        deleted = 16 * anchor if side == 'S' else None
        available = [j for j in range(720) if j != deleted]
        U = X if side == 'S' else Z
        assert dimension(U[j] for j in available) == 128
        if deleted is not None:
            assert numerator[deleted] == 0
        targets[side, anchor] = (numerator, norm)
        query_facts.append({'sector': side, 'anchor_orbit': anchor, 'absence_probability': str(norm),
            'conditional_total': 128, 'available_pool_rank': 128})
    # Independently settle the finite seed-subset screen with exact arithmetic,
    # including the possible one-unit rank drop on deleting a same-sector
    # anchor. A rank128 graph proves the physical indexwise sector map is
    # linear, so the same independently computed subset ranks apply to Z.
    assert dimension([x | (z << 128) for x, z in zip(X, Z)]) == 128
    seed_sets = set()
    for path, expected in d['input_hashes']['seed_banks'].items():
        source_path = Path(path) if Path(path).is_absolute() else ROOT / path
        assert sha(source_path) == expected
        seed_sets.update(tuple(c['indices']) for c in json.loads(source_path.read_text())['cuts'])
    seed_sets = sorted(seed_sets)
    assert all(ids == tuple(sorted(set(ids))) and all(0 <= j < 720 for j in ids) for ids in seed_sets)
    seed_ranks = {ids: dimension(X[j] for j in ids) for ids in seed_sets}
    deletion_ranks = {}
    for side, anchor in actual_queries:
        if side == 'S':
            aidx = 16 * anchor
            for ids in seed_sets:
                if aidx in ids:
                    deletion_ranks[ids, aidx] = dimension(X[j] for j in ids if j != aidx)
    seed_checks = 0
    seed_violations = []
    max_seed_value = None
    for (side, anchor), (numerator, norm) in sorted(targets.items()):
        denominator = math.lcm(norm.denominator, *(q.denominator for q in numerator))
        scaled = [int(q * denominator) for q in numerator]
        normalizer = int(norm * denominator)
        for ids in seed_sets:
            deleted = 16 * anchor if side == 'S' else None
            bound = deletion_ranks.get((ids, deleted), seed_ranks[ids])
            integer_value = sum(scaled[j] for j in ids) - bound * normalizer
            value = Q(integer_value, denominator)
            max_seed_value = value if max_seed_value is None else max(max_seed_value, value)
            seed_checks += 1
            if integer_value > 0:
                seed_violations.append({'sector': side, 'anchor_orbit': anchor,
                    'indices': [j for j in ids if j != deleted], 'bound': bound,
                    'exact_violation': str(value), 'exact_normalized_violation': str(value / norm)})
    source = json.loads((ROOT / 'physical-pool-source.json').read_text())
    Zp = [shift(mask(s), h) for s in source['Z_orbit_representatives'] for h in range(16)]
    Xp = list(map(exchange, Zp))
    lookup = [{v: i for i, v in enumerate(U)} for U in (Xp, Zp)]
    pairs = [tuple(lookup[s][mask(r[side])] for s, side in enumerate(('X', 'Z'))) for r in json.loads((ROOT / 'partial-frame-88.json').read_text())['pairs']]
    assert all(((pairing[x] >> z) & 1) == (i == j) for i, (x, _) in enumerate(pairs) for j, (_, z) in enumerate(pairs))
    selected = [{pair[s] for pair in pairs} for s in (0, 1)]
    shifted_checks = partial_checks = closure_checks = 0
    results = []
    for cut in d['cuts']:
        side, anchor, ids = cut['sector'], cut['anchor_orbit'], cut['indices']
        assert side in ('S', 'T') and 0 <= anchor < 45 and cut['anchor_condition_value'] == 0
        assert ids == sorted(set(ids)) and ids and all(0 <= j < 720 for j in ids)
        deleted = 16 * anchor if side == 'S' else None
        assert cut['deleted_index'] == deleted and deleted not in ids
        U = X if side == 'S' else Z
        assert dimension(U[j] for j in ids) == cut['bound'], 'physical_rank_bound_mismatch'
        if cut['span_closed_in_available_pool']:
            assert span_members(U, ids, [j for j in range(720) if j != deleted]) == ids
            closure_checks += 1
        assert set(cut['proposed_indices']) <= set(ids)
        assert dimension(U[j] for j in cut['proposed_indices']) == cut['bound']
        numerator, norm = targets[side, anchor]
        exact = sum(numerator[j] for j in ids) - cut['bound'] * norm
        assert exact > 0 and exact == Q(cut['exact_violation'])
        assert exact / norm == Q(cut['exact_normalized_violation'])
        for phase in range(16):
            turn = lambda j: 16 * (j // 16) + (j % 16 + phase) % 16
            J = set(map(turn, ids))
            anchor_index = 16 * anchor + phase
            for s, counted_pool in enumerate((X, Z)):
                assert dimension(counted_pool[j] for j in J) == cut['bound']
                shifted_checks += 1
                anchor_sector = s if side == 'S' else 1 - s
                if anchor_index not in selected[anchor_sector]:
                    assert len(J & selected[s]) <= cut['bound']
                    partial_checks += 1
        assert dimension(U[j] for j in ids) != cut['bound'] - 1
        results.append({'sector': side, 'anchor_orbit': anchor, 'exact_violation': str(exact),
            'exact_normalized_violation': str(exact / norm), 'subset_size': len(ids), 'physical_rank': cut['bound']})
    # Test the compiler even when the bounded search found no new cut.
    rng = random.Random(202610300550)
    synthetic = []
    for side in ('S', 'T'):
        for anchor in (0, 12, 32, 44):
            available = [j for j in range(720) if side != 'S' or j != 16 * anchor]
            U = X if side == 'S' else Z
            for size in (1, 7, 33, len(available)):
                ids = sorted(rng.sample(available, size))
                synthetic.append({'sector': side, 'anchor_orbit': anchor, 'indices': ids,
                    'bound': dimension(U[j] for j in ids)})
    test_cuts = d['cuts'] + synthetic
    compiler_checks = 0
    flat_point = p + [v[moment(side, h, i, j)] for side in ('S', 'T') for h in range(9) for i in range(45) for j in range(45)]
    for cut in d['cuts']:
        terms, rhs = row_terms(cut)
        assert sum(c * flat_point[j] for j, c in terms) - rhs == Q(cut['exact_violation'])
    for control in range(12):
        masks = [[rng.getrandbits(16) for _ in range(45)] for _ in (0, 1)]
        corr = lambda a0, b0, h: (a0 & ((b0 >> h) | (b0 << (16 - h))) & 65535).bit_count()
        flat = [masks[0][i].bit_count() + masks[1][i].bit_count() for i in range(45)]
        flat += [sum(corr(masks[s][i], masks[s if side == 'S' else 1 - s][j], h) for s in (0, 1)) for side in ('S', 'T') for h in range(9) for i in range(45) for j in range(45)]
        for cut in test_cuts:
            terms, rhs = row_terms(cut)
            compiled = sum(c * flat[j] for j, c in terms) - 32 * rhs
            literal = 0
            for s in (0, 1):
                counted_sector = s if cut['sector'] == 'S' else 1 - s
                for phase in range(16):
                    if not (masks[s][cut['anchor_orbit']] >> phase & 1):
                        literal += sum(masks[counted_sector][j // 16] >> ((j % 16 + phase) % 16) & 1 for j in cut['indices']) - cut['bound']
            assert compiled == literal, 'absent_rank_compiler_translation_failed'
            compiler_checks += 1
    out = {'status': 'PASS', 'source_C16_answered': False, 'anchor_condition_value': 0,
        'bank_sha256': sha(a.certificate), 'certificate_sha256': sha(a.certificate), 'point_sha256': sha(a.point),
        'consumer_sha256': sha(Path(__file__)), 'compiler_sha256': sha(ROOT / 'absent_anchor_rank_probe.py'),
        'cuts_checked': len(results), 'results': results, 'conditional_target_queries_checked': len(query_facts),
        'conditional_target_facts': query_facts, 'physical_pairings_rebuilt': 518400,
        'physical_pool_ranks': [128, 128], 'shifted_sector_rank_checks': shifted_checks,
        'sector_exchange_pairing_checks': 518400, 'phase_generator_pairing_checks': 518400,
        'physical_phase_graph_ranks': [128, 128],
        'span_closure_checks': closure_checks, 'physical88_absence_controls': partial_checks,
        'literal32_action_compiler_comparisons': compiler_checks, 'synthetic_compiler_rows': len(synthetic),
        'literal_small_full_frame_absence_checks': small_controls(),
        'indexwise_sector_graph_rank': 128,
        'finite_seed_subsets': len(seed_sets), 'exact_seed_absence_rows_checked': seed_checks,
        'exact_seed_absence_violations': seed_violations,
        'maximum_exact_seed_absence_value': str(max_seed_value) if max_seed_value is not None else None,
        'same_anchor_deletion_seed_ranks_recomputed': len(deletion_ranks),
        'same_anchor_deletion_seed_rank_drops': sum(r < seed_ranks[ids] for (ids, aidx), r in deletion_ranks.items()),
        'lowered_rank_bound_negative_controls_rejected': len(results),
        'complete_matroid_membership_certified': False, 'elapsed_seconds': time.monotonic() - start,
        'scope': 'Every saved cut is a valid source absence-conditioned rank inequality and strictly rejects this exact point. Empty cuts mean only this bounded probe found none; they do not certify all absent-anchor basis polytopes feasible.'}
    a.output.write_text(json.dumps(out, indent=2) + '\n')
    print(json.dumps({k: v for k, v in out.items() if k not in ('conditional_target_facts', 'results')}, indent=2))


if __name__ == '__main__':
    main()
