Incidence-sensitive stopping bounds and a Gram obstruction
24 October 2026. Follow-up to L-F16-stopping-bound.

Question answered positively: a reusable incidence-conditioned bound exceeds two on sparse QC-GHP quantum-code families beyond B1.

PartitionBound proves 2(gamma+sigma) <= (sigma+tau)|S|. PowersFamily gives actual binary CSS families, nontrivial logical classes, constant degrees and arbitrary fixed guarantees. KernelStopping proves exact stopping/logical distance six for the explicit weight4/8 family at every positive39-multiple lift. SidonBad and BadStopping give same-full-real-Gram CSS counterparts with stopping distance two.

The earlier Proposition5.1 useful-parameter question remains answered negatively. The new Gram obstruction is restricted; no claim rules out every stronger spectral bound on every QC-GHP family.

Reproduce with Lean4.36.0-rc1 and the pinned mathlib:
  lake build StrongerAnswer
  lake env lean AuditStronger.lean
The three dependencies are frozen generic stopping/cover infrastructure from the earlier artifact. No native_decide, unproved axiom or external numerical result is a proof premise.

The paper, complete branch and immutable Lean links, source chronology and inventory reconciliation accompany the publication checkpoint. X drafts are not posted.

Published paper: stronger-stopping-paper.pdf
Companion announcement: stronger-stopping-x-draft.txt (not posted)
Complete direct Lean file URLs: PROOF-LINKS.md; immutable source pin3e70cc79d7c4c171027a2a40f0757781d9787efb.
Chronology: SOURCE-CHRONOLOGY.md and compliance-data.json.
Shared inventory: literature/stronger-stopping-source-screening.json;287 entries,143 eligible,5 complete canonical proofs.
Validate with Python3+pypdf: python3 scripts/validate_stronger_stopping.py from repository root.
The source archive includes the checked standalone project and shared question/planning snapshots. Copyrighted primary full texts remain in ignored local extraction, not the archive.
