#!/usr/bin/env python3
"""Check Chapter 4-5 prose statements on Type I error and power against our cell results.

  statement_checks.py ../results/cells.csv > ../results/statement_checks.csv

Each statement gets one row per cell set it names (our rejection rates by n and cutoff index, averaged over
the factors it does not name, as Chen's figures are) and a final row with the statement's verdict, which is
'agree' only if every named cell set agrees. Statements are quoted from the dissertation (printed page, PDF page).
Agreement is judged by the statement's own threshold (.80 power, Bradley [.025, .075]).
"""
import csv, sys
from collections import defaultdict

R = list(csv.DictReader(open(sys.argv[1])))
NS = ['500', '1000', '2500', '5000', '10000']


def rates(eff, **kw):
    d = defaultdict(list)
    for r in R:
        if r['effect'] == eff and all(abs(float(r[k]) - v) < 1e-9 for k, v in kw.items()):
            d[(r['n'], r['cut_index'])].append(float(r['reject']))
    return {k: sum(v) / len(v) for k, v in d.items()}


def fmt(rt):
    return '; '.join(f'n={n}: ' + '/'.join(f'{rt[(n, c)]:.3f}' for c in '123') for n in NS)


rows = []


def add(page, statement, eff, variants, agree_fn):
    """One row per named cell set (variant); the statement agrees only if every variant agrees.

    Rates are averaged over the factors a statement does not name (as Chen's figures are), by n
    and cutoff index. agree_fn(variant, rt) judges one variant.
    """
    verdicts = []
    for kw in variants:
        rt = rates(eff, **kw)
        ok = agree_fn(kw, rt)
        verdicts.append(ok)
        rows.append([page, statement, eff, ' '.join(f'{k}={v}' for k, v in kw.items()), fmt(rt),
                     'cell agrees' if ok else 'cell disagrees'])
    rows.append([page, statement, eff, f'all {len(variants)} cell sets', f'{sum(verdicts)} of {len(verdicts)} agree',
                 'agree' if all(verdicts) else 'disagree'])


lo = lambda x: x < .025
inb = lambda x: .025 <= x <= .075
P = [.14, .39, .59]
add('99 (PDF 113)', 'PNIE Type I near zero, below Bradley, when a = b = 0', 'PNIE', [dict(a=0, b=0)],
    lambda kw, rt: all(lo(v) for v in rt.values()))
add('110 (PDF 124)', 'PNIE power below .80 at n = 500, 1000, 2500 when a = b = .14', 'PNIE', [dict(a=.14, b=.14)],
    lambda kw, rt: all(rt[(n, c)] < .8 for n in NS[:3] for c in '123'))
add('110 (PDF 124)', 'PNIE, a = .59, b = .14: at n = 1000 only cutoff 3 reaches .80; at n = 2500 all three do',
    'PNIE', [dict(a=.59, b=.14)],
    lambda kw, rt: rt[('1000', '3')] >= .8 > max(rt[('1000', '1')], rt[('1000', '2')])
    and all(rt[('2500', c)] >= .8 for c in '123'))
add('112 (PDF 126)', 'TNIE1 (h = .15) power below .80 for n <= 2500 and above .80 for n >= 5000 when a = .14 and '
    'b = .14, .39 or .59', 'TNIE', [dict(a=.14, b=b, h=.15) for b in P],
    lambda kw, rt: all(rt[(n, '1')] < .8 for n in NS[:3]) and all(rt[(n, '1')] >= .8 for n in NS[3:]))
add('104 (PDF 118)', "PNDE Type I within Bradley and close to .05 when c' = h = 0", 'PNDE', [dict(c=0, h=0)],
    lambda kw, rt: all(inb(v) for v in rt.values()))
add('106 (PDF 120)', "TNDE Type I within Bradley when c' = h = 0, at every level of a", 'TNDE',
    [dict(c=0, h=0, a=a) for a in [0] + P], lambda kw, rt: all(inb(v) for v in rt.values()))
add('108 (PDF 122)', 'MINT Type I below Bradley when a = .14, h = 0: MINT1 and MINT3 at n = 500, 1000, 2500; '
    'MINT2 at n = 500, 1000', 'MINT', [dict(a=.14, h=0)],
    lambda kw, rt: all(lo(rt[(n, c)]) for n in NS[:3] for c in '13') and all(lo(rt[(n, '2')]) for n in NS[:2]))
add('108 (PDF 122)', 'MINT Type I within Bradley when h = 0 and a = .39 or .59', 'MINT', [dict(a=a, h=0) for a in P[1:]],
    lambda kw, rt: all(inb(v) for v in rt.values()))
add('108 (PDF 122)', 'MINT Type I below Bradley and close to zero when a = 0, with no variation across h > 0', 'MINT',
    [dict(a=0, h=h) for h in (.05, .15, .34)], lambda kw, rt: all(lo(v) for v in rt.values()))
add('121 (PDF 135)', 'All power for MINT is near zero (below .10)', 'MINT',
    [dict(a=a, h=h) for a in P for h in (.05, .15, .34)], lambda kw, rt: all(v < .1 for v in rt.values()))

w = csv.writer(sys.stdout)
w.writerow(['page', 'statement', 'effect', 'cells', 'our_rejection_rate_cut1/cut2/cut3', 'verdict'])
w.writerows(rows)

# by-n summary for the Chapter 5 sample-size recommendation (printed p. 150)
for n in NS:
    z = [float(r['reject']) for r in R if r['n'] == n and abs(float(r['population'])) < 1e-12]
    nz = [float(r['reject']) for r in R if r['n'] == n and abs(float(r['population'])) >= 1e-12]
    w.writerow(['150 (PDF 164)', f'n = {n}: share of zero-effect cells with Type I in Bradley; share of nonzero cells with power >= .80',
                'all', f'{len(z)} zero cells, {len(nz)} nonzero cells',
                f'{100 * sum(inb(v) for v in z) / len(z):.1f}%; {100 * sum(v >= .8 for v in nz) / len(nz):.1f}%', 'summary'])

# the same shares by cutoff index ("regardless of cutoff score", printed p. 150)
for n in NS:
    for c in '123':
        z = [float(r['reject']) for r in R if r['n'] == n and r['cut_index'] == c and abs(float(r['population'])) < 1e-12]
        nz = [float(r['reject']) for r in R if r['n'] == n and r['cut_index'] == c and abs(float(r['population'])) >= 1e-12]
        w.writerow(['150 (PDF 164)', f'n = {n}, cutoff index {c}: share of zero-effect cells with Type I in Bradley; '
                    'share of nonzero cells with power >= .80', 'all', f'{len(z)} zero cells, {len(nz)} nonzero cells',
                    f'{100 * sum(inb(v) for v in z) / len(z):.1f}%; {100 * sum(v >= .8 for v in nz) / len(nz):.1f}%',
                    'summary'])
