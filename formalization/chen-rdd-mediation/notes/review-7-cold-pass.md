# Review 7: cold pass (rendered PDF only)

PDF: paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf
sha256 3487af0b99a1887100d5a9ee9c7cd7fffdde81a8563c38bfc05a939cdbdb7753, 22 pages.
Read every page as rendered PNG (90 dpi) plus pdftotext -layout. Criteria read:
editorial-review.md, first-page-contract.md, manuscript.md. No packet, source,
.tex, notes or earlier reviews opened before writing this file.

## abstract_verdict_first (p. 1, abstract) - pass

- Sentence 1 opens "We did not replicate three of the four simulation headline
  findings of Chen (2021), who reported that mediation analysis in a sharp
  regression discontinuity design gives biased natural direct effects, percentile
  bootstrap confidence intervals that cover the true value far less often than the
  nominal level, and near-zero power for the mediated interaction:". The verdict
  comes first, the source is cited and the finding is stated, and the published
  and our numbers follow (0.00% vs 85.42%; 0.04 vs 43.62; 0.33 vs 47.07; 0.836 vs
  "near zero").
- Sentence 2 gives the limit: "We could not establish why her results differ, as
  her step comparing estimates with true values and her result files are
  unavailable; her Head Start Impact Study comparison is not established for
  lack of data." This is a good limit-of-evidence sentence.
- The fourth headline (minimum n of 5,000) gets its own verdict at the end:
  "was partly replicated: 86.3% ... 89.2% ..., but effects with both paths zero
  stay conservative." The composite verdict (3 not replicated, 1 partly
  replicated) is readable.
- Minor point: the "who reported that" clause lists three findings, while the
  sentence refers to "three of the four". The reader meets the fourth only in
  the last sentence. This is acceptable, but a reader may briefly wonder what
  the fourth is.
- The abstract has no reversal statement. That is appropriate, since none
  occurred (the introduction says "No headline effect reversed its sign").

## introduction_verdict_first (p. 2, Section 1 para 1) - pass

