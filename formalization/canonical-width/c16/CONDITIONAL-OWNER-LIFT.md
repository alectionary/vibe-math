# Extending one probe beyond the owner-star flow

This is a necessary relaxation for the original full-frame problem. It is a
proposed stronger gate after the conditional owner-star test; no feasibility,
infeasibility, or source exclusion is asserted here.

Fix the four existing anchors and their pattern `m`. Write `lambda_m` for the
pattern mass, `a_m = yX[m,i]` for one additional unanchored X probe `i`, and
`z_mj = yZ[m,j]` for the existing conditional Z allocation. Introduce

    w_mj = E[1_pattern(m) X_i Z_j]             for all 720 Z coordinates.

The retained cross moments require `sum_m w_mj = T(i,j)` for every `j`, not only
the pairing-one neighbors of `i`. These are exact equations before any division
by a pattern mass.

Let `B_m` be the convex hull of the allowed full physical Z bases for the four
anchors. Let `B_m^i` be the corresponding hull after adding `i` to the selected
opposite anchors. The selected and unselected parts must satisfy

    w_m             belongs to a_m B_m^i,
    z_m - w_m       belongs to (lambda_m - a_m) B_m.

For a zero multiplier, interpret the scaled hull as the singleton zero vector.
If the selected domain is empty, impose `a_m = 0` and `w_m = 0`.

The implication follows by conditioning an actual frame on the anchor pattern
and on whether `X_i` is selected. Every resulting Z basis has the specified
selected/deleted own anchors. When the probe is selected, every selected X
anchor, including the probe, has exactly one distinct Z owner. When the probe
is absent, its ownership imposes no condition on the Z basis. Averaging the two
finite basis laws gives the two scaled-hull constraints. Summing over patterns
gives the cross-moment equations.

Conversely, a feasible collection of these two-sector marginals need not be a
full-frame distribution. It only constructs compatible Z basis laws for this
one probe. Different probes may require incompatible joint choices; the full
X basis law and its other pairing relations remain relaxed.

The existing physical domain decomposition makes each hull explicit: a basis
of the zero-signature vector matroid after contraction by forced zero vectors,
together with one member from every distinct unit-signature owner bin. Thus
the scaled hull uses fixed/deleted coordinates, owner-bin and zero-pool counts,
boxes, and all contracted subset-rank inequalities. No enumeration of full
bases is required to state it. A numerical or finite-rank-row solution still
requires the existing exact matroid membership/separation checks.

The selected and residual boxes alone imply

    max(0, a_m + z_mj - lambda_m) <= w_mj <= min(a_m, z_mj).

For a pairing-one neighbor, selected ownership gives
`sum_neighbors w_mj = a_m`. A competing selected anchor forces the corresponding
edge to zero. Keeping only these coordinates and equations recovers the current
owner-star transportation test. The lift therefore retains that test and adds
all non-neighbor cross moments, the complete basis cardinality, the other
owner-bin equations, and the selected/residual matroid ranks.

A cheap first check is whether any augmented physical domain is empty. The
source implication is then the linear inequality `yX[m,i] <= 0`, valid for
every anchor law and every target. The bounded screen in
`probe_augmented_owner_domains.py` tests only positive coordinates of the saved
allocation, checks its domain routine against exhaustive dimension-three full
bases, and retains any domain rejection for independent replay. Failure to find
a rejection says nothing about feasibility of the proposed lift.

A future computational gate should select a small number of probes from the
verified star obstructions, construct the linear count/box version first, and
add independently accepted selected/residual rank rows. A source-moment cut
requires an exact dual combination that cancels every `w`, all allocation
variables, and all five free anchor-law parameters. Infeasibility with fixed
allocations has the narrower scope of rejecting only those allocations.

## Eliminating the split locally by a weighted rank function

The following derivation does not include the cross-pattern equations
`sum_m w_mj = T(i,j)`. It eliminates the split variable for a single pattern
exactly, giving a useful intermediate relaxation.

Every feasible physical sector domain defines a matroid on all 720 pool
indices. Its components are the zero-signature matroid contracted by the
forced zero vectors, the forced zero vectors reintroduced as coloops, and
one rank-one partition component for each owner bin. Forbidden indices are
loops. Its bases are exactly the allowed full physical sector bases. This
does not assert that arbitrary subsets of physical pool vectors have the
same rank as this auxiliary matroid.

For a subset `S`, the domain-matroid rank is explicitly

    r(S) = |S intersect F|
           + rank_physical(F union (S intersect zero_free)) - |F|
           + number of owner bins intersecting S,

where `F` is the complete forced zero set. The physical rank is computed
jointly with all forced zero vectors; deleting their individual ranks instead
would give an incorrect contraction in general. Owner bins here are the
effective bins after forcing: a forced unit owner reduces its bin to that
singleton, and the competing indices become loops.

Assume `0 <= a_m <= lambda_m` and both domains are feasible. Write `r0` and
`r1` for the original and probe-selected domain ranks. The
selected domain's bases form a subset of the original domain's bases, so
`r1(S) <= r0(S)`. Direct conditioning gives the valid split-rank inequality

    z_m(S) + (r0(S)-r1(S))*a_m - r0(S)*lambda_m <= 0.

When `S` consists of pairing-one neighbors of the probe, `r1(S) <= 1`. Since
`r0(S) <= |S|`, this strengthens the plain star inequality

    z_m(S) + (|S|-1)*a_m - |S|*lambda_m <= 0.

Indeed, the difference between the split-rank and plain-star left sides is
`(|S|-r0(S))*(lambda_m-a_m) + (1-r1(S))*a_m`, which is nonnegative on the
probability box. This is an algebraic dominance statement; no new source
instance has yet been evaluated with these stronger ranks.

