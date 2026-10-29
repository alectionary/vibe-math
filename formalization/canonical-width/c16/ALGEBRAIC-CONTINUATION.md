# C16 six-hour algebraic continuation

Research started2026-10-28T20:40:04Z; absolute endpoint2026-10-29T02:40:04Z.
New scientific work stopped2026-10-29T01:16:13.574583Z; final replay and
publication occupy the remaining bounded closeout.
Stop new experiments by02:10:04Z. Canonical target remains
`L-F91-c16-unrestricted-width`, Lee arXiv:2610.06820v1 Proposition9/equation50.
This is a continuation under the user's six-hour limit. The source answer is
still **16 or18**, the sufficient completion cover **418**, and the best checked
physical partial frame **88/128**. The cover starts at428 and falls by10
representatives (2.336%). No unrestricted
retained anchor has yet been excluded or completed.

The answer contract is unchanged: a physical128-pair minimum-pool frame proves
width16; a complete faithful obstruction together with the known upper bound
proves width18. Auxiliary parity domains and formal moment assignments do not
replace that question. This block compares bounded algebraic-certificate methods,
their actual memory use, and stronger full-basis constraints. The scope and
deadline are frozen in `algebraic-results/scope.json`.

## Measured outcomes and their scope

| Quantity | Checked outcome | Evidence |
|---|---|---|
| Original width | Still16 or18; physical partial frame88/128 | Prior source bridges; physical88 replay |
| Original signature-cover criterion |121 <= minimum cover size <=418 | [Fractional packing](algebraic-results/fractional-cover-packing-independent.json), [upper cover](algebraic-results/cover-418-independent.json) |
| Basic one-orbit masks |2545497 ->1439826,43.436% fewer | [Physical phase replay](algebraic-results/orbit-rank-profiles-independent.json) |
| Same frozen fixed48/48 cohort |688994 ->569075,17.405% fewer | [Conditional comparison](algebraic-results/anchor48-profile-gain.json) |
| Conditional occupancy bounds |711/2025 strictly stronger bounds | [45-row comparison](algebraic-results/conditional-capacity/comparison.json) |
| Original-coordinate small rank witnesses |4102 witnesses;22414 appended anchor clauses | [Witness replay](algebraic-results/small-conditional-original-independent.json), [model replay](algebraic-results/full-anchor-small-rank-independent.json) |
| Stronger real relaxation |Exact feasible point at128, including all4050 selected-anchor one-orbit convex hulls | [Rational point](algebraic-results/profile-moment-face1-independent.json), [local hull replay](algebraic-results/conditional-hulls-face1-recheck.json) |
| Pure inverse-linear exclusion |Cannot exclude any of428 starting anchors | [Positive physical span certificates](algebraic-results/span-independent.json) |

Local phase-mask percentages have different frozen denominators. They are not
fractions of eliminated full frames, and neither is the sufficient-cover count.
No finishing-time upper bound or global search speedup has been established.

## First independently checked outcomes

The343-equation partial-necessity model at anchor48/48 remained UNKNOWN after
300seconds. The monitored native solve peaked at256.36MiB. Python clause storage
was transient and was not the binding limit in that run. The later sparse
polynomial lifts did create hundreds of millions of stored terms. C++ does not
remove that mathematical growth. A new allocation estimate caps basis-vector
capacity, proof traces and working buffers in addition to resident memory.
Neither estimate is represented as a formal process-wide memory guarantee.

Complete degree-two formal binary moment assignments pass the independent
physical consumer for the378-edge known-UNSAT control and1252-edge hard
conditional domain, including the optional same-signature normalization. These
assignments are not distributions or matchings. They establish a limitation of
the stated degree-two parity/Boolean/conflict Nullstellensatz test. The343-equation
pilot used only128 variable multipliers and is explicitly incomplete.

