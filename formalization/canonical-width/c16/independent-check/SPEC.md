# Independent check: symmetric frames in the C16 pools

This is a self-contained task specification for an independent implementation. Write a new
program from this document alone.

## Independence rules

- Use only this document and the files it names.
- Do **not** read or reuse code or results from:
  - `formalization/canonical-width/c16/restricted-frames-20261031/` (search programs, SAT encoders, results);
  - `formalization/canonical-width/c16/paper/` and `formalization/canonical-width/c16/lean/`;
  - `formalization/canonical-width/c16/RESTRICTED-FRAMES-20261031.md`;
  - the other C16 search, SAT or SDP scripts in `formalization/canonical-width/c16/`.

  The aim is a second implementation that shares no code and no algorithmic choices with the first.
- You may use any language, standard libraries, and off-the-shelf solvers (SAT, ILP, CP), provided
  any solver you use is named in your README.
- State in your README which model and version wrote the code.

## Input files

All paths are in the repository `alectionary/vibe-math`, branch
`research/c16-structural-20261027T173245`, under `formalization/canonical-width/c16/`.

| File | Lines | SHA-256 (first 16 hex digits) |
|---|---|---|
| `pools/xcoords.txt` | 720 | `5a0661f1e04f5c4b` |
| `pools/zcoords.txt` | 720 | `14b2861040c206e1` |
| `independent-check/inputs/planted1-xcoords.txt` | 848 | `120a03656e5928d6` |
| `independent-check/inputs/planted1-zcoords.txt` | 848 | `e6f78eb45a947a0e` |

- **Line format:** line `i` (0-based) is a 128-bit integer `x_i` (or `z_i`) in hexadecimal. Bit `c` (bit 0 = least significant) is coordinate `c`, for `c` in `0..127`.
- **Blocks:** coordinates form 8 blocks of 16: block `b` is coordinates `16b .. 16b+15`.

## The problem

Define the pairing matrix

    G[i][j] = popcount(x_i AND z_j) mod 2        (i, j in 0..N-1)

where `N` is the number of lines: 720 for the real pools, 848 for the planted pools.

**Sanity check:** for the real pools, exactly **99,808** of the 720 × 720 entries of `G` are 1.

A **frame** is a pair of index sets `S` (X side) and `T` (Z side) with `|S| = |T| = 128` such
that the submatrix `G[S, T]` is a permutation matrix. Equivalently: every chosen X index has
exactly one chosen Z index with `G = 1`, and vice versa.

A frame can never have more than 128 pairs, because the vectors live in a 128-dimensional space.

**Index symmetry.** Index `i = 16a + t` (orbit `a`, position `t` in `0..15`). Define

    tau_k(i) = 16 * floor(i / 16) + ((i mod 16) + k) mod 16.

## The three symmetry classes to decide

For the **real pools**, decide exhaustively whether a frame exists in each class:

| Class | Condition on (S, T) |
|---|---|
| A (half-turn) | `tau_8(S) = S` and `tau_8(T) = T` |
| B (swap) | `S = T` (as index sets) |
| C (swap with half-turn) | `T = tau_8(S)` |

"Decide" means one of two outcomes:
- a complete search that proves no frame exists in the class; or
- an explicit frame, given as 128 `(i, j)` pairs.

A time-limited search that finds nothing is **not** a decision; report it as INCOMPLETE.

## Known-answer tests (all must pass before the real runs count)

1. **Planted frame.** In the planted pools, `S = T = {720, …, 847}` with `i` paired to `i` is a frame, and it lies in all three classes. Your program must find a frame for the planted pools in each of A, B and C. It need not be that particular one. The search should still be exhaustive in design, not told where the planted frame is.
2. **Quarter-turn class (no frame).** For the real pools, the class `tau_4(S) = S` and `tau_4(T) = T` has no frame. Your program must report a complete search with no frame.
3. **Counting on a sub-problem.** Restrict both real pools to vectors supported only on blocks 0 and 1 (coordinates `0..31`). Consider frames of that 32-dimensional space: `|S| = |T| = 32` and `G[S, T]` a permutation matrix. There are exactly **43,046,721 = 3^16** such frames.
   - Counted as unordered matchings, i.e. distinct `(S, T, pairing)`.
   - If your method cannot count, state that and skip this test.
4. **No frame on blocks 2 and 3.** The same restriction to blocks 2 and 3 (coordinates `32..63`) has no 32-pair frame.

## Output

- **Per run**, one JSON object:
  `{"pools": "real|planted1", "class": "A|B|C|quarter|blocks01|blocks23", "status": "COMPLETE|INCOMPLETE", "frames_found": n, "frame": [[i, j], ...] or null, "seconds": t, "notes": "..."}`.
- **Code:** in `formalization/canonical-width/c16/independent-check/` under a subdirectory named after the model (for example `chatgpt/`), with a README containing:
  - build and run commands;
  - the method;
  - why the search is exhaustive (a short correctness argument for any pruning);
  - the result table.
- **Frame check:** any frame reported must pass a check your program prints: `|S| = |T| = 128`, all indices distinct, `G[S, T]` a permutation matrix, and the class condition.

## Scale (so the method is chosen sensibly)

The search space is enormous: naive enumeration of subsets will not finish. An exhaustive method
needs strong pruning or an efficient encoding. Target machine: 2 CPU cores, about 2 hours per
class.
