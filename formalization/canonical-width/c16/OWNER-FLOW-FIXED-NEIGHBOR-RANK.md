# Exact residual basis splitting with fixed owner probabilities

This is a source-valid local strengthening of the accepted shared owner-flow
and neighbor-capacity model. No new physical computation or source exclusion
is asserted by this note.

Fix one existing anchor pattern, one unanchored nonzero X probe `i`, and the
opposite Z allocation `z`. Write `lambda` for the pattern mass, `a` for the
conditional mass of the probe, and `b=lambda-a`. The symmetric construction
applies to a Z probe. Let `M0` be the original conditional Z-domain matroid,
of rank `R=128` on the 720 physical indices. Its bases are the allowed full
physical Z bases, including the original forced/deleted own anchors.

Let `N` be the pairing-one neighbors of the probe and `H=E-N`. Assume the
probe is physically distinct from the selected old X anchors and its selected
domain is feasible. The minimum-neighbor-face argument in
`CONDITIONAL-OWNER-LIFT.md` gives

    r0(H)=R-1,
    G=N-closure_M0(H),
    M1=(M0 restricted to H) direct_sum U1(G).

Indices outside these components are loops. These are auxiliary domain ranks,
not unconditioned physical subset ranks. In particular, forced zero vectors
must be contracted jointly when computing them.

The accepted shared-flow allocation supplies the actual owner probabilities
`t_j=P(pattern, X_i, Z_j)` for every `j in N`. Independently check

    t>=0, sum_N t=a, t_j=0 outside G, and t_j<=z_j.

The support-in-`G` check is required even if earlier structural-zero rows
appear to imply it. Extend `t` by zero on `H`. Then the following are equivalent:

1. There is a selected component `w` with `w_N=t`,
   `w in a B(M1)`, and `z-w in b B(M0)`.
2. `z-t in a B(M0 restricted to H) + b B(M0)`.
3. The total equation `z(E)=R*lambda` holds and, for every subset `S`,

       z(S)-t(S intersect N)
       +(r0(S)-r0(S intersect H))*a-r0(S)*lambda <= 0.

The first equivalence uses the direct-sum description of `M1`: after fixing
its rank-one component to `t`, the remaining component is exactly
`a B(M0 restricted to H)`. For the second, the greedy support function of a
base polytope is linear in its rank function. Therefore the Minkowski sum is
the base polytope of `a*r0(S intersect H)+b*r0(S)`. Its total is
`a*(R-1)+b*R=R*lambda-a`, which equals `(z-t)(E)`.

This proves the complete local characterization without invoking a general
base-polyhedron intersection algorithm, integrality theorem, or a runtime
bound. It does not impose the retained cross moments on the pairing-zero
coordinates, nor couple different probes' full basis laws.

Validity of each displayed inequality has an even more elementary proof that
does not need the face identity. In an actual source frame with the probe
selected, remove its unique Z owner. The remaining selected indices lie in
`H` and are independent in `M0`. Thus their number in `S` is at most
`r0(S intersect H)`. When the probe is absent, the ordinary bound is `r0(S)`.
Averaging these two inequalities gives the displayed row directly. The face
identity and `r0(H)=127` are needed for the exact local characterization and
the colored adapter, but not for accepting a particular source-valid cut.

## Relation to the earlier local split

For a legal `t`, the new left side minus the earlier split-rank left side is

    a*1[S intersects G]-t(S intersect N) >= 0.

Thus the fixed-owner family dominates the earlier family at this allocation.
For attribution, report both exact left sides for a discovered subset. A
positive new left side with a nonpositive old one specifically uses the saved
owner distribution. A positive old left side remains a valid result, but does
not establish that narrower attribution.

Individual sector membership and all chosen shared-flow/capacity rows should
already be independently accepted at the tested pattern. That makes a new
violation a meaningful strengthening instead of another ordinary rank failure.
Neither prerequisite is needed for validity of the source inequality itself.

