# Analytical verification of the remaining source claims

This is a continuation of the source-to-proof bridge for Pesah's 2021 **Master
of Research** dissertation. The source locators below refer to printed pages.
These are written mathematical checks plus independent finite implementations,
not new Lean theorems. Standard cellular homology of the three-torus, finite
binary rank-nullity and the stabilizer projector argument are inherited
background. They are explicitly used rather than made into new research tasks.
The existing Lean statements and their narrower signatures remain unchanged.

## Rhombic parameters and distances: §2.4.2, pp30–32

**Result.** In the prose convention (Z cube checks, X triangle checks), every
even periodic size L>=2 has n=3L^3, k=3, d_X=L, d_Z=2L^2. Figure 2.10 and the
historical implementation interchange Pauli labels; this is the previously
recorded global-label conflict, not a change of geometry.

Identify each odd-parity cube's lower corner v with a vertex of a face-centred
cubic (FCC) complex. A physical edge of axis a at integer position u is adjacent
to four cubes, precisely two of odd parity. Join those two cube vertices. Their
difference has two coordinates +/-1 and the third zero. This bijects physical
edges with FCC edges, including translated edge identities in the small periodic
quotient. Each original vertex is surrounded by four odd cubes. Its six incident
physical edges form the six edges of their tetrahedron; the four source
triangles are exactly that tetrahedron's four faces. Thus cube checks are vertex
incidence and triangle checks are face boundaries. A triangle has two edges at
each of its incident FCC vertices, proving commutation over F2.

The complex fills Euclidean space by tetrahedra and octahedra. To see that this
is a cellulation, subdivide each unit cube of the FCC-coordinate lattice into
the tetrahedron spanned by its four odd corners and the four tetrahedra at its
even corners. Their disjoint interiors exhaust the cube (central volume 1/3,
four corner volumes 1/6). The eight corner pieces meeting at each even lattice
vertex form one octahedron with odd neighbours as its six vertices. All faces
are the source triangles; there are no missing 2-cells. Quotienting by L times
each coordinate translation preserves parity for even L and gives a cellulation
of the three-torus. This universal-cover construction handles periodic
identifications at L=2; it does not assume the quotient is a simple graph.

There are L^3/2 vertices, 3L^3 edges, 4L^3 triangular faces, L^3 tetrahedra and
L^3/2 octahedra. The FCC edge graph is connected. Its vertex incidence has rank
L^3/2-1. Since H_1(T^3;F2) has dimension three, the triangle boundary rank is
(3L^3-(L^3/2-1))-3 = 5L^3/2-2. Consequently the two independent CSS check ranks
sum to 3L^3-3, giving k=3.

A nontrivial binary edge cycle decomposes into closed edge trails, at least one
with odd winding along a coordinate. Lifting that trail to the universal cover,
its net displacement in that coordinate has magnitude at least L; every FCC
edge changes the coordinate by at most one. Its support, hence the full cycle's
weight, is at least L. A length-L zigzag chain of parallel physical edges closes
for even L and winds once, attaining d_X=L.

For the dual lower bound, choose a coordinate normal b whose winding cycle
pairs nontrivially with the cocycle. For either physical edge orientation a!=b,
fix the other two physical coordinates and vary coordinate b through 0..L-1.
The corresponding FCC edges form a connected zigzag cycle: neighbouring
endpoints agree, transverse displacements alternate, and displacement after
one period is L in direction b and zero otherwise. For the two choices of a
and L^2 fixed-coordinate pairs, these are 2L^2 edge-disjoint cycles in the same
homology class. A cocycle pairs identically with homologous cycles, so it must
occupy an odd, nonzero number of edges on each. Its weight is at least 2L^2.
The cut consisting of both orientations a!=b at physical coordinate b=0 has
2L^2 edges, has even intersection with each triangle, and pairs once with the
winding cycle. It attains the bound. Therefore d_Z=2L^2.

`check_rhombic_cellulation.py` constructs FCC endpoints and tetrahedron faces
independently of the corner-triple generator. It checks exact cube matrices,
triangle-row multisets, connectivity, disjointness and winding at L=2,4,6,8,10.
All pass in 0.289 seconds, under 84 MiB RSS. Shared assumptions are the periodic
coordinate convention and axis labels, not the incidence-generation algorithm.
Finite checks support this source mapping; they do not substitute for the
general topological argument.

## Cubic sectors and ideal majority: §§3.2.1,3.4.1–2

The kernel and source-incidence bridges are proved in the existing Lean files.
For completeness, pure-X point equations after the first-axis Hadamard use
only the remaining two edge axes. Their vertex endpoints have equal first
coordinate. For each fixed first coordinate these are exactly the square
periodic vertex-edge incidence equations; faces normal to the first axis are
the square boundaries. Hence this point sector is a stack of 2D toric decoding
problems. This structural reduction does not determine BP-OSD's threshold.

For the restricted pure-Z point sector, equal syndromes differ by constant
bits on L^2 disjoint chains of length L. For the restricted pure-X loop sector,
they differ by constant bits on L disjoint planes of area L^2. In both cases,
minimum-weight choice is majority decoding. Assume independent Bernoulli(p)
physical errors and independent fair coin choices on ties. If a component has
m bits, its wrong-complement probability is

q_m = Pr[Binomial(m,p)>m/2] + (1/2)Pr[Binomial(m,p)=m/2].

All components represent the same relevant logical class: two parallel chains
bound a strip; two parallel sheets differ by a slab stabilizer. Failure is the
parity of wrong choices. Disjoint inputs and independent tie coins imply
independent choices, so for N components its probability is

P_fail = (1-(1-2q_m)^N)/2.

