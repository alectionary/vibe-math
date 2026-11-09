# Screen for fetch issue 101

- Fetch issue: https://github.com/alectionary/vibe-math/issues/101
- Manifest id: `vibe-math-101-worker-20261109`
- SHA-256: `0d4aa07b8fef0df14b47a43412a3356d652afed80e371a4be2712c417a5ad458`
- Pages: 44
- PDF bytes: 543449
- Unicode characters in the extracted text: 116759
- Question count in this screen: 0
- Bibliography row: F197, linking [formalization/moss-score-reliability](../../../formalization/moss-score-reliability/README.md)

The manifest `question_screen.status` stays `not_screened`. Checked 2026-11-09. Line numbers are 1-based `str.splitlines()` on the extracted text. A form feed counts as a line break. The fetch hash matches `papers/paperI.pdf` in that replication's provenance. Re-replication assessment: [#112](https://github.com/alectionary/vibe-math/issues/112). This note does not redo that replication.

The manifest says the PDF is an anonymized submission and the author name is not in the text layer. Identity is the requested path in Jonas Moss's thesis repository. The header is "Psychometrika Submission, August 12, 2020."

## What the paper establishes

Jonas Moss, *Psychometrics and the modelling of publication bias*, Paper I. Fetched file: https://github.com/JonasMoss/phd-thesis/blob/c539b0bc4ab1424352ab93f5aaae5150f02fa9e3/papers/paperI.pdf.

The paper argues that standardized alpha should not be used as a reliability estimator, that ordinal alpha has no concrete interpretation, and that the concrete ordinal reliability in Definition 13 measures prediction of the latent variable from the observed items. Theorem 10 is stated as a comparison already proved in the paper. Section 6, extracted lines 1087–1107, repeats those conclusions.

## Open questions

No additional inventory target. Line 1082 says it is unclear whether one numerical gap of about 0.04, between concrete ordinal congeneric reliability and concrete ordinal H, should be expected in other examples. That is a limit of Figure 1, not a conjecture. The conclusion does not pose a further question.

## Code and supplementary material

| Place checked | UTC date | Result |
|---|---|---|
| The paper, software sentence | 2026-11-09 | Lines 965–966 name the companion R package `conogive` on CRAN. |
| https://CRAN.R-project.org/package=conogive | 2026-11-09 | HTTP 200, HTML. The package was not installed. |

No help issue was filed. The question count does not depend on the package.
