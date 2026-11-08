# Shared basis master: checked model, full pricing and negative projection

The shared master is built and independently checked. Full-domain pricing and
exact owner projection also completed. The resulting necessary inequality is
valid but does **not** separate point 22: its exact gap is negative,
approximately **-12,146.42155**. No exact restricted phase-I optimum or zero-error
membership certificate was obtained.

The original source question remains width **16 or 18**. The sufficient cover
is still **405**, the best verified physical partial frame is **88/128**, and
**zero complete source anchors are excluded**. No new Lean completion is claimed.

This follow-up was authorized for up to two hours starting 30 October 2026 at
22:07:54Z, with deadline 31 October 00:07:54Z. It uses one immutable master,
not a column-generation loop. All computational workers used niceness 19 and
one numeric thread. The [frozen contract](SHARED-MASTER-TWO-HOURS.md) and
[solver diagnosis](SHARED-MASTER-SOLVER-DIAGNOSIS.md) retain the limits and failed
attempts.

## The model and what was checked

The master retains all 98,863 rows of the unpinned parent owner-capacity and
eight-event model. The five higher joint moments are free; no zero-face
elimination or saved-law pins are introduced. Each of the 32 sector/pattern
domains has physical basis columns, including the ten blocks whose saved
starting mass is zero.

There are **1,642 physical rank-128 basis columns**, **70,235 variables**,
**169,657 rows** and **1,057,219 nonzeros**. Historical membership archives
contribute geometry only; the separate accepted current-point phase-I seed
supplies the starting weights. The independent checker
reconstructs every source and linking row, verifies every physical basis,
parses the literal LP and checks the exact feasible artificial start. Its
initial error sum is approximately 289.05648. This is a feasible phase-I start,
not a solved membership problem.

The main inputs are [the manifest](shared-master-results/phase-one-v1.json),
[LP](shared-master-results/phase-one-v1.lp) and
[independent preparation receipt](shared-master-results/phase-one-v1-independent.json).
The LP SHA-256 is
`590102f60151d9baf6e24bc0b0dbef7813f98171027acedbd9c2a765d92d8658`.
The original point 22 remains unchanged, with SHA-256
`4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f`.

## Bounded solver outcomes

Two SoPlex attempts reached their limits. The first used no internal presolve;
the second enabled it after an independent tiny control. Neither supplied an
exact endpoint. The second also returned no floating primal or dual vector.
The first saved basis file is incomplete and cannot be used as a basis proof.
All raw files and logs are retained unchanged.

One final HiGHS candidate-extraction attempt used a checked floating view of
the same LP. The independent conversion gate compared every coefficient, row
bound, variable bound, objective coefficient and starting value against the
exact input. It also checked a tiny primal/dual optimum of 1/2. A checker
performance bug was repaired in a separate version; the original source and
stopped attempt remain preserved.

The HiGHS run stopped before 22:56Z after about 83.49 seconds total, using
351,272,960 bytes maximum sampled RSS. Its provisional objective was
64.9316395, and it supplied complete named numerical row weights. Neither that
objective nor its primal/dual availability flags are exact feasibility or
optimality certificates. The [outcome record](shared-master-results/producer-solver-outcome-v1.json)
contains all attempts, limits and measurements.

## Exact projection without assuming an optimal dual

The [pattern-local bound certificate](SHARED-MASTER-PATTERN-LOCAL-BOUNDS.md)
proves `0 <= v <= lambda[m]` for every one of the 22,508 non-tau parent
variables using 45,016 explicit nonnegative combinations of source rows.
The remaining five coordinates satisfy the higher-joint-moment identities
`tau[h] = sum(lambda[m] : m contains h)`.

The numerical row weights were converted to exact rationals and used only to
select a new source-row combination. Parent inequality multipliers were made
nonnegative explicitly. Every uncancelled variable coefficient was retained.
A residual `r*v` is bounded below by `min(0,r)*lambda[m]`; higher-moment
residuals are distributed to all containing patterns. Artificial link errors
are set to their source value zero, not treated as probabilities.

The independent consumer reconstructed the source combination, replayed all
45,016 probability-bound witnesses, and checked all **32 full physical domain
minima** using **18,424 signed prefix ranks**. This prices the full domains
without enumerating all their bases. The result has 18,729 nonzero non-tau
residuals, five higher-moment residuals and 10,513 clipped source inequality
weights. These substantial corrections explain why the interrupted numerical
candidate should not be treated as an approximately certified dual.

