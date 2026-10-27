# Four-hour inverse-pool continuation

- Canonical target: L-F91-c16-unrestricted-width; issue https://github.com/alectionary/vibe-math/issues/8 . This is a follow-up, not a new source question.
- Source: Lee arXiv:2610.06820v1, Proposition9/equation50, with previously independently checked complete physical pools and mixed-Pauli bridge.
- Session: codex-c16-four-hour-inverse-20261027T202223Z.
- Authorized start: 2026-10-27T20:22:23Z. User asks to proceed for the next four hours. Endpoint: 2026-10-28T00:22:23Z. Stop new experiments by23:50UTC and reserve the remaining32minutes for verification, reconciliation and preservation.
- Work branch: research/c16-four-hour-inverse-20261027T202223, based on4a3d2bed698d717b29b21fb95981ae8a69385483, isolated worktree /private/tmp/c16-four-hour-inverse-20261027T202223.
- Previous block: INVERSION.md and inversion-results/verification.json. Exact tensor normal form, thin-factor congruences and necessary type constraints are established. Reduced maximum7 is certified, but source-specific descent is unproved and generic descent is false.
- Current answer: width16 or18; best physical partial frame88/128; no Lean completion.

## Answer contract

Question/source -> intended answer -> decisive evidence: Does the original source's complete minimum-weight pool contain a binary128-pair dual frame? A checked physical frame gives width16; a faithful complete obstruction gives width18. This block attacks inverse-transpose membership in the exact Cartesian tensor pools. It may produce a proved structural restriction or a counterexample to the proposed source-specific reduction. Such a result is reported at its actual scope and does not silently replace the original question.

First priority: determine which additional joint tensor/thin-congruence/transpose-exchange hypotheses can justify residue descent. Study unrestricted binary bases U and inverse transpose U^-T; impose neither cyclic invariance nor a tensor-product form on U. Use short exact examples to refute unsound implications, then derive source-specific identities at the first three nilpotent coefficients. No blind extension of the previous billion-node global campaign.

Ownership is acquired create-only at this scope commit and read back before substantive work. Do not mutate issue8 or post external comments; no such messages are requested. Preserve progress through the existing research PR17. Required review blocks master integration; do not override protection. Release only this session's expected claim SHA after preservation. Research and publication status remain separate.

Literature/source accounting: frozen source meaning is reused. Any new full text must follow the current acquisition/screening workflow. Current-resolution, exact-target Lean discovery and authenticated X gaps remain explicit until actually completed. No paper-only proof is promoted to Lean completion.

## First-hour results (ordinary proofs and exact finite certificates)

The unrestricted source question is still open. The principal completed result
is a counterexample to proposed aggregate residue descent, not a counterexample
to the C16 width question.

### Aggregate residue descent fails in the same128-dimensional ring model

There are explicitly enlarged Cartesian dictionaries over the exact original
R=F2[t]/(t^16-1), S=F4 tensor R with the following properties:

- Both original720-point pools are contained in the enlarged pools.
- The source residue point sets are unchanged (32 points per sector), as are
  their eight-dimensional pairing problem and its certified maximum frame7.
- Primitive rank-one form, free cyclic action, the source transpose sector
  exchange P M^T Q, and the exact61-dimensional three-jet thin modules remain.
- An explicit128-pair trace-dual frame exists in the enlarged pools.

The first checked version has dictionaries35-by14 and7616 points per sector;
its selected frame retains16 original X points and zero original Z points.
The independent consumer uses epsilon-polynomial convolution over a literal
F4 table rather than the generator's t-basis cyclic arithmetic, and checks all
16384 frame pairings, all256 frame determinants, source-pool containment, residue
maps, cyclic primitivity, the Cartesian exchange and both module ranks61. Four
mutated certificates are rejected.

