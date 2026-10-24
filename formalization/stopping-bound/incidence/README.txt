Incidence-aware QC-GHP stopping certificate
=========================================

RESEARCH-NOTE.txt states the exact answered question, source conventions,
proofs, literature comparison, evidence limits and remaining targets.

Main interface: IncidenceCertificate.lean
  Incidence.Family.positive_family
  Incidence.Family.source_B1_stopping_distance_six

For t any positive natural, the actual CSS check matrices at ell=63t have
882t columns,441t rows, degrees3/6 and stopping distance exactly6. Logical
k,d and rate are not asserted. IncidenceSpectral.lean proves sigma_2^2>=12
and negativity of both Zhu–Chugg formulas whenever their strict gap holds.

Pinned Lean: leanprover/lean4:v4.36.0-rc1
Pinned mathlib:5f7b4198d22a9c82e1c698a379334fe128095c82

From this folder:
  lake update
  lake exe cache get Mathlib/Analysis/Matrix/PosDef.lean Mathlib/LinearAlgebra/Matrix/Circulant.lean Mathlib/Tactic.lean
  lake build IncidenceCertificate
  lake env lean AuditIncidence.lean

The cache step retrieves compiled dependencies; the build/audit check the proofs.
verification.json freezes source hashes, commands and axiom results.
AuditIncidence.lean checks every new declaration and prints main signatures.
No sorry, added axiom, native_decide or Lean.ofReduceBool is used.

dependencies/Spectral.lean is an exact vendored copy of the frozen parent
Spectral.lean (SHA-256 a3e712b2a206bd7743408ecc122e66e7d980dbd4689c6d49977536dfe9bb469d).
Its previously checked52 declarations are imported infrastructure, not new
completed source targets. The standalone copy avoids an unstated external
research-project dependency.

Optional corroboration requires Python3+NumPy:
  python3 crosscheck.py
Exact domains and floating-only illustration are labelled in crosscheck.json.
The universal proofs do not depend on Python or a numerical eigenvalue.

source-screening.json and prior-art.json preserve source/algorithm comparisons
and explicit access gaps. Shared inventory/source/planning reports were updated,
with five broad historical directions and no new canonical completion.
No publication, commit, push, external message or PAT creation was performed.