Bosphorus4.1.0 reported the hard conditional ANF domain UNSAT. A separate
CaDiCaL1.9.5 run on the original conditional graph/parity CNF reproduced UNSAT,
and physical reconstruction plus DRAT-trim verified the proof. The domain was an
old82-removed-class trial at anchor112/387; both the starting90-omitted-class
cover and final100-omitted-class cover use different domains. Therefore this result does not establish a smaller current cover or
an unrestricted anchor obstruction. ElimLin learned no new facts in this test;
the solver's16 learned linear facts were the16 input identities.

The full inverse linear-span survey is complete for all428 starting anchors. Its positive certificates
are XOR decompositions of the residual identity using individually compatible
atoms. The independent consumer checks physical pairings and the full128-by128
outer-product identity, and rejects dropped-term corruption. Mutual compatibility
is not asserted. Producer span-rank numbers are not required by that consumer.

## Full-anchor comparison

`full_anchor_model.py` retains all53511 compatible original free edges at48/48,
including23268 zero signatures. Owner-presence equivalences and a fully defined
prefix threshold counter require127 free pairs. Biorthogonality bounds their
number above by127 in the anchor quotient. Thus a SAT witness would be a full
source-frame candidate. The counter passes3586 exhaustive small controls.

The initial ten-minute original full-anchor runs, with and without343 inverse
parities, both reached the wall limit. Xorcle also reached its limit. Native
CryptoMiniSat initialized the actual343-by30243 Gaussian matrix; its proof run
was stopped by a1GiB trace cap, without an accepted proof. Controlled native
comparisons and full-basis coverage constraints are being tested separately.

## Flat-saturation lemma

Let V have dimension n with a nondegenerate pairing. Let Xpool and Zpool be the
allowed vectors, and U a subspace. Write u=dim(U) and
v=dim span(Zpool intersect U-perp). If u+v<n, every full allowed dual frame
selects at most u-1 X vectors in U. Otherwise the ordinary bound u applies.

Proof: selected X vectors are independent. If u of them lie in U, they span U.
The other n-u selected Z duals annihilate those u vectors, so lie in U-perp and
are independent. They belong to Zpool, forcing v>=n-u, a contradiction. Sector
exchange gives the corresponding Z statement. The argument assumes a complete
dual frame. Applying it to arbitrary partial frames would be invalid.

This lemma is a static subspace form of the existing `rank_oracle.py` zero-domain test, not a new general principle. The new pilot enumerates source subspaces generated by one/two cyclic orbits
and thin-family unions. It records the entire pool closure and opposite
annihilator, then checks both ranks independently from physical coordinates.
A uniform first-moment point is tested with exact cleared denominators, so a
large number of valid cuts is not automatically reported as an obstruction.

## Certified one-orbit phase restrictions

For selected independent X vectors S, every other Z dual annihilates S. Their
span must therefore have dimension at least n-|S|. A witness w annihilating all
available Z vectors orthogonal to S, but outside span(S), proves this impossible.
If S is dependent, it is already impossible in a dual frame. A second witness
test uses all Z vectors whose pairing profile on S has weight at most one:
these contain every possible selected Z vector, so a nonzero annihilator of
this eligible pool also excludes S. In particular, a missing private-partner
class supplies such a witness. These are static uses of the earlier rank oracle.

Apply these tests to every subset of each source cyclic orbit. The native
producer scans45 times65536 phase masks; independent replay checks each retained
annihilator and the monotone coverage of forbidden masks. It does not trust the
producer's rank values. Surviving masks are only unexcluded by these tests.
They are not certified completable, so the maximum survivor size is an upper
bound on full-frame occupancy, not an attained maximum.

The basic count/private-owner test retains2,545,497 local phase masks. The
checked rank nogoods retain1,439,826: **1,105,671 fewer,43.436%**. Eight source
orbits have a full-frame occupancy upper bound5. Physical transpose symmetry
transfers the restrictions to the other sector. These local counts must not be
multiplied into a global frame count or confused with the sufficient cover.

