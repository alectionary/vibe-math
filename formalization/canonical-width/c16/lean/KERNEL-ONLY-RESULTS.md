# C16 kernel-only partial result

Model: Codex, based on GPT-6. The exact model build/version is not exposed in this session.
Baseline: `36c7dc91ce530d20443ea4dbfa7dd05a81fe3603` (`master`, 2026-11-08).
Branch: `independent/c16-kernel-only-chatgpt-2026-11-08`.
Toolchain: Lean 4.36.0-rc1, commit `c9afcddf514a6772bd4d649f7cfc04eff0b9f15e`, arm64-apple-darwin24.6.0.
Mathlib: `5f7b4198d22a9c82e1c698a379334fe128095c82`.

This is a partial conversion. The two certificate facts and the large graph/code
computations remain native. No theorem statement, existing data, or computational
definition is changed. The three converted library modules add only helper lemmas.
No re-encoding is integrated into the library. A separate prototype is described below. Input SHA-256 values are in `kernel-only/input-sha256.txt`.

The re-derived inventory matches all **35** names in the spec. There were **37**
active tactic calls: `rotEquiv` and `tau8` each had two. Source comments are not
counted. There are now **21** active calls. Exact original/current source locations
are recorded in `kernel-only/native-inventory.json`; no target-name differences
were found.

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

`kernel-only/packed/generate.py` authenticates `swap.inst` and `swap.cert.gz`
against the manifest, checks the pool text files, and writes a balanced tree of Nat
chunks for all 720+720 vectors, 7,936 item keys and 346,146 tokens. Its header
records the SHA-256 of every input. `PackedData.lean` has kernel-checked proofs
that both decoded vector arrays equal `PoolData`; both depend only on `propext`.
The initial prototype compilation exited 0 for the reader and data/proof module.
The repeated prototype check compiled `PackedCore` with exit **0** in 2.330 s
and `PackedData` (data plus both pool-equality proofs) with exit **0** in 6.884 s.
These are whole-module wall times, not isolated per-proof kernel timings.

`RootProbe.lean` checks the actual certificate root's branch-coverage predicate
(entry `(112,112)`, all 45 original root child keys) with the original
`concreteRules`, the full packed instance, and the initial 7,936-item live set.
With `lean -j 1 -M 2048`, that kernel experiment **timed out at 90 seconds**
(observed wall 90.427 s). No Lean exit status was obtained for the killed probe;
the collector exited **1**. This includes data construction and the coverage
predicate; it is not a per-node throughput estimate and does not justify a
whole-certificate runtime extrapolation. Full results are in
`kernel-only/packed/validation.json`.
This prototype is not imported by the C16 library and does not prove full
certificate acceptance. Both original certificate facts retain native proofs
until a shared direct-data backend and its checking proof are integrated.

Reproduce the independent prototype after `lake build`:

```sh
python3 kernel-only/packed/generate.py
lake env python3 kernel-only/packed/check.py
```

The second command deliberately returns 1 if the bounded root check times out;
read its per-module records rather than treating the collector as a passing proof.
The balanced reader uses structural recursion, fixed-width Nat shifts/moduli,
and cached subtree sizes. It avoids large flat Array literals in the generated
encoding; the original checker still constructs arrays when it consumes the data.

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

## Converted and remaining targets

**14/35 targets converted, removing 16/37 original `native_decide` calls.**
The remaining 21 targets retain their original native proofs. The non-decoder
rows below marked "not implemented" were retained in this partial result after
the priority-1 reduction blocker and the algebraic conversions; they are not
claims of failed full kernel experiments. Further work needs mathematical
lemmas or a scalable kernel representation with a proved connection to the data.

P = `propext`, C = `Classical.choice`, Q = `Quot.sound`. All other axiom names
are written in full. Exact nanosecond measurements and axiom lists, including
auxiliary declarations, are in `kernel-only/timings-before.json` and
`kernel-only/timings-after.json`. The complete library-wide audits are in
`kernel-only/axioms-before.json` and `kernel-only/axioms-after.json`.

Kernel times below recheck the actual stored proof/definition bodies with
`Lean.Kernel.Environment.addDeclCore` under fresh names. They exclude imports,
tactics and previously checked imported dependencies, but include generated
auxiliary proofs of each target and the two newly introduced private helper
lemmas where applicable. These are kernel checking times, not the time to run
native computations. In particular a fast recheck of a native proof still
trusts its recorded native axiom. The full build is the fresh-source validation.

