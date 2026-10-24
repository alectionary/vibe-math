CYCLIC LIFT-LABEL ELIMINATION: EXACT COUNTS AND A CSS FAMILY

This is a project-derived follow-up to L-F16-other-absorbing. It does not add an
author-posed question or change the canonical coverage denominator. The general
voltage/cycle-consistency method and the two base configurations are classical.
No mathematical, formalization or code-record priority is claimed.

RESULTS
* Every lifted Pasch in an ordinary cubic linear monomial cover projects
  injectively to a base Pasch. It survives exactly when its three cycle voltages
  vanish, contributing exactly N unordered supports.
* For the fixed star and triangle bases, the numbers of raw edge-label arrays
  eliminating every cover Pasch are, for all N>=1,
    N^30-N^27,
    N^30-5N^27+10N^24-10N^21+4N^19.
  All six histogram bins and the explicit eleven-coordinate slices are counted.
  Raw and slice counts are proved independently, including composite N.
* Simultaneous original/dual star-cover elimination has raw-label count
    N^30-2N^27+N^24.
* The fixed N=7 scalar-right construction retains at least 70 supports in each
  full Tanner graph for any left labels. For N=7q, q>=2, the two-edge assignment
  z(0,0)=z(4,6)=7 instead gives actual binary CSS [[140q,18,6]] codes, column
  weight 3, row weight 6, no Tanner four-cycles, and no elementary (4,0) supports
  in either graph. Dimension and distance remain constant; no decoder-performance
  or asymptotic-goodness claim is made.

PROOF COVERAGE
Every manuscript proof has a faithful checked Lean version. The 70 mathematical
modules were freshly built from recorded source hashes; all 1,755 named authored
declarations are queried by AuditAll.lean. Only propext, Classical.choice and
Quot.sound are allowed. See proof-coverage.json, axiom-audit.json and
verification.json for the exact objects, hypotheses, source hashes and scope.
The 61 imported research modules are the unchanged, previously freshly checked
dependency artifact; they are not claimed rebuilt in this block.

Ten root certificate modules compile all 141 unchanged generated fragments.
certificate-assembly.json maps their hashes and namespaces to the actual compiled
modules. The fragments in certificates/ are generator components, not standalone
library modules. check_generators.py reproduces all fragments and batches exactly.
Legacy names use Gauge; the paper states explicit coordinate slices and does not
assert or depend on a general switching-orbit theorem.

The paper uses recurrence and orthogonal-witness proofs for rank and logical
nontriviality. Historical quotient-ring/carry derivations are retained in
DERIVATION.txt; they are alternate routes to the same conclusions. The historical
checkpoint's pending-formalization statements are superseded by the final audit.

INDEPENDENT CHECKS
C++ enumerates all 8,746,998 slice assignments for N=2,3,4 in both bases. A second
C++ implementation reconstructs the q=2 [[280,18,6]] code, checks both ranks 131,
commutation, degrees and linearity, tests all 250,654,530 four-subsets per graph,
and checks an explicit weight-six nontrivial logical. Python consumers cover
q=2,3,4 and 128 seeded ordinary-cover cases (seed 20261024). These are independent
checks, not claims that the Python/C++ software algorithms are formally verified.

REPRODUCE (Python>=3.10, C++17)
  python3 verify.py
This replays integer certificates, finite ingredients, source generation and both
C++ consumers, then checks the frozen payload. Never compile with NDEBUG.

Pinned Lean leanprover/lean4:v4.36.0-rc1; mathlib revision
5f7b4198d22a9c82e1c698a379334fe128095c82. With that project installed:
  python3 ../absorbing-four-zero/verify_sources.py --project /path/to/pinned/project
  python3 verify_lean.py --project /path/to/pinned/project
The second command builds only the new modules, in an isolated library, then
queries every named authored declaration. Its record distinguishes the previous
61-source dependency build from the new source build. No compiled objects, caches,
third-party PDFs or full third-party code blobs are distributed.

PUBLICATION AND PRIOR ART
The editable manuscript and PDF are in papers/lift-label-elimination in the repo.
Proof links are pinned to an immutable source commit. Reference-date intervals,
inspected versions and elapsed days are recorded in reference-chronology.json.
prior-art.json and github-review.json retain primary-text comparisons, remaining
access gaps, exact X/GitHub queries, result caps and invalid-search exclusions.
A bounded negative search does not establish that the exact instance is new.
Earlier frozen research archives and manifests remain unchanged.
