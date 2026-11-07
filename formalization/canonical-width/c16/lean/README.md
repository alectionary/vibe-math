# Swap-class certificate checker

Model and version: Grok 4.7.

This directory contains a Lean 4 checker for the swap-class (class B) no-frame
certificate specified in `../independent-check/LEAN-CERT-SPEC.md` and
`../independent-check/CERT-SPEC.md`. Toolchain `leanprover/lean4:v4.36.0-rc1`,
Mathlib `5f7b4198d22a9c82e1c698a379334fe128095c82`.

`gen_swap_cert.py` checks the SHA-256 values in
`restricted-frames-20261031/certificates/MANIFEST.json` and that `swap.inst`
reproduces `pools/xcoords.txt` and `pools/zcoords.txt`, then writes
`SwapCert.lean` (item table and certificate bytecode as hex strings).

`CertRun.lean` is the checker. It rebuilds the swap orbits of partial frames and
replays the certificate: rank leaves, empty leaves, and branches, with shard
records rejected. `CertItems.lean` and `CertCheckRun.lean` are the
`native_decide` proofs that the orbit table matches and that the checker accepts
`swap.cert.gz`.

`CertSound.lean` proves that the xor-fold parity equals the `F₂` dot product
(so the Boolean pool pairing is `PoolBridge.G`) and that the checker's binary
Gaussian elimination bounds matrix rank. `CertCheck.lean` defines `IsPairFrame`
and proves it yields `C16Frames.IsFrame`, and that a swap-invariant pair set has
equal vertex sets in the sense of `fixed_swap_iff`.

The theorem `no_swap_frame` is not proved. Acceptance of the certificate is a
separate `Bool` fact. The search invariant — that acceptance rules out every
swap-invariant frame — is not finished, so this directory does not yet contain
a kernel proof that the swap class has no frame. There is therefore no
`#print axioms no_swap_frame` output.

`lake build` completed with exit status 0: `Build completed successfully (3800 jobs).`
`#print axioms` on the declarations that do exist:

```
'C16Frames.CertCheck.isPairFrame_isFrame' depends on axioms: [propext, Classical.choice, Quot.sound]
'C16Frames.CertCheck.swap_image_iff_vertex' depends on axioms: [propext, Classical.choice, Quot.sound]
'C16Frames.CertSound.matrixRank_le_geCount' depends on axioms: [propext, Classical.choice, Quot.sound]
'C16Frames.CertSound.G_bool' depends on axioms: [propext, Classical.choice, Quot.sound]
'swap_items_ok' depends on axioms: [propext, Quot.sound, swap_items_ok._native.native_decide.ax_1_1]
'swap_check_ok' depends on axioms: [propext, Classical.choice, Quot.sound, swap_check_ok._native.native_decide.ax_1_1]
```

On this toolchain `native_decide` records one axiom per computation. It does not
use `Lean.ofReduceBool`; `#print axioms` for `Aut.lean` reports the same kind of
axiom.
