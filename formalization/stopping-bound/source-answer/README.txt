L-F16: universal negative parameter answer for Proposition5.1

Read RESEARCH-NOTE.txt and paper.pdf. The nonexistence theorem covers every
positive-dimensional binary biregular scalar-factor parameter choice. The raw
spectral inequality can hold, but its large-root guarantee never exceeds two.

Reproduce with Lean4.36.0-rc1 and the pinned mathlib:
  lake update
  lake exe cache get
  lake build SourceQuestionAnswer
  lake env lean AuditSourceAnswer.lean
The project includes unchanged parent Spectral.lean under dependencies/.
source-ledgers/parent-verification.json, parent-Audit.lean and its axiom log
preserve the earlier52-declaration audit. New2-declaration audit checks the
combined all-cases statements. PROOF-LINKS.html has archive-local file links.
Original parameter question: ANSWERED NEGATIVELY; complete checked Lean proof.
The separate stronger replacement-bound direction remains open.

Immutable proof source revision: ce3c849feff7a4f6284ff4f93d0209e42da33983
https://github.com/alectionary/vibe-math/blob/ce3c849feff7a4f6284ff4f93d0209e42da33983/formalization/stopping-bound/source-answer/SourceQuestionAnswer.lean
https://github.com/alectionary/vibe-math/blob/ce3c849feff7a4f6284ff4f93d0209e42da33983/formalization/stopping-bound/source-answer/dependencies/Spectral.lean

Paper: paper.pdf; companion announcement: x-post-draft.txt (not posted).
The publication reconciliation is recorded in PUBLICATION.txt / publication.json.
