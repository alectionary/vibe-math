# Full-design run record (RQ3 simulation)

Date: 2026-11-08 (UTC). Script: `simulation/chen_sim.py`, sha256
`2d6a3e185d49c19fd78c197d1e2dc5e6c6b1f0f2dd825b77fed04070e48e8a55` (the same file on both hosts).

**Design run:** all 1,280 generated-data conditions (5 n x 4 a x 4 b x 4 c' x 4 h), each analysed
at all three cutoffs, giving 3,840 of 3,840 condition-cutoff cells, at 1,000 replications and 500
percentile-bootstrap resamples per replication. 13.7 core-hours in total.

| Host | Conditions | Engine |
|---|---|---|
| Cloud container (Linux x86_64) | 401: all n = 10,000, and n = 5,000 indices 768-912 | Python 3.13.18, NumPy 2.5.3 |
| Linux VM on the owner's computer (aarch64) | 879: all n = 500, 1,000, 2,500, and n = 5,000 indices 913-1023 | Python 3.10.12, NumPy 2.2.6 |

Each condition has its own seed, `SeedSequence(20211201, spawn_key=(k,))`, so the split does not
change any result. The VM's sandbox ends background processes when each command returns, so its
share ran in consecutive foreground chunks of 170 s; a condition interrupted by a chunk boundary
left no file (outputs are written atomically) and was rerun from its seed in the next chunk.
One VM condition (926) was missed by a chunk boundary and run separately.

**Cross-host check.** Conditions 37 (n = 500) and 300 (n = 1,000), computed on the VM, were rerun
in the container: the largest difference in any summary statistic was 1.1e-16. No condition was
computed on both hosts in the main run (the merge script found no file in common).

**Engine.** R is not reachable from either host (see `simulation/fallback.json`); the estimator
was validated against scikit-learn 1.9.1 OLS (container) and explicit resampling by
`simulation/validate_estimator.py` (`PASS_ESTIMATOR_VALIDATION`). R's random streams cannot be
reproduced, so agreement with Chen is judged on summaries, not draws.

**Outputs.** `simulation/work/` (one JSON per condition) is not committed;
`simulation/aggregate.py` turns it into `results/cells.csv` (19,200 rows: condition x cutoff x
effect) and the summary tables, and `simulation/statement_checks.py` checks the Chapter 4-5
prose statements on Type I error and power against `results/cells.csv`.
