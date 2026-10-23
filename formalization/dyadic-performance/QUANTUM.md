# Quantum CSS optimization in P11's constructions

The quantum extension uses **P11's literal Constructions 3.10 and 3.11**, fixes quantum dimension and exact quantum distance within each stratum, and scores recovery modulo the full stabilizer row spans. **Optimization helps in the tested 3.11 stratum and hurts in the tested 3.10 stratum.** Shortest-cycle-first, absorbing-only, joint and aggregate-cycle policies select the same code within every pool, so these samples do not separate the competing objectives.

## Source and controlled design

The [source comparison](QUANTUM-SOURCE-COMPARISON.md) identifies the exact formulas in Gómez-Fonseca, Matthews, Morris and Pllaha's [P11](https://arxiv.org/html/2605.01942v1). The [quantum protocol](QUANTUM-PROTOCOL.md) fixes geometry, objectives, noise and primary comparisons before benchmark decoding. The [prior-art review](PRIOR-ART.md) credits the source's published optimization experiments and the absorbing/trapping-set predecessors. This is a finite study of source subfamilies, not a reproduction of Figure 1 or a universal objective ranking.

Construction 3.10 uses `omega=4`, `ell=2`, all four rows, fixed cyclic `sigma` and sampled cyclic `tau` with explicit commutation checks. Construction 3.11 uses `v=6`, `ell=3`, all four source rows and `H_X=H_Z`; its larger size supplies graph-feature variation beyond the small full-row feasibility samples. The families are analyzed separately: their different lengths and dimensions are not pooled into a between-construction comparison.

Each family has 16 pools of 24 admissible candidates; every policy sees the same pool. An additional 24 examples per family calibrate graph-feature scaling. **768 candidate codes plus 48 calibration codes** have checked commutation, ranks, connectedness and exact quantum distance. Selections are frozen before decoding, with earliest-candidate tie breaking. Source checks and logical-distance checks are computational, not new Lean theorems.

## Primary quantum results

The fixed primary setting is independent binary X and Z component probability **0.02 each**, min-sum normalization **0.8**, 50 iterations, and perfect syndrome measurements. The corresponding total nonidentity Pauli probability is **3.96%**; this is not a 2% depolarizing channel. Every row below compares policies at fixed length, dimension and distance.

| P11 construction | Quantum parameters | Baseline quantum FER | Shortest-cycle-first | Absorbing-only | Joint |
| --- | --- | --- | --- | --- | --- |
| 3.10 | `[[32,8,4]]` | 14.157% | 15.300% | 15.300% | 15.300% |
| 3.11 | `[[96,40,4]]` | 31.861% | 27.981% | 27.981% | 27.981% |

The family-adjusted approximate bootstrap intervals exclude zero for optimized-versus-baseline differences in both strata, with opposite signs. This is evidence about these specified selection policies and decoder, not a claim that graph minimization always improves quantum decoding. The policies themselves are tied because they choose identical matrices, so no superiority claim among them follows.

## Stabilizer-equivalent recovery

Z errors are decoded with `H_X`; X errors with `H_Z`. Success requires `residual_Z` in `rowspan(H_Z)` and `residual_X` in `rowspan(H_X)`. Row-span membership includes arbitrary products of stabilizer generators. Nonzero stabilizers count as successes; nontrivial logical residuals with matching syndromes count as failures. Injected errors and opposite-check spans are used for scoring, not to choose the decoder output.

Across the **1,650,000 actual quantum frame evaluations**, **51 non-exact recoveries are correctly accepted as stabilizer-equivalent successes**. Explicit tests also inject pure stabilizers and weight-four logical witnesses: both have zero syndrome, but only the former succeed. Full low-weight support spectra distinguish stabilizers from logical operators even though the raw absorbing objective retains both for comparability.

## Construction 3.10

The stratum has length 32, quantum dimension 8, ranks `(12,12)`, and exact sector distances `(4,4)`. There are 24 calibration instances and 384 candidate instances in 16 equal-budget pools. Sampling took 4130 attempts; rejected counts are `{'noncommuting': 2854, 'rank_mismatch': 526, 'disconnected': 333, 'duplicate_parameters': 9}`. Calibration uses graph features only.

All four optimizing policies select the same matrix in **16/16 pools**. The baseline is already that selected matrix in 5/16 pools. Thus their equality in decoding is exact within these pools, not merely an unresolved statistical comparison between distinct designs.

At the primary setting the optimizing policy changes frame error by **+1.142 percentage points** relative to baseline. Negative is an improvement. All conditions follow:

| Normalization | Sector probability | Baseline | Shortest-cycle-first | Absorbing-only | Joint | Aggregate-cycle sensitivity |
| --- | --- | --- | --- | --- | --- | --- |
| 0.8 | 0.01 | 4.141% | 4.402% | 4.402% | 4.402% | 4.402% |
| 0.8 | 0.02 | 14.157% | 15.300% | 15.300% | 15.300% | 15.300% |
| 0.8 | 0.05 | 54.004% | 56.452% | 56.452% | 56.452% | 56.452% |
| 1.0 | 0.01 | 36.940% | 45.821% | 45.821% | 45.821% | 45.821% |
| 1.0 | 0.02 | 59.966% | 70.254% | 70.254% | 70.254% | 70.254% |
| 1.0 | 0.05 | 89.552% | 94.001% | 94.001% | 94.001% | 94.001% |

Primary paired contrasts are in percentage points. Negative favors the left policy. The primary-family intervals apply a Bonferroni marginal level to the 12 primary comparisons across both construction strata. Aggregate-cycle comparisons are secondary.

| Contrast | Difference (points) | Paired 95% interval | Primary-family 99.5833% interval |
| --- | --- | --- | --- |
| Baseline minus Shortest-cycle-first | -1.142 | [-1.570, -0.707] | [-1.749, -0.515] |
| Baseline minus Absorbing-only | -1.142 | [-1.570, -0.707] | [-1.749, -0.515] |
| Baseline minus Joint | -1.142 | [-1.570, -0.707] | [-1.749, -0.515] |
| Baseline minus Aggregate-cycle sensitivity | -1.142 | [-1.570, -0.707] | Secondary |
| Shortest-cycle-first minus Absorbing-only | +0.000 | [+0.000, +0.000] | [+0.000, +0.000] |
| Shortest-cycle-first minus Joint | +0.000 | [+0.000, +0.000] | [+0.000, +0.000] |
| Shortest-cycle-first minus Aggregate-cycle sensitivity | +0.000 | [+0.000, +0.000] | Secondary |
| Absorbing-only minus Joint | +0.000 | [+0.000, +0.000] | [+0.000, +0.000] |
| Absorbing-only minus Aggregate-cycle sensitivity | +0.000 | [+0.000, +0.000] | Secondary |
| Joint minus Aggregate-cycle sensitivity | +0.000 | [+0.000, +0.000] | Secondary |

Structural counts below are summed over both Tanner graphs, then averaged over pools. They are graph instances/supports, not counts of independent failure events.

| Policy | Four-cycles | Six-cycles | Eight-cycles | Positive-b absorbing size 4 | Logical kernel supports of weight 4 |
| --- | --- | --- | --- | --- | --- |
| Baseline | 324.00 | 3088.00 | 40808.00 | 888.00 | 113.00 |
| Shortest-cycle-first | 256.00 | 2816.00 | 44512.00 | 800.00 | 96.00 |

The primary-condition outcome decomposition separates failure to match a syndrome from a syndrome-matched logical error. The last column is successful recovery with a nonzero stabilizer residual; these frames would be incorrectly rejected by exact-error scoring.

| Policy | Syndrome failure | Syndrome-matched logical failure | Non-exact stabilizer-equivalent success |
| --- | --- | --- | --- |
| Baseline | 11.0000% | 3.1575% | 0.0013% |
| Shortest-cycle-first | 10.5838% | 4.7163% | 0.0000% |

## Construction 3.11

The stratum has length 96, quantum dimension 40, ranks `(28,28)`, and exact sector distances `(4,4)`. There are 24 calibration instances and 384 candidate instances in 16 equal-budget pools. Sampling took 1317 attempts; rejected counts are `{'rank_mismatch': 633, 'disconnected': 275, 'duplicate_parameters': 1}`. Calibration uses graph features only.

All four optimizing policies select the same matrix in **16/16 pools**. The baseline is already that selected matrix in 4/16 pools. Thus their equality in decoding is exact within these pools, not merely an unresolved statistical comparison between distinct designs.

At the primary setting the optimizing policy changes frame error by **-3.880 percentage points** relative to baseline. Negative is an improvement. All conditions follow:

| Normalization | Sector probability | Baseline | Shortest-cycle-first | Absorbing-only | Joint | Aggregate-cycle sensitivity |
| --- | --- | --- | --- | --- | --- | --- |
| 0.8 | 0.01 | 10.040% | 7.299% | 7.299% | 7.299% | 7.299% |
| 0.8 | 0.02 | 31.861% | 27.981% | 27.981% | 27.981% | 27.981% |
| 0.8 | 0.05 | 90.249% | 89.471% | 89.471% | 89.471% | 89.471% |
| 1.0 | 0.01 | 56.771% | 29.631% | 29.631% | 29.631% | 29.631% |
| 1.0 | 0.02 | 82.798% | 66.689% | 66.689% | 66.689% | 66.689% |
| 1.0 | 0.05 | 99.486% | 98.820% | 98.820% | 98.820% | 98.820% |

