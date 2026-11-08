# Independent certificate checker: symmetric frames in the C16 pools

Write a program that **checks proof certificates** produced by our search, from this document
alone. The certificates claim that no frame exists in three symmetry classes. Your checker must not
trust our search program: it re-derives everything a certificate relies on, and accepts only if the
certificate proves the claim.

## Independence rules

- Use only this document, `SPEC.md` in this directory (definitions of pools, `G`, frames, `tau_k`),
  and the files listed below. Do **not** read our search code (`restricted-frames-20261031/la/`),
  our reference checker (`restricted-frames-20261031/certificates/check_cert_ref.py`), the paper, the Lean files, or
  `RESTRICTED-FRAMES-20261031.md`.
- Any language. Prefer a compiled one (C, C++, Rust, Go): the largest certificate has about 50
  million nodes. No external solvers are needed.
- State in your README which model and version wrote the code.

## Inputs

Repository `alectionary/vibe-math`, branch `research/c16-structural-20261027T173245`, directory
`formalization/canonical-width/c16/`:

| File | Role |
|---|---|
| `pools/xcoords.txt`, `pools/zcoords.txt` | the pools (format and hashes in `SPEC.md`) |
| `independent-check/inputs/planted1-{x,z}coords.txt` | planted pools (see `SPEC.md`) |
| `restricted-frames-20261031/certificates/*.inst` | instance files (format below), one per class |
| `restricted-frames-20261031/certificates/*.cert.gz` | certificates (gzip text, format below) |
| `restricted-frames-20261031/certificates/MANIFEST.json` | SHA-256 of every instance and certificate |

Check every file's SHA-256 against `MANIFEST.json` before use.

## Mathematics

Pools `x_0..x_{N-1}`, `z_0..z_{N-1}` in `F_2^128`, `G[i][j] = <x_i, z_j>` (popcount of AND, mod 2).
A **frame** is a set `F` of 128 pairs `(i, j)` with all `i` distinct, all `j` distinct, and, for
any pairs `p = (i, j)` and `p' = (i', j')` in `F`, `G[i][j'] = 1` iff `p = p'`. (This is the frame
of `SPEC.md`, with `S`, `T` the X and Z indices and each `i` paired with its unique `j`.)

**Frame identity.** If `F` is a frame then `sum_{(i,j) in F} x_i z_j^T = I` (the 128x128 identity
over `F_2`). Proof: the matrix `A` with rows `x_i` and `B` with rows `z_j` (in pair order) satisfy
`A B^T = I`, so `A` is invertible and `B^T A = I`, which is the sum.

**Symmetry classes.** Each class is a group `H` acting on pairs:

| Class | Generator of `H` on pairs `(i, j)` |
|---|---|
| `half` (A) | `(i, j) -> (tau_8 i, tau_8 j)` |
| `swap` (B) | `(i, j) -> (j, i)` |
| `swapT8` (C) | `(i, j) -> (tau_8 j, tau_8 i)` |
| `quarter` (test) | `(i, j) -> (tau_4 i, tau_4 j)` |

A frame is in the class if `H` maps `F` onto itself. (Classes A, B, C are those of `SPEC.md`;
`quarter` is `H = <tau_4>` acting on both indices, used only for tests. For the planted pools use
the same maps.)

**Items.** An *item* is an `H`-orbit of a pair `(i, j)` with `G[i][j] = 1` (over all
`0 <= i, j < N`) whose pairs form a *partial frame*: X indices distinct, Z indices distinct, and
`G[i][j'] = [p = p']` for pairs `p = (i, j)`, `p' = (i', j')` of the orbit. Orbits of size 1
(fixed pairs) count. Every frame in the class is a disjoint union of items (the orbit of any of its
pairs lies in it, and a subset of a frame is a partial frame).

**Item sums.** For an item `q`, `M_q = sum_{(i,j) in q} x_i z_j^T`; `M_q[c][k]` is its entry at
row `c`, column `k` (`c, k in 0..127`).

## Instance files (`*.inst`, text)

```
NX NZ NI DIM
dmask_lo dmask_hi                       (hex; all 128 bits set here)
NX lines: lo hi                         x_i, low and high 64 bits in hex (bit c = coordinate c)
NZ lines: lo hi                         z_j
NI lines: k i1 j1 i2 j2 ... ik jk        item q (0-based line number q) = pairs (i1,j1), ...
```

**Your first check:** the instance vectors equal the pool files, and the instance's items are
exactly the items you generate yourself from the pools and the class (as a set of pair-sets; order
and duplicates matter: no duplicates, nothing missing, nothing extra). Report counts.

## Certificate format (`*.cert.gz`, gzip text, one record per line)

Header: `C16CERT 1 need 128 items NI live_sides 1 shard s nshard n shard_depth d`.
Then the search tree in depth-first preorder, then the line `END COMPLETE`.

A **node** is one of:

| Record | Meaning |
|---|---|
| `R` | rank leaf |
| `E c k` | empty leaf at entry `(c, k)` |
| `B c k m` | branch on entry `(c, k)`, followed by exactly `m` child records |
| `F` | a frame was found (must not occur in a no-frame certificate) |

