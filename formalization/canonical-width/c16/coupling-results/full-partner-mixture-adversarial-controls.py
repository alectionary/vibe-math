#!/usr/bin/env python3
"""Additional acceptance-gate controls; synthetic targets, no source claim."""
from pathlib import Path
import copy, json, sys
from fractions import Fraction as Q
import numpy as np
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from verify_full_partner_mixture import (checked_physical_source, check_columns,
    verify_binding, literal_features, dimension, point_data, sha, SOURCES, LAYOUT)
from recover_full_partner_mixture import exact_recover

archive = ROOT/'coupling-results/full-partner-projection-active-witness2.columns.npz'
point = ROOT/'coupling-results/witness2-rational.json.gz'
data = np.load(archive)
X, Z, forbidden, physical = checked_physical_source()
ids = [0, len(data['features'])//2, len(data['features'])-1]
columns = []
for index, weight in zip(ids, (Q(1, 2), Q(1, 3), Q(1, 6))):
    chosen = list(map(int, data['selected_Z_indices'][index]))
    mask = int(data['masks'][index])
    columns.append({'weight': str(weight), 'mask': mask, 'selected_Z_indices': chosen,
                    'features': literal_features(mask, chosen)})
target = [sum(Q(c['weight'])*c['features'][j] for c in columns) for j in range(775)]
rejections = []


def rejects(name, call):
    try:
        call()
    except (AssertionError, ValueError) as error:
        rejections.append({'control': name, 'reason': str(error)})
    else:
        raise AssertionError('invalid_gate_acceptance_'+name)


bad = copy.deepcopy(columns)
chosen = bad[0]['selected_Z_indices']
phase = next(h for h in range(16)
             if sum((X[512+h] & Z[j]).bit_count() % 2 for j in chosen) != 1)
bad[0]['mask'] = 1 << phase
rejects('distinct_full_rank_Z_but_wrong_unit_owners', lambda: check_columns(bad, target, X, Z, forbidden))

bad = copy.deepcopy(columns)
chosen = bad[0]['selected_Z_indices']
replacement = next(j for j in range(720) if j not in chosen
                   and dimension([Z[k] for k in chosen[1:]]+[Z[j]]) == 127)
chosen[0] = replacement
assert len(set(chosen)) == 128
rejects('128_distinct_Z_but_rank127', lambda: check_columns(bad, target, X, Z, forbidden))

_, actual_target = point_data(point, 32)
binding = {'status': 'EXACT_NONNEGATIVE_MIXTURE_RECOVERED_REQUIRES_PHYSICAL_REPLAY',
           'orbit': 32, 'feature_layout': LAYOUT, 'source_C16_answered': False,
           'physical_full_frame': False, 'point_sha256': sha(point),
           'source_hashes': {p: sha(ROOT/p) for p in SOURCES},
           'target': list(map(str, actual_target)), 'positive_columns': 3, 'columns': columns}
assert verify_binding(binding, point) == actual_target
bad = copy.deepcopy(binding); bad['point_sha256'] = '0'*64
rejects('point_binding', lambda: verify_binding(bad, point))
bad = copy.deepcopy(binding); bad['target'][55] = str(Q(bad['target'][55])+Q(1, 7))
rejects('saved_target_normalization', lambda: verify_binding(bad, point))

matrix = np.asarray([c['features'] for c in columns]+[columns[0]['features']], dtype=np.int64).T
recovery, recovered = exact_recover(matrix, target, np.asarray([.25, 1/3, 1/6, .25]))
assert recovered is not None and recovery['exact_column_rank'] < matrix.shape[1]
assert all(sum(w*int(matrix[j, k]) for k, w in enumerate(recovered)) == target[j] for j in range(775))
negative_target = [sum(w*int(matrix[j, k]) for k, w in enumerate((Q(-1), Q(1), Q(1), Q(0)))) for j in range(775)]
negative, recovered = exact_recover(matrix[:, :3], negative_target, np.asarray([-1., 1., 1.]))
assert recovered is None and negative['status'] == 'EXACT_EQUATIONS_BUT_NEGATIVE_RECOVERED_WEIGHTS'

out = {'status': 'PASS_ADVERSARIAL_AND_DEPENDENT_RECOVERY_CONTROLS_ONLY',
       'source_C16_answered': False, 'witness2_membership_asserted': False,
       'sample_column_ids': ids, 'archive_sha256': sha(archive), 'point_sha256': sha(point),
       'code_sha256': sha(Path(__file__)),
       'dependencies': {p: sha(ROOT/p) for p in ('recover_full_partner_mixture.py', 'verify_full_partner_mixture.py')},
       'rejections': rejections, 'dependent_column_recovery': recovery,
       'negative_weight_recovery': negative}
output = ROOT/'coupling-results/full-partner-mixture-adversarial-controls.json'
assert not output.exists()
output.write_text(json.dumps(out, indent=2)+'\n')
print(json.dumps({'status': out['status'], 'rejections': len(rejections), 'sha256': sha(output)}))
