# C16 restricted-frame checkpoint — 31 October 2026

**The source question is still open: width 16 or 18.** This note records one
session's restricted results so the next investigator can start from them
instead of re-deriving them. Nothing here excludes an unrestricted width-16
frame or proves width 18.

Everything below is reproduced by the scripts in
[`restricted-frames-20261031/`](restricted-frames-20261031/), which read the
canonical [`pools/`](pools/) directly (SHA-256 of `xcoords.txt`
`5a0661f1…4ea89d`, `zcoords.txt` `14b28610…bbe977`). One command reruns all of
it except the open long searches:

```
cd formalization/canonical-width/c16/restricted-frames-20261031
PATH=/path/to/kissat:/path/to/drat-trim:$PATH ./run_all.sh
```

Tools used: Kissat 4.0.4 (`8af8e56f`), drat-trim (`2e3b2dc0`), Python 3.13,
NumPy 2.5. Long runs used `nice -n 19`, one thread.

## Setup used throughout

Write a pool vector as eight 16-bit blocks, block `b = 4a + 2p + q`.
T rotates every block by one bit at once. Logical space is `R^8` with
`R = F2[x]/(x^16+1)`, a local ring with maximal ideal `(y)`, `y = 1+x`.
The pairing is the standard F2 dot product, and the 720×720 Gram
`G = X Z^T` is symmetric. A frame is a pair of 128-subsets `S, T` with
`G[S,T]` a permutation matrix.

## Results

| # | Claim | Evidence | Script / record |
|---|---|---|---|
| 1 | No frame splits along the quarters `{0,1},{2,3},{4,5},{6,7}` | Written proof + exact finite computation; DRAT-verified | `quarters.py`, `support_cnf.py`, `results/quarters.json` |
| 2 | Pool structure facts listed below | Exact finite computation | `structure.py`, `results/structure.json` |
| 3 | No T⁴-invariant frame (independent re-encoding) | Kissat UNSAT; reproduces the existing DRAT-verified result in [STRUCTURAL-COMPARISON.md](STRUCTURAL-COMPARISON.md) | `subgroup_cnf.py 4` |
| 4 | T⁸ (half-turn) invariant frames | **Open.** Kissat timed out at 6,931 s; the stronger repo encoding was stopped at 7,138 s (follow-up B) | `subgroup_cnf.py 2`, `results/h2-kissat.log.gz` |
| 5 | Frames splitting into a `p=0` and a `p=1` half | **Open.** `p1` timed out at 5,349 s; `p0` got ~600 s only | `support_cnf.py`, `results/p1-kissat.log.gz` |
| 6 | No order-3 invariant frame | Written: 3 ∤ 128 | — |

### 1. Quarter-split frames do not exist

Pairing between different quarters is zero, so a frame made only of
quarter-supported vectors would split into four 32-pair frames, one for each
quarter. In each of the quarters `{2,3}`, `{4,5}` and `{6,7}`, one side's pool
has exactly 32 vectors of rank 32 (X for `{2,3}`; Z for `{4,5}`; both for
`{6,7}`). That side must therefore be the whole frame side, which forces the other
side to be its dual basis. In every case only 16 of the 32 forced dual vectors
lie in the other pool. Example missing vectors are listed in
`results/quarters.json`. The SAT encodings confirm this: the quarter `{0,1}` is
SAT (a decoded 32-pair frame passes the permutation check in `decode.py`), and
`{2,3}`, `{4,5}` and `{6,7}` are UNSAT, with DRAT cores of 8, 114 and 5 clauses.

This is a restricted exclusion only. Frames in general mix quarters.

### 2. Structure of the pools (all recomputed by `structure.py`)

- Both pools are closed under T: 45 orbits per sector, all of size 16.
- **Unit vectors.** 96 X-pool and 96 Z-pool vectors are unit vectors `e_i`.
  - X units lie on blocks {0,1,3,4,5,7}; Z units on {0,1,2,3,5,7}.
  - 80 unit vectors are common to both pools.
  - Block 6 has no unit vector on either side.
