# Review 5: cold pass (rendered PDF only)

Reviewer: independent cold-reader agent (fresh context, review 5).
PDF: paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf,
sha256 a38a77e6e39b6bcedaee0d76b69a5e2304b5ae3ed4719c10d94caefd5797b4d6, 21 pages.
Inputs used in this pass: the rendered PDF (pages rendered at 90 dpi, page 1 table
also cropped at 200 dpi), pdftotext -layout of the PDF, and the three criteria files
(editorial-review.md, first-page-contract.md, manuscript.md). No source, packet,
manifest, results, notes or earlier reviews were opened.

## abstract_verdict_first

- p. 1, abstract sentence 1: "We did not replicate three of the four simulation
  headline findings of Chen (2021), who reported that mediation analysis in a sharp
  regression discontinuity design gives biased natural direct effects, percentile
  bootstrap confidence intervals that cover the true value far less often than the
  nominal level, and near-zero power for the mediated interaction: ..." The verdict
  ("did not replicate three of the four") comes first, the work is cited, and the
  three missed headline findings are named, followed by the published-versus-ours
  numbers (85.42 vs 0.00; 43.62 vs 0.04; 47.07 vs 0.33; near zero vs 0.836).
- p. 1, abstract sentence 2: "We could not establish why her results differ, as her
  step comparing estimates with true values and her result files are unavailable;
  her Head Start Impact Study comparison is not established for lack of data." This
  is the evidence limit, in the right place. "her step comparing estimates with true
  values" is slightly vague for a first-time reader but understandable.
- p. 1, abstract final sentence gives the fourth headline (H4) as partly replicated
  with 86.3% / 89.2%. The opening says "three of the four", so the reader learns the
  fourth only at the end; acceptable because the opening counts it.
- Sentence 1 says "85.42% in our average of her Table 4.8 rows" without saying
  these are the six direct-effect rows (the introduction does). Minor.
- Judgment: pass.

## introduction_verdict_first

