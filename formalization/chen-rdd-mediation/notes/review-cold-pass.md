# Cold-pass review (rendered PDF only)

Reviewer: independent cold-reader agent (fresh context). Read before opening the
.tex source, evidence packet, writer manifest, results or notes.

Input: `paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf`
(sha256 640590a12ecc553c901b242bacf8225ab358a6911dd7c3a8156758daec5e9217), 18 pages,
rendered at 90 dpi (pdftoppm) and extracted with pdftotext -layout. Criteria:
editorial-review.md, first-page-contract.md, manuscript.md.

## abstract_verdict_first (page 1) -- provisional pass, with clarity problems

- p. 1, abstract sentence 1: "We did not replicate the simulation headline findings of
  Chen (2021), who reported that mediation analysis in a sharp regression discontinuity
  design gives biased natural direct effects, percentile bootstrap confidence intervals
  that cover the true value far less often than the nominal level, and near-zero power for
  the mediated interaction: ..." The verdict comes first, names and cites the source, and
  states her three-part finding, followed by published-versus-ours numbers (85.42 vs 0.00;
  43.62 vs 0.04; 47.07 vs 0.33; near zero vs 0.836). Verdict first: yes.
- The sentence is about 95 words and carries four numeric comparisons. It reads, but only
  just.
- "the simulation headline findings": H4 (minimum n of 5,000) is also a simulation
  headline and is "partly replicated" later in the abstract. So "did not replicate the
  simulation headline findings" names only three of the four headline components. A reader
  will reconcile this, but the composite verdict for all four parts is never given in one
  phrase.
- "mediated-interaction power was 0.836 at n = 500": this leaves out the condition. Table 1
  E4 and Section 4.3 show 0.836 only for the largest mediated interaction (a = .59,
  h = .34, ah = .20). At other n = 500 cells in Table 5, power is 0.011-0.719. As written,
  the abstract suggests that 0.836 is the n = 500 power in general, which is misleading.
  The same omission appears on p. 2.
- "her 85.42%": this is a derived average (our calculation from her Table 4.8), not a
  figure she printed. The Table 1 caption says so, but the abstract attributes it to her.
- Sentence 2 gives the evidence limit: "We could not establish why her results differ, as
  her matching of estimates to population values is not printed". "Matching of estimates
  to population values" is unexplained to a first-time reader.
- "over 3,840 of 3,840 condition-cutoff cells" is an awkward and unclear construction.
- "products with both paths zero stay conservative": "products" and "conservative" (Type I
  error below nominal) are not defined. The 86.3% Type I share at n = 5,000, half of the H4
  claim, is absent from the abstract.

## introduction_verdict_first (page 2) -- provisional pass

- p. 2, Section 1 paragraph 1 repeats the verdict-first sentence with source locators
  ("(Table 4.8)", "(Table 4.9)", and the quotation "All power for MINT is near zero" (printed
  p. 121)). Then it gives the evidence limit, then "No headline effect reversed its sign",
  then the H4 partial verdict, then the tolerance ("half a unit in Chen's last printed
  decimal ... a rounding bound, not a sampling band ... not equivalence tests"). This
  follows the required order.
- It has the same unconditioned "0.836 at n = 500" as the abstract.
- "the step that matched her estimates to population values" is clearer than the abstract
  wording but still vague.
- The research questions come after the verdict (p. 2, paragraph 2). Good.

## standalone_prose -- provisional fail

- p. 1, Table 1: PNDE, TNDE and MINT are used without definition on page 1. They are
  defined only on p. 3, Section 3.1. "condition-cutoff results" is also undefined.
- p. 1, Table 1 caption: tolerances are printed as "0.00500001", "0.005000025" and
  "0.01000005" percentage points. These look like floating-point artifacts of rounded
  weights; the exact rounding bounds are 0.005, 0.005 and 0.010. A reader cannot tell where
  the trailing digits come from.
- p. 1 caption: "Descriptive point estimates; not equivalence. It applies to rows E1-E4,
  not to E5." The referent of "It" is unclear.
- p. 6, Section 4.4: "n = 5,000 is where most results first pass". Table 6 shows 70.0% of
  Type I results and 53.3% of power results already pass at n = 500 and n = 1,000. The
  sentence is inaccurate as written.
- p. 8 Section 5.2: "Chen's Figures 4.17-4.28 were not digitized". p. 13 Sections 10.4 and
  p. 14 Section 12 instead say "Figures 4.17-4.21". The range is inconsistent.
- p. 8, Table 7: "MINT1", "MINT3" and "TNIE1" (cutoff-indexed labels) are not defined.
- p. 16-17, Appendix B ledger: "in this writing pass", "Template and stage-instruction
  snapshots", "handoff/SNAPSHOTS.md ... at revision 454cc89", "Approved preamble used
  unchanged ... glyphs that do not extract as the evidence text". These narrate the drafting
  pipeline and use internal terms a reader cannot interpret.
- p. 17, Appendix C: "Every claim in the evidence packet" names an internal artifact without
  telling the reader what it is or linking it (Appendix A does list evidence-packet.json).
- p. 3, Section 3.3: the host and container narrative ("Linux x86_64 cloud container (401
  conditions)", "Linux aarch64 virtual machine (879 conditions)") is operational detail,
  but it is relevant to reproducibility and acceptable.

## scientific_process_distinction -- provisional fail

- p. 2, Section 2 separates Chen's contribution (model, design, tables, equations
  3.5-3.11, Appendices A-B) from ours (re-implementation, full run, comparison) and labels
  derived numbers. Good.
