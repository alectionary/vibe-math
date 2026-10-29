# Published correlation matrix and descriptive-statistic checks

## What can the published matrix establish?

The printed matrix supports a reproducible rounded-summary reconstruction, not a rerun of the participant-data analysis. Table 3.2 gives 37 variables, their means and standard deviations, and 666 distinct correlations on dissertation pp. 94–95 (PDF pages 108–109). Its note reports **n = 296**. The original model analysis instead uses incomplete records with full-information maximum likelihood and robust standard errors (pp. 96–97). The printed matrix does not contain missingness patterns, fourth moments, individual observations, or robust correction information.

The machine-readable [correlation matrix](../sources/table_3_2.csv) and [item metadata](../sources/table_3_2_items.csv) preserve all published numbers. The reconstruction sets the diagonal to one and reflects the lower triangle to the upper triangle. The full matrix is positive definite: the smallest eigenvalue is **0.0850668933**. The 21-variable Revised-model subset is also positive definite, with smallest eigenvalue **0.1106077603**. No nearest-positive-definite correction or synthetic data generation was used.

## What did we supply, and what came from the source?

All 666 correlations and 74 means/standard deviations come from Table 3.2. Our contributions are their transcription, canonical item-name mapping, matrix checks, and the calculations below. [extract_matrix.py](../scripts/extract_matrix.py) generates the CSVs and [matrix_audit.json](../outputs/matrix_audit.json). Its `extract` function reads page-specific text; `audit` computes the comparisons; `kmo` implements the partial-correlation formula. No participant records were created.

### Assumption: covariance reconstruction

If a covariance matrix is needed, the supplied operation is `diag(SD) @ R @ diag(SD)`. This treats rounded sample correlations and rounded SDs as mutually compatible summaries. It does not make them equivalent to the covariance information in the original full-information likelihood. In particular, CTFLUE4's published SD is retained, not silently changed.

### Assumption: the variable subset for factorability

The exact subset behind p. 126's KMO and correlation fraction is not specified sufficiently to select one calculation uniquely. Pages 99–100 discuss manifest indicators of the same latent factor. We therefore report several design-motivated subsets, rather than choosing whichever gives a preferred answer. Positive and absolute correlations are distinguished; the primary reading is the printed `r > .30`, not `abs(r) > .30`.

### Assumption: responses stayed within the instructed range

The SD bound below is conditional on all CTFLUE4 values lying in the instructed interval [0,100]. Appendix D, p. 240, instructs that interval. The document does not establish that software validation enforced it or that every stored response obeyed it. The bound also uses the conventional sample SD divisor `n-1`, with Table 3.2's n=296. The variance bound is conservative relative to a population-divisor SD.

## Which numerical checks matched?

The broad KMO conclusion is compatible with the published rounded matrix. KMO is the sum of squared zero-order correlations divided by that sum plus the sum of squared partial correlations, excluding diagonal entries. A second calculation obtains each partial correlation by a Schur complement, independently of the full inverse used in the first implementation; the results agree to 13 decimal places.

| Claim | Published | Ours | Verdict |
|---|---|---|---|
| Factorability, KMO (p. 126) | .93 | .925088 for all 37; .928524 for 35 excluding age/sex; .934932 for all 28 creative-efficacy items | partial |
| Fraction of correlations greater than .30 (p. 126) | .66 | .534535 (356/666) for all 37; .598319 (356/595) for 35; .817460 (309/378) for 28 creative-efficacy items | partial |
| CTFLUE4 mean/SD consistent with instructed [0,100] range (pp. 95, 240) | M=74.8, SD=52.3 | Maximum sample SD 43.518222 allowing mean rounding, versus minimum SD 52.25 allowing SD rounding | no match |

The KMO row is partial rather than an empirical match because the exact input subset and unrounded, participant-level inputs are missing; the first three plausible calculations round to .93. The correlation-fraction row remains unresolved because none of the specified candidate calculations yields .66, but we cannot identify the exact inputs behind it. The last row is a conditional internal consistency check, not a claim that the original participant data were wrong.

