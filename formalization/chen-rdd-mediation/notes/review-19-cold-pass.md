# Review 19: cold pass (rendered PDF and review criteria only)

Reviewer: independent cold-reader agent, fresh context. Read before opening the
evidence packet, writer manifest, DISAGREEMENTS.yaml, results, source or any
other note. Inputs: `paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf`
(24 pages, every page rendered with `pdftoppm -r 80` and inspected; `pdftotext -layout`
used for quotes) and the four criteria files.

Severity: blocking / should-fix / polish. Items marked "verify" are cold-pass
suspicions to be checked against evidence in the evidence pass.

## Page 1: abstract

1. Abstract, sentence 1: "We did not replicate three of the four simulation
   headlines of Chen (2021), who reported biased direct-effect estimates,
   percentile bootstrap intervals that cover the true value far too rarely, and
   power for the mediated interaction (MINT) near zero." Verdict first, source
   cited and identified, original findings named in the same sentence. Pass.
   The fourth headline's verdict ("holds in part") arrives in sentence 4; the
   word "three of the four" signals it. Acceptable.
2. Sentences 2-3 give the signed headline numbers (85.42% vs 0.00%; 43.62 vs
   0.04 points; 0.013 (raw 0.063) vs 0.802 (raw 0.852)). Good: the raw rates are
   kept beside the null-centred contrasts.
3. Limit of evidence (Head Start not rerunnable; bootstrap unseeded) follows the
   numbers, as the manuscript rules require. Pass.
4. Second paragraph: "Her figures instead match results from data without the
   treatment-by-mediator interaction, and her coverage a comparison with
   population values wrong for treated cases; the rule behind her bias is not
   determined; of ten disagreements, eight are explained, two partly." Elliptical
   ("her coverage a comparison") and a three-semicolon chain; hard to parse on
   first read. Polish.
5. "her claim of opposite significance conclusions" (abstract line 10; also
   Section 1). The noun "claim" is close to the disfavoured "the author claims"
   wording; "her conclusion of" would be cleaner. Polish (check cue output).
6. Tolerance and comparison type stated ("Table 1 gives the tolerances (her
   printed rounding or our figure-reading error); comparisons are of point
   estimates, not equivalence."). Pass.

## Page 1: Table 1

7. Columns: Effect and estimand | Published | Ours | Published effect | Our
   effect | Effect magnitude | Direction | Verdict. Readable at 80 dpi; rows are
   separated; no overlap. Pass.
8. E1: Published "PNDE and TNDE within [-.10, .10] in only 12.50-18.75% of
   conditions, with negative bias"; effect 85.42. Consistent on its face
   (100 - 85.42 = 14.58 lies within 12.50-18.75). Ours "within [-.05, .05] in
   100% ...; largest |bias| 0.016"; effect 0.00, "smaller", "zero vs nonzero".
   Direction label follows the contract (0.00 within tolerance 0.005). Verify
   cells against Table 4.8 values and results.
9. E2/E3: effects 43.62/0.04 and 47.07/0.33, "smaller", "same". The "same"
   direction for 0.04 rests on a rounding tolerance (0.005) that is smaller than
   our own Monte Carlo SE (0.005-0.019, stated in Section 1). The contract makes
   this the correct descriptive label and Section 1 states the MC SEs, so not
   misleading; a reader may still wonder. Polish at most.
