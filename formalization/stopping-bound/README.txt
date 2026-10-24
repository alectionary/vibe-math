Scalar-factor QC-GHP spectral stopping-bound investigation
========================================================

Read RESEARCH-NOTE.txt for the exact question, hypotheses, proofs, source
comparison, limitations and the next decisive follow-up.

Spectral.lean is a standalone Lean development. It proves the obstruction for
actual expanded real matrices and includes the source's stopping-set/root
bridges, a running-code consumer, and a dense finite CSS illustration.
Audit.lean prints the axioms of every new declaration and the main theorem types.

Pinned environment:
  Lean: leanprover/lean4:v4.36.0-rc1
  mathlib: 5f7b4198d22a9c82e1c698a379334fe128095c82

To reproduce from this folder with Lean/Lake installed:
  lake update
  lake exe cache get Mathlib/Analysis/Matrix/PosDef.lean Mathlib/Tactic.lean
  lake build Spectral
  lake env lean Audit.lean

The cache step only retrieves compiled dependencies; it is not evidence for the
research theorems. The checked build and complete axiom audit are recorded in
verification.json, build.log and axiom-audit.log. Standard Lean/mathlib axioms
are distinguished from admissions; no sorry or new axiom is used.

crosscheck.py is optional independent numerical exploration (Python + NumPy).
Its exact enumeration domain, seed and boundary margin are recorded in
crosscheck.json. Floating eigenvalue calculations are not proof premises.

prior-art.json records literature/code/social queries and concrete access limits.
source-screening.json records the additional historical source directions and
archival gaps. Their current-open status is not inferred. inventory-validation.log
records report/bookkeeping checks, not mathematical correctness.

No publication, push, external message or PAT creation was performed. The source
PDFs and browser-access snapshots remain in the local ignored extraction area;
they are not bundled as public deliverables. SHA-256 values distinguish original
PDFs from normalized web-tool snapshots.
