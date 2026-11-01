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
