#!/usr/bin/env python3
"""Frozen matched source comparison: old fundamental, complete order2, order3."""
from pathlib import Path
import argparse
import collections
import hashlib
import json
import random
import time
import datetime
from verify_algebraic_model import physical
from conditional_word_oracle import WordNativeConditionalSpan
from sparse_quotient_oracle import SparseQuotientOracle
from verify_sparse_quotient import SparseQuotientConsumer

ROOT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--library', type=Path, required=True)
    p.add_argument('--old-library', type=Path, required=True)
    p.add_argument('--generated', type=int, default=512)
    p.add_argument('--seconds', type=float, default=600)
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args()
    X, Z, A = physical()
    prior = ROOT/'strategy-results/word-followup-case-02.json'
    cover_path = ROOT/'strategy-results/final-cover.json'
    previous = json.loads(prior.read_text())
    cases = json.loads(cover_path.read_text())['cases']
    cohort = [{'cohort': 'retrospective', 'index': k, 'pairs': row['pairs']}
              for k, row in enumerate(previous['records'])]
    rng = random.Random(202610291700)
    allbits = (1 << 720)-1
    for k in range(a.generated):
        case = cases[k % len(cases)]
        pairs = [[case['X_index'], case['Z_index']]]
        activeX = allbits & ~A[pairs[0][1]]
        activeZ = allbits & ~A[pairs[0][0]]
        target = 2+k % 8
        for step in range(1, target):
            candidates = []
            total = 0
            for i in range(720):
                if activeX >> i & 1:
                    mask = A[i] & activeZ
                    degree = mask.bit_count()
                    if degree:
                        total += degree
                        candidates.append((i, mask, degree))
            if not total:
                break
            pick = rng.randrange(total)
            for i, mask, degree in candidates:
                if pick >= degree:
                    pick -= degree
                    continue
                while pick:
                    mask &= mask-1
                    pick -= 1
                j = (mask & -mask).bit_length()-1
                pairs.append([i, j])
                activeX &= ~A[j]
                activeZ &= ~A[i]
                break
        cohort.append({'cohort': 'generated', 'index': k, 'target_pairs': target, 'pairs': pairs})
    for row in cohort:
        pairs = row['pairs']
        for k, (i, j) in enumerate(pairs):
            assert A[i] >> j & 1
            for ii, jj in pairs[:k]:
                assert i != ii and j != jj and not A[i] >> jj & 1 and not A[ii] >> j & 1
    cohort_path = a.output.with_name(a.output.stem+'-cohort.json')
    cohort_path.write_text(json.dumps({'status': 'FROZEN_BEFORE_COMPARISON', 'records': cohort}, indent=2)+'\n')
    frozen = {'frozen_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
              'source_C16_answered': False, 'cohort_file': cohort_path.name,
              'cohort_sha256': sha(cohort_path), 'retrospective_metadata_sha256': sha(prior),
              'cover_sha256': sha(cover_path), 'generated_seed': 202610291700,
              'retrospective_cases': len(previous['records']), 'generated_cases': a.generated,
              'seconds': a.seconds, 'native_library_sha256': sha(a.library),
              'old_native_library_sha256': sha(a.old_library),
              'source_sha256': {name: sha(ROOT/name) for name in
                                ['sparse_quotient_gate.py', 'sparse_quotient_native.cpp',
                                 'sparse_quotient_oracle.py', 'verify_sparse_quotient.py']},
              'comparison': 'Same physical partial pairs: old fundamental-only negative clauses; complete sparse order<=2; complete sparse order<=3. A source predicate improvement is not a full case exclusion.'}
    a.output.with_name(a.output.stem+'-frozen.json').write_text(json.dumps(frozen, indent=2)+'\n')
    native = SparseQuotientOracle(X, Z, a.library)
    old = WordNativeConditionalSpan(X, Z, a.old_library)
    consumer = SparseQuotientConsumer(X, Z)
    records = []
    counts = collections.Counter()
    new_certificates = []
    elapsed = collections.Counter()
    start = time.monotonic()
    for k, case in enumerate(cohort):
        if time.monotonic()-start >= a.seconds:
            break
        pairs = case['pairs']
        values = [0]*1440
        for i, j in pairs:
            values[i] = values[720+j] = 1
        t = time.monotonic()
        old_rows = old.check(values)
        old_reject = any(all(lit < 0 for lit in r['clause']) for r in old_rows)
        elapsed['old'] += time.monotonic()-t
        t = time.monotonic()
        rows2 = []
        for side in (0, 1):
            rows2 += native.probe(side, [pair[1-side] for pair in pairs], 2, cap=1)
        elapsed['complete2'] += time.monotonic()-t
        t = time.monotonic()
        rows3 = []
        for side in (0, 1):
            rows3 += native.probe(side, [pair[1-side] for pair in pairs], 3, cap=1)
        elapsed['complete3'] += time.monotonic()-t
        assert not rows2 or rows3
        prefix = case['cohort']
        counts[prefix+'_checked'] += 1
        for name, value in [('old_reject', old_reject), ('complete2_reject', bool(rows2)),
                            ('complete3_reject', bool(rows3)), ('new2_over_old', bool(rows2) and not old_reject),
                            ('strict3_over_complete2', bool(rows3) and not rows2)]:
            counts[prefix+'_'+name] += value
        fresh = rows3 if rows3 and not rows2 else rows2 if rows2 and not old_reject else []
        indices = []
        for row in fresh:
            consumer.check(row)
            indices.append(len(new_certificates))
            new_certificates.append(row)
        records.append({'cohort': prefix, 'index': case['index'], 'old_reject': old_reject,
                        'complete2_reject': bool(rows2), 'complete3_reject': bool(rows3),
                        'new_certificate_indices': indices})
        if k % 100 == 0:
            print('SPARSE GATE', k, dict(counts), 'seconds', round(time.monotonic()-start, 2), flush=True)
    old.close()
    native.close()
    out = {'status': 'BOUNDED_COMPARISON_COMPLETE' if len(records) == len(cohort) else 'WALL_LIMIT',
           'source_C16_answered': False, 'frozen_file': a.output.stem+'-frozen.json',
           'cohort_sha256': sha(cohort_path), 'counts': dict(counts), 'seconds_by_method': dict(elapsed),
           'elapsed_seconds': time.monotonic()-start, 'records': records,
           'new_certificates': new_certificates,
           'scope': 'Matched predicates on frozen partial source matchings. New certificates are independently checked here; no full-frame class or cover is excluded by this comparison alone.'}
    a.output.write_text(json.dumps(out, indent=2)+'\n')
    print('SPARSE GATE END', out['status'], out['counts'], out['seconds_by_method'], flush=True)


if __name__ == '__main__':
    main()
