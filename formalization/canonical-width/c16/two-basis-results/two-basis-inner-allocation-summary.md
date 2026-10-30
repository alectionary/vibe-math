# Bounded fixed-pattern-mass allocation gates at point15

No gate below produced an exact pattern-mass separator or an exact target mixture. The physical oracle, initial mixtures, and phase-I feasibility certificates have independent checks; numerical residuals remain nonzero.

The frozen quad is X[80,512]/Z[186,433]. Given exact pattern masses lambda, each sector has nonnegative physical-basis weights with sixteen mass equations and 3,600 literal feature equations. Adding signed error variables only to the feature equations gives a feasible phase-I LP. A feature potential a yields the necessary pattern-mass inequality `sum_m lambda[m] h_m(a) >= a·target`, where every h_m is an exact signed full-basis support. A violation at a fixed lambda would exclude that lambda, not the global moment point; an outer proof and full functional repricing are still required.

The first 120-second LP attempt loaded all 7,600 archived columns without a feasible warm basis. Both calls timed out and returned unavailable-as-proof numerical values with negative weights and large mass residuals. HiGHS exceeded the requested cooperative limits by about 22 and 15 seconds. The original files remain frozen; `two-basis-inner-first-gate.md` corrects the overly optimistic zero-dual stopping wording. No recovery or membership claim is attached to these outputs.

The v2 diagnostic used an explicit block-triangular basis: one physical basis per pattern and one signed error variable per feature. Independent replay verified both saved exact starts and all 3,616 basic variables. This is phase-I feasibility with errors, not target membership. The thirty-second tests stopped near sixteen seconds because the driver supplied a decreasing remaining limit to HiGHS' cumulative timer. The external forty-five-second caps were not reached. The v2 reports remain frozen.

The v3 attempt corrected cumulative time accounting and used the old Wolfe active columns, while retaining the explicit sixteen-column initial basis. Its new exact lambda minimizes L1 distance to the old Wolfe pattern masses within the independently accepted local-box projection. Five high-cardinality patterns have zero mass. They were still exactly priced for every candidate inequality; only unnecessary new LP columns at zero mass were skipped.

| v3 sector | LP rounds | Initial/final basis columns | Exact saved phase-I L1 error | Maximum feature error |
|---|---:|---:|---:|---:|
| X | 32 | 359 / 700 | 0.8060971679222086 | 0.004518235125665069 |
| Z | 31 | 359 / 689 | 0.7456812646706585 | 0.00930799379201236 |

The terminal interrupted values again included negative weights. The table instead describes earlier recomputed nonnegative iterates, converted from binary floats exactly and explicitly normalized within each pattern to the frozen rational lambda. Signed errors were recomputed exactly; no weight was clamped. Independent replay checked the 569/579 positive physical bases, all sixteen masses, eleven anchor identities, all 3,600 error equations, and the normalization against the saved numerical state. The exact errors improve on the separately verified rescaled-old-mixture upper bounds 2.4256205439713474 and 2.5332394762127604, but remain nonzero.

Approximately 118 seconds per v3 sector went into LP solves and one second into exact support pricing. Box-constrained L1 dual directions still had large negative global support gaps, motivating the separately authorized fixed-lambda L2 gate rather than further LP extension.

For fixed lambda, the sector polytope is the Minkowski sum of the pattern basis polytopes weighted by lambda. Its support is the corresponding weighted sum of the sixteen exact supports. The L2 driver starts with the independently accepted interior mixture above; each subsequent atom retains sixteen physical bases and exact integer feature numerators over the common lambda denominator. All sixteen supports are retained even at zero-mass patterns. An interior starting mixture is a valid atom, and its full physical expansion remains bound by hash.

| L2 sector | Rounds / saved atoms | Active atoms | Maximum feature residual | L1 feature residual | Final normalized exact target-minus-support gap |
|---|---:|---:|---:|---:|---:|
| X | 1,037 / 1,038 | 610 | 0.0009178629227107118 | 0.2499477921162851 | -0.11255143430365996 |
| Z | 1,021 / 1,022 | 613 | 0.0004296215152069481 | 0.02420134569334992 | -0.49672676293342033 |

Both L2 searches stopped at the 120-second loop cap; total process times including preparation and serialization were about 121.85 seconds, below the external 150-second caps. No exact positive gap appeared. The physical aggregate archives are about 8.46 MB and 8.27 MB. Exact positive support is the acceptance gate for a future separator, and exact nonnegative mixture recovery is the gate for target membership. Neither gate was met here. No cover case, source frame, or width bound was resolved by these attempts.

`audit_two_basis_fixed_lambda_endpoint.py` independently replayed both complete aggregate archives, including every physical basis at zero-mass patterns, the accepted initial mixture, exact aggregate numerator/denominator identities, final sixteen signed-prefix support bounds, and numerical mixture residuals. Both endpoint receipts report `PASS_FULL_FIXED_LAMBDA_ENDPOINT_INCONCLUSIVE`. This validates the bounded records and their scope; it does not change the negative separator result or certify target membership.
