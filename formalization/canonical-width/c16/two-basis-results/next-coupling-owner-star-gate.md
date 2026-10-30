# A bounded next gate: conditional owner-star consistency

The point22 inventory has seven exact sector-pattern mixtures and fifteen
positive higher-rank cuts against the supplied allocations. These include the
two earlier mask0 mixtures. The source point itself is not cut by those fifteen
allocation failures. The authorized all-rank successor should finish before
starting another allocation trajectory. Even a successful successor would
certify only the chosen shared anchor law and independent sector bases.

## What not to use as the next relaxation

A full physical X basis uniquely determines its dual Z basis: the evaluation
map from the ambient Z space to 128 coordinates is an isomorphism, and every
unit coordinate has exactly one preimage. A compatible pair of archived full
bases is therefore already a source frame. A transportation problem restricted
to archived compatible basis pairs can find a frame, but an empty graph only
rejects those archives. It does not provide a source-valid exclusion or a cut
against every possible decomposition.

Plain Hall/matching flow also misses the issue. Any two full bases have an
invertible GF(2) pairing matrix. Its determinant contains a nonzero permutation
term, so its support graph has a perfect matching, even when many additional
pairing-one entries prevent duality. Thus separate basis distributions can
always be coupled with support-matchings by taking their product and choosing
a matching per pair. At unconditioned or empty-pattern level, Hall feasibility
adds no restriction to complete separate basis membership. The tiny exhaustive
review checks all basis pairs in dimensions1,2,3: every pair has a support
matching, while most pairs are not dual. A source frame requires all selected
pairing-one edges to be the matching, not just a matching subgraph.

## Retain conditional products on a few owner stars

Fix the existing four anchors A and let m range over all16 patterns. Write
`lambda_m=Pr(A=m)`, `x_m,i=E[1_m X_i]`, and
`z_m,j=E[1_m Z_j]`. For an unanchored X probe i and each physical pairing-one
neighbor j, introduce

`t_m,j=E[1_m X_i Z_j]`.

Every source frame satisfies:

* `sum_j t_m,j=x_m,i`, since a selected X has exactly one selected owner.
* `sum_m t_m,j=T(i,j)`, the fixed literal cross moment with factor one.
* `0<=t_m,j<=x_m,i` and `t_m,j<=z_m,j`.
* `t_m,j>=x_m,i+z_m,j-lambda_m`, the conditional Boolean lower bound.
* `t_m,j=0` if a different selected X anchor pairs with j, or a different
  selected Z anchor pairs with i. Such an edge would duplicate a selected
  anchor's owner. Forced absent endpoints are also zero.

The same construction applies with the sectors reversed. Pairing-zero edges
need no t variable because they cannot be owner edges. The physical graph has
99,808 pairing-one edges; an individual X star has68–212 neighbors. One probe
therefore has at most3,392 pattern-edge variables, not a Cartesian product of
full bases.

The conditional lower bound is essential. For example, deterministic rank2
bases with pairing matrix `[[1,1],[0,1]]` have a support-perfect matching. But
the first X's two edge lower bounds are each1, contradicting its owner total1.
The new rows detect the extra selected edge. Prescribed global T marginals add
another coupling across patterns, absent from the current 7,211-feature
projection, which retains only anchor/full-pool cross products.

## Exact finite flow certificates

At fixed rational lambda/x/z, this is a bounded transportation feasibility
problem between the16 pattern nodes and the probe's neighbor nodes. Subtract
the lower bounds, then use integer max-flow after a common denominator is
cleared. A negative residual row/column demand or a capacity below a lower
bound already yields an exact linear contradiction. Otherwise a deficient
minimum cut records pattern subset M and neighbor subset J. For residual
demands d and b and capacities u it proves

`sum_(m in M) d_m > sum_(j in J) b_j + sum_(m in M,j notin J) u_mj`.

The independent consumer only needs the subsets, physical pairing/anchor
status checks, target coordinates, and exact rational arithmetic. It does not
need to trust the flow implementation. Every chosen lower bound is either0
or the affine Boolean lower bound; every chosen upper bound is one of the
valid affine upper bounds (or0 for a physical impossibility). Freeze those
choices in the certificate so the resulting inequality remains a valid linear
source row away from the target allocation.

There is an even cheaper preliminary screen. For each pattern/probe, select
neighbors J with positive Boolean lower bounds. Necessarily

`(|J|-1) x_m,i + sum_(j in J) z_m,j <= |J| lambda_m`.

For an anchor-forbidden edge the corresponding necessary row is simply
`x_m,i+z_m,j<=lambda_m`. These rows couple the two allocations directly and can
be checked before any flow call. A fixed-allocation violation is a useful
diagnostic and a valid auxiliary row, not a projected moment cut by itself.

## One bounded experiment and acceptance boundary

After the authorized all-rank successor, freeze its accepted point, shared
law, both allocations, and allrank receipts. Use at most eight unanchored
probes per sector, chosen once from the core orbit32/orbit27 phase neighbors
by the largest exact necessary owner-capacity mismatch. Preserve the ranking
and chosen physical indices. Run the cheap lower-bound screen, then at most16
exact star flows, with a120-second total cap. Stop after collecting eight
distinct independently verified auxiliary cuts. No new global moment point
or repeated allocation chase is part of this diagnostic.

If no star fails, record feasibility only for the selected stars and supplied
allocations. If stars fail, the next single joint allocation LP should retain
both sector blocks and the new cross-sector rows, with the five higher anchor
moments free. All16 patterns, including currently zero-mass patterns, must
remain available. Reuse the valid finite rank banks; complete all-rank closure
is not needed for validity of an infeasibility certificate, though it may
strengthen the model. A120-second LP followed by bounded exact recovery or
dual replay is a separate authorization, not implied by this review.

For a projected cut against the fixed p/S/T point, an exact Farkas combination
must eliminate the free allocations and higher anchor moments, or pay for
their residuals using justified bounds. Infeasibility with the chosen zero-high
law fixed excludes only that law. A global source obstruction further requires
the necessary global/case model and exact certificate, as in the semantic
Farkas route. No star diagnostic alone excludes a cover case.

## Why this precedes a larger overlap hierarchy

The prior16-quad overlap gate already coupled shared third/fourth anchor
moments, but only local boxes. A stronger overlap model can additionally
identify `sum_(m with restriction s) y_m,u` for every shared anchor state s and
physical selector u. Two quads sharing three anchors would then share
conditional first moments under eight states, not just their anchor law.
This is valid and tractable as a later small joint LP, but it still omits
unanchored mutual pairing. The owner-star gate targets that specific missing
constraint now and has a much smaller exact certificate than full basis-pair
enumeration. Full support optimization with arbitrary unanchored quadratic
weights does not retain the independent matroid-greedy decomposition.
