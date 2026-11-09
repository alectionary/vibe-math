# Review 18: cold pass (rendered PDF and criteria only)

Reviewer: independent cold-reader agent (fresh context, review 18).
Inputs read before this note: the four criteria files (editorial-review.md,
first-page-contract.md, manuscript.md, pdf-link-review.md) and the rendered PDF
`paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf`
(24 pages, each rendered at 80 dpi and inspected; text quoted via pdftotext).
No packet, manifest, DISAGREEMENTS.yaml, artifact, source, earlier review or git
history was opened before writing this note.

## Overall reader impression

The paper is verdict-first, standalone and unusually explicit about limits. A reader
who stops at page 1 learns: which work (Chen 2021, cited), its four simulation
headlines, our verdict (three not replicated, one partly), the signed contrasts,
tolerances and that labels are descriptive point estimates, the blocked Head Start
analysis, and the leading explanations. Nothing on its face looks blocking. Items
below are should-fix (not, on their face, making a number or label wrong) or polish,
plus numbers flagged for the evidence pass.

## Page 1: abstract

- Sentence 1: "We did not replicate three of the four simulation headlines of Chen
  (2021), who reported biased direct-effect estimates, percentile bootstrap intervals
  that cover the true value far too rarely, and power for the mediated interaction
  (MINT) near zero." Verdict first, source identified and cited, original findings
  stated. Pass.
- Sentences 2-3 give published-vs-ours numbers for H1-H3 (85.42% vs 0.00%; 43.62 vs
  0.04 points; 0.013 (raw 0.063) vs 0.802 (raw 0.852)). Good.
- Sentence 4 gives H4 "holds in part" with 86.3% / 89.2% and the both-zero exception.
- The limit of evidence (Head Start needs restricted-use data; unseeded bootstrap)
  comes in sentences 5-6, not immediately after the verdict as manuscript.md
  prescribes ("The next sentence is what we could not establish"). Polish: the
  ordering is defensible because H4 is a fourth headline result, but the limit could
  move up one sentence.
- "her coverage matches population values wrong for treated cases" is hard to parse
  (a coverage pattern cannot match population values). Polish: "her coverage matches
  a comparison with population values that are wrong for treated cases".
- "Her figures instead match data without the treatment-by-mediator interaction":
  same compression ("match results computed from data without..."). Polish.
- "of ten disagreements, eight are explained and two only partly" matches Section 6
  (6.2 and 6.3 partly). Consistent.
- Tolerance statement "her printed rounding (0.005-0.01 points) or our figure-reading
  error (.0091); comparisons are of point estimates, not equivalence." Good.

## Page 1: Table 1

- Readable at 80 dpi; nine columns, rows do not collide. Columns: Effect and estimand,
  Published, Ours, Published effect, Our effect, Effect magnitude, Direction, Verdict.
- E1: Published "PNDE and TNDE within [-.10, .10] in only 12.50-18.75% of conditions,
  with negative bias"; effect 85.42 (share outside). 100-12.50..18.75 gives
  81.25-87.50, mean 85.42 is plausible for six rows: verify. Ours 0.00, smaller,
  zero vs nonzero, no match. Looks right.
- E2: 43.62 vs 0.04, smaller, same. Our 0.04 exceeds the 0.005 tolerance so "same"
  direction follows the contract; Section 1 gives its Monte Carlo SE (0.005-0.019),
  so this "same direction" carries little inferential weight; the paper says so
  ("as point estimates they point the same way"). Acceptable.
- E3: 47.07 vs 0.33 smaller same. Tolerance 0.01 (two rounded inputs). Plausible.
- E4: 0.013 vs 0.802, larger, same, no match. Caption discloses "cell chosen after
  the results were seen" and "her cutoff-1 series is hidden". Honest. Tolerance 0.0091
  "mean reading error of her two read points". Flag for evidence pass: Section 4.3
  (p. 7) says the two readings are 0.068 and 0.057, whose mean is 0.0625, giving an
  excess of 0.0125, not the 0.0127 / raw 0.063 shown; presumably unrounded readings,
  verify.
- E5: "not established" for all scalar columns with "qualitative, no scalar contrast"
  applicability text; Published/Ours cells carry substantive findings; Verdict
  "partial". Appropriate.
- Caption contains "Descriptive point estimates; not equivalence." and defines
  estimands, units (percentage points / rejection rate), positive meaning and each
  tolerance. Good.
- Minor: "Monte Carlo errors: Section 1" points to the introduction; fine.

## Page 2: introduction

- Opening "We did not replicate the simulation headlines of Chen (2021): her finding
  that ... , her finding that ... , and her finding that ..." then "Her fourth headline
  ... holds for most but not all cells". Should-fix (wording, not failing): the
  abstract says "three of the four"; the introduction's "the simulation headlines"
  read alone sounds like all of them, although the colon list enumerates exactly
  three and H4 follows. Fix: "We did not replicate three of the four simulation
  headlines of Chen (2021): ...".
