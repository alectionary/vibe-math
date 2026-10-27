# Pool restrictions under matrix inversion

- Canonical target: `L-F91-c16-unrestricted-width`, Lee arXiv:2610.06820v1 Proposition9/equation50; issue https://github.com/alectionary/vibe-math/issues/8 .
- Follow-up authorized by “Proceed to study the pool restrictions under matrix inversions, as you suggested.”
- Session: `codex-c16-inversion-20261027T190522Z`; start2026-10-27T19:05:22Z.
- Separate branch `research/c16-inversion-20261027T190522`, based on `e6280e125e67a3f7c583c2b5559ed38e20f4f8a2`. Prior PR17 is open and review-required; no master publication or rule override is claimed.
- First bounded review endpoint20:35:22UTC; stop experiments by20:15 and reserve the remainder for verification/preservation. No new global exhaustive campaign. Short exact computations test candidate structural statements.
- Current answer: width16 or18; best physical partial frame88 pairs; no Lean completion.

## Answer contract

The source question is existence of an invertible binary128-by128 matrix U whose columns are in the complete X pool and whose inverse-transpose columns are in the complete Z pool. A full physical128-pair witness or a complete obstruction answers the source. This block's first milestone is a proved, source-specific necessary inversion condition or an exact algebraic normal form that substantially reduces its analysis. A partial identity or rejected strategy does not silently replace the source question.

The study must retain arbitrary binary bases, including asymmetric ones. An8-by8 matrix over the cyclic coefficient ring represents a restricted regular basis and is not automatically equivalent to the unrestricted question. Likewise, generic dual-basis and Nakayama theorems do not preserve membership in the finite weight16 pools.

## Prior evidence and choice of route

The basic degree-two SDP is exactly feasible at128, quarter-turn invariant frames are excluded, and the stronger phase model remains unresolved. The source pool has45 free cyclic orbits per sector, organized into five physical-column groups. Existing global search, ordinary span tests and fixed-form deformations do not settle inversion constraints.

A new read-only advisory check found eight orbit pairs giving a128-dimensional block-triangular support minor. Consequently every scalar matrix over every field with the same zero/nonzero pairing pattern has rank at least128. This eliminates a broader scalar weighted-support rank<=127 certificate. The explicit witness is preserved in `inversion-results/triangular-support.json` and independently replayed by `replay_inversion.py`. It is a method limitation, not a frame.

We now prioritize the structure of allowed inverse matrices over another search-time extension: identify exact pool families and which algebraic restrictions constrain both a basis and its dual. Any proposed tensor/module simplification needs a checked source bridge. Written proofs, exact computations and hypothetical lemmas will be labeled separately.

## Ownership

The unique scope commit was pushed and the canonical claim acquired create-only, then read back at `d3c0bc0e6479a032ea2a1aae41c67fc96d9d8caf` before substantive research. The ownership commit stays fixed while the work branch advances. Release only that expected SHA after preserving the handoff. No Project or external announcement is requested; do not post issue comments.

## First algebraic results

There is an explicit fixed change of ambient cyclic-ring coordinates and its
adjoint dual change identifying the logical space with2-by2 matrices over
S=F4 tensor_F2 R, R=F2[t]/(t^16-1). Let omega^2+omega+1=0. All720 vectors in
each sector are primitive rank-one matrices. These coordinate changes do not
restrict the selected basis and therefore retain asymmetric frames.

More precisely, after redistributing fixed unit scalars between tensor factors,
the X pool is exactly {t^h a_i tensor b_c : i=0..8,c=0..4,h=0..15}; the Z pool
is exactly {c_d tensor t^h d_j : d=0..4,j=0..8,h=0..15}. All720 generated points
are distinct and agree with the saved source pools. The binary pairing becomes
Tr_F4/F2 CT(sum M_ij N_ij^*), with t^*=t^-1 and omega^*=omega. The explicit
coordinate maps, factors and full generated coordinates are in the normal-form
certificate. No assumption that a full frame itself is a tensor product is made.

The five b_c generate an R-submodule B of binary dimension61 in S^2, and the
five c_d generate a corresponding C of dimension61. Each is the kernel of a
surjective three-coefficient congruence Tr(q dot v)=0 modulo epsilon^3, with
primitive q. Consequently each becomes R^3 direct_sum epsilon^3 R under an
S-linear coordinate change. The output includes explicit q and verifies all
jet ranks4j-min(j,3).

