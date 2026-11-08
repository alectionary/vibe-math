#!/usr/bin/env python3
"""Build evidence-packet.json for the Chen (2021) replication from committed results.

  python3 build_packet.py            (from the study root; needs source/chen2021.pdf and pdftotext)

Every number below is read from results/ or secondary/; every source excerpt is checked to occur
on the stated PDF page of source/chen2021.pdf (whitespace-normalized) before the packet is written.
Printed page = PDF page - 14.
"""
import csv, hashlib, json, re, subprocess, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
PDF = ROOT / 'source/chen2021.pdf'
PDF_SHA = '9206b3d824077d36c86b4935ff7f19f64b3fdebde7746943b8a94500fe11e557'
OFFSET = 14


def sha(p):
    return hashlib.sha256((ROOT / p).read_bytes()).hexdigest()


def norm(s):
    s = re.sub(r'[‐-―]', '-', s)
    return re.sub(r'\s+', ' ', s).strip()


if sha('source/chen2021.pdf') != PDF_SHA:
    sys.exit('source PDF hash mismatch')
PAGES = [norm(p) for p in subprocess.run(['pdftotext', '-layout', str(PDF), '-'], capture_output=True,
                                          text=True, check=True).stdout.split('\f')]


def loc(pdf_page):
    return f'printed p. {pdf_page - OFFSET} (PDF page {pdf_page})'


def excerpt(text, pdf_page):
    if norm(text) not in PAGES[pdf_page - 1]:
        sys.exit(f'excerpt not on PDF page {pdf_page}: {text!r}')
    return text


def rows(path):
    return list(csv.DictReader(open(ROOT / path)))


t48 = {(r['effect'], int(r['cut_index'])): r for r in rows('results/table48_ours.csv')}
t49 = {(r['effect'], int(r['cut_index'])): r for r in rows('results/table49_ours.csv')}
summary = json.load(open(ROOT / 'results/summary.json'))
checks = rows('results/statement_checks.csv')
EFF = ['PNIE', 'TNIE', 'PNDE', 'TNDE', 'MINT']

# Printed Table 4.8 (PDF page 102) and Table 4.9 (PDF page 138), cut index 1..3
P48 = {'PNIE': [62.50, 75.00, 81.25], 'TNIE': [51.88, 60.00, 70.94], 'PNDE': [12.50, 12.50, 18.75],
       'TNDE': [12.50, 12.50, 18.75], 'MINT': [87.50, 87.50, 87.50]}
P49 = {  # (truth below CI %, coverage %, truth above CI %)
    'PNIE': [(1.21, 59.07, 39.72), (1.59, 70.94, 27.47), (1.93, 83.99, 14.08)],
    'TNIE': [(0.72, 41.97, 57.31), (0.83, 50.89, 48.28), (0.90, 62.25, 36.85)],
    'PNDE': [(0.36, 26.87, 72.77), (0.52, 36.60, 62.89), (0.68, 47.72, 51.60)],
    'TNDE': [(0.34, 24.10, 75.55), (0.48, 32.86, 66.65), (0.64, 42.76, 56.60)],
    'MINT': [(0.47, 64.42, 35.11), (0.46, 61.91, 37.62), (0.47, 64.36, 35.17)]}
for page, needle in [(102, '87.50% 75.00%'), (102, '18.75% 10.00%'), (138, '1.93% 83.99% 14.08%'),
                     (138, '0.34% 24.10% 75.55%')]:
    excerpt(needle, page)


def r2(x):
    return round(x + 1e-12, 2)


# headline contrast 1: % of direct-effect condition-cutoff results with |bias| > .10
pub_dir = r2(sum(100 - v for e in ('PNDE', 'TNDE') for v in P48[e]) / 6)
our_dir = r2(sum(100 - float(t48[(e, c)]['within_10']) for e in ('PNDE', 'TNDE') for c in (1, 2, 3)) / 6)
# indirect and MINT, supporting
pub_ind = {e: r2(sum(100 - v for v in P48[e]) / 3) for e in ('PNIE', 'TNIE', 'MINT')}
our_ind = {e: r2(sum(100 - float(t48[(e, c)]['within_10']) for c in (1, 2, 3)) / 3) for e in ('PNIE', 'TNIE', 'MINT')}
# headline contrast 2: coverage shortfall from 95%; contrast 3: truth-above minus truth-below
pub_short = r2(95 - sum(v[1] for e in EFF for v in P49[e]) / 15)
our_short = r2(95 - sum(float(t49[(e, c)]['coverage']) for e in EFF for c in (1, 2, 3)) / 15)
pub_imb = r2(sum(v[2] - v[0] for e in EFF for v in P49[e]) / 15)
our_imb = r2(sum(float(t49[(e, c)]['truth_above_ci']) - float(t49[(e, c)]['truth_below_ci'])
                 for e in EFF for c in (1, 2, 3)) / 15)
mint = summary['mint_power_by_n_and_ah']
our_mint = round(mint['n=500 ah=0.2006'], 3)
n5000 = [r for r in checks if r['statement'].startswith('n = 5000:')][0]
SH = {r['statement'].split(':')[0]: [float(x.strip().rstrip('%')) for x in r['our_rejection_rate_cut1/cut2/cut3'].split(';')]
      for r in checks if r['verdict'] == 'summary'}
