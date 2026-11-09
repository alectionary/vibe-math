# Review 17: cold pass (rendered PDF and criteria only)

Reviewer: independent cold-reader agent, fresh context. Read before opening the
evidence packet, writer manifest, DISAGREEMENTS.yaml, sources or earlier reviews.
PDF: `paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf`
(24 pages), rendered at 80 dpi; every page inspected; text quoted from `pdftotext -layout`.

## Overall reader judgment

The paper is verdict-first, standalone and unusually careful about limits. A reader
learns on page 1 what Chen (2021) reported, what we found, the tolerances, that the
comparisons are point estimates, and what could not be rerun. No blocking problem is
visible on the face of the PDF. Items below are should-fix or polish, to be confirmed
or dismissed in the evidence pass.

## Page 1: abstract

- Sentence 1: "We did not replicate the three simulation headlines of Chen (2021), who
  reported biased direct-effect estimates, percentile bootstrap intervals that cover the
  true value far too rarely, and power for the mediated interaction (MINT) near zero:
  85.42% ... against 0.00% ...; 43.62 ... against 0.04; ... 0.013 (raw 0.063) ... against
  0.802 (raw 0.852)." Verdict first, source cited, original finding stated, all three
  headline numbers paired. Good.
- "the three simulation headlines" -- H4 (the 5,000-case recommendation) is also a
  simulation headline and is reported next as holding "only in part"; Section 1 calls it
  "Her fourth headline". A reader may briefly think there are only three headlines.
  Severity: polish (the next sentence covers H4 explicitly; nothing is hidden). Suggested:
  "three of the four simulation headlines".
- Limit sentence: Head Start "need restricted-use data and could not be rerun";
  unseeded bootstrap. Present and phrased as a limit. Good.
- "Her printed, seeded R code, replayed on all 1,280,000 datasets it generates" --
  see p. 4 note on 635 of 1,270; check in evidence that "all ... it generates" is exact.
- Tolerances stated: "her printed rounding (0.005-0.01 points) or the figure-reading
  error (.0091); these are point-estimate comparisons, not equivalence." Good.
- Not stated on page 1: the E4 contrast cell was chosen after results were seen (stated
  only on p. 7, Section 4.3) and the .0091 tolerance was not set in the plan (p. 17,
  Section 7.5). The tolerance is not called prespecified, so nothing is wrong, but the
  post-hoc cell choice is relevant to E4. Severity: polish.

## Page 1: Table 1

- Columns: Effect and estimand | Published | Ours | Published effect | Our effect |
  Effect magnitude | Direction | Verdict. Headings legible at 80 dpi; row spacing fine.
- E1: 85.42 vs 0.00, smaller, zero vs nonzero, no match. 0.00 is within tolerance 0.005
  of zero, so "zero vs nonzero" is the right label. Published cell "within [-.10, .10] in
  only 12.50-18.75% of conditions, with negative bias" is consistent with 85.42 outside
  (mean of complement 14.58 lies in range). Ours cell: "largest |bias| 0.016" -- p. 5
  says 0.016 is the maximum over all five effects; true for direct effects a fortiori.
- E2: 43.62 vs 0.04, smaller, same; 0.04 > tolerance 0.005 so a positive sign is
  displayed. Fine as descriptive.
- E3: 47.07 vs 0.33, tolerance 0.01 (two rounded inputs). Fine.
- E4: 0.013 vs 0.802, larger, same, tolerance 0.0091. Hers 0.0127 > 0.0091 so not "zero";
  caption gives "about 1.4 reading errors". Check 0.0127 vs raw 0.063 (0.063 - .05 =
  0.013; 0.0127 implies unrounded readings). Published cell "0.057-0.068 in this cell".
- E5: all comparison cells "not established", verdict partial, Published/Ours cells
  carry real findings (tentative minimum; 86.3%/89.2%; both-zero products conservative).
- Caption: "Descriptive point estimates; not equivalence." present; units, estimands,
  positive meaning, all tolerances and their basis present; MC errors pointed to
  Section 1. Good.
- No commit hash or working branch on page 1.

## Page 2: Introduction

- Opens "We did not replicate the simulation headlines of Chen (2021)" with the same
  numbers; then MC standard errors (.007; E4 .002); limit (Head Start; unseeded
  bootstrap); "No estimate reverses its sign." Verdict first. Good.
- "Our replay of her printed code behaves like our independent run, not like her
  published results. The disagreements therefore arise in steps she did not print." --
  "therefore" is slightly strong: Section 6.1 attributes much of it to the data behind
  her published runs, i.e. a run differing from the printed code, not only unprinted
  steps. Severity: polish.

