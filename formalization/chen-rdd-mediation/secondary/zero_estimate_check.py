#!/usr/bin/env python3
"""Diagnostic: what would Table 4.8 show if every estimate were zero (bias = -population value)?

Chen's printed estimation code (Appendix B) matches our re-implementation, and our full-design
run is unbiased; the step that matched estimates to population values is not printed. This
script asks which printed Table 4.8 entries are reproduced, over the 256 (a, b, c', h)
combinations (each n level gives the same percentages), when |bias| = |population value|.
It is a consistency check on the printed table, not evidence of what Chen's code did.

  zero_estimate_check.py > zero_estimate_check.csv
"""
import csv, itertools, sys

P = [0, .14, .39, .59]
H = [0, .05, .15, .34]
GRID = list(itertools.product(P, P, P, H))

# printed Table 4.8 (printed p. 88, PDF page 102): effect -> [(within .10, within .05) for cut index 1, 2, 3]
PRINTED = {
    'PNIE': [(62.50, 50.00), (75.00, 50.00), (81.25, 75.00)],
    'TNIE': [(51.88, 41.88), (60.00, 42.19), (70.94, 54.69)],
    'PNDE': [(12.50, 6.25), (12.50, 8.75), (18.75, 10.00)],
    'TNDE': [(12.50, 6.88), (12.50, 7.50), (18.75, 7.19)],
    'MINT': [(87.50, 75.00), (87.50, 75.00), (87.50, 75.00)],
}
HYP = [
    ('PNIE', 'ab (population value)', lambda a, b, c, h: a * b),
    ('TNIE', 'ab + ah (population value)', lambda a, b, c, h: a * b + a * h),
    ('PNDE', "c' (population value)", lambda a, b, c, h: c),
    ('PNDE', "c' + h (alternative)", lambda a, b, c, h: c + h),
    ('TNDE', "c' + ah (population value)", lambda a, b, c, h: c + a * h),
    ('TNDE', "c' + h + ah (alternative)", lambda a, b, c, h: c + h + a * h),
    ('MINT', 'ah (population value)', lambda a, b, c, h: a * h),
]


def pct(f, tol):
    return 100 * sum(abs(f(*g)) <= tol + 1e-12 for g in GRID) / len(GRID)


w = csv.writer(sys.stdout)
w.writerow(['effect', 'magnitude_if_estimate_zero', 'zero_within_10', 'zero_within_05',
            'printed_cut1', 'printed_cut2', 'printed_cut3'])
for eff, name, f in HYP:
    w.writerow([eff, name, f'{pct(f, .10):.2f}', f'{pct(f, .05):.2f}',
                *[f'{a:.2f}/{b:.2f}' for a, b in PRINTED[eff]]])