- Limit of evidence is stated ("The limit of our evidence is that her Head Start
  analysis ... could not be rerun ... and that her interval-based results cannot be
  reproduced draw for draw"), then "No estimate reverses its sign." Good.
- "about three orders of magnitude smaller ... about two": 43.62/0.04 ~ 1,090 and
  47.07/0.33 ~ 143. Consistent.
- MC SE statements (about .007 for a rate; E4 about .002; shortfall 0.005/0.019)
  are present. Good.
- The paragraph on research questions comes after the verdict, as required.

## Page 3-4: methods

- Section 2 labels contributions clearly (six items) and attributes model/design to
  Chen. Good.
- 3.3 "Exact R replay": careful scope ("reproduces her printed pipeline, not her
  published runs"). Literal check: "by design the check rebuilds every second dataset
  (635) and skips the rest by drawing the same number of normal deviates. The 635
  rebuilt datasets match ... exactly ... and the random-number state after all 1,270
  is identical". Clear, but verify against chen_exact.R and literal_check.txt that
  (a) only 635 were compared and (b) "her own group_walk/pmap_dfr pipeline" is really
  what was run.
- p. 4: "It first rebuilt 64,000 datasets ..." The antecedent of "It" is ambiguous
  (just after the literal-check sentence; it means the replay). Polish.
- p. 4: stray space in "( r-reproduction/out-full/literal_check.txt)". Polish.
- p. 4 "How the engines were chosen": discloses that Python was used without first
  asking the owner. This is a consequential departure, so keeping it is right; it
  reads a little like process narrative ("When told, the owner agreed"). Polish only.
- Issues #92 and #118 are named (issue links are allowed); no commit or branch named.

## Page 5-6: H1, Table 2, H2

- H1: "largest |bias| over all 19,200 condition-cutoff-effect results ... is 0.016";
  19,200 = 3,840 x 5. Consistent. Replay: "largest condition-mean bias is 0.017";
  "5.3% ... beyond 1.96 MC SE and 0.14% beyond 3.29" (expected 5% and 0.1%). Fine.
- Table 2 readable; the R-replay Data cell repeats the 635-of-1,270 literal check.
- H2: "92.9% of the 19,200 results lie in Bradley's [.925, .975]" with MINT 80.1%,
  PNIE 89.4%, TNIE 95.4%; the section title "close to nominal coverage" is qualified
  in text ("describes the row means"). Acceptable.

## Page 7: H3, H4, S1

- H3: E4 explained, tolerance rounding down disclosed, post hoc cell choice disclosed.
  Good. See the 0.0625/0.0627 query above.
- H4: Type I shares 70.0, 74.0, 80.1, 86.3, 89.6; power 35.9, 53.3, 61.5, 89.2, 91.4;
  "largest step is from 2,500 to 5,000" holds for both (6.2 vs 6.1 points for Type I:
  barely). 1,176 + 2,664 = 3,840 per n. Consistent.
- S1 numbers 27.08/39.06/12.50 to verify.

## Page 8-9: S2, S3, RQ2, RQ1/S8

- S2/S3 counts are internally consistent: 13+16 = 29 strict, 14+17 = 31 slack,
  46-31 = 15 disagree under both, 10 of 15 become agreements with h = 0, 39 hold,
  the 7 listed (2, 43, 10, 11, 30, 41, 44) = 46-39. Good.
- RQ2: S4 and S6 explicitly "blocked: not established, and not a failure to
  replicate". Good.
- S9 (10 of 15) and S8 ("announced, never reported", with search terms) are clear.

## Page 10-11: Table 3

- Readable. H3 published shown as 0.0127 here vs 0.013 in Table 1 (display rounding;
  fine). S8 numerical "not applicable"; S4/S6 "withheld"/"unavailable". Consistent
  with definitions on p. 9.
- "Small differences that are not replication failures" list is present. Good.

## Page 11-17: disagreements

- Each of 6.1-6.10 has competing theories with an "ours" theory first, predictions,
  tests, verdicts and a conclusion with confidence. Explained/partly counts match
  the abstract.
- 6.1 conclusion: "Explained; ... high confidence: the evidence indicates ... (an
  inference from her outputs ...)" with mechanism undetermined. Calibrated.
- 6.2 conclusion: partly explained, medium confidence; bias rule not determined.
- 6.3: "supported" with an unexplained ah coefficient of -0.26 admitted; partly.
- 6.7: "Monte Carlo noise in one prespecified comparison" marked inconclusive with an
  honest reason (selected post hoc); conclusion "Explained as Monte Carlo variation"
  while Section 9 keeps ".009 of the .038 gap" open. Mildly in tension, but the
  residual is within reading error; acceptable.

## Page 17-20: assumptions, ambiguities, unresolved, limitations, availability

- 7.5 states the E4 tolerance was "not set in the plan". Honest.
- Limitations 1-7 plus claim-specific limits. Good.
- Availability ledger (p. 20) dated 2026-11-08 with six rows; verify against
  notes/availability.md.
- Source identified with labelled (truncated) SHA-256; fine under the project rule.

## Page 20-24: references and appendices

- References render; Chen entry: University of Nebraska-Lincoln, December 2021,
  Digital Commons URL. Verify against the source title page.
- Appendix A: "The code, committed outputs and evidence cited here are those on the
  master branch, where every link points." No commit hash or working branch anywhere
  in the rendered text (checked visually on every page).
- Appendix B ledger includes the departures (engine, source software, software
  versions) with justifications.
- Appendix C claim inventory statuses agree with Sections 4.1-4.9 and Table 3.

## Commit/branch references

None seen in the rendered PDF. Only "master", issue numbers #92/#118, and a labelled
SHA-256 of the source PDF.

## Cold-pass severity summary

- Blocking: none found on the face of the PDF.
- Should-fix (non-failing unless evidence shows otherwise): introduction sentence 1
  should say "three of the four" (p. 2).
- To verify in the evidence pass: E4 0.068/0.057 vs raw 0.063/0.0127 (p. 7, p. 1);
  E1-E3 published averages; literal-check scope (p. 4); availability ledger (p. 20).
- Polish: abstract "matches population values" compressions (p. 1); limit sentence
  placement in abstract (p. 1); "It first rebuilt" antecedent (p. 4); stray space
  before r-reproduction/out-full/literal_check.txt (p. 4); engine-choice narrative
  wording (p. 4).
