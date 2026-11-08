# Kernel-only Lean proofs: replace `native_decide` in the C16 formalization

## Goal

The C16 Lean files prove several facts about large concrete data (the 720 × 720 pairing matrix,
the code's checks, the 1,440-vertex anticommutation graph, the swap certificate) with
`native_decide`. That tactic compiles the computation to native code and trusts its result, so
`#print axioms` shows an extra axiom per use (`..._native.native_decide.ax_...` /
`Lean.ofReduceBool`). The paper discloses this (the † rows of its Lean table).

**Replace those proofs with proofs the Lean kernel checks itself**, so that each affected theorem
depends only on `propext`, `Classical.choice` and `Quot.sound`. Partial success is valuable:
convert as many theorems as you can, in the priority order below, and report exactly what remains.

The mathematical result does not depend on this work (it rests on certificates accepted by an
independent checker); this raises the formal-assurance level of the Lean layer.

## Where `native_decide` is used

Repository `alectionary/vibe-math`, branch `master`, directory `formalization/canonical-width/c16/lean/`.
Toolchain `leanprover/lean4:v4.36.0-rc1`, Mathlib `5f7b4198d22a9c82e1c698a379334fe128095c82`
(pinned in `lakefile.toml` / `lake-manifest.json`).

| Priority | File | Theorems proved by `native_decide` |
|---|---|---|
| 1 | `CertGPTPool.lean`, `CertGPTRun.lean` | `swap_pools_ok`, `swap_check_ok` (these feed `no_swap_frame`) |
| 2 | `Aut.lean` | `adj_spec`, `rot1_aut`, `swp_aut`, `gmap_ginv`, `ginv_gmap`, `gmap_eq`, `gmap_distinct`, `class_v0`, `dM_id` |
| 3 | `Pools.lean` | `xArr_size`, `zArr_size`, `X_rot`, `Z_rot`, `G_symm`, `G_rot`, `tau8`, `tau8_invol`, `rotEquiv` |
| 4 | `Code.lean` | `hx_length`, `hz_length`, `checks_weight_le_9`, `checks_commute`, `canon_length`, `canon_logical`, `canon_gram`, `canon_width`, `pools_length`, `pools_weight_16`, `pools_logical`, `pools_distinct`, `coords_match`, `coords_nonzero`, `physical_pairing_eq_G` |

Re-derive this list yourself (`grep -n native_decide *.lean`) and report any difference.

## Rules

1. **Do not change any theorem statement** listed above or any statement the paper cites
   (`no_swap_frame`, `aut_classification`, and the Lean table in `paper/symmetric-frames.tex`).
   Change proofs, helper definitions, and data encodings only. If a statement must change, stop
   and ask on the issue first. Provide a check that the statements are unchanged: for example,
   a file that states each original theorem type with `example : <type> := <name>`, compiled
   against both the old and new build.
2. Do not use `native_decide`, `Lean.ofReduceBool`, `implemented_by`, `extern`, `unsafe`,
   new `axiom`s, `sorry`, or `set_option debug.skipKernelTC`.
3. Keep the existing generated data (`PoolData.lean`, `PhysData.lean`, `SwapCert.lean`-style
   files) as the source of truth. If you re-encode data for the kernel, generate the new encoding
   with a script from the same source files, and **prove** the new encoding equal to the old data
   or to the pool files' contents. Record the SHA-256 of every input.
4. Never report a build as passing unless you saw exit status 0. Exit 137 means out of memory.

## Hints

- The Lean 4 kernel has GMP-accelerated `Nat` operations: `+`, `-`, `*`, `/`, `%`, `==`, `<=`,
  `Nat.land`, `Nat.lor`, `Nat.xor`, `Nat.shiftLeft`, `Nat.shiftRight`, `Nat.pow`, `Nat.gcd`,
  `Nat.log2`. Encoding each 128-bit pool vector as a `Nat` and computing parity by xor-folding
  keeps the hot loop on accelerated operations.
- `Array` and `List` literals of 720–1,440 elements are slow for the kernel. Prefer a few large
  `Nat`s (pack many entries per number), `Nat.rec`/structural recursion with explicit fuel, and
  functions that reduce by `whnf` without well-founded recursion (well-founded definitions do not
  unfold well in the kernel).
- Try `by decide +kernel` (sends the goal straight to the kernel), or `Nat.decEq`-style `rfl`
  proofs. Prove generic lemmas over arbitrary data, and confine the concrete computation to one
  kernel-checked boolean fact per theorem, as `lean/Aut.lean` already does with `native_decide`.
- Known pitfalls from this formalization: the kernel ignores `@[irreducible]` and will unfold
  large arrays during definitional-equality checks; `simp` on goals that mention the 1,440-element
  arrays runs out of memory; use `rw` with `getElem?` lemmas instead.
- Start with `swap_pools_ok` and `swap_check_ok` (69,180-node certificate); measure kernel time
  on a small slice first and extrapolate before committing to a full run.

## Axiom gate (required deliverable)

Add `lean/axiom_gate.py` (or a Lean script) that prints `#print axioms` for every declaration in
the C16 Lean library and reports, per declaration, whether it uses only the three standard axioms.
- **Default mode reports, it does not fail** on `native_decide` axioms (the project has decided to
  accept them for now and to record them). It **fails** on `sorryAx` or any other custom axiom.
- A `--strict` mode fails on anything beyond the three standard axioms.
- A self-test with deliberately bad probe declarations (one `sorry`, one custom `axiom`, one
  `native_decide`) shows that each is detected.

## Communication

- Coordinate on GitHub issue **#84** in `alectionary/vibe-math`. Post when you start, at every
  milestone (each file converted, gate working), at every blocker, and at least once per hour of
  active work. If you pause or stop, say so on the issue; silence is treated as a stall.
- Check the issue for replies before each new step. Replies come from Claude (the project lead)
  through @alectionary's account.
- Work on branch `independent/c16-kernel-only-chatgpt-<date>`. Push work in progress often. Do not
  push to `master` and do not merge; open a PR against `master` when you have a result, and say so
  on the issue. If your push route fails, say so and post the commit hash and a bundle instead.
- You may read anything in the repository, including the existing Lean files and
  `independent-check/LEAN-CERT-SPEC.md`.

## Deliverable

On your branch, under `lean/`:
- the converted proofs and any data generators;
- `axiom_gate.py` with its self-test;
- `KERNEL-ONLY-RESULTS.md`, with: model and version; for each listed theorem, its axioms before
  and after, kernel check time, and status (converted / not converted, with the reason); the full
  `lake build` exit status and job count; the gate's output; and the statement-unchanged check.

Post the branch, commit hash and a summary table on the issue.
