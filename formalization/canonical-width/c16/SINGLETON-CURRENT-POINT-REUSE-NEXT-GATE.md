# Reusing singleton archives at the current point

No broader cohort has been launched. Orbit 40 at point 22 now has an exact
selected-conditioned membership certificate. Orbit 15 is a separately
authorized calibration. Its outcome should determine the next batch budget.

All 45 point12 numeric archive files exist. The sampled archive sizes are 264
columns for orbit 0, 1,245 for orbit 6, 1,945 for orbit 17, and 383 for orbit 40.
Some exact refinement outputs also contain additional physical zero bases.
These files offer reusable geometry; their old weights, residuals, lattice
arguments and membership conclusions do not transfer to point 22. The current
archive adapter expects a fresh-target partial-state receipt, so legacy reuse
needs a new geometry-only input adapter and consumer. It must explicitly bind
the old archive provenance separately from the fresh target; passing the old
point metadata unchanged would be invalid.

The cheapest prospective path is:

1. Freeze one current point and a declared archive cohort. For each anchor,
   independently rebuild the physical zero pool, verify each retained basis
   has rank127 and zero pairing, and deduplicate the columns. Recompute all
   current conditional targets `T/p` and the unit-owner simplex exactly.
2. Audit missing positive coordinates and universal coordinates with target
   below one before any LP. Add deterministic exact greedy coverage/omission
   bases. If an omission is impossible, directly test the resulting literal
   physical rank inequality; never label this merely an LP failure.
3. Run exact fixed-archive reweighting. A rational primal is accepted only by
   physical basis replay and exact equality of all720 conditional marginals.
4. If the archive is exactly infeasible, price its Farkas direction once over
   the full zero matroid by signed greedy. A globally valid direction yields
   a literal violated prefix rank, followed by the unchanged rank consumer and
   owner-row compiler. Otherwise the result is only a missing column.

Start with one LP and one pricing per anchor, with a common hard cohort budget
and a stop at the first independently accepted global cut. Reserve longer
column generation for cases justified by the two fresh calibrations. Avoid a
new60-second push-relabel run on every anchor merely to regenerate columns.
Orbit40 needed only one new column, but exact reweighting took43.5 seconds and
produced961-bit weight denominators; archive size alone is not a runtime
predictor.

For a future generic adapter, zero-probability conditioning is vacuous only
after checking all corresponding T entries are zero. Positive probability,
including probability one, permits division. A zero pool of rank below127
should trigger a directly checked rank obstruction when the required target
mass is127, rather than silently aborting or changing the domain. No such
boundary case arose in the completed orbit40 gate.

Every accepted result remains tied to its exact point. A later global-point
update requires fresh targets and fresh exact replay. This selected-T family
does not settle absent conditioning, S laws, common-profile coupling or source
frame existence.