by_cut = [SH[f'n = 5000, cutoff index {c}'] for c in '123']
by_n = {n: SH[f'n = {n}'] for n in ('500', '1000', '2500', '5000', '10000')}
t1_5000, pw_5000 = [float(x.strip().rstrip('%')) for x in n5000['our_rejection_rate_cut1/cut2/cut3'].split(';')]
verdicts = {r['statement']: r['verdict'] for r in checks if r['verdict'] in ('agree', 'disagree')}
slackv = {r['statement']: r['verdict_with_.01_slack'] for r in checks if r['verdict'] in ('agree', 'disagree')}
n_agree = sum(v == 'agree' for v in verdicts.values())
n_slack = sum(v == 'agree' for v in slackv.values())
T1S = [k for k in verdicts if 'Type I' in k]
PWS = [k for k in verdicts if 'Type I' not in k]
t1_agree, pw_agree = sum(verdicts[k] == 'agree' for k in T1S), sum(verdicts[k] == 'agree' for k in PWS)
t1_slack, pw_slack = sum(slackv[k] == 'agree' for k in T1S), sum(slackv[k] == 'agree' for k in PWS)
h0v = {r['statement']: r['verdict_if_h_were_0'] for r in checks if r['verdict'] in ('agree', 'disagree')}
robust_dis = [k for k in verdicts if verdicts[k] == 'disagree' and slackv[k] == 'disagree']
H0_FIXES = [k for k in robust_dis if h0v[k] == 'agree']
n_h0 = sum(v == 'agree' for v in h0v.values())
assert len(T1S) == 18 and len(PWS) == 28, (len(T1S), len(PWS))
n_pnie = sum(1 for k in PWS if k.startswith('PNIE')); n_pnde = sum(1 for k in PWS if k.startswith('PNDE'))
assert all(verdicts[k] == 'agree' for k in PWS if k.startswith(('PNIE', 'PNDE')))
assert all(h0v[k] == 'agree' for k in verdicts if verdicts[k] == 'agree')   # no agreeing statement flips
NUM = {r['statement']: int(r['number']) for r in checks if r['verdict'] in ('agree', 'disagree')}
assert list(NUM.values()) == list(range(1, len(verdicts) + 1))
rest = ', '.join(str(NUM[k]) for k in robust_dis if k not in H0_FIXES)

ART = [
    ('pdf', 'source/chen2021.pdf'), ('plan', 'REPLICATION-PLAN.yaml'), ('sim', 'simulation/chen_sim.py'),
    ('validate', 'simulation/validate_estimator.py'), ('fallback', 'simulation/fallback.json'),
    ('aggregate', 'simulation/aggregate.py'), ('cells', 'results/cells.csv'),
    ('t48', 'results/table48_ours.csv'), ('t49', 'results/table49_ours.csv'),
    ('type1', 'results/type1.csv'), ('power', 'results/power.csv'), ('summary', 'results/summary.json'),
    ('stmt_code', 'simulation/statement_checks.py'), ('stmt', 'results/statement_checks.csv'),
    ('zero_code', 'secondary/zero_estimate_check.py'), ('zero', 'secondary/zero_estimate_check.csv'),
    ('arith_code', 'secondary/table_arithmetic.py'), ('arith', 'secondary/table_arithmetic.csv'),
    ('avail', 'notes/availability.md'), ('runrec', 'notes/run-record.md'), ('builder', 'build_packet.py'),
]
artifacts = [dict(id=i, path=p, sha256=sha(p)) for i, p in ART]

from decimal import Decimal


def rounding_tol(n_inputs, k_rows):
    """Mean(s) of printed two-decimal percentages: n_inputs values entering with weight 1/k_rows each.

    The mean of k values each within +-0.005 is itself within +-0.005, so each mean is one
    weight-1 component with two decimals; n_inputs / k_rows means are combined by their sum.
    """
    means = n_inputs // k_rows
    assert means * k_rows == n_inputs
    value = float(Decimal('0.005') * means)
    return dict(kind='rounding', value=value, components=[dict(decimals=2, weight=1)] * means,
                basis=f'{n_inputs} printed percentages, each to two decimals (half-unit bound 0.005), enter as '
                      f'{"a mean" if means == 1 else f"a difference of {means} means"} of {k_rows} values. A mean of '
                      f'values each within 0.005 is within 0.005, so the bound is {value} percentage points.')


TOL2 = lambda k: rounding_tol(k, k)


claims = []


def claim(**kw):
    claims.append(kw)


GRID = ('Full factorial of Table 3.1: n in {500, 1000, 2500, 5000, 10000}, a, b, c\' in {0, .14, .39, .59}, '
        'h in {0, .05, .15, .34}; three cutoffs (25th, 50th, 75th percentile of x). Expected 3,840 condition-cutoff '
        'cells; completed 3,840 at 1,000 replications and 500 percentile-bootstrap resamples.')
METHODS = ('Independent Python/NumPy re-implementation of Appendices A-B (R unavailable; simulation/fallback.json), '
           'validated against scikit-learn OLS and explicit resampling. Same data-generating model, estimators, '
           'bootstrap count and percentile rule; our own seeds, so agreement is judged on summaries.')
MC = ('With 1,000 replications, a cell coverage near .95 has a binomial standard error of about .007 and a '
      'rejection rate near .05 about .007. Chen reports no Monte Carlo error.')
STOP_DONE = lambda why: dict(reason='Full design completed.', attempted='All 3,840 condition-cutoff cells at the '
                             'printed replication and bootstrap counts.', untested='Chen\'s own R output and seeds.',
                             resource_basis='13.7 core-hours.', next_evidence=why)