For any selected dictionary types U={a_i}, let L=span_R U and M=span_S U. An
S-linear right coordinate change takes B to (R+epsilon^3 omega R) direct_sum S.
Hence span_R{u tensor b:u in U,b in B} is isomorphic to
(L+epsilon^3 M) direct_sum M. This gives an exact dimension formula, rather than
an enumeration of full frames. It has been checked against literal binary ranks
for all512 type subsets on each side.

In particular, full128-dimensional span forces M=S^2 and
L+epsilon^3 M=M. Nakayama (or direct nilpotent iteration) then gives L=M. Thus
any full X basis must use dictionary types whose four-bit augmentations span
F2^4; the analogous condition holds for the Z right dictionary. At least four
types are required. Any three types span at most125 dimensions;64 of the126
four-type subsets span fully in each sector. These are necessary conditions,
not a complete inversion obstruction.

## Residue obstruction and the missing implication

The residue pools modulo epsilon have32 distinct vectors per sector in binary
dimension8. Their maximum canonical partial frame size is exactly7: an explicit
seven-pair witness is checked, and the eight-pair CNF is UNSAT with a checked
DRAT certificate. This is an exact statement about the residue pools.

It does not settle C16. A new small counterexample shows that a full primitive
binary dual frame under a free orthogonal cyclic action need not descend to a
full residue frame. In period2 and dimension8, a16-vector common pool contains
a full eight-pair frame, whereas its four-dimensional residue pool has maximum
frame size2. The explicit matrices and proof will be preserved. Therefore a
source-specific lifting theorem needs additional hypotheses; it cannot be
silently imported from generic cyclic-module arguments.


## Written proofs and the exact source bridge

These are ordinary mathematical arguments supported by exact finite certificates.
They have not been formalized in Lean. Binary vector coordinates use eight
16-bit cyclic blocks. An S element is `[a,b]` meaning a+b omega, with each
integer a polynomial in t encoded by its bits. Matrix entries have order
[00,10,01,11]. All conventions and explicit maps are in
[inversion-results/normal-form.json](inversion-results/normal-form.json).

### Deriving the field and tensor coordinates

Take the four independent R generators from physical-column group0 and four
from group3. Their augmentation matrix is nonsingular, hence the resulting
8-by8 R matrix is invertible: over R an element is a unit precisely when its
augmentation is1. This is an ambient coordinate change, not a restriction to
R-linear selected frames. The other three column-group spans are graphs.
Normalize the graph of group4 to the identity and call the other two J1,J2.
The exact source equations are

    J1^2 = a I + b J1,       J2 = u I + v J1,
    (a,b,u,v) = (54483,20161,53749,18249).

Here b is a unit. Put d=1+a/b^2 and c=d+d^2+d^4+d^8. Direct source computation
gives augmentation(d)=0. Since the augmentation ideal is (epsilon) and
epsilon^16=0, d^16=0 and c^2+c=d. Thus

    Theta = J1/b + c I,       Theta^2+Theta+I=0.

An explicit R basis puts Theta into two standard omega blocks. This gives the
S^2 factor coordinates. The five graph slopes are 0, `[5658,20161]`,
`[12894,40384]`, infinity, and1. The middle two have the same residue but their
difference has epsilon-adic valuation1. Literal factorization of all45 orbit
roots, followed by redistribution of fixed unit scalars, gives the nine-by-five
Cartesian dictionaries. The certificate consumer independently regenerates all
720 vectors on each side and compares their sets, not just their spans.

Let C be the fixed X coordinate map. The Z map is its adjoint inverse under
the binary coefficient pairing. Its S trace-dual conversion is (a,b) ->
(a+b,a), because Tr(omega)=Tr(omega^2)=1 and Tr(1)=0. The involution on R is
t -> t^-1. Independent checks cover all16,384 coordinate-basis pairings and
all518,400 source-pool pairings. Consequently all source Gram equations,
including those for arbitrary asymmetric binary bases, are retained exactly.

There is a further checked bridge for the physical sector exchange E. In the
new coordinates it is

    L(M) = P M^T Q,

with invertible P,Q over S. Their explicit entries are saved under
`sector_exchange`; the consumer tests all128 binary coefficient basis vectors
and all720 exchanged source vectors. This establishes a transpose relation
between the source dictionaries; it does not make the selected frame a tensor
product or a cyclic orbit basis.

### Thin-factor module and type constraints

