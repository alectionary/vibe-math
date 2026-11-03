# Theory notes 2: splitting along subspaces spanned by pool orbits

Follow-up to `THEORY-NOTES.md` (which proved that no frame splits along a partition of the 8
coordinate blocks). Here the splitting lemma is stated for arbitrary subspace pairs, and applied to
subspaces spanned by whole pool orbits. Evidence labels: **[proof]** written proof;
**[computation]** exhaustive program run, recorded below; **[heuristic]** not exhaustive.

Notation: X and Z pools (720 vectors each, 45 T-orbits of 16; vector `16a+t` is `T^t` of the orbit
representative), pairing `<x, z>` over F2^128. A *frame* is 128 pairs with Gram matrix the identity.
For a subspace `W` of the X space, `W^perp` is the set of Z-space vectors orthogonal to it, and
vice versa.

## 1. The splitting lemma for any subspace pair

**Lemma A [proof].** Let `F` be a frame and `S ⊆ F` a set of `d` pairs. Let `U` be the span of the
X vectors of `S` and `U2` the span of the Z vectors of `S`. Then:
1. `dim U = dim U2 = d`, and the pairing `U × U2` is nondegenerate.
2. The pairs of `F \ S` have X vectors in `U2^perp` and Z vectors in `U^perp`, and form a frame of
   the pair `(U2^perp, U^perp)` (both of dimension `128 − d`).

Conversely, a local frame of `(U, U2)` (d pool pairs inside `U × U2` with identity Gram matrix)
together with a frame of `(U2^perp, U^perp)` built from pool vectors is a frame.

*Proof.* The Gram matrix of `S` is the identity, so the X vectors of `S` are independent (a
dependency `Σ c_i x_i = 0` paired with `z_j` gives `c_j = 0`), and likewise the Z vectors; the
pairing matrix of these bases is the identity, so it is nondegenerate. For a pair `(x, z) ∈ F \ S`,
`<x, z_i> = 0` for every Z vector `z_i` of `S`; these span `U2`, so `x ∈ U2^perp`. Symmetrically
`z ∈ U^perp`. The Gram matrix of `F \ S` is the identity block of size `128 − d`. Since the pairing
on `U × U2` is nondegenerate, `V = U ⊕ U2^perp`, so `dim U2^perp = 128 − d`, and likewise
`dim U^perp`. Conversely, the cross terms vanish (`<U, U^perp> = 0`, `<U2^perp, U2> = 0`), so the
union has identity Gram matrix. ∎

So a frame **splits along** `(U, U2)` exactly when both `(U, U2)` and `(U2^perp, U^perp)` carry local
frames of pool vectors. The block result of `THEORY-NOTES.md` is the case `U = U2 = V_B`.

**Coordinate change used by every search here [proof].** Fix a basis `b_1..b_d` of `U`. An X pool
vector `x ∈ U` gets its coefficient vector `c(x)`; a Z pool vector `z ∈ U2` gets
`w(z) = (<b_k, z>)_k`. Then `<x, z> = c(x) · w(z)`, so local frames of `(U, U2)` are exactly frames
of F2^d for these vectors, which `la/la_gen` decides (dimension `d`, coordinate mask the low `d`
bits). Script: `subspace_frames.py`.

**Controls of the coordinate change [computation].** `control_planted.py`: in the planted pools
(`la/gen_instance.py` plant seed 1), the planted orbit pairs `(45, 45)` and `(46, 46)` have a local
frame and their 112-dimensional complements have a frame (found in 113 nodes). `control_blocks.py`:
with `U = U2 =` coordinates of blocks `B`, the pipeline reproduces Proposition 4 of
`THEORY-NOTES.md` on real pool vectors: frames for `B = {0,1,3,5,7}` (80 dims, 81 nodes) and
`{0,1}`; none for `{2,4,6}`, `{2,3}`, `{0,1,2,3}` (1,912 nodes).

**Caution [computation].** The same complement problems run through `la_gen -p` (fixing the 16 pairs
inside the full 128-coordinate instance) are much harder for the search: for the orbit pair
`(1, 10)` the complement search in complement coordinates is COMPLETE with no frame in 25 nodes,
while `la_gen -l -p` and `la_gen -l -f -p` hit 30-minute limits (8.7 M and 0.34 M nodes). Both
instances have the same 288 X and 224 Z candidates and identical pairings (checked); the difference
is pruning strength only. A Kissat run on an independent encoding (`complement_sat.py`) was UNKNOWN
at 25 minutes. So the negative complement results below rest on `la_gen` in complement coordinates
plus the controls above; they are not independently confirmed.