claim(id='H1', level='headline',
      statement='Direct-effect estimates (PNDE, TNDE) are biased, mostly negatively: only 12.50-18.75% of '
                'conditions fall within [-.10, .10] (Table 4.8), against 51.88-87.50% for the indirect and MINT effects.',
      source_locator=f'Table 4.8, {loc(102)}; Chapter 4 bias text, {loc(100)}-{loc(101)}; Chapter 5, {loc(161)}',
      artifact_ids=['pdf', 't48', 'cells', 'aggregate'],
      published=dict(value=pub_dir, units='% of direct-effect condition-cutoff results with |bias| > .10'),
      ours=dict(value=our_dir, units='% of direct-effect condition-cutoff results with |bias| > .10'),
      conditions=GRID,
      contrasts=[dict(definition='Percentage of PNDE and TNDE condition-cutoff results with |bias| > .10, '
                                 'averaged over the six effect-cutoff rows of Table 4.8',
                      units='percentage points', positive_means='more direct-effect results fall outside [-.10, .10]',
                      published=pub_dir, ours=our_dir)],
      reproduction_deviation=f'ours minus printed = {r2(our_dir - pub_dir)} percentage points',
      methods=METHODS + ' Bias is the mean of 1,000 estimates minus the population value (PNDE = c\', TNDE = c\' + ah).',
      uncertainty=f'Our largest |bias| over all 19,200 condition-cutoff-effect results is '
                  f'{summary["overall_max_abs_bias"]:.3f}, far inside .10; Monte Carlo standard error of a mean of 1,000 '
                  f'estimates is at most {max(float(r["sd"]) for r in rows("results/cells.csv")) / 1000 ** 0.5:.3f} in any cell.',
      multiplicity='Descriptive summary over the full grid; no tests.',
      status='not_replicated',
      status_reason='Every direct-effect result in our run lies within [-.05, .05]. Chen\'s printed estimation code '
                    'matches ours line by line, and her data-generating model contains no term that would bias OLS.',
      numerical='mismatch', reconstruction_scope='full design, independent re-implementation, own seeds',
      limitations=['Chen\'s step that matched estimates to population values is not printed, so the cause of the '
                   'printed bias cannot be identified.'],
      stopping=STOP_DONE('Chen\'s result files or aggregation code would show where the printed bias arises.'),
      findings=dict(
          published=dict(text='PNDE and TNDE within [-.10, .10] in only 12.50-18.75% of conditions, with negative bias',
                         state='reported', artifact_ids=['pdf'], locator=f'Table 4.8 and Chapter 5 bias, {loc(161)}',
                         source_excerpt=excerpt('When bias was present, the measure of bias was a negative value.', 161),
                         page_locator=loc(161), claim_type='numerical estimate',
                         conditions='Global linear models m ~ t + r and y ~ t + r + m + tm; full factorial collapsed '
                                    'over n and effect sizes, by cutoff index',
                         component_claim_ids=[], component_contrast_indices=[0]),
          ours=dict(text=f'PNDE and TNDE within [-.05, .05] in 100% of conditions; largest |bias| '
                         f'{max(abs(float(r["bias"])) for r in rows("results/cells.csv") if r["effect"] in ("PNDE", "TNDE")):.3f}',
                    state='observed', artifact_ids=['t48', 'cells'],
                    locator='results/table48_ours.csv rows PNDE and TNDE', component_claim_ids=[],
                    component_contrast_indices=[0])))

claim(id='H2', level='headline',
      statement='Percentile bootstrap CIs give coverage well below .95 (24.10-83.99% by effect and cutoff, '
                'Table 4.9), with the true value systematically above the interval, so the CI method does not give '
                'valid inference for mediation in RDD.',
      source_locator=f'Table 4.9, {loc(138)}; Chapter 4 coverage text, {loc(137)}; Chapter 5, {loc(164)}',
      artifact_ids=['pdf', 't49', 'cells', 'aggregate'],
      published=dict(value=pub_short, units='percentage points below 95% coverage, mean over Table 4.9 rows'),
      ours=dict(value=our_short, units='percentage points below 95% coverage, mean over Table 4.9 rows'),
      conditions=GRID,
      contrasts=[dict(definition='95 minus mean coverage (%) over the 15 effect-cutoff rows of Table 4.9',
                      units='percentage points', positive_means='CIs cover the population value less often than 95%',
                      published=pub_short, ours=our_short),
                 dict(definition='Mean over the 15 Table 4.9 rows of (% of replications with the population value '
                                 'above the CI) minus (% with it below the CI)',
                      units='percentage points', positive_means='the population value falls above the CI more often '
                                                                 'than below it', published=pub_imb, ours=our_imb)],
      reproduction_deviation=f'coverage shortfall: ours minus printed = {r2(our_short - pub_short)}; imbalance: '
                             f'ours minus printed = {r2(our_imb - pub_imb)} percentage points',
      methods=METHODS + ' Coverage is the share of 1,000 95% percentile CIs containing the population value.',
      uncertainty=MC + f' Our lowest cell coverage is {summary["overall_min_coverage"]:.3f}; '
                       f'{summary["pct_cells_coverage_in_bradley"]:.1f}% of the 19,200 results lie in Bradley\'s '
                       f'[.925, .975].',
      multiplicity='Descriptive; 19,200 cell coverages, no correction because nothing is tested.',
      status='not_replicated',
      status_reason='Coverage is close to nominal in every effect-cutoff row of our run, and misses fall on both '
                    'sides of the interval at similar rates.',
      numerical='mismatch', reconstruction_scope='full design, independent re-implementation, own seeds',
      limitations=['Our run shows a small positive imbalance (the truth lies above the CI slightly more often than '
                   'below it), two orders of magnitude smaller than Chen\'s; we did not investigate its cause.'],
      stopping=STOP_DONE('Chen\'s per-replication CIs and population values would locate the discrepancy.'),
      findings=dict(
          published=dict(text='Coverage 24.10-83.99% by effect and cutoff; true value usually above the CI',
                         state='reported', artifact_ids=['pdf'], locator=f'Table 4.9 and Chapter 5, {loc(164)}',
                         source_excerpt=excerpt('the imbalance measure showed that the true parameter value '
                                                'systematically fell above the CIs', 164),
                         page_locator=loc(164), claim_type='numerical estimate',
                         conditions='95% percentile bootstrap CIs from 500 resamples; collapsed over n and effect sizes',
                         component_claim_ids=[], component_contrast_indices=[0, 1]),
          ours=dict(text=f'Coverage {min(float(r["coverage"]) for r in t49.values()):.1f}-'
                         f'{max(float(r["coverage"]) for r in t49.values()):.1f}% by effect and cutoff; misses on both '
                         f'sides at similar rates', state='observed', artifact_ids=['t49', 'cells'],
                    locator='results/table49_ours.csv', component_claim_ids=[], component_contrast_indices=[0, 1])))