Moreover, all the split-rank inequalities together with
`z_m(E)=128*lambda_m` describe the local decomposition exactly:

    a_m B(r1) + (lambda_m-a_m) B(r0)
       = B(a_m*r1 + (lambda_m-a_m)*r0).

One proof uses greedy support functions. Order the coordinates of any real
objective `c` in decreasing order, with prefixes `S_k`. The maximum over a
base polytope is

    c_n*r(E) + sum_{k<n} (c_k-c_{k+1})*r(S_k).

This expression is linear in the rank function, so the weighted sum of the
two compact base polytopes and the base polytope of the weighted rank have
identical support functions for every objective. The weighted rank is a
normalized submodular function, generally not an integral matroid rank.
Hence the compact convex
sets agree. Zero weights are covered by continuity or directly. An empty
selected domain is instead handled by the separate condition `a_m=0`.

The cross-pattern prescribed moments remain a further constraint. This
local weighted-rank characterization alone does not establish that the full
owner lift is a submodular-flow instance, an integral polytope, or a complete
description of full frames.

## The augmented domain is a particular matroid face

There is additional structure beyond arbitrary inclusion of two matroid base
sets. Assume the original domain is nonempty and every one of its bases is a
full physical basis. The probe must be a nonzero functional distinct from every
selected opposite anchor as a physical vector, not merely as a pool index.
Let `A` be all pairing-one neighbors of the probe and let `H=E-A`.

Every original full basis contains at least one element of `A`, since otherwise
the nonzero probe would vanish on a spanning set. Suppose a basis contains
exactly one, at index `j`. This owner cannot also own a selected old anchor:
the old anchor and the probe would then have identical unit evaluation rows
on a full basis, forcing the two physical vectors to agree. Consequently the
original bases containing exactly one element of `A` are precisely the
augmented-domain bases. Own forced/deleted statuses stay unchanged.

The minimum number of `A` elements in an original basis is `R-r0(H)`, with
`R=128`. Therefore the augmented domain is feasible exactly when
`r0(H)=R-1`. On this gate it is the minimum-neighbor face of the original base
polytope, with face matroid

    M1 = (M0 restricted to H) direct_sum (M0 contracted by H).

If `G=A-closure_M0(H)`, this gives the simpler rank formula

    r1(S) = r0(S intersect H) + 1[S intersects G].

Elements of `A` already in the closure of `H` become contraction loops. This
includes competitors for an old selected owner's bin. A forced zero vector
that pairs with the probe can instead become its unique owner. If
`r0(H)<R-1`, the minimum-neighbor face still exists but contains more than one
neighbor; it must not be identified with the empty augmented domain.

This is a source-domain characterization and potential rank-oracle
simplification. It is not a new exclusion result. The independent reasoning
review is `two-basis-results/probe-domain-exposed-face-independent-review.md`.

## Maximum local selected mass and an exact oracle bound

Assume `z` has already been certified in `lambda B(r0)`. Counts and a finite
collection of rank inequalities do not establish this prerequisite. For a
feasible selected domain define

    c(S) = lambda*r0(S)-z(S) >= 0,
    d(S) = r0(S)-r1(S) in {0,...,128}.

The maximum compatible selected mass is exactly

    a_max = min(lambda, min_{S:d(S)>0} c(S)/d(S)).

An empty inner minimum imposes no extra upper bound. Empty selected domains
give `a_max=0`; zero pattern mass is handled separately.

Starting at `a=lambda`, call an exact global minimization oracle for
`F_a(S)=c(S)-a*d(S)`. A nonnegative minimum certifies the current mass feasible.
For a negative minimizer `S`, update `a` to `b=c(S)/d(S)`, which is strictly
smaller and remains an upper bound on `a_max`.

At any subsequent negative query, the positive integer `d` strictly decreases.
Indeed, `F_b(S)=0`. If another set `T` has `F_b(T)<0` and `d(T)>=d(S)`, then

    F_a(T) = F_b(T) - (a-b)*d(T)
           < -(a-b)*d(S) = F_a(S),

contradicting the previous global minimum. Ties among exact minimizers do not
affect the argument. There are thus at most128 negative updates and one
terminal query. Terminal feasibility and the maintained upper bound identify
`a_max` exactly. This counts global weighted-rank minimization calls, not
individual rank evaluations, and supplies no practical runtime guarantee.

A maximum-defect certificate need not trust an algorithm's level labels. For
any verified colored mixture `x` in `B(f)` and any target `g`, every set obeys

    g(S)-f(S) <= g(S)-x(S) <= sum_j max(g_j-x_j,0).

If a reported cut attains the final bound, it is a global maximum defect;
otherwise it may still be a valid separating cut. The fast early-stop oracle
does not automatically provide the optimality needed for the128-update bound.
The reasoning reviews are `weighted-rank-ratio-descent-independent-review.md`
and `weighted-rank-maxdefect-certificate-independent-review.md` under
`two-basis-results/`.

## Bounded structural screen and review status

The first augmented-domain screen completed all 15,121 positive unanchored
probe/pattern coordinates of the accepted repaired allocation in 30.97 seconds.
It found no empty augmented domain. This negative screen does not test the
weighted-rank inequalities above or the full owner lift.

The saved screen's tiny-control field `physical_full_bases_per_domain:35`
means 35 candidate three-element subsets. Only 28 are full bases before
conditioning. The 512 exhaustive domain controls are unaffected by this
labeling error. The original artifact is retained unchanged; its allocation
inputs already have separate exact acceptance receipts. A future standalone
consumer must explicitly bind those receipts and the corresponding configs.

The selected/residual decomposition, empty-domain implication, and weighted-rank
identity received read-only independent mathematical reviews. Any algorithm
using the new identity still requires implementation controls. No
heavy local computation is being launched during the user's temporary local-load
hold.
