# Review 11 - cold pass (rendered PDF only)

Reviewer: independent cold-reader agent, fresh context. Read before any packet,
manifest, DISAGREEMENTS.yaml, results, source or other notes.
Inputs read: editorial-review.md, first-page-contract.md, and the 22-page PDF
`paper/mediation_in_regression_discontinuity__a_replication_of_chen_2021.pdf`
(rendered at 80 dpi, every page viewed or read via pdftotext -layout).

## Overall reader judgment

The paper is verdict-first, standalone in most places, and unusually candid
about limits (unseeded bootstrap, post hoc choice of the E4 cell, fallback
engine). The page-1 table is legible and its cells look arithmetically coherent.
Blocking issue as a reader: one introduction sentence overstates what the exact R
replay covers, contradicting Section 3.3 and Limitation 1. Several should-fix
items are internal inconsistencies visible on the page.

## Page-specific judgments

### Page 1 - abstract
- Sentence 1: "We did not replicate the three simulation headlines of Chen (2021),
  who reported that direct-effect estimates are biased, that percentile bootstrap
  intervals cover the true value far too rarely, and that power for the mediated
  interaction (MINT) is near zero". Verdict first, source named with finding,
  composite headline covered. Good.
- H4 sentence: "holds only in part ... products with both paths zero stay
  conservative at every n". Good, matches Table 1 "partial".
- "Of ten disagreements, nine are explained and that one only partly" -
  ungrammatical; "that one" has no antecedent and a reader can parse it as "one
  of the nine is partial". Page 10 says "nine are explained and one (Section 6.2)
  is partly explained". SHOULD-FIX: "nine are explained and the tenth only partly".
- "her cutoff 3 is not reproduced" - cryptic for a standalone abstract (which
  cutoff is 3? reproduced by what?). POLISH: "the rule does not fit her third
  cutoff".
- Uncertainty: tolerance sources stated; "comparisons are descriptive point
  estimates, not equivalence". Good. No Monte Carlo error mentioned in abstract;
  acceptable since caption carries it.

### Page 1 - Table 1
- Columns Published / Ours / Published effect / Our effect / Effect magnitude /
  Direction / Verdict present; readable at 80 dpi.
- E1: 85.42 vs 0.00, "smaller", "zero vs nonzero". Published cell "within
  [-.10,.10] in only 12.50-18.75%" is consistent with 85.42 as the mean share
  outside (100-18.75 = 81.25 .. 87.50). OK on its face.
- E2: 43.62 vs 0.04, direction "same". 0.04 exceeds the 0.005 rounding tolerance,
  but the caption gives a per-cell MC SE of ~.007 (0.7 points) and the paper never
  says whether a 0.04-point mean shortfall is distinguishable from Monte Carlo
  noise. The intro then asserts "Our coverage shortfall and imbalance point the
  same way as hers". SHOULD-FIX: state the MC uncertainty of the 0.04 and 0.33
  means, or qualify "same way" as a point-estimate sign only.
