# Review 15: cold pass (rendered PDF and criteria only)

Reviewer: independent cold-reader agent, fresh context. Read before opening the
evidence packet, writer manifest, DISAGREEMENTS.yaml, sources, scripts, or any
other notes. Inputs: `editorial-review.md`, `first-page-contract.md`,
`pdf-link-review.md` (link step only), and
`paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf`
(24 pages, every page rendered with `pdftoppm -r 80` and inspected; text quoted
from `pdftotext -layout`).

Overall cold impression: verdict-first, standalone, careful about scope and
limits. No blocking problem visible on the page. Several items need the
evidence pass (E4 tolerance derivation, exactness of the R replay, availability
ledger, her p. 143 summary wording), and several clarity items are listed below.

## Page 1: abstract

- Abstract, sentence 1: "We did not replicate the three simulation headlines of
  Chen (2021), who reported biased direct-effect estimates, percentile bootstrap
  intervals that cover the true value far too rarely, and power for the mediated
  interaction (MINT) near zero: 85.42% ... against 0.00% of ours; ... 43.62
  points below 95% against 0.04; ... exceeds the nominal .05 by 0.013 (raw 0.063),
  about 1.4 reading errors, against 0.802 (raw 0.852)." Verdict first, source
  identified and cited, original findings stated, evidence numbers given. Pass.
- Sentence 2 covers H4 ("holds only in part" with 86.3% / 89.2% and the
  both-zero exception) and sentence 3 RQ2 (blocked, printed arithmetic
  recomputes, S9 10 of 15). Composite headline covered. Pass.