The remaining design-motivated subsets also do not close the .66 gap. The Revised model's 21 indicators give KMO .924767 and 176/210 = .838095 correlations above .30. Adding BCSE and openness gives 28 indicators, KMO .916519 and 216/378 = .571429 above .30. Pooling only pairs within the nine first-order indicator groups gives 43/51 = .843137 (absolute-value version .862745). Using absolute correlations on the full 35-variable matrix gives .608403. Reversing the three negatively oriented openness items would produce that same .608403, not .66.

Rounding at .30 cannot close the selected-subset gaps. For the full 37-variable matrix, allowing each displayed `.30` to lie just above the threshold yields a fraction no larger than .542042; the analogous bands are [.598319,.606723] for 35 variables, [.817460,.822751] for 28 creative-efficacy variables, and [.838095,.842857] for the Revised 21. These are deterministic rounding bands, not sampling confidence intervals. No Monte Carlo claim or multiplicity adjustment applies.

## Which source ambiguities were resolved?

The row-10 label prints **CPFI**, not CPF3. The [600 dpi label crop](../outputs/matrix_crops/row10_label.png) agrees with the text extraction. Its position between CPF2 and CPF4, the four-indicator design, and Appendix J's CPFIEL1–CPFIEL4 list support mapping it to CPFIEL3. The original printed label is preserved in the metadata CSV. This is a naming interpretation, not an altered numerical value.

The CTFLUE4 SD really prints **52.3**. The [600 dpi crop](../outputs/matrix_crops/row27_sd.png) rules out an extraction mistake; the [scale instruction](../outputs/matrix_crops/fluency_scale.png) confirms the stated 0–100 interval. From `0 <= x <= 100`, `x² <= 100x`; averaging and subtracting the squared mean gives `s² <= n/(n-1) * mean * (100-mean)`. At the printed mean the bound is 43.489650. Allowing a rounding interval [74.75,74.85] gives a larger bound of 43.518222, still below 52.25. This requires no distributional model, optimizer, or software-specific estimator. Possible explanations remain a table transcription issue, out-of-range responses, an unreported transformation, or some other difference in the summarized variable. The participant file and original descriptive output would distinguish them.

All table rows, including negative signs in the openness, age, and sex rows, were compared against the rendered page images and enlarged page-95 halves. The rounded values were not edited to make any model fit. [render_matrix.py](../scripts/render_matrix.py) regenerates the full-page images and crops with Poppler at 600 dpi. These are local-only artifacts, with no repository commit or remote publication.

## How can these checks be regenerated?

Run these commands from the project root; supply the verified source PDF if it is not at `/tmp/abbott-unl.pdf`.

```sh
python scripts/extract_matrix.py
python scripts/render_matrix.py --pdf /tmp/abbott-unl.pdf
python -m unittest discover -s tests -p test_matrix.py -v
```

The extraction reads `sources/pages/pdf-108.txt` and `sources/pages/pdf-109.txt`, produced by `pdftotext -layout` on the source PDF. The source SHA-256 is `a3c381d6f6295e917806834364b7f55fc35684b3db53174a53c3564feab4d70a`. The CSV SHA-256 values are `07623c2356d9aa14af3b1b30186de6da79581ce742b82f742ca3c3a4e8918be6` (matrix) and `6fe780a6e48d4207212c56deaa928c836f631da4d64bdc3589ed57f6b00043b8` (metadata).

The checks used [Python](https://github.com/python/cpython) 3.12.14 for scripting, [NumPy](https://github.com/numpy/numpy) 2.3.5 for matrix operations, [Poppler](https://gitlab.freedesktop.org/poppler/poppler) 26.05.0 for text extraction and 600 dpi rendering, and [Pillow](https://github.com/python-pillow/Pillow) 12.3.0 for cropping. No random seed is needed because these checks are deterministic. [Three tests passed](../outputs/matrix_tests.log), covering shape/order/signs, positive definiteness, an independent partial-correlation calculation, and the variance bound.
