#!/usr/bin/env python3
"""Compare saved primal-warm-start states with independent exact constructions.

The predecessor audit independently reconstructed the3600target coordinates
and all artificial errors, and linked every selected basis to a fully replayed
physical archive. This consumer binds that evidence to the actual new start.
"""
from pathlib import Path
from fractions import Fraction as Q
from two_basis_replay_paths import RecordedRoot
import argparse
import json
import numpy as np
from verify_two_sided_full_basis_oracle import ROOT, read, sha


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--initial', type=Path, required=True); ap.add_argument('--reference', type=Path, required=True); ap.add_argument('--reference-report', type=Path, required=True); ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--recorded-root',type=Path,required=True)
    a = ap.parse_args();paths=RecordedRoot(ROOT,a.recorded_root);assert sha(ROOT/'verify_two_basis_phase_I_start.py')=='b5c9d743a97d4700a300e48ad5046c4e51e4a5d689cea24e9615e6283dc9abc2'; assert not a.output.exists()
    initial, reference, report = read(a.initial), read(a.reference), read(a.reference_report)
    assert initial['status'] == 'EXACT_PHASE_I_FEASIBLE_INITIAL_BASIS_CANDIDATE'
    assert reference['status'] == 'PASS_REJECTED_NUMERIC_ENDPOINT_AND_EXACT_PHASE_I_START'
    assert reference['report_sha256'] == sha(a.reference_report)
    assert reference['auditor_sha256'] == sha(ROOT/'audit_two_basis_inner_initial.py')
    assert reference['physical_consumer_sha256'] == sha(ROOT/'verify_two_sided_full_basis_oracle.py')
    assert initial['point_sha256'] == reference['point_sha256'] == report['point_sha256']
    assert initial['side'] == reference['side'] == report['side']
    assert initial['X_anchors'] == report['X_anchors'] and initial['Z_anchors'] == report['Z_anchors']
    assert initial['lambda_masses'] == report['lambda_masses'] and initial['sector_target'] == report['sector_target']
    assert all(sha(ROOT/p) == h for p, h in initial['source_hashes'].items())
    frozen_path = Path(str(a.initial).replace('.initial-exact.json', '.frozen.json'))
    assert initial['frozen_sha256'] == sha(frozen_path)
    frozen = read(frozen_path)
    assert frozen['source_hashes'] == initial['source_hashes'] and frozen['initial_unique_sector_bases'] == 16
    archive_path = paths.resolve(report['columns_artifact']); assert sha(archive_path) == reference['archive_sha256']
    archive = np.load(archive_path, allow_pickle=False)
    start = reference['exact_phase_I_feasible_start']; records = initial['pattern_basis_records']
    assert [r['mask'] for r in records] == list(range(16)) and len(start['pattern_column_ids']) == 16
    for m, (record, index) in enumerate(zip(records, start['pattern_column_ids'])):
        assert int(archive['masks'][index]) == m
        assert archive['selected_indices'][index].tolist() == record['selected_indices']
        assert Q(record['weight']) == Q(start['pattern_weights'][m]) == Q(initial['lambda_masses'][m]) >= 0
    errors = [Q(sign)*Q(value) for row, sign, value in start['signed_error_variables']]
    assert [row for row, sign, value in start['signed_error_variables']] == list(range(3600))
    positive = list(map(Q, initial['positive_feature_errors'])); negative = list(map(Q, initial['negative_feature_errors']))
    assert len(positive) == len(negative) == 3600
    assert positive == [max(v, 0) for v in errors] and negative == [max(-v, 0) for v in errors]
    assert sum(positive)+sum(negative) == Q(initial['phase_I_objective']) == Q(start['objective']) > 0
    basics = list(range(16))+[16+j+(3600 if error < 0 else 0) for j, error in enumerate(errors)]
    assert initial['basic_variable_indices'] == sorted(basics) and len(set(basics)) == 3616
    result = dict(portable_replay=paths.evidence(),frozen_consumer_sha256=sha(ROOT/'verify_two_basis_phase_I_start.py'),status='PASS_EXACT_ARTIFICIAL_ERROR_PHASE_I_INITIAL_BASIS', source_C16_answered=False,
                  initial_sha256=sha(a.initial), frozen_sha256=sha(frozen_path), reference_sha256=sha(a.reference),
                  reference_report_sha256=sha(a.reference_report), consumer_sha256=sha(__file__),
                  point_sha256=initial['point_sha256'], side=initial['side'], full_physical_basis_records_checked=16,
                  exact_feature_error_equations=3600, exact_pattern_mass_equations=16, basic_variables=3616,
                  determinant_absolute_value=1, phase_I_objective=initial['phase_I_objective'],
                  actual_target_membership=False, source_hashes=initial['source_hashes'],
                  scope='The saved start is a nonnegative feasible basis of the LP with artificial signed errors. Those strictly positive total errors are not a sector allocation, and do not establish membership or a source frame.')
    a.output.write_text(json.dumps(result, indent=2)+'\n'); print(json.dumps(result, indent=2), flush=True)


if __name__ == '__main__':
    main()