| Priority | Target | Axioms before | Axioms after | Kernel ms before / after | Status / reason |
| --- | --- | --- | --- | --- | --- |
| 1 | `C16Frames.CertGPT.swap_pools_ok` | P, C, Q, `C16Frames.CertGPT.swap_pools_ok._native.native_decide.ax_1_1` | P, C, Q, `C16Frames.CertGPT.swap_pools_ok._native.native_decide.ax_1_1` | 3.0737 / 0.1880 | not converted: prototype pool equality proved; shared Nat backend not integrated |
| 1 | `C16Frames.CertGPT.swap_check_ok` | P, C, Q, `C16Frames.CertGPT.swap_check_ok._native.native_decide.ax_1_1` | P, C, Q, `C16Frames.CertGPT.swap_check_ok._native.native_decide.ax_1_1` | 0.0445 / 0.0863 | not converted: Nat root-coverage probe timed out at 90 s; full check unproved |
| 2 | `C16Frames.Aut.adj_spec` | P, C, Q, `C16Frames.Aut.adj_spec._native.native_decide.ax_1_1` | P, C, Q, `C16Frames.Aut.adj_spec._native.native_decide.ax_1_1` | 7.5072 / 2.4157 | not converted: graph/pairing computation; kernel data bridge not implemented |
| 2 | `C16Frames.Aut.rot1_aut` | P, C, Q, `C16Frames.Aut.rot1_aut._native.native_decide.ax_1_1` | P, C, Q, `C16Frames.Aut.rot1_aut._native.native_decide.ax_1_1` | 0.1032 / 0.1256 | not converted: graph/pairing computation; kernel data bridge not implemented |
| 2 | `C16Frames.Aut.swp_aut` | P, C, Q, `C16Frames.Aut.swp_aut._native.native_decide.ax_1_1` | P, C, Q, `C16Frames.Aut.swp_aut._native.native_decide.ax_1_1` | 0.0761 / 0.0972 | not converted: graph/pairing computation; kernel data bridge not implemented |
| 2 | `C16Frames.Aut.gmap_ginv` | P, C, Q, `C16Frames.Aut.gmap_ginv._native.native_decide.ax_1_1` | P, C, Q | 0.5577 / 142.8455 | converted |
| 2 | `C16Frames.Aut.ginv_gmap` | P, C, Q, `C16Frames.Aut.ginv_gmap._native.native_decide.ax_1_1` | P, C, Q | 0.0925 / 134.6470 | converted |
| 2 | `C16Frames.Aut.gmap_eq` | P, C, Q, `C16Frames.Aut.gmap_eq._native.native_decide.ax_1_1` | P, C, Q | 0.3917 / 46.7154 | converted |
| 2 | `C16Frames.Aut.gmap_distinct` | P, C, Q, `C16Frames.Aut.gmap_distinct._native.native_decide.ax_1_1` | P, C, Q | 1.3315 / 100.5760 | converted |
| 2 | `C16Frames.Aut.class_v0` | P, C, Q, `C16Frames.Aut.class_v0._native.native_decide.ax_1_1` | P, C, Q, `C16Frames.Aut.class_v0._native.native_decide.ax_1_1` | 1.4620 / 1.1602 | not converted: concrete colour-refinement computation; scalable kernel proof not implemented |
| 2 | `C16Frames.Aut.dM_id` | P, C, Q, `C16Frames.Aut.dM_id._native.native_decide.ax_1_1` | P, C, Q, `C16Frames.Aut.dM_id._native.native_decide.ax_1_1` | 0.0555 / 0.0709 | not converted: concrete colour-refinement computation; scalable kernel proof not implemented |
| 3 | `C16Frames.PoolBridge.xArr_size` | `C16Frames.PoolBridge.xArr_size._native.native_decide.ax_1_1` | none | 0.3076 / 20.6698 | converted |
| 3 | `C16Frames.PoolBridge.zArr_size` | `C16Frames.PoolBridge.zArr_size._native.native_decide.ax_1_1` | none | 0.0372 / 14.2406 | converted |
| 3 | `C16Frames.PoolBridge.X_rot` | P, C, Q, `C16Frames.PoolBridge.X_rot._native.native_decide.ax_1_1` | P, C, Q, `C16Frames.PoolBridge.X_rot._native.native_decide.ax_1_1` | 0.1096 / 0.1254 | not converted: concrete orbit bit checks; scalable kernel proof not implemented |
| 3 | `C16Frames.PoolBridge.Z_rot` | P, C, Q, `C16Frames.PoolBridge.Z_rot._native.native_decide.ax_1_1` | P, C, Q, `C16Frames.PoolBridge.Z_rot._native.native_decide.ax_1_1` | 0.0938 / 0.0986 | not converted: concrete orbit bit checks; scalable kernel proof not implemented |
| 3 | `C16Frames.PoolBridge.G_symm` | P, C, Q, `C16Frames.PoolBridge.G_symm._native.native_decide.ax_1_1` | P, C, Q, `C16Frames.PoolBridge.G_symm._native.native_decide.ax_1_1` | 0.0786 / 0.0846 | not converted: 720×720 dot-product checks; kernel proof not implemented |
| 3 | `C16Frames.PoolBridge.G_rot` | P, C, Q, `C16Frames.PoolBridge.G_rot._native.native_decide.ax_1_1` | P, C, Q, `C16Frames.PoolBridge.G_rot._native.native_decide.ax_1_1` | 0.0766 / 0.0896 | not converted: 720×720 dot-product checks; kernel proof not implemented |
| 3 | `C16Frames.PoolBridge.tau8` | P, Q, `C16Frames.PoolBridge.tau8._native.native_decide.ax_1` | P, Q | 0.4202 / 22.0374 | converted |
| 3 | `C16Frames.PoolBridge.tau8_invol` | P, Q, `C16Frames.PoolBridge.tau8._native.native_decide.ax_1`, `C16Frames.PoolBridge.tau8_invol._native.native_decide.ax_1_1` | P, Q | 0.3837 / 1.0524 | converted |
| 3 | `C16Frames.PoolBridge.rotEquiv` | P, Q, `C16Frames.PoolBridge.rotEquiv._native.native_decide.ax_1`, `C16Frames.PoolBridge.rotEquiv._native.native_decide.ax_2` | P, Q | 0.1309 / 41.1291 | converted |
| 4 | `C16Frames.Code.hx_length` | P, Q, `C16Frames.Code.hx_length._native.native_decide.ax_1_1` | P, Q | 0.0338 / 2.1038 | converted |
| 4 | `C16Frames.Code.hz_length` | P, Q, `C16Frames.Code.hz_length._native.native_decide.ax_1_1` | P, Q | 0.0297 / 1.3365 | converted |
| 4 | `C16Frames.Code.checks_weight_le_9` | P, Q, `C16Frames.Code.checks_weight_le_9._native.native_decide.ax_1_1` | P, Q, `C16Frames.Code.checks_weight_le_9._native.native_decide.ax_1_1` | 0.0740 / 0.0664 | not converted: physical-vector computation; scalable kernel proof not implemented |
| 4 | `C16Frames.Code.checks_commute` | P, Q, `C16Frames.Code.checks_commute._native.native_decide.ax_1_1` | P, Q, `C16Frames.Code.checks_commute._native.native_decide.ax_1_1` | 0.0321 / 0.0367 | not converted: physical-vector computation; scalable kernel proof not implemented |
| 4 | `C16Frames.Code.canon_length` | P, `C16Frames.Code.canon_length._native.native_decide.ax_1_1` | P, Q | 0.0428 / 1.1994 | converted |
| 4 | `C16Frames.Code.canon_logical` | P, Q, `C16Frames.Code.canon_logical._native.native_decide.ax_1_1` | P, Q, `C16Frames.Code.canon_logical._native.native_decide.ax_1_1` | 0.0323 / 0.0462 | not converted: physical-vector computation; scalable kernel proof not implemented |
| 4 | `C16Frames.Code.canon_gram` | P, C, Q, `C16Frames.Code.canon_gram._native.native_decide.ax_1_1` | P, C, Q, `C16Frames.Code.canon_gram._native.native_decide.ax_1_1` | 0.8541 / 0.1659 | not converted: physical-vector computation; scalable kernel proof not implemented |
| 4 | `C16Frames.Code.canon_width` | P, `C16Frames.Code.canon_width._native.native_decide.ax_1_1` | P, `C16Frames.Code.canon_width._native.native_decide.ax_1_1` | 0.0897 / 0.0969 | not converted: physical-vector computation; scalable kernel proof not implemented |
| 4 | `C16Frames.Code.pools_length` | P, `C16Frames.Code.pools_length._native.native_decide.ax_1_1` | P, Q | 0.0388 / 1.4871 | converted |
| 4 | `C16Frames.Code.pools_weight_16` | P, `C16Frames.Code.pools_weight_16._native.native_decide.ax_1_1` | P, `C16Frames.Code.pools_weight_16._native.native_decide.ax_1_1` | 0.0413 / 0.0493 | not converted: physical-vector computation; scalable kernel proof not implemented |
| 4 | `C16Frames.Code.pools_logical` | P, Q, `C16Frames.Code.pools_logical._native.native_decide.ax_1_1` | P, Q, `C16Frames.Code.pools_logical._native.native_decide.ax_1_1` | 0.0450 / 0.2193 | not converted: physical-vector computation; scalable kernel proof not implemented |
| 4 | `C16Frames.Code.pools_distinct` | P, `C16Frames.Code.pools_distinct._native.native_decide.ax_1_1` | P, `C16Frames.Code.pools_distinct._native.native_decide.ax_1_1` | 0.1724 / 0.0333 | not converted: physical-vector computation; scalable kernel proof not implemented |
| 4 | `C16Frames.Code.coords_match` | P, `C16Frames.Code.coords_match._native.native_decide.ax_1_1` | P, `C16Frames.Code.coords_match._native.native_decide.ax_1_1` | 0.2520 / 0.0611 | not converted: physical-vector computation; scalable kernel proof not implemented |
| 4 | `C16Frames.Code.coords_nonzero` | P, `C16Frames.Code.coords_nonzero._native.native_decide.ax_1_1` | P, Q | 0.0779 / 182.6833 | converted |
| 4 | `C16Frames.Code.physical_pairing_eq_G` | P, C, Q, `C16Frames.Code.physical_pairing_eq_G._native.native_decide.ax_1_1` | P, C, Q, `C16Frames.Code.physical_pairing_eq_G._native.native_decide.ax_1_1` | 0.3002 / 1.2399 | not converted: physical-vector computation; scalable kernel proof not implemented |

