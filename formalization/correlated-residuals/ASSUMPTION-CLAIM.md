# Claim block RQ-F102-assumption-grid

Canonical target: `L-F102-correlated-residuals`.
Follow-up: `RQ-F102-assumption-grid`.
Parent issue: https://github.com/alectionary/vibe-math/issues/13.
Work branch: `cursor/l-f102-correlated-residuals-4c01`.
Session ID: `a42142f3-1c1c-4f9f-afc5-8c4316e76486`.
UTC start: `2026-10-27T18:49:33Z`.
Project board: not requested.
Draft PR: https://github.com/alectionary/vibe-math/pull/14.

The gap claim at `d164f8295bb58b3f1ff6ad4c5536572a12834f04` was released at the previous closeout. This commit is the reservation for the assumption grid. It is preparation until the create-only ref update succeeds.

## Bounded question

Under the glyph reading of equation (7), the remaining gaps are SEM power 48/87 against 77/96 for QTL2 and QTL3, single-trait QTL3 power 86 against 97, and single-trait QTL2 power 1 against 3. Family A tests modeling choices the paper does not pin down, each with a seeded run of 1000 replicates. Family B checks internal consistency of Tables 1–2 and whether the printed powers match a different design in the companion papers. Do not merge to `master`. Do not post outside the repository.

## Answer contract

Question and source: Table 1 of Mi et al. (2010) SAGMB, under the glyph reading already recorded in `simulation/out/gaps.json`.
Intended answer: an explanations table with family, evidence, gap closed, and a graded verdict. A cell that disagrees with the printed display is labeled `source discrepancy (our reading)`, `consistent with`, or `cannot be distinguished from`. It is not labeled an author error.
Decisive evidence: seeded JSON at n=1000 for each family-A choice, analytic noncentral-chi-square powers, and the companion-paper comparison.

## Stopping condition

Every listed choice has a seeded n=1000 run or a post-processing of one, the companion papers have been compared, the explanations table is in the PDF, and the claim is released.