## Page 4: Section 3.3

- "On the first simulation block of her code (1,270 datasets, of which the 635 kept by
  the replay were compared)" -- unexplained why the replay keeps 635 of 1,270, and this
  sits uneasily with "all 1,280,000 datasets it generates" (abstract, p. 2). Table 2
  (p. 6) says identity "verified on the first simulation block (1,270 datasets)",
  whereas the text says 635 were compared. Internally inconsistent on its face.
  Severity: should-fix (clarify what was compared; make Table 2 say 635 compared).
- "How the engines were chosen" narrates project process ("made without first asking
  the owner of this replication project"). It is a disclosed departure, consistent with
  ledger; acceptable. Severity: polish at most.
- References issues #92 and #118 (allowed: issue links). No commit/branch named.

## Page 5-6: H1, H2

- H1 "largest |bias| ... 0.016, MC SE of a cell mean at most 0.006"; replay 0.017;
  5.3% beyond 1.96 SE, 0.14% beyond 3.29 -- consistent with no bias. Clear.
- H2 "Mean coverage is 94.6-95.6% ... lowest cell coverage is 0.916, and 92.9% of the
  19,200 results lie in Bradley's" -- honestly qualified by product effects at 80.1-95.4%.
- p. 6 "small positive imbalance (0.33 points) ... we did not investigate its cause" --
  honest; also in Section 9.

## Page 7: H3, H4

- H3: contrast cell chosen after results seen is disclosed here. Good.
- H3: notes her abstract contradicts her MINT statement. Good.
- H4: "Mostly ... partly replicated". Shares by n given. Good.

## Page 8-9: S1, S2, S3, RQ2

- Statement counts: 13/18 (14 slack), 16/28 (17 slack), 29/46 (31 slack); with h = 0,
  39 of 46 (strict). 10 of 15 both-reading disagreements turn into agreements, leaving
  10, 11, 30, 41, 44, plus 2 and 43 that agree only with slack: 46 - 7 = 39. Arithmetic
  coherent but requires care to follow. Polish: say "39 of 46 hold as designed".
- p. 8: "with that divisor the printed sign is that of RDD minus RCT" -- Section 6.4
  (p. 14) says the standardized biases "equal the difference divided by the standard
  error" without mentioning the sign flip. Minor internal inconsistency. Severity: polish.
- RQ2 blocked parts called "blocked: not established, and not a failure to replicate".
  Correct handling.
- S9 "partly replicated, from printed numbers only". Good.

## Pages 9-11: Section 5, Table 3

- Definitions clear. H3 row shows 0.0127 (Table 1 shows 0.013) -- precision differs
  but both labelled. Fine.
- "Small differences that are not replication failures" list present.

## Pages 11-17: Section 6

- Every disagreement has competing theories including our own errors, tests, verdicts,
  conclusion with side and confidence. "eight explained, two partly (6.2, 6.3)";
  sections 6.1-6.10 count to ten. Consistent with abstract.
- 6.2 header uses "Bradley's [92.5, 97.5]" (percent) whereas 3.2 uses [.925, .975].
  Polish.
- 6.7 post-hoc selection handled properly (single-comparison criterion not applied).

## Pages 17-19: Assumptions, ambiguities, unresolved, limitations

- 7.5 states E4 tolerance not set in plan; not called prespecified. Good.
- Limitations complete and claim-tagged.

## Pages 19-20: availability ledger

- Dated rows, ICPSR checks, owner's restricted-use application. "public-use data
  files ... next row finds none" -- clear. To check against notes/availability.md.

## Pages 21-24: Appendices

- Appendix A says links point to master branch only (naming `master` is allowed).
  Commands and outputs listed per claim. "about 3.4 hours" vs "3 hours 25 minutes" (p. 4)
  consistent.
- Appendix B ledger: departures justified.
- Appendix C, Front matter row: "Claims: none" but note "including S9" -- slight
  contradiction (S9 is stated in her abstract). Polish.
- No commit SHA or working-branch name anywhere in the rendered text (only labelled
  SHA-256 of the source PDF, abbreviated). To confirm with commit_refs.py.

## Summary of cold-pass items

Should-fix: p. 4 / p. 6 the 635-of-1,270 literal-pipeline check described inconsistently
(text vs Table 2) and in tension with "all 1,280,000 datasets it generates".
Polish: "three simulation headlines" (p. 1); post-hoc E4 cell choice not on p. 1;
"therefore" (p. 2); h = 0 statement count wording (p. 8); sign of standardized bias in
6.4 (p. 14); percent vs proportion Bradley range (p. 12); Appendix C front-matter row
(p. 24).