A monitored native repeat reproduces all45 mathematical certificate records in
37.44seconds with sampled peak RSS2.656MiB. This compact table calculation and
the sparse polynomial lift have very different allocation growth, even though
both use C++. The repeat is a bounded hardware observation, not a general
language or complexity theorem.

## Conditioning and quotient coordinates

For a fixed allowed pair (x_a,z_b), the remaining full frame lies in the paired
127-dimensional spaces ker(z_b) and ker(x_a). A dual coordinate change sends the
fixed pair to coordinate0 and removes that coordinate. Every original free
vector and all518400 padded index-pairings are independently reconstructed;
ineligible indices are zero placeholders, not newly admitted vectors.

At anchor48/48, the old profile restrictions plus actual anchor availability and
the prior critical cap leave688994 local masks. The independently checked
conditional rank profiles leave569075: **119919 further exclusions,17.405%**.
Every old nogood is still covered. Some orbit upper bounds fall from5 to4.
The standalone quotient count/owner baseline826069 and its569316 rank survivors
use a different cohort; the comparison above applies the same prior critical
cap to both sides. No full anchor obstruction follows from these counts.

For X-only conditioning, the Z partner is not fixed. Choose any z_b with
beta(x_a,z_b)=1 solely as a coordinate gauge. Project every other original X
vector modulo span(x_a), and retain original Z vectors annihilating x_a.
If a full source frame contains x_a, removal of its actual, possibly different,
Z partner gives a127-pair dual frame in these quotient dictionaries. Thus
quotient nogoods are necessary for that X-only condition. Projected dictionary
points can be dependent or coincide; no regular basis or unique phase choice
is assumed. Dedicated dimension/zero-placeholder controls and direct physical
pairing replay guard this distinction.

## Coupling local restrictions to real moments

If a source orbit O has a pointwise occupancy upper bound c, then for any
Boolean selector x_a,

    x_a sum_h x_(O,h) <= c x_a.

Translation and physical sector-exchange averaging therefore give
sum_h S_h[a,O] <= c p_a and sum_h T_h[a,O] <= c p_a. These are real moment
inequalities, so characteristic-two coefficient averaging is not being used.
The prior cap11 for the critical orbit is also pointwise and is included.
All4050 scalar occupancy inequalities have been tested in the global and
half-turn moment models. Both runs returned numerical feasible points, with
explicit residuals rather than an exact feasibility claim.

There is an exact strict-strengthening result: the earlier certified rational
basic SDP point violates112 of these new inequalities. For example, at anchor
type X0 and counted type Z32, the bound is5 and the positive rational violation
is171266444553/1099511627776. This removes that old feasible point. It does not
prove that the strengthened relaxation or the source problem is infeasible.

If X-only conditioning at a yields a stronger orbit capacity m_(a,O), the same
argument gives sum_h S_h[a,O] <= (m_(a,O)+[a in O])p_a. A forbidden free phase
mask H also gives sum_(h in H) S_h[a,O] <= (|H|-1)p_a. For the initial X48 and
X192 cohort,180778 phase inequalities did not separate the saved numerical
point; one aggregate conditional-capacity inequality did. A45-type conditional
capacity cohort has passed independent physical replay for every row. Its2025
entries include711 bounds strictly stronger than the previous unconditioned
capacities, spread across all45 rows. No diagonal bound improves. The full
coupled model remains numerically feasible.

## Exact limit of the strengthened degree-two relaxation

`profile-moment-rational.json.gz` is a rational feasible point of the full
period16, sector-exchange-averaged degree-two relaxation, including the checked
one-orbit phase-profile hulls,4050 unconditional occupancy inequalities and2025
X-only conditional capacity inequalities. It has76008 rational coordinates,
including43473 nonnegative local convex weights. All631 exact equalities pass;
the earlier independent physical consumer checks1440 source-pool degree
equations and nine positive-semidefinite Fourier blocks using256-bit intervals.
Direct convex-combination and capacity checks are also replayed exactly.

