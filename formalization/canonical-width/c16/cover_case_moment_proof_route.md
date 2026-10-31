The cyclic/sector averaged necessary model can certify exclusion of an
individual selected-pair cover case. The required bridge is a lower bound on
one averaged cross moment, not an assertion that an averaged marginal equals
one. No case has been excluded by this audit. The source interval remains
16/18, the cover remains405, and completed full source anchors remain zero.

For a source selection write x[i,t], z[j,t] for its binary indicators. With
G=C16×C2 acting by simultaneous phase rotation and sector exchange, the model's
cross moment is

    T_h[i,j] = (1/32) Σ_t (x[i,t] z[j,t+h] + z[i,t] x[j,t+h]).

All phase indices are modulo16. The physical symmetry bridge was replayed:
both pools have720 distinct vectors, every one of the90 sector/phase orbits
has binary rank16, the three symmetry graph ranks are128, and the pairing
matrix is preserved by rotation and transposition.

Suppose the actual frame contains the selected matching edge
e=(X_(i,0),Z_(j,h)). Each element of Stab_G(e) contributes one to the above
32-term sum. Consequently

    T_h[i,j] ≥ |Stab_G(e)|/32 = 1/|G·e|.

A rotation alone fixes the typed edge only at rotation0. A swap followed by
rotation r fixes it exactly when i=j, r=h, and2h=0 mod16. Therefore the floor
is1/16 for i=j and h∈{0,8}, and1/32 otherwise. The405 retained cases contain
15 cases of the former kind and390 of the latter. Frame stabilizers may force
larger counts in a particular frame; they do not justify increasing this
uniform floor. Pair-only indicator controls attain the stated combinatorial
floor, but those controls are not full frames.

The averaged orbit of a frame containing e need not consist entirely of frames
containing e. That causes no problem: all averaged frames satisfy the global
necessary rows, and the identity/stabilizer contributions establish the floor.
Conversely, a moment point satisfying the floor is not a frame or a common
joint distribution. The method is a necessary test for the full anchor case.

For the requested example, cover tuple(5,11,10) has physical anchor(80,186),
physical pairing1, and orbit size32. Its constraint is

    T_10[5,11] = T_6[11,5] ≥ 1/32,
    -32 * owner_vector[30920] ≤ -1.

The transpose for phase10 is essential. T_0 diagonal coordinates are cross
moments and must not be replaced by p. The existing405 cover's completeness
and nested proof chain remain separate dependencies; the new bridge checks
the physical identity and floor for every retained case without modifying
that cover.

`cover_case_moment_bridge.py` and its independently implemented consumer
`verify_cover_case_moment_bridge.py` replay the405 floors and owner-coordinate
translations. Receipts are
`coupling-results/cover-case-moment-bridge-witness8.json` and
`coupling-results/cover-case-moment-bridge-independent.json`.
The peer strategy audit separately confirmed the stabilizer argument.

Repository searches of Python sources, research notes, and frozen command
records found no prior selected-cover-pair floor SDP before this pilot.
Earlier half-turn moment tests explicitly restricted source-frame symmetry;
earlier anchor-conditioned profile/rank rows and local hull tests did not
impose this selected-pair floor on the global averaged model. The existing
`block_moment_dual.py` already implements the relevant residual-corrected
Farkas idea for a different block SDP. This is evidence about the examined
repository, not a claim that the idea has never been considered elsewhere.

One authorized necessary-model pilot was run for(5,11,10). The new file
`case_floor_coupling_model.py` is a copy of
`unified_multi_orbit_coupling_model.py` with the verified floor, a mandatory
zero artificial-margin gate, and additional case/canonical output. Root's
model files were unchanged. Its frozen row bank contained27 accepted partner
rows,286 conditional rank rows,3 projected rows, and128 selected Boolean rows,
plus the previous physical/profile/ownership/linear families. The warm seed
was accepted multi-witness8. The SCS limit was120 seconds; it solved in14.92
seconds of solver time, with the complete call taking53.24 seconds.

The numerical result had T_6[11,5]≈0.03406772 and floor slack≈0.00281772.
Its first exact recovery failed the interval PSD check; that failed candidate
and log are preserved. A deterministic rational blend of31/32 of that
candidate with1/32 of accepted multi-witness8 required no second model solve.
The blend passed exact PSD/profile, all physical/legacy/286 rank rows, all3
projected rows, all27 partner rows, all128 selected Boolean rows, and the
global conditioned screen. Its exact case moment and slack are

    T_6[11,5] = 75491874994233 / 2251799813685248,
    T_6[11,5] - 1/32 = 5123130816569 / 2251799813685248 > 0.

