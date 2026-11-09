# Review 13: cold pass (rendered PDF only)

Reviewer: independent cold-reader agent, fresh context. Inputs read before this note:
`editorial-review.md`, `first-page-contract.md`, and the 23-page rendered PDF
(`pdftoppm -r 80`, every page viewed; `pdftotext -layout` for quotes). No packet,
manifest, notes, source or earlier review was opened before writing this.

## Overall reader judgment (before evidence)

A demanding but readable paper. The verdict comes first in both the abstract and the
introduction, the four headline claims are separated from the blocked Head Start
part, and the disagreements section is unusually explicit about competing theories.
The main cold-read problems are internal consistency between the methods/limitations
statements and how E4 was built, a "differ only" sentence that contradicts its own
table, and a dense page-1 caption. Nothing on its face looks fabricated.

## Page-specific judgments

| # | Page / location | Quote | Judgment | Severity |
|---|---|---|---|---|
| 1 | p1, abstract sentence 1 | "We did not replicate the three simulation headlines of Chen (2021), who reported biased direct-effect estimates, percentile bootstrap intervals that cover the true value far too rarely, and power for the mediated interaction (MINT) near zero" | Verdict first, source named and cited, each original finding stated, followed by signed numbers for each. Good. | pass |
| 2 | p1, abstract sentences 2-3 | "Her tentative minimum of 5,000 cases ... holds only in part ... Her Head Start estimates need restricted-use data and could not be rerun" | Fourth headline and the blocked RQ2 are separated; blocked part is not called a nonreplication. Good. | pass |
| 3 | p1, abstract | "her MINT rejection rate exceeds the nominal .05 by 0.013 (raw 0.063), about one reading error" | Honest about the near-zero size. "raw 0.063" is the three-cutoff mean, but the Published cell says "0.057-0.068 in this cell" and p6 says the cutoff-1 point reads 0.063; a reader may think the raw value is the single cutoff-1 point. | polish |
| 4 | p1, abstract para 2 | "Her printed, seeded R code, replayed on all 1,280,000 datasets it generates, recovers the interaction and gives unbiased estimates like ours." | Scope of the replay is stated correctly here and on p4 ("reproduces her printed pipeline, not her published runs"). Not overstated. | pass |
| 5 | p1, Table 1 | rows E1-E5, columns Published / Ours / Published effect / Our effect / Effect magnitude / Direction / Verdict | Readable at 80 dpi; cells legible; magnitude and direction separate; caption contains "Descriptive point estimates; not equivalence." Signed contrasts, units and positive meaning defined. | pass |
| 6 | p1, Table 1, E4 row and caption | "her unrounded 0.0127 exceeds the tolerance by only 0.0004, a near-tie (the tolerance was set after the results)" | Direction "same" hinges on 0.0004 against a post-hoc tolerance that was rounded down; this is disclosed, which is right. Check in evidence pass that rounding down was not chosen to change a label. | check |
| 7 | p1, Table 1, E4 caption + p6 + p4 + p18 | p4: "A marker hidden behind another series is flagged as occluded and is not used for any verdict." p18 limitation 3: "points hidden behind another series are flagged and not used for verdicts (H3, S2, S3)". p6: "The cutoff 1 point is partly hidden by another series and enters this average" | Internal inconsistency: the H3 headline value E4 and its tolerance use a partly hidden point, while the methods and limitation 3 say hidden points are not used for verdicts, naming H3. Dropping it (mean .0625, excess .0125, tolerance about .009) would not change the labels, but the limitation as written is false for H3. Fix: qualify limitation 3 and p4 ("fully hidden points ... ; the partly hidden H3 cutoff-1 point is used in E4, see Section 4.3") or report E4 on the two directly read points. | should-fix |
| 8 | p1, Table 1, E2 and E3 rows | identical Published and Ours text in both rows | E3's own finding (imbalance) is only implicit: Ours says "misses on both sides at similar rates" although our E3 is +0.33 points. Not wrong, but E3 cells could state the above/below shares (2.5-2.9% vs 1.8-2.7%). | polish |
| 9 | p1, Table 1 caption | about 11 lines of definitions, tolerances, MC errors | Complete but dense; tolerance for each row is findable. | polish |
| 10 | p2, Introduction para 1 | "We did not replicate the simulation headlines of Chen (2021): her finding that ..." | Verdict first, independent of the abstract, with numbers and locators. "No estimate reverses its sign." consistent with Table 1. | pass |
| 11 | p2, Introduction para 1 | "Our coverage shortfall (0.04 points against her 43.62) is about three orders of magnitude smaller ... imbalance (0.33 against 47.07) about two" | Arithmetic correct (1,090x and 143x). | pass |
| 12 | p2, Introduction last para | "Two patterns explain most of them ... (Section 6.2, only partly explained)" | Uncertainty kept in the intro. Good. | pass |
| 13 | p4, Section 3.3 "How the engines were chosen" | "that choice was made without first asking the owner of this replication project" | Candid; slightly project-internal for a standalone paper but understandable. | polish |
| 14 | p5, Section 3.6 lead-in vs Table 2 | "The sides differ only in random draws for interval-based results and in the step that compares estimates with population values" vs Table 2 Data row "published results evidently lack h where h > 0" | Contradiction within the same section: the paper's own main finding (Section 6.1) is that the data differed. "differ only" understates the comparability gap. Fix: "By design the sides differ only in ...; on the evidence of Section 6.1 her published data also lacked h". | should-fix |
| 15 | p5, Section 4.1 | "every PNDE and TNDE result lies within [-.05, .05]; the largest |bias| over all 19,200 condition-cutoff-effect results is 0.016" | 19,200 = all five effects, not only direct effects; wording slightly ambiguous. | polish |
| 16 | p6, Section 4.3 | "This contrast cell ... was chosen after the full results were available" | Post-hoc choice disclosed. Good. | pass |
| 17 | p6-7, Section 4.3 | "her abstract and Chapter 5 ... say that Type I error and power for all five effects were within or reached the robustness criteria, which her MINT power statement contradicts" | Fair acknowledgement of a conflicting source statement. | pass |
| 18 | p7, Sections 4.6-4.7 | 13/14 of 18, 16/17 of 28, 29/31 of 46, 39 of 46 at h=0, 7 listed | Counts internally consistent (29+10=39; 46-39=7 statements listed). | pass |
| 19 | p8, Section 4.8 | "are therefore blocked: not established, and not a failure to replicate" | Blocked parts correctly not called nonreplication. | pass |
| 20 | p9, Table 3, S5 row | "24 entries / 24 reproduced / 3 decimals / match" | Text checks 24 differences plus 24 standardized biases (48 numbers) and 12 identities; "24 entries" undercounts what was compared. | polish |
| 21 | p10, Reasons by row, H1/S1 | "it is exact only where h = 0 ... The mismatch stands there too" | Good scope reasoning. | pass |
| 22 | p10-16, Section 6 | "Of the ten, eight are explained and two (Sections 6.2 and 6.3) are partly explained" | Ten subsections, conclusions match the count; each starts with an "ours" theory. | pass |
| 23 | p12, Section 6.2 | "λ = 1.96, 1.92 and 1.76 ... Verdict: ruled out" and conclusion "medium confidence" | Honest partial explanation. | pass |
| 24 | p14-15, Section 6.7 | "Monte Carlo noise in one prespecified comparison ... inconclusive" then "Her particular random draws ... supported" | Multiplicity handled explicitly. Good. | pass |
| 25 | p17, Section 7.5 | "0.0123, rounded down rather than up, and not set in the plan" | Disclosed post-hoc tolerance. | pass |
| 26 | p18, Section 10 | seven numbered limitations with claim IDs | Clear; but see item 7 for limitation 3. | see 7 |
| 27 | p19, Section 11 | "The project owner applied for the restricted-use data and could not obtain them." | Not in the availability ledger table above it; check against notes/availability.md. | check |
| 28 | p19, Section 11 ledger | five rows dated 2026-11-08 | Readable. | pass |
| 29 | p21-22, Appendix B | heading "B Compliance ledger" alone at the bottom of p21, table on p22 | Orphan heading; the ledger itself is workflow-internal ("preflight", "check_citations.py", "No authorship statement by a language model"). | polish |
| 30 | p22-23, Appendix C | claim inventory with statuses | Matches statuses in body (H1-H3 not replicated, H4 partly, S1 not, S2/S3/S9 partly, S4/S6 blocked, S5 replicated, S7/S8 not established). | pass |

## Cold-pass items to verify in the evidence pass

- Every Table 1 cell against the packet and result files; E1-E3 means of her rows; tolerance derivations (E1/E2 0.005 as mean of rows at 2 decimals; E3 0.01; E4 0.0123 rounded down).
- Whether the partly hidden H3 point is flagged as occluded in the digitized data (item 7).
- The owner's data application (item 27) against notes/availability.md.
- Disagreement verdicts against DISAGREEMENTS.yaml.
