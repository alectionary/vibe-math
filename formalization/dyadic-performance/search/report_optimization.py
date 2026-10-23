"""Render the complete optimization comparison without selecting conditions."""
from pathlib import Path
import json

HERE = Path(__file__).resolve().parent
s = json.loads((HERE/'optimization-selection.json').read_text())
d = json.loads((HERE/'optimization-results.json').read_text())
lex_d = json.loads((HERE/'lexicographic-results.json').read_text())
names = {'baseline': 'Unoptimized baseline', 'cycles': 'Cycle-only',
         'absorbing': 'Absorbing-only', 'joint': 'Joint'}
arms = list(names)
primary = next(a for a in d['analysis'] if a['primary'])
primary_table = '\n'.join('| '+names[arm]+' | '+f'{100*primary["mean_fer"][arm]:.3f}%'+' |'
                          for arm in arms)
sensitivity = '\n'.join('| '+f'{a["alpha"]:.1f} | {a["p"]:.2f} | '+
                        ' | '.join(f'{100*a["mean_fer"][arm]:.3f}%' for arm in arms)+' |'
                        for a in d['analysis'])


def interval(bounds):
    return '['+', '.join(f'{100*v:+.3f}' for v in bounds)+']'


contrasts = '\n'.join('| '+names[c['left']]+' minus '+names[c['right']]+' | '+
                      f'{100*c["mean_fer_difference"]:+.3f} | '+interval(c['ci95'])+' | '+
                      interval(c['primary_family_ci99_1667'])+' | '+
                      f'{c["pools_better"]}/{c["pools_equal"]}/{c["pools_worse"]} |'
                      for c in primary['contrasts'])
metrics = []
for arm in arms:
    codes = [pool['candidates'][pool['selected'][arm]] for pool in s['pools']]
    mean = lambda values: sum(values)/len(codes)
    metrics.append('| '+names[arm]+' | '+
                   ' | '.join(f'{mean(c["cycles"][j] for c in codes):.2f}' for j in range(3))+' | '+
                   ' | '.join(f'{mean(c["absorbing_features"][j] for c in codes):.2f}' for j in (0, 2, 4, 5))+' |')
same = sum(pool['selected']['absorbing'] == pool['selected']['joint'] for pool in s['pools'])
unique_selections = sum(len(set(pool['selected'].values())) for pool in s['pools'])
selected_fingerprints = {json.dumps([pool['candidates'][i]['cycles'],
                                   pool['candidates'][i]['absorbing_spectrum']], sort_keys=True)
                         for pool in s['pools'] for i in set(pool['selected'].values())}
bootstrap_exclusions = [c for c in primary['contrasts']
                        if c['primary_family_ci99_1667'][0] > 0 or c['primary_family_ci99_1667'][1] < 0]
exclusion_text = '; '.join(names[c['left']]+' versus '+names[c['right']] for c in bootstrap_exclusions) or 'none'
lex_primary = next(a for a in lex_d['analysis'] if a['primary'])
lex_names = dict(names, cycles='Shortest-cycle-first')
lex_primary_table = '\n'.join('| '+lex_names[arm]+' | '+f'{100*lex_primary["mean_fer"][arm]:.3f}%'+' |'
                              for arm in arms)
lex_sensitivity = '\n'.join('| '+f'{a["alpha"]:.1f} | {a["p"]:.2f} | '+
                           ' | '.join(f'{100*a["mean_fer"][arm]:.3f}%' for arm in arms)+' |'
                           for a in lex_d['analysis'])
lex_contrasts = '\n'.join('| '+lex_names[c['left']]+' minus '+lex_names[c['right']]+' | '+
                          f'{100*c["mean_fer_difference"]:+.3f} | '+interval(c['ci95'])+' | '+
                          f'{c["pools_better"]}/{c["pools_equal"]}/{c["pools_worse"]} |'
                          for c in lex_primary['contrasts'])
