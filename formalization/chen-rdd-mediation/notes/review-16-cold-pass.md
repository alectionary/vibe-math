# Review 16: cold pass (rendered PDF and criteria only)

Reviewer: independent cold-reader agent, fresh context. Read before opening the
evidence packet, writer manifest, DISAGREEMENTS.yaml, any other notes, provenance
or the source. All 24 pages rendered at 80 dpi (pdftoppm -r 80) and inspected;
pdftotext used for quotes.

PDF: paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf
(24 pages, letter).

## Verdict-first opening

- p1, abstract sentence 1: "We did not replicate the three simulation headlines of
  Chen (2021), who reported biased direct-effect estimates, percentile bootstrap
  intervals that cover the true value far too rarely, and power for the mediated
  interaction (MINT) near zero: 85.42% ... against 0.00% ...; 43.62 ... against
  0.04; ... 0.013 (raw 0.063) ... against 0.802 (raw 0.852)." Verdict, source,
  original findings and our numbers in sentence 1. Pass. The sentence is very long
  (about 90 words, three contrasts plus a reading-error ratio); readable but
  dense. Polish.
- p1, abstract sentence 2: the fourth headline (H4) "holds only in part" with
  86.3% / 89.2% and the both-zero exception. Clear. Pass.
- p1, abstract: Head Start part blocked ("could not be rerun") is not called a
  nonreplication; S9 "holds in 10 of 15 comparisons". Good.
- p1, abstract second paragraph: bootstrap unseeded, exact R replay of printed
  code recovers the interaction; disagreements 8 explained, 2 partly; tolerance
  and "point-estimate comparisons, not equivalence". Limits and uncertainty are
  present. Pass.
- p2, Introduction paragraph 1 opens "We did not replicate the simulation
  headlines of Chen (2021): ..." with each finding and both numbers, then MC
  standard errors (.007; .002 for E4), H4 partial, Head Start limit, unseeded
  bootstrap. Verdict first. Pass.
- p2, Intro: "Our coverage shortfall (0.04 points against her 43.62) is about
  three orders of magnitude smaller than hers and our imbalance (0.33 against
  47.07) about two" - arithmetic 1090x and 143x, consistent. "as point estimates
  they point the same way as hers, with Monte Carlo standard errors of about
  0.005 points if cells are independent and 0.019 if they are correlated" - the
  0.04 shortfall is only about 2 SE under the correlated bound; the text does
  not claim it is significant. Acceptable.

## Standalone prose

- No reliance on earlier drafts or reviews noticed. "previous" / "as before"
  phrasing not found in a way that refers to earlier manuscripts.
- p4, Section 3.3: "(1,270 datasets, of which the 635 kept by the replay were
  compared)" - why only half are "kept" is not explained on the page; a reader
  must guess (presumably one of two simulation blocks / some datasets discarded by
  her code). Polish.
- p4, Section 3.3: the narrative of how engines were chosen (Python first without
  asking the owner; owner later agreed; issues #92 and #118) is process history,
  but it is a substantive disclosure of a departure from the source's software
  and is cross-referenced in Appendix B. Acceptable.
- p9-10, Table 3 cells "limited (same data at h = 0)" are cryptic in the table
  alone; the "Reasons by row" paragraph on p10 explains them. Polish.

## Page-1 table (Table 1)

- Readable at 80 dpi; nine columns; no overlap or clipping. Column headers
  "Published", "Ours", "Published effect", "Our effect", "Effect magnitude",
  "Direction", "Verdict" present.
- E1: Published "PNDE and TNDE within [-.10, .10] in only 12.50-18.75% of
  conditions, with negative bias"; effect 85.42 (= share outside, mean of six
  rows). Internally consistent (outside 81.25-87.50%, mean 85.42 plausible).
  Ours "within [-.05, .05] in 100% ... largest |bias| 0.016", effect 0.00,
  smaller, zero vs nonzero (0.00 within tolerance 0.005). Labels follow the
  contract. Verdict no match.
- E2/E3: Published and Ours text cells are identical across the two rows
  (both come from Table 4.9). Acceptable, but the E3 cells do not name the
  imbalance numbers; the numbers are in the effect columns. Polish only.
  E2 43.62 vs 0.04 smaller/same; E3 47.07 vs 0.33 smaller/same. Our 0.04 is
  8x the rounding tolerance 0.005, so "same" direction is the contract's
  mechanical label; the caption says "Descriptive point estimates; not
  equivalence" and the Intro gives MC SE 0.005-0.019. Acceptable.