This is an exact feasible point for the finite case-conditioned model. It
prevents exclusion of this case by precisely that model. It does not pass the
broader all-triple gate: one omitted triangle on events[256,556,1439] has exact
violation362841476407/1125899906842624, approximately0.00032227. The direct
triple-distribution consumer rejects the same candidate. Thus the case with
all Boolean triples remains unresolved. The mixed-point certificate is
`coupling-results/cover-case051110-mixed-rational.json.gz`; the summary is
`coupling-results/cover-case051110-mixed-checks.json`, explicitly labeled
`PASS_FINITE_CASE_RELAXATION_ONLY`. No second SDP was run. The accepted global
multi-witness8 point already satisfies9 of the405 correct floors, so those9
also cannot be excluded by the same finite model.

For a future case, two concrete numerical formulations are valid:

1. Add the integer row -|G·e| T_e≤-1 and solve feasibility with every artificial
   PSD/Boolean/projected margin zero.
2. Keep the base feasible model and maximize T_e. A rigorously certified upper
   bound below1/|G·e| excludes the full anchor. Changing only the objective
   permits a shared canonical model and warm starts. A numerical optimum or
   SCS infeasibility status is discovery evidence only.

To turn either result into a source proof, reconstruct semantic constraints
from their exact source compilers. Do not treat the saved floating canonical
matrix as the source model. Let z contain independent p,S,T coordinates and
the profile weights. All these variables lie in[0,1]; each profile weight is
nonnegative and its orbit's weights sum to one. Write the source constraints
as Az=b, Gz≤h, and F_k(z)=F_k,0+Σ_j z_j F_k,j≽0. The case floor is one of the
integer rows of Gz≤h.

Choose rational equality multipliers μ, rational nonnegative inequality
multipliers λ, and certified PSD matrices Y_k. Define

    r_j = (Aᵀμ+Gᵀλ)_j - Σ_k tr(Y_k F_k,j),
    β   = bᵀμ+hᵀλ + Σ_k tr(Y_k F_k,0).

Every feasible z satisfies r·z≤β. Exact stationarity is unnecessary, because

    r·z ≥ Σ_j min(0,r_j).

Thus β < Σ_j min(0,r_j) is a contradiction. With certified intervals
r_j∈[l_j,u_j] and β≤B, the sufficient check is

    B - Σ_j min(0,l_j) < 0.

The case-row multiplier contributes -λ_case to β when the row is
-|G·e|T_e≤-1. Since the accepted global point proves the base model feasible,
a genuine contradiction must depend on the case condition. Removing the
floor is a useful negative control.

For an optimization certificate with objective c·z=T_e, put
a=Aᵀμ+Gᵀλ-Σ_k tr(Y_k F_k,j) and ρ=c-a. Then

    c·z ≤ β + Σ_j max(0,ρ_j).

An interval upper bound below the floor is a source-case exclusion. If box
correction is too loose, the exact profile-simplex constraints give
Σ_s r_(o,s)w_(o,s)≥min_s r_(o,s) for each orbit. Other already proved bounds may
tighten the correction, but must be replayed rather than assumed.

Practical certification steps are:

1. Extract an SCS ray or objective dual, undoing row normalization and the
   SCS symmetric-matrix packing conventions. The off-diagonal sqrt(2) factors
   are a discovery conversion, not exact proof data.
2. Round equality and nonnegative inequality multipliers to rationals. Rebuild
   each PSD multiplier as an exact rational Gram product LLᵀ, or symmetrize and
   certify a rational matrix after an explicit diagonal inflation. Any change
   is accounted for in the freshly computed residual; no stationarity repair
   is required.
3. Reconstruct the true Fourier coefficients. Here cos/sin(kπ/8) lie in the
   real algebraic field generated by θ=2cos(π/8), θ⁴-4θ²+2=0. Either exact field
   arithmetic or high-precision outward Arb intervals is suitable. Binary
   `math.cos`/`math.sin` values are not exact source coefficients.
4. Compute r and β from the exact integer/rational row banks and those rigorous
   Fourier enclosures. Check the strict interval residual inequality above.
   Preserve the exact accepted row-bank bindings, case bridge, variable-bound
   proof, PSD multiplier proof, and independently reconstructed cone layout.
5. Replay with a separate consumer. Test a corrupted phase/floor, a negative
   inequality multiplier, an indefinite PSD multiplier, and a removed case
   row. A passing exact contradiction excludes the full physical anchor,
   after which the canonical cover update remains root-owned.

The saved canonical A,b,c, cone dimensions, variable offsets and SCS arrays
from this pilot are available as discovery/mapping data. No infeasibility ray
was produced here, and no general full-model dual consumer was implemented
during this bounded audit.
