# Whole-dissertation continuation

The source-count Bayesian recovery and power studies remain unfinished. This continuation adds response-generation checks, fuller assessments of the saved Chapter 6 grid, ordinary mathematical proofs, and bounded convergence experiments. None replaces the missing source-count posterior aggregates or unavailable empirical refits.

The existing 17-page main paper remains the reviewed milestone at commit `241fd4ae49dce3d2d9d7351c53306ab528b08ecb`. Its PDF SHA256 is `d1aee6a0f1c488ea68cc76b8489949f3acaa9aa7a96f48b6ed54391446b9fefb`. These additional findings have scientific review records but have not been incorporated into a newly reviewed main paper.

## Coverage and evidence

[coverage-v4.csv](coverage-v4.csv) separates completed pilots from unfinished exact targets. It retains all 996 source records and their frozen scientific adjudications. Current operational counts are 10 completed narrow targets, 311 completed attempts, 404 attempted-incomplete records, 16 pending records and 255 blocked records. The exact-target column has 391 pending records, including 355 linked source-count aggregate records. These are dependent inventory records, not independent experiments or a replication success fraction. Historical fields are preserved in `prior_*` columns for the 30 updated rows.

- [generator-summary-scientific-evidence.json](handoff/generator-summary-scientific-evidence.json): 2,650 response-generation datasets across 19 conditions, with no posterior fits. The 19 pilot datasets repeat the first fixed seeds and are not additional independent observations.
- [generator-alpha-sensitivity-scientific-evidence.json](handoff/generator-alpha-sensitivity-scientific-evidence.json): raw versus standardized alpha on the same 2,650 regenerated datasets. Standardization does not close the reported alpha differences; source aggregation remains unresolved.
- [chapter6-saved-target-assessment.json](outputs/chapter6-saved-target-assessment.json): descriptive assessment of all 26 previously unclosed qualitative targets. It adds no model fits or new significance tests. Precision evidence is not measured power, and failure to exclude zero is not equivalence.
- [continuous-moderator-identification-check.json](provenance/continuous-moderator-identification-check.json): a conditional population-identification proof allowing rich, disjoint moderator supports across zygosities. It does not establish finite-sample likelihood uniqueness.
- [non-gaussian-latent-moment-check.json](provenance/non-gaussian-latent-moment-check.json): inversion of latent moments for the Chapter 2 model at fixed finite parameters. Identification from finite observed Rasch responses remains open.
- [compute-remedies-independent-review.json](provenance/compute-remedies-independent-review.json): reviewed centered-model equivalence and exact Rasch score-likelihood factorization. Neither mathematical equivalence nor sufficiency establishes computational speed or convergence.
- [jags-centered-scientific-evidence.json](handoff/jags-centered-scientific-evidence.json): the completed source-length centered diagnostic still fails the unchanged joint convergence gate.

The final, fixed longer centered experiment is specified in [jags-centered-extended-plan.json](provenance/jags-centered-extended-plan.json). Its result must be read from its terminal ledger and independent outcome review, not inferred from successful adaptation or a partial checkpoint. Earlier process-guard aborts and the failed convergence results remain preserved.

## Final diagnostic status

The 28,000-draw experiment was cancelled at 04:05:18 UTC on 31 October 2026. The guard mistook a checksum shell in chain 1's own process group for a competing model. Zero of four requested chains completed the planned length. Chain 1 saved 12,000 rows with a stale 8,000-row checkpoint manifest; the other chains saved 8,000 rows with matching manifests. Every saved prefix and sampler state matches previously retained centered evidence, so this interruption adds no new independent posterior evidence or convergence conclusion.

See [jags-centered-extended-interruption-audit.json](provenance/jags-centered-extended-interruption-audit.json) and its [independent review](provenance/jags-centered-extended-interruption-independent-review.json). The frozen files, including the inconsistent manifest, are preserved. The new process-group-aware dispatcher passes independent regression checks but has not been exercised on another model run. There was no restart.

This follow-up consumed 9,006.183 summed chain-process wall seconds; including the earlier initial diagnostic gives 11,905.255 seconds. These are different accounting scopes, not measured CPU time. The follow-up allocation was 12,000 seconds. A fresh run at the same limits would require up to 5,480 chain-process seconds plus 20 seconds of cleanup, exceeding its remaining allocation. Preparation and diagnostic analysis have separate caps. A new resource plan is required before further execution; no source-count grid has started.

## Reproduction

Use the R/JAGS runtime and package versions documented in the study's original [README.md](README.md) and pinned runtime manifests. The actual execution environment uses `/workspace/slot3-runtime/bin/Rscript` and the separate posterior library. Run the following from this study directory.

Saved-output checks and ordinary algebra:

```sh
python simulation/assess_chapter6_saved_targets.py
python simulation/analyze_generator_summaries.py
python simulation/analyze_alpha_sensitivity.py
python simulation/continuous_moderator_identification_check.py
python simulation/non_gaussian_latent_moment_check.py
python simulation/rasch_sufficiency_check.py
python simulation/reconcile_continuation_coverage.py
```

These commands analyze saved evidence or check algebra; they do not fit models. They regenerate their own output files. The Chapter 6 assessment also requires the separately held dissertation text with its recorded hash. Source PDF/text are not redistributed here.

Response generation, using a fresh output directory:

```sh
/workspace/slot3-runtime/bin/Rscript simulation/validate_generator_summary.R NEW_VALIDATION.csv
timeout 60 /workspace/slot3-runtime/bin/Rscript simulation/generator_summary_check.R production/NEW_PILOT pilot
timeout 600 /workspace/slot3-runtime/bin/Rscript simulation/generator_summary_check.R production/NEW_GENERATION run
timeout 300 /workspace/slot3-runtime/bin/Rscript simulation/generator_alpha_sensitivity.R production/NEW_ALPHA_CHECK
```

The alpha sensitivity intentionally checks the retained canonical generator outputs and pinned generator bytes. It regenerates the same seeds, rather than adding independent datasets.

A fresh execution of the fixed final diagnostic, requiring its separately declared allocation:

```sh
python simulation/dispatch_jags_centered_extended_guarded.py check --namespace production/NEW_CENTERED_DIAGNOSTIC
python simulation/dispatch_jags_centered_extended_guarded.py dispatch --namespace production/NEW_CENTERED_DIAGNOSTIC
python simulation/dispatch_jags_centered_extended_guarded.py diagnose --namespace production/NEW_CENTERED_DIAGNOSTIC
```

The dispatcher refuses nonempty execution namespaces and conflicting known model processes. It pins code, prepared inputs and runtime bytes, caps each chain, preserves all four requested outcomes and writes partial checkpoints. It does not automatically resume, replace chains, lengthen sampling or launch a source-count grid. Partial checkpoint data and sampler-state files are valid together only when their hashes match the checkpoint record.

The interrupted canonical run has no complete final draws and cannot pass `simulation/validate_saved_centered_extended_outcome.py` or the full-length `simulation/check_centered_trajectory_prefix.R`. Its actual partial-file checks are recorded in [jags-centered-extended-interrupted-checkpoints.csv](provenance/jags-centered-extended-interrupted-checkpoints.csv). Full-length helpers are retained for an explicitly authorized, completed future run; the prefix helper requires a new CSV output filename. Reused trajectory prefixes must never be pooled as independent draws with the earlier centered run.
