Distance loss in girth-eight cyclic lifted-product codes
Manuscript date: 25 October 2026 (UTC). No author line.

Read main.pdf. Its Lean appendices explain the objects, dependency structure,
complete central proof bodies and all current/immutable source URLs. main.tex
and lean-appendix.tex are editable; the listings and deep links are generated
from the checked sources. PROOF-GUIDE.html additionally links every admitted
file, exact hash, checked build record and imports. proof-coverage.json maps
every manuscript proof and appendix listing to the formal counterparts.

The result is an infinite counterfamily to our diagnostic criterion:
for every L>0 divisible by11, dQ<=11<12<=dC<=20, classical girth8,
connected classical Tanner graph, no full RCPC, transpose distance2L.
The source's general sufficient-condition problem is not marked solved.
The report follows the repository's established article/theorem/proof style.

Publication and source pins
The unchanged mathematical Lean sources are published at Git commit
98eb91cd9049e6a88887a5ba79150ad96a4a3e53. Manuscript theorem links target
their exact declarations at that pin. The paper appendices also print every
current and immutable source URL. This presentation build is local until
separately committed; no new push or announcement is part of its preparation.
editorial-provenance.json records the earlier snapshot and the presentation work.

Reproduction
Generate the source-bound listings before building the manuscript:
  python3 generate_appendix.py
This checks all50 source files against the immutable Git snapshot and records
exact ranges/hashes in appendix-listings.json. In an extracted ZIP without Git
history, the existing generated files can be compiled as supplied; hash/range
validation in validate_report.py does not require Git history.
Build main.tex with Tectonic (the repository's existing manuscript workflow):
  tectonic --keep-logs main.tex
The desktop LaTeX project/compiler can also compile and preview this folder.
Run the checks and create the source snapshot using:
  python3 prepare_report.py
  python3 validate_report.py
Use Python3.10+; the investigation's numerical scripts require Python3.10+
and NumPy. A known working bundled interpreter is recorded in report-audit.json.

Lean dependencies are pinned by ../dyadic-rank/ relative to the research
directory (i.e. ../../dyadic-rank/ from here). See the bundled dependency
specifications and the exact mathlib commit in the guide. The original
build helper is ../build_lean.py. An isolated source rebuild is recorded
in ../clean-rebuild.json; all50 admitted authored modules passed. Pinned
cached mathlib and dependency objects were reused, not rebuilt.
PaperAudit.lean checks the exact signatures and axioms of every Lean
declaration linked in the manuscript, using the isolated rebuilt sources.

Standalone archive rebuild (requires installed Lean/Lake and network access
for initial dependency setup): in paper/lean-environment run `lake update`
and `lake exe cache get`. Then, from paper/, run:
  python3 rebuild_proofs.py --environment lean-environment --output /tmp/distance-proof-rebuild
The output directory must be new. This compiles the50main modules and
PaperAudit against the pinned dependencies, with all research objects isolated.
`python3 rebuild_proofs.py --check-plan` checks source hashes and import order
without rebuilding. This portable wrapper's plan has been checked; the complete
successful build evidence is the recorded isolated investigation rebuild and
the separate manuscript declaration audit, not a new execution of this wrapper.

Artifact scope
distance-preservation-source.zip preserves the manuscript, checked sources,
build records and selected reproducibility evidence with their original
directory relationships. SHA256SUMS.txt hashes every archive member; the
archive hash and PDF hash are in report-audit.json. It excludes downloaded
third-party repositories, local runtime paths, binaries, compiled Lean objects
and obsolete prototypes. The full original investigation directory retains
the larger search-input/output archive. The included verification.json is
the historical full-investigation manifest; not every external experiment
file named there is included in this smaller manuscript bundle.

Timing and evidence
The four-hour investigation ran 25 October2026 02:13:15--06:13:26 UTC;
closeout.json records the exact elapsed time, approximately4h00m11s.
Manuscript preparation started after that closeout, in a separately
authorized report-writing request. report-audit.json records its build date.
Source-reference calendar deltas are measured to25October2026, independent
of investigation duration. No discovery-to-proof effort estimate is inferred.

Exact finite computations, searches, the repaired C++ exclusions and the
UNKNOWN SAT attempt are supporting evidence, not premises of the Lean
counterfamily. Neither the144-pattern catalog nor the weight7 support
classification is promoted to a completed universal theorem in this paper.

Question answered: the explicit proposed girth/RCPC criterion is false.
Question still open: general sufficient conditions for source dQ=dC.
Next proposed target (follow-up): prove/refute dQ>=min(dC,12) under the
normalized strengthened hypotheses stated in the paper's final section.