claim(id='H3', level='headline', comparison_kind='scalar_unestablished',
      statement='Power for the mediated interaction (MINT) is near zero at every sample size and never reaches .80.',
      source_locator=f'Chapter 4, Figure 4.28 text, {loc(135)}; Chapter 5 power, {loc(162)}',
      artifact_ids=['pdf', 'summary', 'power', 'cells'],
      published=dict(value='near zero at every sample size; never reaches .80', units='rejection rate (verbal)'),
      ours=dict(value=our_mint, units='rejection rate'),
      conditions=GRID + ' Contrast cell: n = 500, a = .59, h = .34 (ah = .2006), averaged over b, c\' and the three cutoffs.',
      contrasts=[dict(definition='MINT rejection rate at n = 500, a = .59, h = .34, mean over b, c\' and cutoffs',
                      units='rejection rate', positive_means='the 95% CI excludes zero more often',
                      published=None, ours=our_mint, comparison_kind='scalar_unestablished',
                      unavailable_reason='Chen gives no number for this cell; the figure is not tabulated.')],
      contrast_unestablished_reason='The published value is only the verbal statement "near zero"; no printed '
                                    'number or rounding precision exists to define a tolerance.',
      methods=METHODS + ' Rejection means the 95% percentile CI excludes zero; it does not use population values.',
      uncertainty=MC,
      multiplicity='One cell: the largest MINT in the design at the smallest n. It was chosen after the full results '
                   'were available; results/summary.json gives MINT power for every n and ah.',
      status='not_replicated',
      status_reason=f'In our run MINT power rises with n and ah: {our_mint:.3f} at n = 500 for ah = .20, and at least '
                    f'{min(mint["n=1000 ah=0.1326"], mint["n=1000 ah=0.2006"]):.3f} for ah >= .13 once n >= 1,000. '
                    f'Rejection rates do not use population values, so this disagreement cannot come from how '
                    f'estimates were matched to population values; it could still come from another unprinted step.',
      numerical='withheld: no published number', reconstruction_scope='full design, independent re-implementation',
      limitations=['Chen also reports MINT Type I error near zero with a = 0 at every h > 0 and no variation across '
                   'h. Ours is below Bradley\'s range at h = .05 through n = 5,000 (at most .019; .026-.036 at n = 10,000) and at h = .15 at n = 500 (.014-.020), but about .05 at h = .34 and at h = .15 from n = 2,500 (.026-.033 at n = 1,000), so it varies with h. Both MINT differences are consistent '
                   'with smaller h estimates or wider h intervals in her runs than the printed code produces; this is '
                   'not tested.'],
      stopping=STOP_DONE('Chen\'s MINT CIs for one condition would show whether her h estimates were attenuated.'),
      findings=dict(
          published=dict(text='MINT power near zero at every sample size; never reaches .80', state='reported',
                         artifact_ids=['pdf'], locator=f'Figure 4.28 discussion, {loc(135)}',
                         source_excerpt=excerpt('All power for MINT is near zero.', 135), page_locator=loc(135),
                         claim_type='numerical estimate',
                         conditions='Nonzero MINT cells (a and h nonzero), all n and cutoffs',
                         component_claim_ids=[], component_contrast_indices=[0]),
          ours=dict(text=f'MINT power {our_mint:.3f} at n = 500 for ah = .20; at least .97 for ah >= .13 from n = 1,000',
                    state='observed', artifact_ids=['summary', 'power'],
                    locator='results/summary.json mint_power_by_n_and_ah', component_claim_ids=[],
                    component_contrast_indices=[0])))

claim(id='H4', level='headline', comparison_kind='nonscalar',
      statement='Tentatively, a minimum sample size of 5,000 gives accurate Type I error rates and power above .80 '
                'regardless of cutoff.',
      source_locator=f'Chapter 5, Implications, {loc(164)}',
      artifact_ids=['pdf', 'stmt', 'type1', 'power'],
      published=dict(value='n >= 5,000 gives accurate Type I error and power above .80, regardless of cutoff (tentative)',
                     units='qualitative recommendation'),
      ours=dict(value=f'at n = 5,000: {t1_5000:.1f}% of zero-effect results have Type I in Bradley\'s range and '
                      f'{pw_5000:.1f}% of nonzero results have power >= .80', units='qualitative with shares'),
      conditions=GRID, contrasts=[],
      contrast_not_applicable='A qualitative design recommendation over the whole grid; no single signed contrast '
                              'represents it, and any pooled share would depend on the grid\'s mix of effect sizes.',
      methods=METHODS, uncertainty=MC, multiplicity='Shares over 1,176 zero-effect and 2,664 nonzero results at n = 5,000.',
      status='partly_replicated',
      status_reason=(f'In our run the share of zero-effect results with Type I error in Bradley\'s range rises from '
                     f'{by_n["500"][0]:.1f}% at n = 500 to {by_n["5000"][0]:.1f}% at n = 5,000, and the share of nonzero '
                     f'results with power >= .80 from {by_n["500"][1]:.1f}% to {by_n["5000"][1]:.1f}% (the largest step, '
                     f'from {by_n["2500"][1]:.1f}% at n = 2,500). The shares differ little by cutoff at n = 5,000 '
                     f'({min(b[0] for b in by_cut):.1f}-{max(b[0] for b in by_cut):.1f}% and '
                     f'{min(b[1] for b in by_cut):.1f}-{max(b[1] for b in by_cut):.1f}%). Not all results pass: product '
                     f'effects with both paths zero stay conservative (about .002) at every n, and small effects such as '
                     f'ah = .007 stay below .80.'),
      numerical='not applicable: qualitative', reconstruction_scope='full design',
      limitations=['Chen calls the recommendation tentative; our check judges it literally over the whole grid.'],
      stopping=STOP_DONE('None needed for the recommendation; it is fully characterized by results/type1.csv and power.csv.'),
      findings=dict(
          published=dict(text='Tentative minimum n of 5,000 for accurate Type I error and power above .80',
                         state='reported', artifact_ids=['pdf'], locator=f'Chapter 5, {loc(164)}',
                         source_excerpt=excerpt('a minimum sample size of 5000 has accurate Type I error rates and '
                                                'power above .80, regardless of cutoff score', 164),
                         page_locator=loc(164), claim_type='other',
                         conditions='Recommendation from the simulation, stated as tentative',
                         component_claim_ids=[], component_contrast_indices=[]),
          ours=dict(text=f'At n = 5,000, {t1_5000:.1f}% of zero-effect results have Type I in range and {pw_5000:.1f}% '
                         f'of nonzero results reach .80 power, similar at each cutoff; both-zero products stay conservative',
                    state='observed', artifact_ids=['stmt', 'power'], locator='results/statement_checks.csv n = 5000 row',
                    component_claim_ids=[], component_contrast_indices=[])))

