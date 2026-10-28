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

Groenland–Mannens–Nederlof–Piecyk–Rzążewski, arXiv2312.03859v1,
Lemma7.1 and Observation4.6, compare half-induced matching, asymptotic induced
matching and support rank. The published ICALP2024 version changes the title
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

This supplies a small, proved conditional cover for future source-specific
moment or exact-completion arguments. It does not justify imposing any
particular anchor on all frames, or counting the12 open cases as solved.

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

Paper copies are collected in the shared workspace's `collected-c16-papers`.
Hashes, version-specific question locators, exclusions and borrowed leads are
recorded in `overnight-results/paper-screening.json`; full copyrighted source
copies remain local rather than being republished with this repository.
