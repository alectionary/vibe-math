# Published-statistic checks for Abbott (2010)

## Question and answer

**Do the dissertation's printed numerical summaries reproduce their stated comparisons?** Most fit-index arithmetic and the reported AIC ranking do, but two scaled chi-square difference statistics do not follow from the printed inputs under the official Mplus formula. The dissertation's headline claim is a two-dimensional creative self-efficacy structure, with a Revised model preferred to its alternatives. These checks support the *reported ranking* but cannot establish that substantive claim independently: no participant-data analysis or original Monte Carlo run is repeated here.

**Our contribution is a reproducible arithmetic audit of published quantities.** The dissertation supplies the model estimates, sample counts, diagrams, selected simulation output, and its conclusions. Our script supplies independently implemented formulas, rounding intervals, consistency comparisons, and source-page crops. Full numerical detail is in [the comparison table](../outputs/published_checks.md), [machine-readable results](../outputs/published_checks.json), and [CSV](../outputs/published_checks.csv).

## What matches

**The Revised model has the lowest published AIC among all four H5/H6 alternatives.** Subtracting its AIC, 76438.957, gives 235.089 for All, 338.690 for Held, 64.474 for Implied Structure, and 131.654 for Implied Indicators (printed pp.140–150). This verifies the reported ordering, not the original fitted likelihoods. The arithmetic does not support interpreting a percentage of the absolute AIC as a general scale of evidential strength; we do not use that interpretation.

**All nine RMSEA values are reproduced at the displayed three decimals.** The calculation is sqrt(max((chi-square − df)/(308 × df), 0)), using the reported robust chi-square and Mplus's N convention. The N−1 convention gives a different last displayed digit for the general-factor model, so using N−1 would create a spurious mismatch. Mplus explicitly says it uses N for its chi-squares in the [official discussion of RMSEA](https://www.statmodel.com/discussion/messages/23/26.html), Linda K. Muthén's April 19, 2000 response. This is a transformation of reported statistics, not a re-estimated RMSEA.

**Appendix I's selected Monte Carlo output is arithmetically coherent.** All 31 displayed mean-square-error entries agree with squared empirical standard deviation plus squared bias, allowing displayed rounding and both N and N−1 empirical-SD conventions. Among the 21 displayed nonzero free parameters, the maximum absolute relative parameter bias is 0.0100874, and across 22 displayed free parameters the maximum absolute relative standard-error bias is 0.0273973. These satisfy the stated .10 and .05 thresholds for these rows. Their printed nonzero-parameter significance proportions are 1.000, while the zero population CP–CT covariance has significance proportion .045: the latter is a type-I-error proportion, not power against a nonzero alternative. Fixed parameters are not power targets.

**The power analysis remains only partially checkable.** Appendix I reports 10000 completed replications, n = 200, and seed 0, but contains selected output rather than a complete generating program, including all residual variances and analysis choices. The population CP–CT covariance is 0 in that appendix, whereas the observed Revised model's correlation in Figure 4.2 is .858. Those are different model settings; the selected power output is not a rerun or a generic guarantee of power for the observed fit.

## What does not follow from the printed inputs

### Scaled difference after refinement

