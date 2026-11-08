#!/usr/bin/env python3
"""Independent exact membership consumer for a local full-partner projection.

No numerical or producer recovery/feature routine is imported for acceptance.
Every positive column is reconstructed physically. This is membership in a
necessary convex relaxation, never a full frame or resolution of source C16.
"""
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter
import argparse, copy, gzip, hashlib, json, time
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension, rebuild_domain
from verify_full_partner_projection import literal_features, point_data, translation_controls, move

ROOT = Path(__file__).resolve().parent
LAYOUT = '1,k,C1..C8,n[45],d[45,16].ravel(C)'
SOURCES = ('physical-pool-source.json', 'pools/xcoords.txt', 'pools/zcoords.txt',
           'algebraic-results/orbit-rank-profiles.json.gz',
           'algebraic-results/hulls-16-rank.json.gz')


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    raw = Path(path).read_bytes()
    return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)


def checked_physical_source():
    X, Z, A = physical()
    assert dimension(X) == dimension(Z) == 128
    for side, pool in (('x', X), ('z', Z)):
        assert pool == [int(v, 16) for v in (ROOT/f'pools/{side}coords.txt').read_text().split()]
    graph_ranks = [dimension([x | z << 128 for x, z in zip(X, Z)]),
                   dimension([X[i] | X[move(i, 1)] << 128 for i in range(720)]),
                   dimension([Z[i] | Z[move(i, 1)] << 128 for i in range(720)])]
    assert graph_ranks == [128]*3
    assert all((A[i] >> j & 1) == (A[j] >> i & 1) == (A[move(i, 1)] >> move(j, 1) & 1)
               for i in range(720) for j in range(720))
    profiles = read(ROOT/'algebraic-results/orbit-rank-profiles.json.gz')
    row = next(r for r in profiles['records'] if r['orbit'] == 32)
    phase = X[512:528]
    assert dimension(phase) == 16
    signatures = [sum(((x & z).bit_count() % 2) << h for h, x in enumerate(phase)) for z in Z]
    forbidden = []
    for item in row['minimal_bad_certificates']:
        mask, witness = item['mask'], int(item['annihilator_hex'], 16)
        assert 0 < mask < 65536 and 0 < witness < 1 << 128
        if item['kind'] == 'zero_rank':
            selected = [phase[h] for h in range(16) if mask >> h & 1]
            assert dimension(selected+[witness]) == len(selected)+1
            assert all(signature & mask for z, signature in zip(Z, signatures) if (z & witness).bit_count() % 2)
        else:
            assert item['kind'] == 'missing_private'
            assert all((signature & mask).bit_count() > 1 for z, signature in zip(Z, signatures) if (z & witness).bit_count() % 2)
        forbidden.append(mask)
    return X, Z, forbidden, {'symmetry_graph_ranks': graph_ranks,
                              'physical_pairing_symmetry_checks': 2*720*720,
                              'profile_obstructions_physically_checked': len(forbidden)}


def check_columns(columns, target, X, Z, forbidden):
    assert columns and len(target) == 775
    total = [Q(0)]*775
    mass = Q(0)
    domains, mask_counts = {}, Counter()
    for item in columns:
        weight = Q(item['weight'])
        assert weight > 0, 'positive_weights_required'
        mask, chosen = item['mask'], item['selected_Z_indices']
        assert type(mask) is int and 0 <= mask < 65536
        assert not any(mask & bad == bad for bad in forbidden), 'forbidden_profile_mask'
        assert len(chosen) == len(set(chosen)) == 128, '128_distinct_physical_Z_required'
        assert all(type(j) is int and 0 <= j < 720 for j in chosen)
        assert dimension(Z[j] for j in chosen) == 128, 'Z_full_rank_required'
        if mask not in domains:
            selected = [512+h for h in range(16) if mask >> h & 1]
            domains[mask] = rebuild_domain(X, Z, selected, 128)
        domain = domains[mask]
        assert domain['status'] == 'FULL_PARTNER_BASIS_DOMAIN', 'physical_mask_domain_failed'
        counts = Counter(domain['signatures'][j] for j in chosen)
        expected = Counter({0: 128-mask.bit_count(), **{1 << h: 1 for h in range(mask.bit_count())}})
        assert counts == expected, 'unit_owner_and_zero_partition_failed'
        features = literal_features(mask, chosen)
        assert features == item['features'], 'literal_feature_mismatch'
        assert len(features) == 775 and features[0] == 1
        total = [a+weight*v for a, v in zip(total, features)]
        mass += weight
        mask_counts[mask] += 1
    assert mass == 1, 'exact_weight_mass_not_one'
    assert total == list(target), 'exact775_target_equations_failed'
    return {'positive_columns_physically_checked': len(columns), 'distinct_masks_checked': len(domains),
            'exact_weight_sum': str(mass), 'exact_feature_equations_checked': 775,
            'mask_column_counts': {str(k): v for k, v in sorted(mask_counts.items())}}


