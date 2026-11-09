# Review 12: cold pass (rendered PDF and criteria only)

Reviewer: independent cold-reader agent, fresh context. Read before opening the
evidence packet, writer manifest, DISAGREEMENTS.yaml, source, artifacts, prior
reviews, provenance or git history. Inputs: the two criteria files and
`paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf`
(23 pages), all pages rendered with `pdftoppm -r 80` and inspected; page 1 also
at 160 dpi; text quoted from `pdftotext -layout`.

## Overall reader impression

A dense but well-organized paper. The verdict comes first in both abstract and
introduction, each headline (H1-H4) has a signed contrast, tolerance and
uncertainty statement, disagreements are laid out as competing theories with
predictions, tests and verdicts, and blocked parts are not called failures. The
problems I found as a reader are one abstract sentence that understates the
Head Start results, one abstract parenthetical that says more failed than
Section 6.2 reports, and a few calibration and polish points.

## Page 1: abstract

- p1, abstract sentence 1: "We did not replicate the three simulation headlines
  of Chen (2021), who reported that direct-effect estimates are biased, that
  percentile bootstrap intervals cover the true value far too rarely, and that
  power for the mediated interaction (MINT) is near zero: ..." The verdict comes
  first, the source is named and cited, and the three original findings are stated
  with numbers for both sides. Pass.
- p1, abstract sentence 2: "Her fourth headline, a tentative minimum of 5,000
  cases ... holds only in part: at n = 5,000, 86.3% ... and 89.2% ... but
  products with both paths zero stay conservative at every n." Clear partial
  verdict with its evidence and limit. Pass.
- p1, abstract: "Her Head Start analysis needs restricted-use data and is not
  established either way". As a reader I then find in Section 4.8 (p8) and
  Table 3 (p9-10) that S5 (Head Start arithmetic) is "replicated" and S9 (opposite
  significance conclusions, which the paper says is in her own abstract) is
  "partly replicated" from her printed intervals. "Not established either way"
  is true of rerunning the analysis (S4, S6) but not of the Head Start claims as a
  whole. Severity: **should-fix** (the abstract understates and internally
  contradicts the body; the abstract also never mentions S9, a conclusion in
  Chen's own abstract). Fix: "Her Head Start estimates need restricted-use data
  and could not be rerun; from her printed numbers, her arithmetic recomputes and
  her claim of opposite significance conclusions holds in 10 of 15 comparisons."
- p1, abstract: "her figures instead match data without the treatment-by-mediator
  interaction and, in part, population values wrong for treated cases (that rule
  does not fit her third cutoff)." Section 6.2 (p11-12) says the per-case rule
  "reproduces her coverage and imbalance at every cutoff"; only the single-scale
  version for *bias* fails at cutoff 3 (lambda 1.76). The parenthetical says the
  rule does not fit cutoff 3 without qualification. Severity: **should-fix**
  (misstates a result). Fix: "(it fits her coverage at every cutoff but not her
  bias at the third)".
- p1, abstract: "for the largest interaction at n = 500 her MINT rejection rate
  exceeds the nominal .05 by 0.013 (raw 0.063, her Figure 4.28), about one
  reading error". Honest about the knife edge. Table 1 labels E4 direction "same";
  her excess 0.0127 exceeds the 0.0123 tolerance by only 0.0004 and the tolerance
  was set after results were seen (p6, p17 Section 7.5). Disclosed; polish:
  say in the caption or row that her excess is within 0.0004 of the tolerance, so
  "same direction" is a near-tie, not evidence that her MINT has power.
- p1, abstract: "Tolerances are her printed rounding (0.005-0.01 points) or the
  figure-reading error (.0123); comparisons are descriptive point estimates, not
  equivalence." Pass.
- p1, abstract length: about 330 words in one paragraph; dense with numbers.
  Polish.

## Page 1: Table 1

- Readable at 80 dpi; columns Effect and estimand / Published / Ours / Published
  effect / Our effect / Effect magnitude / Direction / Verdict. Heading
  "Effect magnitude" present; caption begins "Descriptive point estimates; not
  equivalence."
- E1: Published "PNDE and TNDE within [-.10, .10] in only 12.50-18.75% of
  conditions, with negative bias"; Published effect 85.42 (mean share outside,
  consistent with 81.25-87.50 outside). Ours "within [-.05, .05] in 100% of
  conditions; largest |bias| 0.016"; 0.00; smaller; zero vs nonzero; no match.
  Coherent on its face.
- E2/E3: identical Published and Ours text in both rows. E3's Published cell does
  not state her imbalance (47.07); the cell does say "true value usually above the
  CI". Polish: give E3 its own cells (e.g. "true value above the CI in most
  misses").
- E2 ours 0.04 and E3 ours 0.33 labeled "same" direction; caption gives Monte
  Carlo SE 0.005-0.02 for these means, so both are several SEs from zero. Coherent.
- E4: Published "MINT power near zero at every sample size; never reaches .80
  (Figure 4.28: 0.057-0.068 in this cell)"; 0.013 vs 0.786; larger; same; no
  match. Caption explains unrounded 0.0127 and tolerance 0.0123 "rounded down;
  one point is partly hidden". Coherent; see near-tie note above.
- E5: qualitative row, "not established" across scalar cells, verdict partial;
  applicability "qualitative, no scalar contrast" in row. Pass.
- Caption: contrasts, units, positive meaning, tolerances and their basis, Monte
  Carlo SE and "Chen reports none" all present. Pass.

## Page 2: introduction

- p2, para 1, sentence 1: "We did not replicate the simulation headlines of Chen
  (2021): ..." verdict first, numbers for each, partial H4, then limits (RQ2
  restricted data; unseeded bootstrap). Pass.
