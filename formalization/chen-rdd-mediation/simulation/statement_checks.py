#!/usr/bin/env python3
"""Check every testable Type I error and power statement in Chen (2021), Chapter 4, against our cells.

  statement_checks.py ../results/cells.csv > ../results/statement_checks.csv

Scope: every statement in the Type I error section (printed pp. 99-108, PDF 113-122) and the power
section (printed pp. 110-121, PDF 124-135) that names cells and a checkable outcome. Sentences considered
and not tested, with the reason (EXCLUDED below), are written to the end of the output as 'excluded' rows.

Rates are rejection rates of the 95% percentile bootstrap CI, averaged over the design factors a
statement does not name (as Chen's figures are), by n and cutoff index. A statement about "PNIE1" or
"TNIE1" uses cutoff index 1 only; otherwise all three cutoffs are tested unless a cutoff is named.
Thresholds used to read Chen's words (stated here; the slack column below shows which verdicts depend on them):
  below the robustness criteria / near zero (Type I) : rate < .025
  within the robustness criteria                    : .025 <= rate <= .075
  outside the robustness criteria                   : rate < .025 or rate > .075
  approached .05 / within as n increased            : within at n = 10,000
  power below / above (or at least) .80             : < .80 / >= .80
  power around .80                                   : .70 <= rate <= .90
  power slightly below .80                           : .70 <= rate < .80
  power close to zero                                : rate < .10
  no differences across cutoffs or levels            : max - min <= .05 at every n
Each statement has one row per cell set it names (rates by n, cutoffs 1/2/3) with that set's verdict,
then a row with the statement's verdict: 'agree' only if every cell set agrees. A last column repeats
every verdict with each threshold moved .01 in Chen's favour (a sensitivity check on reading her words).
A further column repeats every verdict (strict thresholds) on our cells with h replaced by 0, keeping the
other factors: it asks whether Chen's statement would hold in our run if the mediator-by-treatment
interaction were absent. It is a counterfactual reading of our own results, not a test of her runs.
A last column reads every statement (strict thresholds) against Chen's OWN plotted values instead of our
cells: results/digitized_rates.csv, read from her Figures 4.17-4.28. It asks whether her text agrees with
her own figures, using only directly read points (an occluded or merged marker can carry a neighbouring
series' value). A cell set with no such points is 'not plotted'; a statement is judged on the cell
sets that are plotted, and says how many those are. Digitized values carry a reading error of about .003
(Type I) and .01-.02 (power); a verdict that turns on a smaller margin is noted in the disagreement record.
"""
import csv, sys
from collections import defaultdict

R = list(csv.DictReader(open(sys.argv[1])))
NS = ['500', '1000', '2500', '5000', '10000']
CUTS = '123'
P = [.14, .39, .59]
H = [.05, .15, .34]
IDX = defaultdict(list)
for r in R:
    IDX[r['effect']].append(r)


H0 = False   # counterfactual pass: read every cell with h replaced by 0 (same other factors)
FIG = False  # source-consistency pass: read Chen's own digitized figure values instead of our cells

import os
FIGROWS = defaultdict(list)
_fig = os.path.join(os.path.dirname(os.path.abspath(sys.argv[1])), 'digitized_rates.csv')
if os.path.exists(_fig):
    for r in csv.DictReader(open(_fig)):
        if r['quantity'] != 'reject' or r['chen_value'] == '' or r['status'] != 'read':
            continue          # occluded and merged points can carry another series' value
        spec = tuple(sorted((k, float(r[k])) for k in 'abch' if r[k] != ''))
        FIGROWS[(r['effect'], spec)].append((r['n'], r['cut_index'], float(r['chen_value'])))


def fig_rates(eff, **kw):
    spec = tuple(sorted((k, float(v)) for k, v in kw.items()))
    d = defaultdict(list)
    for n, cut, v in FIGROWS.get((eff, spec), []):
        d[(n, cut)].append(v)
    return {k: sum(v) / len(v) for k, v in d.items()}