## 2. Pool orbit spans

**Fact [computation, `orbit_data.py`].** Every orbit spans a free rank-one R-module (dimension 16),
and the span of any single orbit contains no pool vector outside that orbit. Of the 45 × 45 orbit
pairs, 942 have nondegenerate 16 × 16 pairing.

**Fact [computation, `orbit_flats.py`].** Unions of two orbits span 32 dimensions except for 31
pairs (per side): some span only 31, and some lie in a 32-dimensional flat containing a third orbit
(for example X orbits 0, 1, 2: 48 vectors in a 32-dimensional space, the "x, y, x+y" pattern of
blocks {0,1}).

## 3. No frame contains a whole orbit pair

A local frame of `(span X_a, span Z_b)` must use all 16 vectors of each orbit (they are the only pool
vectors in the spans), so their 16 × 16 pairing block must be a permutation matrix; being circulant,
it has a single 1 per row (a *monomial* orbit pair). There are **177** monomial orbit pairs
(`mono_pairs.json`).

**Proposition B [computation + Lemma A].** No frame contains a whole X orbit paired, pair by pair,
with a whole Z orbit. For each of the 177 monomial pairs the complement `(U2^perp, U^perp)` has no
frame: in 167 cases the pool vectors in one complement span fewer than 112 dimensions (proof by
rank, given the computed ranks), in the other 10 cases a complete search in complement coordinates
finds none (at most 412 nodes). Record: `mono_split.py`, `mono_split.json`, `mono_split.log`.

## 4. Which orbits can appear whole in a frame

**Lemma C [proof].** If a frame contains all 16 vectors of X orbit `a`, then the Z pool vectors
orthogonal to `span X_a` have rank at least 112 (the other 112 Z vectors of the frame lie there and
are independent). The partner of `x_{a,t}` pairs with the orbit as the unit vector `e_t`. Symmetric
statements hold for Z orbits.

**Proposition D [computation].** Only X orbits **1, 9, 10, 11, 12, 14, 15, 33, 41** pass the rank test
of Lemma C, and the same list for Z orbits (`whole_orbit.py`, `whole_orbit.json`). For the other 36
orbits, no frame contains the whole orbit.

**Exact test for the 9 survivors** (`whole_orbit_dfs.py`). Choose the partners `z_0..z_15` in order
from the candidate sets `C_t` (pool vectors pairing with the orbit as `e_t`), pruning when the X pool
vectors outside the orbit and orthogonal to all chosen partners have rank below 112. Each full
partner choice is then decided by Lemma A in complement coordinates. Results:

| X orbit | Method | Result |
|---|---|---|
| 15 | partner search (`whole_orbit_dfs.py`); relaxation (`whole_orbit_relax.py`) | cannot be whole (both methods) |
| 1 | partner search: only surviving choice = whole Z orbit 10 (excluded by Prop. B); relaxation COMPLETE, 20,353 nodes | cannot be whole |
| 14 | partner search: only surviving choice = whole Z orbit 33 (excluded); relaxation COMPLETE, 225 nodes | cannot be whole |
| 12 | relaxation COMPLETE, 3,284 nodes | cannot be whole |
| 41 | relaxation COMPLETE, 10,173 nodes | cannot be whole |
| 9, 10, 11, 33 | relaxation INCOMPLETE (15–50 min limits; 1.7–17 M nodes) | **open** |

*Relaxation [proof of soundness].* A frame containing all of X orbit `a` has every Z vector either a
partner (pairing with the orbit as a unit vector) or orthogonal to the orbit. So it is a frame of
the full problem with the Z pool restricted to those vectors (368–416 of 720); `la_gen -l` on that
restricted instance finding no frame proves the orbit cannot be whole. The partner search and the
relaxation agree on orbits 15, 1 and 14.

**Corollary E [computation].** Every frame meets each of the 41 X orbits other than 9, 10, 11, 33 in
at most 15 vectors, and the same for Z orbits: the side exchange `s` (G is symmetric) maps a frame
containing all of Z orbit `a` to one containing all of X orbit `a`.

