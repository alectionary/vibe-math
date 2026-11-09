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
rfull = json.load(open(ROOT / 'results/r_full_comparison.json'))
dtests = json.load(open(ROOT / 'results/disagreement_tests.json'))
pop = dtests['population.patterns']
bstruct = {(r['figure'], int(r['cut_index'])): r for r in rows('results/bias_structure.csv')}
ragree = {r['figure']: r for r in rows('results/rates_agreement.csv')}
emp = json.load(open(ROOT / 'results/empirical_consistency.json'))
tident = json.load(open(ROOT / 'results/table_identities.json'))
import yaml
DIS = yaml.safe_load(open(ROOT / 'DISAGREEMENTS.yaml'))['disagreements']
DIS_CONC = {d['id']: d['conclusion'] for d in DIS}
# E4: Chen's MINT power at n = 500, a = .59, h = .34 read from Figure 4.28 (mean over cutoffs)
_e4 = [r for r in rows('results/digitized_rates.csv') if r['figure'] == '4.28' and r['n'] == '500'
       and r['a'] == '0.59' and r['h'] == '0.34']
assert len(_e4) == 3, _e4
pub_mint_raw = round(sum(float(r['chen_value']) for r in _e4) / 3, 3)
pub_mint_cuts = [round(float(r['chen_value']), 3) for r in sorted(_e4, key=lambda r: r['cut_index'])]
import math as _m
# mean reading error of the three points, rounded DOWN to 4 decimals (never up)
e4_read_err = _m.floor(sum(float(r['reading_error']) for r in _e4) / 3 * 1e4) / 1e4
e4_status = {r['cut_index']: r['status'] for r in _e4}
NOMINAL = 0.05
pub_mint = round(sum(float(r['chen_value']) for r in _e4) / 3 - NOMINAL, 4)
fig_t1_pw = [f'4.{i}' for i in range(17, 29)]
pct_h0 = [float(ragree[f]['pct_agree_if_h_were_0']) for f in fig_t1_pw]
pct_h = [float(ragree[f]['pct_agree']) for f in fig_t1_pw]
n_dis = len(DIS)
n_expl = sum(c == 'explained' for c in DIS_CONC.values())
n_part = sum(c == 'partly_explained' for c in DIS_CONC.values())
n_unexpl = sum(c == 'unexplained' for c in DIS_CONC.values())
ident_hold = sum(i['holds'] for i in emp['identities'])
t43 = tident['table_4_3_t_equals_coef_over_se']
t43_hold = sum(r['holds'] for r in t43)
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
our_mint_raw = round(mint['n=500 ah=0.2006'], 3)
our_mint = round(our_mint_raw - 0.05, 3)
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
    ('r_code', 'r-reproduction/chen_exact.R'), ('r_rows', 'r-reproduction/out/estimates.csv'),
    ('r_literal', 'r-reproduction/out/literal_check.txt'),
    ('r_full', 'r-reproduction/out-full/condition_summary.csv'), ('r_full_run', 'r-reproduction/out-full/RUN.md'),
    ('r_full_literal', 'r-reproduction/out-full/literal_check.txt'),
    ('r_cmp_code', 'secondary/r_full_comparison.py'), ('r_cmp', 'results/r_full_comparison.json'),
    ('dig_bias_code', 'secondary/digitize_bias_figures.py'), ('dig_bias', 'results/digitized_bias.csv'),
    ('dig_rates_code', 'secondary/digitize_raster_figures.py'), ('dig_rates', 'results/digitized_rates.csv'),
    ('dig_imb_code', 'secondary/digitize_imbalance_figures.py'), ('dig_imb', 'results/digitized_imbalance.csv'),
    ('dig_cross', 'results/digitize_crosscheck.csv'), ('rates_agree', 'results/rates_agreement.csv'),
    ('bias_struct', 'results/bias_structure.csv'),
    ('dis', 'DISAGREEMENTS.yaml'), ('dis_code', 'secondary/disagreement_tests.py'),
    ('dis_tests', 'results/disagreement_tests.json'),
    ('emp_code', 'secondary/empirical_consistency.py'), ('emp', 'results/empirical_consistency.json'),
    ('identities', 'results/table_identities.json'),
    ('sv_readme', 'source-values/README.md'), ('sv_31', 'source-values/table_3_1.csv'),
    ('sv_42', 'source-values/table_4_2.csv'), ('sv_43', 'source-values/table_4_3.csv'),
    ('sv_48', 'source-values/table_4_8.csv'), ('sv_49', 'source-values/table_4_9.csv'),
    ('inventory', 'source-inventory.json'),
    ('sv_47', 'source-values/table_4_7.csv'), ('sig_code', 'secondary/significance_conclusions.py'),
    ('sig', 'results/significance_conclusions.json'), ('r_cmp_csv', 'results/r_full_comparison.csv'),
    ('mcse_code', 'secondary/mc_se_headline.py'), ('mcse', 'results/mc_se_headline.json'),
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