- **Half sub-pools.** Each half has a full-rank (64) sub-pool on both sides:

  | Half | Blocks | X vectors | Z vectors |
  |---|---|---|---|
  | p0 | {0,1,4,5} | 240 | 144 |
  | p1 | {2,3,6,7} | 160 | 144 |
  | a0 | {0,1,2,3} | 144 | 240 |
  | a1 | {4,5,6,7} | 144 | 160 |

  X is heavy on p-halves, Z on a-halves.
- The Z sub-pool of p1 is exactly that of p0 under the block map 0→2, 1→3, 4→6, 5→7.
- **Symmetry is scarce.**
  - The only block permutation that preserves the multiset of y-adic valuation profiles of both pools is the identity.
  - The only one taking the X profiles to the Z profiles is (0,1,4,5,2,3,6,7), the X↔Z swap of blocks 2,3 ↔ 4,5.
  - Among maps acting by GL2(F2) on each block pair (X by M, Z by M^{-T}), only the identity preserves both pools (1 of 6⁴).
  - The X sub-pool of p0 is invariant under the order-3 map (u0,u1)↦(u1,u0+u1) on every pair, but this does not extend to the full pools.

### 3–5. SAT encodings

`subgroup_cnf.py L` encodes frames invariant under `<T^(16/L)>` as an induced
matching on the orbit table. It forbids selected pairs with 2 or more circulant
monomials, requires exactly one unit partner per selected orbit, adds coverage
clauses, and requires at least 128/L orbits per side. This is the same reduction
as the repo's `subgroup_frame.py`, written independently, but without its extra
constraints (critical-monomial bound and lexicographic symmetry breaking). The
L=4 CNF is UNSAT, matching the existing certificate.

`support_cnf.py H` encodes a frame of `span(e_i : i in blocks H)` that uses
only pool vectors supported in H.

CNF hashes (deterministic; regenerated by `run_all.sh`):

| CNF | Variables / clauses | SHA-256 | Outcome |
|---|---|---|---|
| h4 (T⁴) | 44,880 / 113,956 | `d56746f2b8bad814fb69aa29e17af74fc67ef12e8a5aefde2323c3d1bdd798ea` | UNSAT |
| h2 (T⁸) | 183,664 / 447,896 | `dee1cad013102fe39c94683148672387f9443b16e466ff78b3911e33d02318a1` | timeout 6,931 s |
| p0 | 50,240 / 107,216 | `c34db83b732c112920d629c09045d2efacc22389a76711a8d62dad6653911c7f` | ~600 s, no result |
| p1 | 21,680 / 48,736 | `60b0bc893396e64596f6c29fb572cee771a0695dcd36a765bb6b1b9d2ad085e1` | timeout 5,349 s |

Timeouts are not negative certificates. A SAT answer on h2 would be a full
128-pair frame (decode with `decode.py`). It would then still need
physical materialization and verification with the repo's existing
`materialize_pool_frame.py` / `verify_partial_frame.py` chain. A SAT answer on p1
alone is not enough; both p0 and p1 must be SAT to give a frame.

## Follow-up A: global consequences of the quarter structure

**Status: a necessary condition that does not bind at point 22. Stopped under
its stop rule.** Everything here holds for every frame; it uses only the
induced-matching condition restricted to one quarter basis B (the 32 pool
vectors of one sector supported in a quarter whose pool is exactly a basis).

- **Forced duals are realized by only one of the two T-orbits in each basis**
  (`global_quarter.py`, `results/global_quarter.json`).
  - The basis splits into orbits 33 and 35 for quarter {2,3} (X side) and quarter {4,5} (Z side), and into orbits 39 and 41 for quarter {6,7} (both sides).
  - For orbit 33 (resp. 41), no opposite-pool vector pairs to 1 with b and to 0 with the other 31 basis vectors.
  - For orbit 35 (resp. 39), every forced dual is realized.
  - So a selected vector of orbit 33 or 41 always forces another basis vector of its quarter out of the frame.
- **No pairwise exclusions** (`forced_exclusions.py`): for no b is one
  fixed c forced out by every possible partner. The constraint is genuinely
  disjunctive and gives no zero second moment.
