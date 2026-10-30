# Exact pattern-cost projection after basis pricing

This is an elementary finite linear-programming projection lemma and a
preparation route for our existing shared-basis formulation. It is new to our
current projector implementation, not a claim of new mathematics. No shared
master, pricing query, minorant LP, or source obstruction is computed here.

Let `m` range over the sixteen original four-anchor patterns, with probability
`lambda[m]`. For each sector `s`, source-compatible full bases `B` have
nonnegative mixture weights `w[s,m,B]` summing to `lambda[m]`. A source frame
supplies such weights. The converse need not hold: unanchored mutual pairings
remain relaxed. Use inequalities in the convention `expression <= 0`,
nonnegative multipliers on inequalities, and arbitrary signed multipliers on
equalities.

After excluding nonnegative basis-bound rows and cancelling the other finite
variables, suppose a source-valid row combination is

    G(F) + sum_h r[h]*tau[h] + sum_(s,m,B) a[s,m,B]*w[s,m,B] <= 0.

Here `F` is the canonical owner moment vector, and `G` includes its constant.
The priced coefficient includes the mass-row constant:
`a[s,m,B] = gamma[s,m] + sum_(j in B) c[s,m,j]`.
For exact minima `mu[s,m] = min_B a[s,m,B]`, nonnegative weights give

    sum_(s,m,B) a[s,m,B]*w[s,m,B]
        >= sum_m (mu[X,m]+mu[Z,m])*lambda[m].

Consequently replacing the priced expression by this lower bound preserves a
necessary `<= 0` inequality. The minima may be negative. Requiring every
minimum to be nonnegative is sufficient for extending the *same* ordinary
Farkas ray by column-bound rows, but is unnecessary for this new projection.
Signed maximum-support certificates can certify a minimum by negating the
weights and retaining the mass constant.

## Removing pins uses higher joint moments

The actual frozen model has higher coordinates indexed by
`HIGH = [7,11,13,14,15]`. These are joint moments, not exact-pattern masses:

    tau[h] = sum_(m containing h) lambda[m].

In particular `lambda[7]=tau[7]-tau[15]`, and similarly for 11, 13 and 14;
`lambda[15]=tau[15]`. Therefore define

    rho[m] = sum_(h contained in m) r[h],
    K[m] = mu[X,m] + mu[Z,m] + rho[m].

Pattern15 receives **all five** residual coefficients. Substituting a
triple-coordinate residual only into its identically numbered pattern is
invalid after unpinning. If a fully cancelled pinned combination included
the term `h[h]*tau[h]`, deleting that pin row leaves `r[h]=-h[h]`.
Recompute the unpinned symbolic combination rather than guessing this sign.

We now have the unrestricted-law necessary inequality

    G(F) + sum_m K[m]*lambda[m] <= 0.

## Eliminate the pattern law with a quadratic minorant

Write the eleven literal pattern features as the constant, four bits and six
pair products. Any rational coefficients defining

    b(m) = alpha + sum_i beta[i]*bit_i(m)
           + sum_(i<j) gamma[i,j]*bit_i(m)*bit_j(m)

with `b(m) <= K[m]` for all sixteen patterns give the pin-free owner row

    G(F) + alpha + sum_i beta[i]*p[i]
         + sum_(i<j) gamma[i,j]*P[i,j] <= 0.

The expectations are the original four physical-anchor moments, mapped into
the accepted owner coordinates. They have factor one; no factor16 or32 is
introduced by this projection. The physical symmetry bridge is inherited
from the existing source model, not re-proved by these algebra controls.

At a fixed feasible low-moment vector `q`, the best quadratic minorant value
is the finite LP dual of `min K.lambda` subject to the eleven moment
equalities and `lambda>=0`. Exact feasibility of a proposed minorant, checked
on sixteen patterns, suffices for a valid row; optimality is optional. An
exact feasible law and matching minorant value certify optimality. If the
low-moment law itself is infeasible, that is a separate local moment-polytope
question. No numerical objective is an exact certificate.

For illustration, `K(m)=-1+3*bit_0(m)` is already a minorant. If
`p[0]=1/4`, its expectation is `-1/4`, whereas the law-independent constant
bound `min_m K(m)` is `-1`. This is a strict improvement in the lower bound,
not an actual separating C16 row. A quadratic minorant always permits the
constant minimum; comparison with other existing residual corrections needs
the same starting symbolic combination and normalization.

## Five acceptance gates

1. **Source-row provenance and full symbolic lift.** Reconstruct a reduced or
   zero-face certificate in the full source model before deleting pins.
   Preserve owner-feature coefficients and lambda terms from zero-variable
   bounds. Dropping a row because it vanishes at this target is insufficient.
   Exclude artificial phase-I error claims: the source has link errors zero.
2. **Finite cancellation and pin signs.** Remove pin rows, recompute the
   expression, and cancel every finite variable other than the five higher
   moments. Any other residual requires a separately checked source-valid
   correction. Absorb the higher moments using the superset formula above.
3. **Complete exact pricing.** Independently certify both sectors in all
   sixteen source-relevant domains, including currently zero-mass blocks;
   include signed costs and mass constants. An empty domain requires a
   separate proof that its source pattern has zero mass. Present domains are
   feasible, but that fact is not established by the toy controls.
4. **Exact minorant and target mapping.** Check all sixteen rational
   inequalities `b<=K`, preserve the constant, and map the eleven low moments
   with the accepted factor-one physical owner-coordinate bridge.
5. **Endpoint scope.** Replay the final integer/rational owner row and its
   exact target value independently. Only a strictly positive verified gap
   excludes that target. Auxiliary membership or a pinned contradiction does
   not establish a full source frame or answer the C16 question.

The existing `exact_projected_combination` helpers in
`two_basis_joint_general_star.py` and `two_basis_owner_star_capacity.py`
implement exact cancellation or the coarse probability correction
`sum_j min(0,r[j])`. They do not implement this priced pattern-cost minorant.
This note specifies a future adapter rather than silently changing them.

## Small exact controls

`verify_shared_basis_pattern_cost_projection.py` reads the accepted full
capacity model and checks its saved sparse lambda expressions directly,
without importing a model producer or optimization package. It checks the
symbolic mass and five superset identities, every unit law, rational mixture
laws, signed finite toy pricing, the illustrative moment minorant, and
rejected sign/map/minorant mutations. The receipt and inventory are under
`two-basis-results/shared-basis-pattern-cost-projection-*`.

These are algebra and preparation controls. They do not certify a new
physical domain, run a matroid oracle, or prove a C16 source obstruction.
