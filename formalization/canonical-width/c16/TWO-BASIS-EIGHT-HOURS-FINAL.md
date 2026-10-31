# C16 eight-hour continuation: results and remaining gap

The original question is still open: the unrestricted canonical width is 16
or 18. The sufficient selected-pair cover remains 405, the best verified physical
partial frame remains 88/128, and zero complete source anchors have been excluded.
No new Lean completion is claimed.

This is the continuation authorized for 30 October 2026, 14:38:33Z–22:38:33Z.
The work branch is `research/c16-two-basis-20261030T1438`; its starting scientific
checkpoint is `415591d389683e145ced12c2a399c3911ec834a7`. The first report
[records the earlier gates](TWO-BASIS-EIGHT-HOURS.md), and the
[owner-flow supplement](TWO-BASIS-OWNER-FLOW-RESULT.md) records the exact shared
capacity model. This document distinguishes source progress from auxiliary
model reductions and completed necessary-condition tests.

The user lifted the temporary Mac resource restriction. Computational workers
continued with verified niceness 19 and one numeric thread. The final SoPlex
gates had explicit wall-clock and memory limits; other bounded Python pilots
used their stated time or basis caps. A solver status alone was never accepted
as a mathematical result.

## What changed

The strongest saved global necessary-model point is still point 22. It passes
all seven exact screens with 54 partner, 990 integer-form and 308 conditional-rank
rows, together with the older families and complete Boolean-triple checks.
The block began with 234 added integer-form rows. The stronger system remains
feasible; these additional rows have not eliminated a complete source case.

An exact zero-face argument reduced the pinned shared-owner capacity LP from
22,481 to 12,623 variables. Its accepted feasible endpoint was checked against
all 98,730 original rows, including 5,554 listed ranks, 5,685 star inequalities
and 1,328 owner capacities. This is a 44% reduction in this auxiliary model's
variable count, not a reduction of the 405-case source cover. A fresh 22-case
conditional separation cohort gave six exact physical mixtures and sixteen
rank obstructions to that particular allocation. Those obstructions were
saved; their simultaneous repair is not claimed.

The [fixed-owner residual theorem](OWNER-FLOW-FIXED-NEIGHBOR-RANK.md) retains
the actual owner distribution when splitting selected and residual basis laws.
Tiny exact controls demonstrate that this is stronger than separately checking
the two marginals. Its single physical pilot, pattern 2/X614 on the Z side, has
an independently verified 680-basis colored decomposition matching all 721
coordinates, including the dummy coordinate. This proves a precise local
feasibility barrier, not a source obstruction.

At the current global point, [orbit 40 has a complete selected-conditioned
opposite-sector T basis law](singleton_global_point22_o40_membership.md). The initial
saved archive omitted one positive target coordinate. Adding one exact greedy
coverage basis made the 3,068-column master feasible. Its 624 positive physical
rank127 basis weights, together with 96 unit probabilities, match all 720
conditional marginals exactly. The unchanged literal terminal checker accepts
the result. This settles that entire necessary rank family for this orbit and
point; it does not supply compatible laws for all other anchors or a full frame.

Orbit 15 did not close. Twenty exact archive/pricing rounds and a separately
checked 64-exchange batch each ended with a missing valid physical basis.
Restricted-archive infeasibility was never promoted to a source rank cut.
The new [phase-I formulation](SINGLETON-PHASE-ONE.md) replaces arbitrary-scale
Farkas rays with a bounded dual and the exact L1 distance to the saved basis
hull. In one matched trial, 65 justified new columns changed that optimum from
approximately 0.86866010 to 0.83757010, a 3.579% decrease. The two exact solves took
34.66 and 34.12 seconds. The final full-domain greedy gap is negative, so neither
membership nor a global rank obstruction follows. No convergence or finishing
time is inferred from this one comparison.

Historical basis geometry can be reused without transferring old weights or
membership claims. The [orbit32 calibration](SINGLETON-GEOMETRY32-RESULT.md)
independently rebuilt 203 physical bases and all 720 fresh target marginals.
Its one exact master was infeasible; one full pricing call produced a missing
basis. The outcome is inconclusive, but avoids regenerating valid geometry.