mcse = json.load(open(ROOT / 'results/mc_se_headline.json'))
MC_HEAD = lambda e: (MC + f' Our {e} mean over 19,200 cells has a Monte Carlo standard error of about '
                     f'{mcse[e]["se_cells_independent"]:.3f} percentage points if cells are independent and '
                     f'{mcse[e]["se_cells_correlated_within_condition"]:.3f} if cells within a condition are fully '
                     f'correlated (results/mc_se_headline.json).')
claims = []


def claim(**kw):
    claims.append(kw)


GRID = ('Full factorial of Table 3.1: n in {500, 1000, 2500, 5000, 10000}, a, b, c\' in {0, .14, .39, .59}, '
        'h in {0, .05, .15, .34}; three cutoffs (25th, 50th, 75th percentile of x). Expected 3,840 condition-cutoff '
        'cells; completed 3,840 at 1,000 replications and 500 percentile-bootstrap resamples.')
METHODS = ('Two engines. Chen\'s own seeded R code (Appendices A-B) was replayed exactly with R 4.1.3 and the '
           '2021-08-02 package snapshot on an R-capable host (issues #92 and #118): the datasets her printed, '
           'seeded code generates are identical to her literal printed pipeline (largest difference 0), first 64,000 '
           'of them (50 replications per condition), then all 1,280,000 (1,000 per condition). This reproduces what '
           'her printed code produces; it is not necessarily the data behind her published results, which the '
           'h-absent analysis shows lacked the interaction wherever h > 0 (DISAGREEMENTS.yaml). '
           'Her bootstrap sets no seed, so the full simulation with 500 bootstrap resamples per analysis ran in an '
           'independent Python/NumPy re-implementation (validated against scikit-learn OLS and explicit resampling; '
           'the first run used Python without asking the person, who then agreed to keep it for the bootstrap, '
           'simulation/fallback.json); bootstrap-based agreement is judged on summaries. Chen\'s figures 4.12-4.38 '
           'were digitized: 4.12-4.16 exactly from the PDF drawing paths (reading error at most .002), 4.17-4.38 from '
           'images (reading errors up to about .02).')
RFULL = (f'Her printed code, replayed over all 1,000 replications: largest condition-mean bias {rfull["max_abs_r_bias"]:.3f} '
         f'(0% beyond .10); {100*rfull["share_abs_bias_z_gt_1.96"]:.1f}% of 19,200 cell biases beyond 1.96 Monte Carlo SEs '
         f'and {100*rfull["share_abs_bias_z_gt_3.29"]:.2f}% beyond 3.29, as expected with no bias; her estimates and ours '
         f'differ beyond 1.96 combined SEs in {100*rfull["share_abs_diff_z_gt_1.96"]:.1f}% of cells; median SD ratio '
         f'{rfull["sd_ratio_ours_over_r_median"]:.3f}; slope of estimated on true h '
         f'{min(rfull["h_slope_by_cut"].values()):.4f}-{max(rfull["h_slope_by_cut"].values()):.4f} '
         f'(results/r_full_comparison.json).')
MC = ('With 1,000 replications, a cell coverage near .95 has a binomial standard error of about .007 and a '
      'rejection rate near .05 about .007. Chen reports no Monte Carlo error.')