text = f'''# Optimizing dyadic codes and testing decoding performance

The graph-objective intervention is complete for 16 matched candidate pools of classical dyadic codes. **Absorbing-only optimization and shortest-cycle-first optimization both improve decoding over the baseline; this experiment does not distinguish a clear winner between them.** A weighted aggregate of cycle counts performs worse than the baseline and selects more four-cycles. The original fixed comparison and the explicitly labeled follow-up below show why the precise objective matters. These are decoding results after actual code selection, not merely predictions of unoptimized performance.

The source research direction is Gómez-Fonseca, Matthews, Morris and Pllaha's question about optimization objectives and performance in [P11 Section 7](https://arxiv.org/html/2605.01942v1#S7). The [prior-art review](PRIOR-ART.md) credits the source's cycle-optimization experiments and classical/quantum absorbing- and trapping-set predecessors. Our experiment tests a bounded classical subcase, not all of its CSS constructions.

## Intervention and controls

The [protocol](OPTIMIZATION-PROTOCOL.md) was saved before sampling candidate pools and decoding outcomes. Each of 16 pools contains 48 admissible codes, for **768 candidate evaluations**. Each code has parameters **[48,28,4]**, a connected Tanner graph, degree-three variables and degree-six checks. Arrays are normalized `3 × 6` dyadic-permutation layouts over `F₂³`. Binary rank is checked exactly. Distinct nonzero columns and odd column weight exclude codewords of weights one through three; an independently checked weight-four witness establishes distance exactly four.

Every optimizer searches the same candidates within each pool. The unoptimized baseline is the first admissible candidate. Cycle-only minimizes the mean standardized `log(1+count)` of simple four-, six- and eight-cycles. Absorbing-only similarly minimizes positive-syndrome absorbing counts at sizes two, three and four and zero-syndrome counts at size four. Joint minimizes the average of those two family scores. Reference scaling uses graph features from the earlier distance-four population; no decoder outcomes enter selection. These are specific positive weighted aggregates, not every possible cycle or absorbing objective, and not a lexicographic girth-first policy.

This is **best-of-48 random-search optimization**, not a global optimum. Budgets are equal in candidates evaluated, not in the wall-clock costs of computing different graph metrics. The complete selected-code manifest was written before invoking any decoder. All candidates, scores and selections are retained in [optimization-selection.json](search/optimization-selection.json).

## Primary decoding result

The fixed primary condition is binary error probability **0.05**, min-sum normalization **0.8**, and **50 iterations**. Every arm in a pool receives the same 5,000 fresh error vectors; pools have separate noise streams. Classical success requires exact error recovery. Incorrect recoveries with a matching syndrome count as failures.

| Selection policy | Mean frame error rate |
| --- | --- |
{primary_table}

The contrast unit below is **percentage points of frame error rate**, not relative percentage improvement. Negative means the left policy has fewer failures. Bootstrap resampling treats a whole candidate pool and its paired noise outcomes as one block; it does not pretend the four arms are independent.

| Contrast | Mean difference (points) | Paired 95% interval | Primary-family 99.1667% interval | Pools better/equal/worse |
| --- | --- | --- | --- | --- |
{contrasts}

The primary-family intervals use Bonferroni marginal levels for the six primary pairwise contrasts. There are 20,000 paired pool-bootstrap resamples with a fixed seed. These are approximate percentile-bootstrap uncertainty intervals based on only 16 pools; they do not guarantee exact simultaneous coverage. The family intervals exclude zero for: **{exclusion_text}**. Other comparisons should not be described as established differences merely because their point estimates differ.

## All decoder and noise settings

These five additional conditions are sensitivity analyses, not alternative primary endpoints selected after inspection. All values are mean frame error fractions expressed as percentages.

| Normalization | Error probability | Baseline | Cycle-only | Absorbing-only | Joint |
| --- | --- | --- | --- | --- | --- |
{sensitivity}

Descriptive paired 95% intervals for every secondary contrast, pool-level values, nonconvergence/wrong-convergence counts, and sample-level failure bitmaps are retained in [optimization-results.json](search/optimization-results.json). The observed minimum in any secondary row is not itself a universal best-objective finding.

## What changed structurally

The following are average counts across the selected codes in the 16 pools. Positive-`b` columns count absorbing supports with nonzero syndrome. The zero-`b` size-four column is the classical weight-four codeword multiplicity.

| Policy | Four-cycles | Six-cycles | Eight-cycles | Positive-b size 2 | Positive-b size 3 | Positive-b size 4 | Zero-b size 4 |
| --- | --- | --- | --- | --- | --- | --- | --- |
{chr(10).join(metrics)}

The absorbing-only and joint policies select the same matrix in **{same}/16 pools**. The 64 nominal arm slots contain **{unique_selections} distinct selections within pools**, representing {len(selected_fingerprints)} invariant fingerprints across pools. Fingerprints are not a complete isomorphism classification. Identical selections within a pool share decoding output, rather than counting duplicate computation as independent evidence.

Distance is fixed, while codeword multiplicity and other structural features can change. A benefit of the absorbing policy therefore cannot automatically be attributed solely to positive-syndrome absorbing sets. Likewise, the intervention compares complete selection policies; it does not isolate the causal effect of changing one graph invariant while keeping every other invariant fixed.

The aggregate cycle policy reduces six- and eight-cycle counts while increasing four-cycles from 34.00 to 54.50 on average. Thus its unfavorable decoding result does not show that minimizing the shortest cycles is ineffective. It prompted the sensitivity comparison below; the original protocol, selection and unfavorable results are preserved.

## Shortest cycle first on another fresh noise sample

The [follow-up protocol](LEXICOGRAPHIC-PROTOCOL.md) was fixed after seeing the aggregate tradeoff, before generating this comparison's outcomes. It uses the same candidate pools and replaces only the cycle selection rule with the lexicographic minimum `(four_cycles, six_cycles, eight_cycles)`. Baseline, absorbing and joint selections remain unchanged. Every arm is decoded again on another fresh, shared noise sample. This is an adaptive sensitivity check, not the original prespecified primary comparison or an independent code population.

At probability 0.05 and normalization 0.8:

| Policy | Mean frame error rate |
| --- | --- |
{lex_primary_table}

| Contrast | Mean difference (points) | Paired 95% interval | Pools better/equal/worse |
| --- | --- | --- | --- |
{lex_contrasts}

The absorbing-versus-shortest-cycle-first interval includes zero. The corresponding primary-family-level interval also includes zero. Both policies improve on the unoptimized baseline in 15 pools and select the baseline itself in the remaining pool. Absorbing-only and shortest-cycle-first select the identical matrix in 12 of 16 pools, explaining much of their close performance. Joint and shortest-cycle-first coincide in 13 pools. The numerical intervals quantify this follow-up comparison; applying a multiple-comparison adjustment does not turn an adaptive analysis into the original prespecified test.

All six fresh-noise conditions are retained:

| Normalization | Error probability | Baseline | Shortest-cycle-first | Absorbing-only | Joint |
| --- | --- | --- | --- | --- | --- |
{lex_sensitivity}

Full outcomes, paired contrasts and hashes are in [lexicographic-results.json](search/lexicographic-results.json) and the choices in [lexicographic-selection.json](search/lexicographic-selection.json). The practical conclusion is to retain shortest-cycle priority as a serious baseline for absorbing-objective optimization. This experiment supplies no clear evidence that the richer absorbing spectrum is superior to that cycle-only policy, despite its earlier advantage over aggregate cycle features in prediction.

## Evidence and remaining scope

There are **{d['nominal_arm_decodes']:,} nominal arm-frame evaluations**, implemented as **{d['actual_decoder_executions']:,} actual Monte Carlo decodes** after identical selections are cached. An additional {d['reference_checks']} C++ versus Python decoder comparisons check low-weight patterns on the selected graphs. Full selected-code cycle and absorbing spectra, independent four-cycle formulas, independent weight-four counts, exact ranks, distance witnesses, matrix expansions, sample hashes and selection minima are audited by the validator.

The shortest-cycle-first follow-up adds **{lex_d['actual_decoder_executions']:,} actual Monte Carlo decodes** and {lex_d['reference_checks']} decoder-reference comparisons. The optimization investigations therefore total **{d['actual_decoder_executions']+lex_d['actual_decoder_executions']:,} actual Monte Carlo decodes** and {d['reference_checks']+lex_d['reference_checks']} reference comparisons. Nominal arm-frame evaluations across both runs total 3,840,000; identical within-pool selections are cached.

The result is empirical evidence for these explicit graph-objective policies in short classical dyadic codes. It is not a new Lean theorem, quantum logical-error performance, a rare-event error-floor measurement, or a claim that this weighting is optimal. Larger fibers, source-specific commuting CSS checks and stabilizer-aware scoring remain necessary for the broader P11 quantum direction. No first-study or mathematical novelty claim is made.

## Reproduction

From the repository root, using Python 3 and a C++17 compiler:

```sh
python3 formalization/dyadic-performance/search/optimize.py
python3 formalization/dyadic-performance/search/lexicographic.py
python3 scripts/validate_dyadic_optimization.py
python3 formalization/dyadic-performance/search/report_optimization.py
```

The frozen selection manifest hashes the optimizer, protocol, feature-reference artifacts and decoder dependencies. The result file hashes that manifest. Original prediction-study artifacts remain unchanged. Findings are local and have not been committed or pushed.
'''
(HERE.parent/'OPTIMIZATION.md').write_text(text)
print('Wrote formalization/dyadic-performance/OPTIMIZATION.md')