## A missing compatibility condition and its exact local test

A [conditional Boolean union inequality](OWNER-K22-CONDITIONAL-PAIR-LAW.md)
rejects the saved capacity allocation by approximately 0.00090932224. It couples
the selected patterns to the global same-sector moment of X614 and X281.
Independent literal truth checks and exact physical/index replay accept the
row. Its origin is a Boolean identity, not a new rank theorem. It rejects the
supplied auxiliary allocation; it does not by itself reject point 22.

The targeted [global eight-event test](GLOBAL-EIGHT-PROBE-GATE.md) makes that
distinction concrete. All 256 assignments of the old anchor quad and the four
owner probes were inspected. Physical independence and selected cross-degree
at most one retain 152 states. One exact LP produced 37 positive atoms matching
all 37 first/second-moment features of point 22. Thus the conditional obstruction
can be repaired when the eight-event allocation is free. This is an exact local
law, not a joint distribution on full source frames.

The final coupled extension is also exactly feasible. It retains all original
owner-capacity constraints while sharing the eight-event law through the same
conditional variables. Thirty-two new same-sector pair masses supply 112 atom
inequalities, two global moment equations and 24 forbidden-atom equations.
Keeping these last equations matters: two individually admissible probes can
otherwise compete for one old mandatory owner.

One exact solve took 28.72 seconds and about 333 MB sampled peak memory. The
unchanged parent consumer checked the reconstructed 22,481 old parameters;
the new consumer checked all 176 conditional atom slots, their 24 forbidden
zeros, 138 additional rows and all 37 global eight-event features. There are
47 positive global atoms. The combined endpoint has 22,513 full parameters
and 98,868 checked rows, still with the chosen zero-high law pinned. It proves
feasibility of this stronger finite model, not membership in every conditional
rank family or existence of a source frame.

## Verification and preservation

Checkpoint `b6ed9a0db40ec431d706fcd9f68ffa5e93e44e89` passed 34 independent
owner-flow, capacity, face-reduction, conditional-rank, fixed-owner and orbit 40
terminal stages from an isolated declared copy. All 1,449 copied files matched
both their frozen hashes and Git blobs. The path adapter preserved every
original read/hash helper body, explicitly relocated recorded paths, denied
outside-copy research reads, and verified unchanged source bytes. All 34 stages
passed in 83.91 seconds with zero reads of original research inputs.

Four current canonical validators also passed from a fresh Git archive of that
checkpoint. The historical `validate_difficulty.py` related-ID equality failure
was reproduced and preserved; it is not counted as a pass. The exact replay
scope and logs are in the
[clean-checkpoint inventory](two-basis-results/final-clean-checkpoint-b6ed9a0-inventory.json).
Checkpoint `45873144ca36684562c235fc68db41c0b06a95c3` then passed a separate
14-stage supplemental replay in 39.11 seconds. Its 2,060 declared files
(836,860,691 bytes) matched their hashes and Git blobs. The isolated replay
checked both orbit 15 phase-I endpoints and their exchange batch, the orbit 32
geometry gate, Boolean union and eight-event laws, the complete coupled
capacity endpoint, and the preparation-only shared-basis seed. It made zero
original-input reads, preserved source/copy bytes, and ran no optimization.
The [supplemental inventory](two-basis-results/final-supplement-checkpoint-4587314-inventory.json)
records its distinct scope; the stage counts are not counts of solved questions.

Known failed, capped and rejected attempts are retained, including the first
unreduced owner-flow timeout, orbit 15 round cap, exact restricted-archive
infeasibility results, a parser rejection of SoPlex's distinct dual footer,
and the subsequent narrowly versioned parser repair. Frozen source files and
historical evidence were not overwritten to make checks pass.

Literature accounting remains 430 canonical entries, 161 eligible targets,
213 paper records, 170 full-text screens and six completed Lean targets.
The central ledger contains 141 records and 140 distinct IDs because of a
pre-existing duplicate. The dated literature notes preserve the full-text and
authenticated-X coverage limits. No new mathematical-priority claim follows
from these counts.

## Route to an answer

