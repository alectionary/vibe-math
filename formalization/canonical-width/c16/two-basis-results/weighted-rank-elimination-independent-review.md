# Reasoning-only review of local weighted-rank elimination

This review concerns the weighted-rank section of `CONDITIONAL-OWNER-LIFT.md`.
It uses mathematical reasoning only. No model, solver, import, numerical test,
or physical-domain computation was run.

The argument is sound with the following conventions made explicit.

For each feasible domain, use the **effective owner bins after forcing**.
A forced unit-signature owner reduces its bin to that singleton; competing
indices of the same signature become loops. The singleton is a coloop of the
auxiliary direct-sum matroid. Keeping the original unrestricted signature
class would be incorrect: a rank-one component on `{u,v}` would allow replacing
the forced owner `u` by `v`. The existing domain routine's `fixed or candidates`
convention implements the required reduction.

The zero component is the physical zero matroid contracted by the entire
forced zero set F. Reintroduce those forced indices as independent coloops.
Together with the effective rank-one owner components and forbidden loops,
this gives exactly the allowed domain bases. Thus

    r(S) = |S intersect F|
           + rank_physical(F union (S intersect zero_free)) - |F|
           + number of effective owner bins intersecting S

is the correct auxiliary matroid rank. It is not a claim that this rank equals
the physical vector rank on every subset of the full pool.

Assume explicitly `0 <= a <= lambda`. Both feasible domain matroids have rank
128, and every probe-selected basis is an original-domain basis. Every
independent set of the selected matroid extends to one of its bases, hence to
an independent set of the original matroid. Therefore `r1(S) <= r0(S)`.

For nonnegative weights a and lambda-a, their weighted rank sum is a normalized
monotone submodular function. It need not be an integral matroid rank function.
The stated signed greedy support formula includes the necessary final term
`c_n*r(E)` and is valid for arbitrary real objective coefficients. It is linear
in the rank function, proving

    a B(r1) + (lambda-a) B(r0) = B(a*r1 + (lambda-a)*r0).

Zero weights cause no difficulty. An empty selected domain has no rank function
of the required type and must instead impose a=0. An empty original domain
would similarly require lambda=0; the current original domains are feasible.

For S contained in the probe's pairing-one neighbors, the selected domain has
at most one independent element in S: only its probe-owner bin can survive
there. Thus r1(S)<=1. The difference between the split-rank left side and the
displayed plain-star left side is

    (|S|-r0(S))*(lambda-a) + (1-r1(S))*a >= 0.

This is a correct dominance statement for that local subset inequality. It
does not dominate the full owner-star transportation system with prescribed
cross-pattern T marginals.

## Two-pattern counterexample to the broader interpretation

Take two patterns with lambda1=lambda2=1/2 and a1=a2=1/4. On a two-element
ground set use r0=r1=U(1,2) in both patterns, and choose

    z1=(1/2,0),  z2=(0,1/2).

Every local weighted-rank inequality holds, and each local decomposition
exists. Prescribe the cross-pattern marginal T=(1/2,0). Its total equals
a1+a2, and the unconditional Fréchet bounds hold since the probe marginal
and both ground-element marginals equal 1/2.

Nevertheless, selected/residual boxes force

    w1=(1/4,0),  w2=(0,1/4).

Their sum cannot equal the prescribed T. The owner-star transportation system
therefore rejects while every local weighted-rank condition holds. This is
not a counterexample to the note's expressly local elimination claim; it
explains why the omitted cross-pattern equations must remain separate.

No integrality, polynomial-time algorithm, full-frame membership, or source
exclusion follows from this review.
