# Review 20: cold pass (rendered PDF and criteria only)

Reviewer: independent cold-reader agent, fresh context. Written before opening the
evidence packet, writer manifest, DISAGREEMENTS.yaml, any artifact, source, earlier
review or git history. All 24 pages were rendered with `pdftoppm -r 80` and viewed;
quotes are from `pdftotext -layout`.

## Overall impression

The paper reads as a complete, standalone replication note. The verdict comes first
in both the abstract and the introduction, the four headlines are each given with
published-versus-ours numbers, the blocked Head Start part is clearly called blocked
and not a nonreplication, and the post-hoc choice of the E4 cell is disclosed on
page 1 and in Section 4.3. No commit hash or working-branch name appears anywhere;
the only branch named is `master` (Appendix A, ledger row "Code and data links point
at master"). Layout is clean: no overfull tables, captions above tables, readable
row spacing, links visibly coloured. No blocking problem found on a cold read.

## Page-specific judgments

### Page 1, abstract
- Sentence 1: "We did not replicate three of the four simulation headlines of Chen (2021),
  who reported biased direct-effect estimates, percentile bootstrap intervals that cover the
  true value far too rarely, and power for the mediated interaction (MINT) near zero."
  Verdict first, source identified and cited, original findings stated. Pass.
- Sentences 2-3 give the published-versus-ours numbers for H1 (85.42% vs 0.00%), H2
  (43.62 vs 0.04 points) and H3 (0.013 vs 0.802 above .05, raw 0.063 vs 0.852). Clear.
- H4 is stated as "holds in part" with 86.3% / 89.2% and the both-zero exception. Clear.
- The limit (Head Start needs restricted-use data) follows immediately, with the S9 partial
  result "10 of 15". Good ordering. The manuscript reference prefers the limit as sentence
  2; here it is sentence 5, after the four headline components. Acceptable for a
  four-part composite headline (polish at most).
- E3 (above minus below, 47.07 vs 0.33) is not in the abstract prose; it is on Table 1.
  Acceptable.
- Standalone: "Bradley's Type I range" is used without definition on page 1 (defined on
  page 4). Polish.
- "Her coverage matches a comparison with population values wrong for treated cases" is
  compressed to the point of being cryptic for a first-time reader. Polish.
- Tolerances: "Table 1 gives the tolerances (her printed rounding or our figure-reading
  error); comparisons are of point estimates, not equivalence." Good.

### Page 1, Table 1
- Columns: Effect and estimand | Published | Ours | Published effect | Our effect | Effect
  magnitude | Direction | Verdict. Separates findings, signed effects and comparison. Good.
- Cells look internally consistent with the abstract: E1 85.42/0.00 smaller, zero vs nonzero;
  E2 43.62/0.04 smaller, same; E3 47.07/0.33 smaller, same; E4 0.013/0.802 larger, same;
  E5 not established x4, partial.
- E5 Published "Tentative minimum n of 5,000 for accurate Type I error and power above .80";
  Ours gives the 86.3%/89.2% shares and the both-zero exception. Not a placeholder. Good.
- Caption states "Descriptive point estimates; not equivalence.", each tolerance and its
  basis, positive meaning, the E4 hidden cutoff-1 series and "cell chosen after the results
  were seen". Thorough. The caption is dense (polish), but readable at print size.
- PNDE/TNDE are not expanded on page 1 (polish; expanded on page 2/3).
- Magnitude labels with ours 0.04 and 0.33 vs tolerance 0.005/0.01 are "smaller" with
  "same" direction: arithmetically right per the stated rule.

### Page 2, Introduction
- Opens with the same verdict and numbers; then MC standard errors (.007, .002), H4,
  limits (Head Start, unseeded bootstrap), "No estimate reverses its sign", tolerances.
  Verdict-first: pass.
- The first paragraph is very long (about 20 lines) and dense with numbers. Polish:
  split after the H4 sentence.
- "about three orders of magnitude smaller than hers and our imbalance (0.33 against 47.07)
  about two": 43.62/0.04 ≈ 1,090 and 47.07/0.33 ≈ 143; consistent.
