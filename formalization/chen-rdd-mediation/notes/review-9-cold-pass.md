# Review 9: cold pass (rendered PDF only)

Reviewer: independent cold-reader agent (fresh context, review 9).
PDF: paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf,
sha256 c0880066912c30e5eccf38528a82d7551b2beb11fd11496f012d603ba8cc6ad4, 22 pages, letter.
Inputs read in this phase: the PDF (all 22 pages rendered at 90 dpi, page 1 also at 150 dpi;
pdftotext -layout for detail), editorial-review.md, first-page-contract.md, manuscript.md.
Nothing else was opened before this file was written.

## abstract_verdict_first (p. 1, Abstract) -- provisional PASS

- Sentence 1 opens with the verdict and the source: "We did not replicate three of the four
  simulation headline findings of Chen (2021), who reported that mediation analysis in a sharp
  regression discontinuity design gives biased natural direct effects, percentile bootstrap
  confidence intervals that cover the true value far less often than the nominal level, and
  near-zero power for the mediated interaction: ..." followed by the published-versus-ours numbers
  for each (0.00% vs 85.42%; 0.04 vs 43.62 points; 0.33 vs 47.07 points; 0.836 vs "near zero").
  Verdict, source identity, original finding and numbers are all in one sentence.
- Sentence 2 is the evidence limit: "We could not establish why her results differ, as the step
  comparing her estimates with population values is unprinted and her result files are
  unavailable; her Head Start comparison is not established (no data)." Correct order.
- The fourth headline (minimum n = 5,000) comes last, with Chen's qualifier "tentative" kept:
  "Her tentative minimum n of 5,000 was partly replicated: 86.3% ... 89.2% ... but effects with both
  paths zero stay conservative."
- Weaknesses: sentence 1 is about 110 words with four embedded comparisons; dense but parseable.
  Sentence 3 ("Her abstract puts Type I error and power within the robustness criteria, against her
  near-zero mediated-interaction power; 29 of the 46 statements we tested from her text agree.")
  is compressed: a first-time reader does not know what the 46 statements are or that the first
  clause flags an internal inconsistency in Chen. Symbols a, h are undefined in the abstract.
- The reason in sentence 2 (population-value step) does not apply to H3 (rejection rates do not
  use population values, as p. 6 later says); "her result files are unavailable" covers it, but the
  sentence reads as if the population-value step explains all differences. Polish.

## introduction_verdict_first (p. 2, Section 1, paragraph 1) -- provisional PASS

- Opens with the same verdict sentence, expanded: "in all 3,840 of 3,840 condition-cutoff cells
  (each of 1,280 simulated conditions analyzed at each of three cutoffs)", and quotes Chen
  "All power for MINT is near zero" (printed p. 121).
- Next sentence is the limit ("We could not establish why ... because the step that compared her
  estimates with the population (true) values is not printed and her result files are not
  available"), then RQ2 blocked, then direction: "No headline effect reversed its sign: ... about
  140 times (imbalance) and over 1,000 times (shortfall) smaller". Order matches the standard.
- Tolerance restated at end of paragraph: "half a unit in Chen's last printed decimal, carried
  through the averages ... (0.005, 0.005 and 0.01 percentage points); it is a rounding bound, not a
  sampling band, and the magnitude labels are descriptive point-estimate comparisons, not
  equivalence tests."
- To check in Phase 2: "over 1,000 times (shortfall)" rests on a rounded 0.04 (43.62/0.04 = 1090;
  depends on the unrounded value). "39 would hold if, in our results, the treatment-by-mediator
  interaction h were set to 0" is clearly flagged as "a reading of our results, not a test of her
  runs".

## standalone_prose (whole PDF) -- provisional PASS with polish items

- Terms are defined at first use: PNIE/TNIE/PNDE/TNDE/MINT (Table 1 caption p. 1; Section 3.1
  p. 3), condition-cutoff cell (Table 1 caption; p. 2), both-zero products (Table 1 caption),
  "Slack" and "If h = 0" (Table 7 caption p. 9), "Cell sets" (Table 7 caption), numerical/scope
  labels (Section 6 p. 12), evidence-packet.json (Appendix C p. 20).
- No "parent", "executor", "the manifest", "recorded below" or drafting narrative found. Process
  details that appear are interpretively relevant (two computers, R unavailable, MINT contrast
  cell chosen after results, p. 6 and p. 14).
- File names appear as monospace link labels with extensions (chen_sim.py, aggregate.py,
  statement_checks.csv, fallback.json, run-record.md). "handoff/SNAPSHOTS.md" (p. 19) is a path
  name, acceptable.
- Typographic polish on page 1 Table 1: ASCII ">=" ("at least .97 for ah >= .13"), ASCII prime
  "c'" in the H3 estimand, hyphen-minus in "[-.10, .10]" and "12.50-18.75%" while the body uses
  true minus signs and en dashes; variables in roman in the table but italic in the body.
- Abstract sentence 3 (see above) is the least self-explanatory sentence on page 1.

## scientific_process_distinction (pp. 2-3, Section 2; throughout) -- provisional PASS

- Section 2 (pp. 2-3) separates Chen's contribution (model, estimators eq. 3.5-3.11, design Table
  3.1, Appendices A-B code, every published number with table and page) from ours (independent
  re-implementation, full run, comparison), and says E1-E3 published values and the Tables 4.6-4.7
  recomputations are "our calculation from her printed figures". Table 9 marks those with a dagger;
  Table 1 caption says "E1-E3 published effects are our averages of her rows".
- Assumptions (Section 7, pp. 13-14) are separated from Chen's stated choices; 7.5 discloses that
  the H3 contrast cell was chosen after results were available.
- Causes: Section 4.1 p. 4-5 reasons that her DGP makes the fitted models correctly specified
  (a logical deduction from her printed code, presented as such); Section 5.1 calls the zero-estimate
  pattern "a consistency observation ... not a diagnosis"; Section 10 ranks candidates and says
  "None is established". Limit 7 (p. 15) and Section 10.2 keep the h = 0 reading as "not tested
  against her runs". No cause is presented as established on a cold read.
- To check in Phase 2: claims about how the run was done (two computers, 13.7 core-hours, versions,
  rerun of two conditions differing by 1.1e-16, "checked by reading the cited passages") need
  committed records.

## Headline clarity and page-1 legibility (first impression)

- Page 1 holds title, date, abstract and Table 1 (five rows, nine columns) with the caption; it
  fits on one page without overflow. Table text is small (~8-9 pt) but legible at 150 dpi; at
  90 dpi it is tight. Column headings "Published / Ours / Published effect / Our effect / Effect
  magnitude / Direction / Verdict" are clear.
- Tolerance and units are stated per row in the caption (E1 0.005, E2 0.005, E3 0.01 percentage
  points; E4 not established; E5 not applicable), plus "Descriptive point estimates; not
  equivalence." restricted to E1-E4. Direction is a separate column (zero vs nonzero / same
  direction / not established). Monte Carlo errors are given (0.7 points, 0.006).
