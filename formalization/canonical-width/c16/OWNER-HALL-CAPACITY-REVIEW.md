# Ordinary Hall transport and shared capacities

Assume a nondegenerate bilinear pairing between two R-dimensional spaces,
lambda>=0, and marginals x in lambda B(M_X), z in lambda B(M_Z), where these are
the full physical linear-matroid base polytopes. Thus x(E_X)=z(E_Z)=R lambda.
These assumptions require all physical rank inequalities, not a listed subset.

For S contained in E_X, every vector in the physical nonneighbor set N(S)^c
annihilates span(S). Hence r_X(S)+r_Z(N(S)^c)<=R, and

    x(S) <= lambda r_X(S)
         <= lambda (R-r_Z(N(S)^c))
         <= R lambda-z(N(S)^c) = z(N(S)).

These are the weighted Hall inequalities. Together with equal total mass and
nonnegativity, they give a nonnegative transportation matrix on the nonzero
pairing edges with row masses x and column masses z. For lambda=0 the zero
matrix suffices. Its individual entries are automatically at most both endpoint
masses. This statement does not prescribe edge moments or impose Frechet lower
bounds.

The currently declared conditional basis domains also admit the source-forced
edge deletions in this ordinary-transport conclusion. To see this, choose any
one full X basis and one full Z basis from the two conditional domains. Their
pairing matrix is invertible over GF2, so its determinant expansion supplies a
perfect matching of nonzero entries. Every selected fixed anchor has exactly
one opposite neighbor by the domain's unit-owner decomposition. Every perfect
matching must use these forced edges and therefore avoids all edges excluded
because another selected anchor owns an endpoint. Absent anchors are absent
from the chosen bases. Average one such matching over a product coupling of
the two basis-mixture laws, then multiply by lambda. This constructs ordinary
transport respecting the structural zeros. It does not construct a pair of
biorthogonal bases: other selected nonzero edges may still exist.

The new capacity rows are source-valid because a selected vertex has exactly
one selected opposite owner. Restricting the possible owners to the chosen
opposite centers gives sum(t)<=y for each common unchosen vertex. For a chosen
vertex this follows from its existing full-star equality, and a single-edge
case follows from the endpoint upper bound. Keeping all 1328 rows across all
sixteen patterns is safe, including redundant structural-zero cases. The
ordinary transport constructed above already satisfies these capacities.

The added information therefore lies in Frechet lower bounds, prescribed
unconditional T moments across patterns, and their shared-edge consistency.
For a tiny distinction, take deterministic bases X={1,2}, Z={1,3} in GF2^2.
The nonzero pairing graph has the perfect matching (1,1),(2,3). Ordinary
transport exists. But both endpoints of all three nonzero edges are selected,
so Frechet forces all three edge cells to one; the first X row then has sum two
although its owner total is one. The bases are not biorthogonal.

No claim here establishes conditional basis membership from the finite rank
rows, nor simultaneous source-frame realizability from a feasible flow model.
