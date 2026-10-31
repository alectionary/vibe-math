# A diverse negative-priced basis batch for orbit 15

The final orbit-15 ray at point 22 admits a batch of **64 new physical bases**
with **64 independent exchange directions**. Every new basis is on the same
minimum-cost face as the already certified minimizing basis, so its affine
ray value is the same strictly negative rational number. No new LP was run.

The input distinction is preserved: round 20 solved an archive of 3,160
columns, then discovered one additional minimizing basis. That 3,161st column
was not in a solved LP. The batch excludes all 3,161 existing/discovered bases.
Appending the minimizer and the batch to the last solved archive would give
3,225 distinct columns; feasibility of that enlarged archive is untested.

For a minimizing basis B, a fundamental exchange removes e and adds f. Its
exact cost is `u + v(B) + v(f) - v(e)`. The producer enumerates fundamental
circuits with high pivots and integer common-denominator costs. It retains
strictly negative new columns and sorts them by exact cost change, then
physical indices. A disjoint-set forest selects at most 64 edges.

The physical instance has 22,903 valid negative-cost exchanges, of which
3,163 have zero cost change. All 64 selected exchanges have zero change.
Their difference vectors are `e_f - e_e`. The selected edges form a forest,
and independent exact rational elimination confirms direction rank 64.
Thus the minimizing basis together with these 64 columns has affine
dimension 64. No increase in affine rank relative to the old archive is
claimed; the old archive may already span those directions.

The separate consumer reconstructs low-pivot circuits using ground-index
coefficients, checks the complete eligible-edge count, uses graph reachability
instead of the producer's disjoint-set routine, and checks every selected
physical rank, rational cost, and duplicate exclusion. It also checks 146
tiny basis/cost cohorts, 1,364 literal exchange ranks, 916 selected tiny bases,
signed and tied costs, loops, duplicate vectors, and 102-bit denominators.
A four-edge cycle has only rank three; four corrupted batch variants are
rejected.

The bank is `two-basis-results/singleton-o15-r20-negative-exchange-batch.json`,
SHA256 `f7ccb20acea3fc76dd0fc43381bcc2ff1fa4c399425aeaab54396e739dd8a857`.
The matching independent receipt reports
`PASS_EXACT_NEGATIVE_PHYSICAL_EXCHANGE_BATCH`. Producer and consumer took
approximately 0.29 and 1.25 seconds respectively, at verified nice19 and one
thread. The batch establishes valid, diverse pricing columns only: it proves
neither target membership nor a global rank cut.
