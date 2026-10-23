# Exact distance and a genuinely matched decoding comparison

The three existing comparison codes do **not** all have the same distance. Their exact quantum distances are **10, 12 and 10**, respectively. We therefore compare only `previous_best` and `minimum_4`, both `[[252,10,10]]`, on fresh noise. At the prespecified primary probability 0.04, failure is **2.731% versus 2.709%**, with a paired difference of **-0.0220 percentage points** and 95% interval **[-0.1532,+0.1092]**. This comparison does not establish a primary-condition winner. An interval including zero is not an equivalence or no-effect proof.

## What changed, and what was held fixed

The earlier [weight-six census](LOW-WEIGHT-LOGICALS.md) gave baseline distance six and lower bounds of eight for all comparison codes. It identified the distance confound in the original absorbing-count benchmark. The new work resolves the exact distances of the three existing comparison designs, then uses a precisely matched subset. No matrix, size, channel, decoder or objective weight was changed. No new candidate population was generated.

The [protocol](DISTANCE-MATCHED-PROTOCOL.md) distinguishes exploratory upper-witness searches from the distance audit and fixes the fresh comparison before its outcomes exist. Existing decoded outcomes were already known; the new noise is independent, and all distance-matched members are retained regardless of how favorable their old outcomes were. The original distance-six baseline and distance-twelve `minimum_2` are excluded from the primary matched contrast.

| Saved design | Interior exponents | Physical qubits | Logical qubits | Exact distance, X / Z | Four-variable absorbing supports |
| --- | --- | ---: | ---: | --- | ---: |
| Original baseline | (1,2,3,6) | 252 | 10 | 6 / 6 | 3,150 |
| Previous best | (1,2,3,8) | 252 | 10 | 10 / 10 | 2,646 |
| Minimum 2 | (1,3,6,10) | 252 | 10 | 12 / 12 | 2,520 |
| Minimum 4 | (1,4,6,2) | 252 | 10 | 10 / 10 | 2,520 |

This also sharpens interpretation of the original paper's best measured improvement: `minimum_2` has distance twelve versus the original baseline's six. That remains a real comparison of code performance, but it does not isolate absorbing-count effects. The existing PDF reports valid lower bounds and the distance confound; this new exact-distance experiment is documented here as a separate continuation.

## How exact distances were established

The previous complete census excludes all nontrivial logical words below eight in the three comparison codes. Odd column degree three excludes odd-weight binary kernel words. We now provide explicit kernel witnesses outside the full stabilizer span at weight ten (`previous_best`, `minimum_4`) or twelve (`minimum_2`). Separate lower-bound searches exclude all intervening even weights, in both sectors.

The primary search anchors a variable at fiber zero in its smallest occupied circulant block. Cyclic translation preserves both check-row sets and stabilizer-row sets, which is verified directly; thus every logical support has a translated representative in one of these anchored searches. At a partial support with an unsatisfied check, every valid completion must select at least one unselected neighbor of that check. Branching on the first such selected neighbor and excluding earlier alternatives covers every completion. The number of odd checks cannot exceed three times the remaining support budget. Unique one- and two-column syndrome tables handle the last one or two variables exactly. A zero-syndrome stabilizer prefix cannot extend to a different kernel word by at most four additional variables, because all nonzero kernel words have weight at least six. These properties justify the completed exclusions at bounds eight and ten. Budget exhaustion is separately recorded, and no budget was exhausted.

An independent algorithm starts from **every simple Tanner cycle of length eight or ten**, then completes its variable support using a separate traversal without the anchoring or sibling-exclusion strategy. Its completeness for the required lower bounds follows from two structural observations:

1. A zero-syndrome support of size at most ten has only induced check degrees two. If one check met four selected variables, each would require another selected variable through each of its other two checks. The eight witnesses must be outside the original four and pairwise distinct, by four-/six-cycle exclusion. This would require at least twelve selected variables. Higher even check degrees are also impossible.
2. Contracting those degree-two checks gives a simple cubic triangle-free graph on at most ten vertices. If it had neither a four- nor a five-cycle, the edge-rooted Moore argument would require at least fourteen vertices: two edge endpoints, four neighbors and eight distinct next-level neighbors. Hence every such kernel support contains an eight- or ten-cycle in the Tanner graph.

Enumerating all cycle supports and all bounded completions therefore independently covers every possible logical support at the exclusion bounds. The four-cycle support counts agree with the earlier exhaustive absorbing inventories. Both implementations agree on every lower bound. Opposite-pivot binary elimination independently verifies each upper witness's nonmembership in the full companion span. Four positive controls recover known weight-six and weight-ten logical words, guarding against an always-negative search implementation.