For X let B be the R span of the five right factors. The saved primitive
S row q is `[(3,0),(7,5)]`. Every generator satisfies

    Tr(q dot v) = 0 mod epsilon^3.

The functional is onto R: one entry of q is a unit in S and the F4 trace is
onto R. Its three-jet kernel has binary dimension64-3=61. The literal R span
of the five factors has dimension61, so it equals that kernel. An S-linear
coordinate change takes q dot v to the first coordinate. Therefore

    B = (R + epsilon^3 omega R) direct_sum S

in suitable fixed coordinates. The Z thin factor has the same description,
with q=`[(4,5),(4,1)]`. This proves the jet-rank formula
4j-min(j,3), not merely a fit to the computed ranks.

Let U be any subset of the nine thick dictionary factors, L=span_R(U), and
M=span_S(U)=L+omega L. Applying that fixed thin-coordinate change to tensors
shows their R span is

    (L + epsilon^3 M) direct_sum M.                 (1)

Indeed its first column is L+epsilon^3 omega L = L+epsilon^3 M; its second
column is M. Hence (1) gives its exact binary dimension. All512 subsets per
sector also agree with independent direct binary ranks.

If this span has dimension128, both summands have dimension64. Thus M=S^2
and M=L+epsilon^3 M. Iterating this equality gives M=L+epsilon^48 M=L.
Conversely L=S^2 makes (1) full. Since R is local, L=S^2 precisely when the
augmentations of U span F2^4. These augmentation vectors are

    X: [1,2,3,4,11,8,6,10,6]
    Z: [15,5,10,1,8,2,4,7,4].

In particular at least four types must occur in either full basis. If only
three occur and M=S^2, their images modulo epsilon^3 span at most9 of12
binary dimensions, so (1) has dimension at most64+52+9=125. If M is proper,
its S-module quotient has at least one F4 composition factor, so dim M<=62
and (1) has dimension<=124. The finite catalogue attains125 and has exactly
64 spanning four-type subsets out of126 in each sector. More generally, for
any proposed frame the number of selected vectors from each type subset
cannot exceed its dimension in the saved rank profile. The known physical
88-pair frame passes all1,024 such inequalities.

These conditions constrain possible bases. No measured global search speedup
or exclusion of all full bases is claimed.

### A genuine inverse identity, and a local screen that did not help

Let Omega be multiplication by omega in the new coordinates, pulled back to
the original binary space. For a full dual frame U,V, with V^T U=I,

    K=V^T Omega U=U^-1 Omega U,       K^2+K+I=0.

The diagonal entries of this binary equation imply, for every selected pair i,

    sum over j!=i of beta(Omega x_j,z_i) beta(Omega x_i,z_j) = 1 (mod2).   (2)

Thus every selected pair needs an odd number of other selected pairs with
both auxiliary cross-pairings1. This is a necessary inversion identity. It is
already implied by the complete Gram identity, not an extra theorem beyond
that identity. A screen tested whether any candidate pair had no possible
compatible neighbor of this kind. All6,238 common-translation pair orbits
have such neighbors (minimum274, maximum4835), so it excludes no pair.
`screen_inverse_omega.py` reproduces that bounded negative result.

An equivalent full-frame formulation is also available: in binary dimension n,
exactly n allowed rank-one atoms x z^T sum to I if and only if they form a
canonical frame. Writing the selected columns as U,V gives U V^T=I; square
invertibility then gives V^T U=I. The exact cardinality n matters. A literal
control checks19,645 cases in dimensions2 and3, including impossibility with
n-1 atoms. The alternative XOR/cardinality solver returned UNKNOWN on both
small quotient trials (5s in dimension8 and30s in dimension16); no speedup or
full-C16 solver result follows.

## Reduced pools: what is certified, and what is still missing

Folding each cyclic block to period1 gives32 distinct pool vectors per sector
in binary dimension8. `quotient1-seven.json` contains a checked seven-pair
frame. `quotient1.cnf.gz` and its checked DRAT proof exclude eight pairs.
Thus the maximum in this reduced problem is exactly7. Period2 has90 vectors
per sector and binary dimension16; its30-second SAT run is UNKNOWN. The
123MiB incomplete trace is not a proof and is deliberately not bundled;
its size/hash and the reproducible CNF/log are retained.

