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
    ap.add_argument('--domain-mode', choices=['circuits', 'closed_flats'], default='circuits')
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    start = time.monotonic()
    cohort_path = ROOT / 'transfer-results/capacity/frozen.json'
    circuit_path = ROOT / 'moment-resumption-results/physical-rank-moment-bank.json'
    cohort = [r for r in json.loads(cohort_path.read_text())['cohort'] if r['ids'] != [416, 512]][:args.max_cases]
    classes = json.loads(circuit_path.read_text())['physical_circuits']
    circuits = sorted({tuple(sorted(16*(i//16)+(i % 16+h) % 16 for i in c)) for c in classes for h in range(16)})
    X, Z, _ = physical()
    flat_domains = None
    if args.domain_mode == 'closed_flats':
        lookup = {v: i for i, v in enumerate(X)}
        assert len(lookup) == len(X)
        flats = set()
        for C in circuits:
            values = {0}
            for i in C:
                values |= {v ^ X[i] for v in list(values)}
            flats.add(tuple(sorted(lookup[v] for v in values if v in lookup)))
        flat_domains = sorted(flats)
    frozen = {'status': 'FROZEN_BEFORE_CIRCUIT_SHORTENED_SUBSPACE_SCREEN',
              'cohort': [r['ids'] for r in cohort], 'circuit_classes': len(classes),
              'translated_circuits': len(circuits), 'seconds': args.seconds,
              'domain_mode': args.domain_mode,
              'global_closed_flats': flat_domains,
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
    for case, item in enumerate(cohort):
        if time.monotonic()-start >= args.seconds:
            break
        J = item['ids']
        assert rank(Z[j] for j in J) == len(J)
        ids, H, residual_rank = parity_columns(X, Z, J)
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
            physical_rank = rank(X[i] for i in D)
            histogram[len(D), physical_rank, len(kernel)] += 1
            if len(kernel) >= 2:
                candidates.append({'case': case, 'mandatory_opposite': J, 'circuit_index': number,
                                   'circuit_indices': D, 'shortened_dimension': len(kernel),
                                   'physical_rank': physical_rank,
                                   'kernel_masks': kernel})
        totals['cases'] += 1
        totals['eligible_circuits' if flat_domains is None else 'residual_closed_flats'] += eligible
        totals['shortened_dimension_at_least_two'] += sum(n for (_, _, d), n in histogram.items() if d >= 2)
        records.append({'mandatory_opposite': J, 'eligible_pool_size': len(ids), 'residual_rank': residual_rank,
                        'eligible_circuits': eligible,
                        'shortened_dimension_histogram': [{'support_size': size, 'physical_rank': pr, 'dimension': dim, 'count': n} for (size, pr, dim), n in sorted(histogram.items())]})
    out = {'status': 'COMPLETE_SHORTENED_SUBSPACE_SCREEN' if len(records) == len(cohort) else 'TIME_LIMIT',
           'source_C16_answered': False, 'frozen_sha256': sha(frozen_path), 'records': records,
           'candidates': candidates, 'statistics': dict(totals), 'circuit_size_histogram': dict(circuit_sizes),
           'domain_mode': args.domain_mode,
           'global_closed_flat_count': len(flat_domains) if flat_domains is not None else None,
           'global_closed_flat_size_histogram': dict(Counter(map(len, flat_domains))) if flat_domains is not None else None,
           'elapsed_seconds': time.monotonic()-start,
           'scope': 'Only subspaces supported inside the frozen domains are screened (raw circuits or full source-pool closures, as declared). If candidates is empty, no r>=2 witness subspace has its detector union inside any processed domain, independently of word demands. No all-subspace completeness, source extendibility or source-case completion is claimed.'}
    args.output.write_text(json.dumps(out, indent=2)+'\n')
    print({k: v for k, v in out.items() if k not in ['records', 'candidates']}, flush=True)
    print('CANDIDATES', len(candidates), flush=True)


if __name__ == '__main__':
    main()
