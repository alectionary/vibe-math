# Resume the C16 shared-basis investigation

The source question is still **width 16 or 18**. The sufficient cover is 405,
the best verified physical partial frame is 88/128, and zero complete source
anchors have been excluded. No new Lean completion is claimed. Read the
[final report](TWO-BASIS-EIGHT-HOURS-FINAL.md) before continuing.

The eight-hour block was authorized for 2026-10-30 14:38:33Z–22:38:33Z, on
`research/c16-two-basis-20261030T1438`. Its scientific checkpoint is
`45873144ca36684562c235fc68db41c0b06a95c3`; later commits preserve the clean
replay outputs, projection lemma and handoff. Existing PR17 uses branch
`research/c16-structural-20261027T173245`. Consult
[issue8](https://github.com/alectionary/vibe-math/issues/8) for the final remote
head and claim status. A released coordination claim is not a pause or a
solution. A new authorized block must acquire its own create-only claim.

## Exact starting objects

| Object | Certificate or note | Scope |
| --- | --- | --- |
| Current global point22 | `coupling-results/two-basis-integer-witness22-rational.json.gz` | Seven exact screens, 54 partner + 990 integer-form + 308 rank rows, older families and complete triples |
| Strongest finite shared endpoint | `two-basis-results/joint-owner-k22-eight-point22-exact.json` | All 98,868 rows, shared owner capacities and complete eight-event law; higher joint moments pinned to zero |
| Shared phase-I starting seed | [Seed result](SHARED-BASIS-PHASE-ONE-SEED-RESULT.md) | 22 valid full physical bases and 23,040 links, with explicit positive artificial errors |
| Full-domain pricing and master | [Next-gate derivation](SHARED-BASIS-MASTER-NEXT-GATE.md) | Reuses the validated signed matroid oracle; shared master still unimplemented |
| Removing law dependence | [Pattern-cost projection](SHARED-BASIS-PATTERN-COST-PROJECTION.md) | Exact lemma and algebra controls; no actual C16 projected cut yet |

Point22 SHA256 is
`4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f`.
The strongest shared endpoint SHA256 is
`7b89285c98822c9714f9577f44945205ef57e2892d54002cc5d926c7e5f44dd0`.
The starting seed SHA256 is
`27bbbe759c93cb20dc7b581a35434bb6c4b35aa132fb7412bf395c1035d40473`.
Use frozen inventories to check the entire input closure, not only these files.

The sixteen conditional rank obstructions found at the earlier capacity
allocation have **not** been silently added to the last coupled model.
Orbit40's membership concerns the opposite-sector T law at point22; it is not
a joint full-frame law. Orbit15's exact saved-hull L1 optimum improved from
0.86866010 to 0.83757010, but its full greedy gap remained negative. Do not
transfer old weights between targets or call restricted-archive infeasibility
a global obstruction.

## Reproduction and resource policy

The recorded interpreter is `/private/tmp/c16-venv/bin/python` (Python3.12.14).
Use verified niceness19 and set `OPENBLAS_NUM_THREADS`, `OMP_NUM_THREADS`,
`MKL_NUM_THREADS`, `VECLIB_MAXIMUM_THREADS`, `NUMEXPR_NUM_THREADS` and
`BLIS_NUM_THREADS` to1. The user lifted the temporary Mac load restriction
but wants lower-priority processes. New solvers need explicit time/memory
limits and new output names. Preserve failed and capped attempts.

Two clean replays already passed:

- `two-basis-results/final-clean-checkpoint-b6ed9a0-inventory.json`:34 stages,
  83.91s,1,449 declared files, no original research-input reads.
- `two-basis-results/final-supplement-checkpoint-4587314-inventory.json`:14
  stages,39.11s,2,060 declared files, no original research-input reads.

Do not repeat these just to consume a budget. If a dependency changes or a
new machine requires replay, use a separate checkout whose HEAD equals the
chosen frozen checkpoint. The drivers reject tracked modifications and
existing output/copy directories. From that checkout's C16 directory:

```sh
env OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 MKL_NUM_THREADS=1 \
  VECLIB_MAXIMUM_THREADS=1 NUMEXPR_NUM_THREADS=1 BLIS_NUM_THREADS=1 \
  PYTHONDONTWRITEBYTECODE=1 nice -n 19 /private/tmp/c16-venv/bin/python \
  replay_final_supplement_checkpoint.py \
  --checkpoint 45873144ca36684562c235fc68db41c0b06a95c3 \
  --copy-root /private/tmp/c16-new-supplement-copy \
  --output-dir /private/tmp/c16-new-supplement-output --total-seconds 900
```

Replace both destinations with nonexistent paths. The earlier driver is
`replay_final_owner_checkpoint.py` at checkpoint
`b6ed9a0db40ec431d706fcd9f68ffa5e93e44e89`, with the same path arguments and
a maximum total of1200seconds. Frozen absolute paths and native runtime
bindings require the documented relocation/runtime checks on another machine;
do not silently rewrite certificates. Solver execution is not part of either
replay. Four current canonical validators pass; the historical
`validate_difficulty.py` related-ID mismatch remains a recorded failure.

## One bounded next gate

Keep the full shared owner-flow/eight-event model, its literal target and
source-row provenance. Add nonnegative basis weights with
`sum_B w[s,m,B]=lambda[m]` and links
`y[s,m,j]=sum_B w[s,m,B]*1[j in B]`. Keep y variables to avoid expanding
every parent row. The saved seed supplies a feasible phase-I initialization
with link errors; its L1 total about289.056 is nonzero and is not membership.

Before the first solve, independently check every literal column, the parent
rows and the explicit starting links. Validate the actual exported LP against
these equations. Set a small wall-clock and memory cap for one exact restricted
solve. Then price every relevant sector/pattern with the existing signed
full-basis oracle, including the mass-row constant. Stop and classify:

1. Zero artificial error plus all exact parent/link rows gives membership in
   this auxiliary relaxation, still not a physical source frame.
2. A positive exact full-master dual gap, after complete pricing and finite
   cancellation, rejects its declared target/law scope only.
3. A missing basis, numerical-only result or cap is inconclusive. Save it;
   do not start an unbudgeted column loop.

To reject the global point, lift any reduced proof to the full symbolic model
and remove pin dependence. The five higher coordinates are joint moments,
`tau[h]=sum_{m contains h}lambda[m]`, not atom masses. The projection lemma
uses all32 sector/pattern domains and a checked quadratic minorant on all16
patterns. Every residual variable needs cancellation or a valid bound.
Source symmetry has factor one. Artificial link errors are zero for source
frames. Only a strictly positive independently verified final owner-row gap
is a new global cut; reinsert it into the global model and check the outcome.

A complete source-case exclusion additionally requires global moments free
and the correct case floor. A full 128-pair physical Gram-identity witness or
an obstruction covering all source frames remains the conclusive endpoint.
No finishing-time bound follows from the measured archive improvement.