These are **exact finite computational results with written completeness arguments**, not Lean-checked exhaustive searches or a universal distance formula. Source hashes, node counts, budgets, explicit witnesses and independent validation outcomes are retained. Equality of both CSS-sector distances gives the stated quantum distance; a mixed Pauli logical must have a nontrivial sector component and cannot have smaller support than that component.

## Fresh matched decoding experiment

Both codes are connected, have girth eight, ranks `(121,121)`, dimension ten and exact distance ten. Their absorbing counts differ by 126, about 4.76%. The experiment retains the paper's one-sector independent Bernoulli noise, perfect syndrome measurements, normalized min-sum flooding with alpha 0.8, 100 iterations, twenty fractional bits, integer rounding and clipping at absolute LLR 50. Residuals in the complete companion stabilizer span count as successes. This is not a full depolarizing, two-sector or circuit-level simulation.

A new seed `20261024` produces 100,000 noise patterns at each probability, shared across the two codes. The stream uses the unchanged paper sampling routine. There are **300,000 independent sampled patterns** and **600,000 decoder evaluations**, not 600,000 independent noise samples. The single primary comparison is at p=0.04; the other probabilities are secondary. Negative differences favor `minimum_4`.

| Component error probability | Previous best FER | Minimum 4 FER | Difference (percentage points) | Paired 95% interval (points) |
| --- | ---: | ---: | ---: | --- |
| 0.01 secondary | 0.042% | 0.022% | -0.0200 | [-0.0357, -0.0043] |
| 0.02 secondary | 0.263% | 0.248% | -0.0150 | [-0.0571, +0.0271] |
| 0.04 **primary** | 2.731% | 2.709% | -0.0220 | [-0.1532, +0.1092] |

The primary interval includes zero. The nominal secondary interval at p=0.01 excludes zero, while p=0.02 does not. Those secondary intervals are pointwise and not corrected for multiple comparisons. They do not overturn the primary result or establish a universal objective advantage. Matching minimum distance does not match logical multiplicities, complete spectra, message dynamics or every other graph property.

At p=0.04, `previous_best` has 2,686 syndrome failures and 45 syndrome-matched logical failures; `minimum_4` has 2,673 and 36. There are 5,912 and 6,009 successful nonzero stabilizer residuals, respectively. Mean iterations are 9.04059 and 9.02466. These decompositions describe observed outcomes; they do not isolate a causal mechanism for their small difference.

## What this closes and what remains

The exact distances are now known for all four saved benchmark designs. We removed the minimum-distance confound for one fresh comparison while preserving length, dimension and decoder settings. Under those controls, the primary experiment does not establish superiority of the smaller absorbing-count code. The earlier large baseline-to-`minimum_2` gain remains a joint change in code structure and distance.

Still open are causal separation of absorbing topology from other invariants, an objective that consistently improves performance across code populations, and a general error-floor predictor. No threshold, asymptotic error-floor law or global absence of an objective effect follows from this finite result. The source's broader decoding-related program remains only partly answered. This step completes the requested exact-distance audit and bounded matched comparison; it adds no completed source target to the coverage denominator.

## Reproduce and audit

```sh
# Repository root
python3 formalization/cyclic-lifts/search/exact_distance.py
python3 scripts/validate_cyclic_exact_distance.py
python3 formalization/cyclic-lifts/search/distance_matched.py
python3 scripts/validate_cyclic_distance_matched.py
python3 formalization/cyclic-lifts/search/report_distance_matched.py
```

[Distance searches and witnesses](search/exact-distance-results.json) · [Independent cycle-seeded exclusions](search/exact-distance-validation.json) · [Positive controls](search/exact-distance-positive-controls.json) · [Frozen matched selection](search/distance-matched-selection.json) · [All decoding results](search/distance-matched-results.json) · [Distance checks](exact-distance-checks.log) · [Matched checks](distance-matched-checks.log) · [Verification manifest](distance-matched-verification.json).

The original decoder's 128 reference comparisons and 638 total checks pass on the matched codes. An additional 72 comparisons check actual fresh-stream inputs with the direct Python message equations. All stored noise hashes, outcome bitmaps, category totals, Wilson intervals and paired intervals are reconstructed independently by the validator. The benchmark helper's internal reference-arm name `baseline` is explicitly relabeled `previous_best` in the archive, so it cannot be mistaken for the excluded distance-six code.
