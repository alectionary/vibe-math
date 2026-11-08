#!/usr/bin/env python3
"""Independent exact singleton conditional-base decomposition replay.

The product of a rank127 zero-basis mixture and the unit-bin probability law
is a full128 Z-basis mixture: every unit vector has nonzero anchor evaluation
and is independent of every zero basis. No product expansion is necessary.
"""
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter
import argparse, copy, hashlib, json, sys, time
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from verify_algebraic_model import physical
from verify_full_partner_projection import point_data, move
from verify_full_partner_basis_oracle import dimension


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def verify(bank, point, X, Z, pairing):
    assert bank['point_sha256'] == sha(point), 'point_binding_failed'
    assert bank['anchor_orbit'] == 32 and bank['source_C16_answered'] is False
    assert all(sha(ROOT/name) == digest for name, digest in bank['source_hashes'].items())
    owner, target = point_data(point, 32)
    p = owner[32]
    assert 0 < p < 1 and Q(bank['conditional_probability']) == p
    q = [value/(16*p) for value in target[55:]]
    assert all(0 <= value <= 1 for value in q) and sum(q) == 128
    zero = [j for j in range(720) if not (pairing[512] >> j & 1)]
    units = [j for j in range(720) if pairing[512] >> j & 1]
    assert sum(q[j] for j in zero) == 127 and sum(q[j] for j in units) == 1
    assert dimension(Z[j] for j in zero) == 127
    if bank['status'] == 'EXACT_CONDITIONAL_RANK_CUT_CANDIDATE':
        c = bank['cut']; ids = c['indices']
        assert c['sector'] == 'T' and c['anchor_orbit'] == 32 and c['mandatory_index'] is None
        assert ids == sorted(set(ids)) and ids and all(type(j) is int and 0 <= j < 720 for j in ids)
        rank = dimension(Z[j] for j in ids)
        assert rank == c['bound']
        violation = (sum(q[j] for j in ids)-rank)*p
        assert violation == Q(c['exact_violation']) > 0
        return {'status': 'PASS_EXACT_CONDITIONAL_RANK_CUT', 'cuts_checked': 1,
                'rank': rank, 'exact_violation': str(violation), 'cut': c}
    assert bank['status'] in ('EXACT_SINGLETON_CONDITIONAL_BASIS_MIXTURE_CANDIDATE',
                              'EXACT_SINGLETON_RANK_LATTICE_CERTIFICATE_CANDIDATE')
    assert list(map(Q, bank['conditional_target'])) == q, 'wrong_conditional_target'
    marginal, mass = [Q(0)]*720, Q(0)
    seen = set()
    for record in bank['zero_bases']:
        ids, weight = record['indices'], Q(record['weight'])
        assert weight > 0, 'positive_zero_basis_weight_required'
        assert ids == sorted(set(ids)) and len(ids) == 127, '127_distinct_zero_vectors_required'
        assert all(type(j) is int and 0 <= j < 720 and not (pairing[512] >> j & 1) for j in ids)
        assert dimension(Z[j] for j in ids) == 127, 'zero_basis_rank_failed'
        assert tuple(ids) not in seen
        seen.add(tuple(ids)); mass += weight
        for j in ids:
            marginal[j] += weight
    assert mass == 1, 'zero_basis_weight_mass_failed'
    unit_law = {}
    for record in bank['unit_probabilities']:
        j, weight = record['index'], Q(record['probability'])
        assert type(j) is int and 0 <= j < 720 and pairing[512] >> j & 1
        assert j not in unit_law and weight > 0
        unit_law[j] = weight; marginal[j] = weight
    assert sum(unit_law.values()) == 1, 'unit_probability_mass_failed'
    # These evaluations prove each product pair has full rank128.
    assert all((X[512] & Z[j]).bit_count() % 2 == 0 for j in zero)
    assert all((X[512] & Z[j]).bit_count() % 2 == 1 for j in unit_law)
    if bank['status'] == 'EXACT_SINGLETON_RANK_LATTICE_CERTIFICATE_CANDIDATE':
        denominator = int(bank['lattice_denominator'])
        assert denominator > 0 and all((value*denominator).denominator == 1 for value in q)
        assert all(marginal[j] == q[j] for j in units)
        error = sum(max(Q(0), wanted-found) for wanted, found in zip(q, marginal))
        assert error == Q(bank['exact_positive_error'])
        assert denominator*error == Q(bank['lattice_scaled_error']) < 1
        return {'status': 'PASS_ALL_SINGLETON_CONDITIONAL_Z_RANK_INEQUALITIES',
                'zero_bases_physically_checked': len(seen), 'zero_basis_rank': 127,
                'unit_probability_support': len(unit_law), 'implicit_full128_basis_components': len(seen)*len(unit_law),
                'lattice_denominator': str(denominator), 'exact_positive_marginal_error': str(error),
                'exact_lattice_scaled_error': str(denominator*error),
                'approximate_lattice_scaled_error': float(denominator*error),
                'exact_target_mixture_recovered': False,
                'proof': 'For every physical Z subset K, q(K)<=x(K)+positive_error<=rank(K)+positive_error<rank(K)+1/D. Since D*q(K) and D*rank(K) are integers, q(K)<=rank(K). The rational x is a physically verified full128-basis mixture, factored as zero basis times unit probability law.',
                'consequence': 'All present-conditioned physical Z-rank inequalities hold for orbit32, hence all16 phases by checked rotation. No exact decomposition of q itself or joint-profile/full-frame membership is asserted.'}
    assert marginal == q, 'exact720_conditional_marginals_failed'
    return {'status': 'PASS_EXACT_SINGLETON_CONDITIONAL_MATROID_MEMBERSHIP',
            'zero_bases_physically_checked': len(seen), 'zero_basis_rank': 127,
            'unit_probability_support': len(unit_law), 'implicit_full128_basis_components': len(seen)*len(unit_law),
            'exact_zero_mixture_mass': str(mass), 'exact_unit_probability_mass': '1',
            'exact_conditional_marginals_checked': 720,
            'consequence': 'All physical Z-matroid rank inequalities hold for the present-conditioned T law of orbit32, and hence all16 phases by checked rotation. This is a singleton conditional law, not a joint orbit32 profile distribution or a full source frame.'}


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--certificate', type=Path, required=True)
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--negative-controls', action='store_true')
    args = ap.parse_args()
    assert not args.output.exists()
    start = time.monotonic()
    bank = json.loads(args.certificate.read_text())
    fp = args.certificate.with_suffix('.frozen.json')
    assert bank['frozen_sha256'] == sha(fp)
    X, Z, A = physical()
    assert dimension(X) == dimension(Z) == 128
    assert all((A[i] >> j & 1) == (A[j] >> i & 1) == (A[move(i, 1)] >> move(j, 1) & 1)
               for i in range(720) for j in range(720))
    # Write the three graph checks explicitly to avoid assuming pool symmetries.
    graph_ranks = [dimension([x | z << 128 for x, z in zip(X, Z)])]
    graph_ranks.extend(dimension([U[i] | U[move(i, 1)] << 128 for i in range(720)]) for U in (X, Z))
    assert graph_ranks == [128, 128, 128]
    result = verify(bank, args.point, X, Z, A)
    rejections = []
    if args.negative_controls and result['status'] in ('PASS_EXACT_SINGLETON_CONDITIONAL_MATROID_MEMBERSHIP',
                                                      'PASS_ALL_SINGLETON_CONDITIONAL_Z_RANK_INEQUALITIES'):
        mutants = []
        bad = copy.deepcopy(bank); bad['point_sha256'] = '0'*64; mutants.append(('point_binding', bad))
        bad = copy.deepcopy(bank); bad['zero_bases'][0]['weight'] = '-1'; mutants.append(('negative_weight', bad))
        bad = copy.deepcopy(bank); bad['zero_bases'][0]['indices'].pop(); mutants.append(('basis_cardinality', bad))
        bad = copy.deepcopy(bank); bad['unit_probabilities'][0]['probability'] = '2'; mutants.append(('unit_mass', bad))
        if 'exact_positive_error' in bank:
            bad = copy.deepcopy(bank); bad['exact_positive_error'] = '0'; mutants.append(('forged_lattice_error', bad))
        for name, bad in mutants:
            try:
                verify(bad, args.point, X, Z, A)
            except (AssertionError, ValueError):
                rejections.append(name)
            else:
                raise AssertionError('malformed_certificate_accepted_'+name)
    result.update(source_C16_answered=False, physical_full_frame=False,
                  certificate_sha256=sha(args.certificate), point_sha256=sha(args.point),
                  consumer_sha256=sha(Path(__file__)), symmetry_graph_ranks=graph_ranks,
                  negative_controls_rejected=rejections,
                  dependencies={p: sha(ROOT/p) for p in ('verify_algebraic_model.py', 'verify_full_partner_projection.py', 'verify_full_partner_basis_oracle.py')},
                  elapsed_seconds=time.monotonic()-start)
    args.output.write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps(result))


if __name__ == '__main__':
    main()