- E4: published effect 0.013 with tolerance exactly 0.013; "zero vs nonzero"
  rests on a tie at the tolerance boundary. Disclosed on p.6 ("Her value lies
  within the .013 reading error of zero"). Reader concern: evidence pass must
  check unrounded values and how .013 was derived (p.4 says reading errors "up to
  about .02 on rates").
- E5: "no scalar" in both effect columns. The contract says absent scalar values
  display "not established". SHOULD-FIX (contract wording) unless the adapter
  explicitly allows it.
- Verdict column vocabulary "no match"/"partial" differs from "not replicated"/
  "partly replicated" in Sections 4 and Appendix C. POLISH.
- Caption: estimand, units, positive meaning, tolerances and "Descriptive point
  estimates; not equivalence." all present. Good.

### Page 2 - introduction
- Opens with the verdict and evidence for H1-H3, then H4 partial, then limits
  (HSIS restricted, unseeded bootstrap). Good.
- "Our coverage shortfall and imbalance point the same way as hers but are about
  two orders of magnitude smaller." E2 is 43.62 vs 0.04 (about 1,000x, three
  orders); only E3 (47.07 vs 0.33, ~140x) is two orders. SHOULD-FIX.
- "We ran her full RQ3 design, replayed her own seeded R code on every dataset she
  generated". This overstates the replay: it reproduces the datasets her PRINTED
  code generates, which Section 3.3 (p.4), Table 2 (p.5), Section 5 reasons (p.9-10)
  and Limitation 1 (p.18) all say are not the data behind her published results
  wherever h > 0. BLOCKING (internal contradiction about the central evidence
  engine): "replayed her printed, seeded R code on every dataset that code
  generates".
- Last paragraph: "Our replay of her printed code behaves like our independent
  run, not like her published results." Correct framing.

### Pages 3-4 - Sections 2-3
- p.3-4, Section 3.3 "They are not necessarily the data behind her published
  results ... The replay therefore reproduces her printed pipeline, not her
  published runs." Excellent; this is the correct statement.
- p.4 "How the engines were chosen": references the "project owner", "repository
  issues #92 and #118". Process detail aimed at insiders; acceptable as
  disclosure but not standalone for an outside reader. POLISH.
- p.4 Section 3.4 reading error "up to about .02 on rates" vs E4 tolerance .013
  (p.1, p.16 Section 7.5 ".013 averaged over cutoffs"). Not contradictory but the
  reader should be told how .013 was computed. POLISH.

### Page 5 - Table 2, Section 4.1
- Table 2 R-replay "Data" cell: "Datasets her printed code generates, identical
  to her printed pipeline". Correct.
- 4.1: "largest |bias| ... 0.016", MC SE at most 0.006. Clear.

### Page 6 - Sections 4.2-4.3
- 4.2 "Our run shows a small positive imbalance (0.33 points), two orders of
  magnitude smaller than hers; we did not investigate its cause." Honest.
- 4.3: discloses the E4 cell "was chosen after the full results were available".
  Good. Its occluded cutoff-1 point "enters the average" while Section 3.4 and
  Limitation 3 say occluded points "are not used for any verdict". The E4
  direction label is a verdict-bearing quantity. SHOULD-FIX: either exclude it (the
  direct points 0.068/0.057 average 0.0625, still near .013) or reword the
  general rule.
- 4.3: "Her own summaries are also inconsistent" - helpful.

### Page 7 - Sections 4.4-4.7
- 4.4: shares by n clear; "1,176 zero-effect and 2,664 nonzero results per n"
  sums to 3,840. Good.
- 4.7: "Read on our cells with h replaced by 0, 39 of 46 hold; 10 of the 15
  statements that disagree under both readings become agreements ... The 5 that
  still disagree are 10, 11, 30, 41 and 44." 46 - 39 = 7 disagree under h=0, but
  only 5 "still disagree" are listed; the other two (agree only with slack?) are
  never named. SHOULD-FIX: reconcile (e.g. "39 of 46 hold at the designed
  thresholds, 44 with slack; ..." or name the other two).

### Page 8 - Sections 4.8-4.9
- Blocked S4/S6 stated "not established, and not a failure to replicate". Good.
- S9 partly replicated with specifics. Good.

### Pages 9-10 - Table 3 and reasons
- Table 3 legend defines match/close/mismatch but the table also uses
  "withheld" and "not applicable" without definition. POLISH.
- H4 "Same direction?" = "mostly" - not a direction label. POLISH.
- H1/S1 scope "limited (exact at h = 0)": explained on p.10. OK.

### Pages 10-16 - Section 6 disagreements
- p.10 "nine are explained and one (Section 6.2) is partly explained; none is
  unexplained." Consistent with abstract intent.
- p.11-12, 6.2 theory "Population values right for control cases, wrong for
  treated cases": its own prediction says "one λ for every cutoff"; result
  "λ = 1.96, 1.92 and 1.76 ... not constant, so this rule does not reproduce
  cutoff 3 exactly. Verdict: supported." A prediction that fails at one of three
  cutoffs should be "partly supported". SHOULD-FIX (overstated theory verdict;
  the section conclusion already says "Partly explained").
- p.12, 6.3: conclusion "Explained" while the PNDE ah coefficient (-0.26) "is not
  explained" and -0.93 vs -1 "may share that cause". Counted among the nine
  "explained". SHOULD-FIX: label "mostly explained" or justify counting it as
  explained with the open residual stated in the abstract count.
- p.14-15, 6.7: careful multiplicity handling (4,685 points; 3.7 SE). Good.
- p.15-16, 6.10: clear. Good.

### Pages 16-18 - Sections 7-10
- 7.5 E4 tolerance basis given. OK.
- p.18 Limitations para: "S6, S7 and S8 are unassessed" omits S4, which is also
  blocked. POLISH.

### Pages 18-19 - availability ledger
- Readable; dated. "The project owner applied for the restricted-use data and
  could not obtain them." OK.

### Pages 20-22 - Appendices
- p.20: revision 35eba69... differs from the reviewed commit; fine if this is
  the code revision, but a reader cannot tell. POLISH.
- p.22, Appendix C: S8 status "blocked: announced, never reported" contradicts
  Table 3 ("not applicable") and Section 4.9 ("nothing to assess"); S8 is not
  blocked by access. SHOULD-FIX (status vocabulary inconsistency).

## Severity summary
- Blocking: p.2 intro "replayed her own seeded R code on every dataset she
  generated" overstates the R replay.
- Should-fix: p.1 abstract "that one only partly"; p.1/p.2 E2/E3 "same way"
  without MC uncertainty; p.2 "two orders of magnitude" wrong for E2; p.1 E5 "no
  scalar" vs contract "not established"; p.6 occluded point used in E4 contrary to
  stated rule; p.7 39-of-46 vs 5 remaining; p.11-12 6.2 theory verdict
  "supported"; p.12 6.3 "Explained" with unexplained term; p.22 S8 "blocked".
- Polish: listed inline above.
