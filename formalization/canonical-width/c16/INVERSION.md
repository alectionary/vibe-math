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

A new read-only advisory check found eight orbit pairs giving a128-dimensional block-triangular support minor. Consequently every scalar matrix over every field with the same zero/nonzero pairing pattern has rank at least128. This eliminates a broader scalar weighted-support rank<=127 certificate. The explicit witness will be preserved and independently replayed in this block. It is a method limitation, not a frame.

We now prioritize the structure of allowed inverse matrices over another search-time extension: identify exact pool families and which algebraic restrictions constrain both a basis and its dual. Any proposed tensor/module simplification needs a checked source bridge. Written proofs, exact computations and hypothetical lemmas will be labeled separately.

## Ownership

Push this unique scope commit, acquire the canonical claim create-only, and read its server SHA back before substantive research. Keep its ownership commit fixed while the work branch advances. Release only that expected SHA after preserving the handoff. No Project or external announcement is requested; do not post issue comments.

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
