# Two-sector full-basis implementation and bounded baseline

The new exact 16-pattern oracle passed independent acceptance. Its domain consists of two full physical rank-128 bases sharing a 2X+2Z anchor pattern, with forced/deleted own anchors and mandatory opposite-anchor owners. Unanchored mutual X/Z pairings remain relaxed. The literal feature map has 7,211 entries with factor-one p/S/T targets.

The stable producer is `two_sided_full_basis_oracle.py`; the stable consumer is `verify_two_sided_full_basis_oracle.py`. The canonical control receipt is `two-basis-results/two-sided-full-basis-controls-v3-independent.json`. Independent controls include 512 tiny pattern/objective comparisons, 7,752 literal basis pairs, 115,376 literal symmetry-map equalities, signed negative/tied/fractional weights, joint contraction and deletion failures, integer row translation, overflow rejection, and corrupted basis/owner/anchor/bound checks. The frozen physical support bank has eight coefficient/quad queries, all sixteen patterns each. The consumer independently checks signed prefix-rank upper bounds and full physical maximizing bases. See `two-sided-full-basis-api.md` for the interface and cut schema.

The authorized first numerical baseline used the fully accepted frozen point `coupling-results/integer-witness15-rational.json.gz`, SHA256 `5f9a622e68a3c1e842ae13a5a5b18cf06b388515b5821d17eda2389375b290ef`. Each quad received a 60-second Wolfe search, seeded by zero, positive/negative target directions, and four deterministic signed random directions. Every direction was rounded to exact integer coefficients and priced over all sixteen patterns. Both searches ended without an exact separator.

| Quad | Rounds | Saved physical basis pairs | Final active columns | Maximum feature residual |
|---|---:|---:|---:|---:|
| X[80,512], Z[186,433] | 468 | 7,600 | 357 | 0.004049676962092517 |
| X[80,432], Z[186,514] | 479 | 7,776 | 367 | 0.004614931272744854 |

The 60-second search guards were followed by archive/report serialization; total reported elapsed times were 61.376 and 61.425 seconds. Numerical correction consumed about 20 seconds per run; exact pricing plus archive scoring consumed about 38 seconds. Final normalized target-minus-support gaps were negative. Neither a small residual nor the absence of a cut proves membership.

The endpoint archives preserve every unique queried physical column, both selected-basis index lists, mask, final active IDs, and numerical weights. Each compressed archive is under 3.6 MB. `audit_two_sided_full_basis_endpoint.py` independently replayed all 15,376 literal columns and all 30,752 full physical bases, anchor states, owner conditions, seed/final exact support bounds, and saved mixture residuals. Both `two-sided-full-basis-{32x27,27x32}-endpoint-independent.json` receipts explicitly retain the inconclusive scope.

The isolated `synthetic-cut-pipeline-v1/summary.json` control exercises the actual producer exporter, independent cut consumer, and matrix dispatcher on a deliberately invalid synthetic target. It verifies the cardinality row and rejects six corruptions. Its artifacts are controls only and must never enter an actual model bank.

No new moment cut or source result arose from this baseline. The saved columns can seed a shared-pattern allocation formulation, and any future exact fixed-pattern-mass separator must first be treated as a row on those masses. An outer proof and full 7,211-feature support replay are required before exporting a global moment inequality.
