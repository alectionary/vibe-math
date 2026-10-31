# Fixed A0 score-representation pilot: approval required

This package prepares exactly four new chains on the existing N=500-pair/J=60 dataset. It compares the canonical score representation with the four already reviewed item-likelihood chains. Both use JAGS 4.3.2; this is not an independent-backend check or a contemporaneous speed comparison. No new dataset is generated. No sampling has run from this package.

The frozen inputs are in `outputs/score-a0-prepared/`. All stochastic latent and global starts are explicit; only deterministic MZ genetic nodes have NA initialization sentinels. Seeds are 850101–850104, disjoint from historical 830101–830104. Each chain has 1,000 adaptation iterations, 7,000 burn-in iterations and 28,000 retained draws, saved in 4,000-draw checkpoints. Fixed priors, calibration, data, source model, diagnostic criteria and estimands are preserved. Original four 28,000-by-14 matrices, adaptation records, request identities and review hashes were verified. The immutable manifest pins prepared, source, historical and installed-runtime bytes.

Run these commands from `formalization/schwabe-psychometric-genetics` in the recorded workspace/runtime. The first command is read-only and does not start R:

```sh
python simulation/dispatch_score_a0.py check
```

Only after the user explicitly approves this bounded pilot, substitute the actual approval message ID:

```sh
python simulation/dispatch_score_a0.py launch --approval-reference ACTUAL_APPROVAL_MESSAGE_ID
```

The approval-reference argument records authority; inventing a string does not grant it. Do not run the R chain script directly. The launcher alone supplies its accidental-launch interlock. It copies the frozen preparation to `production/score-a0-v1/prepared`, runs the four chains concurrently, and then runs the fixed diagnostic/comparison script if all chain processes complete. It never generates data, replaces a chain, resumes, or expands to another condition. An existing namespace is refused, including after failure. Do not delete or rename the namespace to bypass that refusal.

For interruption, send the launcher SIGINT, or from another shell run:

```sh
python simulation/dispatch_score_a0.py stop
```

The stop command verifies the supervisor PID's Linux start time before signalling it. The supervisor sends TERM to its owned process groups, allows five seconds, then sends KILL; descendants are included even if a leader exited. It retains partial checkpoints, logs and all four requested outcomes. SIGKILL of the supervisor itself prevents Python cleanup and must not be used as routine shutdown; a machine crash likewise requires explicit forensic process inspection before any later action.

## Fixed resource and failure policy

- Four workers maximum, one computational thread each; at least four cgroup/affinity CPU slots.
- 1,600 seconds per chain; 6,420 summed chain/cleanup seconds.
- 120 process-seconds for copying preparation, 600 for read-only validation, 600 for diagnostics; 7,740 all-phase summed process-seconds overall.
- One-hour elapsed deadline including validation and all later phases. A phase may be cut short by that deadline even if its own allowance remains.
- 1 GiB RSS per worker, 4 GiB aggregate worker RSS, and 2 GiB free cgroup reserve; launch requires 6 GiB headroom. Ancestor cgroups are checked.
- 1 GiB namespace output and 16 MiB per log.

Limits are monitored every 0.1 seconds, with polling/cleanup margins reserved for time budgets. They are fail-closed operational guards, not kernel-hard memory/output limits or hard realtime guarantees: usage can overshoot between probes. Resource-probe errors, identity mismatches, conflicting model workers, worker failures or any exceeded guard stop the stage. No unused allowance authorizes extra draws, replacement seeds or a larger case. The 1,600-second ceiling is based on historical 1,226–1,240-second item-chain timings; score-graph throughput and mixing remain unmeasured.

`requested-chains.json` is an initial snapshot. `chains/outcomes.json` records actual terminal states; if preparation fails before that exists, all four remain unlaunched. Partial or failed runs stay in the requested denominator. Successful process exit is not convergence. The diagnostic keeps all 14 established gates and trace/rank/whole-half HPD review; five predeclared global mean differences use combined MCSE and Bonferroni intervals. Zero inclusion is not scientific equivalence. Manual independent diagnostic review remains required after any approved run.

## Verification and scientific status

```sh
python simulation/test_score_a0_dispatch_independent.py
```

These tests use harmless Python processes only. They cover prelaunch budgets, timeouts, memory/output/log guards, conflicts, fixed denominators, cancellation, descendant cleanup, existing namespace refusal and cgroup ancestry. Independent review is in `provenance/score-a0-dispatch-independent-review.json`; preparation/reuse evidence is in `provenance/score-a0-reuse-evidence.json`.

This package closes the previously identified A0 preparation tasks. It does not complete posterior replication, source-count recovery/power/sufficiency targets or any new original dissertation claim. The existing reviewed main PDF is unchanged. Stage B, source-count production and another backend are not included in the requested approval.