STOP_DONE = lambda why: dict(reason='Full design completed.', attempted='All 3,840 condition-cutoff cells at the '
                             'printed replication and bootstrap counts.', untested='Chen\'s own R output and seeds.',
                             resource_basis='13.7 core-hours (Python); 3.4 hours for the full R replay.', next_evidence=why)

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
      status_reason=('Every direct-effect result in our run lies within [-.05, .05]. ' + RFULL + ' Her digitized bias '
                     f'(Figures 4.12-4.16) is an almost exact function of the design with no dependence on n: MINT '
                     f'{bstruct[("4.16", 1)]["coef_ah"]}*ah; PNDE {bstruct[("4.14", 1)]["coef_c"]}, '
                     f'{bstruct[("4.14", 2)]["coef_c"]}, {bstruct[("4.14", 3)]["coef_c"]} times c\' by cutoff plus about '
                     f'{bstruct[("4.14", 1)]["coef_h"]}*h (results/bias_structure.csv). DISAGREEMENTS.yaml entries '
                     'h-absent, population-values and pnde-definition give the competing explanations and tests.'),
      numerical='mismatch', reconstruction_scope='full design, independent re-implementation, own seeds',
      limitations=['Chen\'s step that compared estimates with population values is not printed; the mechanism is '
                   'inferred from her digitized figures and tables (DISAGREEMENTS.yaml population-values: partly '
                   'explained), not read from her code.'],
      stopping=STOP_DONE('Chen\'s result files or aggregation code would confirm the per-case rule directly.'),
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
      status_reason=('Coverage is close to nominal in every effect-cutoff row of our run, and misses fall on both '
                     'sides of the interval at similar rates. Her digitized coverage of nonzero PNIE falls with n to a '
                     f'plateau of {pop["PNIE_coverage_by_cut_and_n_nonzero_paths"]["1"]["10000"]}, '
                     f'{pop["PNIE_coverage_by_cut_and_n_nonzero_paths"]["2"]["10000"]} and '
                     f'{pop["PNIE_coverage_by_cut_and_n_nonzero_paths"]["3"]["10000"]} at cutoffs 1-3 (the control share '
                     'under her code), with the truth above the interval in about the treated share; a wrong population '
                     'value per condition would drive coverage toward 0 instead. Her PNIE Type I and power agree with ours '
                     f'in {ragree["4.17"]["pct_agree"]}% and {ragree["4.22"]["pct_agree"]}% of points, so her intervals '
                     'sit where ours do; only the comparison with population values differs (DISAGREEMENTS.yaml '
                     'population-values).'),
      numerical='mismatch', reconstruction_scope='full design, independent re-implementation, own seeds',
      limitations=['Our run shows a small positive imbalance (the truth lies above the CI slightly more often than '
                   'below it), two orders of magnitude smaller than Chen\'s; we did not investigate its cause.',
                   'Which per-case rule produced her population values is not determined: one rule fits cutoffs 1-2 '
                   'but not cutoff 3 exactly, and a step written for her text\'s reversed cutoff labels predicts the '
                   'same plateau.'],
      stopping=STOP_DONE('Chen\'s per-replication CIs and population values would identify the rule.'),
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

