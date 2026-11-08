# Review 2: cold pass (rendered PDF only)

Reviewer: independent cold-reader agent, fresh context (review 2).
PDF: paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf,
sha256 cf5e4acab3d6678115cef5c397e14eaaa7609ebeddb456a121ef0b39c59bb615, 19 pages.
Inputs used in this pass: the PDF (all 19 pages rendered at 90 dpi and viewed for pages
1, 2, 9, 10, 15, 16; full pdftotext -layout of all pages), and the criteria files
editorial-review.md, first-page-contract.md, manuscript.md. No packet, manifest, .tex,
results, notes or prior review was opened before this file was written.

## abstract_verdict_first (p. 1, Abstract)

- Sentence 1 opens: "We did not replicate the simulation headline findings of Chen (2021),
  who reported that mediation analysis in a sharp regression discontinuity design gives
  biased natural direct effects, percentile bootstrap confidence intervals that cover the
  true value far less often than the nominal level, and near-zero power for the mediated
  interaction: ..." followed by three published-versus-ours pairs (0.00% vs 85.42%; 0.04 vs
  43.62; 0.33 vs 47.07) and the MINT power 0.836 vs "near zero". Verdict first, source
  identified and cited, original finding stated, numbers given. Pass.
- Sentence 2 is the limit of evidence: "We could not establish why her results differ,
  because the step that compared her estimates with the true values is not printed; her
  Head Start Impact Study comparison is not established, because its data were
  unavailable." Correct order (limit after verdict).
- No reversal sentence; the introduction states "No headline effect reversed its sign",
  which explains its absence. Fine.
- H4 (5,000 minimum n) is the fourth headline and is "partly replicated" in the last
  sentence. The opening "We did not replicate the simulation headline findings" is a
  composite verdict over four parts of which one is partial; a first-time reader could read
  it as all four failing until the last sentence. Acceptable because the abstract states the
  partial H4 explicitly, but "three of the four" wording would be clearer (polish).
- The abstract is long (one dense 14-line paragraph); "Head Start Impact Study comparison"
  appears without saying it is her second research question (RCT vs RDD). Minor.
- Tolerances are on page 1 in the Table 1 caption (0.005, 0.005, 0.01 percentage points) and
  the direction column is present. Pass.

## introduction_verdict_first (p. 2, Section 1, paragraph 1)

- Opens with the same verdict sentence, now with "all 3,840 of 3,840 condition-cutoff
  cells (each of 1,280 simulated conditions analyzed at each of three cutoffs)" and the
  quotation "All power for MINT is near zero" (printed p. 121). Then the limit ("We could
  not establish why ..."), then the no-reversal statement ("No headline effect reversed its
  sign ... two orders of magnitude smaller"), then her abstract's Type I/power statement and
  the H4 partial verdict, then the tolerance and the "not equivalence tests" note. This is
  the required verdict / limit / reversal ordering. Pass.
- The research questions follow in paragraph 2 ("Chen's dissertation asks three research
  questions (printed p. 7)"), after the verdict, as required.

## standalone_prose

- Mostly reads standalone: terms PNIE/TNIE/PNDE/TNDE/MINT, condition-cutoff cell and
  both-zero products are defined in the Table 1 caption (p. 1) and again in Section 3.1
  (p. 3); RDD, CI, HSIS, RCT defined on p. 2.
- Internal or operational wording a first-time reader would trip over:
  - p. 3, Section 3.3: "R is not reachable from either host used here (fallback.json;
    Section 8.3)"; "hosts" and the allowlist detail in Section 8.3 (p. 12: "neither CRAN,
    conda-forge nor the Ubuntu archives are reachable through the network allowlist") are
    environment chatter; the scientific point (engine departure, validated) is relevant,
    the allowlist detail less so. Polish.
  - p. 15, Appendix A intro: "the packet builder needs pdftotext" - "packet builder" is
    internal shorthand; it is only explained on p. 18 (Appendix C: "evidence file ...
    built by build_packet.py").
  - p. 17, Appendix B ledger: "handoff/SNAPSHOTS.md names the repository file and revision
    from which approved-preamble.tex was copied" and the row "Typesetting template used
    without additions ... departed ... so that apostrophes, vertical bars and ligatures copy
    out of the PDF" narrate how the note was produced (typesetting/production process).
    Not scientific content; polish (it is confined to the compliance appendix).
  - p. 1, Table 1 E3 estimand "(% of CIs lying below the population value) minus (% lying
    above it)" while Table 4 (p. 6) uses "Below CI means the truth lies below the interval":
    the word "below" is used in opposite senses for the same quantity. Arithmetic is
    consistent (E3 = truth-above minus truth-below), but this is confusing.
- No "the manifest", "per README" or vague destinations; README.md references name the
  "Reproduce" section. No author line, no LLM statement. Pass with polish.

## scientific_process_distinction

- Section 2 (pp. 2-3) separates Chen's contribution (model, design, equations 3.5-3.11,
  Table 3.1, Appendices A-B, printed numbers) from ours (re-implementation, run,
  comparison) and labels derived numbers ("E1-E3 ... our calculation from her printed
  figures"); Table 8 marks them with a dagger (p. 10); Table 1 caption says "E1-E3
  published effects are our averages of her rows". Good.
- Causal language about Chen's discrepancy: p. 8 Section 5.1 "This is a consistency
  observation about the printed table, not a diagnosis of what her code did"; p. 13
  Section 10.1 "Candidate (e) ranks first only because it is the one candidate not
  contradicted by the evidence; it is untested, not established." Appropriately hedged.
- Points to verify in phase 2:
  - p. 4 Section 4.1: "In her data-generating model the assignment variable enters neither
    M nor Y (Appendix A, printed pp. 175-177), so the linear models she fits are correctly
    specified and OLS has no source of bias" - a strong statement about her code; must
    match Appendix A. Also limit 6 (p. 12) and candidate (b) (p. 13) rely on it.
  - p. 7 / p. 11: the H3 contrast cell was "chosen after our full results were available".
    Disclosed in the body (Sections 4.3, 7.5) but not on page 1, where E4 is the headline
    row. Since Chen's statement is "All power for MINT is near zero" any cell tests it,
    and Table 5 shows all cells, so this is disclosure polish, not a failure.
  - p. 6 Section 4.2: "is the expected direction for percentile intervals of products of
    coefficients" - uncited theoretical assertion; also PNDE/TNDE rows (not products in the
    same sense) show imbalance near zero or slightly negative (e.g. PNDE1 below 2.69, above
    2.68). Soften or cite.
  - p. 13 Section 10.1(a) "ruled out" a coding error in our estimator - strong but
    supported by the described validation.

