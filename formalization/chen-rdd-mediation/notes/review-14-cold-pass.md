# Review 14: cold pass (rendered PDF and review criteria only)

Reviewer: independent cold-reader agent, fresh context. Read before opening the
evidence packet, writer manifest, DISAGREEMENTS.yaml, artifacts, earlier notes
or the source. Inputs: `editorial-review.md`, `first-page-contract.md`, and
`paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf`
(24 pages, all rendered with `pdftoppm -r 80` and inspected; text quoted from
`pdftotext -layout`).

## Overall reader judgment

A careful, verdict-first paper. The abstract and introduction each open with the
composite verdict (three simulation headlines not replicated, H4 partly, RQ2
blocked, S9 partly from printed numbers) and name the evidence behind it. The
exact R replay is described carefully as reproducing her *printed* pipeline, not
her published runs. No blocking problem is visible on the face of the PDF. The
issues below are should-fix or polish; none makes a number or label wrong on its
face.

## Page-specific findings

### Page 1, abstract
- Sentence 1: "We did not replicate the three simulation headlines of Chen (2021),
  who reported biased direct-effect estimates, percentile bootstrap intervals that
  cover the true value far too rarely, and power for the mediated interaction (MINT)
  near zero". Verdict first, source cited, original finding stated, each component
  given a signed number. Pass.
- "Her tentative minimum of 5,000 cases ... holds only in part" keeps Chen's own
  "tentative" qualifier and states the failing cells (both-zero products). Good.
- "Her Head Start estimates need restricted-use data and could not be rerun; from her
  printed numbers, her arithmetic recomputes and her claim of opposite significance
  conclusions holds in 10 of 15 comparisons." Blocked part is not called a
  nonreplication. Good.
- "her MINT rejection rate exceeds the nominal .05 by 0.013 ..., about one reading
  error, against 0.786". Honest, but a reader may ask why a value "about one reading
  error" from zero is labelled "same" direction in Table 1. The table caption answers
  (0.0127 vs tolerance 0.0123, near-tie, tolerance set after results). Polish: the
  abstract could say "a near-tie with the reading error" so it is not read as zero.