claim(id='H3', level='headline',
      statement='Power for the mediated interaction (MINT) is near zero at every sample size and never reaches .80.',
      source_locator=f'Chapter 4, Figure 4.28 text, {loc(135)}; Chapter 5 power, {loc(162)}',
      artifact_ids=['pdf', 'summary', 'power', 'cells'],
      published=dict(value=pub_mint, units='rejection rate minus the nominal .05; raw rate read from Figure 4.28'),
      ours=dict(value=our_mint, units='rejection rate minus the nominal .05'),
      conditions=GRID + ' Contrast cell: n = 500, a = .59, h = .34 (ah = .2006), averaged over b, c\' and the three cutoffs.',
      contrasts=[dict(definition='MINT rejection rate at n = 500, a = .59, h = .34, mean over b, c\' and cutoffs, '
                                 'minus the nominal .05 (excess rejection over a null effect)',
                      units='rejection rate', positive_means='the 95% CI excludes zero more often than under a null effect',
                      published=pub_mint, ours=our_mint)],
      reproduction_deviation=f'ours minus published = {round(our_mint - pub_mint, 3)} (rejection rate; raw rates '
                             f'{our_mint_raw} and {pub_mint_raw})',
      methods=METHODS + ' Rejection means the 95% percentile CI excludes zero; it does not use population values.',
      uncertainty=MC,
      multiplicity='One cell: the largest MINT in the design at the smallest n. It was chosen after the full results '
                   'were available; results/summary.json gives MINT power for every n and ah.',
      status='not_replicated',
      status_reason=(f'In our run MINT power rises with n and ah: {our_mint_raw:.3f} at n = 500 for ah = .20, and at least '
                     f'{min(mint["n=1000 ah=0.1326"], mint["n=1000 ah=0.2006"]):.4f} for ah >= .13 once n >= 1,000. Her '
                     f'Figure 4.28 gives {pub_mint_cuts[0]}, {pub_mint_cuts[1]} and {pub_mint_cuts[2]} in this cell at '
                     'cutoffs 1-3, and no point above about .07: a Type I error curve. Rejection rates do not use '
                     'population values. Her MINT power matches our rates with h set to 0 at '
                     f'{ragree["4.28"]["pct_agree_if_h_were_0"]}% of points (against {ragree["4.28"]["pct_agree"]}% '
                     f'with h as designed) and her MINT bias is {bstruct[("4.16", 1)]["coef_ah"]}*ah, so the data behind '
                     'her results contained no interaction, while her printed code recovers h (' + RFULL + ') '
                     '(DISAGREEMENTS.yaml h-absent: explained). Her own abstract and Chapter 5 (printed p. 143) say '
                     'that Type I error and power for all five effects were within or reached the robustness criteria, '
                     'which her MINT power statement contradicts.'),
      numerical='mismatch', reconstruction_scope='full design, independent re-implementation and exact replay',
      limitations=['The published value is read from an image (reading error about .013 averaged over cutoffs; the '
                   'cutoff 1 point is partly hidden by another series). Which mechanism removed the interaction from '
                   'her data (y generated before the t*m column was filled, or h not reaching gendata) cannot be told '
                   'apart from her published results.'],
      stopping=STOP_DONE('Chen\'s y intercepts or result files would tell the two mechanisms apart.'),
      findings=dict(
          published=dict(text=f'MINT power near zero at every sample size; never reaches .80 (Figure 4.28: '
                              f'{min(pub_mint_cuts)}-{max(pub_mint_cuts)} in this cell)', state='reported',
                         artifact_ids=['pdf'], locator=f'Figure 4.28 discussion, {loc(135)}',
                         source_excerpt=excerpt('All power for MINT is near zero.', 135), page_locator=loc(135),
                         claim_type='numerical estimate', value_source='figure_digitized',
                         digitized_file='results/digitized_rates.csv', reading_error=e4_read_err,
                         conditions='Nonzero MINT cells (a and h nonzero), all n and cutoffs',
                         component_claim_ids=[], component_contrast_indices=[0]),
          ours=dict(text=f'MINT power {our_mint_raw:.3f} at n = 500 for ah = .20; at least .97 for ah >= .13 from n = 1,000',
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
      status_reason=('All indirect and MINT results lie within [-.05, .05] in our run, and in the full replay of her '
                     'code. Her digitized PNIE bias is -k*ab with k = ' + ', '.join(str(abs(float(bstruct[('4.12', c)]['coef_ab'])))
                     for c in (1, 2, 3)) + ' at cutoffs 1-3 and no dependence on n, and her MINT bias is exactly -ah '
                     '(results/bias_structure.csv; DISAGREEMENTS.yaml h-absent and population-values). At the median '
                     'cutoff, Chen\'s PNIE and MINT rows and her TNIE [-.05, .05] entry also equal what |bias| = '
                     'population value would give over the grid (secondary/zero_estimate_check.csv).'),
      numerical='mismatch', reconstruction_scope='full design',
      limitations=['The zero-estimate pattern does not fit every printed entry (for example PNDE needs c\' + h); '
                   'the bias-structure fit is the fuller description.'],
      stopping=STOP_DONE('Chen\'s population-value table, if one existed, would test the pattern directly.'))

STMT_METHOD = ('Every Type I error and power statement in Chapter 4 that names cells and a checkable outcome is '
               'tested on every cell set it names (simulation/statement_checks.py), with rates averaged over the '
               'factors it does not name, as in Chen\'s figures, and with fixed numeric readings of her words '
               '(for example "near zero" Type I < .025, "close to zero" power < .10, "around .80" .70-.90). '
               'A second reading moves every threshold .01 in her favour.')
H_NOTE = (f'As a consistency check, every statement was also read on our cells with h replaced by 0 (other '
          f'factors unchanged; the verdict_if_h_were_0 column). Then {n_h0} of {len(verdicts)} statements hold, '
          f'against {n_agree} as designed; {len(H0_FIXES)} of the {len(robust_dis)} statements that disagree under '
          f'both readings become agreements, and none that agrees becomes a disagreement. With h = 0, '
          f'{len(verdicts) - n_h0} statements still disagree under the strict reading: {rest} (which disagree under both '
          f'readings) and ' + ', '.join(str(NUM[k]) for k in verdicts if h0v[k] == 'disagree' and k not in robust_dis) + ' '
          f'(which agree with the .01 slack) (the number column of results/statement_checks.csv). Chen also '
          f'defines PNDE as "adding c\' and h" (printed p. 104), whereas with the mediator intercept zero in her '
          f'data-generating model the population PNDE is c\'. Her digitized Figures 4.17-4.28 match our rates read '
          f'with h = 0 at {min(pct_h0):.1f}-{max(pct_h0):.1f}% of points per figure (at {min(pct_h):.1f}-{max(pct_h):.1f}% '
          f'with h as designed; results/rates_agreement.csv), and each statement was also read against her own '
          f'figure points (verdict_on_chen_figures). Together with the exact replay of her code, which recovers h, '
          f'this indicates that the data behind her results contained no interaction (an inference from her outputs; her code and data for those runs are not available) (DISAGREEMENTS.yaml h-absent). '
          f'The remaining disagreements are threshold cases, her text against her own figures, and one TNDE cell set '
          f'explained by her particular random draws (DISAGREEMENTS.yaml threshold-noise, prose-versus-own-figure, '
          f'tnde-power-gap).')
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
      status_reason=(f'{t1_agree} of {len(T1S)} Type I statements agree ({t1_slack} with slack). ' + H_NOTE + ' The robust '
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
                   'Figures 4.17-4.21 were read from images; points hidden by another series are excluded from verdicts.'],
      stopping=STOP_DONE('None needed: the figures were digitized and compared cell by cell (results/rates_agreement.csv).'))

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
      limitations=['Figures 4.22-4.28 were read from images; points hidden by another series are excluded from verdicts.',
                   'The numeric readings of Chen\'s words are ours; the slack column shows which verdicts depend on them.'],
      stopping=STOP_DONE('None needed: the figures were digitized and compared cell by cell (results/rates_agreement.csv).'))

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
      source_locator=f'Tables 4.2-4.3, 4.6-4.7, equation 3.12', artifact_ids=['pdf', 'arith', 'arith_code', 'emp', 'emp_code', 'identities', 'sv_42', 'sv_43'],
      published=dict(value=24, units='printed differences and SBs'),
      ours=dict(value=24, units='printed entries reproduced'),
      conditions='Printed estimates only.', contrasts=[],
      contrast_not_applicable='An internal arithmetic check, not an effect.',
      methods='Recompute each difference and SB from the printed estimates.',
      uncertainty='Exact at the printed precision.', multiplicity='24 entries.',
      status='replicated',
      status_reason=('All 24 differences match; all 24 SBs match only when the divisor is the RCT estimate\'s SE '
                     'rather than the outcome SD stated in equation 3.12. Her printed effects also obey their '
                     f'definitions: {ident_hold} of {len(emp["identities"])} identities hold (PNIE = ab, TNIE = ab + ah, '
                     'TNDE - PNDE = ah in the RCT and three cutoffs), so on real data her code estimated h and used it; '
                     'the PNDE identity implies a mediator intercept of about 19.7 (RCT) and 22.1 (cutoff 3), the scale '
                     'of the mediator mean, so her real-data code used the fitted intercept. Table 4.2 shows treatment '
                     'below the cutoff (treated shares .36, .72, .86 at cutoffs 1-3), as her text labels them and the '
                     f'reverse of her simulation code. In Table 4.3, {t43_hold} of {len(t43)} t values equal the '
                     'coefficient over its SE; one (cutoff 3, child age, -0.127/0.061 = -2.08 against -2.252) is a '
                     'one-digit typo (DISAGREEMENTS.yaml table-4-3-t-value).'),
      numerical='match', reconstruction_scope='printed numbers only',
      limitations=['The divisor discrepancy is between the text and the tables; which was intended is unknown.'],
      stopping=dict(reason='Complete: all 24 printed entries recomputed.', attempted='Differences and standardized '
                    'biases from the printed RCT and RDD estimates and standard errors (secondary/table_arithmetic.py).',
                    untested='Which divisor Chen intended; the HSIS fits themselves (S4).', resource_basis='Seconds.',
                    next_evidence='None needed for the arithmetic.'))


