# Screen for fetch issue 114

- Fetch issue: https://github.com/alectionary/vibe-math/issues/114
- Manifest id: `vibe-math-114-worker-20261109`
- SHA-256: `b64a3c3fdeb43040875b88560b69d3b9b4f23c1a45b05f0834204e624a56eece`
- Pages: 222
- PDF bytes: 3853291
- Unicode characters in the extracted text: 426384
- Question count in this screen: 0
- Bibliography row: F199, linking [formalization/koziol-weighted-multilevel](../../../formalization/koziol-weighted-multilevel/README.md)

The manifest `question_screen.status` stays `not_screened`. Checked 2026-11-09. Line numbers are 1-based `str.splitlines()` on the extracted text. A form feed counts as a line break. The fetch hash matches the hash in that replication's source inventory. Re-replication assessment: [#104](https://github.com/alectionary/vibe-math/issues/104). This note does not redo that replication. Koziol is not one of the 99 UNL-SEM seed rows.

## What the dissertation establishes

Natalie A. Koziol, *A comparison of population-averaged and cluster-specific approaches in the context of unequal probabilities of selection*, University of Nebraska–Lincoln, 2015. Landing page: https://digitalcommons.unl.edu/cehsdiss/229/.

The dissertation compares weighted single-level and weighted multilevel estimators when selection probabilities are unequal. Chapter V discusses when the two targets differ and how the studied estimators behaved.

## Open questions

No additional inventory target. Future Directions, extracted lines 7076–7221, asks whether the conclusions extend to other designs, including count or ordinal outcomes, few clusters, repeated measures, small cluster sizes, Bayesian and small-sample variance adjustments, sampling levels that do not match the model hierarchy, and weighted centering. Line 7182 says it is unclear how weighted multilevel modeling would be applied when weights are missing for a level that was not in the sample design. That is an applied method gap without a fixed estimand. Line 7325, that parameters are not well-defined for a non-normal outcome with a complex covariance, is a limitation statement in the same section, not a separate conjecture.

## Code and supplementary material

| Place checked | UTC date | Result |
|---|---|---|
| The dissertation, software sentences | 2026-11-09 | Names R and cites `lme4`, `survey`, and `sampling`. Appendix A is select R code printed in the dissertation. No external code host and no supplement file. |
| https://CRAN.R-project.org/package=lme4 and the other cited package pages | 2026-11-09 | Not opened. They are the cited packages, not a deposit of this dissertation's programs. |

No help issue was filed.
