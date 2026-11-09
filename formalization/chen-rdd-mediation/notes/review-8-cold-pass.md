# Review 8: cold pass (rendered PDF only)

PDF: paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf
SHA-256 1a8439b88674cdb168fc2e413450884b28d71759c3f6bd780680f13c6ac425b7, 22 pages.
Read before any evidence: the rendered pages (pdftoppm -r 90) and pdftotext text,
plus the criteria files editorial-review.md, first-page-contract.md, manuscript.md.
No .tex, packet, manifest, results, notes or earlier reviews were opened.

## abstract_verdict_first (first impression: pass)

- p. 1, abstract sentence 1: "We did not replicate three of the four simulation
  headline findings of Chen (2021), who reported that mediation analysis in a sharp
  regression discontinuity design gives biased natural direct effects, percentile
  bootstrap confidence intervals that cover the true value far less often than the
  nominal level, and near-zero power for the mediated interaction: ..." The verdict
  ("did not replicate three of the four"), the cited source and her finding come
  first, followed by the four published-versus-ours pairs (0.00% vs 85.42%; 0.04 vs
  43.62; 0.33 vs 47.07; 0.836 vs near zero). It is one long sentence but parseable.
- p. 1, abstract sentence 2: the limit ("We could not establish why her results
  differ, as her step comparing estimates with true values and her result files are
  unavailable"), plus RQ2 (Head Start) not established for lack of data. Correct
  order (verdict, then limit). "her step comparing estimates with true values" is a
  little vague for a first-time reader; it is clarified on p. 2 ("the step that
  compared her estimates with the population (true) values is not printed").
- p. 1, abstract: no reversal is claimed in the abstract; the introduction (p. 2)
  states "No headline effect reversed its sign". Fine.
- p. 1, abstract: H4 "partly replicated" with 86.3% / 89.2%; component limitation
  (both-zero products conservative) retained.
- Concern (minor): "85.42% in our average of her Table 4.8 rows" does not say these
  are the six direct-effect rows (stated in Table 1 and p. 2).

## introduction_verdict_first (first impression: pass)

- p. 2, Section 1 paragraph 1 opens with the same verdict sentence, adds the exact
  count "in all 3,840 of 3,840 condition-cutoff cells" and defines the cell, and
  quotes "All power for MINT is near zero" (printed p. 121). Then the limit, then
  "No headline effect reversed its sign" with sizes ("about 140 times ... over 1,000
  times smaller"), then the abstract-conflict and statement counts, H4, and the
  tolerance ("half a unit in Chen's last printed decimal ... 0.005, 0.005 and 0.01
  percentage points ... not a sampling band ... not equivalence tests").
- Concern (polish): paragraph 1 is ~30 lines and very dense; the h = 0 reading (39
  of 46) is placed in the opening paragraph, which is more detail than an opening
  needs.
- p. 2, paragraph 2: research questions come after the verdict, as required.

## standalone_prose (first impression: pass with polish items)

- File names appear as linked names (chen_sim.py, aggregate.py, fallback.json,
  run-record.md, cells.csv, summary.json) on pp. 3-5; acceptable as evidence links.
- p. 8-10, Section 5.2/Table 7: dense but self-contained; "Slack" and "If h = 0"
  defined in the caption (p. 9).
- p. 19-20, Appendix B ledger: mentions "approved-preamble.tex", "handoff/SNAPSHOTS.md",
  "The repository's check_citations.py" and font/microtype details; these are
  process/typesetting details, confined to the ledger appendix, so acceptable but
  slightly internal.
- p. 1 caption: "condition-cutoff cell", "both-zero products", PNIE etc. are defined.
- No "parent", "executor", "the manifest" or "recorded below" phrasing seen.
- p. 6, Section 4.3: "chosen after our full results were available as the most
  direct test of that statement" - honest disclosure of a post hoc choice.

## scientific_process_distinction (first impression: pass)

- p. 2: "We could not establish why ..."; p. 7 (5.1): zero-estimate pattern called
  "a consistency observation about the printed table, not a diagnosis of what her
  code did"; p. 8 (5.2): h = 0 reading "not tests of her runs, and they do not
  establish a cause"; p. 15-16 (10.1, 10.2): candidates ranked, "untested, not
  established", "None is established". Good separation.
- p. 4-5 (4.1): "the linear models she fits are correctly specified and OLS has no
  source of bias" - this is a derivation from her printed model, presented as such,
  not as an established cause of her discrepancy. To check in Phase 2 that
  Appendix A indeed has no x in M or Y.
- p. 3 (3.3): process claims ("R could not be installed on either of the two
  computers", "13.7 core-hours", two machines with counts 401/879, cross-machine
  difference 1.1e-16) - need to be backed by run-record.md / fallback.json.
- p. 16 (10.1): "Candidate (e) ranks first only because it is the one candidate not
  contradicted by the evidence; it is untested, not established." Good.

## Headline clarity and page-1 legibility (first impression)

- p. 1: title, date, abstract and Table 1 fit on one page. Table 1 has columns
  Claim/estimand, Published, Ours, Published effect, Our effect, Effect magnitude,
  Direction, Verdict. Text is small but legible at 90 dpi; the "not established"
  labels wrap to two lines in narrow columns, which is readable.
- Tolerances and units are in the caption ("E1 tolerance 0.005 percentage points;
  ... E4 tolerance not established, units rejection rate; E5 tolerance not
  applicable"), plus "Descriptive point estimates; not equivalence." and the
  clarification that this applies to E1-E4 only.
- Direction labels: E1 "zero vs nonzero", E2/E3 "same direction", E4/E5 "not
  established". E4 published effect is "not established" because she printed no
  number; her verbal "near zero" is in the Published cell.
- Possible confusion: the H3 estimand row is wordy ("The source states a verbal
  result; a scalar contrast exists but no defensible margin.") - the applicability
  text is placed in the claim column; acceptable.
- Caption page list "printed pp. 88, 124, 121, 150" is out of order; polish.
- The caption gives "ours are about 0.7 percentage points per cell" as Monte Carlo
  error; that is the binomial SE of a single cell's coverage, not of the E1 share
  or of the row averages; slightly loose for E1 (a share of conditions).

## Things to verify in Phase 2

- 85.42, 43.62, 47.07 recomputation; 0.00, 0.04, 0.33 from our CSVs.
- 0.836 and Table 5; 86.3/89.2; 1,176/2,664 counts; 92.9%, .916, 94.96%.
- Quotes: "All power for MINT is near zero" (p. 121); "never reached the .80 level"
  (p. 148); abstract quote (PDF p. 3); "When bias was present..." (p. 147);
  "may be an indicator", "plausible explanation" (p. 147); "the current method of
  bootstrapping ..." (p. 151); "a minimum sample size of 5000 ..." (p. 150);
  "collapsed across sample and effect size" (p. 87); "25% control—75% treatment"
  (p. 86); "adding c' and h" (p. 104); "An additional power analysis by standard
  deviation of the outcome" (p. 58); "the standard deviation of the RCT outcome"
  (p. 54).
- Statement 1-46 table vs statement_checks.csv; six exclusions; three restatements.
- Advisers, institution, date on title page.

## Appended after Phase 2 (the cold-pass sections above are unchanged)

Phase 2 confirmed the cold-pass judgments on abstract_verdict_first, introduction_verdict_first,
standalone_prose and scientific_process_distinction. Every quotation listed above was found at its
cited page. The process claims in Section 3.3 are backed by notes/run-record.md and
simulation/fallback.json. Phase 2 found one coverage defect that the cold pass could not see: Chen's
printed p. 112 (PDF p. 126) sentence "Given a = .14 and b = .14, .39, or .59, power increased as sample
size increased." is a result sentence. It is not one of the 46 tested statements, not one of the six
excluded sentences, and not a restatement the paper names. The paper treats the matching TNDE
sentence on p. 118 as an exclusion, so by its own rule there are seven untested sentences, not six.
See notes/editorial-review.json.