sigc = json.load(open(ROOT / 'results/significance_conclusions.json'))
claim(id='S9', level='supporting',
      statement='In the Head Start analysis, 95% CIs for the RDD estimates reach opposite significance conclusions to '
                'the RCT estimates: if the RCT was significant, the RDD estimate was not (abstract; printed p. 143).',
      source_locator=f'Abstract, PDF p. 3; Chapter 5, {loc(157)}; Table 4.7, {loc(97)}-{loc(98)}; Chapter 4, {loc(95)}',
      artifact_ids=['pdf', 'sv_47', 'sig', 'sig_code'],
      published=dict(value='opposite significance conclusions in every comparison', units='qualitative'),
      ours=dict(value=f'{sigc["opposite"]} of {sigc["comparisons"]} comparisons opposite', units='comparisons'),
      conditions='Printed 95% CIs of Table 4.7 (RCT and three synthetic-RDD cutoffs, five effects); an estimate is '
                 'significant when its printed interval excludes 0.', contrasts=[],
      contrast_not_applicable='A count of significance conclusions read from printed intervals.',
      methods='Read from her printed Table 4.7 (source-values/table_4_7.csv; secondary/significance_conclusions.py). '
              'No refit: the HSIS data are unavailable (S4).',
      uncertainty='Exact at the printed precision of the interval bounds.', multiplicity='15 comparisons; descriptive.',
      status='partly_replicated',
      status_reason=(f'{sigc["opposite"]} of {sigc["comparisons"]} RCT-RDD comparisons reach opposite conclusions and '
                     f'{sigc["same"]} the same ({", ".join(sigc["same_conclusion_cells"])}). Where the RCT is significant '
                     f'(PNIE, TNIE), the RDD is not in all {sigc["rct_significant"]} cells, as she says; but in '
                     f'{sigc["rct_not_significant_but_rdd_significant"]} cells ({", ".join(sigc["rdd_significant_cells"])}) '
                     'the RDD interval excludes zero where the RCT interval does not, so her p. 81 sentence that PNDE '
                     'and TNDE "were not significant" holds for the RCT only. Her own Chapter 4 reading of the '
                     'table (printed p. 85) agrees with ours cell by cell: it reports the RDD intervals for PNIE and '
                     'TNIE as Type II errors and those for PNDE and TNDE at cutoffs 1-2 as Type I errors; the '
                     'overgeneralization is in her abstract and the p. 143 summary only (DISAGREEMENTS.yaml '
                     'significance-conclusions).'),
      numerical='not applicable', reconstruction_scope='printed numbers only',
      limitations=['Read from printed intervals; the fits themselves cannot be rerun (S4).'],
      stopping=dict(reason='Complete: every printed interval read.', attempted='All 20 intervals of Table 4.7.',
                    untested='The HSIS fits behind them (S4).', resource_basis='Seconds.',
                    next_evidence='The restricted-use HSIS file would allow a refit.'))