- p. 2, Section 1 paragraph 1 repeats the verdict first ("We did not replicate three
  of the four simulation headline findings of Chen (2021) ..."), with the 3,840 of
  3,840 cell count, the same four number pairs, and a direct quotation for MINT
  ("All power for MINT is near zero", printed p. 121).
- Then the limit ("We could not establish why ..."), then reversals ("No headline
  effect reversed its sign ... about 140 times (imbalance) and over 1,000 times
  (shortfall) smaller"), then her abstract's conflicting statement, the 27 of 41
  statements, H4 partly replicated, and the tolerance (0.005, 0.005, 0.01 percentage
  points, "a rounding bound, not a sampling band").
- The paragraph is very long (about 28 lines); readable but dense. Polish only.
- Judgment: pass.

## standalone_prose

- Mostly standalone: terms (RDD, CI, PNIE/TNIE/PNDE/TNDE/MINT, condition-cutoff cell,
  both-zero products) are defined on p. 1 (Table 1 caption) and pp. 2-3.
- p. 3, Section 3.3: "R could not be installed on either of the two computers used
  (fallback.json; Section 8.3)", "401 conditions ... 879 conditions", "The run took
  13.7 core-hours". These are execution details, but they bear on interpretation
  (engine departure) and are file-linked; acceptable.
- p. 6, Section 4.3: "chosen after our full results were available as the most
  direct test of that statement". Honest disclosure of a post hoc choice; this is
  scientific (selection of the contrast cell), not process chatter.
- p. 18-19, Appendix B ledger rows on the typesetting template ("adds the Latin
  Modern fonts with T1 encoding, textcomp and microtype with f-ligatures disabled
  ...") and "handoff/SNAPSHOTS.md" are production/delivery details. They sit in the
  compliance ledger, which is where the writing standard puts departures, so they
  do not intrude on the scientific text. Polish: could be shortened.
- p. 1 Table 1 cells use ASCII ">=" ("at least .97 for ah >= .13"), hyphen ranges
  ("12.50-18.75%") and "c'" rather than the body's "c′"; typographic polish.
- No internal roles ("parent", "executor"), no "see the manifest", no authorship
  statement. Judgment: pass.

## scientific_process_distinction

- p. 2-3, Section 2 separates Chen's contribution (model, design, tables, R code)
  from ours (re-implementation, run, comparison) and says derived values E1-E3 are
  "our calculation from her printed figures". Table 1 caption: "E1-E3 published
  effects are our averages of her rows". Table 8 marks derived values with a dagger.
- p. 7, Section 5.1: zero-estimate pattern is "a consistency observation about the
  printed table, not a diagnosis of what her code did". p. 8, 5.2 and p. 14 limit 7:
  the h = 0 reading "a reading of our results rather than a test of her runs".
  p. 15, 10.1-10.2: candidate causes ranked, "None is established". Good separation.
- p. 4, Section 4.1: "the linear models she fits are correctly specified and OLS has
  no source of bias; our unbiased results are what that model implies." This is a
  derivation claim (ours) and is phrased as such; Section 10.1 (b) calls Chen's
  explanation "not supported" rather than refuted. Acceptable.
- p. 15, Section 10.2: "Smaller h estimates or wider h intervals rank first, because
  they are consistent with 9 of the 12 disagreements" - leans toward a cause, but is
  explicitly hedged ("None is established"). Acceptable; watch in Phase 2.
- Judgment: pass.

## Headline clarity and page-1 legibility (first impression)

- Page 1 holds title, date, abstract and the full Table 1 (five rows E1-E5, nine
  columns) plus caption. The table text is small (roughly 8 pt) but legible at
  normal zoom; the caption is smaller still (about 7 pt) and dense.
- Columns: Claim/estimand, Published, Ours, Published effect, Our effect, Effect
  magnitude, Direction, Verdict. Magnitude/direction labels: E1 smaller / zero vs
  nonzero; E2, E3 smaller / same direction; E4 not established / not established;
  E5 not established x4; verdicts no match x4 and partial.
- Tolerance and units are stated in the caption (0.005, 0.005, 0.01 percentage
  points; E4 "not established, units rejection rate"; E5 not applicable) and the
  caption includes "Descriptive point estimates; not equivalence." with a note that
  E5 is qualitative. Monte Carlo error of ours (~0.7 pp per cell) and absence of
  Chen's errors are stated.
- E2 and E3 rows repeat identical Published and Ours cells; acceptable since both
  come from the same table, but slightly redundant.
- E4 Published effect "not established" though the Published finding cell says
  "near zero"; the row label explains "The source states a verbal result; a scalar
  contrast exists but no defensible margin." Clear enough.
- Checks to make in Phase 2: whether "MINT power near zero at every sample size"
  matches pp. 121/148; whether "with negative bias" is Chen's; the 140x / 1,000x
  ratios (0.04 is rounded); the 17 + 24 = 41 statement inventory against pp. 99-121
  (PDF 113-135); the h = 0 counts (36 of 41, 9 of 12, 10/11/38, 9 and 17), which I
  verified for internal consistency against Table 7 (strict disagreements: 2, 9, 10,
  11, 17, 24, 26, 29, 31, 36, 37, 38, 40, 41 = 14, so 27 agree; slack flips 2 and 40,
  giving 29; h = 0 disagreements 2, 10, 11, 38, 40 = 5, giving 36; of the 12
  both-reading disagreements, 9 become agreements and 10, 11, 38 remain); the cutoff
  label quotation on printed p. 86; the run-time and cross-machine claims.
- Possible confusions for a first-time reader: Table 8 H4 "89.2% and 86.3% pass"
  reverses the order used elsewhere without labels; Appendix C mixes printed and PDF
  page numbers ("PDF pp. 137-156", "PDF p. 162") though it says printed numbers are
  used.

## Phase 2 addendum (written after opening the evidence; the cold pass above is unchanged)

- The cold-pass judgments on the four prose checks stand. All quotations checked against
  source/chen2021.pdf are exact at the cited printed pages, and the abstract/introduction numbers
  reproduce from results/*.csv and from Chen's Tables 4.8 and 4.9.
- New issue not visible in the cold pass: the paper says statement_checks.py tests "every statement"
  in Chen's Type I error and power sections that names cells and a checkable outcome ("All 41 testable").
  Reading PDF pages 113-135, at least three such statements are not among the 41: PNDE Type I "There
  were no differences across cutoff scores" (printed p. 104, PDF 118); PNDE power "Given c' = 0, for
  sample sizes of n <= 2500, power was below the .80 level" (printed p. 116, PDF 130); and TNDE power
  "the results for the other levels of h do not differ" (printed p. 118, PDF 132). The last would
  disagree in our run (TNDE1 power spread over h up to 0.61 at c' = .14). This makes the completeness
  claim and the 27-of-41 / 36-of-41 denominators inaccurate, so claim_coverage fails.
- The 27/29/36, 12-of-17, 15-of-24, 9-of-12, statements 10/11/38 and 9/17 counts all reproduce exactly
  from a fresh run of statement_checks.py (output byte-identical to results/statement_checks.csv).
- The TNIE h = .15 reading of statements 24-28 is disclosed; I checked that their verdicts are the same at
  h = .05 and h = .34 for TNIE1, so the disclosed ambiguity does not change any verdict.
