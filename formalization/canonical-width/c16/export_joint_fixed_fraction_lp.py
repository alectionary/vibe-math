"""Versioned fraction-text successor to the immutable integer-row LP export."""
from pathlib import Path
from fractions import Fraction as Q
import argparse
import gzip
import json
import os
import time

from two_basis_joint_fixed_star import ROOT, sha, read
from export_joint_fixed_exact_lp import write_row


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--integer-manifest', type=Path, required=True)
    ap.add_argument('--prefix', type=Path, required=True)
    a = ap.parse_args()
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    start = time.monotonic()
    manifest = read(a.integer_manifest)
    assert manifest['status'] == 'PASS_EXACT_LP_TEXT_INTEGER_ROUNDTRIP'
    assert sha(manifest['semantic']) == manifest['semantic_sha256']
    assert sha(manifest['lp']) == manifest['lp_sha256']
    model = read(manifest['semantic'])
    assert all(sha(ROOT/p) == h for p, h in model['source_hashes'].items())
    path = Path(str(a.prefix) + '.lp')
    receipt = Path(str(a.prefix) + '.json')
    assert not path.exists() and not receipt.exists()
    n = model['variable_count']
    with path.open('w') as stream:
        stream.write('Minimize\n obj: + 0 x0\nSubject To\n')
        for row in model['rows']:
            scale = Q(row['scale'])
            assert scale > 0
            terms = {j: Q(v)/scale for j, v in row['coefficients']}
            rhs = Q(row['rhs'])/scale
            write_row(stream, row['name'], terms, rhs, row['relation'])
        stream.write('Bounds\n')
        for j in range(n):
            stream.write(' x'+str(j)+' free\n')
        stream.write('End\n')
    tokens = path.read_text().split()
    assert tokens[:7] == ['Minimize', 'obj:', '+', '0', 'x0', 'Subject', 'To']
    cursor = 7
    for row in model['rows']:
        assert tokens[cursor] == row['name'] + ':'; cursor += 1
        terms = {}
        while tokens[cursor] in ['+', '-']:
            sign = 1 if tokens[cursor] == '+' else -1
            v = Q(tokens[cursor+1]) * sign
            var = tokens[cursor+2]
            assert var.startswith('x') and 0 <= int(var[1:]) < n
            j = int(var[1:]); terms[j] = terms.get(j, Q(0)) + v
            cursor += 3
        assert tokens[cursor] == row['relation']
        assert Q(tokens[cursor+1]) * Q(row['scale']) == Q(row['rhs'])
        cursor += 2
        assert {j: v*Q(row['scale']) for j, v in terms.items() if v} == {
            j: Q(v) for j, v in row['coefficients']}
    assert tokens[cursor] == 'Bounds'; cursor += 1
    for j in range(n):
        assert tokens[cursor:cursor+2] == ['x'+str(j), 'free']; cursor += 2
    assert tokens[cursor:] == ['End']
    result = dict(status='PASS_EXACT_LP_FRACTION_TEXT_ROUNDTRIP',
                  integer_manifest=str(a.integer_manifest), integer_manifest_sha256=sha(a.integer_manifest),
                  semantic=manifest['semantic'], semantic_sha256=manifest['semantic_sha256'],
                  lp=str(path), lp_sha256=sha(path), lp_bytes=path.stat().st_size,
                  row_count=len(model['rows']), variable_count=n,
                  input_rows_are_original_semantic_rows_without_positive_integer_scaling=True,
                  original_integer_export_unchanged=True,
                  source_sha256=sha(Path(__file__)), nice=os.getpriority(os.PRIO_PROCESS, 0),
                  elapsed_seconds=time.monotonic()-start)
    receipt.write_text(json.dumps(result, indent=2)+'\n')
    print(result, flush=True)


if __name__ == '__main__':
    main()
