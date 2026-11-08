# Lean certificate checker: brief for Agent B

Goal: a **Lean 4 theorem** that the swap class (class B) has no frame, obtained by running a
certificate checker whose soundness is proved in Lean. Then, if time allows, the same for the
half-turn class (A) and the swap-half-turn class (C).

The certificate format, checking rules and the soundness argument are in `CERT-SPEC.md` (same
directory); read it first. Unlike Agent A you may read anything in the repository, including
`restricted-frames-20261031/certificates/check_cert_ref.py` (a 130-line Python reference checker),
because the trust here comes from the Lean kernel, not from independence of authorship.

## Target statement

In `lean/CertCheck.lean` (add it to `roots` in `lean/lakefile.toml`), something equivalent to

```lean
theorem no_swap_frame :
    ¬ ∃ F : Finset (Fin 720 × Fin 720),
      IsPairFrame G F ∧ F.card = 128 ∧ F.image Prod.swap = F
```

where `G i j = parity (xArr[i] &&& zArr[j])` from `lean/PoolData.lean` (already generated, with
SHA-256 of the pool files in its header), and `IsPairFrame` says X indices distinct, Z indices
distinct and `G i j' = true ↔ (i, j) = (i', j')` for pairs in `F`. Relate it to the existing
`C16Frames.IsFrame` (`lean/C16Frames.lean`, `(S, T)` form) and the class conditions
`fixed_swap_iff`, `fixed_half_iff`, `fixed_swapHalf_iff`, so the result plugs into the paper's
statement.

## Suggested architecture

1. **Generic soundness, no data.** Over an arbitrary `N`, vectors `x z : Fin N → (Fin 128 → ZMod 2)`
   (or `BitVec 128`), an item list, and a certificate as an inductive tree
   (`R | E c k | B c k (children : List (Child))`, `Child = C q t | K q | S q`), define
   `check : State → Tree → Bool` exactly as in `CERT-SPEC.md` and prove
   `check s t = true → ¬ ∃ frame ⊇ s.P with the rest from s.live`. Ingredients already proved in
   `lean/C16Frames.lean`: `gram_one_iff_sum_outer` (frame identity), `exists_pair_of_residual_entry`,
   `first_member_unique` (minimal-index child), `induced_matching_le_rank` (rank leaves). Also prove
   that every class-invariant frame is a disjoint union of items when items are the orbits of
   partial-frame pairs — or check the item list against a Lean-defined orbit generator.
2. **Data.** Generate `lean/SwapCert.lean` from `swap.inst` and `swap.cert.gz` with a Python
   script (like `lean/gen_pool_data.py`). The swap certificate has 69,180 nodes (24,864
   branch, 12,308 rank leaves, 32,008 empty leaves; 69,179 `C` child records) and 7,936 items.
3. **Evaluation.** `native_decide` on `check root swapTree = true`. Axioms then are the standard
   three plus `Lean.ofReduceBool` (as in `lean/Aut.lean`; that is acceptable). Only class B is
   required; A has about 11 million nodes and C about 48 million, which may be out of reach.

## Pitfalls we hit in `lean/Aut.lean` (Lean v4.36.0-rc1, Mathlib `5f7b4198`)

- `native_decide` here runs in the IR **interpreter** for definitions in the same file: slow. Mark
  heavy helpers `@[noinline]`, avoid recomputation, and keep the hot loop on `UInt64`/`Nat`
  bit operations (popcount by xor-fold) rather than `Finset` or `Matrix`.
- The **kernel ignores `@[irreducible]`** and will evaluate big arrays during defeq checks; never
  let a goal mention a concrete large array except inside the single `native_decide` call. State
  generic lemmas over arbitrary data and instantiate at the end.
- `simp` on goals containing the 1,440-element pool arrays unfolds them and runs out of memory; use
  `rw` with `getElem?` lemmas instead.
- A large literal tree as one Lean term may be slow to elaborate; consider storing the certificate
  as a flat `Array Nat` (preorder token stream) and a checker that consumes it with a cursor, with
  soundness proved for the stream form (fuel = stream length).
- Machine: memory is limited; check exit codes (exit 137 = out of memory; do not report that as a
  successful build).

## Deliverable

New branch from `research/c16-structural-20261027T173245`; `lean/CertCheck.lean`, the generator
script, generated data file(s) (or a script that regenerates them with SHA-256 checks), a
`lake build` log showing 0 errors and no `sorry`, the output of `#print axioms no_swap_frame`, and
an entry in `lean/verification.json`. README note naming the model and version.
