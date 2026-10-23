# Dyadic decoding objectives in classical and quantum codes

P11’s performance-objective question is now studied through classical prediction, controlled code optimization, and literal quantum CSS experiments. The quantum extension gives opposite optimization effects in two source strata, while all tested optimizing policies choose the same code within each quantum pool. The classical studies below separately show when absorbing spectra improve prediction and when shortest-cycle priority is competitive. The bounded follow-up now separates two fixed-code objective disagreements and supplies exact low-weight ambiguity bounds. These are conditional results, not a universal best-objective theorem.

## Quantum extension using the actual source constructions

The [quantum CSS experiment](QUANTUM.md) now uses literal P11 Constructions 3.10 and 3.11, with matched quantum parameters within separate `[[32,8,4]]` and `[[96,40,4]]` strata. Both X and Z components are decoded, and recovery is successful modulo the full stabilizer spans. Quantum distance is certified by excluding lower-weight non-stabilizer supports and checking weight-four logical witnesses.

Across 768 candidate CSS pairs plus 48 calibration pairs, the cycle-first, absorbing, joint and aggregate-cycle policies select the same matrix in every pool. At sector error probability 0.02 and normalization 0.8, selection worsens quantum frame error from 14.1575% to 15.3000% in Construction 3.10, but improves it from 31.86125% to 27.98125% in Construction 3.11. This supplies source-specific quantum evidence without ranking tied objectives or transferring the earlier classical gains automatically. The 3.3 million sector-decoder executions include 51 non-exact, stabilizer-equivalent successes. Full unfavorable/positive results and paired intervals are retained.

See the [source mapping](QUANTUM-SOURCE-COMPARISON.md), [fixed protocol](QUANTUM-PROTOCOL.md), and [verification record](quantum-verification.json). The experiment uses independent X/Z component noise and perfect measurements; it is not a depolarizing or circuit-level study.

## Bounded objective disagreements and low-weight explanation

The [capped follow-up](TARGETED.md) reuses 22 existing quantum pairs across all 11 observed graph/kernel profiles, with no new sizes, channels, decoders or objective weights. In two Construction 3.10 disagreements, the absorbing-preferred representatives beat the eight-cycle tie-break choices by **1.5225 and 1.6300 percentage points** on fresh paired noise; both multiplicity-adjusted intervals exclude zero. These are fixed-code comparisons, and the two disagreements have swapped sector invariant profiles. The original global objective minimum still performs worse than alternatives, so there is no universal winning objective.

Exhausting all 394,486 Pauli patterns of physical weight at most two separates unavoidable stabilizer-class ambiguity from decoder excess on that finite ensemble. Five [Lean-checked lemmas](../dyadic-rank/QuantumSyndromeAmbiguity.lean) establish the reusable subgroup and finite weighted bounds, crediting the standard coset-decoding principle. The experiment itself remains computational. All tested binary pairs in the 32-qubit codes, successful or failed, are contained in a four-variable absorbing support: that containment has no specificity here. Exact low-weight failure mass accounts for about 38–40% of fresh FER in the 32-qubit cases and only 2–4% in the 96-qubit cases, so it is not an adequate general error-floor model. [Protocol](TARGETED-PROTOCOL.md) · [audit](targeted-verification.json).

The agreed cap is reached. No larger code search or decoder redesign is part of this step. All three broad research paths remain open beyond the finite advances above.

## A proved obstruction in the unchanged 32-qubit decoder

The [trajectory follow-up](TRAJECTORIES.md) now gives a concrete structural result. For error pair `{0,17}` in the existing optimized profile-2 representative, the exact min-sum update preserves seven message classes and three posterior classes. Every resulting hard decision has zero syndrome, although the target is nonzero. The [Lean proof](../dyadic-rank/DyadicMinSumTrajectory.lean) checks the actual expanded graph, integer updates and invariant for every iteration count. The same pair is corrected in five iterations by the profile-0 representative. This applies the known symmetry-trapping mechanism, with prior-art credit, rather than claiming that mechanism is new.

