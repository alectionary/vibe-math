#!/usr/bin/env python3
"""Independent circuit-shortening screen and exact word-subspace controls.

The source replay eliminates128 physical EVALUATION rows, whereas discovery
eliminates the eligible physical POOL vectors. A rank/orthogonality check proves
that the reconstructed parity-check kernel is exactly the evaluation code.
Nullity on each circuit is then independent of the choice of systematic basis.

General theorem: in a full dual frame containing opposite J, a quotient witness
w needs at least d(w) opposite words outside J. Its expansion in the dual basis
has exactly as many such terms as selected residual X vectors detecting w.
For an r-dimensional quotient witness space, each selected residual X detects
either0 or2^(r-1) of its nonzero witnesses. Summing therefore gives
ceil(sum d(w)/2^(r-1)) <= selected_detector_union_count <= rank(U_union).
Ordinary physical rank is enough; no quotient of the detector pool is needed.
"""
from pathlib import Path
from itertools import combinations
from collections import Counter
import argparse
import hashlib
import json
import time
from verify_algebraic_model import physical

ROOT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def dimension(vectors):
    rows = {}
    for value in vectors:
        while value:
            low = value & -value
            if low not in rows:
                rows[low] = value
                break
            value ^= rows[low]
    return len(rows)


def evaluation_parity_columns(U, V, J, n=128):
    ids = [i for i, u in enumerate(U) if all((u & V[j]).bit_count() % 2 == 0 for j in J)]
    generators = [sum(((U[i] >> k) & 1) << t for t, i in enumerate(ids)) for k in range(n)]
    rows = {}
    for value in generators:
        while value:
            low = value & -value
            p = low.bit_length()-1
            if p not in rows:
                rows[p] = value
                break
            value ^= rows[p]
    for p in sorted(rows, reverse=True):
        for q in rows:
            if q < p and rows[q] >> p & 1:
                rows[q] ^= rows[p]
    free = [t for t in range(len(ids)) if t not in rows]
    H = {ids[t]: 1 << k for k, t in enumerate(free)}
    for p, row in rows.items():
        H[ids[p]] = sum(((row >> t) & 1) << k for k, t in enumerate(free))
    for row in generators:
        check = 0
        while row:
            low = row & -row
            row ^= low
            check ^= H[ids[low.bit_length()-1]]
        assert check == 0
    assert all(H[ids[t]] == 1 << k for k, t in enumerate(free))
    assert len(rows)+len(free) == len(ids)
    return ids, H, len(rows)


def span(values):
    result = {0}
    for value in values:
        result |= {x ^ value for x in list(result)}
    return result


def exact_word_demands(V, J=()):
    initial = span(V[j] for j in J)
    distance = {w: 0 for w in initial}
    frontier = set(initial)
    depth = 0
    while frontier:
        depth += 1
        new = {w ^ v for w in frontier for v in V}-distance.keys()
        for w in new:
            distance[w] = depth
        frontier = new
    return distance


def physical_witness(U, ids, support):
    """Solve every residual physical evaluation equation, with free bits zero."""
    rows = {}
    support = set(support)
    for i in ids:
        value, rhs = U[i], int(i in support)
        while value:
            low = value & -value
            if low not in rows:
                rows[low] = value, rhs
                break
            old, bit = rows[low]
            value ^= old
            rhs ^= bit
        if not value:
            assert rhs == 0
    witness = 0
    for low, (row, rhs) in sorted(rows.items(), reverse=True):
        if rhs ^ ((row & witness).bit_count() % 2):
            witness |= low
    assert all((U[i] & witness).bit_count() % 2 == int(i in support) for i in ids)
    return witness