## Headline clarity and page-1 legibility (first impression)

- Page 1 holds title, date, abstract and Table 1 (claim/estimand, Published, Ours,
  Published effect, Our effect, Effect magnitude, Direction, Verdict). All four headline
  claims have rows (E1-E5; H2 has two rows). Text is small but legible at 90 dpi; columns
  are narrow and wrap heavily (e.g. "not established" split over two lines) but cells do not
  collide.
- Table 1 caption gives tolerances and units for each row, says "Descriptive point
  estimates; not equivalence." and limits it to E1-E4, notes Chen has no Monte Carlo errors
  and ours are ~0.7 pp per cell. Good.
- E4 row: published effect "not established", ours 0.836, magnitude and direction "not
  established", verdict "no match". The estimand cell explains "The source states a verbal
  result; a scalar contrast exists but no defensible margin." Clear enough. A reader may ask
  why direction is not established when the source says "near zero" (a positive rate) and
  ours is 0.836 - acceptable because no signed published number exists.
- E5 row (H4): "partial" verdict with Ours "86.3% ... 89.2% ... both-zero products stay
  conservative". Clear.
- First impression: headline is clear and supported on its face; the main readability
  issues are the abstract's density and the "below/above" wording in E3.

## Addendum after Phase 2 (evidence check; the cold-pass text above is unchanged)

- The Phase 2 check confirms most cold-pass impressions: Appendix A (printed pp. 175-177) indeed
  has x entering M and Y only through t, so the Section 4.1 "correctly specified" statement is
  supported; the post hoc choice of the H3 cell is disclosed in the packet and body.
- New finding not visible from the PDF alone: the S2 statement "MINT Type I below Bradley and
  close to zero when a = 0, at every h > 0" was checked only at h = .34
  (simulation/statement_checks.py), and results/cells.csv shows our MINT Type I error with a = 0 is
  .002-.036 at h = .05 (all n) and .014-.033 at h = .15 for n <= 1,000, i.e. near zero and below
  Bradley as Chen reported. The paper's "ours are about .05" (p. 8, Section 5.2; p. 13, Section
  10.2) is therefore inaccurate for those cells, and the 10.2 inference built on it needs narrowing.
  This changes claim_coverage to fail (see notes/editorial-review.json).
- Chen's own wording on the bias cause is hedged ("may be an indicator", "plausible explanation",
  printed p. 147); the paper's "Chen attributed" (p. 4) and "Chen attributes" (p. 12, limit 6) are
  slightly stronger than the source. Polish.
