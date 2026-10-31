# What the first full-partner separator uses

All comparisons below keep the accepted775 coefficients and their2^24 scale
unchanged. The exact support audit independently checks1,058,579 physical
prefix ranks. Global supports are:

| Allowed Z selection for each orbit32 mask | Support |
| --- | ---: |
| Any128 physical Z vectors |195223891|
| Any full physical Z basis |194996444|
| Any128 vectors with zero/unit evaluation signatures |82576227|
| Full basis of those eligible vectors, without unique owners |78173185|
| Exactly one vector per owner, plus128-k arbitrary zero vectors |47846162|
| Independent positive eligible hinges |131589216|
| Best separately computed singleton-anchor full-basis bound |146415320|
| One jointly compatible full Z basis |2155958|

Only the final support separates witness2. Its scaled exact gap is about
0.00132778190145. Joint support improves the singleton-envelope bound on289 of
291 phase classes. The globally tight class is P={0}; at that class every Z
vector is individually eligible, so the zero-pool rank and exactly-one-owner
conditions are directly responsible for the tighter bound.

The saved optimizing bases violate known Z orbit count caps in250/291 classes
and known forbidden Z pairs in92/291 classes. The tight P={0} optimizer has
7 vectors in orbit5, whose source cap is6, and contains two saved forbidden
pairs. This is a diagnostic of these particular optimizers; alternate optimal
bases were not ruled out by those counts alone.

## The underlying constraints

For independent selected X vectors P of size k, evaluate each Z vector on P.
A compatible full Z basis consists of a rank128-k basis of the zero-evaluation
pool and exactly one vector from each unit-evaluation bin. Its weighted support
is a signed greedy zero-basis support plus one maximum from each owner bin.

This description also follows from ordinary full-Z rank inequalities and the
k row-degree equations, provided they hold within the same P-conditioned law.
The zero pool has rank at most128-k, so at least k expected selected vectors
lie outside it. Summing the k row-degree equations gives exactly k nonzero
evaluation incidences. Thus no positive mass can have a signature of weight
greater than one; every unit bin has mass one and the zero pool has mass128-k.
The additional strength is a shared distribution conditioned on the entire
phase pattern. It does not use a new physical axiom.

## Exact singleton rank certificates

For one selected anchor X_a, write q_j=T[a,j]/p_a. The zero pool has rank127,
its q mass is127, and the unit bin has q mass1. A rational mixture of physical
zero bases, independently combined with the exact unit-bin probability law,
gives a rational mixture x of compatible full128 Z bases.

The producer first seeks x=q. When a small numerical corral fails this exact
equation test, it reports that failure. A separate exact Wolfe refinement can
instead establish the following elementary certificate. Choose integer D with
D*q_j integral for all720 coordinates and let

`epsilon = sum_j max(q_j-x_j,0)`.

If `D*epsilon < 1`, then for every physical Z subset K,

`q(K) <= x(K)+epsilon <= rank(K)+epsilon < rank(K)+1/D`.

The number `q(K)-rank(K)` is an integer multiple of1/D, so it is nonpositive.
This proves **all** singleton conditional cross-sector rank inequalities, not
just a finite screen. It does not claim that the displayed x equals q, and it
does not need the matroid base-polytope characterization or a new paper.

The independent consumer rebuilds the physical vectors, checks every rank127
zero basis, every rational weight, and the exact unit law. A unit vector has
anchor evaluation one and therefore lies outside the span of every zero
basis; every product component is consequently a full128 basis. Sector and
rotation maps are independently checked, extending an anchor-orbit result to
all16 phases. Five corruptions of each original singleton certificate are
rejected, including a forged lattice error.

- On original witness2,199 zero bases and198 unit probabilities certify every
  orbit32 singleton cross-rank inequality, with `D*epsilon` about0.71945.
- On accepted basis-witness5,141 zero bases and198 unit probabilities give
  `D*epsilon` about0.87913 for orbit32.
- The initial120-second witness2 L1 pilot remains preserved as inconclusive.
  Its failure is not an infeasibility or rank-completeness claim.

## The wider cohort found an ordinary missing rank row

A new fixed600-second cohort targeted accepted basis-witness5 and stopped at
the first exact cut after160.77 seconds. Of anchors0 through15, anchors
0,1,7,9,10,11 passed complete singleton cross-rank certificates; nine were
bounded inconclusive; anchor15 gave a violated rank row. The remaining29
anchors were not tested in that cohort.

The discovered subset has283 Z vectors and rank90. Its full physical span
closure adds one vector without increasing rank. Both the old independent
rank consumer and the independent closure/dominance consumer accept the row

`sum_{j in K} T[j%16;15,j//16] <= 90*p15`, with `|K|=284`.

The closed row has exact violations:

- witness2: `11456234516499/281474976710656`;
- basis-witness5: `46803586917557/1125899906842624`;
- accepted partner-witness7: `102455208981361/2251799813685248`.

Thus the orbit32 attribution is sharp, but it must not be promoted to a claim
that witness2 or witness5 satisfies every singleton rank law at every anchor.
The orbit15 counterexample disproves that broader statement. No full source
obstruction, full-frame mixture, or physical frame is certified here.

## A next conditional full-partner family

One possible degree-two extension fixes an opposite anchor Z_b as selected.
Use only the16 orbit-P indicators and720 Z indicators as features; their
conditional means are existing T and S moments divided by p_b. Do not include
P autocorrelations or P-times-Z features unless third moments are introduced.
For each allowed P, force b into the full Z basis: a multi-owner signature
excludes P; a zero signature contracts b in the zero-pool matroid; a unit
signature fixes that owner's choice to b. Remaining support is still exact
greedy plus owner maxima. Fixed anchor phase breaks the291-representative
shortcut, so all oriented masks or an equivalent anchor-phase indexed domain
must be covered. This is a proposed hierarchy step, not an implemented or
accepted new bank in this audit.

Repository searches found methodological mentions of matroid polytopes in
RESEARCH-LESSONS.md and MOMENT-RESUMPTION.md, but no primary reference for the
base-polytope theorem. The statements above deliberately avoid depending on it.
