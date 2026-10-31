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
| 4 | T⁸ (half-turn) invariant frames | **Open.** Kissat timed out at 6,931 s | `subgroup_cnf.py 2`, `results/h2-kissat.log.gz` |
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

## Suggested next steps

1. **Rerun the half-turn case with the repo's stronger encoding.** Add the
   critical-monomial bound and lexicographic symmetry breaking from
   `subgroup_frame.py` (and the 80 common unit pairs as hints). This is the
   last subgroup-invariant case before the unrestricted search.
2. **Run p0 for a comparable bounded time.** p0 is the other half of the
   split test.
3. **Use the quarter obstruction globally.** Look for a cardinality or rank
   lemma: how many frame vectors can be supported in `{2,3}`, `{4,5}` or
   `{6,7}`? The forced-dual argument above may extend to a necessary inequality.
