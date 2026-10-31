# Exact selected-case linear certificate gate

`semantic_linear_case_rows.py` rebuilds the original integer equations and
inequalities for the frozen zero-margin selected-case model. It uses the
existing checked source-family compilers and the exact profile layout and
equations; it does not use CVXPY's floating canonical matrix. Unsupported
optional conditional families fail explicitly. The present export has 76,008
variables, 636 equations, and 263,046 inequalities. All variables are in
`[0,1]`: the moments are Boolean probabilities and the profile weights are
nonnegative components of distributions of mass one.

`verify_semantic_linear_case_dual.py` checks a proposed exact linear
contradiction. The current construction receipt is not a contradiction.

The JSON certificate schema is:

```json
{
  "schema": "c16-semantic-linear-farkas-v1",
  "semantic_digest": "digest from a freshly rebuilt model",
  "case": [32, 32, 0],
  "denominator": "positive integer",
  "equality_terms": [[0, "signed integer numerator"]],
  "inequality_terms": [[0, "nonnegative integer numerator"]]
}
```

Indices refer to the exact semantic row ordering; repeated row indices are
rejected. All multipliers share the stated denominator. The consumer computes
`c = sum(u_i E_i) + sum(v_j A_j)` and
`d = sum(u_i e_i) + sum(v_j b_j)` in Python integer arithmetic. Source
feasibility implies `c*x <= d`. The box gives
`c*x >= sum(min(c_k,0))`. Only a strictly positive exact difference
`sum(min(c_k,0)) - d` is accepted. Thus residual coefficients need not vanish,
and their correction is explicit. A successful certificate excludes this
selected source case only; it does not by itself cover all 405 cases.

The saved numeric-row map is discovery assistance. A numeric equation is
`equality_scale_numerator/equality_scale_denominator` times its mapped semantic
equation. A numeric inequality is its semantic inequality divided by its
positive `inequality_divisor`. Any further positive solver row scaling must
also be included when translating a numeric dual. Solver sign conventions are
not proof: after translation and rational rounding, the exact consumer alone
decides acceptance. No claim depends on the canonical floating coefficients.

Base correspondence was checked on every row, including every profile
variable. All 262,925 unnormalized inequalities match bit for bit; normalized
rows also have zero double discrepancy in this export. Every equality matches
as an exact integer row up to a recorded nonzero rational factor.

To append accepted dense integer-form rows, rebuild with matching
`--dense-banks` and `--dense-replays`; the resulting model has a new semantic
digest. The old base numeric correspondence cannot be reused as if it included
those added rows. The exact append compiler checks the dense validity receipts
and source hashes. No PSD condition is asserted by this linear model.

Example validation command (choose fresh output paths):

```sh
/private/tmp/c16-venv/bin/python verify_semantic_linear_case_dual.py \
  --frozen coupling-results/sourcecase323200-linear22-frozen.json \
  --certificate two-basis-results/proposed-exact-certificate.json \
  --output two-basis-results/proposed-exact-certificate-independent.json
```

The current finite controls check the exact box minimum on 625 coefficient
vectors, a valid contradiction with nonzero residual, and eight corrupt
certificates. They complement the source-row construction; no real certificate
or numerical solve was performed by this consumer task.
