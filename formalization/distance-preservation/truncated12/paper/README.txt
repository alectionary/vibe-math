A truncated distance bound for cyclic lifted-product quantum codes
Manuscript date:25 October2026. No author line.

Read main.pdf. The theorem is dQ>=min(dC,12) for the exact strengthened
normalized fully populated3x4 cyclic source criterion. It uses actual binary
matrices, both full stabilizer spans and ordinary Pauli union weight. The
broader source question asking for sufficient conditions for dQ=dC remains open.

The paper follows the repository's existing LaTeX article/theorem/proof style.
Its Lean appendices print complete central declarations, explain the source
bridges and dependency structure, and link every one of the269 research
imports. PROOF-GUIDE.html provides the complete source/hash/import index.
proof-coverage.json maps every manuscript theorem/proof to checked declarations.
No helper, external verifier or conditional support map replaces the main result.

Proof sources are pinned to immutable commit
3ae21c0719cedbd928f4f7882f9b9e266567605e. All183312 finite cases and the full
source-distance theorem pass. The preserved research branch supplies the
current links. ReportAudit.lean checks all named source interfaces and axiom
closures; declaration-audit.json binds that successful check to its exact source
and log. The only reported axioms are propext, Classical.choice and Quot.sound.
The report adds exposition and audits, not a new mathematical investigation.

Manuscript reproduction
  python3 generate_appendix.py
  tectonic --keep-logs main.tex
The generator verifies current sources against the admitted manifest and,
when Git history is present, the immutable proof snapshot. The generated
listings can also be used as supplied in the standalone ZIP. The integrity
checker verifies their exact source ranges and hashes without Git history.
  python3 prepare_report.py
  python3 validate_report.py
Python3.10+ is required for the report tools, with pypdf for PDF inspection.
Pillow and Poppler are used only for visual review. The report's actual build
used Tectonic0.17.0 and the same article preamble as the earlier source report.

Proof reproduction from the archive
The archive preserves repository-relative source paths. Use Lean4.36.0-rc1
and clone mathlib4 at5f7b4198d22a9c82e1c698a379334fe128095c82. In that separate
Mathlib checkout retain its committed lake-manifest.json and run lake exe cache
get. Avoid lake update: several upstream requirements track moving branches.
The checked manifest hash and exact dependency revisions are recorded in
dependency-lock.json. Then, from the
included formalization/distance-preservation/truncated12 directory, run:
  python3 verify_catalog.py
  python3 replay_round.py --mathlib /path/to/pinned/mathlib4 \
    --lean-bin /path/to/pinned/lean/bin --build-dir /path/to/new/objects \
    DistanceTwelve CriterionScope
  python3 verify_round.py --round-number 2 --final
After that dependency-ordered source rebuild, from paper/ run:
  python3 audit_declarations.py --mathlib /path/to/pinned/mathlib4 \
    --lean-bin /path/to/pinned/lean/bin --build-dir /path/to/new/objects
The recorded investigation checks reuse the pinned Mathlib cache. They do not
claim that Mathlib itself or a new full source rebuild ran during report writing.
The independent integer verifier uses only the Python standard library.
Optional discovery scripts require SymPy1.14; they are not proof premises.

Artifact scope
truncated-distance-source.zip includes the manuscript/PDF, editable TeX,
generated complete listings, source-to-proof map, exact admitted Lean sources,
matching build records, encoded/raw certificates and verification/generation
tools, preserving their relative paths. SHA256SUMS.txt hashes archive members.
report-audit.json records the final PDF/archive hashes outside the archive to
avoid self-reference. archive-metadata.json and the root checksum manifest let
the extracted archive validate itself without that external receipt. Runtime caches, compiled Lean objects, downloaded papers,
credentials and obsolete prototypes are excluded. Earlier campaigns and the
first-block manifest remain historical evidence.

REPORT-PROVENANCE.json separates research and report preparation times.
reference-chronology.json checks calendar ages to the fixed manuscript date;
those ages are not durations of open problems. The reused source ledger records
primary comparisons, harvested questions and native-X access limits. This report
creates no new paper/question cohort and credits no new canonical completion.

Question answered: the exact strengthened criterion implies dQ>=min(dC,12).
Question still open: the broader sufficient-condition question for dQ=dC.
Next proposed target, FOLLOW-UP: Lean-certify the already-studied L13 example's
distance14, including concrete source hypotheses, upper witness and weights12/13.
This proposal is outside the completed theorem and is not active research.
