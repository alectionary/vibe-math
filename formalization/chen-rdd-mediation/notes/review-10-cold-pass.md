# Review 10: cold pass (rendered PDF and criteria only)

Reviewed: `paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf` (21 pages, letter), every page rendered with `pdftoppm -r 80` and read, with `pdftotext -layout` for quotes. Nothing else was opened before this note was written: no evidence packet, writer manifest, results, source, or earlier notes.

## Overall reader impression

The paper puts its verdict first and is mostly standalone. It is unusually candid about process, limits and post-hoc choices. Page 1 is dense but readable. The main problems are internal: a few statements contradict the paper's own central explanation, or overstate what a test showed.

## Page-specific findings

### Page 1: abstract
- Sentence 1: "We did not replicate the three simulation headlines of Chen (2021), who reported that direct-effect estimates are biased, ... percentile bootstrap intervals cover the true value far too rarely, and ... power for the mediated interaction (MINT) is near zero". The verdict comes first, cites the source and states the source's finding, with numbers for each component (85.42% vs 0.00%; 43.62 vs 0.04 points; 0.063 vs 0.836). Pass.
- H4 is handled separately ("holds only in part") and gives the both-zero exception. RQ2 is "not established either way", which correctly avoids calling it a nonreplication. Good.
- **should-fix**: "Her figures match data without the treatment-by-mediator interaction and population values wrong for treated cases". This states both mechanisms as matches. Section 6.2 (p. 11) calls the second only "partly explained / medium confidence", and it does not reproduce cutoff 3. The next clause ("eight are explained, one partly") does not say which one is partial. Fix: "...and, in part, population values wrong for treated cases."
- **polish**: "Tolerances are her printed rounding (0.005 points) or the figure-reading error (.013)". This omits E3's summed tolerance of 0.01. Say "0.005-0.01 points".
- **blocking (shared with p. 3, p. 5, p. 8, p. 16)**: "her seeded R code, replayed on all 1,280,000 of her datasets". See the dataset-identity item below.

### Page 1: Table 1
- The columns appear in contract order: Published, Ours, Published effect, Our effect, Effect magnitude, Direction, Verdict. The caption opens with "Descriptive point estimates; not equivalence." Units, positive meaning and per-row tolerances are in the note. The MC SE caveat is present ("about .007 here; Chen reports none"). Legible at 80 dpi.
- E1 cells: Published "within [-.10, .10] in only 12.50-18.75% of conditions, with negative bias". This is consistent with 85.42 outside (100 - 14.58). Ours "100% within [-.05, .05]; largest |bias| 0.016". Coherent. The direction label "zero vs nonzero" is correct for 0.00 vs 85.42.
- E2/E3 have identical Published and Ours text. This is acceptable because E3's text contains "true value usually above the CI" / "misses on both sides at similar rates". polish: E3's Ours cell could print the 0.33-point imbalance explicitly.
- **should-fix (E4 direction)**: the estimand is the raw rejection rate, "positive means zero is excluded more often". A rejection rate is never negative, so "same direction" is automatic and carries no information. Section 4.3 (p. 6) itself says her curve "is the shape of a Type I error curve": her 0.063 is about 0.013 above the nominal .05, which is inside the stated .013 tolerance. Measured against the null (power minus .05), the comparison is closer to "zero vs nonzero". The contract says not to compare conveniently chosen raw parameters, and to define a contrast against its null. Fix: redefine E4 as power minus .05, or explain in the note why a raw rate is the scientific contrast and that direction is trivially the same.
- E5: the "no scalar / not established" row is labelled "qualitative, no scalar contrast". Its verdict "partial" matches the abstract.
- E2 direction "same": ours is 0.04 points against a 0.005 tolerance, with no stated uncertainty for the mean. The intro (p. 2) then says "our coverage shortfall ... point[s] the same way as hers". polish: note that 0.04 points may be within Monte Carlo error.

### Page 2: Introduction
- First sentence: "We did not replicate the simulation headlines of Chen (2021): ...". Verdict first, with findings and numbers. H4 is partial and limits follow immediately ("could not be rerun without restricted-use data", "bootstrap sets no seed"). Pass.
- "Two patterns explain most of them: ... (Section 6.2, only partly explained)". This qualification is properly kept here, unlike in the abstract.

### Pages 3-4: Methods
- p. 3, Section 3.3: "r-reproduction/chen_exact.R runs her own gendata() ... so its datasets and point estimates are hers". Table 2 (p. 5): "Her datasets, identical".
- **blocking (internal contradiction / overstated scope)**: Section 6.1 (p. 10) concludes "the datasets behind her published results contained no treatment-by-mediator interaction, while her printed code recovers it". So the replay reproduces the datasets that her *printed code* generates, not the datasets behind her published results. Several statements still treat the two as the same:
  - p. 16, Limitation 1: "Her datasets and point estimates are reproduced exactly by the R replay".
  - p. 8, Table 3: H1/S1 scope "exact".
  - p. 9, "Reasons by row": "the bias comparison uses her exact datasets through the replay ... so the scope is exact and the gap is not sampling error".
  - p. 4: "bias and point estimates are compared on her exact datasets".

  This overstates the limits on H1/S1. Fix: say "the datasets her printed seeded code generates", and qualify the "exact" scope in Table 3 and Limitation 1 using Section 6.1's finding.