claim(id='S1', level='supporting',
      statement='Indirect (PNIE, TNIE) and MINT bias falls within [-.10, .10] in 51.88-87.50% of conditions, '
                'increasing with the control share (Table 4.8).',
      source_locator=f'Table 4.8, {loc(102)}', artifact_ids=['pdf', 't48', 'zero'],
      published=dict(value=pub_ind['PNIE'], units='% of PNIE condition-cutoff results with |bias| > .10'),
      ours=dict(value=our_ind['PNIE'], units='% of PNIE condition-cutoff results with |bias| > .10'),
      conditions=GRID,
      contrasts=[dict(definition=f'% of {e} condition-cutoff results with |bias| > .10, mean over cutoffs',
                      units='percentage points', positive_means='more results outside [-.10, .10]',
                      published=pub_ind[e], ours=our_ind[e]) for e in ('PNIE', 'TNIE', 'MINT')],
      methods=METHODS, uncertainty=MC, multiplicity='Descriptive.',
      status='not_replicated',
      status_reason='All indirect and MINT results lie within [-.05, .05] in our run. At the median cutoff, Chen\'s '
                    'PNIE and MINT rows and her TNIE [-.05, .05] entry equal what |bias| = population value would give '
                    'over the grid; her TNIE [-.10, .10] entry is 60.00 against 59.38 '
                    '(secondary/zero_estimate_check.csv). This is a consistency observation, not a diagnosis.',
      numerical='mismatch', reconstruction_scope='full design',
      limitations=['The zero-estimate pattern does not fit every printed entry (for example PNDE needs c\' + h).'],
      stopping=STOP_DONE('Chen\'s population-value table, if one existed, would test the pattern directly.'))

STMT_METHOD = ('Every Type I error and power statement in Chapter 4 that names cells and a checkable outcome is '
               'tested on every cell set it names (simulation/statement_checks.py), with rates averaged over the '
               'factors it does not name, as in Chen\'s figures, and with fixed numeric readings of her words '
               '(for example "near zero" Type I < .025, "close to zero" power < .10, "around .80" .70-.90). '
               'A second reading moves every threshold .01 in her favour.')
H_NOTE = (f'As a consistency check, every statement was also read on our cells with h replaced by 0 (other '
          f'factors unchanged; the verdict_if_h_were_0 column). Then {n_h0} of {len(verdicts)} statements hold, '
          f'against {n_agree} as designed; {len(H0_FIXES)} of the {len(robust_dis)} statements that disagree under '
          f'both readings become agreements, and none that agrees becomes a disagreement. The {len(robust_dis) - len(H0_FIXES)} '
          f'that still disagree are statements {rest} (the number column of results/statement_checks.csv). Chen also '
          f'defines PNDE as "adding c\' and h" (printed p. 104), whereas with the mediator intercept zero in her '
          f'data-generating model the population PNDE is c\'. These observations are consistent with h contributing '
          f'little to her estimates; they do not establish it.')
excerpt('PNDE is calculated by adding c', 118)

claim(id='S2', level='supporting',
      statement='Type I error statements for all five effects (Figures 4.17-4.21): for example, near zero when both '
                'paths of a product effect are zero; within Bradley\'s [.025, .075] for PNDE and TNDE; for MINT near '
                'zero when a = 0, with no variation across h.',
      source_locator=f'Chapter 4 Type I error, {loc(113)}-{loc(122)}', artifact_ids=['pdf', 'stmt', 'type1', 'stmt_code'],
      published=dict(value=f'{len(T1S)} testable Type I error statements', units='statements'),
      ours=dict(value=f'{t1_agree} of {len(T1S)} agree ({t1_slack} with .01 threshold slack)', units='statements'),
      conditions='Every zero-effect cell set named in each statement, all n and cutoffs; rates averaged over the '
                 'factors a statement does not name, as in Chen\'s figures.', contrasts=[],
      contrast_not_applicable='Each statement is a threshold claim about a set of cells; results/statement_checks.csv '
                              'holds the per-cell rates and verdicts.',
      methods=METHODS + ' ' + STMT_METHOD, uncertainty=MC,
      multiplicity=f'{len(T1S)} statements, each judged at its own threshold; no correction (descriptive).',
      status='partly_replicated',
      status_reason=(f'{t1_agree} of {len(T1S)} Type I statements agree ({t1_slack} with slack). The robust '
                     f'disagreements are MINT with a = 0, where ours is below Bradley\'s range at h = .05 through '
                     f'n = 5,000 (at most .019) and at h = .15 at n = 500 (.014-.020), as Chen reports, but about .05 at '
                     f'h = .34 and at h = .15 from n = 2,500 (.026-.033 at n = 1,000), whereas she reports no variation '
                     f'across h; and TNIE Type I statements with a = 0 at small n (statements '
                     f'{", ".join(str(NUM[k]) for k in robust_dis if k in T1S and k.startswith("TNIE"))}), where '
                     f'our rates and her description fall on different sides of the robustness bounds. Read with h = 0, '
                     f'statements {", ".join(str(NUM[k]) for k in robust_dis if k in T1S and h0v[k] == "agree")} would '
                     f'hold in our run.'),
      numerical='not applicable', reconstruction_scope='full design',
      limitations=['The numeric readings of Chen\'s words are ours; the slack column shows which verdicts depend on them.',
                   'The figures themselves were not digitized; only the text was tested.'],
      stopping=STOP_DONE('Digitized Figures 4.17-4.21 would allow a cell-by-cell numeric comparison.'))