- p2, para 1: "The limit of our evidence is that her Head Start analysis
  (research question 2) could not be rerun ..." Accurate (unlike the abstract's
  "not established either way").
- p2, para 1: "about three orders of magnitude smaller ... and our imbalance
  (0.33 against 47.07) about two" (43.62/0.04 = 1090; 47.07/0.33 = 143). Correct.
- p2, last para: "her bias and coverage match a comparison with population values
  that are right for control cases and wrong for treated cases (Section 6.2, only
  partly explained)". Better calibrated than the abstract parenthetical.

## Pages 2-5: what we did, methods, comparability

- p3 Section 3.1: design, 1,280 conditions x 3 cutoffs = 3,840 cells; cutoff
  orientation by code flagged (Section 8.1). Clear.
- p4 Section 3.3: "The replay therefore reproduces her printed pipeline, not her
  published runs." Good, explicit limit on what the exact R replay reproduces;
  "It does not reproduce her bootstrap". Pass.
- p4 Section 3.3: "Section 6.1 shows that those lacked the interaction wherever
  h > 0". Also Table 2 (p5) "published results lack h where h > 0" and Limitation
  1 (p18) "her published results came from data without the interaction". This is
  an inference from digitized figures (Limitation 2 says the mechanisms are
  "inferred"), stated as fact in three places. Polish/calibration: say "evidently"
  or "on the evidence of Section 6.1".
- p4 "How the engines were chosen": candid disclosure that Python was used before
  asking the owner. Pass.
- p4-5 Section 3.4: digitizing reading errors and cross-check counts stated;
  PyMuPDF/pandas versions not recorded (disclosed). Pass.
- p5 Table 2: readable; clear.

## Pages 5-8: results

- p5 4.1 heading "H1: direct effects are not biased" states our finding; body
  quotes hers. Pass.
- p6 4.1: replay "largest condition-mean bias is 0.017"; p10 6.1 "no
  condition-mean bias exceeds .018 for any effect". Not contradictory but reads
  oddly (why .018 if the max is .017?). Polish: use one number or say which set
  each covers.
- p6 4.2: honest that the 0.33 imbalance was not investigated. Pass.
- p6 4.3: "This contrast cell ... was chosen after the full results were
  available" - candid about post-hoc selection. Pass.
- p6-7 4.3: notes her own abstract contradicts her MINT statement. Useful.
- p7 4.4: "Chen states this as tentative; we judge it literally over the whole
  grid." Pass.
- p7 4.6 / p7-8 4.7: statement counts 13+16 = 29, 14+17 = 31, 46-31 = 15,
  29+10 = 39, 46-39 = 7 (2, 43, 10, 11, 30, 41, 44). Internally consistent.
- p8 4.8: blocked parts "not established, and not a failure to replicate". Pass.
- p8 4.8 S9: 10 of 15 opposite, 6 of 6 where trial significant. Pass.
- p8-9 4.9: S8 not reported, search terms given. Pass.

## Pages 9-10: Table 3 and reasons

- Table 3 definitions are stated before the table; rows match Table 1 values.
- p10 "Reasons by row": H3 "her rate is about one reading error above it (0.0127
  against a tolerance of 0.0123)". Consistent.
- "Small differences that are not replication failures" clear.

## Pages 10-16: disagreements

- Each subsection: her result, ours, theories (ours tested first), predictions,
  tests, results, verdicts, conclusion with confidence. Ten sections; "eight are
  explained and two (Sections 6.2 and 6.3) are partly explained". Counted: 6.1
  explained, 6.2 partly, 6.3 partly, 6.4-6.10 explained. Consistent.
- p11 6.1 "85-100% of points agree" vs p8 "84.9-100.0%". Rounding; polish.
- p12 6.2 lambda = 1.96, 1.92, 1.76; consistent with k/treated share (1.469/.75,
  .959/.5, .441/.25). Good.
- p14-15 6.7: post-hoc selection handled explicitly. Pass.
- p15 6.9: arithmetic (-0.127/0.061 = -2.082) correct.

## Pages 16-19: assumptions, ambiguities, unresolved, limitations, availability

- p17 7.5: tolerance "not set in the plan", "rounded down". Honest.
- p18 Section 9 lists open items with ranked candidates and the artifact that
  would settle them. Pass.
- p18-19 Section 10: seven limitations plus claim-specific limits. Pass.
- p19 Section 11 availability ledger readable.

## Pages 19-23: references, appendices

- References complete for cited works; Chen entry has title, institution, date,
  URL, advisers.
- p20-21 Appendix A table readable; underscores in some commands render as
  spaces in the command column ("chen sim.py", "statement checks.py") while the
  File column shows underscores. Polish: the printed commands cannot be copied as
  shown.
- p21-22 Appendix B: two "departed" rows disclosed with justification. Pass.
- p22-23 Appendix C: claim statuses match the body (H1-H3 not replicated, H4
  partial, S1 not replicated, S2/S3 partial, S4/S6 blocked, S5 replicated, S7/S8
  not established, S9 partial).

## Severity summary

- Blocking: none found on the cold pass.
- Should-fix: (1) p1 abstract "Her Head Start analysis ... is not established
  either way" understates S5 (replicated) and S9 (partly replicated), and S9 is
  absent from the abstract; (2) p1 abstract "(that rule does not fit her third
  cutoff)" overstates the failure: the rule fits coverage at every cutoff and
  fails only for bias at cutoff 3.
- Polish: E4 near-tie note; E3 own cells; "shows/lack" calibration (p4, p5,
  p18); 0.017 vs .018 (p6/p10); 84.9 vs 85 (p8/p11); Appendix A underscores;
  abstract length.