excerpt('made opposite statistical significance conclusions compared to the RCT estimates', 157)
excerpt('TNDE were not significant at the', 95)
excerpt('the RDD estimates would be a Type I error as a significant effect was falsely concluded', 99)

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
      status='not_established', status_reason='The analysis is announced in Chapter 3 but never reported, so there '
                                              'is nothing to assess; nothing blocks access.',
      numerical='not applicable', reconstruction_scope='none', limitations=['Unassessed.'],
      stopping=dict(reason='Not reported in the source.', attempted='Search of Chapters 3-5 and Appendices A-B for '
                    '"expected power", "standard deviation" and "power analysis".', untested='The analysis.',
                    resource_basis='Not a resource limit.', next_evidence='Chen\'s analysis notes.'))

DEV = dict(
    H4='Not computable: qualitative recommendation.',
    S1='PNIE: ours minus printed = %s; TNIE: %s; MINT: %s percentage points' % tuple(
        r2(our_ind[e] - pub_ind[e]) for e in ('PNIE', 'TNIE', 'MINT')),
    S2=f'Not computable: threshold statements; {len(T1S) - t1_agree} of {len(T1S)} disagree ({len(T1S) - t1_slack} with slack).',
    S3=f'Not computable: threshold statements; {len(PWS) - pw_agree} of {len(PWS)} disagree ({len(PWS) - pw_slack} with slack).',
    S4='Not computable: not rerun.', S9='Not computable: a count of significance conclusions.', S5='0 of 24 entries differ (SB with the RCT-estimate SE divisor).',
    S6='Not computable: not rerun.', S7='Not applicable: conceptual.', S8='Not computable: not reported.')