- The paragraph repeats the verdict-first sentence with the cell count ("in all
  3,840 of 3,840 condition-cutoff cells"), the four contrasts and a quotation
  from the source ("All power for MINT is near zero", printed p. 121). It then
  gives the limit (unprinted comparison step, files unavailable, HSIS blocked)
  and says "No headline effect reversed its sign" with ratios. It covers the
  statement tests, the H4 partial verdict and the tolerance ("half a unit in
  Chen's last printed decimal ... 0.005, 0.005 and 0.01 percentage points; it is
  a rounding bound, not a sampling band").
- This paragraph is very long, about 30 lines. It is dense but in order: verdict,
  then limit, then direction, then support.
- "about 140 times (imbalance) and over 1,000 times (shortfall) smaller": the
  shortfall ratio 43.62/0.04 depends on an unrounded 0.04. I will check it in
  Phase 2.

## standalone_prose (whole paper) - pass, with polish items

- Terms are defined at first use: PNIE/TNIE/PNDE/TNDE/MINT (Table 1 caption,
  Section 3.1), condition-cutoff cell (caption p. 1), "Slack" and "If h = 0"
  (Table 7 caption p. 9) and the cutoff index (Table 7 caption).
- No drafting or delivery narration appears in the body. The ledger (pp. 19-20)
  mentions handoff/SNAPSHOTS.md and the typesetting template, which are
  delivery-process rows. That is acceptable inside a ledger.
- p. 8, Section 5.2 para 2: "Among the power statements they are MINT power
  (statement 44, the H3 headline)". Table 7 (p. 11) numbers MINT power as
  statement 46. Statement 44 is the TNDE2/3 cutoff statement, which the same
  sentence cites again later ("(statements 30 and 44)"). This is a wrong
  statement number that a careful reader will notice, because 44 is listed
  twice among the fifteen. To verify in Phase 2.
- p. 4, Section 4.1 opening: "in our run every direct-effect estimate is
  unbiased". Individual estimates are not "unbiased". The supported statement is
  that every condition's mean bias is within [-.05,.05], with a max of 0.016
  against an SE of at most 0.006. "OLS has no source of bias" is also a strong
  claim for product estimators. This is polish (wording), not a scientific error.
- p. 1, Table 1, E5 estimand: "qualitative sample-size recommendation over the
  grid. A qualitative design recommendation over the whole grid; ..." The text
  is repetitive.
- p. 9: the Table 7 caption is set in a narrow, indented block above a full-width
  table. This looks odd but is readable.
- p. 22 holds only one table row (Appendix B) of the dissertation-parts table.
  This is wasted layout.

## scientific_process_distinction - pass

- Section 2 (pp. 2-3) separates Chen's contribution (model, design, tables, code)
  from ours (re-implementation, run, comparison). It labels derived numbers
  (E1-E3 averages, Tables 4.6-4.7 differences) as "our calculation from her
  printed figures". The Table 1 caption also says "E1-E3 published effects are
  our averages of her rows".
- Section 4.3 (p. 6) and 7.5 (p. 14) disclose that the H3 contrast cell was
  "chosen after our full results were available". This is honest and relevant.
- Causes are kept hedged: Section 5.1 (p. 7) says "consistency observation ...
  not a diagnosis"; Section 10.1 (p. 16) says "(e) ... untested, not
  established"; Section 10.2 (p. 16) says "None is established". Limit 7 (p. 15)
  says "neither is tested against her runs".
- Process statements to verify in Phase 2: "R could not be installed on either
  of the two computers used" (p. 3); per-machine condition counts 401/879; "two
  conditions computed on one and rerun on the other differed by at most
  1.1e-16"; "13.7 core-hours"; and the software versions (Python 3.13.18, NumPy
  2.5.3, scikit-learn 1.9.1).
- Section 4.1 (p. 4) says "the linear models she fits are correctly specified
  and OLS has no source of bias; our unbiased results are what that model
  implies". This is an argument about her DGM, and it is fair. It does not
  claim to explain her numbers. "her step comparing estimates with true values
  ... unavailable" (abstract) needs checking against her Appendix B.

## Headline clarity and page-1 legibility (p. 1)

- The headline is clear: the verdict and numbers are in the first sentence.
  Table 1 sits directly under the abstract with columns Claim / estimand,
  Published, Ours, Published effect, Our effect, Effect magnitude, Direction and
  Verdict. Tolerances and units are in the caption ("E1 tolerance 0.005
  percentage points; ...; E4 tolerance not established ...; E5 tolerance not
  applicable"). The caption includes "Descriptive point estimates; not
  equivalence." and says that this applies to E1-E4 and that E5 is
  qualitative. Direction is shown per row ("zero vs nonzero", "same direction",
  "not established").
- Legibility: the table text is small (about 8 pt) with nine columns, and the
  narrow Published/Ours cells wrap heavily (E4 and E5 rows of 6-8 lines). It is
  readable at 90 dpi. The caption is about 7 pt, tight but legible.
- E1 Published cell "within [-.10, .10] in only 12.50-18.75% of conditions, with
  negative bias", against Ours "within [-.05, .05] in 100% ...". Using different
  bands on each side is slightly confusing, though both are true statements to
  check.
- Table 1 E4 Published effect "not established" with Our effect 0.836 and
  Direction "not established": understandable, since Chen gives no number.
- Units for E1-E3 are "percentage points" (caption). E1 is a "percentage", so
  this is consistent.

## Other things a first-time reader may question (to check in Phase 2)

- Section 5.2: the counts 29/46, 31 with slack, 13/18 (14), 16/28 (17), 15
  disagree under both readings, 39 under h = 0, and the "10 of 15 become
  agreements" claim. I recounted from Table 7 and these are internally
  consistent, apart from the "statement 44" mislabel for MINT (should be 46).
- Section 5.2: "Statement 43 tests the TNDE cells with c' > 0" against the
  Table 7 row 43 "TNDE power shows no variation by cutoff (h = .15)". Check the
  cell set.
- Section 5.3 vs 8.2: differences "match as RCT minus RDD" (p. 12), but Eq 3.12
  is described as "RDD-minus-RCT" with the example (1.301 - 2.066)/0.733 =
  -1.044. These may be Chen's own sign conventions. Check.
- p. 4: "largest |bias| 0.016 (0.01551 before rounding)" against Table 3's PNDE3
  0.0155.

## Phase 2 addendum (written after the evidence check; the cold pass above is unchanged)

- Confirmed: Table 7 and results/statement_checks.csv number MINT power as statement 46. Section 5.2,
  para 2 (p. 8) calls it "statement 44, the H3 headline", so 44 is cited twice among the fifteen
  robust disagreements. This is a wrong statement number, and it is a required fix. Every other count
  and number in Section 5.2, Tables 7-8, Section 10.2 and Appendix C reproduces from the rerun of
  statement_checks.py, whose output is byte-identical to the committed CSV.
- Confirmed: "Statement 43 tests the TNDE cells with c' > 0" matches the script, which uses c in {.14, .39, .59}.
- Confirmed: the shortfall ratio is 43.62/0.0358 = 1,218, so "over 1,000 times" holds unrounded.
  The imbalance ratio is 144, so "about 140" holds.
- Confirmed: the RCT-minus-RDD differences and the (RDD - RCT)/SE standardized biases are both
  Chen's own conventions (eq. 3.12, printed p. 54; Tables 4.6-4.7). The paper is consistent with them.
- Confirmed: Appendix B ends at write_csv of per-replication estimates and CIs. No step comparing
  estimates with population values or aggregating cells is printed, so the abstract's limit is supported.
- My view of the other cold-pass items is unchanged.
