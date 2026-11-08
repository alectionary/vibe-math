# Target-exposed local faces and universal inequality recovery

Reasoning-only review. No computation, import, optimization or active-face
system was run or solved.

For one physical coordinate let g_m=(1,P_1,...,P_4) denote its pattern vector,
let t_m=v dot g_m, and let y_m be its pattern allocation. Structural status
sets y_m to zero, forces y_m=lambda_m, or leaves 0<=y_m<=lambda_m. The local
box support is h_m=0, t_m, or max(0,t_m), respectively. The moment equations
b=sum_m g_m*y_m then give

    Q = sum_m h_m*lambda_m - v dot b
      = sum_{free m:t_m>0} t_m*(lambda_m-y_m)
        + sum_{free m:t_m<0} (-t_m)*y_m.

Thus Q is a positive weighted sum of genuine source-valid box slacks. Forced
and forbidden coordinates contribute zero. A facet normal is sufficient, but
the identity and conclusion do not require facet completeness or extremality.

Write lambda=L*mu+C*tau. If h*C=0 **exactly**, then Q is a linear form q in
the retained owner moments (including the constant coordinate), independent
of all five high moments and local allocation variables. If q(current_target)
is exactly zero, every term with positive weight is zero for every feasible
allocation and law at that target. Adding these face equalities and eliminating
their coordinates is therefore an exact reduction at this target. No positive
pattern mass is required. This does not assert that the face holds at other
owner targets.

## Lifting a target-conditional proof

Use first the nonnegative-slack convention. Suppose a reduced proof, lifted
through its recorded exact substitutions, has the variable-free form

    H(owner) = R(owner,x) + sum_i eta_i*s_i >= 0,

where R is a nonnegative combination of original nonnegative rows plus an
arbitrary combination of genuine equality rows. The eta_i are signed because
the exposed s_i=0 were treated as equalities. If Q=sum_i w_i*s_i with w_i>0
on every exposed slack having a negative eta_i, choose

    gamma >= max(0, max_i (-eta_i/w_i)).

Then H+gamma*Q is a nonnegative combination of genuine source-valid rows,
so it is universally nonnegative. Its value at the current target equals H
because Q is exactly zero there. A strict target violation is preserved.

**Sign in the existing adapter's convention:** it stores inequalities as
`r_i=-s_i<=0`. If the lifted reduced proof is

    P(owner) = R(owner,x) + sum_i eta_i*r_i <= 0,

the universally valid row is **P-gamma*Q<=0**. Indeed,
`-Q=sum_i w_i*r_i`, so the new row coefficients are eta_i+gamma*w_i>=0.
Adding gamma*Q to this <=0 form would have the wrong sign. For example the
face-valid inequality q<=0 on q=0, with universal q>=0, is not repaired by
adding a positive multiple of q.

For several exposed identities, aggregate their nonnegative slack weights:
Q_total=sum_k Q_k and W_i=sum_k w_ki. At the target Q_total=0. Every signed
face multiplier that needs repair must have W_i>0. A single sufficiently large
nonnegative rational gamma then suffices. Alternatively retain separate gamma_k.
Identities that hold modulo original equality rows are equally usable, provided
those equality multipliers are included in the proof reconstruction.

## Necessary proof conditions

- All identities, coefficient cancellations, target zeros, substitutions and
  multiplier corrections must use exact arithmetic. A near-zero target slack
  is not an exposed face; a large gamma can magnify its error.
- Keep the signed face multipliers or an exact back-substitution map. Merely
  retaining Q without the provenance of the reduced proof does not reconstruct
  a certificate automatically.
- Only slacks covered by a positive weight in a proved zero identity may be
  fixed through this argument. Structural equalities remain separately valid.
- Exact cancellation of tau/allocation coefficients is needed for a target-only
  row, unless a separately justified residual-bound method is used afterward.
- A finite correction proves validity, not numerical conditioning or sparsity.
  No claim about how many useful faces exist at the current target follows.

The proposed facial reduction and universal moment-cut recovery are sound
with these conditions and the stated sign convention. No dense active-face
solve, global feasibility claim or source exclusion is implied.