for c in claims:
    if 'reproduction_deviation' not in c:
        c['reproduction_deviation'] = DEV[c['id']]
for c in claims:
    for p in ('published', 'ours'):
        if c[p].get('value') is None and 'unavailable_reason' not in c[p]:
            sys.exit(f'{c["id"]} {p} null without reason')
excerpt('Type I error rate and power for all five effects were either within the robustness criteria or reached', 157)
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
         interpretation='descriptive point estimates; not equivalence', uncertainty_statement=MC_HEAD('E2')),
    dict(id='E3', claim_id='H2', contrast_index=1, estimand=claims[1]['contrasts'][1]['definition'],
         units='percentage points', positive_means=claims[1]['contrasts'][1]['positive_means'],
         published_effect=pub_imb, ours_effect=our_imb, estimate_status='resolved', display_decimals=2,
         tolerance=rounding_tol(30, 15),
         magnitude='smaller', direction='same direction',
         interpretation='descriptive point estimates; not equivalence', uncertainty_statement=MC_HEAD('E3')),
    dict(id='E4', claim_id='H3', contrast_index=0,
         estimand=claims[2]['contrasts'][0]['definition'], units='rejection rate',
         positive_means=claims[2]['contrasts'][0]['positive_means'], published_effect=pub_mint, ours_effect=our_mint,
         estimate_status='resolved', display_decimals=3,
         tolerance=dict(kind='measurement', value=e4_read_err, source_file='results/digitized_rates.csv',
                        basis=f'Reading error of the digitized Figure 4.28 points, averaged over the three cutoffs '
                              f'and rounded down; not set in the plan. The cutoff-1 point is partly hidden by '
                              f'another series (status {e4_status["1"]}); the two directly read points have a mean '
                              f'reading error of about .009. Her excess over .05 ({pub_mint}) is about one reading '
                              f'error: small, positive, and far below ours. Our Monte Carlo error of this 48-cell '
                              f'average is about .002.'),
         magnitude='larger', direction='same direction',
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
for e in EFFECTS[:4]:
    tol = e['tolerance']['value']
    a, b = abs(e['published_effect']), abs(e['ours_effect'])
    e['magnitude'] = 'same' if abs(a - b) <= tol else ('larger' if b > a else 'smaller')
    if (abs(e['ours_effect']) <= tol) != (abs(e['published_effect']) <= tol):
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
         claim_ids=['H1', 'H2', 'H3', 'S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S9']),
    dict(id='ch5', locator='Chapter 5, Discussion', claim_ids=['H1', 'H2', 'H3', 'H4', 'S4', 'S6', 'S9']),
    dict(id='refs', locator='References', claim_ids=[], exclusion_reason='Bibliography only.'),
    dict(id='appA', locator=f'Appendix A, R syntax for data generation, {loc(189)}-{loc(192)}', claim_ids=['H1', 'H2'],
         exclusion_reason=None),
    dict(id='appB', locator=f'Appendix B, R syntax for estimation and bootstrapping, {loc(193)}-{loc(203)}', claim_ids=['H1', 'H2', 'H3']),
]
for s in sections:
    if s.get('exclusion_reason') is None:
        s.pop('exclusion_reason', None)

