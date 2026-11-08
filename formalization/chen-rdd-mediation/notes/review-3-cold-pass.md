# Review 3: cold pass (rendered PDF only)

Reviewer: independent cold-reader agent (fresh context, review 3).
PDF: paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf,
sha256 6d40dca5cb182c7089c91176cfc0313ff873f6b02f2bbc8828bfbbe92e9f5dbd, 19 pages.
Inputs in this pass: the rendered PDF (pages rendered at 90 dpi and read; pdftotext -layout
for detail) and the three criteria files (editorial-review.md, first-page-contract.md,
manuscript.md). No .tex, packet, manifest, results, notes, git history or earlier reviews
were opened.

## abstract_verdict_first (page 1, Abstract) -- judgment: pass

- Sentence 1 opens with the verdict and cites the source: "We did not replicate three of
  the four simulation headline findings of Chen (2021), who reported that mediation analysis
  in a sharp regression discontinuity design gives biased natural direct effects, percentile
  bootstrap confidence intervals that cover the true value far less often than the nominal
  level, and near-zero power for the mediated interaction". It then gives published-versus-ours
  numbers for each component: 0.00% vs 85.42% (|bias| > .10), shortfall 0.04 vs 43.62 points,
  imbalance 0.33 vs 47.07 points, MINT power 0.836 vs "near zero".
- Sentence 2 is the evidence limit: "We could not establish why her results differ, as her step
  comparing estimates with true values is unprinted; her Head Start Impact Study comparison is
  not established, as its data were unavailable." Correct order (verdict, then limit).
- The fourth headline (minimum n = 5,000) is given its own "partly replicated" verdict with
  86.3% / 89.2%. The supporting statements (8 of 10) come after, not before.
- Weakness: sentence 1 is about 110 words with four semicolon-joined components; legible but
  heavy. "condition-cutoff cells" is not defined in the abstract (defined in the Table 1 caption
  and Section 1). "our average of her Table 4.8 rows" is clear enough. No reversal of direction
  is claimed, and none is apparent from the numbers (all same sign; E1 is zero vs nonzero).

## introduction_verdict_first (page 2, Section 1, paragraph 1) -- judgment: pass

- Opens with the same verdict sentence, now defining RDD, CIs and "condition-cutoff cells
  (each of 1,280 simulated conditions analyzed at each of three cutoffs)", "3,840 of 3,840".
- Then the limit ("We could not establish why her printed bias, coverage and
  mediated-interaction results differ ... because the step that compared her estimates with the
  population (true) values is not printed and her result files are not available"), then RQ2
  blocked, then "No headline effect reversed its sign", then tolerance: "half a unit in Chen's
  last printed decimal ... (0.005, 0.005 and 0.01 percentage points); it is a rounding bound, not
  a sampling band". Good.
- Adds MINT range for smaller interactions (0.011-0.719), which helps.
- Weakness: one paragraph of ~420 words; dense. Quotes of Chen's abstract (PDF p. 3) and
  printed p. 121 need source checking in Phase 2.

## standalone_prose -- judgment: pass with polish items

- Generally readable without the working conversation; terms are defined at first use
  (PNIE/TNIE/PNDE/TNDE/MINT on p. 1 caption and p. 3; Bradley band p. 3; "truth above CI" p. 3).
- Internal or process-flavoured items a first-time reader may stumble on:
  - p. 3, Section 3.3: "R is not reachable from either host used here (fallback.json; Section
    8.3)", "cloud container (401 conditions)", "virtual machine (879 conditions)". Relevant to
    reproducibility but "host"/"container" is operational vocabulary.
  - p. 12, Section 8.3: "which printed PASS_ESTIMATOR_VALIDATION" -- a program token in
    scientific prose; tolerable as an evidence pointer.
  - p. 17, ledger: "handoff/SNAPSHOTS.md" -- "handoff" is an internal workflow directory name;
    Appendix A (p. 16) lists "SNAPSHOTS.md" only. Minor inconsistency.
  - p. 1 Table 1, Claim/estimand cells of H3 and H4 contain applicability boilerplate ("The
    source states a verbal result; a scalar contrast exists but no defensible margin."; "A
    qualitative design recommendation over the whole grid; no single signed contrast represents
    it, and any pooled share would depend on the mix of effect sizes in the grid."). Readable,
    but awkward as part of a claim label.
- No vague destinations ("see the manifest"); file references are named files.

## scientific_process_distinction -- judgment: pass

- p. 2-3 Section 2 cleanly separates Chen's contribution (model, design, tables, code of
  Appendices A-B) from ours (re-implementation, full run, comparison), and labels derived
  numbers (E1-E3, recomputed Tables 4.6-4.7 differences) as "our calculation from her printed
  figures"; Table 8 uses a dagger for these. "We wrote no proofs".
