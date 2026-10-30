"""Export the original margin-free joint semantic LP using exact integer rows.

Positive row denominator clearing is recorded explicitly. No floating matrix
or recovered near-feasible allocation is used to define the LP.
"""
from pathlib import Path
from fractions import Fraction as Q
from functools import reduce
from math import gcd, lcm
import argparse
import gzip
import json
import os
import time

from two_basis_joint_fixed_star import ROOT, sha, read, prepare


def integer_row(expression):
    constant, terms = expression
    denominator = lcm(*(v.denominator for v in [constant, *terms.values()]))
    rhs = int(-constant * denominator)
    coefficients = {j: int(v * denominator) for j, v in terms.items()}
    divisor = reduce(gcd, [abs(rhs), *map(abs, coefficients.values())], 0) or 1
    scale = Q(denominator, divisor)
    rhs //= divisor
    coefficients = {j: v // divisor for j, v in coefficients.items()}
    assert scale > 0 and Q(rhs) == -constant * scale
    assert {j: Q(v) for j, v in coefficients.items()} == {
        j: v * scale for j, v in terms.items()}
    return coefficients, rhs, scale


def write_row(stream, name, coefficients, rhs, relation):
    stream.write(' ' + name + ':')
    count = 0
    for j, v in sorted(coefficients.items()) or [(0, 0)]:
        if count % 3 == 0:
            stream.write('\n  ')
        stream.write((' + ' if v >= 0 else ' - ') + str(abs(v)) + ' x' + str(j))
        count += 1
    stream.write('\n  ' + relation + ' ' + str(rhs) + '\n')


def replay_text(path, records, n):
    """Separate narrow grammar reader checks every exported integer token."""
    tokens = path.read_text().split()
    assert tokens[:5] == ['Minimize', 'obj:', '+', '0', 'x0']
    assert tokens[5:7] == ['Subject', 'To']
    cursor = 7
    for row in records:
        assert tokens[cursor] == row['name'] + ':'
        cursor += 1
        coefficients = {}
        while tokens[cursor] in ['+', '-']:
            sign = 1 if tokens[cursor] == '+' else -1
            value = int(tokens[cursor+1]) * sign
            variable = tokens[cursor+2]
            assert variable.startswith('x') and 0 <= int(variable[1:]) < n
            j = int(variable[1:])
            coefficients[j] = coefficients.get(j, 0) + value
            cursor += 3
        assert tokens[cursor] == row['relation']
        rhs = int(tokens[cursor+1]); cursor += 2
        assert rhs == int(row['rhs'])
        assert {j: v for j, v in coefficients.items() if v} == {
            int(j): int(v) for j, v in row['coefficients']}
    assert tokens[cursor] == 'Bounds'; cursor += 1
    for j in range(n):
        assert tokens[cursor:cursor+2] == ['x'+str(j), 'free']; cursor += 2
    assert tokens[cursor:] == ['End']


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--joint-config', type=Path, required=True)
    ap.add_argument('--prefix', type=Path, required=True)
    a = ap.parse_args()
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19, 'Research must run at nice19'
    paths = {k: Path(str(a.prefix) + suffix) for k, suffix in
             [('lp', '.lp'), ('semantic', '.semantic.json.gz'), ('manifest', '.json')]}
    assert not any(p.exists() for p in paths.values())
    started = time.monotonic()
    config = read(a.joint_config)
    assert config['status'] == 'FROZEN_JOINT_FIXED_LAW_OWNER_STAR_ALLOCATION_GATE'
    assert all(sha(ROOT/p) == h for p, h in config['source_hashes'].items())
    model = prepare(Path(config['point']),
                    {s: Path(config[s.lower()+'_config']) for s in ['X', 'Z']},
                    [(Path(z['bank']), Path(z['receipt'])) for z in config['star_banks']])
    n = len(model['variables'])
    records = []
    maximum_bits = 0
    with paths['lp'].open('w') as stream:
        stream.write('Minimize\n obj: + 0 x0\nSubject To\n')
        for kind, rows, relation in [('eq', model['equalities'], '='),
                                     ('ineq', model['inequalities'], '<=')]:
            for k, e in enumerate(rows):
                coefficients, rhs, scale = integer_row(e)
                name = kind + str(k)
                write_row(stream, name, coefficients, rhs, relation)
                maximum_bits = max(maximum_bits, abs(rhs).bit_length(),
                                   *(abs(v).bit_length() for v in coefficients.values()))
                records.append(dict(name=name, kind=kind, semantic_index=k,
                                    relation=relation, scale=str(scale), rhs=str(rhs),
                                    coefficients=[[j, str(v)] for j, v in sorted(coefficients.items())]))
        stream.write('Bounds\n')
        for j in range(n):
            stream.write(' x' + str(j) + ' free\n')
        stream.write('End\n')
    replay_text(paths['lp'], records, n)
    semantic = dict(status='EXACT_INTEGER_ROW_EXPORT_REQUIRE_INDEPENDENT_ENDPOINT_REPLAY',
                    joint_config=str(a.joint_config), joint_config_sha256=sha(a.joint_config),
                    variables=model['variables'], variable_count=n, rows=records,
                    artificial_margin_removed=True, objective_zero=True,
                    all_structural_variables_free=True,
                    source_hashes={**model['sources'], str(a.joint_config): sha(a.joint_config),
                                   'export_joint_fixed_exact_lp.py': sha(Path(__file__))})
    paths['semantic'].write_bytes(gzip.compress((json.dumps(semantic)+'\n').encode(), mtime=0))
    result = dict(status='PASS_EXACT_LP_TEXT_INTEGER_ROUNDTRIP',
                  variable_count=n, equality_count=len(model['equalities']),
                  inequality_count=len(model['inequalities']),
                  nonzeros=sum(len(r['coefficients']) for r in records),
                  maximum_integer_coefficient_or_rhs_bits=maximum_bits,
                  lp=str(paths['lp']), lp_sha256=sha(paths['lp']), lp_bytes=paths['lp'].stat().st_size,
                  semantic=str(paths['semantic']), semantic_sha256=sha(paths['semantic']),
                  nice=os.getpriority(os.PRIO_PROCESS, 0),
                  elapsed_seconds=time.monotonic()-started,
                  scope='Exact listed fixed-law relaxation. No solver or source conclusion.')
    paths['manifest'].write_text(json.dumps(result, indent=2)+'\n')
    print(result, flush=True)


if __name__ == '__main__':
    main()
