# A bounded two-probe, four-face gate

Fix an old anchor pattern m and two distinct, unanchored X probes u,v. Let M0
be the declared full Z-basis matroid for that pattern, including joint forced
zero contraction, effective owner bins and own-anchor deletion/forcing. Every
M0 basis is a full physical basis. Put A_u={z:beta(u,z)=1} and similarly A_v.

The selected-u domain is the face Bu=B(M0) intersect {z(A_u)=1}, if nonempty;
likewise Bv. Selection of both probes gives Buv=Bu intersect Bv. Distinct probe
functionals cannot share their unique owner in a full physical basis, so the
two face equalities enforce the required distinct owners. This relies on u,v
being nonzero, distinct from each other and from selected old X anchors.
Absence of a probe adds no opposite-sector restriction: the four opposite
domains are M00=M0, M10=Mu, M01=Mv, M11=Muv. Own-X completion remains relaxed.

Buv is the minimum face for weight 1_Au+1_Av if that minimum is exactly two.
Each individual count is at least one. If the minimum exceeds two, the jointly
selected domain is empty. If either individual selected domain is empty, its
corresponding selected masses must also vanish. The required minimum and face
rank can be obtained from M0 ranks at the two weight-level flats. Let
F0=E minus (Au union Av), F1=E minus (Au intersect Av), R=r0(E). The minimum is
2R-r0(F0)-r0(F1). When it equals two, the face is the direct sum of the minors
on F0, F1/F0 and E/F1. Its rank on S is

    r0(S intersect F0)
    + r0(F0 union (S intersect (F1 minus F0))) - r0(F0)
    + r0(F1 union (S minus F1)) - r0(F1).

These are ranks of the effective domain matroid, not uncontracted physical
rank on the whole pool. Forced owner bins remain effective singletons, and
forbidden elements remain loops. The original full-basis oracle can independently
check the face support and emptiness; no new matroid-intersection solver is
needed for this selected-only opposite-sector relaxation.

For a fixed allocation write a=yX[m,u], b=yX[m,v], lambda=lambda_m and introduce
kappa=Pr(A_m and both probes selected). Its four masses are

    mu00=lambda-a-b+kappa, mu10=a-kappa, mu01=b-kappa, mu11=kappa,

with max(0,a+b-lambda)<=kappa<=min(a,b). The known same-sector pair moment adds
sum_m kappa_m=S(u,v), with factor one and the usual physical phase folding.
At fixed kappa, opposite aggregate membership is exactly

    yZ[m] in B(mu00*r0 + mu10*ru + mu01*rv + mu11*ruv).

An exact colored-mixture certificate proves this local statement; a literal
rank obstruction gives an exact affine inequality in kappa. Thus each pattern
has a convex feasible interval of kappa values. A small interval master coupled
by sum(kappa)=S is a possible next gate. Do not assume the rank slope
r0-ru-rv+ruv has one sign, nor claim finite/polynomial convergence for an early
separation oracle. A failed membership query at one kappa does not exclude the
interval. Empty domains and lambda=0 need explicit zero-mass handling.

The aggregate-only four-face gate does not automatically dominate the completed
owner-flow model. Existing t[m,u,z] on nonzero edges prescribe selected-color
submarginals, whereas ordinary colored membership only fixes the aggregate
yZ[m]. To retain those flows one must also require sum_{sigma:u=1} z_sigma=t_u
and the analogous v equations on their represented edges. That is a constrained
four-color allocation problem; it is not supplied by the current ordinary
colored matroid oracle. A single-pattern, four-block LP with exact per-color
rank separation is a separate, bounded option (at most four 720-coordinate
blocks), not a claim that the whole coupled problem is solved.

Recommended next choice is diagnostic: after actual conditional full-basis
membership is known, freeze one pattern and one same-sector chosen-probe pair,
construct/replay all four domains and their weight-level ranks, and test a few
exact kappa values with the existing colored certificate consumer. Preserve
all returned affine kappa cuts. Only consider the constrained four-block model
if the aggregate gate passes and retaining the known flows is material. No
runtime estimate, broad model implementation, or source-frame conclusion is
asserted here.