10. E4: Published effect 0.013, Ours 0.802, "larger", "same". Tolerance 0.0091
   ("mean reading error of her two read points"), chosen after results ("cell
   chosen after the results were seen" in the caption; Section 7.5 "not set in
   the plan"). Section 3.4 says reading errors are "up to about .02 on rates";
   with .02 her 0.0127 excess would be within reading error, i.e. "zero vs
   nonzero". The label "same" therefore depends on the per-point reading error
   being ~.009 rather than the generic .02. Verify the per-point reading errors
   in the digitized file. If verified, the label is per contract
   (measurement tolerance, rounded down). Should-fix only if unsupported.
11. E4 Ours cell uses ASCII "ah >= .13". Polish (use the ≥ symbol as in the
   text).
12. E5: Published "Tentative minimum n of 5,000 for accurate Type I error and
   power above .80"; Ours gives shares and the both-zero exception; scalar
   columns "not established"; tolerance "not applicable"; verdict "partial".
   Row label says "qualitative, no scalar contrast". Applicability looks
   honest on its face. Verify packet classification.
13. Caption contains "Descriptive point estimates; not equivalence.",
   estimand definitions, units (percentage points / rejection rate), positive
   meaning, tolerances and their basis, MC errors pointer. Pass. Dense but
   complete. Polish: long.

## Page 2: Introduction

14. Opens with the verdict and numbers, then the MC SE context, then the
   fourth headline, then the limit, then "No estimate reverses its sign." Pass.
15. Uses "S9" ("holding in 10 of 15 comparisons; S9") before any S-label is
   defined; S1-S9 labels are only explained in Appendix C. Standalone-prose
   issue. Polish (define "secondary claims S1-S9, Appendix C" at first use).
16. Arithmetic on face: 0.0127/0.0091 = 1.40 ("about 1.4 reading errors");
   43.62/0.04 ≈ 1,090 ("about three orders"); 47.07/0.33 ≈ 143 ("about two");
   sqrt(.05*.95/1000) = .0069 ("about .007"); sqrt(.852*.148/1000)/sqrt(32) ≈
   .002 ("our E4 value one of about .002"). All consistent.

## Pages 3-4: what we did; methods

17. Contribution section clearly separates hers from ours. Pass.
18. Section 3.3, p. 4: "so its datasets and point estimates are exactly those
   her printed, seeded code generates". The literal check covers the first
   simulation block only (635 of 1,270 datasets rebuilt and compared; RNG state
   identical after the block). "Exactly" for all 1,280,000 is then an inference
   from same code + same order + same RNG, not a dataset-by-dataset comparison.
   The paragraph does qualify that the replay is not her published runs. Verify
   against run record; possible should-fix wording ("by construction; verified
   literally on her first block").
19. Section 3.3 "How the engines were chosen" narrates process (who was asked
   when). It is a consequential departure from the source's software and is
   needed for the ledger, so acceptable; "research workspace" is internal
   phrasing. Polish.
20. Section 3.4: digitizing tool versions not recorded; stated openly and in the
   ledger as a departure. Pass (honest limit).

## Pages 5-9: results

21. Each H section opens with the question and the answer ("No.", "Not in our
   run.", "Mostly."). Pass.
22. Section 4.4 counts: 1,176 zero-effect + 2,664 nonzero = 3,840 per n; I
   derived 1,176 from the design (sum over effects of the zero-population
   share × 256 conditions × 3 cutoffs = 1.53125 × 768). Consistent.
23. Section 4.7: 13+16 = 29, 14+17 = 31, 46-31 = 15, 29+10 = 39, 46-39 = 7 =
   {2, 43} + {10, 11, 30, 41, 44}. Internally consistent.
24. p. 6-7: one-line widow "are not replicated." at the top of p. 7. Polish.
25. p. 9: large blank area below Section 5 because Table 3 floats to p. 10.
   Polish.
26. Section 4.8 (p. 8): blocked parts S4/S6 explicitly "not established, and
   not a failure to replicate". Pass.

## Pages 10-11: Table 3

27. Columns claim/published/ours/precision/numerical/scope/same direction;
   reasons paragraph follows. Pass. H1 scope "limited (same data at h = 0)" is
   explained in the reasons paragraph. Pass.

## Pages 11-17: disagreements

28. Ten disagreements, each with ours-first theories, predictions, tests,
   results, verdict and conclusion; 8 explained + 2 partly (6.2, 6.3) matches
   the lead and the abstract. Pass on face.
29. 6.2 arithmetic: λ = k / treated share: 1.469/.75 = 1.959, .959/.50 = 1.918,
   .441/.25 = 1.764. Matches "1.96, 1.92 and 1.76". Pass.
30. 6.5: "ours .0275, hers .0241, 0.7 standard errors apart and 1.0 from
   .025". With 4,000 replications (averaged over c'), SE ≈ .0026, so
   (.0275-.025)/.0026 ≈ 1.0 fits, but (.0275-.0241)/.0026 ≈ 1.3, not 0.7,
   unless the "apart" SE includes her reading error. Verify definition.
31. 6.7: .7362-.6975 = .0387 ("the .039 gap"); .039-.029 = .010; .010/.0071 =
   1.4. Consistent.
32. 6.9: -.127/.061 = -2.082; bounds .1265/.0615 = 2.057 and .1275/.0605 =
   2.107; -.137/.061 = -2.246. Consistent.

## Pages 17-20: assumptions, ambiguities, unresolved, limitations, availability

33. Section 7.5 states the E4 tolerance is a post-hoc measurement tolerance.
   Honest. Pass.
34. Section 9 has candidates, attempts, ranking and the settling artifact for
   each open gap. Pass.
35. Section 10 closing: "S4, S6, S7 and S8 are unassessed." Consistent with
   blocked/not established. Pass.
36. Section 11: source identified with a labelled abbreviated SHA-256; the
   availability ledger is dated and rowed. Verify against notes/availability.md.

## Pages 21-24: appendices

37. Appendix A states all links point to master; no commit hash or working
   branch named anywhere in the 24 pages (searched the text for "commit",
   "branch", 7+ hex runs: only "master branch" and the labelled SHA-256 of the
   source). Pass on the cold read; confirm with commit_refs.py.
38. p. 22: long filenames break mid-word in the File column
   ("condition_ summary.csv", "significance_ conclusions.json",
   "regression_ discontinuity__..."). Polish.
39. Appendix C dissertation-section table: "Chapter 1, Introduction: H1-H4,
   S7" — H1-H4 are Chapter 5 conclusions; Chapter 1 carries the research
   questions. Note column says so. Polish.

## Cold-pass summary

No blocking problem visible on the face of the PDF. Items to verify in the
evidence pass: (10) E4 per-point reading errors and tolerance derivation;
(18) scope of "exactly" for the R replay; (30) the 0.7 SE figure in 6.5;
(36) availability ledger; every page-1 cell. Polish: 4, 5, 9, 11, 13, 15, 19,
24, 25, 38, 39.
