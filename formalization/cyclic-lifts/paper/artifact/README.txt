COMPANION ARTIFACT -- RECTANGLE CRITERIA FOR GIRTH EIGHT
Snapshot date: 2026-10-22

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
and three optimized-candidate declarations are separate audits. General absorbing
and stopping bounds and the conductance argument are written mathematical proofs.
The fixed-size optimum and Monte Carlo results are computational evidence.