A small physical binary example shows strictness over the earlier local
split plus one complete owner star. In dimension three, take Z vectors
`[1,2,4,5,6]`, probe vector `4`, `lambda=1`, `a=1/2`, and allocation
`z=(3/4,1/2,5/8,5/8,1/2)`. The earlier selected law is
`1/4*{1,2,4}+1/4*{1,2,5}` and the residual law is
`1/4*{4,5,6}+1/8*{1,4,6}+1/8*{1,5,6}`; braces here name physical vectors.
Instead fix owner probabilities on vectors `4,5,6` to `(1/8,1/8,1/4)`.
They satisfy the owner sum, upper bounds, and every Fréchet lower bound.
For the physical subset `{1,4,5}`, the original rank is two and the
annihilator-restricted rank is one. The new row has gap `1/4`, whereas its
old split-rank row is tight. This is a local interface example, not a C16
allocation or a claim about its other moment families.

## Common-rank dummy adapter

The existing colored prototype requires the same positive-color rank. Add a
new ground element `d`, represented as a fresh independent bit in the selected
color and as a loop in the residual color:

    selected: (M0 restricted to H) plus coloop d,
    residual: M0 plus loop d,
    target:   (z-t, a),
    masses:   (a,b).

Both colors have rank `R`. For `lambda>0`, divide target and masses by
`lambda` before using the existing solver. Every cut on `S` with or without
`d` reduces to the displayed row: the dummy target and selected rank terms
cancel exactly. Its normalized violation times `lambda` is the raw violation.

A successful selected-color mixture gives a law of bases of `M0|H` after
deleting the dummy. Combine that law independently with the owner distribution
`t/a` on `G` to obtain the required selected full-basis law. This can be kept
as a factorized exact certificate; a Cartesian expansion of all basis/owner
pairs is unnecessary. Every such pair is a valid full basis by the face
decomposition. The residual-color law is already a full original-domain law.

If `lambda=0`, all probabilities vanish and no oracle is needed. If `a=0`,
the selected domain need not be feasible and the problem reduces to original
membership. If `a>0` and the selected domain is empty, the source condition
`a=0` is violated. The initial implementation gate deliberately selects
`lambda>0`, `a>0`, and a feasible selected face. The case `b=0` is allowed.

## Subsequent two-probe gate

For two same-sector probes `i,k`, let `a=y_i`, `b=y_k`, and introduce only
`s_m=P(pattern m, X_i, X_k)` per pattern. Its four masses are

    theta00=lambda-a-b+s, theta10=a-s, theta01=b-s, theta11=s.

Let `M00,M10,M01,M11` be the opposite full-basis domains after selecting the
specified subset of probes. Absence of a probe adds no opposite-side pairing
restriction. Empty positive-mass domains are forbidden. Assuming the domains
are feasible, local four-color decomposition is equivalent to all rows

    z_m(S)+(r00-r10)*a+(r00-r01)*b
       +(r10+r01-r00-r11)*s_m-r00*lambda_m <= 0.

The mixed rank coefficient has no assumed sign. Together with the ordinary
Fréchet interval for `s_m` and `sum_m s_m=S(i,k)` in physical factor-one
coordinates, a finite row bank is only 16 intervals and one sum at fixed
allocations. Choosing one active upper or lower bound per pattern and summing
can eliminate all `s_m` exactly. Such a contradiction gives a valid row in
the original allocation and moment variables. A cut at one arbitrary `s`
does not establish that the free joint mass is impossible.

This four-color local elimination drops the individual cross-pattern
`sum_m(w10+w11)=T(i,j)` and `sum_m(w01+w11)=T(k,j)` equations. A successful
local decomposition is therefore a precisely scoped auxiliary barrier, not
the full two-probe lift or a source frame. The fixed-owner two-color gate is
the preferable first experiment because it uses already accepted edge data
and requires only the existing colored solver plus the exact dummy adapter.
