# Whole-dissertation continuation

The source-count Bayesian recovery and power studies remain unfinished. This continuation adds response-generation checks, fuller assessments of the saved Chapter 6 grid, ordinary mathematical proofs, and bounded convergence experiments. None replaces the missing source-count posterior aggregates or unavailable empirical refits.

The current 22-page main paper integrates these findings and corrected coverage. Its source is `paper/standalone.tex`; exact reviewed artifact hashes and remote downloads are recorded in `provenance/delivery-current-v2.json`. The earlier reviewed 17-page manuscript remains available at commit `241fd4ae49dce3d2d9d7351c53306ab528b08ecb`, SHA256 `d1aee6a0f1c488ea68cc76b8489949f3acaa9aa7a96f48b6ed54391446b9fefb`. The current paper is a scientific milestone, not completed whole-dissertation replication.

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

The single fixed recovery completed all four chains with 28,000 retained draws each. All 14 monitored quantities pass the unchanged operational criteria: maximum rank-normalized split/folded Rhat 1.00167324, minimum bulk ESS 685.7621, minimum tail ESS 1407.5320 and maximum mean MCSE/SD 0.03821134. This is one N500/J60 floor dataset, not a source-count recovery or power experiment. Independent numerical and all-page diagnostic review is recorded in `provenance/jags-centered-extended-recovery-independent-review.json`; the machine gate is not a proof of convergence.

The preceding 28,000-draw attempt was cancelled by an owned-child process-guard false positive. Its incomplete checkpoint files and stale chain-1 manifest are preserved without repair. The completed recovery uses the independently reviewed group-aware guard. Every first 12,000-draw trajectory prefix equals the earlier completed centered run exactly; these runs must never be pooled as independent samples.

The recovery consumed 4,927.558 summed chain-process wall seconds within its separately authorized 5,500-second allocation, with no cleanup termination needed. Preparation took 0.751 seconds and diagnostic analysis 8.262 seconds under separate fixed caps. Earlier follow-up attempts consumed 9,006.183 seconds; including the historical initial gate and this recovery, all attempts total 16,832.813 summed chain-process seconds. These are process elapsed times, not measured CPU time.

No model process remains active and no source-count posterior grid has started. The remaining-target plan identifies 3,250 source-design datasets and 3,450 dataset-method fits; chains are not additional datasets. Further engine validation and representative cost pilots require a concrete bounded allocation before any larger production. Passing one diagnostic does not authorize a production grid.

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