def rates(eff, **kw):
    if FIG:
        return fig_rates(eff, **kw)
    if H0 and eff in ('PNDE', 'TNDE', 'TNIE', 'MINT'):
        kw = dict(kw, h=0)
    d = defaultdict(list)
    for r in IDX[eff]:
        if all(abs(float(r[k]) - v) < 1e-9 for k, v in kw.items()):
            d[(r['n'], r['cut_index'])].append(float(r['reject']))
    return {k: sum(v) / len(v) for k, v in d.items()}


def fmt(rt):
    return '; '.join(f'n={n}: ' + '/'.join(f'{rt[(n, c)]:.3f}' if (n, c) in rt else '-' for c in CUTS) for n in NS)


SLACK = 0.0   # set to .01 for the sensitivity pass: every threshold moves .01 in Chen's favour
below = lambda x: x < .025 + SLACK
within = lambda x: .025 - SLACK <= x <= .075 + SLACK
outside = lambda x: x < .025 + SLACK or x > .075 - SLACK
under80 = lambda x: x < .80 + SLACK
over80 = lambda x: x >= .80 - SLACK
around80 = lambda x: .70 - SLACK <= x <= .90 + SLACK
slightly_below80 = lambda x: .70 - SLACK <= x < .80 + SLACK
near0 = lambda x: x < .10 + SLACK
rows = []


COUNTER = [0]


def stmt(page, text, eff, variants, ok):
    """ok(rt, kw) -> bool for one cell set (kw: the named factor values)."""
    COUNTER[0] += 1
    page = f'{COUNTER[0]}|{page}'
    verdicts = []
    for kw in variants:
        rt = rates(eff, **kw)
        try:
            v = ok(rt, kw)
        except KeyError:          # only in the FIG pass: the cell set is not plotted
            v = None
        verdicts.append(v)
        rows.append([page, text, eff, ' '.join(f'{k}={v}' for k, v in kw.items()),
                     fmt(rt) if v is not None else 'not plotted',
                     'not plotted' if v is None else ('cell agrees' if v else 'cell disagrees')])
    shown = [v for v in verdicts if v is not None]
    if not shown:
        verdict = 'not plotted'
    else:
        verdict = 'agree' if all(shown) else 'disagree'
        if len(shown) < len(verdicts):
            verdict += f' ({len(shown)} of {len(verdicts)} cell sets plotted)'
    rows.append([page, text, eff, f'all {len(variants)} cell sets', f'{sum(bool(v) for v in shown)} of {len(shown)} agree',
                 verdict])


def at(pred, ns, cuts=CUTS):
    return lambda rt, kw: all(pred(rt[(n, k)]) for n in ns for k in cuts)


def both(*fs):
    return lambda rt, kw: all(f(rt, kw) for f in fs)


def spread(rt, kw):
    return all(max(rt[(n, k)] for k in CUTS) - min(rt[(n, k)] for k in CUTS) <= .05 + SLACK for n in NS)


def lowest(n, cut, ns=None):
    return lambda rt, kw: all(rt[(m, cut)] == min(rt[(m, k)] for k in CUTS) for m in (ns or [n]))


def highest(n, cut):
    return lambda rt, kw: rt[(n, cut)] == max(rt[(n, k)] for k in CUTS)