def analyze_candidate(candidate, U, V, parent_records):
    """Exact quotient one/two/three-sum absence; demand capped at four.

    A returned demand4 means at least4, not an asserted4-term expression.
    These checks use all720 physical opposite-pool vectors modulo span(J).
    """
    J, D = candidate['mandatory_opposite'], candidate['circuit_indices']
    ids = [i for i, u in enumerate(U) if all((u & V[j]).bit_count() % 2 == 0 for j in J)]
    generators = [physical_witness(U, ids, [i for t, i in enumerate(D) if mask >> t & 1])
                  for mask in candidate['kernel_masks']]
    r = len(generators)
    assert dimension([*(V[j] for j in J), *generators]) == len(J)+r
    rows = {}
    for j in J:
        value = V[j]
        while value:
            low = value & -value
            if low not in rows:
                rows[low] = value
                break
            value ^= rows[low]
    def quotient(value):
        for low in sorted(rows):
            if value & low:
                value ^= rows[low]
        return value
    labels = {quotient(v) for v in V} | {0}
    assert all(quotient(V[j]) == 0 for j in J)
    pairs = {a ^ b for a in labels for b in labels}
    records = []
    for word in sorted(span(generators)-{0}):
        target = quotient(word)
        assert target != 0
        if target in labels:
            demand = 1
        elif target in pairs:
            demand = 2
        elif any(target ^ a in pairs for a in labels):
            demand = 3
        else:
            demand = 4
        support = [i for i in ids if (U[i] & word).bit_count() % 2]
        records.append({'witness_hex': hex(word), 'quotient_hex': hex(target),
                        'demand_lower_bound': demand, 'demand_exact_below_four': demand < 4,
                        'detector_indices': support, 'detector_rank': dimension(U[i] for i in support)})
    detector_union = sorted(set().union(*(set(row['detector_indices']) for row in records)))
    union_rank = dimension(U[i] for i in detector_union)
    divisor = 1 << (r-1)
    demand_sum = sum(row['demand_lower_bound'] for row in records)
    lower = (demand_sum+divisor-1)//divisor
    for i in ids:
        assert sum((U[i] & int(row['witness_hex'], 16)).bit_count() % 2 for row in records) in (0, divisor)
    parents = [number for number, parent in enumerate(parent_records)
               if parent['certificate']['side'] == candidate.get('side', 0)
               and set(parent['certificate']['mandatory_opposite']) <= set(J)]
    return {'case': candidate['case'], 'domain_index': candidate['circuit_index'],
            'side': candidate.get('side', 0), 'mandatory_opposite': J,
            'witness_space_dimension': r, 'witness_generators_hex': list(map(hex, generators)),
            'words': records, 'distinct_quotient_labels_including_zero': len(labels),
            'distinct_pair_sums': len(pairs), 'demand_sum': demand_sum,
            'detector_union': detector_union, 'detector_union_rank': union_rank,
            'selected_detector_lower_bound': lower, 'summed_obstruction': lower > union_rank,
            'individual_obstruction_count': sum(row['demand_lower_bound'] > row['detector_rank'] for row in records),
            'already_subsumed_by_fixed_witness_records': parents}