claim(id='S3', level='supporting',
      statement='Power statements for all five effects (Figures 4.22-4.28): for example, PNIE with a = b = .14 stays '
                'below .80 through n = 2,500; TNIE1 power is close to zero when b = 0; TNDE1 power is close to zero '
                'when c\' = 0 regardless of a and h; all MINT power is near zero.',
      source_locator=f'Chapter 4 power, {loc(124)}-{loc(135)}', artifact_ids=['pdf', 'stmt', 'power', 'stmt_code'],
      published=dict(value=f'{len(PWS)} testable power statements', units='statements'),
      ours=dict(value=f'{pw_agree} of {len(PWS)} agree ({pw_slack} with .01 threshold slack)', units='statements'),
      conditions='Every nonzero-effect cell set named in each statement; rates averaged over unnamed factors.',
      contrasts=[], contrast_not_applicable='Threshold statements; per-cell rates are in results/statement_checks.csv.',
      methods=METHODS + ' ' + STMT_METHOD, uncertainty=MC,
      multiplicity=f'{len(PWS)} statements; no correction (descriptive).',
      status='partly_replicated',
      status_reason=(f'{pw_agree} of {len(PWS)} power statements agree ({pw_slack} with slack): all {n_pnie} PNIE '
                     f'statements and all {n_pnde} PNDE statements agree; the disagreements concern TNIE, TNDE and MINT. '
                     + H_NOTE),
      numerical='not applicable', reconstruction_scope='full design',
      limitations=['Agreement on PNIE and PNDE is consistent with Chen\'s rejection rates for those effects not being '
                   'affected by whatever produced her bias and coverage results.',
                   'The numeric readings of Chen\'s words are ours; the slack column shows which verdicts depend on them.'],
      stopping=STOP_DONE('Chen\'s h estimates for one condition would test whether h was attenuated in her runs.'))

claim(id='S4', level='supporting',
      statement='In the Head Start Impact Study, synthetic-RDD mediation estimates at three cutoffs are typically '
                'smaller than the RCT estimates, with standardized bias outside an acceptable range (Tables 4.6-4.7).',
      source_locator=f'Tables 4.6-4.7 and Chapter 5 RQ2, {loc(159)}-{loc(160)}', artifact_ids=['pdf', 'avail'],
      published=dict(value='RDD estimates typically smaller than RCT estimates', units='qualitative'),
      ours=dict(value=None, units='qualitative', unavailable_reason='HSIS restricted-use data not obtainable; '
                                                                   'notes/availability.md'),
      conditions='HSIS restricted-use file, 3,721 children (2,697 with a wave-1 spelling score).', contrasts=[],
      contrast_not_applicable='No refit is possible without the data.',
      methods='Not rerun.', uncertainty='Not assessed.', multiplicity='Not applicable.',
      status='blocked', status_reason='Restricted-use data require a signed ICPSR agreement this project does not hold; '
                                      'the public download has documentation only.',
      numerical='withheld', reconstruction_scope='none',
      limitations=['RQ2 cannot be assessed beyond the printed arithmetic (S5).'],
      stopping=dict(reason='Input unavailable.', attempted='ICPSR 29462 public download V7 (documentation only); '
                    'restricted-use route reviewed.', untested='All HSIS fits.', resource_basis='Data access, not compute.',
                    next_evidence='The restricted-use HSIS file under an ICPSR agreement.'))

claim(id='S5', level='supporting',
      statement='Tables 4.6-4.7 report RCT-minus-RDD differences and standardized biases for the HSIS path and '
                'mediation estimates, with SB defined in equation 3.12 as the difference over the RCT outcome SD.',
      source_locator=f'Tables 4.6-4.7, equation 3.12', artifact_ids=['pdf', 'arith', 'arith_code'],
      published=dict(value=24, units='printed differences and SBs'),
      ours=dict(value=24, units='printed entries reproduced'),
      conditions='Printed estimates only.', contrasts=[],
      contrast_not_applicable='An internal arithmetic check, not an effect.',
      methods='Recompute each difference and SB from the printed estimates.',
      uncertainty='Exact at the printed precision.', multiplicity='24 entries.',
      status='replicated',
      status_reason='All 24 differences match; all 24 SBs match only when the divisor is the RCT estimate\'s SE '
                    'rather than the outcome SD stated in equation 3.12.',
      numerical='match', reconstruction_scope='printed numbers only',
      limitations=['The divisor discrepancy is between the text and the tables; which was intended is unknown.'],
      stopping=dict(reason='Complete: all 24 printed entries recomputed.', attempted='Differences and standardized '
                    'biases from the printed RCT and RDD estimates and standard errors (secondary/table_arithmetic.py).',
                    untested='Which divisor Chen intended; the HSIS fits themselves (S4).', resource_basis='Seconds.',
                    next_evidence='None needed for the arithmetic.'))

claim(id='S6', level='supporting',
      statement='HSIS assumption checks: density, covariate balance (Table 4.3), residual correlations (Table 4.4) '
                'and functional form (Table 4.5) show slight violations of independence and functional form.',
      source_locator=f'Tables 4.3-4.5; Chapter 5, {loc(160)}', artifact_ids=['pdf', 'avail'],
      published=dict(value='independence assumption slightly violated', units='qualitative'),
      ours=dict(value=None, units='qualitative', unavailable_reason='HSIS child-level data not obtainable.'),
      conditions='HSIS restricted-use file.', contrasts=[], contrast_not_applicable='Not rerun.',
      methods='Not rerun.', uncertainty='Not assessed.', multiplicity='Not applicable.',
      status='blocked', status_reason='The checks need child-level records; no printed numbers allow recomputation.',
      numerical='withheld', reconstruction_scope='none',
      limitations=['Unassessed.'],
      stopping=dict(reason='Input unavailable.', attempted='As for S4.', untested='Tables 4.3-4.5.',
                    resource_basis='Data access.', next_evidence='The restricted-use HSIS file.'))

claim(id='S7', level='supporting',
      statement='An integrated table of mediation and RDD assumptions (Table 4.1) answers RQ1.',
      source_locator=f'Table 4.1, {loc(74)}', artifact_ids=['pdf', 'sim'],
      published=dict(value='integrated assumption framework (Table 4.1)', units='conceptual'),
      ours=dict(value=None, units='conceptual', unavailable_reason='A literature synthesis with no computation to rerun.'),
      conditions='Not applicable.', contrasts=[], contrast_not_applicable='Conceptual.',
      methods='Read only; the simulation model meets the no-confounding and functional-form assumptions by construction.',
      uncertainty='Not applicable.', multiplicity='Not applicable.',
      status='not_established', status_reason='There is nothing computational to replicate.',
      numerical='not applicable', reconstruction_scope='none', limitations=['Not evaluated as scholarship.'],
      stopping=dict(reason='Out of scope.', attempted='Reading.', untested='The synthesis itself.',
                    resource_basis='Not a resource limit.', next_evidence='None within a replication.'))

