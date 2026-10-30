# Full-partner projection for orbit32

This is a necessary projection of a full128-pair source frame. A column consists
of the selected phase mask `P` in X orbit32 and a full128-vector Z basis `Q`
compatible with those selected X vectors. It does not require completion of the
remaining X vectors inside the physical X pool, nor impose absence of X phases
outside `P`. A feasible mixture of columns therefore need not be a source frame.

The current allowed universe has4597 masks in291 rotation classes. Every class
representative has a feasible full-partner domain in the independently checked
oracle cohort. The oracle's generic fixed-weight benchmark is not a global
all-mask bound. The representative reduction below is justified specifically
for the equivariant weights induced by these projected features.

## Integer features and exact normalization

Write `p_t=1[t in P]` and `q[j,b]=1[16*j+b in Q]`; phase indices are modulo16.
Use775 integer features, in this exact order:

```
phi(P,Q) = (1, k, C_1,...,C_8, n[0],...,n[44], d[45,16].ravel(C))
k         = sum_t p_t
C_h       = sum_t p_t p_(t+h)
n_j       = sum_b q[j,b]
d[j,h]    = sum_t p_t q[j,t+h]
```

There are10 constant/mask features,45 Z count features, and720 cross features.
The order of the last block is `j` outer, `h=0..15` inner. `C_8` retains the
ordered phase sum, including both endpoints of an opposite pair; it has no
special factor of one half.

Under averaging over all16 simultaneous phase rotations and the2 sector choices,
the exact target in the existing owner moments is

```
b = (1, 16*p[32], 16*S_1[32,32],...,16*S_8[32,32],
     (16*p[j])_j, (16*T_h[32,j])_(j,h)).
```

Here `T_h[32,j]` means X orbit32 at phase0 with Z orbitj at phase+h. For h>8,
use `T_(16-h)[j,32]`; at h=0 or8 the stored matrix is symmetric. This orientation
is the reverse anchor order of some older shared-profile cut formulas; copying
those formulas without transposing would be wrong.

For a fixed physical frame, averaging the unswapped orientation produces
`n_j(Q)/16` and `d[j,h](P,Q)/16`. Averaging the sector-swapped orientation supplies
the other half of the canonical moments. Thus the stated target is the average
of the two oriented integer-feature vectors. Including all32 actions literally
gives the same result because every feature is invariant under simultaneous
rotation. The checked physical sector isomorphism and phase generators justify
applying the same source-domain rule in both orientations.

If a support inequality is `c.dot(phi) <= H`, its physical moment row is

```
16*c_k*p[32] + 16*sum_(h=1..8) c_C[h]*S_h[32,32]
  + 16*sum_j c_n[j]*p[j]
  + 16*sum_(j,h) c_d[j,h]*T_h[32,j] <= H - c_0.
```

Class columns represent total mass on feature values. Do not multiply them by
class size or by16 again. This differs from the older LP's per-mask probability
variables. The constant feature is exactly1, and the projection includes the
identity `sum_j n_j=128`.

## Exact support for a fixed mask

For coefficients `(c_0,u,v,w)`, the mask-only term is

```
F(P)=c_0 + u_0*k + sum_(h=1..8) u_h*C_h.
```

The induced weight of physical candidate `Z[16*j+b]` is

```
a[j,b](P) = v_j + sum_(h=0..15) w[j,h]*p[(b-h) mod16].
```

Expanding the feature sum gives the exact identity

```
c.dot(phi(P,Q)) = F(P) + sum_(16*j+b in Q) a[j,b](P).
```

The oracle groups all720 Z vectors by their evaluations on the k selected X
vectors. A compatible full Z basis contains a full basis of the zero-evaluation
pool of rank128-k, and exactly one member of each of the k required unit-signature
owner bins. These choices form an independent128-set: applying the evaluations
to a putative dependence kills each owner coefficient, leaving a dependence in
the zero basis. Conversely every compatible full Z basis has this form.

Therefore support is the maximum-weight FULL zero-pool basis plus the maximum
signed weight in each required owner bin. Matroid greedy computes the first
term. Negative weights must be retained; replacing any term by its positive
part, permitting fewer than128 Z vectors, or omitting a negative required owner
would compute the wrong polytope.

The stable API is:

```
from full_partner_basis_oracle import FullPartnerBasisOracle
oracle = FullPartnerBasisOracle()
domain = oracle.prepare(32, P)
result = oracle.support(domain, weights720)
```

Weights must be exact integers or `Fraction` values; floats are rejected. A
successful result includes exact support and the128 selected physical Z indices,
with zero-basis and owner choices separated. `prepare` permits optional extra X
indices, but this pilot does not use them: a fixed unrotated extra anchor would
require extending the equivariance argument.

## Why291 representatives suffice here

