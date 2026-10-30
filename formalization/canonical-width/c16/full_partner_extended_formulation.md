The orbit32 775-feature hull has an exact block formulation, but the inspected
matroids do not support a small count-only replacement. The current obstruction
uses the zero-pool rank function substantially. This is a statement about a
necessary one-sided projection, not the physical source cover.

For each of the 291 allowed mask representatives P, let lambda_P be its total
probability mass. Let E_P be its zero-evaluation Z pool, B_P,t the required
unit-owner bins, and r_P=128-|P|. Introduce a nonnegative joint selection
variable y_P,j for every eligible physical Z candidate. The exact constraints
are

    sum_P lambda_P = 1, lambda_P >= 0;
    sum_(j in B_P,t) y_P,j = lambda_P       for every required owner t;
    sum_(j in E_P) y_P,j = r_P lambda_P;
    sum_(j in A) y_P,j <= rank_Z(A) lambda_P  for every A subset of E_P.

All variables are nonnegative. Singleton rank rows imply y_P,j<=lambda_P in
the zero pool; the owner simplex implies the same owner-variable bound. When
lambda_P=0 all its y variables vanish. For positive lambda, the zero variables
divided by lambda lie in the matroid base polytope, and each owner bin is a
simplex. The product of a zero-basis mixture and independent owner choices
produces an actual compatible full128-vector Z-basis mixture. Conversely every
such basis satisfies these rows. Equivalently, the support of these constraints
is exactly the signed greedy support already independently verified, which
proves equality of the two polytopes.

The 775 feature equations are linear in these variables:

    b_mask = sum_P lambda_P (1,|P|,C1(P),...,C8(P));
    b_n[j] = sum_P sum_b y_P,16j+b;
    b_d[j,h] = sum_P sum_t 1[t in P] y_P,16j+t+h.

Representative masses are total class masses. They are not per-physical-mask
masses, and no class-size or extra factor16 belongs in these equations. The
existing target remains (1,16p32,16S1..8[32,32],16p_j,16T_h[32,j]). The physical
rotation bijection is needed to use representatives. Different masks with
equal autocorrelations cannot generally be merged.

The explicit orbit32 formulation has 291 mass variables, 71,088 zero selection
variables, 61,691 owner selection variables, and 1,236 owner simplex equations.
It is finite-dimensional but has an exponential family of rank inequalities.
A greedy weighted-basis optimizer does not itself separate an arbitrary
fractional point from all these inequalities. That separation asks to minimize
rank(A)*lambda-y(A), a submodular minimization problem. A routine that inspects
only sorted fractional coordinates would not establish complete rank membership.
No small exact list of all necessary rank flats has been found here.

The frozen diagnostic `full-partner-witness9-structural-diagnostic.json` uses
the independently accepted 14 gauge-rounded witness9 functionals. Its direct
sum decomposition finds 194 connected zero matroids out of291. Every domain
has a component of at least144 elements; the largest component ranges up to720.
Keeping only the component ranks, including all forced coloops, fails to retain
any of the14 separators. Keeping the single best weight-prefix rank bound per
mask also fails all14. For cut0, exact full-basis support is0 and the exact
target is about2.45891869. The owner/cardinality and component-cardinality
supports are both135; the best-single-prefix support is24. These matched bounds
rule out those specific cheap replacements, not every possible compact
formulation.

A complete chain of signed weight-prefix rank bounds proves each fixed
functional. The14 cut cohort contains15,244 distinct nontrivial proper prefix
sets across the291 domains. Reusing these inequalities in the block formulation
would admit joint reoptimization of feature coefficients and profile masses;
it is a finite outer approximation, not an exact description for arbitrary
future directions. This is the concrete alternative to successively adding
only projected tangent rows, but at about133,000 selection variables it is not
the recommended immediate gate.

Three reusable identities are already exact:

    sum_j n_j = 128;
    sum_(j,h) d_jh = 128 k;
    sum_(j,h) A_jh d_jh = k,

where A_jh is the physical pairing of X_orbit32,0 with Z_j,h. The third identity
counts the unique owner of each selected X. These explain the two cross-block
gauge shifts used in the rounded bank. They do not claim the full affine hull,
and eliminating them alone does not remove the rank obstruction.

Even exact membership in the entire orbit32 775 hull would leave joint
cross-orbit profile coupling open. A separate orbit27 mixture can use a
different conditional distribution of the same physical Z basis. Combining two
full masks would require21,904,705 physical mask pairs, or1,369,189 classes under
simultaneous rotation (Burnside count). The easy291-by4765 enumeration still has
1,386,615 domains, with duplicates from stabilizers. Independent rotation of
the two masks is invalid because relative phase affects the physical pairings.

The bounded alternative implemented here uses four fixed X anchors, two from
each orbit. It trades full one-orbit mask information for direct two-orbit
coupling; neither projection is asserted to dominate the other. There are only
16 selected-subset patterns. The features are

    (1, P[4], PP[6 lexicographic pairs], Q[720], P_Q[4,720]),

with3611 coordinates. For anchor a_i=(orbit_i,phase_i), their targets are

    1;
    p[orbit_i];
    S_(phase_l-phase_i)[orbit_i,orbit_l];
    p[j] for each physical Z_(j,b);
    T_(b-phase_i)[orbit_i,j].

Every target has factor ONE. These are fixed-anchor literal moments, not sums
over16 phases. The 32-action average justifies their source necessity; all16
selection patterns are priced, with no rotational reduction. Each pattern
uses the unchanged full-basis decomposition on its selected anchor subset.
The absent anchors impose no additional restrictions. In particular, a priced
basis may also be compatible with an anchor declared absent in the pattern;
the relaxation permits that.

The first quads are [512,517,432,437] and [512,520,432,440], corresponding to
orbit32 and27 at phases(0,5) and(0,8). Their count-only block formulations have
10,686 and10,630 total variables respectively,3659 equalities, and6538/6618
zero-variable upper bounds. The full3611 feature vectors map to1460/1459 distinct
owner coordinates. This coincidence of target coordinates does not justify
merging distinct physical features before establishing a valid symmetry.

The120-second Wolfe pilot for each quad at the frozen accepted point10 found no
strict exact separator. Every archived physical column and each final all16
support were independently replayed. The residuals remain about4.26e-4 and
4.82e-4, so neither pilot proves membership. Exact nonnegative distributions
on the16 patterns do reproduce all11 constant/P/PP coordinates for each quad.
Thus a quadratic inequality on just those four Bernoulli anchors cannot exclude
this point. Complete Boolean triangles alone would not have justified that
conclusion; the explicit exact distributions do.

The count-only LP gate initially returned numerical infeasibility with presolve
enabled. No dual ray was available. Disabling presolve returned optimal feasible
primals with equality residuals at most2.4e-10 and no numerical inequality
violation. Both results are preserved. Neither the presolve status nor the
floating feasible primal is an exact certificate. The next small recovery gate
can exploit block structure: after fixing numerical zero and tight y=lambda
variables, eliminate the five Q/PQ equations separately for each physical Z
candidate, leaving a much smaller rational system in the16 masses and residual
local free variables. Exact recovery must then check every equation and bound.
Even success establishes only count-only membership; all zero-matroid ranks
remain a separate gate.

No source cover case is excluded by any result in this note. The source interval,
405-case cover, and unresolved physical completion remain unchanged.
