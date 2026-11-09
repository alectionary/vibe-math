# Review 6: cold pass (rendered PDF only)

PDF: paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf
(sha256 2556420d9b980b4e693af3109c6da5443affd649588c053c0a4de387dcdb528a, 22 pages).
Read all 22 pages from pdftotext -layout and viewed rendered PNGs at 90 dpi of pages 1, 2, 9, 11, 12, 18.
Criteria: editorial-review.md, first-page-contract.md, manuscript.md. No other study file opened.

## abstract_verdict_first (page 1, abstract)

Opening sentence: "We did not replicate three of the four simulation headline findings of Chen (2021), who reported that
mediation analysis in a sharp regression discontinuity design gives biased natural direct effects, percentile bootstrap
confidence intervals that cover the true value far less often than the nominal level, and near-zero power for the mediated
interaction: in all 3,840 condition-cutoff cells, 0.00% ... against 85.42% ...; coverage fell 0.04 rather than 43.62 ...;
the truth lay above the interval 0.33 rather than 47.07 points more often ...; and mediated-interaction power at n = 500 ...
was 0.836 where she reported near zero."

Judgment: pass. Verdict first, source cited with a citation, the three failed headline findings named, and paired
published-vs-ours numbers for each. Second sentence is the evidence limit (cause not established; HSIS blocked).
The fourth headline (minimum n of 5,000) is given its own "partly replicated" verdict with counts in the last sentence.
Reservations (polish): the opening sentence is very long (one colon-joined list of four contrasts); "85.42% in our average
of her Table 4.8 rows" is correctly labeled as our calculation. "29 of her 44 tested Type I and power statements agree"
does not say "with our run" and "her ... tested" reads as if she tested them; minor. The abstract does not itself state
the rounding tolerance, but the Table 1 caption on page 1 does.

## introduction_verdict_first (page 2, Section 1, paragraph 1)

Opens with the same verdict sentence, adds "3,840 of 3,840 condition-cutoff cells" (exact N of M), then the limit
("We could not establish why ... because the step that compared her estimates with the population (true) values is not
printed and her result files are not available"), then the direction statement ("No headline effect reversed its sign ...
about 140 times (imbalance) and over 1,000 times (shortfall) smaller"), then the tolerance ("half a unit in Chen's last
printed decimal ... 0.005, 0.005 and 0.01 percentage points; it is a rounding bound, not a sampling band").
Judgment: pass. Order matches the writing standard. Confusing for a first-time reader: "and 39 would hold if our cells are
read with h replaced by 0, a reading of our results rather than a test of her runs" (page 2, lines 23-25 of the paragraph)
is unexplained at that point and hints at a cause in the opening paragraph; it is only made intelligible in Section 5.2
(page 8). Suggest moving it out of the opening or explaining it in a clause.

## standalone_prose

- Terms defined: RDD, CI, HSIS, PNIE/TNIE/PNDE/TNDE/MINT (Table 1 caption p.1, Section 3.1 p.3), condition-cutoff cell,
  both-zero products (caption p.1). "Slack" and "If h = 0" defined in Table 7 caption (p.9).
- File names used as evidence pointers (statement_checks.csv, summary.json, cells.csv, run-record.md, fallback.json) are
  real filenames with extensions; acceptable under the standard.
- No "the manifest", "recorded below", internal roles, or process chatter seen. Appendix C (p.20) explains what
  evidence-packet.json is.
- Page 1 Table 1 E5 row text: "H4, E5. qualitative sample-size recommendation over the grid. A qualitative design
  recommendation over the whole grid; no single signed contrast..." reads as machine-filled (lowercase start, repetition).
  Polish, not a failure.
- Page 1 Table 1 E4 row: "The source states a verbal result; a scalar contrast exists but no defensible margin." -
  understandable.
- Section 10.2 (p.16) "Smaller h estimates or wider h intervals rank first" is clearly hedged ("None is established").
Judgment: pass with polish items.

## scientific_process_distinction

Section 2 (pp.2-3) separates Chen's contribution (model, design, tables, code) from ours (re-implementation, run,
comparison) and labels derived contrasts E1-E3 and Table 4.6-4.7 recomputations as our calculation from printed figures.
Table captions (Tables 3, 4, 9) separate "Chen" from "ours". Section 7 lists assumptions; Section 7.5 discloses that the H3
contrast cell was "chosen after our full results were available" (p.6 and p.14). Statements about how the analysis was
run (R not installable on either computer, two computers with versions, 13.7 core-hours, 1.1e-16 cross-machine
agreement; pp.3-4) need file support in Phase 2.
Judgment: pass provisionally, subject to Phase 2 verification of the execution claims.

## Headline clarity and page-1 legibility (first impression)

- Page 1 holds title, date, abstract and the full Table 1 with caption; legible at 90 dpi, though the table uses a small
  font and nine columns; "not established" wraps in narrow numeric columns (E4, E5 rows). Effect magnitude and Direction
  columns are present; caption states tolerances and units for each row and "Descriptive point estimates; not
  equivalence." and that this applies to E1-E4 only.
- Table 1 Published/Ours cells give findings, not generic verdicts: e.g. E1 Published "PNDE and TNDE within [-.10, .10]
  in only 12.50-18.75% of conditions, with negative bias"; Ours "PNDE and TNDE within [-.05, .05] in 100% of conditions;
  largest |bias| 0.016".
- E1 direction "zero vs nonzero" (ours 0.00 against 85.42) is sensible. E2/E3 "same direction"; E4 direction "not
  established" because no published number.
- Unclear on first read: E2 and E3 share identical Published and Ours cell text, so the reader has to infer which part of
  the cell supports the imbalance contrast ("true value usually above the CI"; "misses on both sides at similar rates").
  Acceptable.
- E4 Ours cell "MINT power 0.836 at n = 500 for ah = .20; at least .97 for ah >= .13 from n = 1,000" — fine.
- Possible reader concern: the H3 contrast cell is the one most favorable to showing non-near-zero power and was chosen
  post hoc; this is disclosed (p.6, p.14) and Table 5 gives every cell, so the verdict does not hinge on the choice
  (Chen's "All power for MINT is near zero" is contradicted at many cells).

Items to verify in Phase 2: E1-E3 arithmetic; Table 3/4 copies of Chen's Tables 4.8/4.9; Table 5-7 numbers; all
quotations; abstract-quote "PDF p. 3"; title/adviser metadata; R-unavailability and two-computer claims; 13.7 core-hours;
44/6 statement classification; zero-estimate check numbers; S5 24/24.

## Phase 2 addendum (written after opening the packet and sources; the cold pass above is unchanged)

- The four cold-pass judgments stand. The execution claims flagged above (R not installable on either computer,
  401/879 split, versions, 13.7 core-hours, 1.1e-16 cross-host agreement, scikit-learn 1.9.1 on x86_64, post hoc choice
  of the H3 cell) are all supported by notes/run-record.md, simulation/fallback.json and the packet's H3 multiplicity field.
- Phase 2 found a coverage defect not visible from the PDF alone: Chen's power section contains result-bearing sentences
  that are neither among the 44 tested statements nor among the six listed exclusions (PDF p. 126, TNIE2/TNIE3 "similarity
  in overall patterns to the TNIE1 results"; PDF p. 132, TNDE2/TNDE3 "overall patterns were similar to TNDE1 results"),
  so the paper's sentence-level accounting (Section 5.2, Table 8, Appendix C) is not complete. See editorial-review.json.
- evidence-packet.json records a stale sha256 for REPLICATION-PLAN.yaml (877b...; committed file is aed66...).
