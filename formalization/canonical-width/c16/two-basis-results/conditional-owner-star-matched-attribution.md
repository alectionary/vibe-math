# Matched cross-sector ownership gain at point22

The accepted original-allocation bank contains a particularly informative row
at cut index612. It uses only pattern2 and no unconditional T coordinate:

`10 yX[2,614] + sum_(j in J) yZ[2,j] <= 11 lambda[2]`,

where `J={51,56,194,230,485,492,501,547,588,642,646}`.
Its independently replayed exact violation is
`6268396875783/1125899906842624`.

The derivation is the eleven conditional Boolean lower bounds
`E[1_2 X614 Zj] >= yX[2,614]+yZ[2,j]-lambda[2]`, summed over these pairing-one
neighbors. Their sum cannot exceed `yX[2,614]`, because a selected X has exactly
one selected pairing-one owner. Rearranging gives the displayed row.

Crucially, both original pattern2 marginals already have exact independently
verified full physical basis mixtures:

* `two-basis-push-relabel-early-point22-X-m02-independent.json`
* `two-basis-push-relabel-early-point22-Z-m02-independent.json`

They bind the same original dyadic50 allocations used by the owner-star bank.
Consequently this row is not detecting a missing individual sector rank
inequality. It proves these particular full-basis marginals cannot arise from
a mutually compatible source selection law under pattern2. Other allocations
for the same anchor law, and other laws at the same global point, remain open.

The accepted whole-bank replay is
`conditional-owner-star-original-point22-independent.json`, checking1429 cuts
and11 feasible individual stars across all1440 probes. The subsequent
closed-rank-allocation bank separately checks1423 cuts and17 feasible stars.
Those successes are fixed-allocation statements; neither bank excludes a
shared law, the global moment point, a cover case, or C16.

The source scripts and receipts are frozen. The v2 adapter changes only the
allocation receipt consumer from the original geometry consumer to the
closed-rank consumer, plus the matching flow-producer filename. A failed
strict consumer-version guard before that adapter is preserved. All jobs had
exited before the request to keep the Mac responsive; no follow-up numerical
model or cohort is authorized by this attribution note.
