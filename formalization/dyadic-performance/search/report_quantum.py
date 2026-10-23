"""Render every quantum condition and distinguish logical from exact recovery."""
from pathlib import Path
import json

HERE = Path(__file__).resolve().parent
s = json.loads((HERE/'quantum-selection.json').read_text())
d = json.loads((HERE/'quantum-results.json').read_text())
names = {'baseline': 'Baseline', 'cycle_first': 'Shortest-cycle-first',
         'absorbing': 'Absorbing-only', 'joint': 'Joint', 'cycle_aggregate': 'Aggregate-cycle sensitivity'}


def interval(bounds):
    return '['+', '.join(f'{100*v:+.3f}' for v in bounds)+']'


sections, summary = [], []
rescued = 0
for sf, rf, af in zip(s['families'], d['families'], d['analysis']):
    config = sf['configuration']
    primary = next(a for a in af['conditions'] if a['primary'])
    policy = primary['mean_quantum_fer']
    summary.append(f'| {config["family"]} | `[[{config["n"]},{config["k"]},4]]` | '+
                   ' | '.join(f'{100*policy[arm]:.3f}%' for arm in ('baseline','cycle_first','absorbing','joint'))+' |')
    table = '\n'.join(f'| {a["alpha"]:.1f} | {a["p"]:.2f} | '+
                      ' | '.join(f'{100*a["mean_quantum_fer"][arm]:.3f}%' for arm in names)+' |'
                      for a in af['conditions'])
    contrast_table = '\n'.join('| '+names[c['left']]+' minus '+names[c['right']]+' | '+
                      f'{100*c["difference"]:+.3f} | '+interval(c['ci95'])+' | '+
                      (interval(c['primary_family_ci99_5833']) if c['primary_family_ci99_5833'] else 'Secondary')+' |'
                      for c in primary['contrasts'])
    all_equal = sum(len({pool['selected'][arm] for arm in ('cycle_first','absorbing','joint','cycle_aggregate')}) == 1 for pool in sf['pools'])
    baseline_equal = sum(pool['selected']['baseline'] == pool['selected']['cycle_first'] for pool in sf['pools'])
    structure, failure_types = [], []
    for arm in ('baseline','cycle_first'):
        codes = [pool['candidates'][pool['selected'][arm]] for pool in sf['pools']]
        mean = lambda values: sum(values)/16
        structure.append('| '+names[arm]+' | '+
            ' | '.join(f'{mean(c["cycles_total"][i] for c in codes):.2f}' for i in range(3))+' | '+
            f'{mean(c["absorbing_features_total"][4] for c in codes):.2f} | '+
            f'{mean(c["logical_x"]["kernel_supports"]["4"]["logical"]+c["logical_z"]["kernel_supports"]["4"]["logical"] for c in codes):.2f} |')
        row = [sum(pool['arms'][arm][1][key] for pool in rf['pools'])/80000
               for key in ('syndrome_failures','logical_syndrome_matched_failures','nonexact_stabilizer_successes')]
        failure_types.append('| '+names[arm]+' | '+' | '.join(f'{100*v:.4f}%' for v in row)+' |')
    for pool, outcome in zip(sf['pools'], rf['pools']):
        seen = set()
        for arm, idx in pool['selected'].items():
            if idx not in seen:
                rescued += sum(a['nonexact_stabilizer_successes'] for a in outcome['arms'][arm])
                seen.add(idx)
    family_contrast = next(c for c in primary['contrasts'] if c['left']=='baseline' and c['right']=='cycle_first')
    delta = -100*family_contrast['difference']
    sections.append(f'''## Construction {config['family']}

The stratum has length {config['n']}, quantum dimension {config['k']}, ranks `({config['rank']},{config['rank']})`, and exact sector distances `(4,4)`. There are 24 calibration instances and 384 candidate instances in 16 equal-budget pools. Sampling took {sf['attempted']} attempts; rejected counts are `{sf['rejected']}`. Calibration uses graph features only.

All four optimizing policies select the same matrix in **{all_equal}/16 pools**. The baseline is already that selected matrix in {baseline_equal}/16 pools. Thus their equality in decoding is exact within these pools, not merely an unresolved statistical comparison between distinct designs.

At the primary setting the optimizing policy changes frame error by **{delta:+.3f} percentage points** relative to baseline. Negative is an improvement. All conditions follow:

| Normalization | Sector probability | Baseline | Shortest-cycle-first | Absorbing-only | Joint | Aggregate-cycle sensitivity |
| --- | --- | --- | --- | --- | --- | --- |
{table}

Primary paired contrasts are in percentage points. Negative favors the left policy. The primary-family intervals apply a Bonferroni marginal level to the 12 primary comparisons across both construction strata. Aggregate-cycle comparisons are secondary.

| Contrast | Difference (points) | Paired 95% interval | Primary-family 99.5833% interval |
| --- | --- | --- | --- |
{contrast_table}

Structural counts below are summed over both Tanner graphs, then averaged over pools. They are graph instances/supports, not counts of independent failure events.

| Policy | Four-cycles | Six-cycles | Eight-cycles | Positive-b absorbing size 4 | Logical kernel supports of weight 4 |
| --- | --- | --- | --- | --- | --- |
{chr(10).join(structure)}

The primary-condition outcome decomposition separates failure to match a syndrome from a syndrome-matched logical error. The last column is successful recovery with a nonzero stabilizer residual; these frames would be incorrectly rejected by exact-error scoring.

| Policy | Syndrome failure | Syndrome-matched logical failure | Non-exact stabilizer-equivalent success |
| --- | --- | --- | --- |
{chr(10).join(failure_types)}
''')
text = f'''# Quantum CSS optimization in P11's constructions

The quantum extension uses **P11's literal Constructions 3.10 and 3.11**, fixes quantum dimension and exact quantum distance within each stratum, and scores recovery modulo the full stabilizer row spans. **Optimization helps in the tested 3.11 stratum and hurts in the tested 3.10 stratum.** Shortest-cycle-first, absorbing-only, joint and aggregate-cycle policies select the same code within every pool, so these samples do not separate the competing objectives.

## Source and controlled design

The [source comparison](QUANTUM-SOURCE-COMPARISON.md) identifies the exact formulas in Gómez-Fonseca, Matthews, Morris and Pllaha's [P11](https://arxiv.org/html/2605.01942v1). The [quantum protocol](QUANTUM-PROTOCOL.md) fixes geometry, objectives, noise and primary comparisons before benchmark decoding. The [prior-art review](PRIOR-ART.md) credits the source's published optimization experiments and the absorbing/trapping-set predecessors. This is a finite study of source subfamilies, not a reproduction of Figure 1 or a universal objective ranking.

Construction 3.10 uses `omega=4`, `ell=2`, all four rows, fixed cyclic `sigma` and sampled cyclic `tau` with explicit commutation checks. Construction 3.11 uses `v=6`, `ell=3`, all four source rows and `H_X=H_Z`; its larger size supplies graph-feature variation beyond the small full-row feasibility samples. The families are analyzed separately: their different lengths and dimensions are not pooled into a between-construction comparison.

Each family has 16 pools of 24 admissible candidates; every policy sees the same pool. An additional 24 examples per family calibrate graph-feature scaling. **768 candidate codes plus 48 calibration codes** have checked commutation, ranks, connectedness and exact quantum distance. Selections are frozen before decoding, with earliest-candidate tie breaking. Source checks and logical-distance checks are computational, not new Lean theorems.

## Primary quantum results

The fixed primary setting is independent binary X and Z component probability **0.02 each**, min-sum normalization **0.8**, 50 iterations, and perfect syndrome measurements. The corresponding total nonidentity Pauli probability is **3.96%**; this is not a 2% depolarizing channel. Every row below compares policies at fixed length, dimension and distance.

| P11 construction | Quantum parameters | Baseline quantum FER | Shortest-cycle-first | Absorbing-only | Joint |
| --- | --- | --- | --- | --- | --- |
{chr(10).join(summary)}

The family-adjusted approximate bootstrap intervals exclude zero for optimized-versus-baseline differences in both strata, with opposite signs. This is evidence about these specified selection policies and decoder, not a claim that graph minimization always improves quantum decoding. The policies themselves are tied because they choose identical matrices, so no superiority claim among them follows.

## Stabilizer-equivalent recovery

Z errors are decoded with `H_X`; X errors with `H_Z`. Success requires `residual_Z` in `rowspan(H_Z)` and `residual_X` in `rowspan(H_X)`. Row-span membership includes arbitrary products of stabilizer generators. Nonzero stabilizers count as successes; nontrivial logical residuals with matching syndromes count as failures. Injected errors and opposite-check spans are used for scoring, not to choose the decoder output.

Across the **{d['actual_quantum_frames']:,} actual quantum frame evaluations**, **{rescued} non-exact recoveries are correctly accepted as stabilizer-equivalent successes**. Explicit tests also inject pure stabilizers and weight-four logical witnesses: both have zero syndrome, but only the former succeed. Full low-weight support spectra distinguish stabilizers from logical operators even though the raw absorbing objective retains both for comparability.

{chr(10).join(sections)}

## What this establishes and what remains

This implements the requested move from classical arrays to actual CSS pairs with genuine quantum success criteria. The contrasting results show why the earlier classical gains cannot simply be transferred to quantum codes. In 3.10, the selected graphs have fewer four-/six-cycles and fewer enumerated small absorbing and logical supports, but more syndrome-matched logical failures under this decoder; counting those structures alone does not guarantee improved logical performance. In 3.11 both failure categories decrease at the primary setting.

The experiment does not identify a best objective because all tested optimizing rules pick identical designs in each pool. A next discriminating experiment needs source subfamilies or constraints in which the rules choose different designs, or topology-/decoder-conditioned objectives, rather than treating the tied policy outcomes as independent evidence. Larger distance, other channels, syndrome noise, other decoders and asymptotic error floors remain outside this comparison. The P11 performance research direction remains unresolved in general.

## Reproduction and verification

The experiment uses 480,000 independent sampled quantum error frames, shared across policies and normalizations. There are **{d['nominal_arm_frame_evaluations']:,} nominal arm-frame evaluations**, **{d['actual_quantum_frames']:,} actual quantum frame evaluations** after identical selections are cached, and **{d['actual_sector_decoder_executions']:,} sector-decoder executions**. These are not {d['actual_quantum_frames']:,} independent noise samples. There are {d['decoder_reference_checks']} decoder-reference comparisons and {d['stabilizer_logical_scoring_tests']} explicit stabilizer/logical scoring tests.

From the repository root, using Python 3 and a C++17 compiler:

```sh
python3 formalization/dyadic-performance/search/quantum_benchmark.py
python3 scripts/validate_quantum_dyadic.py
python3 formalization/dyadic-performance/search/report_quantum.py
```

The [selection manifest](search/quantum-selection.json) retains every source parameter array, both binary block arrays, calibration and candidate spectra, exact logical-distance witnesses, objectives and dependency hashes. The [results](search/quantum-results.json) retain paired quantum/exact/logical/syndrome failure bitmaps, seeds, noise hashes, all settings and contrasts. Intervals use 20,000 paired pool-bootstrap resamples; their finite-sample coverage is approximate. Validation independently checks the literal matrices, exact ranks, quotient-distance enumeration, stabilizer membership, selected spectra, constant-feature handling, selection minima and outcome partitions.

Findings are local and have not been committed or pushed. Existing Lean artifacts and completed-target counts remain unchanged.
'''
(HERE.parent/'QUANTUM.md').write_text(text)
print('Wrote formalization/dyadic-performance/QUANTUM.md')
