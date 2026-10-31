# Reproducing the completed reconstruction and diagnostics

Use immutable repository revision `2424e0f4d67929ba72255ef6f546ba2a72c25df0` in a separate checkout. It contains the original replication code, completed Chapter 6 reports, generation summaries, mathematical checks, all fixed recovery draws and their diagnostics. Work from `formalization/schwabe-psychometric-genetics`.

Python versions are recorded in `provenance/continuation-python-runtime.json`. R 4.5.0, JAGS 4.3.2, rjags 4-16 and the package archives are pinned in `provenance/runtime-packages.json`; posterior 1.6.1 has a separate manifest and library. The R package version of coda is 0.19.4.1 (Debian package 0.19-4.1-1). The tested launcher is `/workspace/slot3-runtime/bin/Rscript`; runtime reconstruction instructions are in `README.md`.

These saved-output checks do not fit models:

```sh
python simulation/validate_saved_centered_extended_recovery_outcome.py \
  --namespace production/jags-centered-extended-recovery-v1 \
  > /tmp/schwabe-recovery-independent-check.json
/workspace/slot3-runtime/bin/Rscript \
  simulation/check_centered_recovery_trajectory_prefix.R \
  /tmp/schwabe-new-prefix-check.csv \
  production/jags-centered-extended-recovery-v1
/workspace/slot3-runtime/bin/Rscript \
  simulation/check_centered_recovery_shared_posterior.R
python simulation/analyze_generator_summaries.py
python simulation/analyze_alpha_sensitivity.py
python simulation/continuous_moderator_identification_check.py
python simulation/non_gaussian_latent_moment_check.py
python simulation/rasch_sufficiency_check.py
```

The prefix-check output must be a new filename. The shared-library check and summary/algebra scripts regenerate their named outputs in this separate checkout. Independent Rhat/summaries and shared-library ESS/MCSE checks have different independence scopes. The recovery is four chains on one dataset; its repeated 12,000-draw prefixes must not be pooled with earlier runs.

The saved Chapter 6 recipe is `handoff/terminal-reproduction.md`. Its 96,000 method fits use 48,000 datasets, with no failed or guard-invalid fits. The additional descriptive assessment can be rerun using `python simulation/assess_chapter6_saved_targets.py`, but requires the separately held dissertation text and recorded hash. Full copyrighted source files and unlicensed original programs are not included. Rebuilding reports from saved outputs does not require claiming those inputs are bundled.

To reproduce the fixed diagnostic itself, use a new namespace and the pinned runtime:

```sh
python simulation/dispatch_jags_centered_extended_guarded.py check \
  --namespace production/NEW_RECOVERY
python simulation/dispatch_jags_centered_extended_guarded.py dispatch \
  --namespace production/NEW_RECOVERY
python simulation/dispatch_jags_centered_extended_guarded.py diagnose \
  --namespace production/NEW_RECOVERY
```

The design is fixed at four prescribed seeds, 1,000 adaptation iterations, 7,000 burn-in iterations and 28,000 retained draws per chain. The dispatcher caps each chain at 1,370 seconds, preserves all requested outcomes and partial states, and permits no automatic retry or source-count production. The observed completed run took 4,927.558 summed chain-process wall seconds, plus 0.751 preparation and 8.262 diagnostic seconds. This measurement is not a guarantee on another host. Prepared/runtime/code hashes must match; an inconsistent checkpoint manifest is not a valid resumable state.

Generation-only commands and their fixed seeds are documented in `CONTINUATION.md`; 2,650 generated datasets and paired alpha sensitivity are not posterior-fit counts. The full source-count recovery and power targets, independent empirical refits and broad identification/finite-likelihood questions remain open as recorded in `coverage-v4.csv` and the current scientific evidence packet.
