# Issue 1: truncated distance through weight eleven

This is the October 25, 2026 study of `RQ-F25-truncated-distance-12`, within
`L-F25-distance-preservation`. The [issue](https://github.com/alectionary/vibe-math/issues/1)
records coordination and the four-hour cap.

[RESEARCH-NOTE.txt](RESEARCH-NOTE.txt) gives a certificate-assisted written
argument for `dQ >= min(dC,12)` under the exact stated entry tests. A complete
source-level Lean distance theorem has **not** been assembled. The broader
source question asking for sufficient conditions for `dQ=dC` remains distinct.

The strongest completed source theorem is `source_mixed_count_profiles` in
[SourceProfiles.lean](SourceProfiles.lean): starting with the actual expanded
source kernel, girth hypotheses and support weight at most eleven, it derives
exactly the three mixed block-count profiles. [ExceptionalGraph.lean](ExceptionalGraph.lean)
identifies the exceptional five-coordinate graph with `K2,3`.
[SupportSingletons.lean](SupportSingletons.lean) derives the singleton label
alternative from actual source supports. Other modules cover pure sectors,
torsion classical words, full-span/gauge transport, normalization, cycle
obstructions, both CSS sectors and Pauli union weight.

[verification.json](verification.json) is authoritative for exact-source build
status, admitted case intervals and pending work. Generated theorem source is
not a successful check until its matching build record passes. In particular,
the complete weight-ten kernel replay is deferred when it cannot fit the cap.
The independent standard-library verifier checks all **183,312** integer pattern
certificates; that is separate from Lean coverage and actual support coverage.

## Reproduce the checks

The toolchain is Lean `v4.36.0-rc1` and Mathlib commit
`5f7b4198d22a9c82e1c698a379334fe128095c82`. The latter is checked by
`build_round.py`. It writes fresh objects to a separate build directory and
records source hashes, logs and axiom reports. It also records/cleans up its own
child PID and accepts memory, thread, timeout and UTC deadline limits.

```sh
python3 verify_catalog.py
python3 verify_round.py
python3 build_round.py --mathlib /path/to/pinned/mathlib4 \
  --lean-bin /path/to/pinned/lean/bin --build-dir /path/to/fresh/objects \
  SourceProfiles ExceptionalGraph SupportSingletons
```

For a fresh build, first compile the dependencies in their import order; the
admitted module records and import statements identify them. Parent-directory
modules are unchanged source dependencies. Mathlib's cache must be available.
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
