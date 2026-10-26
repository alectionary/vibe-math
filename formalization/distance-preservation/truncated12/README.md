# Issue 1: truncated distance through weight eleven

This is the October 25, 2026 study of `RQ-F25-truncated-distance-12`, within
`L-F25-distance-preservation`. The [issue](https://github.com/alectionary/vibe-math/issues/1)
records coordination and the four-hour cap.

**Completed general Lean result:** [ThroughNine.lean](ThroughNine.lean) proves
`dQ >= min(dC,10)` under the stated girth/entry tests and transpose-distance
comparison, using actual source matrices, both entire stabilizer row spans and
Pauli union weight. Its predicate form assumes both classical kernel distances
are at least `D` and proves the union-weight lower bound `min(D,10)`.

The second authorized block has checked the full general reduction in
[TwelveConditional.lean](TwelveConditional.lean), conditional only on the
independent finite weight-ten certificate coverage. Both remaining actual
support constructions are complete: [TenEncoding.lean](TenEncoding.lean)
and [SourceEleven.lean](SourceEleven.lean). The latter includes the constant-label
full-stabilizer branch and the actual colored K2,3 realization.
[ProfileTransport.lean](ProfileTransport.lean) and
[CountCanonical.lean](CountCanonical.lean) discharge arbitrary group placement
and re-normalization. [DistanceMinima.lean](DistanceMinima.lean) checks the actual
classical, transpose and quantum minimum definitions, including infinity.
[CriterionScope.lean](CriterionScope.lean) checks the redundancy of the full-row
RCPC premise under the stronger three-column test.

The remaining work is the weight-ten closed-case replay and its unconditional
assembly in [Coverage10.lean](Coverage10.lean),
[ThroughEleven.lean](ThroughEleven.lean) and
[DistanceTwelve.lean](DistanceTwelve.lean). Those source files are not yet
admitted. The broader source question asking for sufficient conditions for
`dQ=dC` remains distinct.

[RESEARCH-NOTE.txt](RESEARCH-NOTE.txt) gives the mathematical argument;
[CLAIM-AUDIT.txt](CLAIM-AUDIT.txt) traces the source hypotheses, actual objects,
complete quotient and final statement.
[verification.json](verification.json) is authoritative for exact-source build
status and admitted intervals. The first block's manifest is preserved in
[round1-verification.json](round1-verification.json). All 58,752 weight-eleven
and all 144 weight-seven checks pass. The independent standard-library verifier
checks all **183,312** integer pattern certificates; this is separate from Lean
coverage and actual support coverage.

## Reproduce the checks

The toolchain is Lean `v4.36.0-rc1` and Mathlib commit
`5f7b4198d22a9c82e1c698a379334fe128095c82`. The latter is checked by
`build_round.py`. It writes fresh objects to a separate build directory and
records source hashes, logs and axiom reports. It also records/cleans up its own
child PID and accepts memory, thread, timeout and UTC deadline limits.

```sh
python3 verify_catalog.py
python3 replay_round.py --mathlib /path/to/pinned/mathlib4 \
  --lean-bin /path/to/pinned/lean/bin --build-dir /path/to/fresh/objects \
  ThroughNine
python3 verify_round.py --final
```

`replay_round.py` computes and builds the full local import closure in dependency
order; `--plan` prints that order without compiling. With no module arguments it
selects only exact-source modules admitted in the manifest, excluding deferred
weight-ten chunks. Parent-directory modules are unchanged source dependencies.
Mathlib's pinned cache must be available.
The closed catalog checker itself imports only Lean core definitions.

`integer_patterns.py` discovers integer certificates using SymPy 1.14;
`complete_torsion.py` and `complete_classical.py` fill the exceptional types.
`lift_catalog.py` lifts them to full source matching equations, including all
fiber variables. `verify_catalog.py` independently reconstructs the source
patterns and identities without importing discovery code or symbolic algebra.

`pack_catalog_tables.py` produces compact finite lookup tables, whose equality
to explicit tables is checked in `PackedTablesAudit.lean`. The certificate
coefficients are untrusted data: `FastCatalogChecker.lean` checks their full
integer row identities, and `KernelCatalog.checked_fast_equations` proves their
interpretation in every additive group. `emit_kernel_chunks.py --fast` emits
individual closed checks and aggregate axiom audits in `catalog-chunks/`.
Small chunks allow incremental replay on a machine with limited memory.

The expected catalog sizes are 144, 124,416 and 58,752 for weights 7, 10 and 11.
Use `build_round.py` on the generated chunk module names; `verify_round.py`
admits only successful exact-source records. Source generation alone does not
certify a chunk. No `sorry`, native decision oracle or extra axiom is admitted.

## Exploratory evidence and limits

`PROTOCOL.txt` freezes the initial prime-13 diagnostic; later planned primes
were superseded by integer identities. `EXCEPTION-PROTOCOL.txt` records an
adaptive torsion-five exploration stopped in favor of the analytic classical
word. `torsion5-positive.json` is a nonqualifying search lead, **not** a
counterexample. The independently rebuilt `boundary-L10.json` example has
`dC=6`, `dTranspose=10` and a nontrivial quantum word of weight ten.

Intermediate integer catalogs preserve unsuccessful classifications as well as
the final completed certificates. Earlier frozen repository campaigns and
manifests have not been rewritten. The literature/source ledger records primary
comparisons, newly harvested questions, held formulations and the native X
access gap. No canonical source completion is credited to this block.

Unchecked weight-ten chunk sources and their all-import wrapper are generated
locally and omitted from version control. The encoded certificates, generator
and exact source-hash plan are preserved; regenerate them with
`python3 emit_kernel_chunks.py --fast`. Admitted weight-ten chunks are tracked
explicitly. The verifier reports absent unperformed chunks as pending.
