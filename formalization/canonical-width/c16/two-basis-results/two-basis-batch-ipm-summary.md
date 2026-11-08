# Single X-sector batch IPM gate

This bounded diagnostic produced no exact pattern-mass separator and no exact target membership result.

The model uses the frozen point15 quad X[80,512]/Z[186,433] and the exact nearest pattern-mass seed. It includes all 5,225 original archived X-basis columns from the eleven positive-mass patterns. The five zero-mass blocks are explicitly removed from the LP. There are eleven exact mass equations, 3,600 feature equations, and 7,200 signed feature-error variables: 12,425 variables and 1,654,025 nonzeros in total.

Before solving, the producer saves an exact strictly feasible phase-I point. Every basis within pattern m receives positive weight lambda[m]/n[m], and both signed feature-error variables receive one plus the corresponding positive or negative residual. This satisfies every equality exactly and makes every retained variable strictly positive. It proves feasibility of phase I with errors, not membership of the target in the basis hull.

The single HiGHS IPM call uses presolve and crossover off, a 120-second solver limit, and a separate 150-second process cap. It returned numerical `kOptimal` in 18.082 seconds after 33 IPM iterations; the full process took 19.725 seconds. The restricted phase-I objective was 1.30982255899825. Recomputed numerical mass/equality residuals were about 3.3e-16 and 9.7e-15, with nonnegative variable values.

The central feature-dual direction was rounded to exact integers and priced independently on all sixteen physical pattern domains, including the five omitted from the fixed-lambda LP. Its exact target-minus-support gap is negative; divided by 2^24 it is approximately −168.16024854114562. Therefore it provides no separating row. The apparent numerical optimum is not presented as an exact LP optimum, and the restricted column hull is not the full sector hull.

`verify_two_basis_batch_ipm.py` independently replayed all 5,225 physical basis columns and their deduplication order, all 12,425 exact matrix columns, the strictly positive rational phase-I start, and all sixteen final signed-prefix support bounds. The receipt is `two-basis-batch-ipm-X-nearest-point15-independent.json`. No additional sector, column-generation loop, or extension was run.

The gate shows that batch IPM avoids the original simplex initialization stall on this representation. It does not remove the column-coverage limitation: the old-archive restricted objective is larger than the feasible errors from later generated columns and the L2 aggregate search. No cover case, source frame, or width bound was resolved.