Consequently this particular strengthened relaxation cannot exclude128 pairs.
This is a proved method limitation. Its formal moments need not arise from any
probability distribution or compatible full frame. The stronger constraints
still matter: they remove the earlier certified basic point in112 exact
inequalities (56 after sector-exchange averaging). Strict strengthening and
remaining feasibility are both established; neither settles width16 versus18.
The first recovery attempt lacked a full-rank correction-column set and failed
before producing a certificate. Its receipt is preserved separately.

A second bounded transfer of NulLA's degree-cutter idea admits previously
checked affine consequences as new polynomial generators. It lowers the378-edge
control to a degree-one contradiction. On the1252-edge hard conditional domain,
both complete degree-two formal witnesses satisfy all4816 added quadratic
generators. Thus these particular cuts do not remove that degree-two barrier.

## Conditional nonpartner bounds

Fix a selected source X vector x_a. Exactly one selected Z vector pairs to1
with it; all other selected Z vectors annihilate it. Projecting the other X
vectors modulo x_a and removing that actual Z partner gives a127-dimensional
dual frame. If the quotient rank profiles bound the number of its Z vectors in
orbit O by c_(a,O), then every full source frame satisfies

    x_a sum_(h: beta(x_a,z_(O,h))=0) z_(O,h) <= c_(a,O) x_a.

Translation averaging gives the corresponding real-moment inequality
sum_(h: beta=0) T_h[a,O] <= c_(a,O) p_a. The partner term is explicitly excluded;
a blanket extra1 is unnecessary. The separate45-row swapped-quotient cohort
passes independent physical replay. The original exact point also satisfies
all2025 nonpartner inequalities exactly.

## Conditional hulls produce stronger weighted inequalities

For an anchor type a, orbit O and sector, divide the corresponding exact second
moments by p_a. For the X orbit containing the fixed vector, first remove its
known selected phase. For Z, keep only phases annihilating the fixed X. A full
source frame would make this conditional first-moment vector a convex combination
of the allowed quotient phase masks. This imposes every linear inequality of
that local polytope, rather than only a total count bound or a single nogood.

The initial rational point fails this test in six rows. Six supporting
inequalities are derived by LP separation, then checked using integer support
maximization over **every** unexcluded mask. The LP solver's infeasibility status
is not accepted as the certificate. These are supporting inequalities; no
facet-dimension claim is made. The historical filenames use `facets-round1`.

One concrete consequence is that the original minimum-pool X vectors336 and438
cannot both occur in a full allowed dual frame. Translation gives16 such X pairs;
sector exchange gives their Z counterparts. The normalized moment
S_6[21,27] is therefore zero. A strict-margin witness search must retain this
face, rather than artificially demand positive slack for that entry. The first
unreduced search and its poor residual are preserved as an unsuccessful
sufficient-witness attempt, never an obstruction.

A second rational point, `profile-moment-face1.json.gz`, passes632 exact
equalities, all8100 occupancy/nonpartner inequalities, the six weighted cuts,
and the independent physical/256-bit interval PSD consumer. It also has
**4050 exact conditional local decompositions**, covering45 anchor types,
45 counted orbits and both sectors. Translation and sector exchange transfer
them to the other source-vector conditions. A fresh process checks their rational
nonnegative weights, all16 first moments, membership in the complete survivor
families, and90 corrupted-phase negative controls, without running an LP.

Thus the specified degree-two relaxation remains feasible even after imposing
the **whole selected-anchor one-orbit local polytopes** from these rank tests.
Separate local distributions need not combine into a common distribution or
source frame. This is a conclusive limitation of this class of local
strengthenings. The complementary anchor-absent check also passes4050 exact local
decompositions against the original, unconditioned rank-profile families.
This gives8100 decompositions for the two stated condition families.
Deleting the absent vector from the opposite dictionary is a genuinely stronger
test. A bounded X336-absent pilot physically certifies830 further local mask
exclusions, but the same point still has exact local decompositions in all45
resulting Z polytopes. The other44 normalized deletion dictionaries are untested;
they are not ruled out by the present method barrier.

