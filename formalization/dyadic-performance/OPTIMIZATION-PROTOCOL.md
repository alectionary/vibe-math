# Controlled optimization comparison

Fixed October 23, 2026 before generating candidate pools or decoding outcomes. This follows the prediction studies and implements the requested intervention: select codes by graph objectives, then decode on fresh samples. It is not an externally registered study.

## Population and equal search budgets

Generate 16 independent pools of 48 admissible arrays using construction seed 20261027. Arrays have the same normalized `3 × 6` full-support dyadic layout over `F₂³` as before. Each must be connected, have binary rank 20, no duplicate expanded binary columns, and have a weight-four codeword. All codes therefore have parameters `[48,28,4]`, variable degree three and check degree six. Check distance by an independent pair-syndrome collision calculation; retain a weight-four witness. Record rejected candidates and avoid duplicate arrays across the entire new experiment. Do not discard a candidate for unfavorable cycle or absorbing counts. Record fingerprint overlap with earlier populations and between pools without selecting on it.

Each pool supplies an unoptimized baseline (its first admissible candidate), a cycle-only winner, an absorbing-only winner and a joint winner. The three optimizers see exactly the same 48 candidates. This is bounded best-of-48 random-search optimization, not a claim of a global optimum or equal wall-clock cost for different metrics. Tie-break by lexicographic flattened label array, independently of decoder results. Save the entire selected-code manifest before running any decoder.

## Fixed objectives

Reference centering and scaling use only graph features of the previously saved 32-code distance-four follow-up population, never its decoding outcomes. For each feature use `z = (log(1+count)-reference_mean)/reference_population_standard_deviation`. Ignore features constant in the reference population. All nonconstant feature weights are positive and equal within their family.

- **Cycle-only:** minimize the mean standardized counts of simple cycles of lengths four, six and eight.
- **Absorbing-only:** minimize the mean standardized counts of positive-syndrome absorbing supports of sizes two, three and four, plus zero-syndrome supports of size four. This follows the earlier useful spectrum, including classical codewords. It is not restricted to positive-syndrome trapping configurations.
- **Joint:** minimize half the cycle-only score plus half the absorbing-only score.

The distance constraint fixes the smallest nonzero codeword weight, not its multiplicity. Record the weight-four codeword count separately to distinguish improving its multiplicity from improving positive-syndrome absorbing structures. The chosen positive weighted aggregate is one explicit objective per family; conclusions do not automatically apply to every alternative weighting or lexicographic girth objective.

## Fresh decoding and primary comparison

Use the existing independently checked flooding min-sum engine, 50 iterations, normalizations 0.8 and 1.0, and binary error probabilities 0.02, 0.05 and 0.08. For each pool/probability draw 5,000 error vectors from a new stream seeded `20261028 + 100*pool_index`; share them across all four arms and both decoder settings within that pool. Different pools use different samples. Decoder success requires exact classical error recovery; retain syndrome failures and wrong-syndrome-matching recoveries separately. Reuse identical selected candidates' decoding results within a pool and report both nominal arm evaluations and actual decoder executions.

The fixed primary condition is probability 0.05 and normalization 0.8. Report all six pairwise arm differences in frame error fraction there. For each contrast bootstrap the 16 independent pools as paired blocks, 20,000 resamples, seed 20261029. Report 95% percentile intervals and 99.1667% percentile intervals (Bonferroni marginal level for six primary contrasts). These approximate bootstrap intervals account for sampled construction pools and their independent noise streams; they are not exact finite-sample coverage guarantees. Report all other five conditions as secondary sensitivity analyses with descriptive paired 95% intervals, without choosing a favorable condition afterward. Preserve failure bitmaps so disagreement on individual samples is inspectable.

## Checks and interpretation

Verify independent matrix expansion, connectedness, rank, absence of duplicate columns, distance witness, simple-cycle counts and the full size-at-most-four absorbing spectrum. Check the weight-four count independently from pair-syndrome collisions. Verify actual selected arrays minimize their declared score over the saved candidate pools. Check the C++ decoder against the Python reference on low-weight patterns for selected graphs, and recalculate every output syndrome during scoring.

A lower graph objective is not itself decoding improvement. Compare each optimizer to the baseline and to the other optimizers, reporting unfavorable and uncertain outcomes. The intervention tests these explicit selection policies within a short classical dyadic ensemble. It is not a Lean theorem, a quantum logical-error study, an asymptotic error-floor measurement, or a resolution of all P11 constructions.