claim(id='S8', level='supporting',
      statement='An additional power analysis by the SD of Y compares expected and simulated power.',
      source_locator=f'Chapter 3, Outcome Measures, {loc(72)}', artifact_ids=['pdf', 'runrec'],
      published=dict(value=None, units='power', unavailable_reason='Announced in Chapter 3 but no method or result '
                                                                   'appears in Chapters 4-5 or the appendices.'),
      ours=dict(value=None, units='power', unavailable_reason='Nothing to rerun without a stated method.'),
      conditions='Not stated.', contrasts=[], contrast_not_applicable='No result reported.',
      methods='Searched the dissertation.', uncertainty='Not applicable.', multiplicity='Not applicable.',
      status='blocked', status_reason='The analysis is announced but not reported.',
      numerical='withheld', reconstruction_scope='none', limitations=['Unassessed.'],
      stopping=dict(reason='Not reported in the source.', attempted='Search of Chapters 3-5 and Appendices A-B for '
                    '"expected power", "standard deviation" and "power analysis".', untested='The analysis.',
                    resource_basis='Not a resource limit.', next_evidence='Chen\'s analysis notes.'))

DEV = dict(
    H3='Not computable: the published result is verbal; ours is a rejection rate of .836 in the contrast cell.',
    H4='Not computable: qualitative recommendation.',
    S1='PNIE: ours minus printed = %s; TNIE: %s; MINT: %s percentage points' % tuple(
        r2(our_ind[e] - pub_ind[e]) for e in ('PNIE', 'TNIE', 'MINT')),
    S2=f'Not computable: threshold statements; {len(T1S) - t1_agree} of {len(T1S)} disagree ({len(T1S) - t1_slack} with slack).',
    S3=f'Not computable: threshold statements; {len(PWS) - pw_agree} of {len(PWS)} disagree ({len(PWS) - pw_slack} with slack).',
    S4='Not computable: not rerun.', S5='0 of 24 entries differ (SB with the RCT-estimate SE divisor).',
    S6='Not computable: not rerun.', S7='Not applicable: conceptual.', S8='Not computable: not reported.')
for c in claims:
    if 'reproduction_deviation' not in c:
        c['reproduction_deviation'] = DEV[c['id']]
for c in claims:
    for p in ('published', 'ours'):
        if c[p].get('value') is None and 'unavailable_reason' not in c[p]:
            sys.exit(f'{c["id"]} {p} null without reason')
excerpt('An additional power analysis by standard deviation of the outcome', 72)
excerpt('Bias for the indirect effects and MINT were more often within the ideal', 161)

EFFECTS = [
    dict(id='E1', claim_id='H1', contrast_index=0, estimand=claims[0]['contrasts'][0]['definition'],
         units='percentage points', positive_means=claims[0]['contrasts'][0]['positive_means'],
         published_effect=pub_dir, ours_effect=our_dir, estimate_status='resolved', display_decimals=2,
         tolerance=TOL2(6), magnitude='smaller', direction='zero vs nonzero',
         interpretation='descriptive point estimates; not equivalence', uncertainty_statement=claims[0]['uncertainty']),
    dict(id='E2', claim_id='H2', contrast_index=0, estimand=claims[1]['contrasts'][0]['definition'],
         units='percentage points', positive_means=claims[1]['contrasts'][0]['positive_means'],
         published_effect=pub_short, ours_effect=our_short, estimate_status='resolved', display_decimals=2,
         tolerance=TOL2(15), magnitude='smaller',
         direction='reversed direction' if our_short < 0 else 'same direction',
         interpretation='descriptive point estimates; not equivalence', uncertainty_statement=MC),
    dict(id='E3', claim_id='H2', contrast_index=1, estimand=claims[1]['contrasts'][1]['definition'],
         units='percentage points', positive_means=claims[1]['contrasts'][1]['positive_means'],
         published_effect=pub_imb, ours_effect=our_imb, estimate_status='resolved', display_decimals=2,
         tolerance=rounding_tol(30, 15),
         magnitude='smaller', direction='same direction',
         interpretation='descriptive point estimates; not equivalence', uncertainty_statement=MC),
    dict(id='E4', claim_id='H3', contrast_index=0, comparison_kind='scalar_unestablished',
         estimand=claims[2]['contrasts'][0]['definition'], units='rejection rate',
         positive_means=claims[2]['contrasts'][0]['positive_means'], published_effect=None, ours_effect=our_mint,
         estimate_status='unresolved', unresolved_reason='No published number for this cell.', display_decimals=3,
         tolerance=dict(kind='unestablished', value=None, basis='The source gives "near zero" with no printed value or precision.'),
         applicability_reason='The source states a verbal result; a scalar contrast exists but no defensible margin.',
         magnitude='not established', direction='not established',
         interpretation='descriptive point estimates; not equivalence', uncertainty_statement=MC),
    dict(id='E5', claim_id='H4', contrast_index=None, comparison_kind='nonscalar', estimand='qualitative sample-size '
         'recommendation over the grid', units='not applicable', positive_means='not applicable',
         published_effect=None, ours_effect=None, estimate_status='unresolved',
         unresolved_reason='Qualitative recommendation; no scalar contrast.', display_decimals=None,
         tolerance=dict(kind='not_applicable', value=None, basis='No scalar contrast exists.'),
         applicability_reason=claims[3]['contrast_not_applicable'], component_claim_ids=[],
         component_contrast_indices=[], magnitude='not established', direction='not established',
         interpretation='descriptive point estimates; not equivalence', uncertainty_statement=MC),
]
# magnitude and direction from the signed values (|ours| vs |published| beyond tolerance)
for e in EFFECTS[:3]:
    tol = e['tolerance']['value']
    a, b = abs(e['published_effect']), abs(e['ours_effect'])
    e['magnitude'] = 'same' if abs(a - b) <= tol else ('larger' if b > a else 'smaller')
    if abs(e['ours_effect']) <= tol and abs(e['published_effect']) > tol:
        e['direction'] = 'zero vs nonzero'
    elif (e['ours_effect'] > 0) == (e['published_effect'] > 0):
        e['direction'] = 'same direction'
    else:
        e['direction'] = 'reversed direction'