Primary paired contrasts are in percentage points. Negative favors the left policy. The primary-family intervals apply a Bonferroni marginal level to the 12 primary comparisons across both construction strata. Aggregate-cycle comparisons are secondary.

| Contrast | Difference (points) | Paired 95% interval | Primary-family 99.5833% interval |
| --- | --- | --- | --- |
| Baseline minus Shortest-cycle-first | +3.880 | [+2.595, +5.121] | [+2.022, +5.673] |
| Baseline minus Absorbing-only | +3.880 | [+2.595, +5.121] | [+2.022, +5.673] |
| Baseline minus Joint | +3.880 | [+2.595, +5.121] | [+2.022, +5.673] |
| Baseline minus Aggregate-cycle sensitivity | +3.880 | [+2.595, +5.121] | Secondary |
| Shortest-cycle-first minus Absorbing-only | +0.000 | [+0.000, +0.000] | [+0.000, +0.000] |
| Shortest-cycle-first minus Joint | +0.000 | [+0.000, +0.000] | [+0.000, +0.000] |
| Shortest-cycle-first minus Aggregate-cycle sensitivity | +0.000 | [+0.000, +0.000] | Secondary |
| Absorbing-only minus Joint | +0.000 | [+0.000, +0.000] | [+0.000, +0.000] |
| Absorbing-only minus Aggregate-cycle sensitivity | +0.000 | [+0.000, +0.000] | Secondary |
| Joint minus Aggregate-cycle sensitivity | +0.000 | [+0.000, +0.000] | Secondary |

Structural counts below are summed over both Tanner graphs, then averaged over pools. They are graph instances/supports, not counts of independent failure events.

| Policy | Four-cycles | Six-cycles | Eight-cycles | Positive-b absorbing size 4 | Logical kernel supports of weight 4 |
| --- | --- | --- | --- | --- | --- |
| Baseline | 1344.00 | 15360.00 | 275520.00 | 8520.00 | 384.00 |
| Shortest-cycle-first | 960.00 | 10752.00 | 258624.00 | 5376.00 | 336.00 |

The primary-condition outcome decomposition separates failure to match a syndrome from a syndrome-matched logical error. The last column is successful recovery with a nonzero stabilizer residual; these frames would be incorrectly rejected by exact-error scoring.

| Policy | Syndrome failure | Syndrome-matched logical failure | Non-exact stabilizer-equivalent success |
| --- | --- | --- | --- |
| Baseline | 25.1387% | 6.7225% | 0.0138% |
| Shortest-cycle-first | 23.2900% | 4.6913% | 0.0000% |


## What this establishes and what remains

This implements the requested move from classical arrays to actual CSS pairs with genuine quantum success criteria. The contrasting results show why the earlier classical gains cannot simply be transferred to quantum codes. In 3.10, the selected graphs have fewer four-/six-cycles and fewer enumerated small absorbing and logical supports, but more syndrome-matched logical failures under this decoder; counting those structures alone does not guarantee improved logical performance. In 3.11 both failure categories decrease at the primary setting.

The experiment does not identify a best objective because all tested optimizing rules pick identical designs in each pool. A next discriminating experiment needs source subfamilies or constraints in which the rules choose different designs, or topology-/decoder-conditioned objectives, rather than treating the tied policy outcomes as independent evidence. Larger distance, other channels, syndrome noise, other decoders and asymptotic error floors remain outside this comparison. The P11 performance research direction remains unresolved in general.

## Reproduction and verification

The experiment uses 480,000 independent sampled quantum error frames, shared across policies and normalizations. There are **4,800,000 nominal arm-frame evaluations**, **1,650,000 actual quantum frame evaluations** after identical selections are cached, and **3,300,000 sector-decoder executions**. These are not 1,650,000 independent noise samples. There are 440 decoder-reference comparisons and 220 explicit stabilizer/logical scoring tests.

From the repository root, using Python 3 and a C++17 compiler:

```sh
python3 formalization/dyadic-performance/search/quantum_benchmark.py
python3 scripts/validate_quantum_dyadic.py
python3 formalization/dyadic-performance/search/report_quantum.py
```

The [selection manifest](search/quantum-selection.json) retains every source parameter array, both binary block arrays, calibration and candidate spectra, exact logical-distance witnesses, objectives and dependency hashes. The [results](search/quantum-results.json) retain paired quantum/exact/logical/syndrome failure bitmaps, seeds, noise hashes, all settings and contrasts. Intervals use 20,000 paired pool-bootstrap resamples; their finite-sample coverage is approximate. Validation independently checks the literal matrices, exact ranks, quotient-distance enumeration, stabilizer membership, selected spectra, constant-feature handling, selection minima and outcome partitions.

Findings are local and have not been committed or pushed. Existing Lean artifacts and completed-target counts remain unchanged.
