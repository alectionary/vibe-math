# Producer API and certificate schema

Producer: `two_sided_full_basis_oracle.py`. Schema: `c16-two-sided-full-basis-v1`.
The producer exports candidates; independent acceptance is required before model integration.

`TwoSidedFullBasisOracle(X_pool=None, Z_pool=None, dimension=128)` reads the physical pools by default. Arbitrary tiny pools are supported, including repeated vectors and zero vectors, with exact integer coordinates in the ambient range. `prepare(X_anchors, Z_anchors)` takes two distinct physical indices per sector and returns all sixteen domains in mask order. Bits 0–1 name the supplied X anchors, bits 2–3 the supplied Z anchors; supplied order is retained. Each domain has `mask`, `status`, `X_anchors`, `Z_anchors`, `X`, and `Z`. Per-side records describe forced/deleted anchors, selected opposite anchors, jointly contracted zero anchors, remaining zero pool, owner bins, and exact ranks or rejection reason.

`support_pattern(domain, weights)` accepts exactly `len(X_pool)+len(Z_pool)` integer/Fraction weights, with X first. A feasible result has `value`, local sorted `X_selected`/`Z_selected`, and `X_support`/`Z_support`; each side records its `zero_basis_indices` and `owner_indices`. Owner indices align with `opposite_selected_indices` in the domain. Rejected patterns have `value=None` and both rejection reasons. This method prices only the basis-selection weights.

`support(coefficients, domains)` accepts `11+5*(len(X_pool)+len(Z_pool))` exact coefficients, requires all sixteen domains in mask order, and returns `upper_bound` plus `support_records`. Feasible records include the anchor-only `pattern_constant`, the `basis_value`, and their sum as `value`. Floats and Boolean coefficients are rejected. Ties favor the smaller physical index. Signed greedy always completes the full rank.

For the physical pools the feature layout is exactly

```
0:         1
1..4:      P[4]
5..10:     PP[6 lexicographic pairs]
11..1450:  U[X720,Z720]
1451..7210: P_U[4,1440].ravel(C)
```

`feature(mask, X_selected, Z_selected, pool_sizes=(720,720))` builds literal binary features. `columns(X_anchors,Z_anchors)` and `target(point,X_anchors,Z_anchors)` use the existing factor-one p/S/T map and phase reversal/diagonal identities. `compile_row(integer_coefficients,integer_bound,X_anchors,Z_anchors)` returns an exact sparse owner-row dictionary and integer RHS, with signed-int64 range guards. The owner layout is `p45 + S[0..8].ravel(C) + T[0..8].ravel(C)`, length 36495.

`cut_candidate(oracle, domains, coefficients, point)` clears rational denominators and common gcd, exactly prices the integer direction, and returns `None` unless the rational target violates its support. A returned candidate includes integer coefficients, anchors, bound, exact target value/violation, owner row/RHS, and all sixteen support records. `export_cut_bank(output,point,candidates,frozen_inputs=None)` writes a new file only, binding the physical source, pools, moment helpers, current passing symmetry receipt, point hash, and supplied frozen discovery inputs. Bank status is `EXACT_TWO_SIDED_FULL_BASIS_CUT_CANDIDATES`. Every cut retains its own anchor quad, allowing a shared bank across quads. Exact Fraction values serialize as canonical strings; integer coefficients remain JSON integers.

The support-control CLI is:

```
OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 VECLIB_MAXIMUM_THREADS=1 \
/private/tmp/c16-venv/bin/python -B two_sided_full_basis_oracle.py \
  --output two-basis-results/NEW-SUPPORT-BANK.json
```

It freezes two existing quads and four exact coefficient cohorts before pricing. The bank has `queries`, each containing its quad, label, coefficients, bound, and full pattern records. The accompanying `.frozen.json` binds all discovery inputs. No optimization is performed.

The source-valid domain is the product of two full-basis domains conditional on the common four-bit pattern. Pairings between unanchored X and Z vectors remain relaxed. Neither an auxiliary basis pair nor exact membership in this projected hull certifies a physical dual frame or resolves a cover case.
