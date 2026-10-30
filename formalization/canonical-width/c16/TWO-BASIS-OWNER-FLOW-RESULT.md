# Shared owner flows and an exact zero-face reduction

Continuation of `TWO-BASIS-EIGHT-HOURS.md`, session
`c16-two-basis-20261030T1438`, issue8. The source question remains open:
width 16 or 18, sufficient cover 405, physical partial 88/128, zero complete
source anchors excluded, and no new Lean completion. The latest exact global
moment point is still 22. The results below concern auxiliary allocations at
that one point, not new global points or removed source cases.

## Completed finite refinement

The general five-high-moment model, with all five moments explicitly pinned
to zero for this trial, accepts an exact allocation with 5,530 listed rank
rows and 4,269 star inequalities. Its 13,393 variables and 55,984 rows replay
independently. A complete fresh separation cohort finds 1,416 star cuts and
24 feasible individual flows; the 22 conditional rank endpoints give seven
exact mixtures and fifteen rank violations, with no capped endpoint. The
24 raw/closed rank rows are independently checked. These findings reject
that allocation only. The 577-file closure is recorded in
`two-basis-results/joint-general-refine1-separation-point22-inventory.json`.

## Complete flows for four overlapping probes

The next extension chooses X614/X281/Z51/Z83, which form a physical K2,2.
It introduces a single conditional pairing variable for every physical
edge and anchor pattern. Overlapping stars share that variable. Distinct
physical edges are kept distinct even when symmetry identifies their
unconditional target coordinate. All sixteen patterns are retained.

The full system enforces nonnegativity, both marginal upper bounds,
Fréchet lower bounds, physical anchor-forced zeros, every selected star's
conditional row total, and every involved edge's unconditional moment.
These constraints describe the entire transportation feasibility problem
for each chosen star, with additional shared-edge consistency. The source
proof and a generic strictness example are in `OWNER-STAR-FLOW-PROOF.md`
and `OWNER-STAR-EXTENSION.md`; the example is not a C16 frame or exclusion.

There are 568 physical edges, four shared edges, 9,088 new variables and 2,994
structural-zero cells. Including all accumulated cuts gives 22,481 variables,
97,402 rows, 5,554 rank rows and 5,685 earlier star inequalities. Independent
preparation replay checks every LP token and physical row, plus positive
tiny frames and corrupted controls. The first exact SoPlex trial reaches
its 120-second internal cap, taking 128.21 seconds externally and about 344 MB
sampled peak memory. It supplies no rational endpoint or proof.

An additional ownership constraint prevents two chosen probes from spending
the same unchosen vector's mass: the sum of their shared edge variables is
at most that vector's conditional selection mass. There are 74 relevant X
vertices and nine relevant Z vertices, adding 1,328 rows across 16 patterns.
This capacity extension is independently checked against the unchanged
parent model and 5,898 tiny matching-capacity checks.

## Exact reduction and accepted endpoint

Under the explicitly pinned law, patterns 7, 11, 13, 14, 15 have zero mass.
Every allocation and joint probability in those patterns is therefore zero.
Other joint variables have explicit structural-zero bounds. The presolver
records original-row lower and upper proofs for every omitted probability,
and the five explicit equations for omitted high moments. It never discards
an unproved coordinate or relaxes a source row.

This removes 9,858 of 22,481 variables, leaving 12,623. Of 98,730 full rows,
64,697 remain nonconstant, with 330,258 nonzero coefficients instead of 690,744.
The other 34,033 rows become exact valid constants. An independent consumer
reconstructs all zero proofs, the complete variable partition, every reduced
LP token, and positive/negative residual lifting controls. This is an exact
size reduction for the chosen law, not a reduction of the 405-case cover.

The reduced capacity model reaches an exact objective-zero solution in 25.18
seconds externally, with about 365 MB sampled peak memory. This is not a
controlled speedup comparison with the earlier trial, since the capacity
rows were also added. All 9,858 omitted coordinates are restored as exact
zeros, and all 98,730 original rows pass exact reconstruction.

A separate consumer accepts the full endpoint without relying on the
presolver's internal reasoning. It checks all 22,481 parameters, 7,200 target
equations,23,040 allocation coordinates,5,554 rank rows,5,685 star rows,
9,088 joint cells,64 selected-star rows,568 edge totals and1,328 capacities.
Eight corrupted endpoints are rejected. Parameter denominators have up to
1,242 bits; no floating rounding is used in acceptance.

The exact certificate is
`two-basis-results/joint-owner-capacity-zero-face-point22-exact.json`.
Its independent endpoint receipt is
`two-basis-results/joint-owner-capacity-zero-face-point22-exact-independent.json`,
SHA256 `e7f1cb21edac11e40dd8b7fb9f21e8857eba9a94f0d0686e4582a92a2d4d52b4`.
The similarly named receipt without `-exact` verifies the reduction, not
the final endpoint; both immutable files are retained.

## What this closes and what remains

This particular finite shared-flow/capacity relaxation is exactly feasible.
Neither its source law nor the global moment point is excluded. It still
omits most complete owner stars and most conditional rank inequalities.
The completed 22-case membership cohort takes 98.36 seconds: both sectors
have exact full-basis mixtures at patterns 0, 2, and 4; the other sixteen
sector-pattern allocations have independently checked rank obstructions.
No endpoint is capped. The 22 raw/closed rank rows are retained for a future
refinement; no successor solve is implied by this check. A sharper local rank test will retain the actual saved owner
flows when splitting a conditional opposite basis into selected-probe and
residual parts. Any new cut must be independently reconstructed and then
added to the model before a stronger feasibility or exclusion claim.

All computation uses verified niceness 19 and one-thread numerical-library
settings, following the user's continuing preference. The eight-hour block
still ends at 22:38:33Z, with final preservation beginning 22:08:33Z.
