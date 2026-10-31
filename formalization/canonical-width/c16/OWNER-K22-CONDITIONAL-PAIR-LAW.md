# Fixed four-center owner compatibility and conditional pair laws

This note concerns the fixed centers X614, X281, Z51, Z83 at accepted point22, and the accepted shared-flow/capacity allocation. Their four physical cross pairings are all one. It does not assert existence or nonexistence of a source frame.

## What was already enforced

For distinct same-sector centers i,k, a selected i has one selected opposite owner. If k is also selected, that owner cannot pair with k. Therefore

    S(i,k) + sum_{z in N(i) intersect N(k)} T(i,z) <= p_i.

These are exactly the existing private-partner rows in `physical_owner_moment_matrix.py`, all45×719 phase representatives. Rotation and sector averaging supply the other physical representatives. The current global model includes all32,355 rows. The four directed rows for the fixed centers pass exactly; this is not a new family.

For a physical K2,2, any three selected centers would give one center two selected opposite owners. Consequently its four-bit law has support only on the empty state, four singletons, and six pairs. Its pair atoms are the given six pair moments. Its singleton atoms are p_a minus the three incident pair moments; the empty atom is 1−sum p+sum pairs. These eleven masses uniquely determine that local law.

The singleton inequalities are implied by the existing private-partner rows and nonnegative omitted common-owner moments. The empty inequality is a universal Boolean integer form: with N the number of selected centers,

    1−N+binom(N,2) = binom(N−1,2) >= 0.

It is the already supported affine-template family with constant−1 and four coefficients+1. It does not require the K2,2 hypothesis. At point22 every atom of this fixed local law is nonnegative; its empty atom is614935664280555/1125899906842624. This establishes only this four-event law.

## A distinct conditional requirement

Let m denote one of the original sixteen anchor patterns, with mass lambda_m. Let y be the four conditional first moments, and t_ij the four actual shared conditional cross moments between the selected centers. Add two missing same-sector conditional pair masses sX_m and sZ_m. Their totals must be the existing global S(X614,X281) and S(Z51,Z83).

For each mask define

    Ux = min_i(yX_i − sum_j t_ij),
    Uz = min_j(yZ_j − sum_i t_ij),
    L  = max(0, sum_i yX_i + sum_j yZ_j − sum_ij t_ij − lambda_m).

The complete conditional K2,2 law exists precisely when

    0 <= sX_m <= Ux,
    0 <= sZ_m <= Uz,
    sX_m+sZ_m >= L.

Necessity follows from the eleven atoms. Conversely, these constraints make the six pair atoms, four singleton atoms, and empty atom nonnegative and reproduce every specified marginal exactly. The existing t must already be nonnegative. Local feasibility requires Ux,Uz>=0 and L<=Ux+Uz, including zero-mass masks.

For target totals SX,SZ, the Minkowski sum of these sixteen polygons is characterized completely by

    sum max(0,L−Uz) <= SX <= sum Ux,
    sum max(0,L−Ux) <= SZ <= sum Uz,
    SX+SZ >= sum L.

Here and below each sum is over masks. This is a complete characterization, not only a necessary screen.

A constructive proof avoids any general polyhedral theorem. Start x_m=max(0,L_m−Uz_m). Allocate the remaining required X mass first to coordinates below min(Ux_m,L_m), and then to any remaining X capacity. Every unit allocated in the first stage decreases the necessary Z mass by one. For a feasible X total, the smallest attainable Z total is exactly

    max(sum max(0,L−Ux), sum L−SX).

Set z_m=max(0,L_m−x_m), then add Z mass up to Uz_m until reaching SZ. The five aggregate inequalities are exactly the conditions that make these steps succeed. All operations preserve rationality. The implemented construction was compared against an independent exact rectangle/sum-interval intersection test on35,721 two-pattern cases, and checked on1,008 three-pattern rational cases.

## The actual obstruction and its attribution

The accepted capacity allocation fails the X lower-total condition by approximately0.00090932223984. Only masks2 and9 contribute, and Z51 attains the active bound in each. The frozen sparse row is

    sum_{m in {2,9}} [
      yX[m,614] + yX[m,281] + yZ[m,51] − lambda[m]
      − t[m,614,51] − t[m,281,51]
    ] − S(X614,X281) <= 0.

This particular row needs no physical K2,2 theorem. For Boolean x,k,z,

    xk−x−k−z+1+xz+kz = (1−z)(1−x)(1−k)+zxk >= 0.

Multiply by a pattern indicator, take expectations, and sum only the two chosen disjoint patterns. The omitted same-sector pair masses are nonnegative. All256 anchor-pattern/center-bit assignments verify the resulting row directly; all16 K2,2 center assignments were checked separately. The exact rational gap and frozen branch choices are in `two-basis-results/owner-k22-conditional-union-point22.json`.

The new information is consistency of conditional Boolean moments with a global same-sector pair total. It rejects the supplied auxiliary allocation, even though its complete selected owner flows and neighbor capacities pass. It does not exclude the global point: changing the conditional allocations or the shared law may repair it. No rank-completeness claim or source-global moment cut follows without further exact elimination.

Independent acceptance is now recorded in `two-basis-results/owner-k22-conditional-union-point22-independent.json`, status `PASS_EXACT_CONDITIONAL_BOOLEAN_UNION_AUXILIARY_ROW`. Its separate consumer reconstructs the fresh global S coordinate7847, actual parent allocations and shared cells, exact gap,256 truth cases, eight Boolean identity assignments, and eight rejected corruptions without importing the producer.

## Complete finite extension, prepared mathematically only

Append32 explicit variables sX_m,sZ_m, retaining all sixteen masks. Add two global sum equalities and112 inequalities: per mask, two nonnegative-pair rows, four singleton rows, and one empty row. Keep all four shared t cells unchanged. This implements the complete conditional four-center law instead of adding a sequence of active-choice cuts.

The full unreduced capacity model would grow from22,481 to22,513 variables and from98,730 to98,844 text rows, before any exact zero-face reduction. A pinned zero-mass mask forces both new pair variables to zero; no pin may be silently transferred to an unrestricted-law run.

Each new variable is a probability. Its nonnegativity is explicit; for example, sX_m+sum_j t_ij<=yX_i and existing t>=0 imply sX_m<=yX_i<=lambda_m<=1. A future residual-correction guard must verify this exact combination for each new variable. The old allocation-only guard cannot be reused unchanged. Any reduced primal must be expanded and replayed against all full semantic rows. No model edit or solve has been launched by this audit.
