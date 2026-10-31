# C16: literature-guided overnight continuation

Canonical target: **L-F91-c16-unrestricted-width**, issue8. Deadline:
2026-10-28 06:00 PDT (13:00 UTC); new experiments stop12:30 UTC.
This is a continuing research record, not a claim that elapsed time was all CPU work.

## Mathematical status

The unrestricted answer remains **16 or18**. No full128-pair physical frame
has been constructed; the best preserved partial frame still has88 pairs.
No new complete Lean target is claimed.

There is a new exact exclusion: **no full frame can have both sector thin
supports contained in {0,3,4}**. This is a joint restriction, not exclusion of
{0,3,4} in either sector alone. Combined with the previously proved13 supports
per sector and sector exchange, it removes the self-paired034/034 case:
169 ordered support pairs become168, or91 exchange representatives become90.
The all-five/all-five case remains open.

An alternative complete decomposition has **1,082 selected-pair completion
cases**, all unresolved. It comes from an optimal source-X-basis hitting cover
and the actual pool symmetries, rather than a new frame-existence assumption.
The case-count reduction is proved; a runtime improvement is not established.

The rational certificate is `overnight-results/joint034-dual-no-cap.json.gz`.
Its independent consumer is `verify_exchange_dual.py`; its exact PSD witness is
`overnight-results/joint034-dual.json.PSD.json.gz`. The checked contradiction
gap is **−1093420454219/1099511627776**. All12,622 linear terms are regenerated
from the original source graph and the stated source-valid inequalities.
The865-dimensional cyclic PSD dual is checked through integer congruences
and exact diagonal dominance in blocks55,54,108,216,432. No numerical
stationarity, floating PSD tolerance, or critical-monomial cap is a premise.

### Why this is a proof about asymmetric frames

Let s be the Boolean selection vector of any hypothetical frame. Its first
and second moments may be averaged under simultaneous cyclic translation and
the verified physical sector exchange. This averages feasible moment matrices;
it never asserts that the selected frame is fixed by either symmetry.
In the original orbit order, exchange swaps X_i with Z_i, so the averaged
pair blocks have the form [[S_h,T_h],[T_h,S_h]], with equal sector first
moments p. The plus/minus sector congruence separates every Fourier PSD block.
At frequency zero the even block is

```
[[1,     4 p^T],
 [4 p,  (Σ_h S_h + Σ_h T_h)/2]],
```

and the odd block is Σ_h S_h−Σ_h T_h. The other frequencies split into the
Fourier transforms of S+T and S−T. These are necessary PSD conditions.
The independent consumer instead lifts the dual to the full rational cyclic
matrix, avoiding trigonometric numbers in its final arithmetic.

Every selected sector set is binary independent because its private partners
give an identity pairing minor. This proves the source rank bounds and circuit
inequalities. Unique partner ownership proves the common-neighbor inequalities.
Boolean triple inequalities and integral-form S(S−1)≥0 supply the remaining
linear rows. For a PSD dual Y and nonnegative inequality multipliers, the
regenerated linear combination bounds the PSD pairing above. Its exact
stationarity residual r is bounded below by Σ_j min(0,r_j), since every first
and pair moment lies in[0,1]. The certificate has b−Σ_j min(0,r_j)<0,
contradicting positivity. This residual correction is explicit, not a numerical
claim of exact stationarity.

Independent physical88 and retained physical80 controls verify the exchange
map, normal-form rephasing and old cuts. Corruption controls and their terminal
results are retained separately. This is an exact computational certificate
with a written argument; it is not a Lean proof.

## What the new literature can and cannot do

