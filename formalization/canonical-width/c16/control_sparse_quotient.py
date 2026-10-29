#!/usr/bin/env python3
"""Check certificate soundness AND completeness of the sparse<=3 discovery gate."""
from pathlib import Path
import argparse
import itertools
import json
import random
import hashlib
from sparse_quotient_oracle import SparseQuotientOracle
from verify_sparse_quotient import SparseQuotientConsumer


def rank(values):
    rows = {}
    for v in values:
        while v:
            p = v.bit_length()-1
            if p not in rows:
                rows[p] = v
                break
            v ^= rows[p]
    return len(rows)


def brute(X, Z, N, side, ids, order):
    V, opposite = (X, Z) if side == 0 else (Z, X)
    residue = SparseQuotientConsumer.quotient(opposite[j] for j in ids)
    labels = {0, *(residue(z) for z in opposite)}
    short = [{0}]
    for q in range(1, order+1):
        short.append({a ^ b for a in short[-1] for b in labels})
    for w in range(1, 1 << N):
        target = residue(w)
        if not target:
            continue
        size = sum(all((x & opposite[j]).bit_count() % 2 == 0 for j in ids)
                   and (x & w).bit_count() % 2 for x in V)
        if size <= order and target not in short[size]:
            return True
    return False


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--library', type=Path, required=True)
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args()
    rng = random.Random(202610291700)
    checks = certificates = positive_frames = 0
    targeted = []
    for N in [4, 6]:
        X = [1, 3, 5, 9, 11, 13, 15] + [1 << k for k in range(4, N)]
        Z = [1 << k for k in range(N)]
        oracle = SparseQuotientOracle(X, Z, a.library, N)
        consumer = SparseQuotientConsumer(X, Z, N)
        for ids in [[], list(range(4, N))]:
            assert not oracle.probe(0, ids, 2)
            rows = oracle.probe(0, ids, 3)
            assert rows and all(r['order'] == 3 for r in rows)
            for row in rows:
                consumer.check(row, literal=True)
            targeted.append({'dimension': N, 'mandatory_opposite': ids,
                             'order2_rejects': False, 'order3_rejects': True, 'certificates': rows})
        oracle.close()
        enlarged = sorted(set(X) | set(Z))
        oracle = SparseQuotientOracle(enlarged, Z, a.library, N)
        for ids in [[], list(range(4, N))]:
            assert not oracle.probe(0, ids, 3)
            positive_frames += 1
        oracle.close()
    for N in [4, 6]:
        points = list(range(1, 1 << N))
        for configuration in range(30):
            units = {1 << k for k in range(N)}
            X = sorted(units | set(rng.sample(points, rng.randint(N, min(len(points), 2*N+4)))))
            Z = sorted(units | set(rng.sample(points, rng.randint(N, min(len(points), 2*N+4)))))
            oracle = SparseQuotientOracle(X, Z, a.library, N)
            consumer = SparseQuotientConsumer(X, Z, N)
            for trial in range(12):
                side = trial % 2
                opposite = (Z, X)[side]
                ids = rng.sample(range(len(opposite)), rng.randrange(min(N, 4)+1))
                if rank(opposite[i] for i in ids) != len(ids):
                    continue
                for order in (1, 2, 3):
                    rows = oracle.probe(side, ids, order)
                    assert bool(rows) == brute(X, Z, N, side, ids, order), (N, X, Z, side, ids, order)
                    checks += 1
                    truth = [x in units for x in X] + [z in units for z in Z]
                    for row in rows:
                        consumer.check(row, literal=True)
                        assert any(truth[abs(lit)-1] == (lit > 0) for lit in row['clause'])
                        certificates += 1
            oracle.close()
    out = {'status': 'PASS', 'source_C16_answered': False,
           'exhaustive_all_witness_vectors_per_query': True,
           'native_vs_brute_existence_checks': checks,
           'independent_literal_certificate_checks': certificates,
           'known_identity_frames_retained': True,
           'targeted_positive_frame_controls': positive_frames,
           'strict_order3_controls': targeted,
           'native_library_sha256': hashlib.sha256(a.library.read_bytes()).hexdigest(),
           'scope': 'Sampled small pools/mandatory subsets; for each, all binary witness vectors are exhaustively compared. Explicit controls distinguish order3 from complete order2. No original source frame is constructed.'}
    a.output.write_text(json.dumps(out, indent=2)+'\n')
    print({k: v for k, v in out.items() if k != 'strict_order3_controls'}, flush=True)


if __name__ == '__main__':
    main()
