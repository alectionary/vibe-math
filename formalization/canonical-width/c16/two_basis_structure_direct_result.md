# Accepted direct Z count allocation at point15

The first reduced direct-allocation pilot recovered an exact feasible count/box allocation in 10.37 seconds. It uses the existing fixed nearest-pattern law for X anchors [80,512] and Z anchors [186,433]. This closes the Z count-allocation gate for that law. It does not yet establish the conditional zero-matroid rank inequalities or full auxiliary two-sector membership.

The model retains six pair-pattern allocations and derives the empty and singleton patterns exactly. After local forced-face elimination it has 3,901 variables, 10 global bucket equations, and 14,980 sparse box inequalities. No basis-column generation is used. Four additional forced coordinates come from exact tight local-zonotope facets. A maximum relative box margin is numerical discovery only.

The numerical candidate was converted to exact binary rationals, then a 10-by-10 rational correction imposed the pair bucket equations exactly. The largest parameter correction is

3764275272161 / 77371252455336267181195264,

approximately 4.87e−14. All 3,600 retained sector moments then hold by the exact pair-to-singleton/empty formulas and direct literal replay. The final normalized slack on all 7,490 coordinates not fixed by source geometry or a local facet is strictly positive; its minimum is

1384584377338662718437 / 2089438574432399694027743559680,

approximately 6.6266e−10, at pattern8/vector1. This is interiority relative to the specified count/box face only. It is not a rank-polytope interiority claim.

The independent consumer reconstructs the physical domain and owner-coordinate target without importing the producer. It checks all 3,600 feature equations, 11,520 boxes, 16 cardinalities, zero and owner bucket masses, 1,480 fixed statuses, the 11 low anchor equations, and all four exact tight-face witnesses. Three corrupted certificates are rejected. It does not rely on the numerical solver status for acceptance.

The recovered conditional selector marginals remain dense: most positive patterns have 717–718 fractional coordinates; pattern10 has 520. Conditional common denominators have 81–144 bits. Thus deletion of zero marginals and contraction of unit marginals do not provide a large automatic reduction for the next rank gates. The separate producer is checking small physical quotient flats before considering local matroid membership. Failure of one rank inequality would reject this allocation, not the fixed-pattern target; it would become a valid additional linear constraint for a future direct allocation run.

Frozen evidence:

* Producer `two_basis_structure_direct_allocation.py`: SHA256 `1e417c4dcd3c513ebd7c784dab673cec88da58d356270a25f5dfeee7f837fb72`.
* Frozen input/model summary `two-basis-results/two-basis-direct-Z-point15.frozen.json`: SHA256 `ec2a02eb30ef263e9217c727b1992b23fd36228fe796cf8b694bbceabed0a6dd`.
* Exact candidate `two-basis-results/two-basis-direct-Z-point15.json.gz`: SHA256 `1932ef3ef1771fcb97036de985f7ac8b5e2eac1a7406fc39761f3a69806da07a`.
* Independent receipt `two-basis-results/two-basis-direct-Z-point15-independent.json`: SHA256 `331e8503127077b7ffb628f739d161e00c1139f8ed0bb2eff736d15a3edc109e`, status `PASS_EXACT_DIRECT_PATTERN_COUNT_ALLOCATION`.

No second-sector direct LP was run under the one-pilot authorization. No source case is excluded, and the source width/cover question remains open.