Here (m,N)=(L,L^2) or (L^2,L). For fixed p<1/2, Hoeffding's bound gives
q_m <= exp(-2m(1/2-p)^2), and P_fail <= N q_m tends to zero. At p=1/2,
complementary errors have equal probability, q_m=1/2 and P_fail=1/2.
This establishes the ideal decoder's 50% endpoint on the conventional
0<=p<=1/2 range. It is not an impossibility assertion for known p>1/2 (where
complementing the noise model changes the decision), nor a proof that finite
iteration BP-OSD attains the ideal endpoint.

`check_majority_exact.py` uses exact rational Bernoulli polynomial convolution
and a two-state parity recursion, independently of SciPy's binomial function
and the closed-form parity expression. All 48 values at L=4,6,8,10 and
p=.1,.2,.3,.4,.49,.5 agree with the saved predictions within 1.43e-15. The
2e-14 tolerance is floating-point evaluation tolerance, not uncertainty.
The check takes 0.216 seconds and under 9 MiB RSS. The broader existing saved
large-L predictions remain illustrative; the asymptotic statement follows
from the bound, not from those values.

## Rhombic pure-X loop recovery: §3.5.2, pp55–56

Each triangle has one first-axis edge. Under first-axis-only errors, a suitable
triangle orientation directly reads every such edge. The existing Lean source
formula therefore proves injectivity and exact recovery if the correction is
restricted to that support. No degeneracy is left in this restricted problem.

The unrestricted, epsilon-regularized BP-OSD implementation need not enforce
this support. Exhaustively checking all 256 first-axis errors at L=2 gives four
logical failures at prior 1e-12; all have weight six. Every returned correction
has the correct syndrome. The external historical dense implementation returns
exactly the same four corrections as our sparse implementation
(`check_loop_reference.py`). At priors .001,.1,.49,.5 all 256 errors succeed.
The prior and size stress case is outside the dissertation's L=4,6,8,10 curves;
these examples qualify a universal extension of the implementation wording,
not the source's observed zero-loop-error curves. They do not invalidate the
restricted-support uniqueness theorem. Further testing is not needed to show
that these two guarantees are logically different. Exact historical production
settings remain unavailable.

## OSD correctness and BP limits: §2.5.2, pp34–40

Let H be any finite binary matrix and s be in its column image. Reordering
columns by reliability is an invertible permutation P. Row swaps and XOR
elimination are invertible row operations U, so Hc=s is equivalent to
(UHP)y=Us with c=Py. Greedily selected pivot columns form a basis of the column
image. In reduced row-echelon form set nonpivot variables to zero and pivot
variables to the transformed right-hand side. Consistency makes every zero
row's right-hand side zero; hence this assignment solves every row. Undoing the
permutation proves the order-zero OSD syndrome guarantee. Reliability ordering
and ties change which valid solution is returned, not this implication.

The integer Python solver performs full row elimination. The native solver
uses forward elimination and back-substitution. Its suffix-word XOR is valid
because every active row has zero coefficients in all earlier columns: pivot
columns have been eliminated and earlier skipped columns were zero in active
rows. Thus skipped words contribute zero. The native residual-row check rejects
inconsistency. The historical and Python versions omit that guard, so their
guarantee must retain the premise s in image(H). All production syndromes here
are generated from errors and satisfy it; measurement-noise claims are outside
this experiment.

`check_osd_exhaustive.py` uses an independent brute-force column-span oracle,
not elimination. For all 682 binary matrices of shapes 1..3 by 1..3, every
consistent syndrome, all strict reliability orders and a tied order, all
20,748 cases agree across Python, native and external historical solvers
(62,244 correction comparisons). In 455 inconsistent examples native rejects,
while historical/Python return invalid solutions. Full validation takes
3.34 seconds and under 48 MiB RSS. Inputs and NumPy tie ordering are shared;
the solution oracle and three solver implementations are identified separately.

These statements prove syndrome consistency, not optimal decoding or convergence
of loopy belief propagation. BP is the source's approximation and OSD fallback
restores consistency under the premise above. The min-plus operations used in
message passing have distributivity but do not form a field; their algebraic
interpretation is a semiring. A failed exploratory exact-zero-LLR test remains
recorded in the interruption checkpoint and supplies no counterexample.

## Quantum interpretation and stopping boundary

For independent commuting Hermitian Pauli generators g_1,...,g_r with no -I
in their generated group, the projector onto their common +1 eigenspace is
2^-r times the product of (I+g_i). Expanding the product, only the identity term
has nonzero trace: independence excludes a nonempty product proportional to I.
The projector rank is therefore 2^(n-r), giving k=n-r. For the CSS incidence
codes, independent pure-X and pure-Z check bases commute and cannot generate
-I: a scalar product would require both binary supports zero, contradicting
basis independence. This supplies the phase and Hilbert-space bridge to the
binary rank argument, using standard Pauli trace facts.

A tensor product of single-qubit Hadamards is unitary, conjugates X and Z into
each other and sends Y to -Y. It maps the stabilizer eigenspace isomorphically,
preserves every Pauli's support and preserves commutation. Thus n,k and total
code distance are preserved. Individual CSS sector distances need not remain
meaningful for the mixed deformed checks. This is the written quantum bridge
to the existing kernel-checked binary transport theorem.

The general cubic ranks and distances already have the written homology and
annihilator-duality arguments in `cubic-homology.md`; together with their Lean
core and finite consumer these satisfy the analytical replication criterion.
Further formalization of rank-nullity, torus homology or projector trace is
optional background formalization, not an unanswered original experiment.
The actual BP-OSD asymptotic 50% expectation remains unestablished, as do the
previous numerical production-input and GUI limits. No general convergence or
optimality result is claimed. The whole study requires publication/review
integration of these analytical findings before this stage is delivered.
