# Issue 1: truncated distance through weight eleven

This is the October 25, 2026 study of `RQ-F25-truncated-distance-12`, within
`L-F25-distance-preservation`. The [issue](https://github.com/alectionary/vibe-math/issues/1)
records coordination and the four-hour cap.

**Completed general Lean result:** [DistanceTwelve.lean](DistanceTwelve.lean)
proves `dQ >= min(dC,12)` for every normalized, fully populated monomial 3x4
cyclic base satisfying classical girth at least eight, the exact strengthened
column/triple-row entry tests, and `dTranspose >= dC`.

The [abstract and keywords](paper/ABSTRACT.txt) accompany the report.

The standalone [research report](paper/main.pdf) gives the theorem, full argument,
source chronology and substantive Lean appendix. [Editable TeX](paper/main.tex),
[complete proof guide](paper/PROOF-GUIDE.html) and
[reproducible source archive](paper/truncated-distance-source.zip) accompany it.

The distances are minima for the actual expanded binary source matrices.
Both entire stabilizer row spans are retained, and quantum weight is the
ordinary Pauli union weight. The transpose distance is infinity when its
kernel is zero. The proof applies to every positive cyclic modulus, including
composite and small moduli; no prime-lift assumption or division by a cyclic
group coefficient is used.
This lower bound does not assert exact quantum distance or settle the broader
source question asking for sufficient conditions for `dQ=dC`.

[ThroughEleven.lean](ThroughEleven.lean) gives the general predicate version:
actual classical and transpose kernel lower bounds `D` imply the Pauli bound
`min(D,12)`. [TwelveConditional.lean](TwelveConditional.lean) supplies the source
reduction; its finite-coverage premise is discharged in the public theorem.
[TenEncoding.lean](TenEncoding.lean) and [SourceEleven.lean](SourceEleven.lean)
construct actual support realizations, including the full constant-label
stabilizer branch and the colored K2,3 case. [ProfileTransport.lean](ProfileTransport.lean)
and [CountCanonical.lean](CountCanonical.lean) handle arbitrary group placement
and re-normalization. [DistanceMinima.lean](DistanceMinima.lean) connects the
result to literal distance minima. [CriterionScope.lean](CriterionScope.lean)
checks that the stronger triple-row test subsumes full-row RCPC.

All **183,312** finite pattern certificates pass both the independent integer
verifier and Lean's closed-case replay: 144 at weight seven, 124,416 at weight
ten and 58,752 at weight eleven. [Coverage10.lean](Coverage10.lean) and
[Coverage11.lean](Coverage11.lean) assemble quantified coverage from the closed
proofs. The entire final import closure, including the source-scope audit,
contains **269 exact-source admitted research modules**. Only the standard
axioms `propext`, `Classical.choice` and `Quot.sound` occur; no `sorry` or native
decision oracle is admitted.

[RESEARCH-NOTE.txt](RESEARCH-NOTE.txt) gives the proof;
[CLAIM-AUDIT.txt](CLAIM-AUDIT.txt) traces the source hypotheses, actual objects
and complete quotient; [verification.json](verification.json) records hashes,
logs, finite intervals and every imported research module. The first block's
completed weaker bound and its original coverage are preserved in
[round1-verification.json](round1-verification.json). No additional canonical
completion is credited to this project-proposed bounded follow-up.

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
  DistanceTwelve CriterionScope
python3 verify_round.py --round-number 2 --final
```

`replay_round.py` computes and builds the full local import closure in dependency
order; `--plan` prints that order without compiling. With no module arguments it
selects all exact-source modules admitted in the manifest. Parent-directory
modules are unchanged source dependencies.
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

All imported research sources, closed weight-ten chunks and catalog wrappers
are tracked. The coefficient data and exact source-hash plan are preserved;
`python3 emit_kernel_chunks.py --fast` regenerates the closed checks and
`python3 emit_coverage.py 10` / `11` regenerate quantified coverage. Regeneration
alone is not admission; matching successful build records remain required.