## Validation and gate output

The unchanged baseline full `lake build` exited **0**, with **3,833 jobs**.
`kernel-only/build-before.log` and `build-before.json` record it. The changed
full `lake build` exited **0**, with **3833 jobs**, in 331.881 wall seconds,
with `LEAN_NUM_THREADS=2`. This controls Lean threads, not Lake's total target
count. Its complete output is `kernel-only/build-after.log`; metadata is in
`build-after.json`. All these exit codes were observed directly.

- `lake env lean kernel-only/StatementCheck.lean`: exit **0**, 52.691 wall seconds.
- `lake env lean kernel-only/KernelTimings.lean`: exit **0**, 80.477 wall seconds.
- `python3 axiom_gate.py --json kernel-only/axioms-after.json`: exit **0**, 117.635 wall seconds.
- `python3 axiom_gate.py --strict`: exit **1**, 42.911 wall seconds.
- `python3 kernel-only/check_statement_sources.py`: exit **0**, 0.478 wall seconds.
- `shasum -a 256 -c lean/kernel-only/input-sha256.txt`: exit **0**, 0.045 wall seconds.

The strict exit 1 is expected: native dependencies remain. The default gate
passes because there are no forbidden axioms. Full default output is in
`kernel-only/axiom-gate-after.log`; strict output's summary is in
`kernel-only/axiom-gate-strict-summary.txt`. The exact final summaries are:

