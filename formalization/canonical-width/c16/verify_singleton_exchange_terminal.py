#!/usr/bin/env python3
"""Direct exact terminal-mixture replay, independent of exchange discovery.

The terminal certificate suffices: no search path or convergence claim is used.
The rank routine uses low pivots; the discovery producer uses high pivots.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse, copy, hashlib, json, time
from verify_algebraic_model import physical
from verify_full_partner_projection import point_data

ROOT = Path(__file__).resolve().parent

def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def rank(vectors):
    rows = {}
    for value in vectors:
        while value:
            pivot = value & -value
            if pivot in rows:
                value ^= rows[pivot]
            else:
                rows[pivot] = value
                break
    return len(rows)

def replay(bank, point, X, Z):
    assert bank['status'] == 'EXACT_SINGLETON_CONDITIONAL_BASIS_MIXTURE_CANDIDATE'
    assert bank['point_sha256'] == sha(point)
    assert bank['source_C16_answered'] is False and bank['physical_full_frame'] is False
    for name, digest in bank['source_hashes'].items():
        assert sha(ROOT/name) == digest
    orbit = bank['anchor_orbit']
    assert type(orbit) is int and 0 <= orbit < 45
    owner, target = point_data(point, orbit)
    p = owner[orbit]
    assert 0 < p < 1 and Q(bank['conditional_probability']) == p
    q = [value/(16*p) for value in target[55:]]
    assert list(map(Q, bank['conditional_target'])) == q
    assert all(0 <= value <= 1 for value in q) and sum(q) == 128
    anchor = X[16*orbit]
    signature = [(anchor & value).bit_count() % 2 for value in Z]
    assert rank(Z[j] for j in range(720) if not signature[j]) == 127
    assert sum(q[j] for j in range(720) if not signature[j]) == 127
    assert sum(q[j] for j in range(720) if signature[j]) == 1
    marginal = [Q(0)]*720
    seen, mass = set(), Q(0)
    for record in bank['zero_bases']:
        indices, weight = record['indices'], Q(record['weight'])
        assert indices == sorted(set(indices)) and len(indices) == 127
        assert all(type(j) is int and 0 <= j < 720 and signature[j] == 0 for j in indices)
        assert tuple(indices) not in seen and weight > 0
        assert rank(Z[j] for j in indices) == 127
        seen.add(tuple(indices)); mass += weight
        for j in indices:
            marginal[j] += weight
    assert mass == 1
    unit_seen, unit_mass = set(), Q(0)
    for record in bank['unit_probabilities']:
        j, weight = record['index'], Q(record['probability'])
        assert type(j) is int and 0 <= j < 720 and signature[j] == 1
        assert j not in unit_seen and 0 < weight <= 1
        unit_seen.add(j); unit_mass += weight; marginal[j] = weight
    assert unit_mass == 1 and marginal == q
    return {'zero_bases': len(seen), 'unit_probabilities': len(unit_seen),
            'implicit_full_basis_components': len(seen)*len(unit_seen),
            'exact_marginals': 720, 'anchor_orbit': orbit}

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--certificate', type=Path, required=True)
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    assert not args.output.exists()
    started = time.monotonic()
    bank = json.loads(args.certificate.read_text())
    assert bank['frozen_sha256'] == sha(args.certificate.with_suffix('.frozen.json'))
    X, Z, _ = physical()
    assert rank(X) == rank(Z) == 128
    result = replay(bank, args.point, X, Z)
    mutations = []
    bad = copy.deepcopy(bank); bad['zero_bases'][0]['weight'] = '-1'; mutations.append(('negative_basis_weight', bad))
    bad = copy.deepcopy(bank); bad['zero_bases'][0]['indices'].pop(); mutations.append(('rank_cardinality', bad))
    bad = copy.deepcopy(bank); bad['unit_probabilities'][0]['probability'] = '-1'; mutations.append(('negative_unit_probability', bad))
    bad = copy.deepcopy(bank); bad['conditional_target'][0] = str(Q(bad['conditional_target'][0])+1); mutations.append(('changed_exact_target', bad))
    bad = copy.deepcopy(bank); bad['point_sha256'] = '0'*64; mutations.append(('wrong_point', bad))
    rejected = []
    for name, bad in mutations:
        try:
            replay(bad, args.point, X, Z)
        except (AssertionError, ValueError):
            rejected.append(name)
        else:
            raise AssertionError('corruption accepted: '+name)
    result.update(status='PASS_DIRECT_TERMINAL_SINGLETON_BASIS_MIXTURE_REVIEW',
                  source_C16_answered=False, physical_full_frame=False,
                  certificate_sha256=sha(args.certificate), point_sha256=sha(args.point),
                  consumer_sha256=sha(Path(__file__)), negative_controls_rejected=rejected,
                  source_hashes={name:sha(ROOT/name) for name in
                    ['verify_algebraic_model.py','verify_full_partner_projection.py',
                     'physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt']},
                  scope='Direct phase-zero singleton conditional law only. Product weights of each rank127 zero basis and each unit vector give full128 bases. No search trajectory, global termination, joint-profile law or source-frame claim is used.',
                  elapsed_seconds=time.monotonic()-started)
    args.output.write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps(result))

if __name__ == '__main__':
    main()