- p. 7 and p. 11 (Sections 4.3, 7.5) disclose that the H3 contrast cell was "chosen after our
  full results were available" -- honest about post hoc selection, and Table 5 shows every cell.
- p. 8 Section 5.1: zero-estimate check is "a consistency observation about the printed table,
  not a diagnosis of what her code did". p. 13 Section 10.1 ranks candidate (e) first "only
  because it is the one candidate not contradicted by the evidence; it is untested, not
  established". Good.
- Watch items for Phase 2 (possible overreach):
  - p. 4 Section 4.1: "the linear models she fits are correctly specified and OLS has no source
    of bias; our unbiased results are what that model implies. Her printed estimation code
    (Appendix B) implements the same estimator as ours" -- needs source check of Appendices A-B.
  - p. 13 Section 10.1(d): engine difference "not supported, because ... checked Type I error and
    power statements ... agree" -- reasoning, not a test; labelled "not supported", acceptable.
  - p. 13 Section 10.2: "Smaller h estimates or wider h intervals rank first" -- labelled untested.
  - p. 3: "two conditions computed on one host and rerun on the other differed by at most
    1.1e-16" and "13.7 core-hours" -- verify against run-record.md.

## Headline clarity and page-1 legibility (first impression)

- Headline is clear: three of four simulation headlines not replicated, one partly replicated,
  RQ2 blocked. Table 1 immediately follows the abstract, before the introduction, with Claim /
  Published / Ours / Published effect / Our effect / Effect magnitude / Direction / Verdict
  columns. Directions: E1 "zero vs nonzero", E2-E3 "same direction", E4-E5 "not established".
- Tolerance and direction on page 1: caption gives tolerances (0.005, 0.005, 0.01 percentage
  points; E4 not established; E5 not applicable), units, MC error (~0.7 points per cell), and
  "Descriptive point estimates; not equivalence. This applies to the magnitude labels of rows
  E1-E4; E5 is qualitative." Good.
- E2 and E3 rows repeat identical Published/Ours finding text (coverage), which is fine since
  both belong to H2, though the E3 Ours cell could mention the 2.5-2.9 vs 1.8-2.7 split.
- Legibility: at 90 dpi the 8-column table is dense, 8-pt-ish type, narrow columns causing many
  line breaks (e.g. "zero vs / nonzero", "not / established"). Readable at normal zoom; no
  overflow or clipping observed. Caption is long (7 lines, small type).
- Quick arithmetic from printed numbers on p. 5-6: E1 = 100 - mean(12.50,12.50,18.75,12.50,
  12.50,18.75) = 85.42 OK; E2 = 95 - 770.71/15 = 43.62 OK; 11.14 = 95.13 - 83.99 OK; 1,176 +
  2,664 = 3,840 per n OK; 5,880 = 5 x 1,176 OK; 19,200 = 3,840 x 5 OK.

## Things a first-time reader might find confusing

- p. 1: "8 of our 10 checked Type I and power statements" -- the 10 include the H3 headline
  statement itself (Table 7, p. 9), so "8 of 10" partly double counts H3; explained only on p. 8.
- p. 1/p. 7: H3 Ours cell says "ah = .20" while Table 5 heads the column ".2006"; fine.
- p. 8 Section 5.2: "at h = .15 from n = 2,500 (.026-.033 at n = 1,000)" -- parenthetical is hard
  to parse.
- p. 7 Section 4.4: "so the shares depend little on cutoff" repeats the preceding clause.

## Phase 2 addendum (written after opening the packet, manifest, results and source)

The cold-pass judgments above stand. Phase 2 confirmed every page-1 number, the E1-E3
recomputation from Chen's printed Tables 4.8 and 4.9, all Chen quotations at their cited pages,
and the bibliographic identity. One view changed: the cold pass accepted "All three PNIE and TNIE
power statements agree" (p. 8) and "her indirect-effect power statements replicate" at face value.
Chen's printed p. 112 (PDF p. 126), in the same paragraph as the checked TNIE1 statement, also says
"when b = 0, power was close to zero across all levels of a" (Figure 4.23, h = .15). That statement
is checkable from the text, was not checked, and our cells.csv contradicts it (TNIE power at b = 0,
h = .15: a = .39 gives .43 at n = 500 and 1.00 from n = 5,000; a = .59 gives .47 and 1.00). The
general wording on pp. 2, 8, 10, 13 and 18 therefore overreaches; see notes/editorial-review.json.