The logical gap is precise: a binary128-pair frame in the original pools need
not provide eight individual pairs that stay dual after augmentation. The
counterexample in `verify_inversion_counterexamples.py` has a common primitive
free period-two pool, a full eight-pair frame, and a rank-four residue pool
whose maximum frame is only two. It refutes the generic descent assertion.
It does not verify the joint rank-one/Cartesian hypotheses of our source.

A separate F4 counterexample gives a full binary trace-dual rank-one frame in
M2(F4) in which no projective left or right factor line contains four of the
eight X vectors. Thus a generic argument that every product frame has a
half-basis in one factor line is also invalid for this trace pairing.

Two small transpose-Cartesian period-two controls over F2, of sizes18 and32,
are UNSAT with checked DRAT proofs. They supply test examples, not a general
lifting theorem: their coefficient field, dictionaries and period differ from
C16. No classification of all such controls is claimed. Similarly the
11 tested fixed-left-factor constructions fail because their right pairing
matrices have rank61<64; this excludes only that explicitly fixed-factor
construction, not all projective factor-line constructions.

A separate128-by128 upper triangular support minor, with128 diagonal nonzeros
and336 extra upper entries, proves every scalar matrix with the same pairing
zero/nonzero pattern has rank at least128 over every field. Consequently a
scalar weighted-support rank<=127 certificate cannot work. This is a method
obstruction, not an identity minor or a canonical frame.

## Evidence, literature scope, and next mathematical step

[Artifact guide and replay](inversion-results/README.md) bind the certificate,
models and proof files to their inputs. The independent consumer uses literal
polynomial convolution and a different binary elimination convention. Five
corrupted-certificate controls reject mutations to the coordinate map, a tensor
point, the thin functional, the type rank profile and the sector exchange.
No Lean toolchain was available in this block; no OpenAI/math file was imported
or compiled. The elementary nilpotent field lift above is a written argument,
not a claim of using a verified OpenAI library theorem.

Bounded primary-source search queries covered product/dual/biorthogonal bases
and finite fields; they identified no directly applicable theorem in the
returned results. No new academic full text was retrieved, so no new full-text
question screen or priority claim is made. A GitHub connector positive control
found the known TensorApproximation module in openai/math; a bounded query for
`biorthogonal product basis finite field` returned no match. Neither is an
exhaustive library audit. Authenticated X and current-resolution/exact-target
Lean discovery remain unassessed. Earlier source-screen gaps stay recorded.

The most focused next lemma is now source-specific: characterize binary
trace-dual bases drawn from the displayed nine-by-five primitive rank-one
Cartesian dictionaries, including the three-jet thin-factor congruence and the
transpose sector exchange. Determine whether these joint hypotheses force a
residue frame, or construct a counterexample satisfying all of them. A proof
of descent for these exact pools, combined with the certified residue maximum7,
would exclude128 and give width18. The generic counterexamples explain why
ordinary Nakayama or generic product-basis arguments do not supply that proof.

If descent fails, retain the exact tensor representation and study matrix
inversion with the first three nilpotent coefficients coupled; the full-rank
criterion (1) already identifies exactly which type sets can support a basis.
A higher-jet model needs a proved source bridge before its UNSAT result can
answer the original question. This is a defined research task, not a promise
that the missing theorem is true or quick.

The canonical answer remains **16 or18**, best physical partial frame **88**,
and completed Lean-target delta **0**. This block answers the requested first
structural milestone, not the open question.


## Preserved handoff, 2026-10-27 20:15:44 UTC

The bounded structural pass concluded70minutes22seconds after its19:05:22UTC
start, before the first review endpoint20:35:22UTC. No new experiment runs past
the20:15 cutoff. Successful code/data and ordinary proofs are preserved on the
inversion branch and in [PR17](https://github.com/alectionary/vibe-math/pull/17).
The GitHub connector independently returned research snapshot
`a59333233f9c4942c9a6e5ab1b858a94b41da480` with tree
`23d1e891e71b48268589fb21622ceb7f506b895b`, matching the local tree.
PR17 is OPEN, BLOCKED and REVIEW_REQUIRED; it has not been merged. No override
was attempted. Issue8 remains open and unchanged, with zero comments.

The canonical claim was released only after this preservation, using a lease
against `d3c0bc0e6479a032ea2a1aae41c67fc96d9d8caf`; server matching-refs then
returned an empty list. This session holds no claim. The final metadata commit
records this handoff; all mathematical certificates remain those of the
verified snapshot. [Structured handoff](inversion-results/handoff.json).
