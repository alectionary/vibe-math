# Screen for fetch issue 96

- Fetch issue: https://github.com/alectionary/vibe-math/issues/96
- Manifest id: `vibe-math-96-worker-20261109`
- SHA-256: `368dc575d9f744bf5ca5516873a633691d999fbdd5d19516994c64e10674896a`
- Pages: 143
- PDF bytes: 713123
- Unicode characters in the extracted text: 273684
- Question count in this screen: 0
- Bibliography row: F192, linking [formalization/kupzyk-power-assumptions](../../../formalization/kupzyk-power-assumptions/README.md)

The manifest `question_screen.status` stays `not_screened`. Checked 2026-11-09. Line numbers are 1-based `str.splitlines()` on the extracted text. A form feed counts as a line break.

## Hash difference

The manifest notes record that this SHA-256 differs from the issue's previously verified copy `c3b7af14877156cf6506e1c3c4ea57b23bcba6ce2139cf82bdce8417c451a1d1`. That earlier hash is the one recorded in the replication README, which also describes a 143-page PDF. This artifact is 143 pages as well. The manifest says the title and author still match. This screen uses this file. The earlier file was not opened again. Re-replication assessment: [#103](https://github.com/alectionary/vibe-math/issues/103). This note does not redo that replication. Kupzyk is not one of the 99 UNL-SEM seed rows.

## What the dissertation establishes

Kevin A. Kupzyk, *The Effects of Simplifying Assumptions in Power Analysis*, University of Nebraska–Lincoln, 2011. Landing page: https://digitalcommons.unl.edu/cehsdiss/106/.

The dissertation compares formulaic, exemplary-dataset, and empirical power calculations for a longitudinal cluster-randomized design when attrition, treatment-group size, or cluster size departs from the formula's assumptions. Chapter V reports sizeable power bias from attrition and treatment imbalance, little bias from unequal cluster sizes in the conditions studied, and a degrees-of-freedom gap between Optimal Design's J−2 and the mixed-model degrees of freedom used in SAS.

## Open questions

No additional inventory target. Chapter V, extracted lines 5644–5718, says no known attrition heuristic replaces a power analysis that uses the whole design, and that formulas for further design features exist or can be derived but are not in one program. Those sentences report the study's finding and a software gap. They do not state a conjecture. The exemplary-dataset limitations in lines 5580–5642 are recommendations about when that method is appropriate.

## Code and supplementary material

| Place checked | UTC date | Result |
|---|---|---|
| The dissertation, software sentences | 2026-11-09 | Names Optimal Design, HLM, and SAS MIXED. No author code deposit and no supplement file. |
| Named code host | 2026-11-09 | None named, so none was opened. |

No help issue was filed.