- E4: Published "MINT power near zero at every sample size; never reaches .80
  (Figure 4.28: 0.057-0.068 in this cell)"; effect 0.013 against tolerance
  0.0091 (measurement, mean reading error of two points, rounded down); ours
  0.802 (raw 0.852). Larger / same. Consistent: 0.013 > 0.0091 so nonzero.
  Note: her printed claim "near zero" vs her figure at about .06 (near the
  nominal .05) - the paper handles this by defining the contrast against .05 and
  saying her curve has "the shape of a Type I error curve" (p7). Needs source
  check in the evidence pass.
- E5: qualitative, all four comparison columns "not established", verdict
  partial; Published/Ours cells carry the actual findings (not placeholders).
  Good.
- Caption: defines each estimand, units, positive meaning, each tolerance and its
  basis, and "Descriptive point estimates; not equivalence." Monte Carlo errors
  point to "Section 1". Pass.
- p1/p7: the E4 contrast cell "was chosen after the full results were available"
  (p7, Section 4.3) - disclosed in the body but not in the Table 1 caption.
  Should-fix-level transparency issue but not wrong: the verdict also holds for
  all ah >= .13 from n = 1,000 and the full grid is cited. Polish.

## Claims, limits, uncertainty

- p5-6 H1: replay over 1,280,000 datasets, largest condition-mean bias 0.017,
  5.3% beyond 1.96 SE and 0.14% beyond 3.29 - nominal rates, well supported.
- p6 H2: "Close to nominal" is qualified ("describes the row means") with
  product-effect cells outside Bradley's range (80.1% MINT inside). Honest.
- p7 H3: explicit that the contrast cell was chosen post hoc and that her
  cutoff-1 series is hidden. Honest.
- p7 H4: "Chen states this as tentative; we judge it literally" - good.
- p8 S2/S3: statement arithmetic is internally consistent: 13+16=29, 14+17=31,
  46-31=15, 15-10=5 = {10,11,30,41,44}, plus 2 and 43 = 7, 46-7=39.
- p8 RQ2: "blocked: not established, and not a failure to replicate." Good.
- p9 S8: "not established, and nothing blocks it" - clear.
- p11-17 Section 6: ten disagreements; conclusions read 6.1 explained, 6.2
  partly, 6.3 partly, 6.4-6.10 explained = 8 + 2 as stated on p11 and in the
  abstract. Each has an "ours" theory tested first. 6.7 handles the post-hoc
  selection of the TNDE cell properly (inconclusive -> multiplicity argument).
- p18-19 Section 10 limitations: seven numbered items with claim tags; claim-
  specific limits sentence. Clear.
- p19-20 availability ledger: six rows dated 2026-11-08; consistent with
  Section 4.8 ("signed ICPSR agreement this project does not hold") and the
  owner's failed application.

## Internal consistency spot checks (cold)

- Coverage rows 94.6-95.6% (p1, p2, p6) vs 94.59-95.63% (p12): consistent.
- MINT power 0.836 all cutoffs, 0.852 cutoffs 2-3 (p1, p7, p11 ".84"): consistent.
- "at least .97" (p1, p11) vs "0.9735 or more" (p7): consistent.
- E4 0.013 (p1) vs 0.0127 (p7, p10): display rounding, consistent.
- 898 of 902 crosscheck (p5, p11, p12): consistent.
- 86.3% / 89.2% (p1, p2, p7, p15): consistent.
- Treated shares .356/.717/.856 (p9, p18) vs .36/.72/.86 (p13): consistent.
- PNDE bias multipliers -1.466/-0.965/-0.446 (p6) vs PNIE k 1.469/0.959/0.441
  (p7) vs "k = 1.47, .96 and .44" (p12): consistent at rounding.
- Appendix A (p21) names code revision 1fa61083...; to be checked in the evidence
  pass.

## Nothing blocking found in the cold pass

Severity summary:
- Blocking: none.
- Should-fix: none that makes a number or label wrong on its face.
- Polish: (a) p1 abstract sentence 1 very long; (b) p4 "635 kept by the replay"
  unexplained; (c) p9-10 Table 3 "limited (same data at h = 0)" cryptic without
  the following paragraph; (d) p1 Table 1 caption could note that the E4 cell
  was chosen after the results (stated p7); (e) p1 E2/E3 share identical finding
  cells.
