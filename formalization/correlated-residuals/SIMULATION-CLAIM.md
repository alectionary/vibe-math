# Claim block RQ-F102-simulation-studies

Canonical target: `L-F102-correlated-residuals`.
Follow-up: `RQ-F102-simulation-studies`.
Parent issue: https://github.com/alectionary/vibe-math/issues/13.
Work branch: `cursor/l-f102-correlated-residuals-4c01`.
Session ID: `febd2771-c168-4e67-8ed4-277662d6eb85`.
UTC start: `2026-10-27T17:39:24Z`.
Project board: not requested.

The previous claim at `64f01d6b3b5b6da4a42c8edb183b3f802e717826` was released at the last closeout. This commit is the new reservation for the same canonical target. It is preparation until the create-only ref update succeeds.

## Bounded question

Replicate the Mi et al. (2010) simulation (equations (7)–(8), 100 replicates of 150 RILs, 11 markers on 100 cM, QTLs at 22, 42, and 78 cM), then add a bow-free correlated-residual Monte Carlo and a calibration that uses Campbell et al. (2003) Table 2 correlations as a realism check. Write the LaTeX paper. Do not merge to `master`. Do not post outside the repository.

## Answer contract

Question and source: the printed simulation design and Tables 1–2, plus the correlated-residual extension of the same design.
Intended answer: a seeded replication with every underspecified choice recorded, a bow-free Monte Carlo with delta-method coverage, and a correlation-scale calibration that is labeled as a realism check.
Decisive evidence: JSON outputs, tables, and the paper. Evidence labels stay separate from the Lean proofs already on this branch.

## Stopping condition

The three studies have fixed seeds and saved JSON, the paper compiles to PDF, and the sources ledger records each PDF hash. Then release this claim.