def literal_controls():
    positive = []
    for r in (2, 3):
        n = r+1
        U = list(range(1, 1 << r))+[1 << r]
        V = list(range(1 << r, 1 << n))
        witnesses = list(range(1, 1 << r))
        demands = exact_word_demands(V)
        assert all(demands[w] == 2 for w in witnesses)
        supports = [[i for i, u in enumerate(U) if (u & w).bit_count() % 2] for w in witnesses]
        union = sorted(set().union(*map(set, supports)))
        union_rank = dimension(U[i] for i in union)
        divisor = 1 << (r-1)
        lower = (sum(demands[w] for w in witnesses)+divisor-1)//divisor
        assert lower > union_rank
        assert all(demands[w] <= dimension(U[i] for i in D) for w, D in zip(witnesses, supports))
        frame_count = 0
        for I in combinations(range(len(U)), n):
            for B in combinations(range(len(V)), n):
                gram = [[(U[i] & V[j]).bit_count() % 2 for j in B] for i in I]
                frame_count += all(sum(row) == 1 for row in gram) and all(sum(row[j] for row in gram) == 1 for j in range(n))
        assert frame_count == 0
        # The r2 example's detector union is itself a3-vector physical circuit.
        if r == 2:
            ids, H, rank = evaluation_parity_columns(U, V, [], n)
            assert rank == n and len(union)-dimension(H[i] for i in union) == 2
        positive.append({'ambient_dimension': n, 'witness_space_dimension': r,
                         'U': U, 'V': V, 'witnesses': witnesses, 'exact_word_demands': [demands[w] for w in witnesses],
                         'individual_detector_ranks': [dimension(U[i] for i in D) for D in supports],
                         'detector_union_rank': union_rank, 'selected_detector_lower_bound': lower,
                         'literal_full_frame_count': frame_count})
    # Full-frame controls in4D use all source X vectors and the standard Z basis.
    # J ranges over leading standard basis coordinates. Every quotient subspace
    # of dimension2 or3 is examined literally; the selected X basis is standard.
    incidence = full_frame_checks = 0
    V = [1, 2, 4, 8]
    for jsize in range(3):
        J = list(range(jsize))
        U = [u for u in range(1, 16) if all(not (u & V[j]).bit_count() % 2 for j in J)]
        words = [w << jsize for w in range(1, 1 << (4-jsize))]
        demands = exact_word_demands(V, J)
        for r in (2, 3):
            seen = set()
            for generators in combinations(words, r):
                W = frozenset(span(generators)-{0})
                if len(W) != (1 << r)-1 or W in seen:
                    continue
                seen.add(W)
                union = [u for u in U if any((u & w).bit_count() % 2 for w in W)]
                for u in U:
                    number = sum((u & w).bit_count() % 2 for w in W)
                    assert number in (0, 1 << (r-1))
                    incidence += 1
                selected = [u for u in V[jsize:] if u in union]
                total = sum(demands[w] for w in W)
                assert total == (1 << (r-1))*len(selected)
                assert len(selected) <= dimension(union)
                full_frame_checks += 1
    # Wrong demand and dependent witness-generators cannot masquerade as a proof.
    assert exact_word_demands([4, 5, 6, 7])[1] == 2
    assert not (exact_word_demands([4, 5, 6, 7])[1] >= 3)
    assert dimension([1, 1]) != 2
    return {'positive_controls': positive, 'literal_nonzero_evaluation_incidence_checks': incidence,
            'quotient_subspace_full_frame_controls': full_frame_checks,
            'false_demand_and_dependent_witness_controls_rejected': 2,
            'single_word_detector_rank_bounds_all_pass_positive_examples': True}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--bank', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--producer-source', type=Path, default=ROOT/'word_subspace_rank_probe.py')
    args = ap.parse_args()
    start = time.monotonic()
    bank = json.loads(args.bank.read_text())
    frozen_path = args.bank.with_suffix('.frozen.json')
    frozen = json.loads(frozen_path.read_text())
    assert bank['frozen_sha256'] == sha(frozen_path)
    assert frozen['producer_sha256'] == sha(args.producer_source)
    assert all(sha(ROOT/p) == digest for p, digest in frozen['source_hashes'].items())
    X, Z, _ = physical()
    for side, values in [('x', X), ('z', Z)]:
        assert values == [int(v, 16) for v in (ROOT/f'pools/{side}coords.txt').read_text().split()]
    # The shared index map is a linear isomorphism, so the X-pool closed-flat
    # index library is also the exact Z-pool closed-flat library.
    assert dimension(X) == dimension(Z) == dimension(x | (z << 128) for x, z in zip(X, Z)) == 128
    if frozen.get('cohort_kind') == 'hard_word_deletions':
        parents = json.loads((ROOT/'moment-resumption-results/fixed-witness-controls.json').read_text())['records']
        deleted = {}
        for number, parent in enumerate(parents):
            certificate = parent['certificate']
            for removed in certificate['mandatory_opposite']:
                key = certificate['side'], tuple(sorted(set(certificate['mandatory_opposite'])-{removed}))
                deleted.setdefault(key, []).append({'parent_record': number, 'removed': removed})
        cohort = sorted(deleted)
        count = len(frozen['cohort'])
        assert frozen['cohort'] == [list(J) for _, J in cohort[:count]]
        assert frozen['cohort_sides'] == [side for side, _ in cohort[:count]]
        assert frozen['cohort_origins'] == [deleted[key] for key in cohort[:count]]
    classes = json.loads((ROOT/'moment-resumption-results/physical-rank-moment-bank.json').read_text())['physical_circuits']
    circuits = sorted({tuple(sorted(16*(i//16)+(i % 16+h) % 16 for i in D)) for D in classes for h in range(16)})
    assert len(circuits) == frozen['translated_circuits']
    for D in circuits:
        assert dimension(X[i] for i in D) == len(D)-1
        for omitted in D:
            assert dimension(X[i] for i in D if i != omitted) == len(D)-1
    flat_domains = None
    if frozen.get('domain_mode') in ('closed_flats', 'union_flats'):
        flats = set()
        for C in circuits:
            rows = {}
            for i in C:
                value = X[i]
                while value:
                    low = value & -value
                    if low not in rows:
                        rows[low] = value
                        break
                    value ^= rows[low]
            D = []
            for i, original in enumerate(X):
                value = original
                while value:
                    low = value & -value
                    if low not in rows:
                        break
                    value ^= rows[low]
                if not value:
                    D.append(i)
            flats.add(tuple(D))
        flat_domains = sorted(flats)
        if frozen.get('domain_mode') == 'union_flats':
            preparation = frozen['union_preparation']
            assert preparation['input_closed_flats'] == len(flat_domains)
            initial_flats = flat_domains
            basis_list = []
            for D in initial_flats:
                rows = {}
                for i in D:
                    value = X[i]
                    while value:
                        low = value & -value
                        if low not in rows:
                            rows[low] = value
                            break
                        value ^= rows[low]
                basis_list.append(rows)
            spans = set()
            eligible_pairs = 0
            for number, (i, j) in enumerate(combinations(range(len(initial_flats)), 2)):
                if number >= preparation['input_pairs_processed']:
                    break
                rows = basis_list[i].copy()
                for value in basis_list[j].values():
                    while value:
                        low = value & -value
                        if low not in rows:
                            rows[low] = value
                            break
                        value ^= rows[low]
                    if len(rows) > 6:
                        break
                if len(rows) <= 6:
                    eligible_pairs += 1
                    for p in sorted(rows, reverse=True):
                        for q in rows:
                            if q < p and rows[q] & p:
                                rows[q] ^= rows[p]
                    spans.add(tuple(rows[p] for p in sorted(rows)))
            assert eligible_pairs == preparation['rank_at_most_six_pairs']
            assert len(spans) == preparation['distinct_spans']
            assert {str(k): v for k, v in Counter(map(len, spans)).items()} == preparation['span_rank_histogram']
            assert preparation['all_input_pairs'] == len(initial_flats)*(len(initial_flats)-1)//2
            assert preparation['complete'] == (preparation['input_pairs_processed'] == preparation['all_input_pairs'])
            lookup = {v: i for i, v in enumerate(X)}
            flats = set()
            for B in spans:
                S = {0}
                for value in B:
                    S |= {v ^ value for v in list(S)}
                flats.add(tuple(sorted(lookup[v] for v in S if v in lookup)))
            flat_domains = sorted(flats)
        assert list(map(list, flat_domains)) == frozen['global_closed_flats']
    assert [r['mandatory_opposite'] for r in bank['records']] == frozen['cohort'][:len(bank['records'])]
    if bank['status'] == 'COMPLETE_SHORTENED_SUBSPACE_SCREEN':
        assert len(bank['records']) == len(frozen['cohort'])
    expected_candidates = {(r['case'], r['circuit_index']): r for r in bank['candidates']}
    assert len(expected_candidates) == len(bank['candidates'])
    actual_candidates = set()
    totals = Counter()
    for case, expected in enumerate(bank['records']):
        J = expected['mandatory_opposite']
        side = frozen.get('cohort_sides', [0]*len(frozen['cohort']))[case]
        assert expected.get('side', 0) == side
        U, V = (X, Z) if side == 0 else (Z, X)
        assert dimension(V[j] for j in J) == len(J)
        ids, H, r = evaluation_parity_columns(U, V, J)
        assert r == 128-len(J) == expected['residual_rank']
        assert len(ids) == expected['eligible_pool_size']
        histogram = Counter()
        eligible = 0
        if flat_domains is None:
            domains = [(number, D) for number, D in enumerate(circuits) if all(i in H for i in D)]
        else:
            domains = list(enumerate(sorted({tuple(i for i in D if i in H) for D in flat_domains})))
        if 'domains_total' in expected:
            assert expected['domains_total'] == len(domains)
            assert 0 <= expected['domains_processed'] <= len(domains)
            domains = domains[:expected['domains_processed']]
        for number, D in domains:
            eligible += 1
            nullity = len(D)-dimension(H[i] for i in D)
            physical_rank = dimension(U[i] for i in D)
            histogram[len(D), physical_rank, nullity] += 1
            if nullity >= 2:
                actual_candidates.add((case, number))
                candidate = expected_candidates[case, number]
                assert candidate['mandatory_opposite'] == J and candidate['circuit_indices'] == list(D)
                assert candidate.get('side', 0) == side
                assert candidate['shortened_dimension'] == nullity
                if 'physical_rank' in candidate:
                    assert candidate['physical_rank'] == physical_rank
                kernel = candidate['kernel_masks']
                assert len(kernel) == dimension(kernel) == nullity
                for mask in kernel:
                    check = 0
                    for h, i in enumerate(D):
                        if mask >> h & 1:
                            check ^= H[i]
                    assert 0 < mask < 1 << len(D) and check == 0
        if expected['shortened_dimension_histogram'] and 'circuit_size' in expected['shortened_dimension_histogram'][0]:
            observed = [{'circuit_size': size, 'dimension': d, 'count': n} for (size, _, d), n in sorted(histogram.items())]
        else:
            observed = [{'support_size': size, 'physical_rank': pr, 'dimension': d, 'count': n} for (size, pr, d), n in sorted(histogram.items())]
        assert observed == expected['shortened_dimension_histogram'] and eligible == expected['eligible_circuits']
        totals['cases'] += 1
        totals['eligible_circuits' if flat_domains is None else 'residual_closed_flats'] += eligible
        totals['shortened_dimension_at_least_two'] += sum(n for (_, _, d), n in histogram.items() if d >= 2)
    assert actual_candidates == set(expected_candidates)
    assert dict(totals) == bank['statistics']
    controls = literal_controls()
    parents_path = ROOT/'moment-resumption-results/fixed-witness-controls.json'
    parents = json.loads(parents_path.read_text())['records']
    demand_analyses = [analyze_candidate(c, X if c.get('side', 0) == 0 else Z,
                                        Z if c.get('side', 0) == 0 else X, parents)
                       for c in bank['candidates']]
    out = {'status': 'PASS', 'source_C16_answered': False, 'bank_sha256': sha(args.bank),
           'frozen_sha256': sha(frozen_path), 'consumer_sha256': sha(Path(__file__)),
           'source_hashes': frozen['source_hashes'], 'statistics': dict(totals),
           'physical_circuits_checked': len(circuits), 'evaluation_code_orthogonality_and_rank_replayed': True,
           'global_closed_flats_independently_reconstructed': len(flat_domains) if flat_domains is not None else 0,
           'literal_controls': controls, 'elapsed_seconds': time.monotonic()-start,
           'candidate_word_demand_analyses': demand_analyses,
           'fixed_witness_parent_bank_sha256': sha(parents_path),
           'comparison_to_previous_rules': 'Existing detecting_capacity variants use one quotient witness and a previously forbidden child inside its detecting support. They do not sum demands over a witness subspace. The positive controls pass every individual word-demand versus physical-detector-rank inequality but violate the new summed bound.',
           'scope': 'Exact screening of the declared finite raw-circuit or closed-flat domains. Zero shortened dimension>=2 excludes any witness subspace supported inside these domains on the processed mandatory sets, irrespective of word demands. It says nothing about unions extending beyond this library, source extendibility, or the original width.'}
    args.output.write_text(json.dumps(out, indent=2)+'\n')
    print({k: v for k, v in out.items() if k not in ['source_hashes', 'literal_controls']}, flush=True)
    print('CONTROLS', controls, flush=True)


if __name__ == '__main__':
    main()
