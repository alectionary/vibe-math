# Same-code, degree- and girth-preserving feasibility

This is a finite representation check, not another decoding-performance run.
Keep both existing exact `[[252,10,10]]` CSS codes, H_Z, physical coordinates,
one-sector Bernoulli channel and the original minsum.cpp decoder/settings.
No new channel errors, candidate codes or decoder parameters are selected.

Enumerate all unordered pairs of original H_X checks and their Tanner
distances. A preliminary distance scan found fourteen pairs at distance eight
for each code. Test every such pair. Replace the two rows by their XOR at the
first row's position and remove the second; retain every other row unchanged.
Verify disjoint supports, equality of binary row spaces in both directions,
CSS orthogonality, unchanged column degrees (all three), connectedness and
girth exactly eight. Record check count, row degrees and edge count as well.
Do not silently require 126 checks: this intervention has 125 checks, one of
weight twelve and 124 of weight six. If check count were fixed too, the
earlier minimum-weight census creates a separate obstruction.

The fourteen pairs in each code are cyclic translates. Verify the complete
translation action on the original rows, pair orbit, modified row sets and
absorbing supports. Count all four-variable absorbing supports for the
lexicographically first pair of each code using both previously independently
validated complete algorithms: all quadruples, and co-neighbor matching/star
enumeration. Prove orbit coverage computationally before using representative
counts for the remaining pairs. These are all degree-three, girth-eight
graphs, so the same (4,4) support class is compared.

Independently enumerate all shortest length-eight paths between the merged
checks in the original graph. Verify that their variable supports are exactly
the absorbing supports gained by the intervention, with none lost. Retain
the labeled paths as witnesses. Check this set equality rather than assuming
cycle multiplicities are automatically support counts.

Run only deterministic decoder compatibility controls at p = 0.04, alpha 0.8,
100 iterations: zero error, all single errors, one stabilizer, one known
logical operator and a fixed selection of low-weight errors. Compare selected
outcomes to direct Python message equations and score with unchanged H_Z.
Such controls are not a performance comparison and cannot establish a count
effect. A fresh paired performance study would need its own frozen protocol.

State the exact scope: this preserves code, variable degrees and girth, but
changes check number, check degrees, cycle counts and message topology. It is
a stronger controlled intervention, not a pure intervention on a scalar count.