## Short clauses checked directly in the original space

The X-only cohort contains two directed singleton certificates (one unordered
translation class),49 two-phase certificates and4051 three-phase certificates.
Together these give4102 forbidden patterns of2,3 or4 original X vectors. This
is the stated one-anchor/one-counted-orbit family, not every possible small
subset of the entire pool.

Each quotient annihilator is lifted using the original source basis. For a
zero-domain witness W, direct replay checks that W is outside the selected X
span and annihilates every original Z vector orthogonal to that selection. If
those selected X vectors formed part of a full dual frame, the other Z duals
would be independent in a space of insufficient dimension. For a private-owner
witness, W is outside the fixed X line and annihilates the entire original free
Z pool with pairing profile of weight at most one. That pool would have to
contain a127-vector basis, another contradiction. Dependency of selected X
vectors already precludes a basis.

`small_conditional_rank_cuts.py --verify-only` checks the original128-bit
witnesses directly, without the quotient discovery code or rank values.
Translation produces64096 distinct forbidden X sets. After sector transfer and
simplification against the fixed48/48 anchor,22414 unique short owner clauses
remain:12 binary,440 ternary and21962 quaternary. An independent consumer checks
each appended clause by subset implication from a witnessed forbidden set and
preserves the baseline model. These are full-basis consequences and do not apply
to arbitrary partial frames.

The two configured1800CPU-second native pilots, with and without343 inverse
parities, use this exact strengthened input. Both return INDETERMINATE:1889.741s and1883.090s wall time, with sampled
child RSS277.359MiB and318.328MiB respectively. No full source anchor is
completed, and no global speedup is established.

## A121 lower bound for the old cover criterion

A cover certified using the original16-signature/compatible-partial-matching
criterion must intersect every retained positive partial witness support. Assign
each of246 independently checked witnesses a nonnegative weight. Their total is
120833646/1000000, while each of the518 source classes has total load at most1.
For any such cover D, summing its class loads gives

    120833646/1000000 <= sum_(c in D) load(c) <= |D|.

Hence |D| >=121, improving the previous109 bound. The current checked upper
bound is418. The discovery LP is replaced by exact integer weights and physical
witness replay, including an overloaded-weight negative control. Neither121
nor418 is claimed optimal. This lower bound does not apply to arbitrary
full-frame covers using stronger basis information, and does not bound width or
elapsed search time. The new rank clauses deliberately add that stronger
information.

## Reuse theorem for the opposite quotient

For S contained in the annihilator of the fixed source X vector x_a, the
original opposite zero domain contains x_a. Projecting modulo x_a lowers the
rank of its span by exactly one, and the ambient dimension also falls by one.
The zero-rank threshold is unchanged. Private-partner profiles are unchanged;
the removed vector has zero profile. Consequently the opposite-sector quotient's
zero-rank/private-partner survivor family is exactly the original family
restricted to phases annihilating x_a. This statement uses projection of the
**entire** other X dictionary and does not transfer the stronger fixed-X-side
family.

The complete instance check compares2025 orbit rows,132710400 phase masks, and
finds exact equality. Future opposite-sector tables can therefore be obtained
by restriction instead of another rank enumeration. The45 generated tables are
retained as an encoding check, not counted as independent new negative rules.

## What the algebraic and library pilots establish

The native343-parity and no-parity full-anchor models both remain undecided at
the frozen900-second CPU limits, before and after adding the unconditioned
phase cuts. The stronger fixed-anchor phase pilot also remains UNKNOWN at900CPU seconds. The half-turn
profile CNF remains UNKNOWN after1800seconds; its incomplete DRAT trace is not
an obstruction. No global speedup or finishing-time estimate is established.

