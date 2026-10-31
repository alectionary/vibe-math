#!/usr/bin/env python3
"""Symbolic all32-action audit for generic exact physical integer-form banks.

The coefficient-folding implementation is checked by equality of literal
Boolean polynomials, not only by evaluating a finite sample of selections.
The heuristic scanner is reviewed separately from this universal proof.
"""
from collections import Counter
from fractions import Fraction
from itertools import product
from pathlib import Path
import argparse
import hashlib
import json
import random
import time
from verify_physical_integer_forms import compile_row, matrix
from verify_projected_profile_moment_rows import point_vector

ROOT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def move(event, rotation, swap):
    side, index = divmod(event, 720)
    orbit, phase = divmod(index, 16)
    return 720*(side ^ swap)+16*orbit+(phase+rotation) % 16


def add_orbit(polynomial, events, coefficient):
    for swap, rotation in product(range(2), range(16)):
        polynomial[tuple(sorted({move(e, rotation, swap) for e in events}))] += coefficient


def nonzero(polynomial):
    return {key:value for key, value in polynomial.items() if value}


def raw_polynomial(cut):
    events, weights, constant = cut['events'], cut['weights'], cut['constant']
    result = Counter({(): -32*constant*(constant-1)//2})
    for k, (event, weight) in enumerate(zip(events, weights)):
        add_orbit(result, [event], -(constant*weight+weight*(weight-1)//2))
        for other, value in zip(events[:k], weights[:k]):
            add_orbit(result, [event, other], -weight*value)
    return nonzero(result)


def symbolic_check(cut):
    row, rhs = compile_row(cut)
    folded = Counter({(): -32*rhs})
    for index, coefficient in row.items():
        if index < 45:
            add_orbit(folded, [16*index], coefficient)
        else:
            side, rem = divmod(index-45, 18225)
            h, rem = divmod(rem, 2025); i, j = divmod(rem, 45)
            add_orbit(folded, [16*i, 720*side+16*j+h], coefficient)
    raw = raw_polynomial(cut)
    assert raw == nonzero(folded), 'literal32-action polynomial differs from folded row'
    assignments = 0
    for bits in product((0, 1), repeat=len(cut['events'])):
        c, w = cut['constant'], cut['weights']
        L = c+sum(v*x for v, x in zip(w, bits))
        expanded = c*(c-1)//2+sum((c*v+v*(v-1)//2)*x for v, x in zip(w, bits))
        expanded += sum(w[i]*w[j]*bits[i]*bits[j] for i in range(len(w)) for j in range(i))
        assert expanded == L*(L-1)//2 >= 0
        assignments += 1
    return row, rhs, len(raw), assignments


def scanner_normalize(events, weights, full_equal_weight_groups=False):
    """Literal translation of the scanner's currently bounded normalization."""
    choices = []
    for swap, rotation in product(range(2), range(16)):
        values = [move(e, rotation, swap) for e in events]
        for weight in sorted(set(weights)) if full_equal_weight_groups else range(-4, 5):
            slots = [i for i, w in enumerate(weights) if w == weight]
            entries = sorted(values[i] for i in slots)
            for i, value in zip(slots, entries):
                values[i] = value
        choices.append(values)
    return min(choices)


def generic_controls():
    rng = random.Random(20261030)
    rows = truth = terms = orbit_checks = 0; incomplete_group_cases = []
    for length in range(1, 13):
        events = rng.sample(range(1440), length)
        weights = [((5*k+length) % 13)-6 for k in range(length)]
        constant = length % 7-3
        cut = dict(events=events, weights=weights, constant=constant)
        _, _, n, t = symbolic_check(cut); rows += 1; truth += t; terms += n
        expected = raw_polynomial(cut)
        canonical = scanner_normalize(events, weights)
        assert raw_polynomial(dict(cut, events=canonical)) == expected
        full = scanner_normalize(events, weights, True)
        if canonical != full:
            incomplete_group_cases.append(length)
        for swap, rotation in product(range(2), range(16)):
            transformed = [move(e, rotation, swap) for e in events]
            assert raw_polynomial(dict(cut, events=transformed)) == expected
            assert raw_polynomial(dict(cut, events=scanner_normalize(transformed, weights))) == expected
            orbit_checks += 1
    # Exhibit the incomplete sorting for a repeated weight outside[-4,4].
    events, weights = [511, 0, 777, 910], [5, 5, -6, -6]
    current = scanner_normalize(events, weights); complete = scanner_normalize(events, weights, True)
    assert current != complete
    cut = dict(events=events, weights=weights, constant=2)
    assert raw_polynomial(dict(cut, events=current)) == raw_polynomial(dict(cut, events=complete))
    return dict(generic_arity_controls=list(range(1, 13)), generic_symbolic_rows=rows,
                generic_truth_assignments=truth, generic_symbolic_monomial_terms=terms,
                exact_scanner_symmetry_and_normalization_controls=orbit_checks,
                signed_weights_tested_range=[-6, 6], nonzero_constants_tested=True,
                outside_range_equal_weight_group_example=dict(events=events, weights=weights, current_normalized=current, fully_grouped=complete),
                limitation='The scanner only sorts repeated-weight slots for weights-4..4. Outside this range orbit moves remain valid and exact rows remain universal, but equal-weight deduplication is incomplete. Current frozen templates use only-1,1,2.')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--bank', type=Path, required=True); ap.add_argument('--receipt', type=Path, required=True)
    ap.add_argument('--point', type=Path, required=True); ap.add_argument('--output', type=Path, required=True)
    a = ap.parse_args(); assert not a.output.exists(); start = time.monotonic()
    bank, accepted = json.loads(a.bank.read_text()), json.loads(a.receipt.read_text())
    assert accepted['status'] == 'PASS' and accepted['bank_sha256'] == sha(a.bank)
    assert accepted['consumer_sha256'] == sha(ROOT/'verify_physical_integer_forms.py')
    assert bank['point_sha256'] == accepted['point_sha256'] == sha(a.point)
    assert accepted['cuts_checked'] == len(bank['cuts']) and bank['source_hashes'] == accepted['source_hashes']
    assert all(sha(ROOT/p) == h for p, h in bank['source_hashes'].items())
    owner = point_vector(a.point); results = []; truth = terms = 0
    for cut in bank['cuts']:
        row, rhs, n, t = symbolic_check(cut)
        gap = sum((v*owner[j] for j, v in row.items()), Fraction(0))-rhs
        assert gap == Fraction(cut['exact_violation']) > 0
        truth += t; terms += n
        results.append(dict(exact_violation=str(gap), arity=len(cut['events']), symbolic_monomial_terms=n,
                            maximum_abs_owner_coefficient=max(map(abs, row.values()), default=0)))
    M, rhs, metadata = matrix([a.bank], [a.receipt]); assert M.shape == (len(results), 36495)
    for k, result in enumerate(results):
        lo, hi = M.indptr[k:k+2]
        gap = sum((int(v)*owner[int(j)] for j, v in zip(M.indices[lo:hi], M.data[lo:hi])), Fraction(0))-int(rhs[k])
        assert gap == Fraction(result['exact_violation'])
    controls = generic_controls()
    scanner = ROOT/'separate_higher_integer_forms.cpp'
    text = scanner.read_text()
    assert 'for (int q=-4;q<=4;++q)' in text and 'K<1 || K>12' in text
    out = dict(status='PASS_SYMBOLIC_PHYSICAL_INTEGER_FORM_REVIEW', source_C16_answered=False,
               bank_sha256=sha(a.bank), receipt_sha256=sha(a.receipt), point_sha256=sha(a.point),
               reviewer_sha256=sha(__file__), source_hashes={p:sha(ROOT/p) for p in
                   ['verify_physical_integer_forms.py', 'physical_integer_form_rows.py', 'verify_projected_profile_moment_rows.py', 'separate_higher_integer_forms.cpp']},
               cuts_checked=len(results), symbolic32_action_polynomials_checked=len(results),
               exact_truth_assignments=truth, symbolic_monomial_terms=terms, results=results,
               compiled_matrix_nonzeros=int(M.nnz), generic_signed_template_controls=controls,
               scanner_review=dict(normalization_preserves_exact_signed_polynomial=True,
                   coefficient_slot_permutation='Only equal signed weights are permuted; arbitraryK1..12 is handled.',
                   current_templates_arithmetic_safe=True,
                   arbitrary_integer_input_limitation='C++int products constant*(constant-1), constant*w and w_i*w_j can overflow for large signed inputs. The current frozen small templates are safe; arbitrary-size coefficients would need guarded wider arithmetic. Discovery remains heuristic and every accepted row is independently evaluated with Python integers/Fractions.',
                   completeness_claimed=False), elapsed_seconds=time.monotonic()-start,
               scope='Universal binomial(L,2)>=0 for integerL; literal32-action Boolean polynomials equal the folded moment rows. Exact positive gaps are only at the named frozen point. No complete family separation, source obstruction or frame is claimed.')
    a.output.write_text(json.dumps(out, indent=2)+'\n')
    print(json.dumps({k:v for k,v in out.items() if k not in ('results', 'generic_signed_template_controls')}, indent=2), flush=True)


if __name__ == '__main__':
    main()
