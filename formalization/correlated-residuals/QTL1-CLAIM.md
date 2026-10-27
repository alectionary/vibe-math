# Claim block RQ-F102-qtl1-power

Canonical target: `L-F102-correlated-residuals`.
Follow-up: `RQ-F102-qtl1-power`.
Parent issue: https://github.com/alectionary/vibe-math/issues/13.
Work branch: `cursor/l-f102-correlated-residuals-4c01`.
Session ID: `a1525409-6da7-4f1d-bc45-91b23f068223`.
UTC start: `2026-10-27T19:08:25Z`.
Project board: not requested.
Draft PR: https://github.com/alectionary/vibe-math/pull/14.

The assumption-grid claim at `76a03bee0b2a15c6f612afaef61a2fcd5ebc69c5` was released at the previous closeout. This commit is the reservation for the QTL1 power search. It is preparation until the create-only ref update succeeds.

## Bounded question

Under the glyph reading, Table 1's SEM powers are 64, 77 and 96. The marker scan gives about 51, 54 and 86. Search for a reading that produces the triple jointly, in three families: data and model assumptions, missing procedural steps, and possible reporting slips. Seeded runs use 1000 replicates. Do not merge to `master`. Do not post outside the repository.

## Answer contract

Question and source: Table 1 of Mi et al. (2010) SAGMB, SEM column.
Intended answer: a ranked table of hypotheses with the predicted SEM triple, the single-trait cells, a distance to Table 1, and a graded verdict. A cell that disagrees with the printed display is labeled `source discrepancy (our reading)`, `consistent with`, or `cannot be distinguished from`. It is not labeled an author error.
Decisive evidence: seeded JSON at n=1000, analytic noncentral chi-square powers, and a remeasurement of the equation (7) glyphs.

## Stopping condition

Every listed hypothesis has a seeded run, a post-processing of one, or an analytic calculation; the explanations table is in the PDF; and the claim is released.