A **child record** is one of `C q` (followed by the child's node), `K q` (item too large, no node),
`S q` (handled in another shard file, no node).

## Checking rules

Each node has a state, computed by your checker, never read from the file:
- `P`: the items chosen on the path from the root; `need = 128 - (number of pairs in P)`;
- `R = I + sum_{q in P} M_q` over `F_2` (the residual);
- `L`: the live items (defined below). At the root `P` is empty, `R = I`, `L` = all items.
- `X'(L)`: the X indices of pairs of items in `L`; `Z'(L)` likewise.

At each node, first: if `need = 0` the chosen pairs form a frame; verify it and report **FRAME**.
Otherwise check, by record type:

1. **`R`**: the rank over `F_2` of the matrix `(G[i][j])` for `i in X'(L)`, `j in Z'(L)` is `< need`.
2. **`E c k`**: `R[c][k] = 1`, and no item `q in L` has `M_q[c][k] = 1`.
3. **`B c k m`**: `R[c][k] = 1`. Let `Cov` = items `q in L` with `M_q[c][k] = 1`. The `m` child
   records name each item of `Cov` exactly once (any order). Process them in the listed order,
   keeping a set `Done`, initially empty; after each child record add its item to `Done`:
   - `K q`: check `|q| > need`.
   - `S q`: nothing here (see shards).
   - `C q`: the child state is `P' = P + {q}`, `need' = need - |q|`, `R' = R + M_q`, and
     `L'` = items `r in L` with `r != q`, `r` not in `Done`, and for every pair `(a, b)` of `r` and
     every pair `(i, j)` of `q`: `a != i`, `b != j`, `G[a][j] = 0`, `G[i][b] = 0`.
     Then check the child node recursively.
4. **`F`** in a certificate claimed to prove "no frame": reject.

After the root's subtree, the next line must be `END COMPLETE`, and the file must end.

**Shards.** A class may be split into several files with the same `nshard` and `shard_depth`.
Check each file by the rules above. Then cross-check: every file reaches the same set of
`B` nodes at depth `shard_depth` (the root has depth 0), with the same child items in the same
order, and each such child is `C` or `K` in exactly one file and `S` in all the others.

### Why acceptance proves "no frame" (you may rely on this, but please re-derive it)

Invariant claimed at each node: *no frame of the class consists of `P` together with items from
`L` only.* At the root this is "no frame in the class".
- `R` leaf: in such a frame the pairs outside `P` have X indices in `X'(L)`, Z indices in `Z'(L)`, and
  pairing matrix the identity of size `need`, so the rank of `G[X'(L), Z'(L)]` is at least `need`.
- `E` and `B`: by the frame identity, the items outside `P` sum to `R`. If `R[c][k] = 1`, one of
  them has `M_q[c][k] = 1`, so it lies in `Cov`. An `E` leaf says `Cov` is empty. At a `B` node, let
  `q` be the **first** listed child whose item lies in the frame. If it is `K`, the frame cannot hold
  `|q| > need` more pairs. If it is `C`, the frame's remaining items avoid the earlier children
  (`Done`, by minimality), are distinct from `q`, and satisfy the disjointness and orthogonality
  conditions (all pairs of a frame are mutually orthogonal and use distinct indices), so they lie in
  `L'` and the child's invariant is contradicted. If it is `S`, another shard covers it.

## Known-answer tests (must pass before the real certificates count)

| Instance | Certificate | Expected |
|---|---|---|
| `test-quarter.inst` (real pools, class `quarter`) | `test-quarter.cert.gz` | ACCEPT (no frame; 15,088 nodes) |
| same | `test-bad-1.cert.gz`, `test-bad-2.cert.gz`, `test-bad-3.cert.gz` | REJECT each (one record altered) |
| `test-planted.inst` (planted pools, class `quarter`) | `test-planted.cert.gz` | reports FRAME; print and verify the frame |

Also make up your own mutations (drop a child, change an entry, swap `R` and `E`, change an item id)
and confirm each is rejected; report which you tried.

## The real checks

| Class | Instance | Certificate files |
|---|---|---|
| `swap` | `swap.inst` | `swap.cert.gz` |
| `half` | `half.inst` | `half-s0of2.cert.gz`, `half-s1of2.cert.gz` |
| `swapT8` | `swapT8.inst` | `swapT8-s{0,1,2,3}of4.cert.gz` |

## Deliverable

New branch; directory `independent-check/<model>-certcheck/` with the checker source, build and run
commands, a README (model and version, method, the item-generation counts, test results, mutation
tests), and one JSON line per run:
`{"class": ..., "files": [...], "result": "ACCEPT|REJECT|FRAME", "nodes": n, "rank_leaves": n,
"empty_leaves": n, "seconds": t, "notes": ...}`.

## Clarifications given during the check (issue #76)

- 2026-11-07: `CERT-SPEC.md` controls; `SPEC.md` is used only for definitions and pools, and its
  exhaustive-search deliverables are not part of this task. `S` records are intended only at the
  declared shard depth. Any sufficient proof that the rank is `< need` (for example an upper bound
  by `min(|X'|, |Z'|, rank of the x vectors, rank of the z vectors)`) satisfies the `R` rule.
