# Resume the shared basis master

Read [the completed block report](SHARED-MASTER-TWO-HOURS-RESULT.md) first.
The source is still width 16 or 18, cover 405, physical partial 88/128, and
zero full source anchors excluded. No optimization remains active.

Scientific checkpoint: `3129963fcac399fe3422429aeed7247dbc2c9dd1`.
Branch: `research/c16-shared-master-20261030T2207`.
Existing publication PR: https://github.com/alectionary/vibe-math/pull/17.
The completed block's claim must be released at closeout; acquire a fresh
create-only claim for another authorized block rather than reusing its lease.

Keep these inputs unchanged:

- `shared-master-results/phase-one-v1.json` and its exact LP/model/seed.
- `shared-master-results/geometry-v4.json.gz`: 1,642 columns, all 32 domains.
- Point 22, SHA `4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f`.
- All old frozen producers, consumers, failed outputs and receipts.

The main exact-optimum route was not completed. Both SoPlex runs lacked an
exact endpoint; the second lacked floating vectors too. The first `.bas` file
is incomplete. Do not feed those stubs or that basis to a certificate checker.
The HiGHS candidate contains finite named row weights and a numerical primal,
but neither is an exact optimizer certificate.

Executed fallback path:

1. `shared_master_price_residual_v2.py` converts the named HiGHS decimal row
   weights into a source-valid rational combination, retaining all residuals.
2. `verify_shared_master_residual_projection.py` accepts all 32 domain prices
   and the exact residual bounds. Its receipt is
   `phase-one-v1-residual-pricing-v2-independent.json`.
3. `shared_master_residual_minorant.py` and `shared_master_residual_projection.py`
   produced the tiny exact minorant and owner row.
4. `verify_shared_master_residual_minorant.py` accepted the row and its negative
   gap, approximately -12,146.42. It rejects no current source case.

The final row has 109-bit primitive coefficients. Keep arbitrary-precision
arithmetic; it is not compatible with an unchecked signed-64-bit insertion.

The next proposed test is [the exact dual-feasible initial basis](SHARED-MASTER-DUAL-START.md),
not another large primal-simplex continuation by default. Implement its basis
statuses in a new versioned runner, check the block identity and signs, and
give the optimizer a fresh bounded deadline. The old HiGHS runners contain the
expired 22:56Z stop time and must not be reused as a new live campaign.
Save a complete basis as well as both vectors for later continuation.

For a dual candidate, preserve the distinction between exact optimality and
arbitrary source weights. An optimality claim requires every original row,
full stationarity and exact primal/dual equality. A residual-bound inequality
instead requires valid source signs, all residual corrections, all 32 prices,
the five joint-moment identities and exact final projection. Only a strictly
positive exact target gap separates point 22; source-case exclusion needs
additional global/case evidence.

The clean-replay controller and plan preserve the five completed gates. To
reproduce from a chosen clean committed checkout, use a new copy/output path
and that checkout's full commit ID with `replay_shared_master_checkpoint.py`.
Run at niceness 19, with all six numeric thread variables set to 1. The replay
does no optimization. The accepted original replay is in
`shared-master-results/clean-replay-3129963-inventory.json`.
