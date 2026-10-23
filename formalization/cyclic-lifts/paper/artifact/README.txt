COMPANION ARTIFACT -- RECTANGLE CRITERIA FOR GIRTH EIGHT
Snapshot revision: 2026-10-23 (earlier proof sources retained)

This snapshot accompanies the anonymous manuscript main.tex. All source and
result paths are relative to this directory. MANIFEST_SHA256.json freezes the
files distributed here. No downloaded papers or dependency binaries are included.

LEAN
Install elan/Lean for the lean-toolchain file, then enter:
  formalization/dyadic-rank

The configuration intentionally preserves the original alternate Lake file:
  lake -f lakefile-cyclic.toml exe cache get
  lake -f lakefile-cyclic.toml build CyclicLift
  lake -f lakefile-cyclic.toml env lean CyclicChecks.lean
  lake -f lakefile-cyclic.toml env lean CyclicSourceQuestion.lean
  lake -f lakefile-cyclic.toml env lean CyclicDecoding.lean
  lake -f lakefile-cyclic.toml env lean CyclicOptimized.lean
  lake -f lakefile-cyclic.toml env lean CyclicStructure.lean

Build the explicit CyclicLift target, as shown. The inherited config also names
an unrelated DyadicRank library, which is not part of this manuscript snapshot.
Lean is pinned to 4.36.0-rc1; Mathlib and its dependencies are pinned by the
configuration and manifest. Mathlib dependencies are downloaded, not bundled.
The checked logs from this snapshot are under formalization/dyadic-rank/checks.

COMPUTATIONS
Python 3.9 or newer and a C++17 compiler suffice; no Python packages are required.
From this artifact root:
  python3 formalization/cyclic-lifts/search/optimize_absorbing.py --r 14
  python3 formalization/cyclic-lifts/search/benchmark_decoding.py --trials 10000
  python3 formalization/cyclic-lifts/search/benchmark_decoding.py --trials 100000 --seed 20261023 --probabilities 0.01 0.02 0.04 --primary-only --output benchmark-confirmation.json
  python3 formalization/cyclic-lifts/search/targeted_absorbing.py
  python3 scripts/validate_cyclic_decoding_benchmark.py
  python3 scripts/validate_cyclic_structure.py

The last command audits existing results without rerunning the Monte Carlo:
it repeats the exhaustive graph search, checks all orbit counts by an independent
DFS, verifies ranks and matrix identities, reconstructs paired outcomes and
intervals, checks logical witnesses, and verifies supplementary source hashes.
Other earlier audit records are included as provenance, but their inventory-level
validators belong to the larger repository rather than this standalone snapshot.

SUCCESS CRITERION AND SCOPE
The simulator tests one Pauli error sector with independent Bernoulli(p) errors
and perfect syndrome measurements. Recovery succeeds iff the true error XOR
the correction belongs to row(H_Z). True errors are used only to form syndromes
and to score outcomes, never to select corrections. Lower-rate minima are only
exploratory; confirmation uses four codes with n=252 and k=10.

The 75-theorem core, three source-question corollaries, eight decoding declarations
and three optimized-candidate declarations are separate audits. A further 29
audited declarations prove the general absorbing-support/eight-cycle bijection,
minimum-size exclusion and the 2*d stopping bound. Cycles have an explicit
native Mathlib walk bridge and are counted modulo origin and orientation.
The elementary (4,4) odd-check count, companion-stabilizer identification and
conductance argument retain written proofs.
The fixed-size optimum and Monte Carlo results are computational evidence.

FULL PROOF DISCOVERY AND PDF LISTINGS
The manuscript's Appendix A and LEAN-PROOF-GUIDE.md link the complete formal
proof at immutable revision 5dbda826fb9d385cf5528694f6908d28bc94054d. Every
helper lemma is also included in this snapshot. The PDF prints nine selected
excerpts and a proof dependency diagram. From this artifact root, run
  python3 scripts/prepare_cyclic_paper_listings.py
to regenerate the sibling manuscript listings and verify their Unicode escape
round trips. The excerpts manifest records exact source locations and hashes.

OCTOBER 23 CLAIM AUDIT AND LOW-WEIGHT SUPPLEMENT
The girth-condition question is answered. Broader decoding-properties questions
have partial answers only. The original benchmark fixes length/rate but not
distance: exhaustive weight-six searches give baseline distance six and lower
bound eight for each comparison code, in both sectors. Absorbing-count changes
and algebraic changes are not causally separated by that benchmark.

From the artifact root:
  python3 formalization/cyclic-lifts/search/logical_six.py
  python3 scripts/validate_cyclic_logical_six.py
  python3 formalization/cyclic-lifts/search/generate_logical_certificate.py
Then in formalization/dyadic-rank:
  lake -f lakefile-cyclic.toml env lean CyclicLogicalSix.lean

The ten new Lean declarations prove a concrete same-local-topology/different-
logical-role certificate, including a full-span nonmembership witness. They do
not formalize the exhaustive census. No new code, noise or decoder was added.