def run_all():
    COUNTER[0] = 0
    # ---------------- Type I error (PDF 113-122) ----------------
    stmt('99 (PDF 113)', 'PNIE Type I below the robustness criteria, near zero, when a = b = 0', 'PNIE',
         [dict(a=0, b=0)], at(below, NS))
    stmt('99 (PDF 113)', 'PNIE Type I outside the robustness criteria at n = 500 and 1000, within for larger n, when '
         'b = 0 and a = .14, at all cutoffs', 'PNIE', [dict(a=.14, b=0)],
         both(at(outside, NS[:2]), at(within, NS[2:])))
    stmt('99 (PDF 113)', 'PNIE Type I within the robustness criteria at all n when b = 0 and a = .39 or .59', 'PNIE',
         [dict(a=a, b=0) for a in P[1:]], at(within, NS))
    stmt('99 (PDF 113)', 'PNIE1 Type I outside the robustness criteria at n = 500, approaching .05 (within) as n '
         'increases, when a = 0 and b = .14', 'PNIE', [dict(a=0, b=.14)],
         both(at(outside, ['500'], '1'), at(within, ['10000'], '1')))
    stmt('99 (PDF 113)', 'PNIE1 Type I within the robustness criteria when a = 0 and b = .39 or .59', 'PNIE',
         [dict(a=0, b=b) for b in P[1:]], at(within, NS, '1'))
    stmt('99 (PDF 113)', 'PNIE2 and PNIE3 Type I within the robustness criteria when a = 0 and b = .14, .39 or .59',
         'PNIE', [dict(a=0, b=b) for b in P], at(within, NS, '23'))
    stmt('102 (PDF 116)', 'TNIE Type I below the robustness criteria, close to zero, when a = b = h = 0', 'TNIE',
         [dict(a=0, b=0, h=0)], at(below, NS))
    stmt('102 (PDF 116)', 'TNIE Type I approaches .05 (within at the largest n) when a = 0 and b = .14, at every h',
         'TNIE', [dict(a=0, b=.14, h=h) for h in [0] + H], at(within, ['10000']))
    stmt('102 (PDF 116)', 'TNIE3 Type I outside the robustness criteria at n = 500 when a = 0 and b = .14, at every h',
         'TNIE', [dict(a=0, b=.14, h=h) for h in [0] + H], at(outside, ['500'], '3'))
    stmt('102 (PDF 116)', 'TNIE3 Type I outside the robustness criteria at n = 1000 when a = 0, b = .14, h = 0 or .05',
         'TNIE', [dict(a=0, b=.14, h=h) for h in (0, .05)], at(outside, ['1000'], '3'))


    def tnie_other(rt, kw):
        """Within everywhere except the TNIE3 exceptions stated just before."""
        for n in NS:
            for k in CUTS:
                if kw['b'] == .14 and k == '3' and (n == '500' or (n == '1000' and kw['h'] in (0, .05))):
                    continue
                if not within(rt[(n, k)]):
                    return False
        return True


    stmt('102 (PDF 116)', 'TNIE Type I within the robustness criteria in all other cases with a = 0 (b or h nonzero, '
         'apart from the TNIE3 exceptions)', 'TNIE',
         [dict(a=0, b=b, h=h) for b in [0] + P for h in [0] + H if b + h > 0], tnie_other)
    stmt('104 (PDF 118)', "PNDE Type I within the robustness criteria and close to .05 when c' = h = 0", 'PNDE',
         [dict(c=0, h=0)], at(within, NS))
    stmt('104 (PDF 118)', "PNDE Type I shows no differences across cutoffs when c' = h = 0", 'PNDE',
         [dict(c=0, h=0)], spread)
    stmt('106 (PDF 120)', "TNDE Type I within the robustness criteria and close to the targeted .05 when c' = h = 0, "
         "at every level of a", 'TNDE',
         [dict(c=0, h=0, a=a) for a in [0] + P], at(within, NS))
    stmt('108 (PDF 122)', 'MINT Type I close to zero and below the robustness criteria when a = h = 0', 'MINT',
         [dict(a=0, h=0)], at(below, NS))
    stmt('108 (PDF 122)', 'MINT Type I below the robustness criteria when a = .14, h = 0: MINT1 and MINT3 at n = 500, '
         '1000, 2500; MINT2 at n = 500, 1000', 'MINT', [dict(a=.14, h=0)],
         both(at(below, NS[:3], '13'), at(below, NS[:2], '2')))
    stmt('108 (PDF 122)', 'MINT Type I within the robustness criteria when h = 0 and a = .39 or .59', 'MINT',
         [dict(a=a, h=0) for a in P[1:]], at(within, NS))
    stmt('108 (PDF 122)', 'MINT Type I below the robustness criteria and close to zero when a = 0, with no variation '
         'across h > 0', 'MINT', [dict(a=0, h=h) for h in H], at(below, NS))

    # ---------------- Power (PDF 124-135) ----------------
    stmt('110 (PDF 124)', 'PNIE power below .80 at n = 500, 1000, 2500 when a = b = .14, with PNIE1 the lowest of the '
         'three cutoffs', 'PNIE', [dict(a=.14, b=.14)], both(at(under80, NS[:3]), lowest(None, '1', NS[:3])))
    stmt('110 (PDF 124)', 'PNIE power below .80 at n = 500, 1000, 2500 when a = .14 and b = .39 or .59, with no '
         'differences across cutoffs', 'PNIE', [dict(a=.14, b=b) for b in P[1:]], both(at(under80, NS[:3]), spread))
    stmt('110 (PDF 124)', 'PNIE, a = .39, b = .14: below .80 at n = 500 at all cutoffs with PNIE1 lowest and PNIE3 '
         'highest; at n = 1000 PNIE2 and PNIE3 at or above .80 while PNIE1 stays below', 'PNIE', [dict(a=.39, b=.14)],
         both(at(under80, ['500']), lowest('500', '1'), highest('500', '3'), at(over80, ['1000'], '23'),
              at(under80, ['1000'], '1')))
    stmt('110 (PDF 124)', 'PNIE power around .80 at n = 500 when a = .39 and b = .39 or .59', 'PNIE',
         [dict(a=.39, b=b) for b in P[1:]], at(around80, ['500']))
    stmt('110 (PDF 124)', 'PNIE, a = .59, b = .14: below .80 at n = 500 with PNIE1 lowest and PNIE3 highest; at n = '
         '1000 only PNIE3 above .80; at n = 2500 all three above .80', 'PNIE', [dict(a=.59, b=.14)],
         both(at(under80, ['500']), lowest('500', '1'), highest('500', '3'), at(over80, ['1000'], '3'),
              at(under80, ['1000'], '12'), at(over80, ['2500'])))
    stmt('110 (PDF 124)', 'PNIE power above .80 at all n and cutoffs when a = .59 and b = .39 or .59', 'PNIE',
         [dict(a=.59, b=b) for b in P[1:]], at(over80, NS))
    stmt('112 (PDF 126)', 'TNIE1 (h = .15) power close to zero when b = 0, at every level of a', 'TNIE',
         [dict(a=a, b=0, h=.15) for a in P], at(near0, NS, '1'))
    stmt('112 (PDF 126)', 'TNIE1 (h = .15) power below .80 for n <= 2500 and above .80 for n >= 5000 when a = .14 and '
         'b = .14, .39 or .59', 'TNIE', [dict(a=.14, b=b, h=.15) for b in P],
         both(at(under80, NS[:3], '1'), at(over80, NS[3:], '1')))
    stmt('112 (PDF 126)', 'TNIE1 (h = .15) power below .80 at n = 500 and above .80 at larger n when a = .39 or .59 and '
         'b = .14', 'TNIE', [dict(a=a, b=.14, h=.15) for a in P[1:]],
         both(at(under80, ['500'], '1'), at(over80, ['10000'], '1')))
    stmt('112 (PDF 126)', 'TNIE1 (h = .15) power around .80 at n = 500 and above .80 at larger n when a = .39 and '
         'b = .39 or .59', 'TNIE', [dict(a=.39, b=b, h=.15) for b in P[1:]],
         both(at(around80, ['500'], '1'), at(over80, NS[1:], '1')))
    stmt('112 (PDF 126)', 'TNIE1 (h = .15) power above .80 at all n when a = .59 and b = .39 or .59', 'TNIE',
         [dict(a=.59, b=b, h=.15) for b in P[1:]], at(over80, NS, '1'))


    stmt('112 (PDF 126)', 'TNIE2 and TNIE3 power show overall patterns similar to TNIE1 (read as: no differences '
         'across the three cutoffs; h = .15, every a and b)', 'TNIE',
         [dict(a=a, b=b, h=.15) for a in P for b in [0] + P], spread)

    def no_h_variation(rt_unused, kw):
        rts = [rates('TNIE', a=kw['a'], b=kw['b'], h=h) for h in H]
        return all(max(r[(n, '1')] for r in rts) - min(r[(n, '1')] for r in rts) <= .05 + SLACK for n in NS)


    stmt('112 (PDF 126)', 'TNIE1 power shows no clear variation across levels of h (h = .05, .15, .34; rates shown for '
         'the cell set averaged over h)', 'TNIE', [dict(a=a, b=b) for a in P for b in P], no_h_variation)
    stmt('114 (PDF 128)', 'TNIE (h = .15), a = .39, b = .14: TNIE1 highest and TNIE3 lowest; all below .80 at n = 500; '
         'TNIE1 and TNIE2 above .80 at n = 1000', 'TNIE', [dict(a=.39, b=.14, h=.15)],
         both(highest('500', '1'), lowest('500', '3'), at(under80, ['500']), at(over80, ['1000'], '12')))
    stmt('114 (PDF 128)', 'TNIE (h = .15), a = .59, b = .14: below .80 at n = 500; at n = 1000 only TNIE1 above .80; '
         'all above .80 for n >= 2500', 'TNIE', [dict(a=.59, b=.14, h=.15)],
         both(at(under80, ['500']), at(over80, ['1000'], '1'), at(under80, ['1000'], '23'), at(over80, NS[2:])))
    stmt('116 (PDF 130)', "PNDE power close to zero when c' = 0, at every level of h (h > 0) and cutoff", 'PNDE',
         [dict(c=0, h=h) for h in H], at(near0, NS))
    stmt('116 (PDF 130)', "PNDE power below .80 for n <= 2500 when c' = 0, at every level of h (h > 0) and cutoff",
         'PNDE', [dict(c=0, h=h) for h in H], at(under80, NS[:3]))
    stmt('116 (PDF 130)', "PNDE power slightly below .80 at n = 500 when c' = .39, at every level of h and cutoff",
         'PNDE', [dict(c=.39, h=h) for h in [0] + H], at(slightly_below80, ['500']))
    stmt('116 (PDF 130)', "PNDE power above .80 when c' = .59, at every level of h and cutoff", 'PNDE',
         [dict(c=.59, h=h) for h in [0] + H], at(over80, NS))
    stmt('116 (PDF 130)', 'PNDE power shows no differences across the cutoffs', 'PNDE',
         [dict(c=c, h=h) for c in P for h in [0] + H], spread)
    stmt('118 (PDF 132)', "TNDE1 power close to zero when c' = 0, regardless of a and h (both nonzero)", 'TNDE',
         [dict(c=0, a=a, h=h) for a in P for h in H], at(near0, NS, '1'))
    stmt('118 (PDF 132)', "TNDE1 power below .80 for n <= 2500, reaching .80 only above 2500, when c' = .14", 'TNDE',
         [dict(c=.14, a=a, h=h) for a in [0] + P for h in [0] + H],
         both(at(under80, NS[:3], '1'), at(over80, ['10000'], '1')))
    stmt('118 (PDF 132)', "TNDE1 power around .80 at n = 500 and above .80 at larger n when c' = .39, at all a and h",
         'TNDE', [dict(c=.39, a=a, h=h) for a in [0] + P for h in [0] + H],
         both(at(around80, ['500'], '1'), at(over80, NS[1:], '1')))
    stmt('118 (PDF 132)', "TNDE1 power above .80 at all n when c' = .59, at all a and h", 'TNDE',
         [dict(c=.59, a=a, h=h) for a in [0] + P for h in [0] + H], at(over80, NS, '1'))
    stmt('118 (PDF 132)', 'TNDE power shows no variation by cutoff (h = .15)', 'TNDE',
         [dict(c=c, a=a, h=.15) for c in P for a in [0] + P], spread)

    stmt('118 (PDF 132)', 'TNDE2 and TNDE3 power show overall patterns similar to TNDE1 (read as: no differences '
         "across the three cutoffs; every c', a and h with a nonzero TNDE)", 'TNDE',
         [dict(c=c, a=a, h=h) for c in [0] + P for a in [0] + P for h in [0] + H if c + a * h > 0], spread)

    def tnde_no_h_variation(rt_unused, kw):
        rts = [rates('TNDE', c=kw['c'], a=kw['a'], h=h) for h in [0] + H]
        return all(max(r[(n, '1')] for r in rts) - min(r[(n, '1')] for r in rts) <= .05 + SLACK for n in NS)

    stmt('118 (PDF 132)', 'TNDE1 power does not differ across levels of h (h = 0, .05, .15, .34; rates shown for the '
         'cell set averaged over h)', 'TNDE', [dict(c=c, a=a) for c in P for a in [0] + P], tnde_no_h_variation)
    stmt('121 (PDF 135)', 'All power for MINT is near zero (below .10)', 'MINT',
         [dict(a=a, h=h) for a in P for h in H], at(near0, NS))



