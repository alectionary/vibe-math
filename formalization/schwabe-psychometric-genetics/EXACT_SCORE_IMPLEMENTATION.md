# Calibrated Rasch implementation checkpoint

This additive technical checkpoint validates an exact likelihood implementation. It is **not a posterior replication or a completed source-count experiment**. The reviewed 22-page main paper and its scientific evidence packet remain unchanged.

`simulation/exact_rasch_score.py` implements normalized score probabilities with log-space coefficients, derivatives, response-pattern probabilities, and their known constants. Calibration is fixed and known. Observed masks are retained separately for each person. Unknown item calibration, unequal item discriminations, and informative missingness require additional models and are not justified by this reduction.

`simulation/rasch_score_jags_adapter.py` preserves the Chapter 2 latent model and priors. Its score graph uses a canonical response pattern and an observed-zero Poisson factor. This differs from the item target by a known parameter-independent constant. It is not itself a normalized score PMF; constants must be restored for probability, evidence or deviance comparisons. Both graphs use JAGS, so this is not an independent-engine validation. No speedup is claimed.

The existing 1,000-person, 60-item dataset gives a maximum full log-target difference residual of 1.10e-11 across three fixed latent/global settings. Independent high-precision checks cover coefficients, normalization, boundaries, extreme predictors, masks and derivatives. Three tiny JAGS fixtures compiled with zero adaptation and zero posterior iterations. Compilation does not establish mixing, resource feasibility or numerical validity at every future sampled state.

Run from this study directory, using Python with mpmath, scipy and sympy and the recorded R/JAGS installation:

```sh
python simulation/test_exact_rasch_score_independent.py
python simulation/check_exact_score_saved_data.py
python simulation/check_score_graph_compilation.py
python simulation/score_stage_concavity_checks.py
python simulation/test_failure_preserving_aggregation_independent.py
```

The saved-data audit uses the existing ignored runtime dataset; its hash and immutable original generation recipe are preserved in prior provenance. These commands perform no sampling. Audit scripts may refresh their own timing records. The new aggregation helper tests only synthetic records: requested IDs survive missing, failed and unclassified outcomes; recovery summaries remain provisional; detection bounds and binomial intervals preserve the full requested denominator.

Ordinary proofs establish a unique finite individual-trait MLE exactly for interior Rasch scores and a unique conditional trait-block MAP under a fixed proper Gaussian prior. Explicit augmented-posterior nonconcavity witnesses rule out one global-concavity proof route; they do not establish multiple maxima or contradict marginal-likelihood uniqueness. The broad observed-response identification and marginal-likelihood claims remain pending.

## Next resource decision

The precise proposal is `provenance/score-pilot-source-and-resource-plan.json`. Its smallest option A0 reuses the reviewed four item-likelihood chains and requests four new score-representation chains on the same saved dataset: 1,600 seconds per chain, 6,420 summed chain/cleanup seconds, 7,740 all-phase summed process seconds, and a 3,600-second elapsed deadline. It requires four worker slots, a 1 GiB cap per worker and 2 GiB free reserve. Fixed lengths, seeds, convergence criteria and failure retention are declared in that plan. The cost ceiling is based on observed item-chain timings, not measured score-graph throughput.

This is a **resource choice ready for consideration, not a dispatch-ready command**. Frozen compatible latent starts, original-draw reuse verification, exact launcher commands and independently tested enforcement of all proposed caps remain feasible low-compute implementation work. A truly independent second backend also remains unimplemented. These are unfinished work, not missing-data or budget blockers. No sampling approval is inferred from approval of code publication.

The second predetermined dataset is N=2,000 pairs, J=60, Delta=1.7, seed 9201701. A separately approved larger-case stage would follow the reference review; no stage runs automatically. Source-count recovery, power and sufficiency targets remain pending. No new chains, new datasets, source-count runs, PR or merge were performed in this checkpoint.