- Second paragraph is dense ("population values wrong for treated cases, a rule that
  reproduces her coverage at every cutoff but not her bias at the third"). Readable
  but heavy. Polish.
- Tolerances and "point-estimate comparisons, not equivalence" stated. Good.

### Page 1, Table 1
- Legible at 80 dpi; five rows; Published, Ours, Published effect, Our effect,
  Effect magnitude, Direction, Verdict columns. Row regions do not overlap.
- E1: published cell "within [-.10, .10] in only 12.50-18.75% of conditions, with
  negative bias"; effect 85.42 (consistent with 100 minus a value in 12.50-18.75).
  Ours 0.00 with "largest |bias| 0.016". "smaller", "zero vs nonzero" correct on face.
- E2 and E3 share an identical Published cell and an identical Ours cell. The E3
  cells do not state the imbalance itself (no above/below shares appear in either
  cell). Should-fix (non-failing): give E3 its own cells, e.g. "true value above the
  CI far more often than below" / "above 2.5-2.9%, below 1.8-2.7%".
- E4: 0.013 vs 0.786, "larger", "same". Caption discloses that 0.0127 exceeds the
  post hoc tolerance 0.0123 by 0.0004 and that one of three points is partly hidden.
  The direction label is fragile but disclosed; acceptable under the contract
  (measurement tolerance rounded down).
- E5: nonscalar, "not established" in all four comparison cells, verdict "partial";
  Published/Ours cells carry the actual finding. Good. "not estab-lished" is
  hyphenated across lines in the narrow columns. Polish.
- Caption: contains "Descriptive point estimates; not equivalence.", estimands,
  units, positive meanings, each tolerance and its basis, MC SE. Correct-looking but
  very long (10 lines). Polish.

### Page 2, Introduction
- Opens: "We did not replicate the simulation headlines of Chen (2021): her finding
  that the natural direct effects are biased (85.42% ... 0.00% in ours) ...".
  Verdict first, independently of the abstract. Limits immediately follow ("The limit
  of our evidence is that her Head Start analysis ... could not be rerun ... and that
  her interval-based results cannot be reproduced draw for draw"). Pass.
- "Our coverage shortfall (0.04 points against her 43.62) is about three orders of
  magnitude smaller than hers and our imbalance (0.33 against 47.07) about two" —
  arithmetic checks (1090x, 143x).
- MC SE "about 0.005 points if cells are independent and 0.019 if they are
  correlated": then E3 = 0.33 is ~17-66 SE from zero, i.e. a real (if small)
  imbalance; p.6 says "we did not investigate its cause". Honest; fine.
- Mentions S9 only in the abstract, not in the intro's verdict paragraph. Polish.

### Pages 3-5, Methods
- p.4 Section 3.3: careful statement that the replay "reproduces her printed
  pipeline, not her published runs"; literal-pipeline identity only "on the first
  block". Not overstated.
- p.4 "How the engines were chosen": candidly discloses that Python was first chosen
  without asking the project owner. Good.
- p.5 Section 3.4: digitizing reading errors stated (.002 bias, ~.02 rates);
  PyMuPDF/pandas versions not recorded (disclosed, also in compliance ledger).
- p.5 Table 2 comparability: clear; "evidently lack h ... (inferred, Section 6.1)"
  keeps inference status.

### Pages 6-9, Results
- p.6 4.1: "every PNDE and TNDE result lies within [-.05, .05]; the largest |bias|
  ... is 0.016". Consistent with Table 1.
- p.6 4.2 heading "percentile intervals have close to nominal coverage", but "92.9%
  of the 19,200 results lie in Bradley's [.925, .975]" with lowest 0.916. With a
  binomial SE of ~.007 (stated), 7.1% of cells outside a +/-.025 band is far more
  than chance would give (~0.04%), so some cells genuinely miss Bradley's range; the
  paper does not say which. Should-fix (non-failing): say where the 7.1% sit (e.g.
  small n, product effects) so "close to nominal" is qualified.
- p.6-7 4.3: contrast cell chosen post hoc, disclosed; "Her own summaries are also
  inconsistent" well supported by quotes with page locators.
- p.7 4.4: "Mostly ... we judge it literally" with per-n shares; consistent with
  Table 1 E5 and abstract.
- p.7 4.5 "12.5% (MINT)" vs Table 3 "12.50" — decimals inconsistent. Polish.
- p.7-8 S2/S3 counts: 13/14 of 18, 16/17 of 28, 29/31 of 46, 39 of 46 at h = 0,
  10 of 15, 7 that disagree. Internally consistent (29+10 = 39; 46-31 = 15).
- p.8 4.8: blocked parts "not established, and not a failure to replicate". Good.
  S9 counts 6+4+5 = 15 consistent.
- p.9 Table 3: legible; split across pp. 9-10 with repeated header. Scope column
  "limited (same data at h = 0)" explained in the following paragraph. Good.

### Pages 10-16, Disagreements
- p.10 "Of the ten, eight are explained and two (Sections 6.2 and 6.3) are partly
  explained; none is unexplained." Matches abstract.
- Each section lists theories with "(ours)" first, prediction/test/result/verdict,
  conclusion with confidence. 6.2 and 6.3 clearly say "Partly explained".
- 6.2 lambda values 1.96/1.92/1.76 are consistent with PNIE k = 1.469/.959/.441
  divided by treated shares .75/.5/.25.
- 6.7 arithmetic consistent (.736-.698 = .038; .715-.687 ~ .029; remainder .009).
- 6.7 explanation "about what the most extreme of the 4,685 ... points would show by
  chance" is plausible on its face.

### Pages 17-19, Assumptions, ambiguities, unresolved, limitations
- 7.5 states E4 tolerance was "not set in the plan" and rounded down. Good.
- Section 9 lists open items without overstatement.
- Section 10 limitations 1-7 tied to claim IDs. Good.
- p.19 availability ledger: "The project owner applied for the restricted-use data and
  could not obtain them." This sentence is not backed by a ledger row (no row records
  an application). Check against notes/availability.md in the evidence pass.

### Pages 20-24, References, appendices
- Bibliography: Chen (2021) entry gives title, UNL, December 2021, URL, advisers.
- Appendix A: reproduction table legible; long paths wrap mid-token. Polish.
- Appendix B: compliance ledger honestly marks "departed" items.
- Appendix C: claim inventory H1-H4, S1-S9 with status; consistent with Tables 1, 3.

## Cold-pass summary
- Blocking: none seen on the face of the PDF.
- Should-fix: (1) E3 Published/Ours cells duplicate E2's and do not state the
  imbalance; (2) Section 4.2 does not say where the 7.1% of cells outside Bradley's
  coverage range sit; (3) verify the p.19 "applied ... could not obtain" sentence.
- Polish: abstract near-tie wording for E4; dense abstract paragraph 2; long
  Table 1 caption; hyphenated "not estab-lished"; 12.5 vs 12.50; wrapped paths.
