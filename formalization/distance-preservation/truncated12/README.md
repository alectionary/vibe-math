# Issue 1: truncated distance through weight eleven

This is the October 25, 2026 study of `RQ-F25-truncated-distance-12`, within
`L-F25-distance-preservation`. The [issue](https://github.com/alectionary/vibe-math/issues/1)
records coordination and the four-hour cap.

**Completed general Lean result:** [ThroughNine.lean](ThroughNine.lean) proves
`dQ >= min(dC,10)` under the stated girth/entry tests and transpose-distance
comparison, using actual source matrices, both entire stabilizer row spans and
Pauli union weight. Its predicate form assumes both classical kernel distances
are at least `D` and proves the union-weight lower bound `min(D,10)`.

[RESEARCH-NOTE.txt](RESEARCH-NOTE.txt) gives a certificate-assisted written
argument for `dQ >= min(dC,12)` under the exact stated entry tests. A complete
source-level Lean theorem for that stronger bound has **not** been assembled. The broader
source question asking for sufficient conditions for `dQ=dC` remains distinct.

[SourceProfiles.lean](SourceProfiles.lean) proves `source_mixed_count_profiles`:
from the actual expanded source kernel, girth hypotheses and support weight
at most eleven, it derives
exactly the three mixed block-count profiles. [ExceptionalGraph.lean](ExceptionalGraph.lean)
identifies the exceptional five-coordinate graph with `K2,3`.
[SupportSingletons.lean](SupportSingletons.lean) derives the singleton label
alternative from actual source supports. [ConstantRows.lean](ConstantRows.lean)
identifies constant-label supports with a complete HX row and proves the
exceptional-group cancellation below the classical distance.
[MatchingRows.lean](MatchingRows.lean) derives full integer matching equations
from actual source incidences. [TargetObstructions.lean](TargetObstructions.lean)
interprets all 64 certificate outcome types, and
[PatternRealizations.lean](PatternRealizations.lean) excludes certified patterns
**conditional on an actual realization witness**. Constructing that witness
for every source support is a separate obligation. [SourceSeven.lean](SourceSeven.lean) completes the seven-singleton profile:
actual source kernel words with those counts lie in the entire HX row span.
It includes a quantified 144-pattern certificate theorem and constructs actual
source realizations for the injective label case. Other modules cover pure sectors,
torsion classical words, full-span/gauge transport, actual classical/transpose
distance transport and normalized entry-test transport, cycle
obstructions, both CSS sectors and Pauli union weight.

[NEXT-STEPS.txt](NEXT-STEPS.txt) gives the concrete handoff for the remaining
support constructions and catalog assembly.

[verification.json](verification.json) is authoritative for exact-source build
status, admitted case intervals and pending work. Generated theorem source is
not a successful check until its matching build record passes. In particular,
the complete weight-ten kernel replay was deferred to fit the cap. All 58,752
weight-eleven cases, all 144 weight-seven cases and 7,000 weight-ten cases pass;
the latter include all six exceptional classical-torsion alternatives.
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