- Paragraph 2 states the unseeded bootstrap (interval results use our seeds),
  what the exact R replay shows ("recovers the interaction and gives unbiased
  estimates like ours"), the explanation status ("eight are explained and two
  only partly") and tolerances with "point-estimate comparisons, not
  equivalence." Limits and uncertainty present. Pass.
- Polish: the abstract is very dense; "about 1.4 reading errors" is unexplained
  jargon at that point (defined only on p. 7 and in the Table 1 note).
- To verify: "a rule that reproduces her coverage at every cutoff but not her
  bias at the third" implies the rule reproduces bias at cutoffs 1-2; Section 6.2
  marks the one-scale bias theory "ruled out" with a fitted lambda 1.96/1.92/1.76.
  Generous but disclosed (p. 13, p. 18). Polish-level wording issue unless the
  evidence differs.

## Page 1: Table 1

- Readable at 80 dpi; nine columns fit; row boundaries clear; caption contains
  "Descriptive point estimates; not equivalence." and every tolerance (E1 0.005,
  E2 0.005, E3 0.01, E4 0.0091, E5 not applicable) and positive meanings.
- E1: Published 85.42 / Ours 0.00 / smaller / zero vs nonzero. 0.00 is within
  0.005 of zero, so "zero vs nonzero" is the correct label. Published cell
  "within [-.10, .10] in only 12.50-18.75% of conditions" is consistent with a
  mean outside-share of 85.42 (to verify against Table 4.8 rows).
- E2: 43.62 / 0.04 / smaller / same. 0.04 > 0.005, so "same" by rule; prose
  (p. 2) correctly notes MC SE 0.005-0.019 so the sign is only a point estimate.
- E3: 47.07 / 0.33 / smaller / same. Tolerance 0.01 = two 2-decimal inputs.
- E4: 0.013 / 0.802 / larger / same. Published 0.0127 vs tolerance 0.0091: her
  value counts as nonzero by only 1.4 reading errors. The tolerance was "not set
  in the plan" (p. 17) and the cell "was chosen after the full results were
  available" (p. 7); both disclosed. Section 3.4 says reading errors are "up to
  about .02 on rates"; must verify that 0.0091 really is the recorded per-point
  reading error of these two points, not a convenient value (a tolerance >= 0.0127
  would flip the direction to "zero vs nonzero"). Evidence-pass item.
- E4 Ours cell, should-fix (clarity, not wrong): the cell shows "MINT power 0.836
  at n = 500 for ah = .20 (all cutoffs)" while Our effect 0.802 is based on raw
  0.852 at cutoffs 2-3 (given only in the caption). A reader computing
  0.836 - .05 = 0.786 will not get 0.802. Suggest putting "0.852 at cutoffs 2-3"
  in the cell.
- E4 Published cell: "MINT power near zero at every sample size; never reaches
  .80 (Figure 4.28: 0.057-0.068 in this cell)". Fine; the reading is near .05,
  not literally zero, which the row's contrast (minus .05) makes explicit.
- E5: nonscalar H4 row, all four comparison cells "not established", verdict
  "partial", row label "qualitative, no scalar contrast". Requires a
  comparison_applicability check (evidence pass).
- E2 and E3 Published cells are identical text; acceptable (same source table)
  but E3's cell gives no above/below numbers. Polish.

## Page 2: introduction

- Opens "We did not replicate the simulation headlines of Chen (2021): ..." with
  each component and numbers, then H4 "holds for most but not all cells", then
  the limits (RQ2 restricted data; S9 partly replicated; unseeded bootstrap).
  Verdict first. Pass.
- Uncertainty: MC SE .007 for a rate near .05/.95 (sqrt(.05*.95/1000) = .0069,
  correct), E4 MC SE about .002, E2/E3 MC SE 0.005 / 0.019. "three orders of
  magnitude" (43.62/0.04 = 1090) and "about two" (47.07/0.33 = 143) check.
- Para 4: "Our replay of her printed code behaves like our independent run, not
  like her published results. The disagreements therefore arise in steps she did
  not print." Slightly strong ("therefore"), but Section 6.1 qualifies it as an
  inference. Polish.

## Pages 3-5: methods

- p. 3 Section 3.1: factor grid 5 x 4^3 x 4 = 1,280 conditions x 3 cutoffs =
  3,840 cells. Consistent.
- p. 4 Section 3.3: "its datasets and point estimates are exactly those her
  printed, seeded code generates" while identity with her literal pipeline was
  "verified on the first block". Need to verify the replay is one seeded
  sequential stream so exactness extends beyond block 1 (evidence pass). The
  paper does say the replay "reproduces her printed pipeline, not her published
  runs" and "does not reproduce her bootstrap". Good scope control.
- p. 4 "How the engines were chosen": the Python fallback was chosen without
  first asking the owner; disclosed with the owner's later decision. Good.
- Polish: "On the first block of datasets" is undefined (how many datasets?).
- p. 5 Section 3.4: reading-error statements ("at most .002" bias; "up to about
  .02" rates); occluded points excluded from verdicts and E4. Good. PyMuPDF and
  pandas versions not recorded, disclosed (also in Appendix B).

## Pages 5-10: results

- p. 5-6 H1: numbers consistent across abstract, Table 1, Section 4.1 (0.016
  max |bias|, MC SE <= 0.006, replay max 0.017, 5.3% / 0.14%).
- p. 6 H2: 94.6-95.6% rows, lowest cell 0.916, 92.9% of cells in Bradley range;
  product-effect cells less often in range (80.1% MINT) disclosed so "close to
  nominal" is qualified. Good.
- p. 7 H3: E4 derivation, post hoc cell choice disclosed. Claim that her
  abstract and p. 143 say power for all five effects reached the criteria: verify
  against source.
- p. 7 H4: shares by n; 1,176 + 2,664 = 3,840 per n. "partly replicated". Good.
- p. 7-8 S1: 27.08/39.06/12.50 are the outside-shares implied by 51.88-87.50%
  within; consistent.
- p. 8 S2/S3: 13+16 = 29 strict, 14+17 = 31 with slack; 46 - 31 = 15; 10 become
  agreements with h = 0, leaving 10, 11, 30, 41, 44 plus slack-only 2, 43 = 7, so
  39 of 46. Internally consistent.
- p. 8-9 RQ2: S4/S6 explicitly "blocked: not established, and not a failure to
  replicate". S5 replicated "at the printed precision" with the divisor caveat.
  S9 partly replicated, 10 of 15. Good.
- p. 9 S7/S8: not established, reasons given, S8 search terms stated. Good.
- p. 9-10 Table 3: readable; splits across pages with repeated header. Rows
  consistent with Table 1 and Appendix C. "Same direction? yes" for S5 is odd
  for an arithmetic check (polish).

## Pages 10-17: disagreements

- Ten subsections; each lists competing theories including our own error first,
  tests, results, verdicts, conclusion with confidence. Counts: explained 6.1,
  6.4, 6.5, 6.6, 6.7, 6.8, 6.9, 6.10 (eight); partly 6.2, 6.3 (two). Matches the
  abstract and p. 11 summary.
- 6.1 conclusion "high confidence" while stating it is an inference from her
  outputs; acceptable given 96.8% vs 4.3% agreement.
- 6.7: honest handling of post hoc selection. Good.
- Polish: Section 11 says her code is "replayed in r-reproduction/README.md";
  the replay is chen_exact.R, the README documents it.

## Pages 17-24

- p. 17 Section 7.5 explicitly says E4's tolerance was not set in the plan.
  Good disclosure.
- p. 18-19 unresolved items and limitations: mirror the claims (H1-H4, S1-S8).
- p. 19-20 availability ledger: five rows dated 2026-11-08; "The project owner
  applied for the restricted-use data and could not obtain them" - verify in
  notes/availability.md.
- p. 20-21 references: complete-looking; DOIs present.
- p. 21-22 Appendix A: commands per claim; code revision d37e39ce... and
  "links point at master" (link review needed).
- p. 22-23 Appendix B: departures recorded honestly (engine, software, versions).
- p. 23-24 Appendix C: claim inventory statuses match the body.

## Cold-pass severity summary

- Blocking: none seen on the page.
- Should-fix (non-failing unless evidence shows otherwise): E4 Ours cell shows
  0.836 (all cutoffs) but the effect uses 0.852 (cutoffs 2-3).
- To verify in evidence pass: E4 tolerance 0.0091 derivation; exactness of the
  replay beyond the first block; p. 143 wording; availability ledger; Table 4.8 /
  4.9 averages; S9 count.
- Polish: abstract density / "reading errors" jargon; "first block" undefined;
  "replayed in README.md"; identical E2/E3 Published cells; "therefore" in
  intro para 4; Table 3 S5 direction "yes".
