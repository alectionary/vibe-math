# Theory push: structure of the pools and obstructions to asymmetric frames (2026-11-03)

Scope: look for a structural reason that rules out (or points to) an asymmetric width-16 frame,
i.e. a 128-pair induced matching of the 720 × 720 pairing matrix `G`. Evidence levels:
**[proof]** written proof here; **[computation]** exact computation by the named script;
**[heuristic]** non-exhaustive search or relaxation with heuristic separation.

Scripts are in this directory: `common.py` (pool loading), `orbit_ilp.py`, `cell_ilp.py`,
`beam_rank.py`. All use only `pools/xcoords.txt`, `pools/zcoords.txt`.

## 1. The pools in module form

Coordinates: `F2^128 = R^8`, `R = F2[t]/(t^16+1)`, block `b` = coordinates `16b..16b+15`, and `T`
multiplies every block by `t` (rotation towards higher bits). The pairing is the standard dot
product. Orbit `a` is `{t^s α_a : s = 0..15}` (index `16a+s`).

**Lemma 1 [computation; one-line check in this file's session log].** `z_i = π(x_i)` for every
index `i`, where `π` swaps blocks `2 ↔ 4` and `3 ↔ 5`. Hence `G[i][j] = ⟨x_i, π x_j⟩`, which is
symmetric because `π` is a symmetric permutation matrix. (This explains the swap symmetry `s`.)

**Quarters.** Write `Q0 = {0,1}`, `Q1 = {2,3}`, `Q2 = {4,5}`, `Q3 = {6,7}`. The pool vectors supported
inside a single quarter are exactly [computation]:

| Quarter | X-local orbits (generators) | Z-local orbits (generators) |
|---|---|---|
| Q0 | `e0`, `e1`, `e0+e1` | `e0`, `e1`, `e0+e1` |
| Q1 | `e3`, `t^3 e2 + e3` | `e2`, `e3`, `e2+e3` |
| Q2 | `e4`, `e5`, `e4+e5` | `e5`, `t^3 e4 + e5` |
| Q3 | `e7`, `t^3 e6 + e7` | `e7`, `t^3 e6 + e7` |

All 45 generators are printed by the session's first script; 33 of the 45 X generators have a
non-monomial coefficient. Orbits 33–38 have `e3`-coefficient `1` and live in `Q0+Q1`; orbits 39–44
have `e7`-coefficient `1` and live in `Q2+Q3`.

## 2. The quarter subproblems, explained

These were previously known only by computation (paper: "\pending{explain this count}").

**Proposition 2 [proof].** Among frames of the 32-dimensional space `V_Q` built from pool vectors
supported in `Q`:
1. `Q0` has exactly `3^16 = 43,046,721` frames.
2. `Q1`, `Q2` and `Q3` have none.

*Proof.* (1) The local vectors are `e_{0,s}`, `e_{1,s}`, `e_{0,s}+e_{1,s}` on both sides. `V_{Q0}`
splits orthogonally as `⊕_s W_s`, with `W_s = span(e_{0,s}, e_{1,s}) ≅ F2^2`, and every local vector
lies in one `W_s`. A pair `(x, z)` with `⟨x,z⟩ = 1` lies in one `W_s`. At most `dim W_s = 2` frame
X-vectors lie in `W_s` (they are independent), and there are 32 in total, so exactly 2 lie in each
`W_s`, and their partners form the dual basis inside `W_s`. So a frame is an independent choice,
for each `s`, of a frame of `F2^2` from the three nonzero vectors on each side. A basis of `F2^2`
is one of the 3 unordered pairs of distinct nonzero vectors; its dual basis is unique and consists
of nonzero vectors, hence is available. So each `W_s` has exactly 3 frames, and the total is
`3^16`.

(2) In `Q1` there are only 32 X-local vectors, `e_{3,s}` and `e_{2,s+3}+e_{3,s}`, so a frame uses
all of them. They form a basis whose dual basis contains `e_{3,s}+e_{2,s+3}` (dual to `e_{3,s}`).
The Z-local vectors of `Q1` are `e_{2,u}`, `e_{3,u}`, `e_{2,u}+e_{3,u}`, all with the two blocks at
the same position `u`. Since `s+3 ≢ s (mod 16)`, the dual vector is missing, so there is no frame.
`Q2` is the same argument with X and Z exchanged. In `Q3`, both sides are `{e_{7,s}, e_{6,s+3}+e_{7,s}}`.
The X side is forced, and its dual basis contains `e_{6,s+3}` (dual to `e_{6,s+3}+e_{7,s}`), which is not
Z-local. ∎

So the local obstruction is a **phase twist**: the X side ties block 2 (or 6) to block 3 (or 7)
with a shift of 3, and the Z side either has no twist (Q1, Q2) or lacks the pure `e6` direction
(Q3).

## 3. Linear identities: what is and is not new

Every frame satisfies `Σ_i x_i z_iᵀ = I` (from `XᵀZ = I` with both square). Every *linear*
necessary condition on the pair indicators is a consequence of these 16,384 entry equations, which
earlier work already used (`RESIDUAL-IDENTITIES.md`). Two consequences are worth recording,
because they hold at the level of orbit or cell counts, which the earlier LP relaxations never
used.

**Folded parity [proof].** Let `A_m` sum, within each block, the coordinates with equal position mod
`m` (`m | 16`). Then `A_m x` depends only on the orbit and on `s mod m`, and
`Σ_i (A_m x_i)(A_m z_i)ᵀ = A_m A_mᵀ = (16/m) I = 0` over F2 for `m ≤ 8`. With `m = 1` this gives 64
parity equations on the orbit-pair counts `n[a][c]`: `Σ n[a][c] ρ(α_a) ρ(ζ_c)ᵀ ≡ 0`, where `ρ`
sums each block. (Checked on random `Q0` frames at every `m`.)

**Characteristic vector [proof].** With `y_i = π z_i`, a frame is a pair of bases `(x_i)` and `(y_i)`
of the X pool that are dual for the symmetric form `B(u,v) = uᵀπv`. `B(u,u) = ℓ(u)` is the parity
of `u` on blocks 0, 1, 6, 7, the coordinates fixed by `π`, so `B` is not alternating, and its
characteristic vector is `w = 1_{blocks 0,1,6,7}`. For dual bases, `Σ_i ℓ(z_i) x_i = w` and
`Σ_i ℓ(x_i) z_i = w`. This is `I w = w`, so it is already one of the residual identities; it is
stated here only because it gives the pairing a clean form: a frame is a dual-basis pair for one
symmetric, non-alternating form on one pool.

## 4. No frame splits along any partition of the blocks

**Lemma 3 (splitting) [proof].** Let `B` be a set of blocks, `B'` its complement, and `V_B` the
span of their coordinates. Suppose a frame `F` contains `16|B|` pairs whose X and Z vectors are both
supported in `B`. Then those pairs form a frame of `V_B`, and the other pairs form a frame of
`V_{B'}` built from vectors supported in `B'`.

*Proof.* The `16|B|` X vectors are independent, so they span `V_B`; likewise the Z vectors. Every
other Z vector of `F` pairs to zero with all of them, so it is orthogonal to `V_B`, i.e. supported in
`B'`; likewise every other X vector. Their Gram matrix is the identity of size `16|B'|`. ∎

**Proposition 4 [computation + proof].** A frame of `V_B` built from pool vectors supported in `B`
exists exactly when `B ⊆ {0,1,3,5,7}`.
- *Exist:* blocks 3, 5 and 7 each carry a unit-vector orbit on both sides (X/Z orbits 33/13, 13/33,
  39/39), and `{0,1}` has frames (Proposition 2), so direct sums give a local frame for every
  `B ⊆ {0,1,3,5,7}` [proof].
- *Do not exist:* every one of the 127 block sets containing block 2, and every set containing 4 or 6,
  has no local frame [computation: `local_frames.py`, `local_frames.json`]. 85 of these fail by
  counting alone (fewer than `16|B|` local vectors on one side). The others were searched to
  completion by `la/la_dfs3 -l -f`, with at most 653 nodes each. Example: blocks 2–7, 96 dimensions,
  COMPLETE in 98 nodes; 255 nodes without `-l -f`. The 8 sets that contain `{0,1}` and lie inside
  `{0,1,3,5,7}` were not searched; they are covered by the existence argument.

**Corollary 5 [computation + proof].** No width-16 frame of `C16` splits along a partition of the
blocks. For no nonempty proper block set `B` does a frame contain `16|B|` pairs local to `B`.
*Proof.* By Lemma 3 both `B` and `B'` would carry local frames, so by Proposition 4 both would lie
in `{0,1,3,5,7}`. But one of them contains block 2. ∎

This generalises the earlier results that no frame splits along the four quarters or along the
halves `{0,1,4,5} | {2,3,6,7}`: any frame is "block-indecomposable". The reason is local: blocks 2,
4 and 6 have no unit vector on at least one side, so they can be completed only through vectors that
reach into other blocks.

## 5. How deep partial frames stay rank-consistent (direction b)

*Observation [proof].* At any search node with `k` chosen pairs, `X' ⊆ (span chosen Z)^⊥`, which has
dimension `128−k`. So `rank G[X', Z'] ≤ 128−k = need` always, and the `-l` rank test is an equality
test with no slack to optimise.

*Beam search [heuristic]* (`beam_rank.py`; score = number of live pairs). Largest rank-consistent
partial frames found: 8 pairs with random scoring; 20, 22 and 21 pairs with live-pair scoring
(widths 24/48, seeds 1–3; `beam_live_*.log`). The number of live pairs decays geometrically, by a
factor of about 0.84 per pair: 79,295 after one pair, 14,594 after 10, 2,872 after 20 and 1,691
after 22. The greedy beam is weaker than structured starts: the earlier near-miss work found
rank-consistent subsets of 40 and 41 pairs inside the 88- and 84-pair partial frames, each with a
single live next pair, which then dies (`RESTRICTED-FRAMES-20261031.md`, Follow-up G). Either way,
rank-consistent partial frames found so far stop between 20 and 41 pairs, far below 128. This is
consistent with the unrestricted Knuth estimates, where leaves are at depth 4–7. It is evidence,
not a bound.

## 6. Aggregated integer and LP models (direction c)

- *Orbit-level integer model* (`orbit_ilp.py`): 45 × 45 counts with exact per-block
  induced-matching caps `ν` (8 distinct values, from 3 to 16; `nu.json`), row and column sums of
  at most 16, total 128, the 64 folded parity equations, and lazily separated pairing-rank cuts.
  **Feasible** at once (19 nonzero cells; `ilp_parity.json`).
- *Why parity cannot help [proof]:* every count vector with all entries even satisfies all folded
  parity equations. The orbit-level solution found is all even.
- *Cell-level (orbit, position mod m), m = 2* (`cell_ilp.py`). Without parity it is feasible at
  once, and heuristic rank separation keeps finding violated cuts (85, 56, 55 in rounds 0–2; not run
  to closure). With parity, HiGHS hit its 300 s limit with no feasible point, which is **unknown,
  not infeasible**.
- *Cell-level pairing-rank LP* (`cell_ilp.py m --lp [--cover]`; logs `cell_lp*_m*.log`). Maximise the
  total subject to caps, row/column sums and pairing-rank cuts. Separation is greedy and always
  tries the full support first. With `--cover`, add the 128 covering constraints: `Σ_i x_i[c] z_i[c] = 1`
  forces some frame pair with `x[c] = z[c] = 1`, so the cell pairs able to contain such a pair carry
  total weight at least 1. **The optimum is exactly 128 for m = 1, 2, 4, 8, with or without covering,**
  and no violated cut was found at the end [heuristic separation]. The LP solutions are far from
  real frames: restricting `la_gen -l` to the pool pairs inside the support cells (158–268 pairs;
  `support_instance.py`) gives COMPLETE, no frame, in at most 2 nodes for every m tried.
  Count-aggregated relaxations, at orbit or cell level, therefore do not see the obstruction, as the
  earlier moment and orbit-LP relaxations did not.

## 7. Summary and next steps

**New and exact:**
1. Lemma 1: `Z = π X`. A frame is a pair of dual bases from the X pool for the symmetric,
   non-alternating form `uᵀπv`.
2. Proposition 2 explains the `3^16` count on blocks `{0,1}` and the absence of local frames on the
   other quarters; the obstruction there is a phase twist.
3. Corollary 5 (with the local search for Proposition 4): **no frame splits along any partition of
   the 8 blocks**, generalising the earlier quarter and half results.

**Negative (recorded so they are not retried):** folded parity equations (satisfied by any all-even
counts); orbit- and cell-level integer and LP models with pairing-rank and covering cuts (optimum
128 at every refinement tried, with supports containing no frame).

**Evidence:** rank-consistent partial frames found stop between 20 and 41 pairs, and the number of
live pairs decays by about 0.84 per chosen pair.

**Suggested next steps:**
- *Use Corollary 5 in the exact search.* Branch first on block 2, 4 and 6 coordinates. A frame must
  cover each of them with pairs that reach into other blocks, which may prune earlier than the
  residual entry with the fewest candidates.
- *Indecomposability beyond blocks.* Lemma 3 holds for any subspace `V` spanned by pool vectors on
  both sides with `V^⊥` likewise; only coordinate blocks were tried. Searching over T-invariant
  R-submodules `V` (for example spans of a few orbits whose orthogonal complement is also spanned by
  pool orbits) could give more forbidden splittings, and possibly a structure theorem. Cheap to try:
  each local check took fewer than 700 nodes.
- *Why the gap.* Compare the 41-pair rank-consistent subsets with the 3^16 local `{0,1}` frames: do
  rank-consistent partial frames all use few block-2/4/6 coordinates? A counting statement there is
  the most plausible route to a real bound.
- Nothing here points to an asymmetric frame. The local picture (twists at blocks 2, 4, 6) is
  compatible with nonexistence, but it is not a proof.
