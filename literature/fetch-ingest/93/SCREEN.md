# Screen for fetch issue 93

- Fetch issue: https://github.com/alectionary/vibe-math/issues/93
- Manifest id: `vibe-math-93-worker-20261109`
- SHA-256: `892f11399bca12d53b75bcc8131bef52539dd78f254d9117a20b253e9e7828e9`
- Pages: 204
- PDF bytes: 4416883
- Unicode characters in the extracted text: 290325
- Question count in this screen: 1
- Bibliography row: F189

The manifest `question_screen.status` stays `not_screened`. Checked 2026-11-09. Line numbers are 1-based `str.splitlines()` on the extracted text. A form feed counts as a line break.

## Hash difference

The manifest notes record that this file's SHA-256 differs from the issue's previously verified copy `9206b3d824077d36c86b4935ff7f19f64b3fdebde7746943b8a94500fe11e557`. This artifact has 204 pages. That earlier copy was described as 203 pages. The manifest says the title and author still match, and this screen uses this 204-page file. The earlier file was not opened again. No bibliography row on master carried either hash. [REPLICATION-STATUS.md](../../../formalization/REPLICATION-STATUS.md) points at unmerged PR #90 for a Chen replication and says that inventory was not committed. This screen does not use that pull request. There is no re-replication issue for Chen in #103–#113.

## What the dissertation establishes

Donna Chen, *Statistical Mediation Analysis in Regression Discontinuity Design for Causal Inference*, University of Nebraska–Lincoln, 2021. Landing page: https://digitalcommons.unl.edu/cehsdiss/403/.

The dissertation builds a framework for mediation estimates inside a sharp regression-discontinuity design. It compares mediation and RDD assumptions, simulates the integrated estimator, and applies it to a secondary education data set. Chapter 5's chief conclusion is that the bootstrap confidence intervals used in the study do not produce valid inferences for the estimates, because true parameter values fall systematically above the intervals.

## Open questions

[L-F189-rdd-mediation-ci-correction](../../OPEN-PROBLEMS.md#l-f189-rdd-mediation-ci-correction). Chapter 5, Limitations and Future Directions, extracted lines 5571–5592. A different method of confidence-interval construction is necessary. Bias-correction methods for RDD and bias-corrected bootstrap methods for causal mediation do not easily extend to the integrated estimator, so different bias-correction methods must be derived for this method. Present resolution and Lean discovery were not assessed.

The same section also asks about functional form and continuous versus categorical variables (lines 5255–5265), local regression and bandwidths (lines 5606–5632), missing data (lines 5637–5647), multiple mediators and multiple cutoffs (lines 5649–5661), multilevel nesting (lines 5663–5673), and fuzzy RDDs (lines 5675–5688). Those sentences ask for further simulations and designs. They are not separate inventory targets.

## Code and supplementary material

| Place checked | UTC date | Result |
|---|---|---|
| The dissertation, software sentences | 2026-11-09 | Names R 4.0.3 and the `rdd` package (Dimmery, 2016). No supplement deposit and no author code host. |
| https://CRAN.R-project.org/package=rdd | 2026-11-09 | HTTP 200, HTML. The package page was not used to rerun the study. |

No help issue was filed. The question count does not depend on that package.