**The printed refinement statistic 52.457 is outside the rounding range of the official calculation.** For the unrefined and refined models, pp.129–130 supply (T,df,c)=(350.161,181,1.456) and (295.571,178,1.463). The [official Mplus chi-square difference instructions](https://www.statmodel.com/chidiff.shtml) give c_d=(d0c0−d1c1)/(d0−d1), then T_d=(T0c0−T1c1)/c_d. Our result is74.388895 on3 df, with c_d=1.040667. Allowing each displayed T and c to vary independently by.0005 gives a rigorous range70.636483–78.599120, excluding52.457. This is a discrepancy under our reading of the supplied scale factors.

**Both displayed and recomputed positive statistics support improvement under the conventional reference calculation.** The disagreement therefore does not reverse the stated direction of this comparison. As a diagnostic, (350.161−295.571)/1.040667=52.456758 rounds to the printed52.457; that numerical coincidence does not establish how the original calculation was performed. Full Mplus outputs would distinguish a transcription issue, a different undocumented comparison, different correction factors, and another calculation route.

### General-factor comparison

**The printed negative statistic−21.803 and2 df do not follow from the reported model summaries.** The general-factor model supplies (319.462,179,1.488); compared with the refined model, the official formula gives c_d=5.938 and T_d=7.231237. Its rounding range is7.070240–7.402212, entirely positive. The difference of displayed model degrees of freedom is179−178=1, not2. The [source crop](../outputs/crops/general-sb-p131.png) confirms the minus sign, statistic, and2 df are visible ink, not extraction artifacts.

**This arithmetic result is not a newly validated hypothesis test for the substantive null.** A correlation fixed at1 is a boundary/singular latent covariance case; regularity and the appropriate reference distribution require separate justification. The JSON includes the conventional chi-square1 reference p=.00716458 for transparency, not as proof that no general factor exists. The original participant data and complete outputs are needed to repeat robust estimation and assess that test properly.

### Composite-validity formula

**All nine Figure 4.2 composite values are recovered by a square-of-sum alternative, but not by the formula printed on p.110.** The printed formula is sum(λ²)/(sum(λ²)+sum(ε)), visibly confirmed in [the equation crop](../outputs/crops/composite-formula-p110.png). Using standardized loadings and ε=1−λ² gives, for example, CTSE=.727508 and CPSE=.707311, not the printed .91 and .88. Replacing sum(λ²) by (sumλ)² gives .914160 and .877590, which round to the published values. The same alternative rounds correctly for all seven first-order factors at the printed input values.

**This result identifies a plausible formula-description ambiguity, not a complete reliability validation.** The alternative calculation excludes residual covariances, while the fitted model includes some correlated residuals. Original residual covariance estimates and the exact composite score definition would be required for a general reliability calculation. Rounded loadings also leave small last-digit uncertainty, particularly for elaboration. The [diagram crop](../outputs/crops/composite-diagram-p132.png) preserves all inputs.

### Correlation-significance note

**Table 3.2's blanket significance cutoffs are not the ordinary two-sided Pearson cutoffs for its stated n = 296.** The corresponding critical positive correlations for p<.05,.01,.001 are.114031,.149507,.190312, rather than.10,.13,.18. One-sided cutoffs are.095791,.135167,.178922, so sidedness does not resolve all thresholds. These are conventional zero-correlation tests, not corrected multiple-comparison thresholds. Table 4.1 contains latent-model correlations, whose significance requires model-based standard errors; applying the elementary Pearson calculation to that table would not be justified. The stated n and cutoffs were verified in [the source crop](../outputs/crops/correlation-cutoffs-p95.png).

## Small reporting differences and boundary cases

**Three smaller issues should be kept separate from substantive replication findings.** First, male incomplete response is 3/93=3.225806%, which rounds to 3.23%, while the text prints 3.22%; truncation would produce that value. Second, p.131's prose names CFI=.054 and threshold.05, inconsistent with the same page's model summary .945 and p.102's threshold .95; the [crop](../outputs/crops/cfi-prose-p131.png) verifies this inconsistency, which does not change the summary's rejection under the stated CFI criterion. Third, the external-validity model's displayed CFI=.950 is called passing a strict CFI>.95 rule. The rounded value cannot reveal which side of the threshold its unrounded value occupies. These are reporting or rounding matters, not independent evidence that the model fails to replicate.

## Assumptions supplied for these checks

### Interpretation of scaling factors

**The SB comparison treats each reported scaling value as the correction factor for the displayed robust chi-square.** This is the interpretation used in the official Mplus chi-square route. As an independent check, AIC differences71.387 and40.850 fall within the rounding bands implied by the recovered unscaled chi-square differences minus twice the df difference:71.089718–71.738368 and40.630091–41.248075. This supports, but does not prove, that interpretation. The loglikelihood-route scaling factors are not assumed interchangeable with chi-square factors.

### Rounding

**Three-decimal printed statistics are treated as nearest-rounded to within.0005.** The SB ratio is linear-fractional in each input with a strictly positive denominator throughout its input box, so checking every corner gives its extrema. We also give point estimates without that uncertainty assumption. A larger undocumented transcription change is not covered by these bands.

### Standardized loadings

**The composite check assumes Figure 4.2's loadings are standardized and uses residual variances1−λ².** It compares the printed sum-of-squares formula with a square-of-sum alternative, omitting residual covariance contributions from both. It is not a new empirical estimate of reliability. No participant-level data are invented.

### Relative simulation bias

**The Appendix I audit uses relative bias for nonzero population parameters and relative standard-error bias against the empirical SD.** Relative parameter bias is undefined for the zero covariance and is not reported for it. Both possible SD divisor conventions are covered in MSE rounding checks. Because only selected output is present, no claim is made about omitted parameters.

## Verification, source record, and reproduction

**The source was checked before classifying any numerical disagreement.** The official 283-page PDF has SHA256 `a3c381d6f6295e917806834364b7f55fc35684b3db53174a53c3564feab4d70a`; PDF page numbers equal printed page numbers plus 14 for these sections. Each disputed cell or formula was rendered with `pdftoppm -png -r 600`, cropped without retouching, and visually inspected. The [crop manifest](../outputs/crops/published-crops-manifest.json) records source/crop hashes, page numbers, bounding boxes, DPI, and renderer version.

**The arithmetic was checked independently where practical.** A 40-digit Decimal rearrangement agrees with both floating-point SB calculations to better than1e−10; known-case self-tests verify the formula and composite functions; independently calculated beta-distribution and Student-t Pearson cutoffs agree to better than1e−10. No optimizer is involved in this component, so changing an optimizer cannot explain these deterministic summary comparisons. Mplus 5.2 was the original software shown in Appendix J; it was not run here.

**The numerical script and the crop script have separate reproducible outputs.** From the package root, run:

```sh
python scripts/published_checks.py
python scripts/render_published_crops.py --pdf /tmp/abbott-unl.pdf
```

The numerical script requires the extracted Appendix I pages under `sources/pages/pdf-265.txt` and`pdf-266.txt`; these are obtained from the verified PDF with `pdftotext -layout` and page splitting on form feed. It writes `outputs/published_checks.json`,`.csv`, and`.md`. `sb_difference`, `sb_decimal`, `rounding_band`, `composite`, and `read_power_table` are in [the runnable script](../scripts/published_checks.py). The crop command verifies the PDF hash and writes 11 PNGs plus its manifest. Both scripts are deterministic; there is no replication seed because no new simulation is run. No Git commit or public repository change was made by this component.

**Software versions are recorded because each serves a specific role.** [Python 3.12.14](https://github.com/python/cpython/tree/v3.12.14) and its Decimal standard library implement the arithmetic and independent high-precision check; [SciPy 1.17.0](https://github.com/scipy/scipy/tree/v1.17.0) supplies distribution functions; [Pillow 12.3.0](https://github.com/python-pillow/Pillow/tree/12.3.0) crops the source renders; [Poppler 26.05.0](https://gitlab.freedesktop.org/poppler/poppler) supplies `pdftoppm` for faithful page rendering. PyMuPDF 1.26.6 was used only to inspect text block coordinates while choosing crops, not by either regeneration script; its [repository](https://github.com/pymupdf/PyMuPDF/tree/1.26.6) documents that tool.

## What would close the remaining gaps

**The decisive next input is the complete original analysis record, not more arithmetic on rounded tables.** The needed materials are `CohortsTwo.dat`, the corresponding Mplus 5.2 outputs with correction factors and loglikelihoods, complete Monte Carlo generating/analysis code, and residual covariance estimates for the reported composites. These would permit the original robust/FIML estimation, the intended nested comparisons, and the simulation to be rerun. The present audit does not establish whether those materials exist elsewhere and does not attribute the observed inconsistencies to a particular cause.
