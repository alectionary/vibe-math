# Exact phase-I singleton calibration

Let E be the physical zero ground, of rank127, and let q be the fresh conditional marginal vector restricted to E. Its total is127. For a finite collection K of valid physical bases, write A for their incidence columns. Consider

    min 1ᵀ(s⁺+s⁻)
    Ax+s⁺−s⁻=q, 1ᵀx=1, x,s⁺,s⁻≥0.

With the Lagrangian c·(q−Ax−s⁺+s⁻)+u(1−1ᵀx), the dual is

    max u+c·q
    −1≤c_j≤1, u+c(B)≤0 for every B in K.

This fixes the sign convention: an improving omitted column has u+c(B)>0. It has the opposite sign to the negative minimum-affine values used by the earlier feasibility-Farkas workflow. An exact primal and dual with equal objectives prove the finite-archive L1 distance. The primal is always feasible for a nonempty archive, so an exact infeasibility claim would indicate an implementation/input error.

For h(c)=max over all physical bases of c(B), one exact greedy support query gives the lower bound

    max(0,c·q−h(c)) ≤ distance_L1(q,conv(all bases)) ≤ D_K.

The upper bound is the exact restricted optimum D_K. It cannot increase when valid columns are appended. Thus the exact restricted objective is comparable between iterations, unlike arbitrarily normalized feasibility rays. This does not guarantee strict improvement after any particular batch or a useful bounded runtime.

If c·q−h(c)>0, sort c in nonincreasing order. With prefixes S_i and consecutive differences Δ_i≥0, the full gap is

    Σ_i Δ_i(q(S_i)−r(S_i)),

because q(E)=r(E)=127 cancels the final constant term. A positive gap therefore supplies an exact violated physical rank prefix. Its unnormalized source row is Σ_{j∈S}T(anchor,j)≤r(S)p_anchor. Conversely, D_K=0 supplies an exact zero-pool mixture; the independently reconstructed unit-owner law completes the singleton conditional basis law on all720 coordinates. Neither endpoint supplies an actual global source frame.

One bounded calibration is reasonable: use the current accepted orbit15 archive, solve the exact phase-I problem once, independently replay its primal/dual, and price one exact dual over the full physical ground. Stop on an exact zero objective or positive global gap. Otherwise, if authorized, append at most64 distinct physically verified exchange bases having u+c(B)>0 and solve once more. Compare exact objectives and bounds, then stop on no objective decrease or the fixed budget. Affine diversity of a batch can be checked but does not prove that its columns remove the current obstruction. No automatic20-round continuation or finite-time completion guarantee follows.

Acceptance must independently bind the fresh point, physical ground, archive columns, all rational equations, nonnegative variables, |c|≤1, every finite-archive dual inequality, exact primal/dual objective equality, and the signed full-ground prefix support. Numerical objective values or a finite-archive failure alone are not global certificates.