A sharper version retains the **five exact source thin-factor orbits** in each
sector and adds thick scalar representatives only. Its enlarged pools have1680
points per sector. No new thick S-projective direction is used: the difference
is in the permitted scalar representatives on the existing directions. Its
selected frame has no pair from the original pools. The independent epsilon-polynomial consumer passes for this sharper certificate.
Its thick dictionary has21 cyclic phase orbits, compared with9 in the source;
12 factors lie on new R-scalar rays within the existing S-projective directions.
Both sectors of its full frame use just two exact thin-factor families. Thus
the original-pool restriction below depends on the finite thick dictionaries.

Construction: first solve a binary16-pair rank-one frame over
F4[eta]/eta^2, retaining source residue points and stated factor restrictions.
A duplicate-augmentation template reduces its remaining lift equations to a
binary linear system. Embed eta=t^8+1 into S. The phases t^r, r=0..7, give eight
orthogonal copies under constant-coefficient trace, hence128 pairs. Dual ambient
left/right changes preserve the pairing and map the two used thin-factor lines
to exact source thin-factor lines. Source-specific finite factors and scalar
normalizations are supplied in the certificates. This construction does not
select vectors from the original720-point pools.

Consequently the joint module/rank-one/residue/transpose hypotheses do not
justify descent. A proof for the exact source must retain its fixed finite
thick scalar choices; an argument using just projective directions is also
insufficient. This result does not claim that exact-source descent is false.

### An actual source restriction: at least three thin families in each sector

Use the unique thin projective family of each original pool point. A full frame
needs at least two thin families per sector because one has binary span64.
The thin pair{1,2} shares a residue line and has total X span124, so it cannot
support a basis. Every other pair is unimodular over S. If X uses such a pair,
its128 selected X vectors split into two64-dimensional spaces and each subset
spans its space. A selected
Z vector in the dual part must therefore have its right thick line orthogonal
to the other X thin line. Each dual part has64 independent Z vectors.

A right thick S-line represented by only one R-orbit cannot supply64: the left
thin factors span only61 over F2. The source has just two right thick S-lines
with more than one R-orbit (sizes3 and2); their orthogonal thin partners force
X thin families{3,4}. The symmetric argument forces Z thin families{3,4}
whenever Z uses only two. These statements retain asymmetric binary bases.

If both sectors use only two, each of the four cells has binary dimension32
and must supply32 pairs. In the cell with X left line e2, source X thick
types{3,5}, and X thin family4, there are exactly32 possible X vectors. They
are independent, so all must be selected. The compatible source Z cell has
thin family4 and thick types{3,5}; only16 of its32 vectors have a unit pairing
column against those32 X vectors (the other16 columns have weight2). Thus it
cannot supply32 dual partners. This excludes the two-by-two thin-family case.
The corresponding X-thin-family3 cell also has only16 unit columns among48
Z candidates. An asymmetric128-vector X-basis control with just one critical
monomial verifies that this argument assumes neither cyclic invariant bases
nor a large critical monomial count.

A stronger result excludes two thin families in **either sector individually**.
If X uses only{3,4}, the64 selected points with thin factor B4 must pair to
64 source Z points with right thick types{3,5}. This forced block has144
candidate X points and160 candidate Z points. Its necessary degree-two cyclic
moment SDP is infeasible, certified by `block4-dual64.json`. Cyclic averaging
is applied to moments of a hypothetical arbitrary frame; no frame symmetry
is assumed. One dummy X orbit pads the rectangular block to10-by10 orbits.

The certificate uses denominator2^40 and12822 scalar linear terms. If Ax<=b
are its source moment inequalities, Y is its rational PSD moment dual, and r
is the exact stationarity residual, the0<=moment<=1 bounds give
b dot y >= sum(min(r_j,0)). The certificate instead has

    b dot y numerator = -1099511517836
    residual box lower numerator = -35197114
    contradiction gap numerator = -1099476320722 < 0.

The independent consumer checks every scalar row against the source moment
constraints and every integer residual exactly. It verifies the rational dual
matrix is PSD using256-bit Arb interval arithmetic on nine Fourier blocks
(dimensions21, then seven40s, then20). Rational preconditioning and strict
Gershgorin bounds make this a checked interval proof, not an eigenvalue tolerance.
The physical88-pair frame supplies a40-pair positive block control; all82 unique
equalities and12740 unique inequalities pass at their exact moments. Four
corrupted dual certificates are rejected.