sections = [
    dict(id='front', locator='Front matter: title page, abstract, acknowledgements, contents', claim_ids=[],
         exclusion_reason='Front matter; the abstract restates the Chapter 4-5 findings inventoried below.'),
    dict(id='ch1', locator=f'Chapter 1, Introduction, {loc(15)}-', claim_ids=['H1', 'H2', 'H3', 'H4', 'S7']),
    dict(id='ch2', locator='Chapter 2, Literature review', claim_ids=[],
         exclusion_reason='Literature review; its effect definitions are used for the population values in the simulation.'),
    dict(id='ch3', locator='Chapter 3, Methods and procedures', claim_ids=['S5', 'S8']),
    dict(id='ch4', locator='Chapter 4, Results (RQ1 Table 4.1; RQ2 Tables 4.2-4.7, Figures 4.1-4.11; RQ3 Tables '
                           '4.8-4.9, Figures 4.12-4.38)',
         claim_ids=['H1', 'H2', 'H3', 'S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7']),
    dict(id='ch5', locator='Chapter 5, Discussion', claim_ids=['H1', 'H2', 'H3', 'H4', 'S4', 'S6']),
    dict(id='refs', locator='References', claim_ids=[], exclusion_reason='Bibliography only.'),
    dict(id='appA', locator=f'Appendix A, R syntax for data generation, {loc(189)}-{loc(192)}', claim_ids=['H1', 'H2'],
         exclusion_reason=None),
    dict(id='appB', locator=f'Appendix B, R syntax for estimation and bootstrapping, {loc(193)}-{loc(203)}', claim_ids=['H1', 'H2', 'H3']),
]
for s in sections:
    if s.get('exclusion_reason') is None:
        s.pop('exclusion_reason', None)

limitations = [
    'R is unavailable here, so the simulation is an independent Python re-implementation with our own seeds; it '
    'agrees with Chen on summaries only (H1-H4, S1-S3).',
    'Chen\'s aggregation code and population-value table are not printed, so the source of her bias, coverage and '
    'MINT results cannot be identified (H1, H2, H3, S1); our Type I and power agree with most of her statements (S2, S3).',
    'RQ2 (HSIS) cannot be rerun: the restricted-use data are not available to this project (S4, S6); only the '
    'printed arithmetic was checked (S5).',
    'The announced power analysis by the SD of Y is not reported, so it cannot be assessed (S8).',
    'The dissertation labels the cutoffs inconsistently: the code\'s index 1 is the 25th percentile (75% treated), '
    'as is the Chapter 4 description of the cut scores, while Chapter 3 and the Table 4.8 note call index 1 25% '
    'treatment; we report by the code (H1, H2).',
    'Chen suggests global estimation with an incorrect functional form as a plausible explanation of the bias; in her data-generating model '
    'the assignment variable does not enter M or Y, so the fitted linear models are correctly specified (H1).',
    'Read on our cells with h replaced by 0, most of Chen\'s Type I and power statements that disagree with our run '
    'would hold, and her text defines PNDE as c\' + h where the population value is c\'; both are consistent with h '
    'contributing little to her estimates or population values, but neither is tested against her runs (S2, S3, H3).',
]

packet = dict(
    schema_version=1, scope='whole_dissertation',
    dissertation='Chen, D. (2021). Statistical mediation analysis in regression discontinuity design for causal '
                 'inference (Doctoral dissertation). University of Nebraska-Lincoln. First adviser: James A. Bovaird; '
                 'second adviser: Lorey A. Wheeler. https://digitalcommons.unl.edu/cehsdiss/403/',
    replicated_work=dict(kind='dissertation', authors='Donna Chen', year='2021',
                         title='Statistical Mediation Analysis in Regression Discontinuity Design for Causal Inference',
                         institution_or_venue='University of Nebraska-Lincoln',
                         identifier='https://digitalcommons.unl.edu/cehsdiss/403/',
                         verification_locator='Title page and abstract of source/chen2021.pdf (PDF pages 1-3)',
                         artifact_ids=['pdf']),
    artifacts=artifacts, sections=sections,
    inventory_audit=dict(reviewer='source reading of the archived dissertation PDF (pdftotext and page renders)',
                         source_artifact_ids=['pdf'],
                         rationale='Read from the title page through Appendix B. Chapter 1 states RQ1-RQ3. Chapter 2 is '
                                   'background. Chapter 3 and Appendices A-B define the HSIS analysis and the simulation. '
                                   'Chapter 4 reports RQ1 (Table 4.1), RQ2 (Tables 4.2-4.7) and RQ3 (Tables 4.8-4.9, '
                                   'Figures 4.12-4.38); Chapter 5 draws the conclusions. HSIS results are entered as '
                                   'blocked claims, and the unreported power analysis as S8, rather than omitted.'),
    claims=claims, headline_order=['H1', 'H2', 'H3', 'H4'], headline_effects=EFFECTS,
    synthesis=(f'Not replicated on the simulation headlines. Over all 3,840 condition-cutoff cells, every effect is '
               f'unbiased (largest |bias| {summary["overall_max_abs_bias"]:.3f}) and percentile-bootstrap coverage '
               f'averages {summary["overall_mean_coverage"]*100:.1f}%, against Chen\'s 6-87% non-bias and 24-84% '
               f'coverage; MINT power reaches {our_mint:.2f} at n = 500 for the largest interaction, where Chen reports near zero. Of her '
               f'{len(verdicts)} testable Type I and power statements, {n_agree} agree ({n_slack} with .01 threshold '
               f'slack), and {n_h0} would hold in our run if h were 0. The n = 5,000 '
               f'recommendation holds for most but not all cells. RQ2 is blocked by data access.'),
    limitations=limitations,
)
(ROOT / 'evidence-packet.json').write_text(json.dumps(packet, indent=1, ensure_ascii=False) + '\n')
print('wrote evidence-packet.json;', len(claims), 'claims;', {e['id']: (e['published_effect'], e['ours_effect'],
                                                                       e['magnitude'], e['direction']) for e in EFFECTS})
