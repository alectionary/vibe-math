Complete minimum stopping-support classification of source B1
===========================================================

For the exact 882-column binary H_X matrix of Abiad–Castriota Example3.2,
arXiv2607.13666v1, ALL size-six stopping supports are the441 distinct companion
H_Z row supports. They form one free Z/7 x Z/63 coordinate-translation orbit.
Every support has3 variables on each side and induced check degrees0or2.
These are conclusions, not elementary/connected-support assumptions.

Read RESEARCH-NOTE.txt for the exact question, definitions, proofs, source and
literature comparisons, evidence boundaries and remaining problems. paper.pdf
is the expanded manuscript, including the preceding family/spectral proofs.
This is a project-derived follow-up supporting L-F16, not a completed answer to
all source Section6 questions. The classification is only for the BASE matrix.
The earlier stopping-distance-six theorem for all positive63-multiple covers
remains valid, but their minimum-support classification is not proved here.
No logical ranks/distances, generator independence or decoding-performance
claims are made. No manuscript author line is assigned.

Pinned toolchain: leanprover/lean4:v4.36.0-rc1
Pinned mathlib:5f7b4198d22a9c82e1c698a379334fe128095c82

Reproduce from this folder:
  lake update
  lake exe cache get Mathlib/Analysis/Matrix/PosDef.lean Mathlib/LinearAlgebra/Matrix/Circulant.lean Mathlib/Tactic.lean
  lake build ClassificationCertificate
  lake env lean AuditClassification.lean

The new proofs are ClassificationSearch,ClassificationData,
ClassificationBranches,ClassificationKernel,Classification and ClassificationCertificate.
ClassificationBranches evaluates ten certificates using decide +kernel.
ClassificationKernel combines them with a proved generic branch-introduction rule.
It can take appreciably longer than ordinary proof elaboration. No native_decide,
Lean.ofReduceBool, added axiom or admission is used. verification.json freezes
all sources, build/audit logs, pins, dependency hashes and timestamps.
PROOF-LINKS.html links every complete source and the checked signatures.

The13 modules under dependencies/ are unchanged copies of the previous checked
artifact (12 incidence modules plus Spectral infrastructure). Their exact hashes
are checked against the frozen parent manifest. They are not new canonical
results. No unstated external research-project import is needed.

Optional independent corroboration, standard Python3:
  python3 enumerate.py
  python3 full_root_check.py
The full882-root enumeration is retained in full-root-check.json. It checks all
441 supports against explicitly reconstructed companion rows, using a different
check ordering from Lean. It is not a proof premise.

Paper source is make_paper.py (ReportLab and DejaVu Sans required). Set
PAPER_OUTPUT_DIR to a chosen output folder and PAPER_FONT_DIR to the DejaVu
font folder to regenerate it. Source PDFs are not bundled; source-screening and
prior-art ledgers preserve provenance/access gaps. No new full texts were
screened in this block. Inventory counts stay267/135,110 papers,97 screens,
4 completed canonical targets. The project-derived classification is linked
separately with zero cohort/completion deltas.

This checkpoint is local, uncommitted and unposted. GitHub folder URLs in the
X draft are intended publication destinations and must be checked after an
authorized publication. No new immutable public proof links exist yet. Complete
archive-relative file links and SHA-256 hashes support local reproducibility.