def verify_binding(bank, point):
    assert bank['status'] == 'EXACT_NONNEGATIVE_MIXTURE_RECOVERED_REQUIRES_PHYSICAL_REPLAY'
    assert bank['orbit'] == 32 and bank['feature_layout'] == LAYOUT
    assert bank['source_C16_answered'] is False and bank['physical_full_frame'] is False
    assert bank['point_sha256'] == sha(point), 'point_binding_failed'
    assert set(SOURCES) <= set(bank['source_hashes'])
    assert all(sha(ROOT/name) == digest for name, digest in bank['source_hashes'].items())
    _, target = point_data(point, 32)
    assert list(map(Q, bank['target'])) == target, 'saved_target_mismatch'
    assert bank['positive_columns'] == len(bank['columns'])
    return target


def controls(X, Z, forbidden, archive):
    """Synthetic target controls: never claimed to match witness2."""
    import numpy as np
    from recover_full_partner_mixture import exact_recover
    data = np.load(archive)
    ids = [0, len(data['features'])//2, len(data['features'])-1]
    columns = []
    for index, weight in zip(ids, (Q(1, 2), Q(1, 3), Q(1, 6))):
        chosen = list(map(int, data['selected_Z_indices'][index]))
        mask = int(data['masks'][index])
        columns.append({'weight': str(weight), 'mask': mask, 'selected_Z_indices': chosen,
                        'features': literal_features(mask, chosen)})
    target = [sum(Q(c['weight'])*c['features'][j] for c in columns) for j in range(775)]
    base = check_columns(columns, target, X, Z, forbidden)
    matrix = np.asarray([c['features'] for c in columns], dtype=np.int64).T
    recovery, weights = exact_recover(matrix, target, np.asarray([.5, 1/3, 1/6]))
    assert weights is not None and all(sum(w*int(matrix[j, k]) for k, w in enumerate(weights)) == target[j] for j in range(775))
    recovered = [{**c, 'weight': str(w)} for c, w in zip(columns, weights) if w > 0]
    check_columns(recovered, target, X, Z, forbidden)
    outside = list(target); outside[0] += Q(1, 7)
    failed, _ = exact_recover(matrix, outside, np.asarray([.5, 1/3, 1/6]))
    assert failed['status'] == 'TARGET_OUTSIDE_SELECTED_COLUMN_SPAN'
    rejected = []
    mutations = []
    bad = copy.deepcopy(columns); bad[0]['weight'] = '-1/2'; mutations.append(('negative_weight', bad, target))
    bad = copy.deepcopy(columns); bad[0]['weight'] = '1'; mutations.append(('wrong_mass', bad, target))
    bad = copy.deepcopy(columns); bad[0]['features'][5] += 1; mutations.append(('forged_feature', bad, target))
    bad = copy.deepcopy(columns); bad[0]['selected_Z_indices'][0] = bad[0]['selected_Z_indices'][1]; mutations.append(('duplicate_Z', bad, target))
    bad = copy.deepcopy(columns); bad[0]['mask'] = forbidden[0]; mutations.append(('forbidden_mask', bad, target))
    bad_target = list(target); bad_target[55] += Q(1, 7); mutations.append(('wrong_target', columns, bad_target))
    for name, candidate, wanted in mutations:
        try:
            check_columns(candidate, wanted, X, Z, forbidden)
        except (AssertionError, ValueError):
            rejected.append(name)
        else:
            raise AssertionError('corruption_accepted_'+name)
    return {'status': 'PASS_SYNTHETIC_TARGET_CONTROLS_ONLY', 'archive_sha256': sha(archive),
            'sample_column_ids': ids, 'physical_mixture': base, 'exact_recovery': recovery,
            'outside_column_span_recovery': failed, 'corruptions_rejected': rejected,
            'witness2_membership_asserted': False}


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--certificate', type=Path)
    ap.add_argument('--point', type=Path)
    ap.add_argument('--controls-archive', type=Path)
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    assert not args.output.exists()
    start = time.monotonic()
    X, Z, forbidden, physical_result = checked_physical_source()
    normalization = translation_controls()
    if args.controls_archive:
        assert not args.certificate and not args.point
        result = controls(X, Z, forbidden, args.controls_archive)
    else:
        assert args.certificate and args.point
        bank = read(args.certificate)
        target = verify_binding(bank, args.point)
        checked = check_columns(bank['columns'], target, X, Z, forbidden)
        result = {'status': 'PASS_EXACT_LOCAL_PROJECTED_MEMBERSHIP',
                  'certificate_sha256': sha(args.certificate), 'point_sha256': sha(args.point),
                  **checked,
                  'scope': 'Exact membership of this target in the one-orbit/full-Z-basis convex relaxation only. Does not prove extendability of any column, existence of a full source frame, or membership in the exact full-frame projection.'}
    result.update(source_C16_answered=False, physical_full_frame=False,
                  consumer_sha256=sha(Path(__file__)), source_hashes={p: sha(ROOT/p) for p in SOURCES},
                  dependencies={p: sha(ROOT/p) for p in ('verify_algebraic_model.py', 'verify_full_partner_basis_oracle.py', 'verify_full_partner_projection.py')},
                  physical_source_checks=physical_result, normalization_controls=normalization,
                  elapsed_seconds=time.monotonic()-start)
    args.output.write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps({k: result[k] for k in ('status', 'source_C16_answered', 'elapsed_seconds')}))


if __name__ == '__main__':
    main()