- **Exact cap on a frame's footprint in a quarter basis** (`local_max.py`,
  Kissat; the selection family is closed under subsets):

  | Basis | Distinct partner patterns | Max selectable | UNSAT at |
  |---|---|---|---|
  | {2,3} X (orbits 33, 35) | 256 | 23 | 24 |
  | {4,5} Z (orbits 33, 35) | 256 | 23 | 24 |
  | {6,7} X (orbits 39, 41) | 384 | 24 | 25 |
  | {6,7} Z (orbits 39, 41) | 384 | 24 | 25 |

- **Against point 22.** p(33) = 0.286, p(35) = 0.244, p(39) = 0.418 and
  p(41) = 0.276 (read from
  `coupling-results/two-basis-integer-witness22-rational.json.gz`, `values[0:45]`).
  So point 22 expects about 8.5 selected vectors in the {2,3} basis and about
  11.1 in the {6,7} X basis, against caps of 23 and 24. Neither the cardinality cap
  nor the forced-dual fact can separate it. A joint two-orbit
  second-moment hull is the only remaining refinement here, and with this much
  slack it is not worth building.

## Follow-up B: half-turn case with the repo's stronger encoding

The frozen `subgroup_frame.py` (critical-monomial bound and lexicographic
translation/sector symmetry breaking) runs unchanged with a minimal stand-in for its
two `pysat` cardinality encoders (`pysat_shim/`, sequential counters). PyPI was
unreachable from this session. The stand-in is logically equivalent but not
clause-identical, so CNF hashes differ from `structural-results/`.
- **Validation:** order 4 returns UNSAT in 215 s (85,213 variables / 215,870 clauses,
  CNF SHA-256 `b959ae253af580585907e7094da1ea989f2908a8adfa2cb0447caaf10e0a183e`).
- **Order 2:** 331,073 variables / 810,210 clauses, CNF SHA-256
  `dc2b1d0d8b5e123d88b566ef77e2746173a0c4e4c8f2659efd402e7c41dc0452`. Running
  for a 10,800 s bound at nice 19, with the proof sent to /dev/null to protect the
  disk. On UNSAT, rerun with a proof file to certify; Kissat is deterministic.
  Outcome: see attempts below.
- **Attempt 1 (interrupted):** ran 5,766 s with no SAT/UNSAT before a container
  restart killed it. This is not a solver time limit and carries no evidence
  either way. Restarted from scratch on the identical CNF for the full 10,800 s bound.
- **Attempt 2 (stopped, inconclusive):** this session's background jobs are capped
  at 2 hours, so the run was killed with SIGTERM at 7,138 s process time, before its
  own 10,800 s bound. There was no SAT/UNSAT. It reached 9.51 M conflicts
  (about 1,330 per second) and 30.6 M decisions, with about 81.9 k of the
  331 k variables still active. The log is in `results/h2-subgroup-frame-run2.log.gz`.
  **The half-turn case remains open.** Kissat cannot resume a run, so a
  conclusive attempt needs a machine that can run for at least 3 hours without
  interruption, or a cube-and-conquer split (for example on the orbit-12
  critical-monomial variables) into jobs that each finish within 2 hours.

Run it with:
```
PYTHONPATH=restricted-frames-20261031/pysat_shim nice -n 19 python3 subgroup_frame.py \
  --order 2 --output OUT.json --kissat KISSAT --drat-trim DRAT_TRIM --seconds 10800
```

## Suggested next steps

1. **Finish the half-turn case** (follow-up B, still open after 7,138 s with the
   stronger encoding). Do one of the following:
   - run it uninterrupted for 3 hours or more, on a host without a 2-hour job cap;
   - split it into cubes (cube-and-conquer) and run each cube as its own job.

   This is the last subgroup-invariant case before the unrestricted search.
2. **Run p0 for a comparable bounded time.** p0 is the other half of the
   split test.
3. ~~Use the quarter obstruction globally~~: done in follow-up A. It is valid
   but non-binding at point 22.