One exact 16-atom LP then optimized the quadratic pattern-cost minorant subject
to all eleven recorded low moments. An independent checker verified all 27 LP
rows, exact primal/dual equality, all sixteen minorant inequalities, the
factor-one physical owner mapping, and positive integer normalization.
The final row has 5,273 nonzero owner coefficients and maximum coefficient
size 109 bits. It is not inserted into the existing signed-64-bit row bank.

Its exact target gap is negative (approximately -12,146.42155), so no new
separating row is accepted. This also settles the best quadratic minorant for
this fixed corrected pattern-cost vector: optimizing that minorant does not
rescue the candidate. Stronger joint residual bounds could give a different
cost vector. The result does not settle the shared master,
other source combinations, or the original question.

The [pricing receipt](shared-master-results/phase-one-v1-residual-pricing-v2-independent.json)
and [final projection receipt](shared-master-results/phase-one-v1-residual-projection-independent.json)
record the exact arithmetic. The latter has SHA-256
`cad693ff8753f95717f888c7c153b39205e007dc6ac69a3f6476310a3a8a5a56`.
The original exact-optimality consumers and unused SoPlex-decimal path remain
separate, preserved and unclaimed as executed results.

## Independent checkpoint replay and scope

Checkpoint `3129963fcac399fe3422429aeed7247dbc2c9dd1` passed five new gates from
an isolated declared copy: master preparation, probability bounds, numeric
conversion, full residual pricing and final exact projection. All **2,164
input files**, totaling **866,710,319 bytes**, matched both SHA-256 hashes and
Git blobs. Replay took 41.83 seconds. It made zero original research reads,
ran no solver, and left all source and copied input bytes unchanged. Explicit
path relocation preserved the original helper bodies. The worker denied
process creation and input mutations; rejection controls checked that boundary.
The [replay summary](shared-master-results/clean-replay-3129963.json) and
[preserved logs/receipts inventory](shared-master-results/clean-replay-3129963-inventory.json)
record its precise scope.

| Requirement | Status | Evidence or limit |
|---|---|---|
| One bounded shared basis master | Met | One immutable LP, all 32 domains, 1,642 checked physical columns |
| Independent exact model and seed check | Met | Preparation receipt and clean replay |
| Exact restricted optimum or zero-error membership | Partial | Bounded attempts did not supply one |
| Full-domain pricing | Met | All 32 minima independently checked |
| Exact projection acceptance | Met | Valid necessary row; negative gap correctly rejected as a separator |
| Reproducible preservation | Met | Git-verified isolated replay and retained failed attempts |
| New literature/author-posed targets/Lean results | Not applicable | No new source or target; all canonical count deltas are zero |
| Publication on master | Pending review | Existing PR17 requires one approving review |

The canonical `literature/` and `planning/` files are unchanged from the
starting checkpoint `64fac577`. Prior dated search/access limitations and the
previously recorded difficulty-validator issue remain in the earlier reports;
they were not silently converted to new coverage or passing checks.

## The next bounded follow-up

A concrete [dual-feasible starting basis](SHARED-MASTER-DUAL-START.md) is now
proved for this exact LP. Its block-triangular basis matrix is unimodular;
the initial dual is -1 on error-nonnegativity rows and zero elsewhere. This
gives an exact lower bound of zero and a valid dual-simplex start. Two
independent algebra reviews agree. Its performance has not been tested.

The next useful trial is to export and check that basis, then run a bounded
dual-simplex solve on the unchanged master. Preserve the basis and both
vectors at the stop. Accept an exact endpoint or a source-valid positive
full-domain projected gap; otherwise record the actual dual residuals and
stop. Do not enlarge the archive merely because a provisional cost is
negative, or infer a convergence time from the numerical objective decrease.

**Question answered:** this bounded master is faithfully built; one actual
full-domain source combination and its optimal fixed-cost quadratic projection are
independently checked and nonseparating.

**Question still open:** exact shared-master membership/optimum, and the source
width-16 construction or complete width-18 obstruction.

**Next proposed target:** follow-up using the proved exact dual-feasible start,
with a fresh explicit runtime budget and the same acceptance gates.
