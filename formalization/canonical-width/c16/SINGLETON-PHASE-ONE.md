# A bounded dual and a measurable archive distance

This is a continuation of the point22 selected-conditioned singleton tests.
It does not change the C16 source question or the405-case sufficient cover.
The zero-pool target is an exact vector q of total mass127. Every archive
column is the incidence vector of a physically checked rank127 basis.

For an archive matrix A, minimize

    D = sum_j (splus_j + sminus_j)
    A x + splus - sminus = q
    sum_i x_i = 1
    x, splus, sminus >= 0.

The optimum is exactly the L1 distance from q to the convex hull of the saved
bases. The program is always feasible when the archive is nonempty: choose
one basis and split its coordinate residual into positive and negative parts.
An exact primal and exact dual of equal value certify the optimum. The dual is

    maximize u + c*q
    u + c(B) <= 0 for each saved basis B
    -1 <= c_j <= 1.

Thus the objective is comparable between successive archives and the dual
coefficients have a fixed normalization. This addresses the arbitrary scaling
of infeasibility rays; it is not a claim of faster convergence.

Physical matroid greedy optimization, using signed exact coefficients c,
finds h(c) = max_B c(B) over every basis of the full zero pool. The quantity

    Delta = c*q - h(c)

is then a valid global separation gap. If Delta is positive, sort c in
descending order. The greedy prefix-rank identity expresses Delta as the sum
of successive nonnegative coefficient differences times q(S)-rank(S).
The terminal coefficient cancels because q(E)=rank(E)=127. Some prefix with
positive coefficient difference must therefore violate a physical rank bound.
This subset can be checked by the existing rank consumer and translated into
the global moment row sum_{j in S} T(i,j) <= rank(S)*p_i.

If the exact primal optimum is zero, its nonnegative basis weights match every
zero-pool marginal. The independently checked unit-pool simplex completes all
720 selected-conditioned marginals. This proves this singleton necessary
condition at this point; it does not construct a common dual frame.

If D is positive and Delta is nonpositive, the maximizing physical basis is
absent from the archive: u+h(c) >= u+c*q = D > 0, whereas every old column has
u+c(B) <= 0. It is a justified new column, but there is no global obstruction.
Adding it cannot increase D. Strict improvement is not guaranteed because a
different optimal dual may keep the same value. Finiteness of the physical
basis set does not provide a useful wall-clock bound.

The initial calibration uses the3,225-column orbit15 archive after the
64-exchange experiment. Exactly one60-second internal/90-second external LP
is authorized initially, followed by independent exact primal/dual and full
greedy replay. Further rounds require an explicit evidence-based decision.
The frozen preparation and result files record whether that run completed;
this mathematical note itself makes no solver-outcome claim.