## Follow-up C: half-turn case by cube-and-conquer (in progress)

`restricted-frames-20261031/cnc.py` splits the follow-up B CNF (SHA-256 `dc2b1d0d…0dc0452`)
into cubes over the primary orbit variables. Cubes are taken first on the critical
orbit 12 (X, then Z), then on the other orbits. Each cube is solved by Kissat with
units appended. Each UNSAT leaf's DRAT proof is checked by drat-trim before
deletion; the proof's hash and size are kept. A cube that times out is split in
two. The leaves therefore always partition the assignment space, and
`check_tree()` re-verifies that from the recorded tree. State is resumable in
`work/cnc/state.json`.
- The root is pre-split on the 8 X-side orbit-12 variables (256 cubes).
- A 60 s probe closed most of the first cubes in under 1 s (lexicographic
  symmetry breaking plus the at-most-5 critical bound). The rest were split.
- **Status after about 4.7 h of solver time: paused, inconclusive.** No SAT cube was found.
  - 302 leaves: 23 UNSAT with checked proofs, 19 UNSAT without proofs (proof-free `--mode search`), 260 open.
  - State is in `results/cnc-state-20261101.json.gz` and the log in `results/cnc-driver-20261101.log.gz`.
- **Splitting on single orbit variables does not make cubes easier.**
  - Cubes that close quickly do so in under 1 s, through symmetry breaking and the critical bound. Roughly 9 in 10 do not.
  - Every split produced the same "ladder". Selecting the variable (`+v`) gave UNSAT in about 100–280 s. Excluding it (`-v`) gave a cube about as hard as its parent.
  - The deep-first probe followed one such chain from depth 8 to depth 17 before both children closed, about 4,400 s for a single depth-8 cube.
  - Extrapolated over the ~220 hard depth-8 cubes, that is on the order of 100+ single-thread hours before certification, which costs about 3× more.
- With proofs, checking costs about 2.7× the solve time, and each proof is about 250 MB. That is why the search was moved to proof-free mode with a later `--mode certify` pass.
- Better options than more of the same:
  1. Split on cardinalities instead of literals, for example on how many sub-orbits of each orbit are selected. That makes the `-v` side bind.
  2. Add stronger symmetry or structural constraints before cubing.
  3. Run the existing tree on many cores (the cubes are independent).

### Follow-up C results so far (1 November)

- 300 s cubes with literal splitting make a "ladder": the selected (`+v`) side closes and the excluded side stays about as hard. Piece #262 cost 4,537 s split this way.
- Splitting it by count (`cardtest.py`) cost 2,125 s; piece #274 cost 1,538 s that way.
- Solving #262 and #274 whole cost at most 634 s each. Splitting throws away what the solver has learned.
- On a 5-core Mac (`cnc_parallel.py --whole-depth 8`), the depth-8 pieces split into two groups:
  - Pieces selecting 5 X sub-orbits of orbit 12 close in 5–12 minutes.
  - Almost every piece selecting 4 or fewer takes over 15 minutes. #270 and #278 needed 6,072 s and 6,777 s whole (cloud runs). About 160 such pieces exist under the original orbit-0-first lexicographic order.

## Follow-up D: orbit-12-first symmetry breaking

`subgroup_frame_o12.py` imports the frozen encoder's `encode()` unchanged and
uses the same 16-element symmetry group:
- the translation T, acting on every sub-orbit index p ↦ p+1 (mod 8) in both sectors;
- the sector swap (S,T) ↦ (T,S), valid because G is symmetric.

The only change is the variable order of the lexicographic-leader constraints: the 8 X
sub-orbit variables of orbit 12 come first, then the other X variables in the
original order.

**Soundness.** Fix any total order σ of the X variables. Every solution's orbit
under the group contains an element whose σ-ordered X part is lexicographically maximal. That element satisfies
`σ(x) ≥lex σ((g·sol)_X)` for every g. So adding these constraints for all g preserves
satisfiability whenever the group maps solutions to solutions.
`check_o12_symmetry.py` verifies that it does: each group element preserves
- every pattern class (zero, one monomial, or two or more), which is all the non-lex clauses depend on;
- both cardinality targets;
- the critical orbit-12 set.