The physical sector exchange L(M)=P M^T Q is beta-self-adjoint (all16384
binary-basis pairings checked) and bijects the original720 pools while preserving
the thin owner labels. Therefore (X,Z)->(L^-1 Z,L X) preserves the canonical
Gram matrix and transfers the one-sector obstruction to Z. The integrated
consumer `verify_three_thin_theorem.py` rechecks all ten candidate thin pairs,
the forced block, the exact dual and this exchange. Consequently every full
original minimum-pool frame uses at least three thin families **in each sector**.
This is an ordinary computer-assisted partial theorem, not a Lean completion.
Three-to-five-family frames remain unresolved.

### One-sided inverse-pool cuts

For n selected X vectors B, a full canonical frame exists with those X vectors
and allowed Z duals precisely when every nonzero functional w satisfies

    count{x in B : beta(x,w)=1} >= 1 if w belongs to Z,
    count{x in B : beta(x,w)=1} >= 2 otherwise.

The first inequalities force B to be a basis. Its duals are exactly the
functionals meeting B in one point, proving the converse. This replaces a
pair-selection model by a one-sided selection problem with a separation oracle.
More generally the right side can be the minimum number d_Z(w) of allowed Z
vectors summing to w: expansion in the chosen Z basis has exactly the displayed
number of nonzero coefficients. This strengthening is necessary, not a claim
of measured speedup. Literal checks cover4504 small inverse-membership cases
and510 threshold-encoder cases.

For period2, the exact Cayley distance distribution is1,90,3330,39136,22979
at distances0,1,2,3,4. The uniform rational selection16/90 satisfies every
word-distance cover inequality, with minimum cleared-denominator margin18.
Thus that continuous relaxation cannot exclude16. Lazy, complete CP-SAT and
native-cardinality integer trials remain undecided at their bounded limits.
For C16 the complete two-sum diagnostic has minimum evaluation weight62 outside
the one-sum ball; no exact length-three sum has evaluation weight<=32. This
particular small-word screen yields no low-support global contradiction.

For a subspace W of functionals, a full frame also embeds W injectively as a
binary code on the selected X coordinates outside W-perp, with distance at
least min{d_Z(w):w in W, w!=0}. Hamming sphere packing (and puncturing for even
distance) therefore yields stronger subspace occupancy cuts. Their value on
these source pools has not yet been established; they are a possible next
mathematical strengthening, not a claimed obstruction.


### Source binary-rank inequalities strengthen the moment model

For any subset S of one source pool, a selected frame contains at most rank(S)
points in S. Multiplying by another Boolean selection variable and averaging
over cyclic shifts gives conditional inequalities as well as first-moment
bounds. These preserve arbitrary asymmetric frames. The rank is the literal
binary rank of finite source points, retaining the source scalar representatives.

All nontrivial rectangular thick-by-thin subcollections were enumerated:6283
per sector. In the first three-family model, X support contained in{0,1,2},
8205 applicable rectangles plus120 conditional rectangle bounds make the
necessary moment SDP infeasible. An exact rational dual has been checked by
an independent epsilon-coordinate consumer, recomputing all8205 ranks and
verifying its182807 scalar terms and nine PSD blocks. Its residual-corrected
gap is -1099384680689/1099511627776. This excludes that support, not every
three-family support. Other triples are being screened and only checked duals
will be promoted to exclusions.

A numerical full-five-family model with all12566 first-moment rank bounds and
120 conditional rectangles is still feasible, with no remaining detected
rectangle violation above2e-5. This is a floating-point result, not an exact
feasible-point certificate or a physical frame. The linear-only version of
the{0,1,2} model is numerically feasible, so the successful exclusion uses the
PSD moment constraint. No general runtime gain has been demonstrated.
