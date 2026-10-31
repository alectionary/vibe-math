"""Reconstruct a joint allocation from sparse exact SoPlex output.

The solver's status is not an acceptance condition. Every original exact row
must hold before emitting a candidate for the independent physical consumer.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse
import json
import os
import time

from two_basis_joint_fixed_star import ROOT, sha, read, prepare, evaluate, exact_check
from read_soplex_exact_output import read_named_rational


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--joint-config', type=Path, required=True)
    ap.add_argument('--fraction-manifest', type=Path, required=True)
    ap.add_argument('--solver-frozen', type=Path, required=True)
    ap.add_argument('--primal', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    frozen = args.output.with_suffix('.frozen.json')
    assert not args.output.exists() and not frozen.exists()
    start = time.monotonic()
    f = read(args.joint_config)
    export = read(args.fraction_manifest)
    assert export['status'] == 'PASS_EXACT_LP_FRACTION_TEXT_ROUNDTRIP'
    assert sha(export['lp']) == export['lp_sha256']
    assert sha(export['semantic']) == export['semantic_sha256']
    solver = read(args.solver_frozen)
    assert solver['status'] == 'FROZEN_SINGLE_EXACT_SOPLEX_TRIAL'
    assert solver['input_manifest_sha256'] == sha(args.fraction_manifest)
    assert solver['input_lp_sha256'] == export['lp_sha256']
    assert solver['semantic_sha256'] == export['semantic_sha256']
    assert any(part == '-X='+str(args.primal.resolve()) for part in solver['command'])
    semantic = read(export['semantic'])
    assert semantic['joint_config_sha256'] == sha(args.joint_config)
    assert all(sha(ROOT/p) == h for p, h in semantic['source_hashes'].items())
    m = prepare(Path(f['point']), {s: Path(f[s.lower()+'_config']) for s in ['X', 'Z']},
                [(Path(z['bank']), Path(z['receipt'])) for z in f['star_banks']])
    n = len(m['variables'])
    assert semantic['variables'] == m['variables'] and n == export['variable_count']
    named = read_named_rational(args.primal, ['x'+str(j) for j in range(n)])
    x = [named['x'+str(j)] for j in range(n)]
    eq_values = [c + sum(v*x[j] for j, v in r.items()) for c, r in m['equalities']]
    gaps = [c + sum(v*x[j] for j, v in r.items()) for c, r in m['inequalities']]
    assert all(v == 0 for v in eq_values), 'Solver values fail original exact equalities'
    assert all(v <= 0 for v in gaps), 'Solver values fail original exact inequalities'
    allocations = {}
    for side in ['X', 'Z']:
        y = evaluate(m['E'][side], x)
        assert exact_check(y, m['lambda_masses'], m['domains'][side], m['wanted'][side]) == []
        allocations[side] = [[str(v) for v in row] for row in y]
    frozen.write_bytes(args.joint_config.read_bytes())
    result = dict(status='EXACT_JOINT_FIXED_ALLOCATION_REQUIRES_REPLAY',
                  frozen_sha256=sha(frozen), exact_allocations=allocations,
                  exact_box_failures=[], exact_inequality_failures=[],
                  exact_equalities_checked=len(eq_values), exact_inequalities_checked=len(gaps),
                  minimum_exact_slack=str(-max(gaps)),
                  maximum_variable_numerator_bits=max(abs(v.numerator).bit_length() for v in x),
                  maximum_variable_denominator_bits=max(v.denominator.bit_length() for v in x),
                  source_bindings={str(p): sha(p) for p in [args.joint_config,
                      args.fraction_manifest, args.solver_frozen, args.primal,
                      Path(__file__), Path('read_soplex_exact_output.py')]},
                  nice=os.getpriority(os.PRIO_PROCESS, 0),
                  elapsed_seconds=time.monotonic()-start,
                  source_C16_answered=False,
                  scope='Exact listed fixed-law allocation only. Independent physical replay required.')
    args.output.write_text(json.dumps(result, indent=2)+'\n')
    print({k: v for k, v in result.items() if k != 'exact_allocations'}, flush=True)


if __name__ == '__main__':
    main()
