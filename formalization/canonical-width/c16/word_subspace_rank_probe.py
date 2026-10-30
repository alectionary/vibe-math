#!/usr/bin/env python3
"""Bounded circuit-supported evaluation-subspace gate for word-demand rank cuts.

For an r-dimensional quotient witness space W, every selected residual X in
the union of its detecting supports detects exactly2^(r-1) nonzero witnesses.
Thus ceil(sum over nonzero w in W of demand(w), divided by2^(r-1)) cannot exceed the physical rank
of that union. This initial gate finds every possible r>=2 witness space whose
entire support fits in a fixed translated physical-circuit library. It performs
no short-word search when no such support space exists.
"""
from pathlib import Path
from collections import Counter
from itertools import combinations
import argparse
import hashlib
import json
import time
from verify_algebraic_model import physical

ROOT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def rank(values):
    rows = {}
    for value in values:
        while value:
            p = value.bit_length()-1
            if p not in rows:
                rows[p] = value
                break
            value ^= rows[p]
    return len(rows)


def row_basis(values, maximum=None):
    rows = {}
    for value in values:
        while value:
            p = value.bit_length()-1
            if p not in rows:
                rows[p] = value
                break
            value ^= rows[p]
        if maximum is not None and len(rows) > maximum:
            return rows
    return rows


def canonical_rows(rows):
    rows = rows.copy()
    for p in sorted(rows):
        for q in rows:
            if q > p and rows[q] >> p & 1:
                rows[q] ^= rows[p]
    return tuple(rows[p] for p in sorted(rows))


def parity_columns(U, V, J):
    """Primal physical-vector elimination, with coordinates in a source basis."""
    ids = [i for i, u in enumerate(U) if all(not (u & V[j]).bit_count() % 2 for j in J)]
    rows = {}
    originals = []
    nonbasis = []
    for i in ids:
        value, tag = U[i], 0
        while value:
            p = value.bit_length()-1
            if p not in rows:
                rows[p] = value, tag ^ (1 << len(originals))
                originals.append(i)
                break
            row, oldtag = rows[p]
            value ^= row
            tag ^= oldtag
        if not value:
            nonbasis.append((i, tag))
    H = {i: 0 for i in originals}
    for t, (i, tag) in enumerate(nonbasis):
        H[i] = 1 << t
        for k, original in enumerate(originals):
            if tag >> k & 1:
                H[original] |= 1 << t
    return ids, H, len(originals)


