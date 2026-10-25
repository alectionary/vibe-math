From an Uninformative Spectral Bound to Useful Stopping Guarantees for QC-GHP Codes
24 October 2026 (Pacific).

The original Proposition 5.1 parameter question is answered negatively by the
universal scalar-factor parameter obstruction. Useful spectral replacements
exist: a fourth-moment criterion and explicit sparse QC-GHP families give bounds
above two. The fixed-degree 4/8 family has guarantee five, including a separately
certified 54-variable instance. The two-block incidence criterion, exact-six
family and restricted Gram-data obstruction explain the implications and limits.

Read stronger-stopping-paper.pdf. Table 2 near the introduction gives the central
source chronology; Appendix C gives all source and lead dates/calendar deltas.
PROOF-LINKS.md lists every current and immutable Lean URL, including all proof
imports and the parameter-obstruction/B1 proof sources.

Proof reproduction (Lean 4.36.0-rc1; mathlib 5f7b4198d22a9c82e1c698a379334fe128095c82):
  lake build StrongerAnswer
  lake env lean AuditStronger.lean
All 485 named declarations have checked signatures/axiom reports. Only propext,
Classical.choice and Quot.sound occur. No numerical eigensolver or external
search result is a premise.

Manuscript reproduction (Tectonic):
  python3 make_paper.py --tectonic /path/to/tectonic
Or set TECTONIC and run python3 make_paper.py. main.tex and supplement.tex are
editable sources. PAPER_OUTPUT_DIR and --only-cached are supported.

verification.json, PRESENTATION-REVISION.json and RESEARCH-PROVENANCE.txt preserve
build, research and editorial provenance outside the manuscript. The source ZIP
contains the proof project, manuscript, evidence and workflow-skill snapshot.
The X draft is an unposted announcement; no post has been sent.

Shared inventory: 295 canonical entries, 144 eligible targets, 119 papers,
106 main-paper screens and five completed canonical Lean targets. Project-derived
replacement results do not increase that last count. Research status and source
screening are maintained in the shared literature/planning records.
