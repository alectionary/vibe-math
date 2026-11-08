#!/usr/bin/env python3
"""Read-only1512-feature translation and branch-coverage review artifact."""
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter
import gzip, hashlib, json, random, sys, time
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import anchor_partner_projection_features as producer
import verify_anchor_partner_projection as consumer
from verify_algebraic_model import physical
from verify_full_partner_anchor_basis_oracle import domain


def sha(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main():
    start = time.monotonic()
    output = ROOT/'coupling-results/anchor-projection-review.json'
    assert not output.exists()
    sources = {p: sha(ROOT/p) for p in (
        'anchor_partner_projection_features.py', 'verify_anchor_partner_projection.py',
        'full_partner_projection_features.py', 'verify_full_partner_projection.py',
        'verify_full_partner_anchor_basis_oracle.py', 'verify_full_partner_basis_oracle.py',
        'verify_projected_profile_moment_rows.py', 'physical-pool-source.json',
        'pools/xcoords.txt', 'pools/zcoords.txt', 'algebraic-results/orbit-rank-profiles.json.gz')}
    rng = random.Random(202610300859)
    feature_checks = target_checks = row_checks = decomposition_checks = 0
    reversed_phase_rejected = incorrect_extra_factor_rejected = 0
    anchors = [0, 80, 272, 512, 704]
    c = [(13*i+7) % 19-9 for i in range(1512)]
    for trial, probability in enumerate((0., .04, .25, .7, 1.)):
        pools = [[[int(rng.random() < probability) for _ in range(16)] for _ in range(45)] for _ in range(2)]
        def moment(side, h, i, j):
            return Q(sum(pools[s][i][t]*pools[s if side == 'S' else 1-s][j][(t+h) % 16]
                         for s in range(2) for t in range(16)), 32)
        owner = [Q(sum(pools[s][j][t] for s in range(2) for t in range(16)), 32) for j in range(45)]
        owner += [moment(side, h, i, j) for side in 'ST' for h in range(9) for i in range(45) for j in range(45)]
        for anchor in anchors:
            literal_sum = [0]*1512
            for s in range(2):
                for rotation in range(16):
                    bits = [pools[s][32][(t-rotation) % 16] for t in range(16)]
                    mask = sum(value << t for t, value in enumerate(bits))
                    selected = [16*j+b for j in range(45) for b in range(16)
                                if pools[1-s][j][(b-rotation) % 16]]
                    chosen = set(selected); qa = int(anchor in chosen)
                    literal = ([1, sum(bits)]
                               +[sum(bits[t]*bits[(t+h) % 16] for t in range(16)) for h in range(1, 9)]
                               +[sum(16*j+b in chosen for b in range(16)) for j in range(45)]
                               +[sum(bits[t]*(16*j+(t+h) % 16 in chosen) for t in range(16)) for j in range(45) for h in range(16)]
                               +[qa]+[qa*v for v in bits]+[qa*int(j in chosen) for j in range(720)])
                    assert tuple(literal) == producer.column_features(mask, selected, anchor)
                    assert literal == consumer.literal_features(mask, selected, anchor)
                    literal_sum = [a+b for a, b in zip(literal_sum, literal)]
                    feature_checks += 1512
                    w = producer.branch_weights(mask, qa, c)
                    assert sum(a*b for a, b in zip(c, literal)) == producer.local_score(mask, qa, c)+sum(w[j] for j in selected)
                    decomposition_checks += 1
            averaged = [Q(v, 32) for v in literal_sum]
            assert averaged == list(producer.moment_target(owner, 32, anchor)) == consumer.target(owner, 32, anchor)
            target_checks += 1512
            row, rhs = producer.moment_row(c, 7, 32, anchor)
            assert (row, rhs) == consumer.row(c, 7, 32, anchor)
            assert sum(value*owner[j] for j, value in row.items())-rhs == sum(a*b for a, b in zip(c, averaged))-7
            row_checks += 1
            a = anchor//16
            wrong_phase = [owner[a]]+[moment('T', (-t) % 16, a, 32) for t in range(16)]
            wrong_phase += [moment('S', (-b) % 16, a, j) for j in range(45) for b in range(16)]
            reversed_phase_rejected += wrong_phase != averaged[775:]
            incorrect_extra_factor_rejected += [16*v for v in averaged[775:]] != averaged[775:]
    assert reversed_phase_rejected and incorrect_extra_factor_rejected
    X, Z, A = physical()
    profiles = json.loads(gzip.decompress((ROOT/'algebraic-results/orbit-rank-profiles.json.gz').read_bytes()))
    profile = next(r for r in profiles['records'] if r['orbit'] == 32)
    forbidden = [r['mask'] for r in profile['minimal_bad_certificates']]
    allowed = [mask for mask in range(65536) if not any(mask & bad == bad for bad in forbidden)]
    assert len(allowed) == 4597
    statuses = Counter(); coverage = []; anchor = 80
    for mask in allowed:
        selected = [512+h for h in range(16) if mask >> h & 1]
        pair = []
        for state in (False, True):
            d = domain(X, Z, selected, anchor, state, 128)
            statuses[d['status']] += 1; pair.append(d['status'])
            if state and d['anchor_signature'].bit_count() > 1:
                assert d['status'] == 'EXCLUDED_SELECTED_MULTIBIT_ANCHOR'
            coverage.append([mask, state, d['status']])
        assert 'ANCHORED_FULL_PARTNER_BASIS_DOMAIN' in pair
    assert len(coverage) == 9194
    assert all(sha(ROOT/p) == digest for p, digest in sources.items())
    result = {'status': 'PASS_READ_ONLY_ANCHORED_PROJECTION_REVIEW', 'source_C16_answered': False,
              'source_hashes': sources, 'review_code_sha256': sha(Path(__file__)),
              'literal_feature_equalities_checked': feature_checks, 'target_coordinates_checked': target_checks,
              'branch_decomposition_checks': decomposition_checks, 'row_and_constant_checks': row_checks,
              'phase_direction_negative_controls_rejected': reversed_phase_rejected,
              'incorrect_factor16_extra_controls_rejected': incorrect_extra_factor_rejected,
              'tested_phase_zero_anchors': anchors, 'allowed_masks': 4597, 'branch_states_checked': 9194,
              'anchor80_branch_status_counts': dict(statuses),
              'branch_coverage_sha256': hashlib.sha256(json.dumps(coverage, separators=(',', ':')).encode()).hexdigest(),
              'normalization': 'Old775 expectations retain16; added737 are p_a,T_t[a,32],S_b[a,j] without16. No anchor-multiplied old correlations are present.',
              'averaging_proof': 'For each physical full frame, each sector orientation and each of16 rotations gives one allowedP and one exact anchor state. The universal support bound holds pointwise, hence after averaging. Fixedphase anchor means all4597 oriented masks are required.',
              'domain_review': 'Selected multibit anchor is impossible. Selected zero anchor is contracted into the zero matroid; selected unit anchor fixes its owner bin. Absence deletes the anchor. Rank deficiency or empty mandatory owner excludes exactly that branch; signed contraction-prefix bounds cover every feasible branch.',
              'matrix_review': 'PASS receipt is bound to bank/current consumer/source hashes/dependency hashes; compiled row and positive exact gap are compared; integer coefficients and rhs are restricted below2^53 before sparse conversion.',
              'limitations': ['Actual cut-bank acceptance still requires full consumer execution.',
                              'Main acceptance is deliberately orbit32-only (512 offsets,4597 masks); generic helper signatures do not certify other orbits.',
                              'Main anchor validation checks phase0 but omits an immediate range assertion; downstream domain/row checks reject invalid indices. Explicit early0<=anchor<720 would improve diagnostics.',
                              'Pure producer helpers coerce selection indices and branch state; acceptance instead checks physical integer indices and exact state coverage.'],
              'elapsed_seconds': time.monotonic()-start}
    output.write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps({k: result[k] for k in ('status', 'literal_feature_equalities_checked', 'branch_states_checked', 'anchor80_branch_status_counts', 'elapsed_seconds')}))


if __name__ == '__main__':
    main()