- Research questions come after the verdict. Good.

### Page 3, Sections 2-3.2
- Contribution section clearly separates hers / ours. Good.
- Model equation and the cutoff-index convention ("Cutoff index 1 ... 75% treated") are
  explicit. Good.

### Page 4, Section 3.3
- Exact replay is carefully limited: "The replay therefore reproduces her printed pipeline,
  not her published runs." Not overstated. Good.
- The literal check is honestly described (635 of 1,270 rebuilt by design). Good.
- "How the engines were chosen" narrates that Python was chosen "without first asking the
  owner of this replication project". This is a consequential software departure, so some
  account belongs here, but the who-asked-whom narrative is process detail. Polish.
- Issue links #92 and #118 are issue-tracker links (allowed).

### Page 5, Sections 3.4-4.1
- Reading errors stated (.0021 vector; up to ~.02 / median .03, up to .05 raster);
  occluded points excluded. Good. Digitizer library versions not recorded: disclosed.
- 4.1 opens with question and answer ("No."). Good.

### Page 6, Table 2 and 4.2
- Table 2 comparability record readable; "evidently lack h ... (inferred, Section 6.1)" is
  properly hedged.
- 4.2 heading "close to nominal coverage" is qualified immediately ("describes the row
  means"; 80.1% MINT cells in Bradley's range). Good, not overstated.

### Page 7, 4.3-4.5
- E4 derivation spelled out (.0683, .0571, mean .0627; 0.0127; tolerance 0.0091 rounded
  down; post-hoc cell choice). Good.
- 4.3: "0.9735 or more for ah >= .13 from n = 1,000" vs Table 1 "at least .97": consistent.
- 4.4 "Mostly" and "H4 is therefore partly replicated". Consistent with Table 1.

### Page 8, 4.6-4.8
- 4.6: "statement 10 sits within one standard error of the .025 threshold"; Section 6.5
  (page 14) says "1.0 from .025" and "1 standard error from .025". "Within one" vs "1.0"
  is borderline wording. Polish.
- 4.8: Blocked S4/S6 are "not established, and not a failure to replicate". Good.

### Page 9, 4.8-4.9, Section 5
- S9 partly replicated "from printed numbers only". Good.
- S8 "announced, never reported ... nothing blocks it". Clear.

### Page 10, Table 3
- Readable. H3 row shows 0.0127 (4 decimals) vs Table 1 0.013 (3 decimals); explained by
  display precision, no conflict.
- S5 "match ... limited" while 4.8 says "replicated at the printed precision": consistent.

### Pages 11-17, Section 6
- Each disagreement has her result, ours, competing explanations including our own error
  tested first, verdicts and a confidence-graded conclusion. Count: 6.1, 6.4-6.10 explained
  (8), 6.2 and 6.3 partly (2): matches abstract "eight are explained and two partly".
- 6.1 conclusion is properly hedged as an inference.
- 6.7 handles the post-hoc selection of the TNDE cell honestly.

### Pages 17-20, Sections 7-12
- Assumptions, ambiguities, unresolved items, limitations all present and specific.
- Availability ledger dated 2026-11-08, consistent with Section 11 prose.

### Pages 20-24, References and appendices
- References readable; R cited twice (4.0.3 and 4.1.3) intentionally.
- Appendix A: files are links, commands given; "on the master branch, where every link
  points". No commit or working branch named.
- Appendix B ledger includes the departures with justifications.
- Appendix C claim inventory consistent with body statuses.

## Commit / branch references
None seen in the rendered PDF. Only `master` is named.

## Severity summary
- Blocking: none.
- Should-fix: none on the cold pass.
- Polish: (1) p1 define "Bradley's range" and PNDE/TNDE or avoid on page 1; (2) p1 clarify
  "population values wrong for treated cases"; (3) p2 split the long first introduction
  paragraph; (4) p4 trim the process narration about asking the owner; (5) p8 vs p14
  "within one standard error" vs "1.0 standard error" wording.
