# Review of the conditional owner lift

This is a reasoning-only review. No solver, algorithm prototype, or source
exclusion is asserted. The source implication in `CONDITIONAL-OWNER-LIFT.md`
is valid: split the conditional Z basis law according to whether the additional
X probe is selected. The two masses are `a` and `b=lambda-a`, and their sum is
the existing conditional allocation `z`. Zero masses mean zero vectors; an
empty selected domain forces `a=0`.

## Exact local elimination

For normalized submodular rank functions r1,r0 and nonnegative a,b,

`a B(r1) + b B(r0) = B(a r1+b r0)`.

One proof compares support functions. For any real weight vector, order the
ground elements by that vector. The greedy support formula for a base
polyhedron is linear in the values of the defining submodular function along
that ordering. Hence the support function on the right is the sum of the two
scaled support functions on the left. These compact convex polytopes are equal.
This argument includes negative objective coefficients and zero scale factors.

Consequently, if the cross-pattern equations `sum_m w_m=T` are temporarily
omitted, a selected/residual decomposition exists exactly when

`z(E)=lambda*128`, and
`z(S)+(r0(S)-r1(S))*a-r0(S)*lambda <= 0` for every subset S.

Here each rank is that of the full domain matroid, including forced coloops,
deleted/forbidden loops, the contracted zero matroid, and owner-bin parallel
classes. Bare physical vector rank without these modifications is insufficient.
The selected domain's bases are a subset of the original domain's bases, so
`r1(S)<=r0(S)`. This inequality is not needed for the Minkowski identity, but
it explains the nonnegative coefficient of a in the split-rank row.

For an owner-neighbor subset J, `r1(J)<=1` and `r0(J)<=|J|`. The split-rank
bound is therefore at least as strong as
`z(J) <= a+|J|*(lambda-a)`, the ordinary summed Boolean owner-star bound.
This is exact dominance because both a and lambda-a are nonnegative. One must
also retain selected-domain rejection cases rather than assigning them a
fictitious rank128 matroid.

## Colored basis exchange certificates

A bounded colored push/relabel prototype can preserve the same certificate
invariant as the single-matroid method. Keep separate basis collections for
M1 and M0, with nonnegative weights summing to a and b, respectively. Let x be
their weighted incidence sum. An exchange and basis split must stay within
one color; a basis identity includes its color even if the physical index
tuple happens to agree in both collections. A common exact denominator may
include the target, color masses, and initial weights.

Maintain nonnegative integer levels, with excess elements at level0, and the
fundamental-circuit level inequality for every active basis in its own
matroid. Suppose an empty level j separates an upper set
`S={e:level(e)>j}` containing a deficit. For an element s in S outside an
active basis, its circuit lies in that basis's intersection with S: circuit
members cannot be below level(s)-1, and no element has level j. Thus every
active color-t basis intersects S in a basis of its own rank-r_t restriction.
It follows that

`x(S)=a*r1(S)+b*r0(S)`.

There is no excess above the nonnegative empty level, and at least one deficit,
so `z(S)>x(S)`. The literal subset and two independently computed ranks give
an exact split-rank violation. This early cut need not maximize rank defect.
If instead x=z, the two colored mixtures explicitly supply the selected and
residual decomposition. Either endpoint has a direct independent consumer.

This argument establishes the endpoint invariant, not a runtime or termination
bound for a modified implementation. The original scan/amortization analysis,
label caps, basis growth, and numerical resource costs do not transfer merely
because the exchange proof looks similar. A future bounded prototype needs
exhaustive tests with genuinely different color matroids, zero color masses,
loops/coloops, non-dyadic weights, same index tuples in different colors, and
mutated color labels/ranks/weights. No such prototype was run for this review.

## Why the retained-w model is not automatically a generalized polymatroid

At fixed z, the residual constraint is indeed another base-polyhedron
constraint. For `g(S)=z(S)+b*r0(E\S)-b*r0(E)`,

`z-w in b B(r0)` is equivalent to `w in B(g)`.

The local feasible w set is therefore the intersection of two base
polyhedra, not automatically one base polyhedron. Cross-pattern T totals add
a further partition system. Merely counting these as two matroid families
does not prove a submodular-flow reduction or an integrality theorem.

A concrete obstruction to the automatic generalized-polymatroid claim already
occurs with M1=M0. Let M be the graphic matroid of K4, take a=b=1, and let z be
one on each of its six edges. Then

`C=B(M) intersect (1-B(M)) = B(M) intersect B(M*)`.

Its integral members are spanning trees whose complements are spanning trees:
exactly the Hamilton paths. This family is not the bases of a matroid. Every
pair of edges extends to a Hamilton path, so the excluded star
`{12,13,14}` and excluded triangle `{12,13,23}` would be minimal circuits.
Eliminating their common edge12 would require a circuit in
`{13,14,23}`, which is itself the Hamilton path `4-1-3-2`. This contradicts
circuit elimination. Standard two-matroid intersection gives an integral
polytope here; a constant-cardinality generalized polymatroid within the unit
box would instead have a matroid base family. Thus C is not one.

This example does not prove that the special C16 domains admit no more
elaborate submodular-flow representation. It shows that such a representation
needs an additional theorem; it cannot be inferred from the two displayed
base constraints. General separation with exact rank oracles remains valid,
and the local Minkowski elimination remains valid, regardless of this issue.

For a primary reference on the missing hypothesis, Takazawa–Yokoi explicitly
require a paramodular cross inequality and distinguish intersection integrality
from being a generalized polymatroid; they also give an incompatible matroid
example. See their [2019 paper, Sections2.2,3.1,4](https://arxiv.org/html/1805.05528).
This was a targeted technical consultation, not a completed open-question
screen or an assessment of current resolution of its conjectures.

The local colored-mixture test ignores prescribed cross-pattern T totals.
Successful local decompositions may choose incompatible w values across
patterns. Even a successful retained-w lift constructs only one probe's Z
laws, not a simultaneous law for every probe, a full X basis, or a source frame.
