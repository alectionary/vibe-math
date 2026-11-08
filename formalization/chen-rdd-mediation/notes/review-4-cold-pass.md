# Review 4: cold pass (rendered PDF only)

PDF: paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf
sha256 90542373b170b27c33b5a3e8c6a22941ad53a4019614ebd8448e9443fa99643f, 20 pages.
Read before opening any packet, manifest, source, .tex or earlier review. Pages rendered at
90 dpi and read as images (pp. 1, 2, 9, 17 inspected visually in detail) plus pdftotext -layout
for every page.

## abstract_verdict_first (page 1, abstract) -- provisional pass

- Sentence 1: "We did not replicate three of the four simulation headline findings of Chen (2021),
  who reported that mediation analysis in a sharp regression discontinuity design gives biased
  natural direct effects, percentile bootstrap confidence intervals that cover the true value far
  less often than the nominal level, and near-zero power for the mediated interaction: ..."
  Verdict first, source cited, Chen's finding stated, then the published-versus-ours numbers
  (85.42 vs 0.00; 43.62 vs 0.04; 47.07 vs 0.33; near zero vs 0.836). The run count
  "all 3,840 condition-cutoff cells" is given.
- Sentence 2 is the limit: "We could not establish why her results differ, as her step comparing
  estimates with true values is unprinted; her Head Start Impact Study comparison is not
  established, as its data were unavailable." Correct order (limit after verdict).
- Weakness: the reason given ("her step comparing estimates with true values is unprinted") cannot
  account for the mediated-interaction power disagreement, which the body (p. 7, Section 4.3)
  says "cannot come from how estimates were compared with population values". The introduction
  (p. 2) gives the fuller reason ("... not printed and her result files are not available").
  The abstract's single reason is therefore slightly narrower than the body. Polish, not fatal.
- The first sentence lists only three of the four findings; the fourth (minimum n of 5,000) is
  introduced only in the last sentence ("partly replicated"). The composite is understandable but
  a reader has to infer that the fourth finding is the 5,000 recommendation.
- "except effects with both paths zero" (last sentence) is ambiguous: it can be read as saying the
  86.3% excludes those effects. Section 4.4 (p. 7) shows they are included and simply fail
  (conservative, about .002). Also the abstract omits that small effects (ah = .007) stay
  below .80 power even at n = 10,000.
- Jargon: "condition-cutoff cells" is not defined in the abstract (defined in the Table 1 caption
  and Section 1).
- No tolerance in the abstract; the tolerance and direction are in Table 1 (direction column;
  caption "E1 tolerance 0.005 percentage points ..."). That satisfies page 1.

## introduction_verdict_first (page 2, Section 1, paragraph 1) -- provisional pass

- Opens "We did not replicate three of the four simulation headline findings of Chen (2021) ..."
  with the same numbers, the exact count "all 3,840 of 3,840 condition-cutoff cells", a direct
  quotation "All power for MINT is near zero" (printed p. 121), then the limit, then
  "No headline effect reversed its sign", then the statement-check counts (27 of 41; 29 with
  slack; 9 of the 12 disagreements concern effects that include h), then H4 partly replicated,
  then the tolerance (0.005, 0.005, 0.01 percentage points, rounding bound, not a sampling band,
  not equivalence). Good structure.
- Inaccuracy: "our coverage shortfall and imbalance have the same sign as hers but are two orders
  of magnitude smaller". Imbalance 47.07 vs 0.33 is a factor of about 140 (two orders), but the
  shortfall 43.62 vs 0.04 is a factor of about 1,000 (three orders). Understatement, not an
  overclaim; suggested fix.
- The paragraph is one very long block (about 28 lines). Legible, but heavy.
- Paragraph 2 gives the three research questions after the verdict, as required.

## standalone_prose -- provisional pass with concerns

- Claim labels H1-H4 and E1-E5 are defined on page 1 (Table 1 caption "Headline claims H1-H4");
  S1-S8 first appear in Section 5 headings (p. 8, "Indirect and mediated-interaction bias (S1)")
  without a definition until Appendix C (p. 19-20). A reader can infer them, but they are internal
  labels. Polish.
- "both-zero products" (page 1 caption) is defined there. "slack" is defined in Table 7 caption
  (p. 9). "condition-cutoff cell" defined in Table 1 caption and Section 1.
- "the H3 headline" (p. 8) relies on the label.
- Appendix A/B (pp. 17-19) mention "handoff/SNAPSHOTS.md" and "approved-preamble.tex"; these are
  file names given as provenance, acceptable.
- No "see the manifest", no internal roles, no LLM authorship statement. File names in text are in
  typewriter face with extensions (cells.csv, summary.json, chen_sim.py ...).
- Classification criterion for "9 of the 12 [disagreements] concern effects that include h"
  (pp. 2, 8, 14) is not defined precisely. Statements 9-11 are TNIE statements (TNIE = ab + ah
  includes h, and the statements are "at every h"), yet they are counted among the 3 that do NOT
  concern h, while statement 17 (MINT with a = 0, population value zero for every h) is counted
  among the 9 that do. Section 5.2 words it as "cells in which h is part of the effect", the
  abstract-adjacent intro as "effects that include h". Need to check in Phase 2 how the 9 were
  classified; as written the criterion is unclear.

## scientific_process_distinction -- provisional pass

- Section 2 (pp. 2-3) separates Chen's contribution (model, design, tables, code of Appendices
  A-B) from ours (re-implementation, run, comparison) and says derived Chen values are marked;
  Table 8 marks them with a dagger; Table 1 caption: "E1-E3 published effects are our averages of
  her rows".
