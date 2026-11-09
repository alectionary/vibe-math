# Screen for fetch issue 98

- Fetch issue: https://github.com/alectionary/vibe-math/issues/98
- Manifest id: `vibe-math-98-worker-20261109`
- SHA-256: `86c3bb482efadc385cd52f7ea12dc33c50b9b70b4ce6111aedb075a12968f62b`
- Pages: 280
- PDF bytes: 13113996
- Unicode characters in the extracted text: 398848
- Question count in this screen: 1
- Bibliography row: F194, linking [formalization/polytomous-person-fit](../../../formalization/polytomous-person-fit/README.md)

The manifest `question_screen.status` stays `not_screened`. Checked 2026-11-09. Line numbers are 1-based `str.splitlines()` on the extracted text. A form feed counts as a line break. The fetch hash matches the hash in that replication README. Re-replication assessment: [#109](https://github.com/alectionary/vibe-math/issues/109). This note does not redo that replication. Beck is not one of the 99 UNL-SEM seed rows.

## What the dissertation establishes

Mark F. Beck, *The Examination of Nonparametric Person-Fit Statistics as Appropriate Measures of Response Bias in Ordered Polytomous Items*, University of Nebraska–Lincoln, 2023. Landing page: https://digitalcommons.unl.edu/cehsdiss/425/.

The dissertation simulates nonparametric person-fit statistics on ordered polytomous items and reports how aberrant-response patterns and dimensionality affect classification accuracy.

## Open questions

[L-F194-polytomous-generalizations](../../OPEN-PROBLEMS.md#l-f194-polytomous-generalizations). Chapter V, Future Research, second item, extracted lines 6309–6319. More nonparametric person-fit statistics should be generalized to polytomous data, and that work would require generating and solving mathematical proofs. The statistics are not named. Present resolution and Lean discovery were not assessed.

The other future-research items are simulation studies: a comparison with parametric statistics (lines 6282–6307), sampling distributions (lines 6325–6345), cutoff choice (lines 6350–6372), factor correlation (lines 6374–6399), and robustness to multidimensionality (lines 6401–6423). They are not separate inventory targets.

## Code and supplementary material

| Place checked | UTC date | Result |
|---|---|---|
| The dissertation, software sentences | 2026-11-09 | Says R packages would need to be created or updated after new generalizations. The cited PerFit and mokken packages are other authors' software. No deposit of this dissertation's programs. |
| Named code host | 2026-11-09 | None for this dissertation's code, so none was opened. |

No help issue was filed.