limitations = [
    'The bootstrap-based results (coverage, Type I error, power) come from the Python run with our own seeds; '
    'Chen\'s bootstrap is unseeded, so they agree with hers on summaries only. The R replay reproduces exactly the '
    'datasets and point estimates her printed, seeded code generates (all 1,000 replications per condition); her '
    'published results came from data without the interaction wherever h > 0, which the printed code does not '
    'produce, so the replay is not her published runs (H1-H4, S1-S3).',
    'Chen\'s aggregation code, population values and result files are not printed. The mechanisms behind her bias, '
    'coverage and MINT results are inferred from her digitized figures and printed tables; they reproduce her patterns '
    'but are not read from her code (H1, H2, H3, S1).',
    'Figures 4.17-4.38 were read from images (reading errors up to about .02 on rates); points hidden behind another '
    'series are flagged and not used for statement verdicts (S2, S3). The one exception is E4 (H3), whose published '
    'value averages all three cutoffs including the partly hidden cutoff-1 point; the two directly read points give '
    'the same mean (.063) with a reading error of about .009, so no label changes.',
    'RQ2 (HSIS) cannot be rerun: the restricted-use data are not available to this project (S4, S6); only the '
    'printed arithmetic and identities were checked (S5).',
    'The announced power analysis by the SD of Y is not reported, so it cannot be assessed (S8).',
    'The dissertation labels the cutoffs inconsistently: the code\'s index 1 is the 25th percentile (75% treated), '
    'while Chapter 3, the Table 4.8 note and her Head Start analysis have treatment below the cutoff; we report by '
    'the code (H1, H2).',
    'Chen suggests global estimation with an incorrect functional form as a plausible explanation of the bias; in her data-generating model '
    'the assignment variable does not enter M or Y, so the fitted linear models are correctly specified (H1).',
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
               f'coverage; MINT power reaches {our_mint_raw:.2f} at n = 500 for the largest interaction, where Chen reports near zero. Of her '
               f'{len(verdicts)} testable Type I and power statements, {n_agree} agree ({n_slack} with .01 threshold '
               f'slack), and {n_h0} would hold in our run if h were 0. The n = 5,000 '
               f'recommendation holds for most but not all cells. RQ2 is blocked by data access. Her printed, seeded R '
               f'code, replayed exactly on all 1,280,000 datasets it generates, behaves like our run, so the disagreements arise in '
               f'unprinted steps: her digitized figures show results computed from data without the interaction h and '
               f'population values wrong for one group of cases. Of {n_dis} disagreements (DISAGREEMENTS.yaml), {n_expl} '
               f'are explained, {n_part} partly explained and {n_unexpl} unexplained.'),
    limitations=limitations,
)
(ROOT / 'evidence-packet.json').write_text(json.dumps(packet, indent=1, ensure_ascii=False) + '\n')
print('wrote evidence-packet.json;', len(claims), 'claims;', {e['id']: (e['published_effect'], e['ours_effect'],
                                                                       e['magnitude'], e['direction']) for e in EFFECTS})
