# Adversarial code review: the C16 symmetric-frame searches

This is a brief for an independent reviewer (a different model from the one that wrote the
code). Your job is to **find a bug that could make a search miss a frame**. A clean bill of
health is a valid outcome, but only after you have tried hard to break the code.

Read `SPEC.md` in this directory first: it defines pools, the pairing matrix `G`, frames, `tau_k`
and the classes A (half-turn, `T^8`), B (swap, `s`) and C (swap with half-turn, `sT^8`). This
review covers code that you were **not** allowed to read for the clean-room check; you may now read
it.

Repository `alectionary/vibe-math`, branch `research/c16-structural-20261027T173245`, directory
`formalization/canonical-width/c16/restricted-frames-20261031/` (paths below are relative to it).

## Claims under review

The search programs report **no frame** in classes A, B and C. The claims rest on these programs:

| Class | Instance generator | Search | Recorded result |
|---|---|---|---|
| A (`T^8`) | `la/gen_instance.py order 2` | `la/la_dfs.c` (`-S 2 -s i`, and again with `-l -f`) | COMPLETE, 0 frames, 9,995,481 nodes (810,784 with `-l -f`) |
| B (`s`) | `la/gen_items.py swap` | `la/la_gen.c -l` | COMPLETE, 0 frames, 69,180 nodes |
| C (`sT^8`) | `la/gen_items.py swapT8` | `la/la_gen.c -l -S 2 -s i -D 1` | COMPLETE, 0 frames, 50,401,313 nodes |

Supporting material: `../RESTRICTED-FRAMES-20261031.md` (Follow-ups E and F) and the paper
`../paper/symmetric-frames.tex`, sections "Method" and "The symmetry group". The written proofs of
the branching, rank-pruning and look-ahead lemmas are formalised in Lean in `../lean/C16Frames.lean`,
so focus on whether **the code implements them**, not on whether the lemmas are true.

## Files to review (about 900 lines)

- `la/la_gen.c` (259 lines): the general search, used for B and C.
- `la/la_dfs.c` (287 lines): the search used for A.
- `la/gen_items.py`, `la/gen_instance.py` (81 lines each): build the item lists the searches branch over.
- `la/verify_frame.py`, `satcheck/check_model.py`: frame checkers (only matter for positive results).
- `explore/gram_wl.py` (26 lines): the colour-refinement argument that the symmetry group has order 32.

## What must hold (check each; report which you checked and how)

**Instance generation (most likely place for a silent loss).**
1. *Item completeness.* For class B, every `s`-fixed frame is a disjoint union of items in the
   generated list: 1-pair items `(i,i)` with `G[i][i]=1`, and 2-pair items `{(i,j),(j,i)}`, `i≠j`.
   For C the analogue with `(i,j) ↔ (tau_8 j, tau_8 i)`. For A, `T^8`-orbit items. Check that no
   admissible item is filtered out (for example by the "partial frame" test inside an item), and
   that orbit enumeration covers every orbit exactly once, including orbits of size 1.
2. *Index conventions.* `tau_8`, `16a+t` indexing, hex parsing and bit order agree with `SPEC.md`
   and with `pools/xcoords.txt`, `pools/zcoords.txt`. Check `lo/hi` 64-bit halves are not swapped.
3. *Coordinate space.* `dmask` (the coordinates the residual is taken over) is all 128 coordinates
   for the real runs.

**Search (each pruning rule must only remove subtrees with no frame).**
4. *Branching.* The branch entry `(c,k)` has `R[c][k]=1`, and the children are **all** live items
   whose outer-product sum has a 1 at `(c,k)`. Earlier siblings are excluded from later subtrees
   only after their subtree has been fully explored (or the run stops with "found").
5. *Availability.* When an item is chosen, items sharing an X or Z vector with it, and items whose
   vectors are not orthogonal to the chosen opposite-side vectors, are removed — and nothing else.
   For `la_gen`, availability is per pool vector: check the bookkeeping is restored on backtrack.
6. *Residual update.* `R ← R − Σ x zᵀ` over F2 is computed correctly for every pair of the item.
7. *Rank pruning.* `need = 128 − |chosen pairs|` and the test compares against the right spaces
   (`X'` orthogonal to all chosen Z, `Z'` orthogonal to all chosen X, restricted to live items when
   `-l` is set). An off-by-one in `need`, or using all pool vectors where only live ones are
   allowed (or the reverse), can over-prune.
8. *Look-ahead (`-f`, `-F`).* The per-group test matches the lemma (`rank(X' ∩ b^⊥) ≥ need − g` and
   symmetric), with `g` the item size.
9. *Sharding.* `-S n -s i -D d`: the union of shards `0..n−1` is exactly the unsharded tree, with
   no child skipped. The recorded C run used `-S 2 -D 1`.
10. *Termination and reporting.* A time-out, a fixed array bound (`MAXK`, `nodes[300]`,
    `chosen[300]`), an overflow or an early `return` cannot be reported as COMPLETE.
11. *`-l` live sides.* Restricting `X'`, `Z'` to vectors of live items is sound: a completion only
    uses vectors of live items.

**Symmetry group.**
12. `explore/gram_wl.py`: refinement is run on the right graph, individualises one vertex, and
    "discrete" is checked correctly; the bound `|group| ≤ 32` follows.

## How to test (encouraged)

- Build: `cc -O3 -march=native -o la/la_gen la/la_gen.c`, same for `la_dfs`.
- Known answers to reproduce: T^4 instance (`gen_instance.py order 4` or `gen_items.py order 4`)
  gives no frame in 15,088 nodes; the quarter `{0,1}` instance (`gen_instance.py support 0,1 OUT`) has
  frames; planted pools (`gen_items.py --plant 1 swap`) contain a frame.
- Mutation tests: introduce a deliberate bug (e.g. drop one admissible item, change `need` by one)
  and check whether any known-answer test catches it. Report which mutations are **not** caught;
  those are the weak spots of the validation.
- Small brute-force oracles: build tiny random instances (dimension 4–8) and compare `la_gen`'s
  frame count (without `-1`) against exhaustive enumeration.
- You may rerun the B search (34 s) in full.

## Deliverable

Put everything under `independent-check/<model>-review/` (for example `codex-gpt6-review/`) on a
new branch, with:
- `REVIEW.md`: for each of points 1–12, **verdict** (OK / BUG / CONCERN / NOT CHECKED), the evidence,
  and file:line references. Then a list of bugs ordered by severity, each with a concrete input that
  triggers it, and whether it could hide a frame in a recorded run.
- Any test scripts and their logs.
- Model name and version, and the commit you reviewed.

Do not modify the reviewed files. If you find a bug that could hide a frame, say so in the first
line of `REVIEW.md`.