def kernel_basis(columns):
    rows = {}
    kernel = []
    for i, value in enumerate(columns):
        tag = 1 << i
        while value:
            p = value.bit_length()-1
            if p not in rows:
                rows[p] = value, tag
                break
            row, oldtag = rows[p]
            value ^= row
            tag ^= oldtag
        if not value:
            kernel.append(tag)
    return kernel


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--seconds', type=float, default=180)
    ap.add_argument('--max-cases', type=int, default=383)
    ap.add_argument('--domain-mode', choices=['circuits', 'closed_flats', 'union_flats'], default='circuits')
    ap.add_argument('--prepare-seconds', type=float, default=60)
    ap.add_argument('--stop-after-candidates', type=int, default=0)
    ap.add_argument('--cohort', choices=['pair_deletions', 'hard_word_deletions'], default='pair_deletions')
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    start = time.monotonic()
    cohort_path = ROOT / ('transfer-results/capacity/frozen.json' if args.cohort == 'pair_deletions' else 'moment-resumption-results/fixed-witness-controls.json')
    circuit_path = ROOT / 'moment-resumption-results/physical-rank-moment-bank.json'
    if args.cohort == 'pair_deletions':
        cohort = [dict(r, side=0) for r in json.loads(cohort_path.read_text())['cohort'] if r['ids'] != [416, 512]][:args.max_cases]
    else:
        parents = json.loads(cohort_path.read_text())['records']
        deleted = {}
        for parent_index, parent in enumerate(parents):
            certificate = parent['certificate']
            for removed in certificate['mandatory_opposite']:
                key = certificate['side'], tuple(sorted(j for j in certificate['mandatory_opposite'] if j != removed))
                deleted.setdefault(key, []).append({'parent_record': parent_index, 'removed': removed})
        cohort = [{'side': side, 'ids': list(J), 'origins': origins} for (side, J), origins in sorted(deleted.items())][:args.max_cases]
    classes = json.loads(circuit_path.read_text())['physical_circuits']
    circuits = sorted({tuple(sorted(16*(i//16)+(i % 16+h) % 16 for i in c)) for c in classes for h in range(16)})
    preparation_frozen = {'status': 'FROZEN_BEFORE_DOMAIN_PREPARATION', 'domain_mode': args.domain_mode,
                          'prepare_seconds': args.prepare_seconds, 'scan_seconds': args.seconds,
                          'stop_after_candidates': args.stop_after_candidates,
                          'cohort': args.cohort,
                          'cohort_sha256': sha(cohort_path), 'circuit_bank_sha256': sha(circuit_path),
                          'producer_sha256': sha(Path(__file__))}
    preparation_path = args.output.with_suffix('.preparation-frozen.json')
    preparation_path.write_text(json.dumps(preparation_frozen, indent=2)+'\n')
    X, Z, _ = physical()
    flat_domains = None
    union_preparation = None
    if args.domain_mode in ('closed_flats', 'union_flats'):
        lookup = {v: i for i, v in enumerate(X)}
        assert len(lookup) == len(X)
        flats = set()
        for C in circuits:
            values = {0}
            for i in C:
                values |= {v ^ X[i] for v in list(values)}
            flats.add(tuple(sorted(lookup[v] for v in values if v in lookup)))
        flat_domains = sorted(flats)
        if args.domain_mode == 'union_flats':
            initial_flats = flat_domains
            initial_rows = [row_basis(X[i] for i in D) for D in initial_flats]
            unique = set()
            processed = eligible_pairs = 0
            for i, j in combinations(range(len(initial_flats)), 2):
                if time.monotonic()-start >= args.prepare_seconds:
                    break
                processed += 1
                combined = row_basis([*initial_rows[i].values(), *initial_rows[j].values()], maximum=6)
                if len(combined) <= 6:
                    eligible_pairs += 1
                    unique.add(canonical_rows(combined))
            flats = set()
            for basis in unique:
                values = {0}
                for value in basis:
                    values |= {v ^ value for v in list(values)}
                flats.add(tuple(sorted(lookup[v] for v in values if v in lookup)))
            flat_domains = sorted(flats)
            union_preparation = {'input_closed_flats': len(initial_flats), 'input_pairs_processed': processed,
                                 'all_input_pairs': len(initial_flats)*(len(initial_flats)-1)//2,
                                 'complete': processed == len(initial_flats)*(len(initial_flats)-1)//2,
                                 'rank_at_most_six_pairs': eligible_pairs, 'distinct_spans': len(unique),
                                 'span_rank_histogram': dict(Counter(map(len, unique))),
                                 'elapsed_seconds': time.monotonic()-start}
    frozen = {'status': 'FROZEN_BEFORE_CIRCUIT_SHORTENED_SUBSPACE_SCREEN',
              'cohort': [r['ids'] for r in cohort], 'circuit_classes': len(classes),
              'cohort_sides': [r['side'] for r in cohort], 'cohort_origins': [r['origins'] for r in cohort],
              'cohort_kind': args.cohort,
              'translated_circuits': len(circuits), 'seconds': args.seconds,
              'domain_mode': args.domain_mode,
              'global_closed_flats': flat_domains,
              'union_preparation': union_preparation,
              'preparation_frozen_sha256': sha(preparation_path),
              'stop_after_candidates': args.stop_after_candidates,
              'source_hashes': {str(p.relative_to(ROOT)): sha(p) for p in [cohort_path, circuit_path, ROOT/'physical-pool-source.json', ROOT/'pools/xcoords.txt', ROOT/'pools/zcoords.txt']},
              'producer_sha256': sha(Path(__file__)),
              'scope': 'Complete within the frozen domain library and processed mandatory sets: domains are the library circuits, or their full source-pool linear closures intersected with the residual pool, as declared by domain_mode. Detect every evaluation subspace of dimension>=2 supported inside a domain. No all-subspace or all-source completeness claim.'}
    frozen_path = args.output.with_suffix('.frozen.json')
    frozen_path.write_text(json.dumps(frozen, indent=2)+'\n')
    circuit_sizes = Counter()
    for D in circuits:
        vectors = [X[i] for i in D]
        assert rank(vectors) == len(D)-1
        assert all(rank(vectors[:k]+vectors[k+1:]) == len(D)-1 for k in range(len(D)))
        circuit_sizes[len(D)] += 1
    records, candidates = [], []
    totals = Counter()
    scan_start = time.monotonic()
    stop_hit = False
    for case, item in enumerate(cohort):
        if time.monotonic()-scan_start >= args.seconds:
            break
        J = item['ids']
        side = item['side']
        U, V = (X, Z) if side == 0 else (Z, X)
        assert rank(V[j] for j in J) == len(J)
        ids, H, residual_rank = parity_columns(U, V, J)
        assert residual_rank == 128-len(J)
        histogram = Counter()
        eligible = 0
        if flat_domains is None:
            domains = [(number, D) for number, D in enumerate(circuits) if all(i in H for i in D)]
        else:
            domains = list(enumerate(sorted({tuple(i for i in D if i in H) for D in flat_domains})))
        for number, D in domains:
            eligible += 1
            kernel = kernel_basis([H[i] for i in D])
            physical_rank = rank(U[i] for i in D)
            histogram[len(D), physical_rank, len(kernel)] += 1
            if len(kernel) >= 2:
                candidates.append({'case': case, 'mandatory_opposite': J, 'circuit_index': number,
                                   'side': side,
                                   'circuit_indices': D, 'shortened_dimension': len(kernel),
                                   'physical_rank': physical_rank,
                                   'kernel_masks': kernel})
                if args.stop_after_candidates and len(candidates) >= args.stop_after_candidates:
                    stop_hit = True
                    break
        totals['cases'] += 1
        totals['eligible_circuits' if flat_domains is None else 'residual_closed_flats'] += eligible
        totals['shortened_dimension_at_least_two'] += sum(n for (_, _, d), n in histogram.items() if d >= 2)
        records.append({'mandatory_opposite': J, 'side': side, 'eligible_pool_size': len(ids), 'residual_rank': residual_rank,
                        'eligible_circuits': eligible,
                        'domains_processed': eligible, 'domains_total': len(domains),
                        'shortened_dimension_histogram': [{'support_size': size, 'physical_rank': pr, 'dimension': dim, 'count': n} for (size, pr, dim), n in sorted(histogram.items())]})
        if case % 25 == 0:
            print('SUBSPACE SCREEN', case+1, dict(totals), round(time.monotonic()-scan_start, 2), flush=True)
        if stop_hit:
            break
    out = {'status': ('STRUCTURAL_CANDIDATE_FOUND' if stop_hit else 'COMPLETE_SHORTENED_SUBSPACE_SCREEN' if len(records) == len(cohort) else 'TIME_LIMIT'),
           'source_C16_answered': False, 'frozen_sha256': sha(frozen_path), 'records': records,
           'candidates': candidates, 'statistics': dict(totals), 'circuit_size_histogram': dict(circuit_sizes),
           'domain_mode': args.domain_mode,
           'global_closed_flat_count': len(flat_domains) if flat_domains is not None else None,
           'global_closed_flat_size_histogram': dict(Counter(map(len, flat_domains))) if flat_domains is not None else None,
           'scan_seconds': time.monotonic()-scan_start, 'union_preparation': union_preparation,
           'elapsed_seconds': time.monotonic()-start,
           'scope': 'Only subspaces supported inside the frozen domains are screened (raw circuits or full source-pool closures, as declared). If candidates is empty, no r>=2 witness subspace has its detector union inside any processed domain, independently of word demands. No all-subspace completeness, source extendibility or source-case completion is claimed.'}
    args.output.write_text(json.dumps(out, indent=2)+'\n')
    print({k: v for k, v in out.items() if k not in ['records', 'candidates']}, flush=True)
    print('CANDIDATES', len(candidates), flush=True)


if __name__ == '__main__':
    main()
