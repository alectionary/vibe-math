#!/usr/bin/env python3
"""Bounded independent mapping/physical-support audit, not hull membership.

Read-only against all projection inputs. Literal features, weight formulas,
compact-target reconstruction and low-pivot physical prefix bounds are separate
from the projection implementation. Comparisons deliberately import producer
functions only as objects under audit. The final active archive does not record
the last solved active IDs: that missing cohort is explicitly NOT reconstructed.
"""
from pathlib import Path
import hashlib, json, random, sys
from fractions import Fraction as Q
from collections import Counter
import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from full_partner_projection_features import moment_target, candidate_weights
from full_partner_projection import read, mask_universe
from full_partner_basis_oracle import FullPartnerBasisOracle
from verify_projected_profile_moment_rows import point_vector
from verify_anchored_full_partner_template import dimension, domain_and_upper
from verify_algebraic_model import physical
from certify_profile_moment_point import layout


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def literal_features(mask, selected):
    phases = [t for t in range(16) if mask >> t & 1]
    chosen = set(selected)
    return (1, len(phases),
            *(sum((t+h) % 16 in phases for t in phases) for h in range(1, 9)),
            *(sum(z//16 == j for z in selected) for j in range(45)),
            *(sum(16*j+(t+h) % 16 in chosen for t in phases)
              for j in range(45) for h in range(16)))


def literal_weights(mask, c):
    phases = [t for t in range(16) if mask >> t & 1]
    return tuple(c[10+j] + sum(c[55+16*j+(b-t) % 16] for t in phases)
                 for j in range(45) for b in range(16))


def main():
    output = ROOT/'coupling-results/full-partner-projection-independent-audit.json'
    assert not output.exists()
    names = [
        'full_partner_projection.py', 'full_partner_projection_features.py',
        'full_partner_projection_incremental.py', 'full_partner_projection_primal.py',
        'full_partner_projection_active.py', 'full_partner_basis_oracle.py',
        'verify_anchored_full_partner_template.py', 'verify_algebraic_model.py',
        'certify_profile_moment_point.py', 'verify_projected_profile_moment_rows.py',
        'physical-pool-source.json', 'pools/xcoords.txt', 'pools/zcoords.txt',
        'algebraic-results/orbit-rank-profiles.json.gz',
        'algebraic-results/hulls-16-rank.json.gz',
        'coupling-results/witness2-rational.json.gz',
        'coupling-results/full-partner-projection-independent-audit.py']
    for kind in ('incremental', 'primal', 'active'):
        stem = f'coupling-results/full-partner-projection-{kind}-witness2'
        names.extend((stem+'.json', stem+'.columns.npz'))
    hashes = {name: sha(ROOT/name) for name in names}
    point = ROOT/'coupling-results/witness2-rational.json.gz'
    pdata = read(point)
    hulls = read(ROOT/'algebraic-results/hulls-16-rank.json.gz')
    _, ix, coord = layout(hulls)
    values = list(map(Q, pdata['values']))
    target = (Q(1), 16*values[ix['p', 32]],
              *(16*values[coord('S', h, 32, 32)] for h in range(1, 9)),
              *(16*values[ix['p', j]] for j in range(45)),
              *(16*values[coord('T', h, 32, j)] for j in range(45) for h in range(16)))
    assert target == tuple(moment_target(point_vector(point)))
    b = np.asarray(list(map(float, target)))
    X, Z, A = physical()
    oracle = FullPartnerBasisOracle()
    assert tuple(X) == oracle.X and tuple(Z) == oracle.Z
    rng = random.Random(20261030)
    reports = []
    support_report = None
    for kind in ('incremental', 'primal', 'active'):
        stem = ROOT/f'coupling-results/full-partner-projection-{kind}-witness2'
        report = read(stem.with_suffix('.json'))
        arr = np.load(stem.with_suffix('.columns.npz'))
        F, lam = arr['features'], arr['master_mixture_weights']
        c, gamma = arr['master_dual_coefficients'], float(arr['master_bound'])
        last = next(r for r in reversed(report['rounds']) if r['model_status'] == 'HighsModelStatus.kOptimal')
        mixture = sum((lam[i:i+1000]@F[i:i+1000] for i in range(0, len(F), 1000)), np.zeros(775))
        ids = sorted({0, len(F)-1, *rng.sample(range(len(F)), 15),
                      *list(np.flatnonzero(lam > 1e-10)[:10])})
        coefficients = (0, *(rng.randrange(-9, 10) for _ in range(774)))
        for index in ids:
            mask = int(arr['masks'][index])
            phases = [t for t in range(16) if mask >> t & 1]
            chosen = list(map(int, arr['selected_Z_indices'][index]))
            direct = literal_features(mask, chosen)
            assert tuple(F[index]) == direct
            assert len(set(chosen)) == dimension(Z[z] for z in chosen) == 128
            signatures = [sum(((X[512+t] & Z[z]).bit_count() % 2) << q
                              for q, t in enumerate(phases)) for z in chosen]
            assert Counter(signatures) == Counter({0: 128-len(phases),
                                                   **{1 << q: 1 for q in range(len(phases))}})
            weights = literal_weights(mask, coefficients)
            assert weights == candidate_weights(mask, coefficients)
            assert sum(x*y for x, y in zip(coefficients, direct)) == (
                sum(coefficients[k]*direct[k] for k in range(10)) + sum(weights[z] for z in chosen))
        record = {
            'master': kind, 'archive_columns': len(F), 'last_optimal_round': last['round'],
            'sample_column_ids': list(map(int, ids)), 'sample_physical_columns_checked': len(ids),
            'mass': float(lam.sum()), 'min_weight': float(lam.min(initial=0)),
            'l1_residual': float(abs(b-mixture).sum()), 'dual_value': float(c@b[1:]-gamma),
            'record_objective': last.get('numeric_restricted_distance', last.get('numeric_restricted_separation')),
            'max_feature_residual': float(abs(b-mixture).max())}
        assert abs(record['mass']-1) < 1e-9 and record['min_weight'] >= -1e-10
        assert abs(record['l1_residual']-record['dual_value']) < 1e-7
        assert abs(record['dual_value']-record['record_objective']) < 1e-7
        if kind != 'active':
            record['solved_cohort_prefix_columns'] = last['master_columns']
            record['max_dual_constraint_violation_solved_cohort'] = float(np.max(F[:last['master_columns'], 1:]@c-gamma))
            assert record['max_dual_constraint_violation_solved_cohort'] < 1e-7
        else:
            record['restricted_dual_cohort_replay'] = 'NOT_AVAILABLE_LAST_SOLVED_ACTIVE_IDS_NOT_SAVED'
            record['final_active_ids_are_post_pricing_not_last_solved_cohort'] = True
        if 'master_errors' in arr:
            error = arr['master_errors']
            record['error_reconstruction_max'] = float(np.max(abs(mixture[1:]+error[:774]-error[774:]-b[1:])))
            selected = abs(b[1:]-mixture[1:]) > 1e-8
            record['complementarity_sign_max'] = float(np.max(abs(c[selected]-np.sign((b[1:]-mixture[1:])[selected]))))
            assert record['error_reconstruction_max'] < 1e-7 and record['complementarity_sign_max'] < 1e-7
        reports.append(record)
        if kind == 'active':
            exact_c = (0, *(int(np.rint(x*65536)) for x in c))
            allowed, reps = mask_universe(32)
            maximum, prefix_checks, per_mask = None, 0, []
            for mask in reps:
                selected = [512+t for t in range(16) if mask >> t & 1]
                weights = literal_weights(mask, exact_c)
                independent = domain_and_upper(X, Z, selected, weights)
                original = oracle.support(oracle.prepare(32, mask), weights)
                assert independent['status'] == original['status'] == 'EXACT_FULL_PARTNER_BASIS_SUPPORT'
                assert independent['upper'] == original['value']
                prefix_checks += independent['prefix_checks']
                fixed = literal_features(mask, ())[:10]
                value = sum(exact_c[k]*fixed[k] for k in range(10)) + independent['upper']
                maximum = value if maximum is None else max(maximum, value)
                per_mask.append({'mask': mask, 'physical_prefix_ranks_checked': independent['prefix_checks'],
                                 'basis_support': str(independent['upper']), 'full_support': str(value)})
            exact_target = sum(x*y for x, y in zip(exact_c, target))
            assert maximum == last['exact_integer_support'] and Q(last['exact_target_value']) == exact_target
            support_report = {'allowed_masks': len(allowed), 'representatives_checked': len(reps),
                              'physical_prefix_ranks_checked': prefix_checks, 'per_mask': per_mask,
                              'coefficients': list(exact_c), 'pricing_scale': 65536,
                              'integer_support': str(maximum), 'exact_integer_target': str(exact_target),
                              'exact_integer_gap': str(exact_target-maximum),
                              'scaled_support': float(maximum/65536),
                              'scaled_target': float(exact_target/65536),
                              'scaled_gap': float((exact_target-maximum)/65536)}
    unchanged = {name: sha(ROOT/name) == digest for name, digest in hashes.items()}
    assert all(unchanged.values())
    result = {
        'status': 'PASS_BOUNDED_INDEPENDENT_MAPPING_AND_SUPPORT_AUDIT',
        'source_C16_answered': False, 'source_hashes': hashes,
        'source_files_unchanged': unchanged, 'exact_target_translation_checked': True,
        'saved_column_samples': reports, 'final_active_pricing_replay': support_report,
        'provenance_gap': 'The active archive stores IDs after final pricing. Last-solved active IDs were not saved; complete final restricted-dual cohort feasibility is not claimed or retrofitted.',
        'scope': 'Read-only audit of mapping, sampled physical columns, numerical primal/dual identities, and one full exact pricing call. Does not certify source obstruction, physical frame, exact mixture membership, or whole optimization trace.',
        'mathematical_review': {
            'features': 'd[j,h]=sum_t P[t] Z[j,t+h]; target=16*T[h,32,j].',
            'weights': 'Z[j,b] receives v[j]+sum_{t in P}w[j,b-t].',
            'primal_dual': 'min ||F*lambda-b||_1, lambda>=0,sum(lambda)=1; dual max c*b-gamma with c*F_j<=gamma, |c_i|<=1.',
            'active_pruning': 'Deleting exact-zero nonbasic columns preserves an optimal primal and its feasible dual; implementation uses numerical zero tolerances and final source cuts still require exact global pricing.',
            'diagnosis': 'No mapping/sign/pruning bug found; large global pricing gaps are compatible with unstable extreme box-duals on restricted column sets.',
            'wolfe_gate': 'For f(x)=0.5*(x-b)^T D*(x-b), c=D*(b-x); maximize c*phi. Wolfe gap=h(c)-c*x; separating target gap=c*b-h(c). They are distinct.',
            'wolfe_safeguards': 'Feasible normalized nonnegative start, decreasing minor-cycle objective, mass/nonnegativity checks, corral stationarity, rank-loss stop, true-gradient witness comparisons, and explicit quantization-error bound before convergence claims.'}}
    output.write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps({'status': result['status'], 'sample_columns': sum(r['sample_physical_columns_checked'] for r in reports),
                      'prefix_ranks': support_report['physical_prefix_ranks_checked'], 'output': str(output), 'sha256': sha(output)}))


if __name__ == '__main__':
    main()