- p. 4, 3.3, "How the engines were chosen": candid and clearly placed. Appendix B (p. 19) instead justifies the departure by "4 billion lm() fits were beyond the R host" and mentions "lavaan/OpenMx", which the paper never uses. **polish**: make the justification consistent and drop the irrelevant packages.

### Pages 5-7: Results
- p. 5, 4.1: "No." comes first; the numbers are stated with their files. Fine.
- p. 6, 4.3: discloses that the cell was chosen post hoc ("was chosen after the full results were available") and that the cutoff-1 point is occluded. Good practice.
- p. 7, 4.6: **should-fix (clarity)**: "and at h = .15 from n = 2,500 (.026-.033 at n = 1,000)". The parenthetical gives n = 1,000 values for a clause about n ≥ 2,500. It also says "The robust disagreements are two" while 18 - 14 = 4 statements disagree even with slack; the sentence then counts statements 9, 10 and 11 inside the second "disagreement". The count is unclear.
- p. 7, 4.7: 29/46 and 31/46 are consistent with 13+16 and 14+17. 39 = 29 + 10 is consistent.
- p. 7/9, 4.9 and Table 3: S8 is "withheld / unavailable / not rerun", and Appendix C (p. 20) and Section 9 call it "blocked". The text says the reason is that no method was reported, not that the input is unavailable. **should-fix (wording)**: label S8 "not reported / not assessable" rather than "blocked" or "withheld".
- p. 8, Table 3: S1 MINT is "12.5" with precision "2 decimals" (polish: "12.50").

### Pages 9-14: Disagreements
- p. 9: "Of the nine, eight are explained and one is partly explained". Each section has its theories, tests and verdicts. The structure is clear.
- p. 10, 6.2 "Ours. Coverage within 0.04 points of 95% and bias within .016 of zero everywhere". **should-fix**: 0.04 is the *mean* shortfall. Rows span 94.6-95.6 and the lowest cell is 0.916 (p. 6), so "within 0.04 points ... everywhere" is false as written.
- p. 11, 6.3: "the h coefficient is about −0.93 (PNDE) ... Verdict: supported" for a prediction of −1, with "high confidence". **should-fix**: acknowledge or explain the 0.07 gap (e.g., the treated-share term from 6.2), or soften the confidence.
- p. 13, 6.7: "Monte Carlo noise (neither) ... within about 2 combined standard errors. Result: 3.7. Verdict: ruled out". The next theory then argues that "a 3.7 standard-error gap is about what the most extreme of the 4,685 digitized rate points compared would show by chance". **should-fix**: the multiplicity argument contradicts the ruling-out of noise, and "her particular random draws" is itself Monte Carlo variation in her run. Reconcile the two, e.g., noise not ruled out once multiplicity is considered.
- p. 13: "The project owner was told this on 2026-11-09." p. 12, 6.6: "simulation/statement_checks.py now reports every statement against her own figures". **should-fix (standalone / process vs science)**: "now" refers to an earlier state of the work, and the notification sentence is project process inside a scientific test. Remove both or move them to the process section.

### Pages 15-17
- p. 15-16, Section 9: consistent with 6.1/6.2 (λ = 1.76 at cutoff 3).
- p. 16, Section 10: the limitations list is clear and tied to claims. Limitation 1 is covered by the blocking item above.
- p. 17, Section 11: the availability ledger is dated. Good.

### Pages 18-21: Appendices
- p. 18, Appendix A: "The repository revision c3e6211ef81e... contains this code". To check in the evidence pass against the reviewed commit fb83900.
- p. 19, Appendix B: the ledger honestly records "departed".
- p. 20, Appendix C: the inventory statuses match Table 3, except for the S8 "blocked" label noted above.
- PDF metadata: Title and Author are empty (polish).

## Severity summary (cold)
- Blocking: replayed data called "her datasets" / "exact" scope, which contradicts Section 6.1 (pp. 1, 3, 4, 5, 8, 9, 16).
- Should-fix: abstract mechanism overstatement (p. 1); E4 raw-rate direction (p. 1); 6.2 "within 0.04 ... everywhere" (p. 10); 6.3 −0.93 called supported with high confidence (p. 11); 6.7 noise ruled out vs multiplicity (p. 13); "now" and owner-notification process text (pp. 12-13); S8 "blocked/withheld" label (pp. 9, 16, 20); 4.6 garbled counts and parenthetical (p. 7).
- Polish: abstract tolerance list; E3 Ours cell; E2 0.04 uncertainty; lavaan/OpenMx and inconsistent engine justification (p. 19); "12.5" (p. 8); PDF metadata.