Groenland–Mannens–Nederlof–Piecyk–Rzążewski, [arXiv2312.03859v1](https://arxiv.org/html/2312.03859v1),
Lemma7.1 and Observation4.6, compare half-induced matching, asymptotic induced
matching and support rank. The published [ICALP2024 version](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.ICALP.2024.77) changes the title
from “Asymptotic Rank Parameters” to “Asymptotic Matrix Parameters”; source
records F153/F157 distinguish the versions and share canonical question IDs.

For the actual720×720 pairing matrix A, exact binary rank is128 and the saved
triangular128 minor is independently replayed. It uses only thin families3,4
in both sectors. For an upper triangular r×r support minor with diagonal1,
take tensor words containing each label exactly s times. If two such words
are distinct, they cannot be coordinatewise ordered. Thus the corresponding
Kronecker submatrix is an identity of size(rs)!/(s!)^r. Its(rs)-th root tends
to r. On the other hand, binary rank bounds induced matchings in every tensor
power by rank(A)^k. Therefore

**him(A)=mimsup(A)=support-rank_F2(A)=rank_F2(A)=128.**

The same equality holds for the both-sector{3,4} restriction. Our independently
replayed three-family theorem proves that restriction has no128-frame.
Consequently an asymptotic/tensor-power bound can lose precisely the finite
distinction that matters here. Such a bound cannot certify less than128 for
this source matrix. This retires one proposed route; it does not retire exact
finite moment or compatibility-state methods.

A second applicability check prevents misuse of the paper's representative
row-basis lemma. The matrices

```
A = [[1,1], [0,1], [1,0]],     B = first two rows of A
```

both have rank2, and B preserves existence of a1 in each individual column.
Nevertheless mim(A)=2 while mim(B)=1. Thus row-basis compression of the
original pool matrix does not preserve simultaneous private partners. A valid
dynamic program would need its own completion-compatibility matrix and a
proof of what its representative sets preserve.

`verify_asymptotic_barrier.py` checks the finite premises and9,152 small
balanced-word controls. The limiting implication is the written argument
above with primary attribution, not a finite enumeration of all tensor powers.

### Coefficient-field scope of the harvested questions

The final question ledger has15 canonical questions, directions or formulation
gates, with11 repeated in the published version. This includes two explicitly
unresolved borrowed quantities used as context (Shannon capacity of C7 and
the matrix-multiplication exponent); they are not newly attributed questions
of these authors. Six entries currently meet the precise-target criterion.
Present resolution and Lean status of these targets remain unassessed.

In particular, two source support-rank questions retain a coefficient-field
gate. For every even q, over F2 the unique support matrix of K_q is A=I+J,
and A²=I, so its binary support rank is q. Over Q, B_ij=i−j has the same
support and rank2. A triangular2 minor (or the q=2 matching) and the cited
rank upper bound therefore give mimsup(K_q)=2. Thus F2 support rank is
already not functionally equivalent to mimsup, and strictness occurs at K4.
The paper's displayed rank2 construction for K_q uses enough distinct field
elements. Silently reading its unresolved questions over F2 would answer a
different formulation. `verify_support_field_scope.py` checks32 even-q
instances; the general statement follows from the displayed identities.

## Pilot outcomes and limits

The coherent selected-third-moment pilot adds shared third moments, Boolean
cell inequalities and selected conditional PSD blocks. It passed physical
controls, but the bounded numerical runs did not demonstrate a stronger
certified result. The pilot closed at07:40 UTC. One later queued launch was
refused by its expired deadline. Its incomplete and inaccurate outputs remain
in the record and are not promoted to feasibility or exclusions.

The productive change was sector-exchange block decomposition of the existing
degree-two model plus source cuts. The joint034 numerical ray became the
exact certificate above. An all-family run of that decomposition has a
separate480-second outer wall bound and2.5GB RSS ceiling; its final status is
recorded in `overnight-results/global-exchange-base.exit.json`. A numerical
status alone will not be treated as a solution.

The all-family direct run was terminated at its480-second wall bound before
returning a solver result. An indirect follow-up removed84,222 exact duplicate
linear rows and returned `solved (inaccurate - reached time_limit_secs)` after
125 iterations and294 seconds. Its primal residual0.0193, dual residual0.0535
and gap0.1445 establish neither feasibility nor exclusion. There is no global
certificate from either run.

The larger joint0234 case also returned `optimal_inaccurate`, with maximum
constraint violation0.0188. Rational recovery left a positive residual gap
(best tested0.08659), so no contradiction was obtained. A broad linear-multiplier
repair reached its120-second limit without a dual. An active-row repair solved
quickly but gave a positive fixed-PSD-pairing upper bound0.07230. Twelve bounded
cut-generation rounds reduced this only to0.07142. These repairs produced no
new certificate. The larger case remains unresolved.

A short construction comparison retained most of the physical88 frame and
released8,16,24 or32 pairs in24 seeded neighborhoods. There was no improvement:
21 subproblems reported infeasible and3 were unknown. These solver outcomes
do not exclude larger frames. Separately, an independent physical-coordinate
check finds13 compatible additional X candidates and5 Z candidates with no
cross-pairing edge. Thus88 is maximal under direct extension, not proved to be
the maximum. `partial88-maximality.json` and `local-exchange.json` preserve the
different exact and sampled scopes.

### A further inversion-identity test

For a full frame, K=U^-1 ΩU satisfies K²+K+I=0. Its diagonal equations imply
that each selected matching edge has an odd number of other selected edges
with both auxiliary cross-pairings1. Ordinary cross-pairings must remain0.
Thus the sum of the matching-edge moments of these compatible reciprocal
neighbors is at least the anchor matching-edge moment. This projects a known
full-basis identity into valid degree-two source inequalities.

`screen_omega_moment_cuts.py` tests all6,238 common-translation anchor orbits
against the previously certified rational128 moment point. **Zero cuts are
violated**; the minimum exact slack is40882179204825/139637976727552.
The screen also checks the reciprocal odd-degree identity on all ordered
bases in binary dimensions2 and4, totaling80,652 selected-vertex checks.
The condition requires a full basis and is not asserted for the physical88
partial frame.

For an even subset F of an anchor's reciprocal neighbors, conditional odd
parity gives

```
anchor + sum(F edge moments) - sum(other neighbor edge moments) <= |F|.
```

At the saved point every matching-edge moment is at most1/2. The violation of
this inequality equals anchor−sum(all neighbors)+Σ_F(2*edge−1), maximized
by F empty. Consequently all these conditional parity inequalities also pass
at that point. This is a specific negative result about this linear projection
of the inversion identity; higher-order joint consistency is not excluded.

## Next proof obligations

### A complete cover by12 possible selected-vector anchors

There is an alternative to the90 support regimes: every full frame has a
common cyclic translate containing X_(16a), with

```
a in {15,18,20,22,23,25,28,29,31,33,36,38}.
```

Indices use zero-based original pool order. These12 anchored frame cases are
still unresolved. The cover is optimal among unions of whole source X orbits
that meet every spanning X subset; this is not optimality among covers using
additional joint-frame conditions. It does not imply equal costs for the12
cases, or a measured runtime improvement.

Here is the reason this optimization needs only255 covectors. Let T be
simultaneous cyclic translation of the eight16-bit blocks. If the complement
of a removed set of source orbits spans a proper space W, then W is
T-invariant. Its nonzero annihilator is invariant under T*. Since in
characteristic2, (T*−I)^16=0, take a last nonzero iterate of any annihilator
vector under T*−I. It is a nonzero fixed covector still annihilating W.
Every fixed covector is constant on each16-bit block. There are only255
nonzero choices. The source orbits on which such a covector is1 must all lie
in the removed set. Conversely, removing these orbits leaves a proper span.
Thus the least possible orbit cover is the least support size of one of
these255 fixed covectors on the45 source orbit roots.

The exact minimum is12, achieved by11 fixed covectors. For the displayed
cover, the complement has rank127. Each of its12 phase-zero anchors extends
a saved127-vector complement basis to a full X basis, so none of the cases
is ruled out by X rank alone. A full frame must meet the cover; translating
one selected point to phase zero proves coverage without assuming a
translation-invariant frame. `verify_anchor_cover.py` verifies the finite
premises, every fixed covector and the12 positive X-basis controls.
An independent consumer uses an integer Walsh-Hadamard transform and a different
binary-rank pivot convention to recheck all255 covectors and the minimum12.

This supplies a small, proved conditional cover for future source-specific
moment or exact-completion arguments. It does not justify imposing any
particular anchor on all frames, or counting the12 open cases as solved.
Only spanning and an invariant annihilator are used here. There is no claim
that a full biorthogonal frame descends to a full residue frame; the earlier
counterexamples to that stronger implication remain in force.

### A concrete1,082-case completion manifest

A selected X anchor must be paired with one of its source anticommuting Z
points. There are6,238 pair orbits under common translation, or3,132 after
sector exchange. A translated anchor pair (a,b,h) is equivalent to
(b,a,−h mod16). For each fixed-covector hitting set H, retain the distinct
pair orbits incident to an X orbit in H, identifying this exchange equivalence.
Every full frame has an equivalent frame containing a retained pair.

The number of retained cases is monotone in H. If any union S of X orbits
meets every source X basis, the invariant-annihilator argument supplies a
fixed-covector hitting set H contained in S. Hence the least case count within
this strategy is attained among the255 fixed covectors. Its exact minimum is
**1,082**, attained at fixed mask140, with pre-exchange X anchor orbits

```
{16,17,19,33,36,38,39,40,41,42,43,44}.
```

`pair-case-cover.json` lists every case with original pool indices and an
unresolved status. It also records all255 cover costs. The independent cover
consumer reconstructs the graph from1088-bit physical supports and checks the
costs using integer incidence masks. This proves optimality within the stated
whole-orbit X-basis-cover strategy; stronger joint-frame arguments could give
a different decomposition. No whole selected-pair completion case has been
excluded in this block.

For a listed pair (x,z), a completion consists of127 further X points in
ker(z) and127 further Z points in ker(x), with an identity cross-pairing after
partner ordering. This is exactly equivalent to completing that selected pair
to a source128-frame. Excluding every listed completion would prove width18;
one verified completion would prove16. A conditional source solver must retain
the exact finite dictionaries and preserve these equivalences. It must not
replace the pair condition by a cyclic-invariant selected-frame assumption.

### Remaining work

1. Retain the90 remaining joint support representatives as unresolved unless
   a separate exact certificate or physical frame covers them.
2. Prioritize the all-five/all-five regime. A finite source obstruction there
   and the intermediate regimes would settle18; an actual128-pair pool frame
   would settle16. Larger unconstrained tensor dictionaries do not answer it.
3. Reuse the checked source-row consumer for any new dual. Do not extend
   numerical runs indefinitely or credit third moments for a degree-two result.
4. Representative-set search requires a proven boundary/completion interface;
   the source row-basis shortcut is invalid. No finishing runtime is established.

The proposed next target is a **follow-up**, not a new canonical problem:
complete one explicitly listed selected-pair case with a checked obstruction
or an actual128-pair source frame, then assess the remaining case costs.
The finite fallback of enumerating X subsets is complete because a chosen
X basis determines its dual uniquely, but it has C(720,128) candidates
(about2^481.45). This is not a practical finishing-time bound. Neither the
case cover nor the present solver data justifies a reliable time estimate.

Paper copies are collected in the shared workspace's `collected-c16-papers`.
Hashes, version-specific question locators, exclusions and borrowed leads are
recorded in `overnight-results/paper-screening.json`; full copyrighted source
copies remain local rather than being republished with this repository.

Readable source statements and formulation gates: [PAPER-QUESTIONS.md](PAPER-QUESTIONS.md).

## Requirement-to-evidence check

| Requirement | State | Evidence and limit |
|---|---|---|
| Collect primary sources | Met | Six source versions/five works and12 source/text files in the local collection; version hashes in the source ledgers. |
| Parse questions beyond immediate methods | Met | Earlier7 entries plus15 overnight entries, with canonical version deduplication, borrowed attribution and field/formulation gates; current status and Lean discovery remain unassessed. |
| Develop a proof or counterexample | Partial | Exact joint034/034 exclusion and complete conditional covers; unrestricted16/18 question remains open. |
| Independently check the new mathematics | Met | `replay_overnight.py`: original-pool bridge, exact dual/PSD, six corruptions, independent cover check, method barriers and physical88. |
| Preserve unsuccessful methods | Met | Terminal launch receipts and logs, inaccurate global/0234 runs, failed repairs and24 local construction trials. |
| Honor bounded overnight scope | Recorded | `UNTIL-6AM.md`, hard launch limits, final verification and closeout records; deadline13:00 UTC, new-experiment cutoff12:30 UTC. |
| Kernel-checked full answer | Not completed | No new Lean completion or unrestricted proof is claimed. |
| Integrate on master | Pending required review | Research PR17 preserves the branch and artifacts; required review is retained. |
| New PDF manuscript | Not applicable | This deliverable is a research report, source ledger and exact certificates. |