CryptoMiniSat5.17.0 solved the original hard conditional domain using native
XORs, and its XLRUP proof passes the official unmodified CakeML-derived checker
built for macOSx86_64 under existing Rosetta. Physical input regeneration and
an empty-proof negative control pass. A dependency-trimmed proof is rechecked
and compressed for preservation. A compressed-signature variant is recorded
separately; a smaller Gaussian matrix is not automatically faster. Bosphorus
4.1.0 agrees on the conditional UNSAT result, but its ElimLin phases learned
no new facts in the two fixed controls. The new cover reductions use longer
CaDiCaL proof budgets, not an attributed Bosphorus or native-XOR speedup.

Four complete papers are screened in `algebraic-results/paper-screening.json`.
Six historical broad directions or formulation gates are indexed outside the
precise-target denominator. The central cohort is408 entries,160 eligible
targets,195 paper records,163 full-text screens and6 complete Lean targets.
There is no new complete Lean target. The NulLA symmetry theorem requires the
group order to be invertible in the coefficient field; it does not authorize
averaging cyclic-order16 coefficient certificates over F2. The current library
experiments and the older OpenAI-library audit retain their distinct scopes.

## Preservation and publication

Work branch `research/c16-algebraic-20261028T2040`, ownership commit
`5fa8a68dc6aa50f53fb9515102c9a611cfad8f04`. The remote canonical claim is fixed
at that commit until closeout. Issues3/8 remain read-only. Completed evidence
will be integrated into existing PR17 within the authorized scope; required
review remains a real master-publication gate. No master delivery or Lean
completion is currently claimed. All four complete paper screens and their six gated historical directions are
reconciled with the central inventory. Final manifests and clean-checkout replay
remain in progress.

## Bounded next follow-up

The exact local-hull point gives a reason to stop adding more inequalities from
the same selected-anchor/one-orbit families: all their linear inequalities are
already satisfied. The remaining44 anchor-absent deletion dictionaries are a bounded remaining
check within local rank reasoning. A specific next test is to require a **common unconditional phase distribution**
for one counted orbit, with compatible conditional subdistributions for all
anchor types. The current certificates supply separate decompositions only.
This common-distribution LP can start with orbit27 and use actual phase masks
as columns, preserving the fixed global first and second moments. Beyond that,
coupling different counted orbits, both dual sectors or higher-order moments
would add information outside the tested local families. A bounded prototype
could learn original-coordinate rank conflicts from partial selections spanning
two counted orbits, using the direct witness consumer as its acceptance gate,
and compare the same retained anchor under identical limits. Static rank cuts
and the current integer pilots do not yet establish a global runtime gain.
Further blind degree-three polynomial expansion is not justified by the measured
term growth. A broad new literature campaign is also not a substitute for that
specific missing joint constraint.

## Requirement-to-evidence record

| Requirement | Status | Concrete evidence / limit |
|---|---|---|
| Exact source answer contract | Partial | Original width16/18; no full128-pair source witness or global obstruction |
| Bounded theoretical progress | Met | Quotient rank proof, weighted local inequalities, exact strengthened feasible points, short original rank witnesses and121 packing bound |
| Original-pool binding and independent consumers | Met for completed certificates | Physical reconstruction, direct128-bit witnesses, rational local decompositions, DRAT and official XLRUP replay; clean-checkout summary records the final run |
| Memory diagnosis and controlled pilots | Met | Resource receipts and allocation cap; C++ does not remove polynomial growth; no universal language or solver speedup claim |
| Literature and question harvest | Met in the bounded scope | Four complete exact-version screens, six gated directions, source/code/X search audit; no priority census or complete new Lean search claimed |
| Lean/PDF manuscript | Not applicable | Research report and external exact certificates; no new Lean theorem or requested PDF paper |
| Shared inventory and planning | Met |408 canonical entries,160 eligible,195 paper records,163 full screens;6 historical complete Lean targets unchanged |
| Publication | Partial until required review | Existing PR17; no master bypass or auto-merge |
| Claim release and time limit | Pending final closeout | Expected owner SHA in scope; final server readback and stop time recorded separately |
