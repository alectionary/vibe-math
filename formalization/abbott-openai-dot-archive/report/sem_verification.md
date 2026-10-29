# Independent verification of covariance-model calculations

## What was checked, and what was not?

The eight normal-theory maximum-likelihood calculations on the printed correlation matrix pass independent algebra, optimizer, gradient, parameter-count, and local-identification checks. These checks validate the implementation on its stated input; they do not reproduce the original participant-level Mplus MLR/FIML analysis.

[verify_sem.py](../scripts/verify_sem.py) reconstructs the covariance using a separate directed-path RAM formulation, `F (I-A)^(-1) P (I-A)^(-T) F'`, instead of the primary script's hierarchical matrix multiplication. It computes the likelihood through `slogdet` and `solve` rather than the primary Cholesky expression, and fits from a perturbed starting point with numerical derivatives rather than the primary analytic gradient. It uses no simulated participant observations. A covariance-only algebraic fixture verifies that the model's own covariance has zero discrepancy.

The [machine-readable results](../outputs/sem_verification.json) record all tolerances, exact software versions, and the deterministic perturbation seed 8675309. Regenerate with:

```sh
OPENBLAS_NUM_THREADS=1 python scripts/fit_sem.py
OPENBLAS_NUM_THREADS=1 python scripts/verify_sem.py
```

## Do the models match the published specifications?

The degrees of freedom match all eight published models after correcting our initial Held-model translation. Appendix J's Held specification, printed page 258, contains no residual-covariance refinements; the results on page 141 report that residual correlations were removed to resolve nonconvergence. The initial local implementation had incorrectly inherited the Revised model's surviving refinements. Removing all of those inherited covariances yields the published 311 degrees of freedom, not 303. This was our translation issue and is not attributed to the dissertation.

| Model | Published df | Our df | Verdict and reason |
|---|---:|---:|---|
| Unrefined Revised, 21 indicators | 181 | 181 | match: 231 covariance moments minus 50 parameters |
| Refined Revised, 21 indicators | 178 | 178 | match: three additional residual covariances |
| General-factor rival | 179 | 179 | match: one less free covariance parameter |
| Revised with external factors | 326 | 326 | match: 406 moments minus 80 parameters |
| All | 536 | 536 | match: 630 moments minus 94 parameters |
| Held | 311 | 311 | match: 378 core moments minus 67 parameters |
| Implied Structure | 327 | 327 | match: 406 core moments minus 79 parameters |
| Implied Indicators | 326 | 326 | match: 406 core moments minus 80 parameters |

The general-factor rival constrains CTSE and CPSE's variances and covariance to one while freeing all higher-order loadings. This is observationally represented by a single unit-variance higher-order factor in our code. Relative to the freely correlated two-factor model, only one identified covariance parameter is removed. The difference in model degrees of freedom is therefore one, even though a separate printed difference-test sentence says two. This operational comparison does not rule out all possible general-factor or bifactor formulations.

## Are the numerical solutions stable and identified locally?

The independently computed covariance matrices agree to floating-point precision, and each separate numerical-gradient fit agrees in discrepancy to better than 1e-10. Every covariance-map Jacobian has full column rank; the smallest singular values range from approximately 0.225 to 0.496. All core residual covariance matrices and fitted observed covariance matrices are positive definite. The results support local identification and consistent optimization at these solutions, not a formal global-optimum guarantee.

The independent finite-difference gradients agree with the primary analytic gradients within 2.3e-7. The covariance-only zero-discrepancy fixtures pass below 1e-12. All tests are hard assertions in the script, rather than visual judgments based on optimizer messages.

## Why can unused indicators be profiled out?

The core-only likelihood equals the full likelihood after profiling unrestricted auxiliary observed covariances. Partition the observed matrix as

`S = [[A, C], [C', D]]`,

where A is the core covariance. For a fitted core covariance V, set

`K = inverse(A) C`, `Omega = D - C' inverse(A) C`,

and construct

`Sigma = [[V, V K], [K' V, Omega + K' V K]]`.

This construction holds the empirical auxiliary conditional regression and residual covariance fixed while varying the core covariance. The determinant is `|V| |Omega|`; the trace term is `tr(A inverse(V)) + q`, where q is the auxiliary count. Hence the full normal-theory discrepancy equals the core discrepancy. Adding `p*q + q*(q+1)/2` free covariance parameters offsets exactly the added covariance moments, leaving the same degrees of freedom. The script verifies the identity numerically for every external-factor model and checks that each full 35-variable observed covariance is positive definite.

This identity requires unrestricted *observed* auxiliary covariances, not a separately enforced latent residual covariance constraint. If the fitted full cross-covariances are assigned only to measurement residuals and all auxiliary-to-latent covariances are fixed to zero, the reconstructed full residual matrix is not positive definite for models with auxiliaries. The script records that diagnostic (minimum eigenvalues about -3.4 to -4.0). Consequently, the full-35 AIC comparisons are explicitly profile-likelihood sensitivity calculations, not a certification that all latent residual details or warnings in the original Mplus run were reproduced. Obtaining the original full output would settle its exact parameterization and warning status.

## Does changing the sample-size convention resolve the differences?

A common rescaling of the input covariance changes neither the discrepancy nor standardized model parameters. The script directly transforms the fitted parameters and checks that multiplying the matrix by 295/296 gives precisely the corresponding scaled fitted covariance and unchanged discrepancy. This addresses the usual conversion from an N-1 sample covariance to the N-denominator normal-ML covariance without generating any data.

Using 295, 296, or 308 as the discrepancy multiplier changes the resulting normal-theory chi-square and AIC contrast but does not recover the missing-data likelihood or robust correction. The [JSON output](../outputs/sem_verification.json) supplies all three calculations. For example, the refined 21-indicator model has chi-square 452.218 at N=296 and 470.551 at N=308, versus the published robust value 295.571. This is not evidence that either original inference is wrong: the data inputs, estimator, missingness treatment, and corrections differ.

## Software and reproducibility

Python, NumPy, SciPy, and pandas versions are copied exactly from the primary run into the verification output. NumPy was chosen for explicit covariance algebra and SciPy for a genuinely independent numerical-gradient optimization pathway. Sources are [CPython](https://github.com/python/cpython), [NumPy](https://github.com/numpy/numpy), [SciPy](https://github.com/scipy/scipy), and [pandas](https://github.com/pandas-dev/pandas). Neither R/lavaan nor the original proprietary Mplus 5.2 executable was present in the checked execution environment; this is a disclosed departure from the replication skill's preferred R-plus-SEM software workflow.
