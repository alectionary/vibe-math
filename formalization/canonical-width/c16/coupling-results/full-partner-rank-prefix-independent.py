#!/usr/bin/env python3
"""Independent low-pivot physical and exact-target replay of the prefix screen."""
from pathlib import Path
from fractions import Fraction as Q
import gzip, hashlib, json, math, sys, time
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from verify_algebraic_model import physical
from verify_full_partner_projection import point_data
from verify_full_partner_basis_oracle import extend


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    raw = Path(path).read_bytes()
    return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)


start = time.monotonic()
path = ROOT/'coupling-results/full-partner-rank-prefix-audit.json.gz'
output = ROOT/'coupling-results/full-partner-rank-prefix-independent.json'
assert not output.exists()
d = read(path)
assert d['status'] == 'NO_VIOLATED_PREFIX_IN_FINITE_EXACT_SCREEN' and d['orbit'] == 32
assert all(sha(ROOT/name) == digest for name, digest in d['source_hashes'].items())
bank_path = ROOT/'coupling-results/full-partner-projection-wolfe-witness2.json'
receipt_path = ROOT/'coupling-results/full-partner-projection-wolfe-witness2-independent.json'
assert d['bank_sha256'] == sha(bank_path) and d['accepted_cut_receipt_sha256'] == sha(receipt_path)
bank, receipt = read(bank_path), read(receipt_path)
assert receipt['status'] == 'PASS' and receipt['bank_sha256'] == sha(bank_path)
assert d['coefficients'] == bank['cuts'][0]['coefficients']
X, Z, A = physical()
c = d['coefficients']
points = {}
for entry in d['points']:
    ppath = ROOT/'coupling-results'/entry['name']
    assert sha(ppath) == entry['sha256']
    owner, target = point_data(ppath, 32)
    p, q = owner[:45], [x/16 for x in target[55:]]
    den = math.lcm(*(x.denominator for x in p+q))
    pp = [int(x*den) for x in p]
    qq = [[int(q[16*(j//16)+(j%16-h) % 16]*den) for j in range(720)] for h in range(16)]
    points[entry['name']] = den, pp, qq
expected = []
for rec in bank['cuts'][0]['support_records']:
    phases = [h for h in range(16) if rec['mask'] >> h & 1]
    expected.append((rec['mask'], 'joint_zero', tuple(phases), tuple(range(16))))
    expected.extend((rec['mask'], 'singleton_zero', (h,), (h,)) for h in phases)
assert [(r['mask'], r['kind'], tuple(r['selected_X_phases']), tuple(r['tested_anchor_phases'])) for r in d['records']] == expected
summary = {(name, condition): {'checks': 0, 'positive': 0, 'zero': 0, 'maximum': None, 'maximum_location': None}
           for name in points for condition in (0, 1)}
rank_checks = 0
for index, rec in enumerate(d['records']):
    mask = rec['mask']; phases = [h for h in range(16) if mask >> h & 1]
    w = [c[10+j]+sum(c[55+16*j+(b-t) % 16] for t in phases) for j in range(45) for b in range(16)]
    eligible = [j for j in range(720) if all(not (A[512+h] >> j & 1) for h in rec['selected_X_phases'])]
    order = sorted(eligible, key=lambda j: (-w[j], j))
    assert order == rec['ordered_Z_indices'] and len(order) == len(rec['prefix_ranks'])
    rows, ranks = {}, []
    for j in order:
        extend(rows, Z[j]); ranks.append(len(rows))
    assert ranks == rec['prefix_ranks']; rank_checks += len(ranks)
    for name, (den, pp, qq) in points.items():
        for h in rec['tested_anchor_phases']:
            present = absent = 0
            for length, (j, rank) in enumerate(zip(order, ranks), 1):
                present += qq[h][j]; absent += pp[j//16]-qq[h][j]
                for condition, cumulative, norm in ((1, present, pp[32]), (0, absent, den-pp[32])):
                    item = summary[name, condition]; value = cumulative-rank*norm
                    item['checks'] += 1; item['positive'] += value > 0; item['zero'] += value == 0
                    if item['maximum'] is None or value > item['maximum']:
                        item['maximum'] = value
                        item['maximum_location'] = {'record': index, 'anchor_phase': h, 'prefix_length': length}
for saved in d['summary']:
    den = points[saved['point']][0]; actual = summary[saved['point'], saved['condition']]
    actual['maximum'] = str(Q(actual['maximum'], den))
    assert actual == {k: v for k, v in saved.items() if k not in ('point', 'condition')}
assert all(item['positive'] == 0 for item in summary.values())
out = {'status': 'PASS_FINITE_NEGATIVE_PREFIX_SCREEN', 'source_C16_answered': False,
       'certificate_sha256': sha(path), 'consumer_sha256': sha(Path(__file__)),
       'chains_checked': len(d['records']), 'physical_prefix_ranks_checked': rank_checks,
       'exact_inequalities_checked': sum(item['checks'] for item in summary.values()),
       'points': d['points'], 'summary': d['summary'],
       'dependencies': {p: sha(ROOT/p) for p in ('verify_algebraic_model.py', 'verify_full_partner_projection.py', 'verify_full_partner_basis_oracle.py')},
       'elapsed_seconds': time.monotonic()-start,
       'scope': d['scope']}
output.write_text(json.dumps(out, indent=2)+'\n')
print(json.dumps({k: out[k] for k in ('status', 'chains_checked', 'physical_prefix_ranks_checked', 'exact_inequalities_checked', 'elapsed_seconds')}))
