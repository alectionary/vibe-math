[Main manuscript PDF](https://github.com/alectionary/vibe-math/blob/69a9ed24224be8e0958074c24ea04777c7d1f9db/formalization/schwabe-psychometric-genetics/paper/whole_dissertation_replication__schwabe_psychometric_genetics.pdf)

[Editable paper.tex](https://github.com/alectionary/vibe-math/blob/69a9ed24224be8e0958074c24ea04777c7d1f9db/formalization/schwabe-psychometric-genetics/paper/paper.tex) · [references.bib](https://github.com/alectionary/vibe-math/blob/69a9ed24224be8e0958074c24ea04777c7d1f9db/formalization/schwabe-psychometric-genetics/paper/references.bib) · [Whole-dissertation coverage.csv](https://github.com/alectionary/vibe-math/blob/69a9ed24224be8e0958074c24ea04777c7d1f9db/formalization/schwabe-psychometric-genetics/coverage.csv) · [README.md](https://github.com/alectionary/vibe-math/blob/69a9ed24224be8e0958074c24ea04777c7d1f9db/formalization/schwabe-psychometric-genetics/README.md)

## What this is

Scheduled slot 3 (latent factors; due 2026-10-30 17:13:16 UTC): an **incomplete whole-dissertation checkpoint** for Inga Schwabe’s 2016 University of Twente PhD, *Nature, Nurture and Item Response Theory: A Psychometric Approach to Behaviour Genetics* (DOI 10.3990/1.9789036540735). The unit is the entire dissertation, Chapters 1–7 and Appendices A–G. This draft is a milestone, not completion or a request to merge.

## Question

Do item-response models prevent spurious genotype–environment effects, do moderator models recover their parameters, and does modelling incomplete covariates jointly improve twin-model inference? The dissertation also reports empirical mathematics, conservatism, SES and school-achievement analyses.

## What ties together

The original work supplies models, designs, reported results and programs. This change supplies original reconstruction code, full-source inventory, source extraction, execution evidence and a standalone manuscript. All twelve public author repositories were cloned; the final thesis edition and degree metadata were verified. Full copyrighted source and unlicensed upstream programs remain local; limited attributed crops support specific checks.

## Findings

- **Partial evidence, not whole-dissertation replication.** Published floor-effect slopes of 1.05 (sum scores) and 0.03 (item analysis) become 1.095 and −0.105 on one new dataset with source-length chains. These are not comparable 100-dataset averages. The item-level point sign reverses, but its 95% posterior interval [−0.698, 0.439] includes zero.
- The original centred JAGS program, after three documented identifier repairs, gives −0.139 on the same data. All five monitored means agree with the independent parameterization within exploratory Monte Carlo bands. The engine, model, priors and data remain shared.
- Chapter 6 has **1,920 successful method-by-dataset fits: 20 repetitions in each of 48 conditions**, including both 2% and 3% missingness readings. Every one of the 108 primary variance-SE point contrasts favors full information; 104 have positive simultaneous conditional bands. The original target is 1,000 repetitions per condition.
- The standard-error scale is unresolved. One source value is 0.04149, versus 0.05907 for our variance SE and 0.04166 for the square-root path SE. Of 216 plotted SE values, 191 are outside conditional adjusted bands on the printed variance scale, versus zero on the exploratory path scale. Different estimands are not declared numerically matched; source Monte Carlo uncertainty is unknown.
- The coverage inventory has **41 groups: 26 attempted/unresolved and 15 blocked**. All specified numerical conditions and software appendices received execution attempts. Short Bayesian pilots do not establish convergence, power or source tables. Empirical refits are blocked by unrecovered NTR/Cito, Virginia30K and linked school/SES inputs.
- An actual 8,000-pair timing pilot projects about 213 single-worker elapsed days for that Chapter 5 condition’s original repetitions alone. Production counts remain open; scope was not redefined.

## Map of the note

The opening states the partial verdict and evidence limits. Subsequent sections explain measurement checks, missing-covariate contrasts and scale ambiguity, assumptions, program/equation diagnostics, empirical input gaps, dated availability and compliance ledgers, and next steps. The appendix inventories the entire dissertation and links exact artifacts.

## How to check it

The README gives pinned upstream revisions, exact engines and package hashes, seeds, commands, checkpoint behavior, full production continuation commands, and the immutable runnable revision. Start with [trial-records.csv](https://github.com/alectionary/vibe-math/blob/69a9ed24224be8e0958074c24ea04777c7d1f9db/formalization/schwabe-psychometric-genetics/outputs/trial-records.csv), [signed-contrasts.csv](https://github.com/alectionary/vibe-math/blob/69a9ed24224be8e0958074c24ea04777c7d1f9db/formalization/schwabe-psychometric-genetics/outputs/signed-contrasts.csv), [source-comparisons.csv](https://github.com/alectionary/vibe-math/blob/69a9ed24224be8e0958074c24ea04777c7d1f9db/formalization/schwabe-psychometric-genetics/outputs/source-comparisons.csv), and [posterior-comparison.csv](https://github.com/alectionary/vibe-math/blob/69a9ed24224be8e0958074c24ea04777c7d1f9db/formalization/schwabe-psychometric-genetics/outputs/posterior-comparison.csv).

All 281 uploaded study files were downloaded from the immutable artifact commit and matched against Git blob SHA256s. Two startup parse failures during development were retried at identical seeds and preserved in execution-retries.json. Structural citation, contrast-coverage and ledger checks pass.

## Open issues and next steps

Independent scientific and rendered-main-PDF reviews are recorded for the revised checkpoint, including initial findings and corrections. Their acceptance is limited to the checkpoint, not whole-dissertation replication or production readiness.

Continue source-count simulations, obtain the original Chapter 6 simulation/SE-summary driver, recover permitted empirical inputs, resolve the undocumented curvilinear design and broader identification assertions, and complete the remaining production-validity checks. No open feasible production item is closed as outside scope. Master navigation links await merge. No merge, author contact, social post or reusable skill edit was performed.


Review follow-up: the whole-dissertation checkpoint now includes all72 Figure6.5 signed biases,23 inconclusive point-sign reversals, and corrected continuation aggregation. Original numerical baseline files are byte-identical. Source-count production and empirical inputs remain unresolved; production safeguards must precede any continuation. New draft PR creation remains denied; this is a prepared description, not an existing PR.
