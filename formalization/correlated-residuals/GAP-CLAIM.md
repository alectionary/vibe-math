# Claim block RQ-F102-replication-gaps

Canonical target: `L-F102-correlated-residuals`.
Follow-up: `RQ-F102-replication-gaps`.
Parent issue: https://github.com/alectionary/vibe-math/issues/13.
Work branch: `cursor/l-f102-correlated-residuals-4c01`.
Session ID: `1a831aa5-e49c-4b88-8374-2f117a9c2519`.
UTC start: `2026-10-27T18:20:15Z`.
Project board: not requested.
Draft PR: https://github.com/alectionary/vibe-math/pull/14.

The simulation claim at `05d69ea141adf3d5ee936d3b48061bde241250dc` was released at the previous closeout. This commit is the reservation for the gap investigation. It is preparation until the create-only ref update succeeds.

## Bounded question

Explain the gaps between our equation-(7) replication and Mi et al. (2010) Tables 1 and 2: SEM powers 64/77/96 versus 59/61/86, single-trait Y1 power for QTL3 97 versus 13, QTL2 single-trait power 3 versus 0, wider position standard deviations, and the printed QTL3 total effect 0.75 on Y1 versus 0.25 from `B = -M`. Test sign convention, scan method, threshold and detection rule, unprinted design details, and Monte Carlo error, each with a seeded rerun. Do not merge to `master`. Do not post outside the repository.

## Answer contract

Question and source: Tables 1 and 2 and equations (7)–(8) of Mi et al. (2010), against our replication in `simulation/out/study1.json`.
Intended answer: a gap-closure table for each hypothesis alone and in combination, a most likely explanation, and an updated replication section. A cell that disagrees with the printed equation is labeled `source discrepancy (our reading)`, not an author error.
Decisive evidence: seeded JSON for each hypothesis, the gap table, and the rebuilt PDF.

## Stopping condition

The five hypotheses have seeded outputs, the gap table is in the paper, and the PDF is rebuilt. If the sign convention that matches Table 2 differs from `B = -M`, the bow and calibration studies are rerun. Then release this claim.