**Control.** With σ set to the identity order, the builder reproduces the follow-up B CNF
byte for byte (`dc2b1d0d…`).

**New CNF:** 331,073 variables and 810,210 clauses, SHA-256
`470ce05d4ae9e607a91cd56677fc5b9d1abb427928d335c838681d689ca48211`.

**Effect.** The 256 depth-8 cubes on the orbit-12 X variables were run with a 15 s limit:
- 226 were UNSAT in 0.52 s or less.
- 30 remained open. These are exactly the 30 lexicographically maximal rotation classes with at most 5 ones, computed independently.
- Of these 30, 23 have 4 or fewer ones (the expected hard type), against about 160 under the original order.

The 30 are now solved whole. Tree: `work/cnc-o12/state.json`, with `C16_CNC=o12`.

**Correction (22:00, 1 November): fewer pieces, not much less work.** The first
o12 pieces with 5 ones took 2,412–3,142 s each (#266, #268, #274). Their old-order
counterparts took 5–12 minutes, and each new piece covers 8 old ones. So a new
piece costs about the sum of its 8 rotated copies. The old orbit-0-first
lexicographic order was already removing that symmetry, spread across orbits. The
gain is about 1.3×, not 8×. Expect the 23 hard pieces to take several hours each.
Estimate: 1.5–2 days on 5 cores for the search pass.

## How to resume the half-turn run (state at 22:30, 1 November)

Machine: a 6-core Mac running natively. A cloud session's job cap (about 2 h) is too short
for these pieces. Files are all under `restricted-frames-20261031/`.

- **Input:** `work/o12/o12.cnf`. Regenerate it with
  `PYTHONPATH=pysat_shim python3 subgroup_frame_o12.py work/o12/o12.cnf` and check
  the SHA-256 `470ce05d…48211`.
- **Tree:** `work/cnc-o12/state.json`. It is the only state; it is written after every
  piece and is safe to kill at any time. A snapshot is in `results/cnc-o12-state-*.json.gz`.
- **Search pass (no proofs):**
  ```
  C16_CNC=o12 python3 cnc_parallel.py --kissat K --drat-trim D --jobs 5 \
      --mode search --whole-depth 8 --cube-seconds 200000
  ```
  On the Mac: `C16_CNC=o12 bash run-mac.sh 5 --whole-depth 8 --cube-seconds 200000`.
  This builds Kissat and drat-trim from `src/` on first use.
- **Statuses:**
  - `UNSAT_UNPROVED`: closed, but no proof yet.
  - `UNSAT_CHECKED`: closed with a drat-trim-verified proof.
  - `whole_timeout`: set aside after hitting the limit.
  - `SAT`: decoded and checked as 128 pool pairs in `witness.json`; then run the repo's physical verification chain.
- **Certify afterwards:**
  `C16_CNC=o12 python3 cnc_parallel.py ... --mode certify`. It re-solves each
  `UNSAT_UNPROVED` leaf with a DRAT proof and checks it. Allow about 2.7× the solve time for checking,
  and about 250 MB of proof per piece while it is checked.
- **Superseded:** the old-order tree `work/cnc/state.json`
  (snapshot `results/cnc-state-mac-20261101.json.gz`). It used the same base problem with a different
  symmetry order, so its leaves must not be mixed with the o12 tree.
- **Tools:** `cnc.py` (tree, decoding, serial driver), `cnc_parallel.py` (parallel
  driver), `cardtest.py` (count-split probe), `cloudhard.py` (whole-piece helper),
  `check_o12_symmetry.py` (symmetry check), `run-mac.sh` (macOS launcher).

## Follow-up E: linear-algebra exact search (`la/`)

**Formulation.** Pairs (x_i, z_i) form a frame exactly when the 128 outer products
x_i z_iᵀ sum to I over F2. If they sum to I, then X_Sᵀ Z_T = I, so X_S is invertible
and X_S Z_Tᵀ = I. `la/la_dfs.c` searches for frames directly on this identity. The
search state is the set of chosen items and the residual R = I − (sum of their outer products).
- **Branch.** Choose an entry with R[c][k] = 1, using the fewest candidates. Every
  completion's outer products sum to R, so some remaining item has a 1 at that
  entry. Branch over exactly those items. Earlier siblings' items are excluded in
  later siblings' subtrees: each completion is reached through the first sibling it contains.
- **Prune.** Let `need` be the number of vectors still required. They must come from
  - X′, the unused X groups orthogonal to every chosen Z vector, and
  - Z′, the unused Z groups orthogonal to every chosen X vector.

  Require rank(pairing on span X′ × span Z′) ≥ need.
- **Items.** A subgroup case uses sub-orbit pairs (i, j, h) whose pattern is one monomial;
  each such item carries L pairs. The unrestricted case uses single pairs with G = 1.
- **Instances.** `la/gen_instance.py` writes them. `la/verify_frame.py` checks any frame found:
  - the Gram matrix in pair order is the identity;
  - all 128 vectors on each side are distinct;
  - every vector is a pool member.

| Instance | Expected | Result |
|---|---|---|
| quarter {0,1}, 32 dims | frame exists | frame found, verified |
| quarters {2,3}, {4,5}, {6,7} | none | none |
| order 16, 8 | none | none, 16 and 332 nodes |
| order 4 (T⁴) | none (DRAT-certified) | none, 15,088 nodes, 2 s |
| planted random T-invariant frame (seed 1), order 16 / 4 | 1 frame | 1 found, verified |
| planted random T-invariant frame (seed 2), order 4 | 1 frame | 1 found, verified |
| planted (seed 1), order 2 | 1 frame | planted frame found and verified (run stopped at the 2 h background limit before finishing the tree) |
| planted (seed 2), order 2 | 1 frame | planted frame found and verified (run stopped at the 2 h background limit before finishing the tree) |
| quarter {0,1} with `-c`, full enumeration | 3^16 (INVESTIGATION.md) | 43,046,721 = 3^16 frames, 330 s |
| **order 2 (half-turn)** | open | **COMPLETE, no frame**: 9,995,481 nodes on 2 shards, 801 s + 787 s |

The planted controls append 8 X and 8 Z orbits of a random T-invariant frame
(`--plant SEED`) to the real pools; the search must find that frame.

**Status of the half-turn result.** This is the output of an unverified custom
program, not a certificate. It agrees with every control above and with the 230
o12 SAT pieces closed so far. Before it is recorded as a theorem, the program or an
independent reimplementation needs review, or the SAT/DRAT route must finish.
Instance SHA-256 prefix: `60acef5f7b8a0bf0` (order 2).

**Coloop forcing (`-c`).** If the X side still has to supply its remaining vectors from X′, every coloop of X′ (a vector outside the span of the others) must be in the frame, and likewise on the Z side. With `-c` the search branches over a coloop's group when that group has fewer live items than the best residual entry, and prunes when a coloop has no live item. On order 4 this changes nothing (15,088 nodes both ways); the rank pruning already sees it.

**Look-ahead filter (`-l -f`).** Two sound strengthenings:
- `-l`: every remaining frame pair is a live item, so X′ and Z′ shrink to the X and Z sides of the live items (sibling exclusions included).
- `-f`: choosing item (a, b) leaves X′ ∩ b^⊥ and Z′ ∩ a^⊥. The child passes the rank test iff both still span need − g dimensions; the pairing between them is then perfect automatically, since the a- and b-groups pair perfectly. So the test splits into one span computation per Z group and one per X group. Items failing it are removed, and the step repeats to a fixpoint.

| Instance | plain | `-l -f` |
|---|---|---|
| order 4 | 15,088 nodes | 491 nodes, 1 s |
| planted seed 1 / 2, order 4 | 1 frame | 1 frame (944 / 976 nodes), verified |
| planted seed 1, order 16 | 1 frame | 1 frame, 11 nodes, verified |
| quarter {0,1}, first frame | found | found at node 33, verified |
| quarter {2,3} | none | none, root pruned |
| planted seed 1 / 2, order 2 (`-1`) | 1 frame each | planted frame found after 978,158 / 930,256 nodes (2,572 s / 2,527 s), verified |
| half support {0,1,4,5}, 64 dims | open | none: 1,911 nodes plain, 503 with `-l -f` |
| half support {2,3,6,7}, 64 dims | open | none: 435 nodes plain, 130 with `-l -f` |
| order 2 | 9,995,481 nodes, no frame | 810,784 nodes, no frame (Knuth estimate was ~6e5) |
| unrestricted, Knuth estimate | ~9e11 | ~2e11 (200 probes, max 2e13), leaves at depth 3–6 |
| unrestricted, no weight-1 vectors | – | ~3e10 (100 probes) |

**Half-turn rerun with `-l -f`: COMPLETE, no frame.** 810,784 nodes on 2 shards (418,365 + 392,419), 1,122 s + 1,011 s, against 9,995,481 nodes for the plain run. It is a second, differently pruned check by the same program, not an independent implementation.

The half-support rows rule out only frames of the 64-dim subspace that use pool vectors supported on those blocks (block-diagonal frames). They do not restrict a global frame.

**Symmetry.** Colour refinement (`explore/auto_wl.py`) on the coordinate/pool incidence graph gives one class per block. Individualising coordinate 0 makes the colouring discrete. So the coordinate-permutation automorphisms preserving both pools are exactly the 16 translations T^k, and 32 with the X↔Z swap. No hidden permutation symmetry is available to shrink the unrestricted search.

**Cocircuits.** `explore/cocircuits.py` looked for functionals u that are 1 on few pool vectors; these would allow narrower branching. Unit vectors give 66–88 pool vectors. Random dual-basis functionals give about 240. So the root branching width is intrinsic, and residual-entry branching is already close to the best a single hyperplane offers.

**Unrestricted problem.** The same search on all 99,808 single pairs (`gen_instance.py order 1`):
- A Knuth estimate (`la_dfs -k 20`) gives about 9e11 nodes, heavy-tailed (maximum 8e12), with leaves at depth 4–7.
- That is out of reach at about 6,000 nodes/s without further reduction, such as the 32-element symmetry group or stronger pruning.

## Follow-up F: the full symmetry group and the remaining involution classes

**The problem is purely combinatorial.** A frame is a pair (S, T) of 128-sets with G[S, T] a permutation matrix, where G = X Zᵀ is the 720 × 720 anticommutation matrix. Equivalently, it is an induced matching of size 128 in the bipartite anticommutation graph. Since rank_F2(G) ≤ 128, no induced matching is larger, so a frame is an induced matching that meets the rank bound.

**Full symmetry group = T^k × {id, swap}, order 32.** `explore/gram_wl.py` runs colour refinement on the anticommutation graph:
- The colour classes are exactly the 90 T-orbits, or 45 orbit pairs when the X/Z swap is allowed.
- Individualising one vertex makes the colouring discrete.

Every symmetry of the frame problem is an automorphism of this graph, linear ones included. So nothing beyond the 16 rotations and the swap exists. The swap is valid because G is symmetric.

**Involution classes.** Z16 × Z2 has exactly three involutions: T⁸, s (swap) and sT⁸.
- A frame fixed by none of them has a free orbit of size 32.
- s acts on pairs as (i, j) → (j, i).
- sT⁸ acts as (i, j) → (τj, τi), where τ is T⁸ on pool indices.

`la/la_gen.c` is la_dfs generalised to items of any size, with availability tracked per pool vector. `la/gen_items.py` writes the items as the H-orbits of pairs that are partial frames.

Validation:
- `gen_items.py order 4` with `la_gen` reproduces la_dfs on order 4 exactly: 15,088 nodes, identical per-depth counts, and 491 nodes with `-l -f` / per-item filter.
- `order 2` gives the same 38,192 items as la_dfs.
- Sharding `-S n -s i -D d` partitions the children created at depth d. On order 4 the per-depth sums match the unsharded run.

| Class | Items | Result |
|---|---|---|
| s-invariant (swap) | 7,936 (416 single, 7,520 double) | **COMPLETE, no frame**: 69,180 nodes, 34 s (`-l`) |
| s-invariant, planted seed 1 | 8,064 | planted frame found (86,873 nodes), verified |
| sT⁸-invariant | 49,904 doubles | **COMPLETE, no frame**: 50,401,313 nodes on 2 shards (-S 2 -D 1; 25,267,931 + 25,133,382), 6,679 s + 6,625 s (`-l`) |

The planted frame is T-invariant with diagonal pairs (720+k, 720+k), so it is invariant under both s and sT⁸.

Once sT⁸ is closed, together with Follow-up E: **any frame has trivial stabiliser in the full symmetry group**, so frames would come in free orbits of 32. This does not by itself exclude frames.

**Negative results (recorded so they are not retried).**
- *Parity checks* (`explore/parity_checks.py`): every frame satisfies #{e ∈ F : z_eᵀ L x_e = 1} ≡ tr L for every matrix L. Restricting L to one block, the smallest odd-trace check found still involves 1,515–2,595 pool pairs. That is no narrower than the residual-entry branching.
- *Cocircuits* (Follow-up E): unit functionals are near-minimal.
- *Per-vector look-ahead in la_gen* (`-f`): sound, but 15× slower than `-l` alone on the swap class (525 s against 34 s). Use `-l`.

**Unrestricted estimates with la_gen (2026-11-02, 300 Knuth probes each, `-l`).**
- Full tree: about 1.8e12 nodes, very heavy-tailed (one probe gave 1.7e14).
- Frames forced to contain a given X vector (`-x`, rotation normalisation): 5e11 (orbit 0), 2e11 (orbit 12) and 6e10 (orbit 30) per sub-search.
- No orbit is forced by rank: removing any single X or Z orbit leaves pool rank 128.

Summing the per-smallest-orbit sub-searches does not beat the unforced tree. So the simple root normalisation does not deliver the 16× symmetry saving; that would need orderly generation.

Order of magnitude: 1e11–1e12+ nodes at a few thousand nodes/s per core, which is 1e4–1e6 core-hours. That is the scale of other large computer proofs, such as the Boolean Pythagorean triples (about 2 days on 800 cores) and Schur number five (about 14 CPU-years). It is feasible only with cluster time, and the heavy tail makes the estimate uncertain by 10× or more.

## Follow-up G: exhaustive completion of dismantled near-misses (2026-11-02)

`la_gen -p FILE` fixes the listed pool pairs and searches every completion; `la/nearmiss.py` drives random dismantling. The saved physical near-misses `partial-frame-88.json` and `partial-frame-84.json` map exactly onto pool pairs, with logical Gram identity checked (`la/inst/partials.json`).

- **Planted control** (`gen_items.py --plant 1 order 1`): the planted 128-pair frame was dismantled by dropping 30, 50 or 60 pairs. Each time the search recovered a full frame in under 100 nodes, and `gen_items.py verify` accepted the 128 pairs.
- **The 88- and 84-pair frames themselves** are rank-dead at the root: no completion exists.
- **Random subsets of the 88:** keeping 24 to 80 of its pairs is always rank-dead at the root (3 trials per drop size, 8 to 64 pairs dropped). A greedy minimal rank-dead subset has only 7 pairs, none of them monomial-X.
- **Largest root-compatible subsets** (greedy, 6 orders): 40 of the 88 and 41 of the 84. Each has a single live next pair, and that child dies, so it is COMPLETE with 2 nodes and no frame.
- **Random pieces of the 40-pair compatible subset**, completed exhaustively: keeping 30, 20, 12 or 8 pairs gives COMPLETE with no frame (2 to 789 nodes, at most 0.6 s). Keeping 5 already exceeds 300 s, which means 5 pairs leave essentially the whole search open.

Conclusion: the known near-misses are not close to any frame in the sense of shared pairs. Every sampled piece of 8 or more of their pairs lies in no frame. Neighbourhood search around them will not find a frame; any frame shares only a handful of pairs with them.
