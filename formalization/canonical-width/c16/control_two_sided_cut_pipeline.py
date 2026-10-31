#!/usr/bin/env python3
"""Isolated synthetic target control for export -> physical replay -> compiler.

The target deliberately violates cardinality. It is not a recovered C16 point,
and this directory must never be added to the research model's accepted banks.
"""
from pathlib import Path
from copy import deepcopy
from fractions import Fraction
import argparse
import json
import os
import subprocess
import sys
import time
from two_sided_full_basis_oracle import TwoSidedFullBasisOracle, cut_candidate, export_cut_bank, json_exact
from verify_two_sided_full_basis_oracle import ROOT, sha, read, matrix, point_owner, check_support, physical_source


def write(path, value):
    assert not path.exists()
    path.write_text(json.dumps(json_exact(value), indent=2)+'\n')


def must_reject(call, label):
    try:
        call()
    except (AssertionError, TypeError, ValueError, OverflowError):
        return label
    raise AssertionError(('negative pipeline control accepted', label))


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--output-dir', type=Path, required=True); a = ap.parse_args()
    assert not a.output_dir.exists(); a.output_dir.mkdir(parents=True); start = time.monotonic()
    (a.output_dir/'SYNTHETIC-ONLY.txt').write_text('CONTROL FIXTURE ONLY. Deliberately invalid cardinality target. Never include these banks in the actual C16 model or describe them as cuts against a recovered point.\n')
    owner = [0]*36495
    for i in range(45):
        owner[i] = owner[45+46*i] = 1
    point = a.output_dir/'synthetic-invalid-cardinality-point.json'
    write(point, dict(status='SYNTHETIC_INVALID_CARDINALITY_CONTROL_ONLY', source_C16_answered=False, owner_vector=owner))
    oracle = TwoSidedFullBasisOracle(); xx, zz = [80, 512], [186, 433]; dd = oracle.prepare(xx, zz)
    c = [7]+[0]*10+[1]*1440+[0]*5760
    candidate = cut_candidate(oracle, dd, c, point)
    assert candidate and candidate['upper_bound'] == 263 and Fraction(candidate['exact_violation']) == 1184
    bank_path = a.output_dir/'synthetic-cardinality-cut-bank.json'
    export_cut_bank(bank_path, point, [candidate], frozen_inputs={'synthetic_control_only':True})
    receipt_path = a.output_dir/'synthetic-cardinality-independent.json'
    env = dict(os.environ, PYTHONDONTWRITEBYTECODE='1', OPENBLAS_NUM_THREADS='1', OMP_NUM_THREADS='1')
    with (a.output_dir/'synthetic-cardinality-independent.log').open('w') as log:
        subprocess.run([sys.executable, str(ROOT/'verify_two_sided_full_basis_oracle.py'), '--bank', str(bank_path),
                        '--point', str(point), '--output', str(receipt_path)], check=True, stdout=log, stderr=subprocess.STDOUT, env=env)
    receipt = read(receipt_path); assert receipt['status'] == 'PASS' and receipt['cuts_checked'] == 1
    M, rhs, metadata = matrix([bank_path], [receipt_path])
    assert M.shape == (1, 36495) and M.nnz == 45 and rhs.tolist() == [256]
    assert M.indices.tolist() == list(range(45)) and M.data.tolist() == [32]*45
    values = point_owner(point)
    gap = sum((int(v)*values[int(j)] for j, v in zip(M.indices, M.data)), Fraction(0))-int(rhs[0])
    assert gap == 1184
    X, Z, _ = physical_source(); rejected = []
    rejected.append(must_reject(lambda: check_support(X, Z, xx, zz, c, candidate['support_records'], 262), 'lowered global bound'))
    changed = list(c); changed[0] += 1
    rejected.append(must_reject(lambda: check_support(X, Z, xx, zz, changed, candidate['support_records'], 263), 'changed literal coefficient'))
    for label, patch in [('wrong proof family', {'proof_kind':'independent_hinge'}),
                         ('fixed profile weights', {'profile_weights_fixed_in_separation':True}),
                         ('wrong bank hash', {'bank_sha256':'0'*64}),
                         ('wrong compiled rhs', {'results':[dict(receipt['results'][0], rhs=255)]})]:
        path = a.output_dir/('rejected-'+label.replace(' ', '-')+'.json')
        write(path, dict(receipt, **patch))
        rejected.append(must_reject(lambda: matrix([bank_path], [path]), label))
    manifest = dict(status='PASS_SYNTHETIC_PIPELINE_CONTROL_ONLY', source_C16_answered=False,
                    real_recovered_point_used=False, eligible_for_actual_model_dispatch=False,
                    helper_sha256=sha(__file__), producer_sha256=sha(ROOT/'two_sided_full_basis_oracle.py'),
                    consumer_sha256=sha(ROOT/'verify_two_sided_full_basis_oracle.py'),
                    synthetic_target_sha256=sha(point), bank_sha256=sha(bank_path), independent_sha256=sha(receipt_path),
                    exact_gap=str(gap), compiled_row='32*sum(p_i)<=256', constant_shift_checked=7,
                    corrupted_controls_rejected=rejected, elapsed_seconds=time.monotonic()-start,
                    scope='Export, physical support receipt and guarded matrix dispatch work on an explicitly invalid synthetic target. No actual research target is separated by this control.')
    manifest['inventory'] = {p.name:sha(p) for p in sorted(a.output_dir.iterdir()) if p.is_file()}
    write(a.output_dir/'summary.json', manifest)
    print(json.dumps(manifest, indent=2), flush=True)


if __name__ == '__main__':
    main()
