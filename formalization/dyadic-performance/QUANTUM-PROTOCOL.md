# Quantum CSS objective comparison

Fixed before generating benchmark candidate pools and decoder outcomes, after checking source formulas and sampling geometry for feasibility. This is a controlled empirical extension to P11's actual CSS constructions, not a reproduction of its Figure 1 curves or an externally registered experiment.

## Source models and matched strata

Use [P11](https://arxiv.org/html/2605.01942v1), Constructions 3.10 and 3.11, Equations (8) and (9). Retain all four check-block rows. No classical array is substituted for a CSS pair.

- Construction 3.10: `omega=4`, fiber `F₂²`, `sigma=(0 1 2 3)`, all six four-cycles available for `tau`, `x[0]=0`, other labels sampled uniformly. Enforce Equation (8) and direct binary commutation. Accept only connected pairs with ranks `(12,12)`, quantum dimension eight and sector distances `(4,4)`. Parameters are **[[32,8,4]]**.
- Construction 3.11: `v=6`, fiber `F₂³`, fixed permutation `P=P_0`, all six labels sampled uniformly. Use exactly the four displayed alternating rows, with the source's reversal/rotation patterns, and `H_X=H_Z=H_P`. Accept only connected graphs with ranks `(28,28)`, quantum dimension 40 and sector distances `(4,4)`. Parameters are **[[96,40,4]]**.

These are separate strata: compare policies within each construction, not absolute error rates between lengths/dimensions. Fixing `P=P_0` in 3.11 uses a common fiber translation of all columns. The source describes 3.10 with a commutation constraint; arbitrary sampled labels and cyclic permutations are not assumed to satisfy it automatically. Every accepted instance is checked.

Geometry-only feasibility samples found nontrivial graph-feature variation in 3.10 at the first stratum. Smaller full-row 3.11 samples at fixed rank/distance showed constant feature profiles, motivating the larger `v=6` stratum. The two strata and ranks were chosen without examining quantum decoding outcomes.

## Exact quantum distance and stabilizer quotient

Compute binary ranks exactly and `k=n-rank(H_X)-rank(H_Z)>0`. For Z errors the relevant space is `ker(H_X)/rowspan(H_Z)`; for X errors it is `ker(H_Z)/rowspan(H_X)`. Enumerate every kernel support of weights one through four using column syndromes and pair-syndrome collisions. Test membership in the opposite check row span. Accept only if neither sector has a non-stabilizer support below weight four and both have a weight-four logical witness. This certifies exact quantum distances, even when small classical codewords are benign stabilizers. Retain stabilizer and logical support counts separately.

## Candidate budgets and objectives

For each family first generate 24 admissible calibration examples, using only graph features to set means/standard deviations of `log(1+count)`. Then generate 16 pools of 24 admissible candidates each. Avoid repeated parameter arrays within a family. Construction seed is `20261101+100000*family_index`, with family order 3.10 then 3.11. Calibration and evaluation parameter arrays are disjoint. Record rejected parameters by reason.

For every candidate count simple four-, six- and eight-cycles and all absorbing supports of sizes two through four, retaining `(a,b)`, elementary status and connectedness. Sum counts over both Tanner graphs, keeping their individual spectra as well. Absorbing features are positive-`b` and zero-`b` totals at each size. Record zero-`b` stabilizer/logical classifications separately; the raw spectrum objective is retained for comparability and does not presume every stabilizer support is harmful.

Select five policies from each identical pool:

1. Baseline: first admissible candidate.
2. Cycle-only primary policy: lexicographically minimize total four-, six-, then eight-cycles.
3. Absorbing-only: minimize the mean standardized log count over nonconstant absorbing features.
4. Joint: minimize half the standardized aggregate cycle score plus half the absorbing score, as in the preceding intervention.
5. Aggregate-cycle sensitivity: minimize the standardized aggregate cycle score, retaining the preceding study's weighting check.

Every optimizer sees the same 24 candidates; this is best-of-24 search, not global optimization or equal metric-computation time. Break objective ties by the earliest candidate, so a flat objective does not arbitrarily relabel a code and produce apparent differences. A wholly constant feature family gets score zero. Save all selections before starting any decoding. No quantum decoding outcome is used for selection or calibration.

## Quantum channel and success

Use perfect syndrome measurements and independent binary X and Z components, each with probabilities `p=0.01,0.02,0.05`. This Pauli channel has probabilities `I=(1-p)^2`, `X=Z=p(1-p)`, `Y=p^2`; `p` is not the total physical error probability and the model is not depolarizing or circuit-level noise.

Decode Z components using `H_X` and X components using `H_Z`, with the existing syndrome-based flooding min-sum decoder, 50 iterations, normalization 0.8 or 1.0. The decoder sees its checks, syndrome and prior; stabilizer row spans and injected errors are used only for scoring. A frame succeeds iff the residual Z component lies in `rowspan(H_Z)` and the residual X component lies in `rowspan(H_X)`. Count nonzero stabilizer residuals as successes. Separate exact recovery, non-exact stabilizer-equivalent success, syndrome-matched logical failure and failure to match a syndrome.

Use 5,000 independent quantum frames per pool/condition, sharing the same X/Z vectors across policies and normalizations. Noise seeds are `20261103+100000*family_index+100*pool_index`, distinct from the preceding experiments. Cache identical selected candidates within a pool. Report nominal arm-frame evaluations, actual quantum-frame evaluations, two-sector decoder executions and reference checks separately.

## Analysis and checks

The fixed primary condition is sector probability 0.02 and normalization 0.8. Compare all six contrasts among the four primary policies separately for each family. Use 20,000 paired pool-bootstrap resamples with seed 20261104, 95% descriptive intervals, and 99.5833% intervals at the primary condition (Bonferroni marginal level for 12 contrasts across two strata). Approximate percentile intervals based on 16 pools are not exact simultaneous coverage guarantees. Report all other conditions and aggregate-cycle comparisons as secondary sensitivities.

Audit literal block construction, independent dense expansion, binary commutation, exact ranks, logical-distance witnesses and low-weight stabilizer/logical counts. Cross-check the fast C++ graph counter against the Python enumerator. Compare the C++ decoder with its independent reference, and explicitly test nonzero stabilizer residuals, nontrivial logical residuals and both-sector success. Preserve source/dependency hashes, seeds, candidates, selections and paired outcome bitmaps. Broader quantum families and rare-event error floors remain outside this finite comparison.