```text
AXIOM GATE DEFAULT PASS declarations=799 KERNEL=718 NATIVE=81 FORBIDDEN=0 (baseline)
AXIOM GATE DEFAULT PASS declarations=814 KERNEL=767 NATIVE=47 FORBIDDEN=0
AXIOM GATE STRICT FAIL declarations=814 KERNEL=767 NATIVE=47 FORBIDDEN=0
SELF-TEST PASS: sorry, custom axiom, native evaluation, and clean proof detected
```

The expanded self-test exited **0** and covers both native axiom suffix forms
(`ax_1_1` and a structure-field `ax_1`), plus a custom axiom, its transitive user,
`sorryAx`, and a clean theorem. Its full output is
`kernel-only/axiom-gate-self-test.log`.

The same 37 frozen type examples passed against both builds (exit **0** each).
`check_statement_sources.py` also exits **0**: all **291** original named
signatures and the paper are unchanged. All original Lean files
outside `Aut.lean`, `Pools.lean`, and `Code.lean` are byte-for-byte unchanged.
Only proof fields of `rotEquiv` and `tau8` change; their computational maps stay
identical. All six recorded input hashes match.

Earlier unsuccessful experiments are not counted as successful builds:
`validation-notes.json` records a stopped duplicate native run (Lean exit -15),
a stopped inefficient timing collector (exit 143), an expected stale-build gate
rejection (gate exit 2, Lake freshness exit 3), and the initial gate classifier
failure (exit 1). The classifier missed native `ax_1`/`ax_2` suffixes; the fix is
covered by the expanded self-test and the successful whole-baseline rerun.
The decoder experiment collector's exit 0 is separate from the nine individual
Lean exit-1 proof attempts in `decoder-probes.json`.

The initial full changed build exited **1** because a scoped option interrupted a
doc comment; the option was moved before the comment. Its full output and exact
exit status are preserved in `build-after-initial-failed.log` / `.json`. The corrected
full build exited **0**, as recorded above.

The required partial result is submitted for review; the 21 remaining targets,
including both certificate facts, still require further kernel-proof work.
