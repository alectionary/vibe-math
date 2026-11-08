# Actual-parent pattern-local probability bounds

The new certificate proves `0<=v<=lambda[m]` for every one of the22,508
non-tau variables in the full unpinned parent:13,388 retained allocations,
9,088 shared owner-edge probabilities and32 conditional same-sector pair
probabilities. It uses explicit nonnegative sums of existing source inequality
rows. No target-law pin or zero-face elimination is used.

For a retained allocation `v=y[s,m,j]`, the two existing box rows give `-v<=0`
and `v-lambda[m]<=0` directly. For an owner-edge variable `t`, its explicit
nonnegative row gives the lower bound, while

    (t-y[X,m,i]) + (y[X,m,i]-lambda[m]) = t-lambda[m]

gives the upper bound. Both summands are named source rows.

For `sX[m]`, the lower row is its nonnegative pair atom. The singleton atom of
X614, the two nonnegative shared-edge rows and its allocation upper box sum to

    (sX+t[614,51]+t[614,83]-yX614)
      -t[614,51]-t[614,83]+(yX614-lambda[m])
        = sX-lambda[m].

For `sZ[m]` use the Z51 singleton and edges from X614 and X281. All coefficients
in these row combinations are1. The proof does not merely assume that the new
pair variables inherit the old allocation-variable bound guard.

The five remaining coordinates are higher joint moments, and their exact
symbolic identities are replayed from the actual model:

    tau[h] = sum_(m containing h) lambda[m], h in [7,11,13,14,15].

The saved lambda expressions also sum identically to1. Pattern15 therefore
receives every higher-moment residual coefficient, not only the coefficient of
tau15.

If a source-row combination leaves residual coefficients `r[v]`, each proved
interval gives the pointwise bound

    r[v]*v >= min(0,r[v])*lambda[mask(v)].

Thus define a pattern correction

    rho[m] = sum_(non-tau v with mask(v)=m) min(0,r[v])
             + sum_(h contained in m) r[tau[h]].

After full-domain basis pricing, this correction can be added to the two
sector minimum costs before the sixteen-state quadratic-minorant projection.
Because `0<=lambda[m]<=1`, this correction is at least as strong pointwise as
replacing every non-tau residual by the constant `min(0,r[v])`. Shared-variable
dependencies could permit stronger corrections; no such completeness claim is
made here.

This certificate prepares a possible *source-combination diagnostic*. It does
not certify an interrupted solver's primal or dual optimum. Such a diagnostic
would require its own frozen exact source multipliers with valid inequality
signs, full symbolic recombination, these bound witnesses, all32 physical
prices, the exact minorant and final target-row replay. Artificial link errors
are evaluated at their source value zero, not treated as source probabilities.
No diagnostic or solver is run by this gate, and the exact-optimality path is
unchanged.

`shared_master_price_probability_bounds.py` emits the witnesses.
`verify_shared_master_projection_bounds.py` imports no bound producer and
checks all45,016 symbolic row identities against independently reconstructed
parent rows. It also checks five tau identities, the lambda-total identity,
60 elementary signed interval cases and seven rejected mutations. The
certificate and receipt are
`shared-master-results/pattern-local-probability-bounds-v1.json.gz` and
`shared-master-results/pattern-local-probability-bounds-v1-independent.json`.

The accepted scope is a probability-bound theorem for this full finite parent,
not membership in the full source set, a new separating target row, or a C16
source exclusion.