- Table captions (Tables 3, 4, 5, 6, 7) separate copied Chen columns from our simulation files.
- Post hoc choice of the H3 contrast cell is disclosed: "chosen after our full results were
  available as the most direct test of that statement" (p. 7; Section 7.5 p. 13). Honest.
- Statement-reading thresholds: "these readings are ours, so a second verdict moves every
  threshold .01 in her favour" (p. 8). Good disclosure, though whether thresholds were fixed
  before comparison ("fixed in the script before the comparison") is a process claim to check.
- Causes: Section 4.1 (p. 4) argues her model is correctly specified so her "incorrect functional
  form" explanation is not supported; Section 10 ranks candidate (e) "untested, not established";
  Section 5.1 calls the zero-estimate pattern "a consistency observation ..., not a diagnosis".
  No cause is presented as established. "OLS has no source of bias" (p. 4) slightly overstates
  for product/nonlinear estimators (ab, c' + h i0M) but the empirical result supports
  negligible bias.
- Process claims to verify in Phase 2: R could not be installed on either of two computers
  (p. 3, 13); 401 + 879 conditions split; rerun agreement 1.1e-16; 13.7 core-hours; scikit-learn
  1.9.1 validation; Python 3.13.18 / NumPy 2.5.3 / Python 3.10.12 / NumPy 2.2.6; thresholds fixed
  before comparison.

## Headline clarity and page-1 legibility (page 1)

- Title, date, abstract, then Table 1 immediately, before the introduction. Columns: Claim /
  estimand, Published, Ours, Published effect, Our effect, Effect magnitude, Direction, Verdict.
- Table 1 is dense: the first three text columns are narrow, causing heavy wrapping; the caption
  is in a small font (~7 pt at 90 dpi rendering, legible when zoomed). Rows E2 and E3 repeat
  identical Published/Ours text. Acceptable but cramped.
- E1: 85.42 vs 0.00, smaller, zero vs nonzero, no match. E2: 43.62 vs 0.04, smaller, same
  direction. E3: 47.07 vs 0.33, smaller, same direction. E4: not established vs 0.836, magnitude
  and direction not established, no match. E5: all not established, partial.
- Caption gives tolerances and units for each row and "Descriptive point estimates; not
  equivalence." and "Chen reports no Monte Carlo errors; ours are about 0.7 percentage points per
  cell."
- My arithmetic from the printed Tables 3-4 (pp. 5-6): E1 = mean(100 - 12.50, 12.50, 18.75,
  12.50, 12.50, 18.75) = 85.4167 -> 85.42; E2 = 95 - 770.71/15 = 43.62; ours 95 - 1424.46/15 =
  0.036 -> 0.04; E3 = 706.07/15 = 47.07; ours 4.90/15 = 0.33. Tolerances: E1 and E2 are means of
  values each rounded to 0.01 (bound 0.005); E3 is a mean of differences of two rounded values
  (0.01). Consistent.
- H3 Ours cell reports only the large-ah results (0.836; at least .97 for ah >= .13); the small-ah
  near-zero rates (0.011 at ah = .007, n = 500) are in the body only. Not misleading, given the
  Published cell says "at every sample size; never reaches .80", but a reader might want both.
- Internal consistency checks done: statement verdict counts in Table 7 (12+15 = 27 agree; slack
  flips statements 2 and 40, giving 13 and 16, 29 total; 12 disagree under both readings);
  zero-effect counts 392 per cutoff x 3 = 1,176, x 5 n = 5,880; mean of Table 6 Type I column =
  80.0; S1 averages 27.08, 39.06, 12.50; zero-estimate pattern for PNIE (75%, 50%) and MINT
  (87.5%, 75%) recomputed and matches.

## Things a first-time reader would find confusing or unsupported

1. The "9 of 12 concern effects that include h" criterion (above).
2. "two orders of magnitude smaller" for the shortfall (factor ~1,000).
3. Abstract's single stated reason for the unexplained differences does not cover H3.
4. "except effects with both paths zero" ambiguity in the abstract.
5. S-labels undefined until Appendix C.

---

## Appended after Phase 2 (evidence check); the cold-pass sections above are unchanged

- Confirmed: E1-E3 recompute from Chen's printed Tables 4.8 (PDF p. 102) and 4.9 (PDF p. 138) as
  85.4167, 43.6193, 47.0713 and from results/table48_ours.csv / table49_ours.csv as 0.00, 0.0358,
  0.3258. All Table 3-6 entries match the results files; statement_checks.py reruns byte-identical
  to results/statement_checks.csv (27/41, 29/41, 12/17, 13/17, 15/24, 16/24 confirmed).
- Confirmed: all quotations of Chen match the source at the cited pages; title-page metadata correct.
- Confirmed and sharpened, cold-pass concern 1 ("9 of 12"): this is now a required fix.
  Statement 9 fails exactly in its h = .15 and h = .34 cell sets (our TNIE3 Type I at n = 500 is
  .043 and .054, inside the band, where Chen reports "outside ... for all levels of h"). That is the
  same pattern as statement 17 (a = 0, population zero, her text reports no variation across h,
  ours varies), which the paper counts among the 9. So statement 9 meets the paper's own criterion,
  and the paper's description of statements 9-11 as "near the robustness bounds" is wrong for
  statement 9 (.043/.054) and for statement 11's b = 0, h = .05 set (.004 at n = 500). No script
  computes the classification.
- New, not material to verdicts: statements 24-28 are tested only at cutoff 1 and h = .15. Chen's
  paragraph (PDF p. 126) is ambiguous between "TNIE1 at all h" (Figure 4.23) and "all cutoffs at
  h = .15" (Figure 4.24). I reran both readings and the verdicts do not change. The same holds when
  c' = 0 is added to statements 35 and 40 and h = 0 to statement 29.
- Cold-pass concerns 2-5 stay suggestions.