The capped census traces all 3,968 binary pairs across four existing CSS codes and both sectors. Both representatives agree: profile 0 has 256 symmetry-forced syndrome failures, 64 other syndrome failures and 96 logical failures across its two sectors; profile 2 has 224, 128 and 160. Thus the selected witness is a real structural obstruction, but a larger total count of these obstructions does not explain the aggregate deterioration. The exact low-weight difference is 1.1424 percentage points; the full moderate-noise difference remains only partly explained. No new candidates, noise samples, channels or decoder changes were introduced. [Protocol](TRAJECTORY-PROTOCOL.md) · [verification](trajectory-verification.json).

## Actual optimization on fresh decoding samples

The [controlled optimization comparison](OPTIMIZATION.md) now tests selection policies, beyond prediction. It evaluates 768 candidate arrays in 16 pools, all with exact parameters `[48,28,4]`. Each policy chooses from the same 48 candidates in its pool, before decoding. The experiments add 2,490,000 actual Monte Carlo decodes on fresh paired noise.

Absorbing-only optimization improves decoding over the random baseline. A weighted aggregate cycle objective performs worse, while allowing more four-cycles. An explicitly labeled shortest-cycle-first follow-up corrects that comparison: on its fresh noise sample at probability 0.05 and normalization 0.8, baseline frame error is 28.130%, shortest-cycle-first 19.849%, absorbing-only 19.683%, and joint 20.939%. The absorbing-versus-shortest-cycle-first paired interval includes zero; those policies select identical matrices in 12/16 pools. Thus the present intervention supports both policies over the baseline, without establishing absorbing-only superiority over a reasonable shortest-cycle-first rule.

These percentages are observed decoding error rates, unlike the prediction RMSE tables below. The original optimization protocol and the adaptive sensitivity protocol are saved separately. All conditions, tradeoffs and paired uncertainty intervals are in the [optimization report](OPTIMIZATION.md).

## Question and prior art