Let `rho_r` add r to every phase index. Then

```
phi(rho_r P, rho_r Q) = phi(P,Q)
a[j,b+r](rho_r P)     = a[j,b](P).
```

Physical phase symmetry bijects the compatible Z bases for P with those for
`rho_r P`. Consequently the maximum of the induced score is identical on each
mask rotation class, including classes with nontrivial stabilizers. Global
support is exactly

```
H(c) = max_(291 representatives P) [ F(P) + oracle_support(P,a(P)) ].
```

This conclusion is not valid for an arbitrary720-vector held fixed while P is
rotated. An implementation must derive candidate weights from the invariant
features, or prove the corresponding covariance. Reducing masks by shape alone
is also unjustified: masks sharing autocorrelations may have different partner
domains. The reduction is291 rotation classes, not186 shapes.

A rigorous source cut consumer must independently rebuild the allowed masks,
check their rotation closure and representative coverage, bind the physical
symmetry proof to the pool hashes, and prove the fixed-mask support upper bounds.
A maximizing witness alone supplies only a lower bound. The independent oracle
consumer's rank-of-prefix method proves greedy optimality and handles signed
weights. Explicit covariance controls complement the algebraic proof.

## Numerical master and exact pricing

Omit the redundant constant coefficient by setting `c_0=0`. Let `f=phi[1:]` and
`b'=b[1:]`. The bounded dual master on a current column set K is

```
maximize   y.dot(b') - t
subject to y.dot(f(P,Q)) <= t    for columns in K
           -1 <= y_i <= 1      for all774 coefficients.
```

The box fixes scaling; t is free. This is the dual of an L1 distance-to-convex-hull
master with normalized nonnegative column weights. A restricted-master positive
objective is not yet a separating cut because unseen columns may violate it.

For each pricing round:

1. Solve the bounded restricted master within the remaining time budget.
2. Round y to explicit integer coefficients at a frozen scale (the first pilot
   uses65536). Compute the induced720 weights exactly for every representative.
3. Obtain all291 maximizers, add their full775 feature columns, and deduplicate
   by the entire feature vector.
4. Recompute `H(c)` exactly and evaluate `c.dot(b)-H(c)` with rational arithmetic.
   Export a candidate only if this exact gap is strictly positive.
5. Otherwise continue until the time/round cap, no new columns, or the bounded
   numerical stopping criterion. None of these no-separation outcomes proves
   projection membership.

Integer rounding can lose a weak separator. It cannot create a false accepted
separator when the resulting integer support and exact target gap are replayed.
A later implementation can try additional scales or exact binary rational y;
this is an optional refinement, not a substitute for independent support proof.

Initial columns can be the291 zero-weight oracle bases. Adding all291 maximizers
per round keeps the first implementation simple and uses the fast cached domains.
Degeneracy is expected from identities such as `sum n=128`; removing redundant
coordinates may improve later numerical work but is not required for validity.
The initial pilot has a600-second ceiling and retains its frozen inputs, every
round summary, exact candidate support records, and termination reason.

A future membership certificate would need exact nonnegative column weights
summing to1 and reproducing all target features, with each support column's
physical compatibility independently checked. A floating master optimum near
zero does not provide that certificate, and such a mixture would still establish
only this one-sided projection's feasibility.

## Files, controls, and acceptance boundary

`full_partner_projection_features.py` provides pure `column_features`,
`candidate_weights`, `mask_score`, `moment_target`, and `moment_row` utilities.
`moment_row` is explicitly a translation of an unverified bound, not a source
certificate compiler. The CLI performs controls and does not solve a model.

```
OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 VECLIB_MAXIMUM_THREADS=1 \
  /private/tmp/c16-venv/bin/python -B full_partner_projection_features.py \
  --physical-controls
```

The controls passed12 arbitrary binary X/Z selections with literal32-action
averages:9300 feature equalities,24 weight decompositions,276480 individual
weight covariance checks,12 moment-row comparisons, and64 exact physical support
queries across rotations. Arbitrary selections are translation controls, not
source frames. The physical queries test the oracle interface and rotation
identity; they do not certify a global support cut.

`full_partner_projection.py` is the bounded numerical driver. A positive output
is labeled `EXACT_SUPPORT_CUT_CANDIDATE` until `verify_full_partner_projection.py`
independently validates it. The certificate stores775 integer coefficients,
integer upper bound, rational target value/gap, all291 support witnesses,
mask-universe and source hashes, and the pricing scale. The independent consumer
is being developed separately from this feature code.

This work introduces no source resolution: width16 versus18 remains open,
sufficient cover405 and physical partial frame88/128 are unchanged, and zero
full source anchors are excluded. A strict projected cut would separate the
specified moment point, not all feasible moments or all source frames.
