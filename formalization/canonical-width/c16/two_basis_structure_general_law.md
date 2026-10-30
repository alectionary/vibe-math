# A direct allocation formulation with all five shared high moments

This is an exact linear reformulation of the reviewed two-sector conditional-basis relaxation. It does not assert feasibility of the current target. The shared anchor law is lambda=L*mu+C*tau, where mu comprises the fixed constant, four singleton and six pair moments, and tau comprises the four triple moments and the quadruple moment. Both sectors use the same five tau variables. Impose all sixteen lambda>=0 rows. The Möbius transform then automatically gives total mass one and all eleven required low moments.

For a sector coordinate j, write b0_j=E[U_j] and bi_j=E[P_i U_j]. Keep y_m,j for the eleven patterns H={m:|m|>=2}. The remaining five coordinates are forced by the feature equations:

    y_{ {i},j} = bi_j - sum(y_m,j : m in H, i in m),
    y_{empty,j} = b0_j - sum_i bi_j
                  + sum((|m|-1)*y_m,j : m in H).

Substitution proves all five feature equations identically. Conversely every allocation satisfying those equations has exactly these singleton and empty coordinates. This is a bijective elimination, including boundary laws with zero pattern mass.

Structural source statuses give y_m,j=0 for forbidden/deleted coordinates and y_m,j=lambda_m for forced coordinates. These are affine equations in local y variables and shared tau. Perform exact elimination separately for each j using the constant source-status coefficient matrix; apply the same row operations to the affine right sides. Any zero local row with a nonzero right side is a global affine constraint on tau and must be retained. A fixed-law tight facet is not a structural identity. The tau=0 local-face fixes in the current fixed-law producer must not be imported unless a separate proof shows they hold uniformly over the new feasible tau domain.

An equivalent local parameter count uses all structurally free pattern coordinates and the rank of their five-row moment map. For the current point22 quad, the solver-free exact source calculation gives:

| Sector | Local variables after elimination | Bucket equations before dependency reduction |
|---|---:|---:|
| X | 6,938 | 32 |
| Z | 6,450 | 32 |

Together with the five shared variables, this is13,393 variables. Every non-anchor coordinate has moment-map rank five; the two own-anchor coordinates have no local free variable. The residual own-anchor equations are already satisfied low-moment identities and impose no additional equality on tau. All five outer dimensions remain. These counts are exact source preparation, not solver performance estimates. The control artifact is `two-basis-results/two-basis-general-law-point22-controls.json`, with1,024 exact reconstruction controls and128 literal Möbius-law controls.

Retain all pattern zero-pool and unit-owner bucket equations, even when lambda_m can become zero. In each sector-pattern they are sum_zero y=lambda_m*(128-|W_m|), and sum_ownerbin y=lambda_m for every selected opposite anchor. Total cardinality follows by adding disjoint bucket equations. Exact dependency reduction may remove redundant rows after their affine right sides are included. All boxes0<=y_m,j<=lambda_m remain. Every accepted contracted-rank row becomes sum_{j in A}y_m,j <= lambda_m*rank_{/F_m}(A), a linear inequality in the reduced variables and tau. If a future quad has a physically infeasible pattern, impose lambda_m=0 and all corresponding y=0; the current quad has all sixteen feasible source domains.

There is no division by a variable pattern mass. In particular, the fixed-law producer's margin lambda_m*t would be bilinear here. Use ordinary feasibility or a linear artificial-error objective; alternatively fix a proportional margin alpha outside the LP, so alpha*lambda<=y<=(1-alpha)*lambda is linear. Infeasibility at positive alpha alone is not a certificate for the original alpha=0 problem. Constant positive row scaling taken from a reference law is legitimate preconditioning, including a separate finite scale for reference-zero patterns.

With every zero-matroid subset-rank inequality present, this allocation system exactly describes the reviewed hull: for lambda_m>0, the normalized zero allocation lies in the contracted matroid base polytope, each owner bin is a unit simplex, and these laws can be coupled to a full sector basis. Conditional product coupling between the two sector laws at the common pattern m reproduces all7211 retained features. When lambda_m=0, boxes force the allocation to zero. This hull still omits mutual pairing conditions between unanchored opposite-sector vectors, just as the reviewed support oracle does.

A finite rank-row version is a necessary relaxation. A feasible exact allocation needs local full-rank certification before claiming this hull membership. An exact Farkas combination that cancels every local variable and all five tau variables proves target nonmembership in the finite relaxation and thus in the hull. Because the eliminated right sides remain linear in the original feature target, the same exact combination can be translated back into a globally valid moment inequality. Numerical infeasibility or failure of one fixed law is insufficient.

The next justified gate, after the currently authorized fixed-law refinement, is a bounded joint preparation/feasibility run with shared tau, all boxes, all bucket rows, complete rank-at-most-three geometry and all accepted higher-rank cuts. This note launches no solve and does not replace that fixed-law experiment.
