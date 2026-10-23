"""Reconstruct P11's cumulative short-pattern forbidden sets from half collisions.

Uses the appendix's row classes and cyclic column inequalities, without the
prefix simplicity filter in scan.py. This is a source-derived reconstruction,
not recovered author code. No exact-length cycle counts are inferred from it.
"""
from itertools import combinations, product
from pathlib import Path
import json
import random
import sys

sys.dont_write_bytecode = True
import scan


def row_representatives(m, half):
    templates = {2:[(0,1)], 3:[(0,1,2)], 4:scan.SOURCE_ROWS}[half]
    # Relabel the sorted row names injectively; omit unused-name duplicates.
    for t in templates:
        used = sorted(set(t))
        if used != list(range(len(used))):
            continue
        for chosen in combinations(range(m), len(used)):
            yield tuple(chosen[i] for i in t)


def collision(B, rows, cols):
    """P11 A.4/A.6 equality of the two half-word sums, in characteristic two."""
    cells = [cell for i in range(len(rows))
             for cell in ((rows[i], cols[i]), (rows[(i+1)%len(rows)], cols[i]))]
    if any(B[i][j] is None for i,j in cells):
        return False
    split = len(cells)//2
    left = right = 0
    for i,j in cells[:split]:
        left ^= B[i][j]
    for i,j in cells[split:]:
        right ^= B[i][j]
    return left == right


def source_presence(B, length):
    half = length//2
    for rows in row_representatives(len(B), half):
        for cols in product(range(len(B[0])), repeat=half):
            if any(cols[i] == cols[(i+1)%half] for i in range(half)):
                continue
            if collision(B, rows, cols):
                return True
    return False


def source_forbidden(B, slot, ell, bound):
    return {a for a in range(1 << ell)
            if any(source_presence(scan.replace(B,slot,a), k)
                   for k in (4,6,8) if k <= bound)}


def cases():
    for ell in (0,1,2,3):
        for vals in product([None, *range(1 << ell)], repeat=3):
            yield [[vals[0],vals[1]],[vals[2],None]], (1,1), ell
    for vals in product(range(4), repeat=3):
        yield [[0,0,0],[0,vals[0],vals[1]],[0,vals[2],None]], (2,2), 2
    rng = random.Random(20261023)
    for _ in range(90):
        m,n,ell = rng.choice([3,4]),rng.choice([3,4]),rng.choice([1,2,3])
        B = [[None if rng.random() < .35 else rng.randrange(1 << ell)
              for _ in range(n)] for _ in range(m)]
        slot = rng.randrange(m),rng.randrange(n)
        B[slot[0]][slot[1]] = None
        yield B,slot,ell


def run():
    arrays = checks = 0
    for B,slot,ell in cases():
        arrays += 1
        for a in range(1 << ell):
            filled = scan.replace(B,slot,a)
            direct_girth = scan.girth(scan.graph(filled,ell))
            for bound in (4,6,8):
                expected = direct_girth is not None and direct_girth <= bound
                reconstructed = any(source_presence(filled,k) for k in (4,6,8) if k <= bound)
                prefix = any(scan.word_cycles(filled,k) for k in (4,6,8) if k <= bound)
                assert reconstructed == prefix == expected, (B,slot,ell,a,bound)
                checks += 1
    # Check A.6's eight-coordinate constraints and row classes against every
    # projected TBC word on four rows/columns, independently of label choices.
    for half in (2,3,4):
        reps = set(row_representatives(4,half))
        proper = [r for r in product(range(4),repeat=half)
                  if all(r[i] != r[(i+1)%half] for i in range(half))]
        def canon(r):
            return min(t[k:]+t[:k] for t in (r,r[::-1]) for k in range(half))
        assert {canon(r) for r in reps} == {canon(r) for r in proper}
    diagnostic = [[0,0],[0,None]]
    result = {
        'source':'P11 v1 Definition 4.20, Remark 4.21, Theorem A.4, patterns before Theorem A.6 and Remark A.7; 2023 predecessor Example 1',
        'status':'Source-derived cumulative cycle-forbidden reconstruction; not recovered author code.',
        'partial_arrays':arrays, 'candidate_label_threshold_checks':checks,
        'reconstructed_prefix_direct_mismatches':0,
        'thresholds':[4,6,8],
        'diagnostic_forbidden':{str(g):sorted(source_forbidden(diagnostic,(1,1),1,g)) for g in (4,6,8)},
        'exact_length_warning':{
            'B':[[0,0],[0,0]],'ell':1,
            'eight_step_collision':source_presence([[0,0],[0,0]],8),
            'actual_simple_eight_cycles':len(scan.exact_cycles_dfs(scan.graph([[0,0],[0,0]],1),8)),
            'actual_girth':4,
            'interpretation':'An exact-count pitfall; not a false positive for cumulative threshold eight.'},
        'complete_target_interpretation':'Cumulative short-cycle forbidden sets in the single-permutation-block model.',
        'not_certified':['Author software identity','Appendix multiplicity formulas','All decoding pathologies']}
    assert arrays == 1043 and checks == 21168
    Path(__file__).with_name('source-results.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))


if __name__ == '__main__':
    run()
