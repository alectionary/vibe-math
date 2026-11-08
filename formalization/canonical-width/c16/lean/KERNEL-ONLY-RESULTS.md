# C16 kernel-only partial result

Model: Codex, based on GPT-6. The exact model build/version is not exposed in this session.
Baseline: `36c7dc91ce530d20443ea4dbfa7dd05a81fe3603` (`master`, 2026-11-08).
Branch: `independent/c16-kernel-only-chatgpt-2026-11-08`.
Toolchain: Lean 4.36.0-rc1, commit `c9afcddf514a6772bd4d649f7cfc04eff0b9f15e`, arm64-apple-darwin24.6.0.
Mathlib: `5f7b4198d22a9c82e1c698a379334fe128095c82`.

This is a partial conversion. The two certificate facts and the large graph/code
computations remain native. No theorem statement, existing data, or computational
definition is changed. The only new definitions in the proof files are helper lemmas.
No re-encoding is integrated into the library. A separate prototype is described below. Input SHA-256 values are in `kernel-only/input-sha256.txt`.

## Priority 1: measured blocker

`kernel-only/probe_decoder.py` records ten bounded experiments in
`kernel-only/decoder-probes.json`. The collector's exit 0 means it collected the
results; each record has the actual Lean exit status. A tiny Nat-array instance
passes kernel reduction (exit 0). The corresponding text instance, `String.splitOn`,
`String.toNat?`, and 128-bit-vector text instances of sizes 1, 4, 16 and 64 all exit 1.
Both full target attempts (`swapPoolsOK`, `swapCertificateOK`) also exit 1,
with reduction stuck at `decodeText swapEncoded`.

These failures concern the existing string packaging. Claude clarified on
[issue #84](https://github.com/alectionary/vibe-math/issues/84#issuecomment-6723626321)
that a hashed direct Nat encoding plus kernel pool-equality proofs is sufficient;
there is no requirement to prove a string-to-Nat bridge.

`kernel-only/packed/generate.py` authenticates the manifest, `swap.inst`, and
`swap.cert.gz`, checks the pool text files, and writes a balanced tree of Nat
chunks for all 720+720 vectors, 7,936 item keys and 346,146 tokens. Its header
records the SHA-256 of every input. `PackedData.lean` has kernel-checked proofs
that both decoded vector arrays equal `PoolData`; both depend only on `propext`.
The initial prototype compilation exited 0 for the reader and data/proof module.
A bounded actual-root branch-coverage predicate experiment is in progress.
This prototype is not imported by the C16 library and does not prove full
certificate acceptance. Both original certificate facts retain native proofs
until a shared direct-data backend and its checking proof are integrated.

## Axiom gate

Run after `lake build`:

```sh
python3 axiom_gate.py --self-test
python3 axiom_gate.py --json kernel-only/axioms-after.json
python3 axiom_gate.py --strict
```

The gate first rejects missing/stale build artifacts using `lake --no-build build`.
It enumerates constants by their owning Lean module, including generated/private
constants, executes `#print axioms` for every one, and emits machine-readable
`Lean.collectAxioms` results. It does not discover declarations by grepping names.
The only standard axioms are `propext`, `Classical.choice`, and `Quot.sound`.
Native dependencies are recognized by the pinned toolchain's generated native
axiom naming convention (and the older `Lean.ofReduceBool` name). Default mode
reports these; strict mode rejects them. Both modes reject other custom axioms
and `sorryAx`; errors or incomplete enumeration exit 2.

The isolated self-test deliberately introduces a sorry, a custom axiom and its
transitive user, a native-decided fact, and a clean proof in a temporary Lean file.
It checks default and strict policy decisions separately, and exits 0 only when
all are detected correctly. The probes are never imported into the C16 library.

## Statement preservation

`kernel-only/StatementCheck.lean` freezes all 35 original target types, plus
`no_swap_frame` and `aut_classification`, as 37 `example` declarations taken from
the baseline. The same file is checked against both builds. The paper and all
other cited declaration statements are retained unchanged.

## Validation

Final validation, exact axiom lists, kernel timing table and exit statuses will be
added after both builds complete. This work-in-progress document does not claim
a successful full build.