- p. 7-8, Section 5.1: "This is a consistency observation about the printed table, not a
  diagnosis of what her code did." Good.
- p. 4, Section 4.1, last sentence: "Her printed estimation code (Appendix B) matches ours
  line by line, so the difference must arise in a step that is not printed (Section 10)."
  This is a diagnosis stated as a certainty. It conflicts with Section 10.1, which calls the
  unprinted step "untested" and only "ranks" it first. It also conflicts with Section 10.2,
  which says her MINT rejection rates (independent of population values) suggest that "her
  h estimates or their CIs differed from what the printed code produces", which is a
  difference in the printed estimation step itself. Overreach.
- p. 4, Section 4.1: "our unbiased results are what that model implies" and Limit 6
  (p. 12) argue that Chen's stated explanation is wrong. This is an analytical observation
  about her printed DGP, which is acceptable if her DGP is as described. Phase 2 must check
  this against Appendix A.
- p. 8, Section 5.2: "Agreement here means her rejection rates for these effects were not
  affected by whatever produced her bias and coverage results." Agreement on a handful of
  verbal statements cannot establish this. It should read "is consistent with".
- p. 12, Section 10.1 (d): "her rejection rates for PNIE, TNIE, PNDE and TNDE agree with
  ours". Only nine verbal statements were checked, not the rates. This overstates.
- p. 6, Section 4.3 and p. 11, Section 7.5: the H3 contrast cell was "chosen in advance".
  Phase 2 must verify this against the plan.

## Headline clarity (first impression)

The verdict is unmistakable: three of Chen's four simulation headlines (biased direct
effects, invalid bootstrap CIs, near-zero MINT power) are not replicated; the n = 5,000
recommendation is partly replicated; RQ2 is blocked. Table 1 is dense. Its estimand
column is long, page 1 does not define the abbreviations, and the non-round tolerances
distract. The single most misleading element is "0.836 at n = 500" without the
a = .59, h = .34 condition in the abstract and introduction.

## Other notes for Phase 2

- Verify the 85.42, 43.62 and 47.07 arithmetic; Chen's table values and pages (Table 4.8
  printed p. 88, Table 4.9 printed p. 124); the quotations on pp. 121, 147, 148, 150 and
  151; the title page metadata (title, December 2021, UNL, advisers Bovaird and Wheeler);
  and whether Chen's DGP omits x from M and Y.
- Check whether the "near zero at every sample size" wording in the Table 1 Published cell
  (H3) is supported by the source.
- The six limits (p. 12) include item 6, which is an argument rather than a limit. Compare
  with the packet.

## Addendum after Phase 2 (the cold-pass text above is unchanged)

The evidence check changed or sharpened these views. Full detail is in
notes/editorial-review.json.

- abstract_source_fidelity: Chen's own abstract (source PDF page 2) concludes that "Type I
  error rate and power for all mediation effects were within or reached the robustness
  criteria, but bias and coverage were more often outside the robustness range." Our
  abstract presents near-zero MINT power as one of her headline findings. That finding is
  supported by her printed pp. 121 and 148, but it contradicts her own abstract. Our
  abstract also omits the Type I and PNIE/TNIE power result, on which our run largely
  agrees (8 of 10 statements). Judged a failure.
- "Chosen in advance" (H3 contrast cell, p. 6 and p. 11): no committed artifact made before
  the full-design results commit (0ed9eae8) names the cell. It first appears in the plan
  update that carries the results, and later in the packet. The claim is unsupported.
- p. 4: the quotation "do not produce valid inferences" is altered. The source (printed
  p. 151) reads "does not produce valid inferences for estimates".
- Table 1 tolerances: the packet explains the trailing digits (weights rounded to 0.166667
  and 0.066667), but the PDF does not.
- Chen's Appendix A confirms that x enters neither M nor Y, so the Section 4.1 and Limit 6
  argument about correct specification is supported. The "must arise in a step that is not
  printed" diagnosis remains an overreach.
- All E1-E3 values recompute exactly (85.4167, 43.6193, 47.0713; ours 0.00, 0.0358, 0.3258).