## 5. The near-miss partial frames

**Observation [computation, `nearmiss_orbits.py`].** The 88-pair partial frame
(`partial-frame-88.json`) contains two whole orbit-pair blocks, `(X9, Z9)` and `(X10, Z10)`, and the
whole X orbit 41. By Proposition B, no frame contains `(X9, Z9)` or `(X10, Z10)`. This is a
concrete reason why it is far from any frame: removing pairs elsewhere cannot help; at least one
pair of each of these blocks must go. The 84-pair partial frame contains no whole orbit-pair block,
and contains the whole Z orbits 11, 12 and 41.

## 6. Three-orbit flats (32-dimensional)

**Fact [computation, `orbit_flats.py`, `flat_split.py`].** On each side exactly 5 flats of dimension 32
contain three orbits (48 vectors): orbits `{0,1,2}`, `{3,4,5}`, `{6,7,8}`, `{9,10,11}`, `{12,13,14}`
(same labels on both sides).

- *Whole flats.* If a frame contains 32 X vectors inside a 32-dimensional flat `F`, its other 96 Z
  vectors lie in `F^perp` (Lemma A). The Z pool vectors orthogonal to `{3,4,5}` or `{6,7,8}` span only
  64 dimensions, so **no frame has 32 X vectors in the flat {3,4,5} or {6,7,8}** (and symmetrically
  for Z) [computation of the rank + proof]. For the other three flats the rank is 96: no conclusion.
- *Flat pairs.* Of the 25 flat pairs, 16 have nondegenerate pairing. Only `(X{9,10,11}, Z{9,10,11})`
  has a local frame (found in 33 nodes), and its 96-dimensional complement has none (COMPLETE, 268
  nodes). The other 15 have no local frame. So **no frame splits along a pair of three-orbit flats**
  [computation + Lemma A]. In 11 of the 16 cases the complement also fails the rank test.

## Summary

- **Lemma A [proof]:** the splitting lemma for any subspace pair; a frame splits along `(U, U2)` iff
  both `(U, U2)` and `(U2^perp, U^perp)` carry local frames. Implemented by a coordinate change and
  validated by planted and block controls.
- **Proposition B [computation]:** no frame contains a whole orbit-pair block (all 177 monomial orbit
  pairs excluded; 167 by rank alone).
- **Proposition D / Corollary E [computation]:** 41 of the 45 orbits (per side) can never appear whole
  in a frame; orbits 9, 10, 11, 33 are open.
- **Section 5 [computation]:** the 88-pair near-miss contains the excluded blocks `(X9, Z9)` and
  `(X10, Z10)`; this is a concrete reason it cannot be extended.
- **Section 6 [computation]:** no frame splits along a pair of three-orbit flats; no frame has 32
  vectors in the flats `{3,4,5}` or `{6,7,8}`.
- **Caution [computation]:** `la_gen -p` (fixed pairs inside the full instance) prunes far worse than
  the same problem in complement coordinates (25 nodes against > 8.7 M for the orbit pair (1, 10)).
  Searches that fix many pairs should change coordinates first. Relevant for the search-ordering
  work.

**Assessment [heuristic].** These are all "no frame contains structured piece P" statements. They
are consistent with frames not existing, but do not add up to an obstruction: an asymmetric frame
could meet every orbit in at most 15 vectors. The most promising next step is to close orbits 9, 10,
11, 33 (sharded relaxation runs, or the complement-coordinate trick applied to the partner search),
and then ask how large `|F ∩ orbit|` can be: bounds of the form "at most k vectors per orbit" for
small k would combine with counting over the 45 orbits (`128 ≤ Σ_a |F ∩ X_a|`).

## Files

`subspace_frames.py` (coordinate change, local/complement search), `orbit_data.py`, `orbit_flats.py`,
`mono_split.py` (+ `.json`, `.log`), `whole_orbit.py`, `whole_orbit_dfs.py`, `whole_orbit_relax.py`
(+ `whole_orbit_relax.log`, `whole_orbit_relax2.log`), `nearmiss_orbits.py`, `flat_split.py`
(+ `.json`, `.log`), `control_planted.py`, `control_blocks.py`, `complement_sat.py` (UNKNOWN, not
used for any claim). Instances are written to `inst2/` and deleted after use.