run_all()
strict = rows
rows = []
SLACK = 0.01
run_all()
slack = rows
SLACK = 0.0
rows = []
H0 = True
run_all()
h0 = rows
H0 = False
rows = []
FIG = True
run_all()
fig = rows
FIG = False
rows = [r[0].split('|', 1)[::-1][:1] + r[0].split('|', 1)[:1] + r[1:] + [s_[-1], z[-1], f_[-1], f_[4]]
        for r, s_, z, f_ in zip(strict, slack, h0, fig)]
SLACK = 0.0   # the summary rows below use the strict thresholds

EXCLUDED = [
    ('100 (PDF 114)', 'Overall, differences in Type I error rate occurred as a function of sample size when one path '
     'was zero while the other path was a small effect size.', 'summary of the PNIE statements tested above (rows on '
     'b = 0, a = .14 and a = 0, b = .14); names no cells of its own'),
    ('110 (PDF 124)', 'Power varied as a function of sample size and effect size. The targeted power was .80.',
     'general description; names no cells or outcome'),
    ('110 (PDF 124)', 'Generally, as sample size increased, power also increased.', 'general trend; names no cells'),
    ('112 (PDF 126)', 'Given a = .14 and b = .14, .39, or .59, power increased as sample size increased.',
     'trend only; the threshold claim in the next sentence is tested (TNIE1, a = .14)'),
    ('116 (PDF 130)', 'Power increased as sample size increased.', "general trend for PNDE after the c' = 0 sentence; "
     'names no threshold'),
    ('118 (PDF 132)', "In the case of c' = .14, power increased as sample size increased.", 'trend only; the threshold '
     'claim in the next sentence is tested'),
    ('121 (PDF 135)', 'Low power may have been due to the fact that MINT is an interaction term.',
     'explanation, not a result'),
]
w = csv.writer(sys.stdout)
w.writerow(['page', 'number', 'statement', 'effect', 'cells', 'our_rejection_rate_cut1/cut2/cut3', 'verdict', 'verdict_with_.01_slack', 'verdict_if_h_were_0', 'verdict_on_chen_figures', 'chen_figure_rate_cut1/cut2/cut3'])
w.writerows(rows)

for page, text, reason in EXCLUDED:
    w.writerow([page, '', text, '', 'not tested', reason, 'excluded', 'excluded', 'excluded', 'excluded', ''])

# Chapter 5 sample-size recommendation (printed p. 150): shares by n, then by n and cutoff
for n in NS:
    for c in [None] + list(CUTS):
        sel = [r for r in R if r['n'] == n and (c is None or r['cut_index'] == c)]
        z = [float(r['reject']) for r in sel if abs(float(r['population'])) < 1e-12]
        nz = [float(r['reject']) for r in sel if abs(float(r['population'])) >= 1e-12]
        label = f'n = {n}' + ('' if c is None else f', cutoff index {c}')
        w.writerow(['150 (PDF 164)', '', f'{label}: share of zero-effect cells with Type I in Bradley; share of nonzero '
                    'cells with power >= .80', 'all', f'{len(z)} zero cells, {len(nz)} nonzero cells',
                    f'{100 * sum(within(v) for v in z) / len(z):.1f}%; {100 * sum(v >= .8 for v in nz) / len(nz):.1f}%',
                    'summary', 'summary', 'summary', 'summary', ''])
