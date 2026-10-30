# Shared basis phase-I seed: preparation only

The independently accepted coupled eight-event endpoint at global point22 now has an exact physical-column start for a possible shared basis master. One maximum-weight full physical basis was chosen in each of the 22 positive sector-pattern domains. Its coefficient is the existing exact pattern mass. The ten zero-mass sector-pattern blocks have zero allocation and contribute no basis.

The parent endpoint's 22,513 parameter strings and all 23,040 allocation strings were retained unchanged. Every proposed linking equation is satisfied by explicit nonnegative artificial errors:

`lambda[m] * 1[j in B] + positive_slack[j] - negative_slack[j] = y[m,j]`.

The total artificial L1 error is approximately **289.05647614220123** (X: 144.70562232678859; Z: 144.35085381541265). The exact fraction is stored in the seed and independent receipt. For each block, signed full-basis greedy maximizes `sum(y[j] for j in B)` and therefore minimizes the single-basis error `256*lambda - 2*sum(y[j] for j in B)`. This is optimality among one-basis choices per block, not an optimal shared-master objective.

`verify_shared_basis_phase_one_seed.py` accepted all 22 full physical bases, 13,454 independent signed-prefix rank checks, all 23,040 exact links, ten zero blocks, retained parent strings, and five corruption controls. The receipt is `two-basis-results/shared-basis-phase-one-point22-seed-independent.json`.

No shared master was implemented or solved. Positive artificial error proves neither allocation membership nor a source obstruction. The existing parent proof retains its finite row families and pinned pattern-law scope. Unanchored mutual pairings remain relaxed; the source width interval 16/18, cover405, physical partial88/128 and zero excluded full-source anchors remain unchanged.

The complete gate inventory includes the producer, consumer, seed, frozen inputs, receipt, and the Clarabel and shared-master strategy notes. Its `files` and `repository_input_bindings` must both be copied; inherited Python import closure is supplied by the separate final checkpoint closure. All gate processes have exited. No further preparation or optimization is active.