Gómez-Fonseca, Matthews, Morris and Pllaha ask which optimization objectives best correlate with performance in [Section 7 of P11](https://arxiv.org/html/2605.01942v1#S7). Their Section 6 already demonstrates decoding gains from cycle minimization. The preceding research direction asks for absorbing-set extensions and invariants predicting the error floor. Our [prior-art review](PRIOR-ART.md) credits those experiments and the classical/quantum trapping-set literature before beginning this comparison.

Particularly relevant is Pacenti, Raveendran and Vasić's [August 2026 detector-error-model study](https://arxiv.org/html/2608.11516v1): it predicts error floors by testing fault patterns within enumerated trapping sets and accounts for overlapping supports. This supports decoder-conditioned structural analysis; it does not supply a universal ranking for P11 dyadic constructions.

## Fixed pilot design

The [protocol](PROTOCOL.md) was saved before execution. It fixes 32 connected `3 × 6` arrays of dyadic permutation blocks with fiber `F₂³`. Every code has 48 variables, 24 checks, binary rank 20, classical dimension 28, variable degree three and check degree six. Selection took 74 samples; 42 were rejected for a different rank. Arrays are normalized by a zero first row and column. These are classical quasi-dyadic codes, not the paper's CSS construction.

Two flooding min-sum settings, normalization 0.8 and 1.0, use 50 iterations and shared error samples at binary error probabilities 0.02, 0.05 and 0.08. There are 3,000 frames per condition per code: **576,000 Monte Carlo decodes**. Another **75,328 decodes** cover every support of weight at most two for both settings. Classical success requires recovering the injected error exactly; syndrome matches with incorrect recovery are counted as failures.

Features are exact simple-cycle counts at lengths four, six and eight, and exhaustive absorbing-set spectra for supports of sizes two through four. The spectra retain `(a,b)`, elementary status and connectedness. The regression features separate positive-syndrome from zero-syndrome counts at each size. Constant features are retained. The 32 codes have distinct invariant fingerprints; holding out complete fingerprint groups prevents isomorphic graphs from crossing a split. Models use training-only standardization and fixed ridge penalty one.

## Held-out prediction results

The outcome is the smoothed logit of the frame error fraction. Values below are leave-one-fingerprint-group-out root mean squared prediction errors; **lower is better**. They measure prediction error, not decoder frame error rate or coding gain.

| Normalization | Error probability | Intercept only | Cycle counts | Absorbing spectrum including `b=0` | Combined |
| --- | --- | --- | --- | --- | --- |
| 0.8 | 0.02 | 1.041 | 0.702 | 0.123 | 0.094 |
| 0.8 | 0.05 | 0.785 | 0.504 | 0.102 | 0.071 |
| 0.8 | 0.08 | 0.681 | 0.436 | 0.089 | 0.078 |
| 1.0 | 0.02 | 0.667 | 0.443 | 0.082 | 0.058 |
| 1.0 | 0.05 | 0.402 | 0.261 | 0.056 | 0.062 |
| 1.0 | 0.08 | 0.298 | 0.185 | 0.057 | 0.061 |

The absorbing-feature model beats the cycle-only model in all six settings. The joint model improves further in four settings, but not the other two. These comparisons use a modest sample of codes and correlated paired noise; no statistical significance or universal winner claim follows from this table.

## What explains the apparent absorbing advantage

The first results exposed a major distinction: **21 codes have eight weight-two codeword supports each; 11 have none**. Such a support is an `(2,0)` absorbing set in this degree-three family. The 21 codes each fail on 16 of the 48 singleton error patterns for both decoder settings; the other 11 recover every singleton pattern. The smallest harmful support class therefore changes even though length, rank, degrees and connectedness agree.

An explicitly [post-hoc diagnostic](search/diagnostics.json) separates positive-`b` counts from zero-`b` counts. Zero-`b` features alone perform nearly as well as the full absorbing model across the whole population. Positive-`b` features alone are worse than cycle counts in all six settings. Thus the headline improvement cannot be attributed simply to richer positive-syndrome absorbing topology; low-weight codeword information accounts for much of it. The negative marginal correlation between eight-cycle counts and failure in this sample is also not evidence that adding eight-cycles improves decoding.

On the 11-code stratum without weight-two codewords, the diagnostic is mixed:

| Normalization | Error probability | Cycles | Positive-`b` only | Combined with zero-`b` |
| --- | --- | --- | --- | --- |
| 0.8 | 0.02 | 0.198 | 0.194 | 0.230 |
| 0.8 | 0.05 | 0.091 | 0.104 | 0.063 |
| 0.8 | 0.08 | 0.069 | 0.071 | 0.042 |
| 1.0 | 0.02 | 0.080 | 0.080 | 0.094 |
| 1.0 | 0.05 | 0.051 | 0.052 | 0.059 |
| 1.0 | 0.08 | 0.052 | 0.056 | 0.062 |

This stratum is too small for a stable winner, especially with nine candidate joint features. It was selected after seeing the pilot, so it is diagnostic rather than confirmatory. It motivated the prospective follow-up below.

## Fresh population excluding weight two codewords

The [follow-up protocol](FOLLOWUP-PROTOCOL.md) was saved before generating the new outcomes. It retains the same dimensions, rank, degree distributions, decoders and models, and prospectively excludes duplicate binary columns. Construction and noise seeds are new. Of 247 sampled arrays, 172 failed the rank condition, 41 had duplicate columns and two were disconnected; the remaining 32 were retained. They have 29 distinct graph-invariant fingerprints, one shared with the original population. Whole-fingerprint groups remain excluded together in each held-out prediction; the follow-up models are trained solely within this population.

Every follow-up code has minimum distance four: columns are nonzero and distinct, odd column weight rules out odd-weight codewords, and the exhaustive spectrum finds weight-four codewords in each code. This controls minimum distance in addition to length and dimension, while allowing weight-four multiplicity to vary.

The new experiment adds **576,000 decodes**, bringing the Monte Carlo total to **1,152,000**. All six comparisons are shown below, using the same held-out logit RMSE measure:

| Normalization | Error probability | Intercept | Cycles | Absorbing spectrum including `b=0` | Combined |
| --- | --- | --- | --- | --- | --- |
| 0.8 | 0.02 | 0.287 | 0.150 | 0.092 | 0.100 |
| 0.8 | 0.05 | 0.225 | 0.101 | 0.043 | 0.046 |
| 0.8 | 0.08 | 0.195 | 0.086 | 0.052 | 0.056 |
| 1.0 | 0.02 | 0.114 | 0.082 | 0.077 | 0.085 |
| 1.0 | 0.05 | 0.063 | 0.053 | 0.043 | 0.044 |
| 1.0 | 0.08 | 0.050 | 0.039 | 0.036 | 0.034 |

The absorbing-spectrum model beats cycles in all six settings after controlling minimum distance. The margins range from about 6% to 57% lower held-out prediction RMSE; **these percentages are not reductions in decoder error rate**. The joint model is best in only the final condition, so adding all cycle features is not automatically beneficial.

A separately labeled [post-hoc follow-up ablation](search/followup-diagnostics.json) shows positive-`b` counts alone narrowly beat cycles in the three normalization-one conditions and narrowly lose in the other three. Weight-four codeword counts and their combination with positive-`b` counts remain important. We therefore have evidence for retaining both parts of the small-support spectrum, rather than proclaiming that positive-syndrome absorbing sets universally outperform cycle counts. The larger reductions at normalization 0.8 and smaller margins at 1.0 also reinforce the need to specify decoder settings.

## Current answer and next experiments

Cycle counts provide predictive information in both populations. Including zero-syndrome absorbing supports improves prediction beyond cycles even after controlling minimum distance, while positive-syndrome counts alone are not a consistent winner. The prediction studies motivated the optimization intervention linked above. That intervention confirms gains over the baseline for both absorbing-only and shortest-cycle-first selection in this family, while retaining codeword multiplicities as an important distinction. Prediction and intervention are separate evidence; neither isolates the causal effect of one graph invariant.

The literal quantum extension and capped low-weight follow-up above now implement source layouts, stabilizer-aware scoring and decoder-conditioned support diagnostics. A universal objective ranking, complete structural decoder-trajectory explanation and validated general error-floor predictor remain unresolved; the trajectory follow-up now proves one concrete all-iterations obstruction. This step stops at the fixed 22-pair cap; no larger experiment is authorized by its protocol.

The completed [Lean forbidden-set proof](../dyadic-forbidden/APPENDIX-ENUMERATION.md) remains a separate mathematical result. The prediction and optimization experiments add computational evidence; the bounded follow-up adds five general supporting ambiguity lemmas, not completion of the source research direction. The inventory research direction **L-P11-invariants** remains unresolved; the fixed cohort of completed Lean targets is unchanged.

## Reproduction and audit

From the repository root, with Python 3 and a C++17 compiler:

```sh
python3 formalization/dyadic-performance/search/pilot.py
python3 formalization/dyadic-performance/search/diagnose.py
python3 formalization/dyadic-performance/search/followup.py
python3 formalization/dyadic-performance/search/diagnose.py --followup
python3 scripts/validate_dyadic_performance.py
python3 formalization/dyadic-performance/search/optimize.py
python3 formalization/dyadic-performance/search/lexicographic.py
python3 scripts/validate_dyadic_optimization.py
python3 formalization/dyadic-performance/search/report_optimization.py
python3 formalization/dyadic-performance/search/quantum_benchmark.py
python3 scripts/validate_quantum_dyadic.py
python3 formalization/dyadic-performance/search/report_quantum.py
python3 formalization/dyadic-performance/search/targeted.py
python3 scripts/validate_dyadic_targeted.py --lean
python3 formalization/dyadic-performance/search/report_targeted.py
python3 formalization/dyadic-performance/search/trajectory.py
python3 formalization/dyadic-performance/search/generate_trajectory_lean.py
python3 scripts/validate_dyadic_trajectories.py
python3 formalization/dyadic-performance/search/report_trajectory.py
```

The [initial results](search/results.json) and [follow-up results](search/followup-results.json) retain every array, feature spectrum, Wilson interval, failure classification, held-out prediction, seeds, dependency hashes and compressed paired failure bitmaps. Bitmaps are zlib-compressed bytes encoded as base64, most significant bit first; the final byte is zero-padded. Monte Carlo ordering is the seeded sample order; exact supports are ordered by weight and then lexicographically. The archived protocols and source hashes distinguish the fixed comparisons from later exploratory diagnostics.

Checks passed for independent XOR/dense-matrix expansions, rank and connectedness, cycle enumeration on complete bipartite and single-cycle graphs, independent four-cycle formulas and pair absorbing spectra, full feature recomputation on three graphs, and 48 C++ versus Python decoder comparisons including all tree error patterns. Reusable engine sources are linked by hash; no binary is stored. All findings are local and have not been committed or pushed.
