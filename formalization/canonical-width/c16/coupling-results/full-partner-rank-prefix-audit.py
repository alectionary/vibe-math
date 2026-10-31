#!/usr/bin/env python3
"""Exact finite rank-prefix attribution screen for the accepted Wolfe form."""
from pathlib import Path
from fractions import Fraction as Q
import gzip, hashlib, json, math, sys, time
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from full_partner_projection_features import candidate_weights, moment_target
from verify_projected_profile_moment_rows import point_vector
from weighted_matroid_separator import insert


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def load(path):
    raw = Path(path).read_bytes()
    return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)


def main():
    start = time.monotonic()
    output = ROOT/'coupling-results/full-partner-rank-prefix-audit.json.gz'
    assert not output.exists()
    bank_path = ROOT/'coupling-results/full-partner-projection-wolfe-witness2.json'
    receipt_path = ROOT/'coupling-results/full-partner-projection-wolfe-witness2-independent.json'
    bank, receipt = load(bank_path), load(receipt_path)
    assert receipt['status'] == 'PASS' and receipt['bank_sha256'] == sha(bank_path)
    coefficients = bank['cuts'][0]['coefficients']
    X, Z = [[int(v, 16) for v in (ROOT/f'pools/{side}coords.txt').read_text().split()] for side in 'xz']
    points = []
    for name, acceptance in [('witness2-rational.json.gz', 'ACCEPTED_EXACT_LISTED_RELAXATION'),
                             ('basis-necessary3-rational.json.gz', 'UNACCEPTED_RECOVERY_FAILED_PSD'),
                             ('basis-witness4-rational.json.gz', 'ACCEPTED_EXACT_LISTED_RELAXATION')]:
        path = ROOT/'coupling-results'/name
        owner = point_vector(path)
        p = owner[:45]
        target = moment_target(owner)
        q = [v/16 for v in target[55:]]
        denominator = math.lcm(*(v.denominator for v in p+q))
        pp = [int(v*denominator) for v in p]
        qq = [[int(q[16*j+(b-h) % 16]*denominator) for j in range(45) for b in range(16)] for h in range(16)]
        assert sum(pp)*16 == 128*denominator
        assert all(sum(row) == 128*pp[32] for row in qq)
        points.append({'name': name, 'acceptance': acceptance, 'sha256': sha(path),
                       'denominator': denominator, 'p': pp, 'q': qq})
    summaries = {(p['name'], condition): {'checks': 0, 'positive': 0, 'zero': 0, 'maximum': None,
                                          'maximum_location': None} for p in points for condition in (0, 1)}
    records = []
    for item in bank['cuts'][0]['support_records']:
        mask = item['mask']
        phases = [h for h in range(16) if mask >> h & 1]
        weights = candidate_weights(mask, coefficients)
        families = [('joint_zero', phases, list(range(16)))]+[
            ('singleton_zero', [h], [h]) for h in phases]
        for kind, selected, anchors in families:
            pool = [j for j, z in enumerate(Z) if all(not ((X[512+h] & z).bit_count() % 2) for h in selected)]
            order = sorted(pool, key=lambda j: (-weights[j], j))
            pivots, ranks = {}, []
            for j in order:
                insert(pivots, Z[j]); ranks.append(len(pivots))
            record = {'mask': mask, 'kind': kind, 'selected_X_phases': selected,
                      'tested_anchor_phases': anchors, 'ordered_Z_indices': order, 'prefix_ranks': ranks}
            records.append(record)
            for p in points:
                den, pp, qq = p['denominator'], p['p'], p['q']
                for anchor in anchors:
                    for condition in (0, 1):
                        summary = summaries[p['name'], condition]
                        cumulative = 0
                        norm = pp[32] if condition else den-pp[32]
                        for length, (j, rank) in enumerate(zip(order, ranks), 1):
                            cumulative += qq[anchor][j] if condition else pp[j//16]-qq[anchor][j]
                            value = cumulative-rank*norm
                            summary['checks'] += 1
                            summary['positive'] += value > 0
                            summary['zero'] += value == 0
                            if summary['maximum'] is None or value > summary['maximum']:
                                summary['maximum'] = value
                                summary['maximum_location'] = {'record': len(records)-1, 'anchor_phase': anchor, 'prefix_length': length}
    summary_rows = []
    for p in points:
        for condition in (0, 1):
            summary = summaries[p['name'], condition]
            summary['maximum'] = str(Q(summary['maximum'], p['denominator']))
            summary_rows.append({'point': p['name'], 'condition': condition, **summary})
    assert not any(r['positive'] for r in summary_rows), 'positive_prefix_requires_export_before_negative_status'
    out = {'status': 'NO_VIOLATED_PREFIX_IN_FINITE_EXACT_SCREEN', 'source_C16_answered': False,
           'bank_sha256': sha(bank_path), 'accepted_cut_receipt_sha256': sha(receipt_path),
           'coefficients': coefficients, 'orbit': 32,
           'points': [{k: v for k, v in p.items() if k not in ('p', 'q', 'denominator')} for p in points],
           'records': records, 'summary': summary_rows,
           'source_hashes': {name: sha(ROOT/name) for name in ('physical-pool-source.json', 'pools/xcoords.txt', 'pools/zcoords.txt')},
           'producer_sha256': sha(Path(__file__)), 'elapsed_seconds': time.monotonic()-start,
           'scope': 'All full-mask zero-pool weight prefixes tested against all16 orbit32 anchor phases, plus selected singleton-anchor zero-pool prefixes; both present and absent conditioning. Finite negative screen only, not completeness of conditional rank inequalities. necessary3 remains an unaccepted PSD-failed candidate.'}
    output.write_bytes(gzip.compress((json.dumps(out, separators=(',', ':'))+'\n').encode(), mtime=0))
    print(json.dumps({'status': out['status'], 'chains': len(records), 'exact_inequalities': sum(r['checks'] for r in summary_rows),
                      'sha256': sha(output), 'elapsed_seconds': out['elapsed_seconds']}))


if __name__ == '__main__':
    main()