- E2 and E3 share identical Published/Ours finding cells; acceptable since both summarize Table 4.9,
  but the E3 cells do not mention the imbalance numbers specifically (they say "true value usually
  above the CI" / "misses on both sides at similar rates", which does describe it).
- E4: Published effect "not established", Our effect 0.836, magnitude and direction "not
  established", verdict "no match". Coherent with a verbal source statement.
- E5: all four comparison cells "not established", verdict "partial", with an applicability
  sentence in the estimand cell.
- Possible confusion: "three of the four simulation headline findings" - the reader must infer that
  the fourth (n = 5,000) is the partly replicated one until the last abstract sentence.

## Other things a first-time reader would question (to check in Phase 2)

- p. 5: "which she calls the chief conclusion of her study" - needs source support.
- p. 8: quote "adding c' and h" (printed p. 104).
- p. 11-14: "All 24 differences match as RCT minus RDD", while Section 8.2 (p. 14) example uses
  (1.301 - 2.066)/0.733 = -1.044 and calls the SB numerator "RDD-minus-RCT"; sign conventions should
  be checked against Tables 4.6-4.7.
- p. 3-4: "two conditions computed on one and rerun on the other differed by at most 1.1e-16";
  "13.7 core-hours"; computer counts 401 + 879 = 1,280.
- p. 20 ledger: "checked by reading the cited passages" is a process claim.

## Phase 2 addendum (written after opening the packet, manifest, results and source; cold-pass text above unchanged)

- The cold-pass questions were all resolved in the paper's favour: "chief conclusion" is Chen's own
  phrase (printed p. 151); "adding c' and h" is verbatim (printed p. 104); Tables 4.6-4.7 print the
  difference as RCT minus RDD and SB with numerator RDD minus RCT, so p. 11 and p. 14 are consistent;
  401 + 879 conditions, 13.7 core-hours and the 1.1e-16 cross-host check are in notes/run-record.md.
- "Over 1,000 times (shortfall)" holds on the unrounded value (43.62 / 0.0358 = 1,218); imbalance
  ratio 47.07 / 0.326 = 144 ("about 140").
- New polish items: Chen's Figure 4.28 (PDF p. 136) does plot MINT power (near .05), so "Chen gives no
  number for the cell" (p. 6) and "the source states a verbal result" (p. 1, E4) should say she prints
  no numeric value and the figure was not digitized; the Table 1 caption's "about 0.7 percentage
  points per cell for ... rejection (E2-E4)" understates the per-cell SE at a rejection rate of .84
  (about 1.2 points). Neither changes a verdict. My provisional passes stand.