A width 16 result still requires 128 physically checked paired vectors with
Gram identity. A width 18 result still requires a complete obstruction covering
all source frames, with all source-to-pool and symmetry bridges retained.
More exact local mixtures do not meet either endpoint.

The next useful computational gate must preserve joint compatibility and have
a direct outcome: either a full-frame construction, a complete source-case
exclusion, or a globally projected necessary inequality followed by a checked
solve of the strengthened global model. The completed orbit 40 and eight-event
laws identify specific weaker families that cannot separate point 22.

A promising implementation is a shared basis-column master. Keep the owner
flows and eight-event variables, and link each conditional allocation to a
nonnegative weighted mixture of full physical bases. Its complete domain-rank
conditions are then enforced by construction. For every master dual, a new
basis column has a constant mass cost plus a linear sum of vector costs, so
the already validated signed matroid oracle can price the entire basis domain
without enumerating its bases. This reuses existing mathematics; the change
is retaining the shared couplings in the exact master. Stronger source caps
and nogoods must remain, since ordinary matroid rank does not subsume them.

The [next gate's starting certificate](SHARED-BASIS-PHASE-ONE-SEED-RESULT.md)
is already prepared and independently checked: 22 valid full physical bases,
ten zero-mass blocks and 23,040 exact allocation-link equations. Each positive
block uses the best single basis for its fixed allocation, verified by 13,454
signed prefix ranks. The artificial L1 errors total about 289.056; they remain
explicit. This is a feasible initialization for the proposed phase-I model,
not a solved shared master or a conditional membership certificate.

Before a contradiction can reject the global point, remove its dependence on
the five pinned law parameters. One route is to free them in the master; another
is an exact dual whose pin coefficients vanish. A third prepared route is the
[pattern-cost projection lemma](SHARED-BASIS-PATTERN-COST-PROJECTION.md): after
exact pricing and symbolic removal of pins, express the five higher joint
moments as sums of pattern masses and minorize the resulting sixteen pattern
costs by a quadratic Boolean function. This produces a necessary inequality
in the already recorded first and second moments. The algebra controls check
the actual model's moment map, signed toy pricing and six rejected mutations.
No actual C16 dual, minorant optimization or new separating row is claimed.
A complete source-case exclusion additionally needs a certified solve with
the global moments free and the correct case floor imposed. The phase-I method
supplies a better-defined diagnostic and a measured archive improvement, but
further batches need an explicit budget and a stopping rule; one 3.58%
improvement does not justify extrapolating a solution time.

## Deliverable accounting

| Requirement | Status | Evidence and remaining limit |
| --- | --- | --- |
| Proof or disproof of the source question | Partial | Width 16/18, cover 405 and physical 88/128 are unchanged; no complete source exclusion |
| Structural progress beyond exhaustive search | Met for the bounded gates | Fixed-owner residual theorem, exact capacity reduction, complete local laws, measured phase-I improvement, and prepared shared-basis projection |
| Independent verification | Met for declared scopes | 34-stage and 14-stage isolated replays linked above; historical pool/cover chains were preserved rather than rerun in full |
| Literature and question accounting | Met with recorded access limits | 430 canonical entries, 161 eligible, 213 papers, 170 full-text screens; dated ledgers retain unread full-text and authenticated-X gaps |
| Lean completion | Not completed | Six earlier canonical completions remain; this block adds none |
| Reproducible continuation | Met | [Resume guide](TWO-BASIS-RESUME.md), frozen inventories and explicit next-gate acceptance criteria |
| Publication to master | Pending required review | Existing [PR #17](https://github.com/alectionary/vibe-math/pull/17); the pushed research branch is a checkpoint |

Final remote readbacks and coordination-claim status are recorded in
[issue #8](https://github.com/alectionary/vibe-math/issues/8) and the local handoff.
The original research objective is unresolved; closing this bounded block is
not a user-requested pause.

**Question answered:** the stated finite capacity/eight-event model admits an
exact compatible allocation; orbit 40 at point 22 admits its complete
selected-conditioned opposite-sector T basis law.

**Question still open:** whether the source admits a full 128-pair width-16
frame, or every such frame can be excluded.

**Next proposed target — follow-up:** build and independently check one bounded
shared basis-column phase-I master, with full-domain pricing and exact
projection acceptance.
