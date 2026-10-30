# Exact conic-dual recovery through physical squares

There is a source-valid route that avoids exact interval reconstruction of
Fourier PSD matrices. Approximate eigenvectors only propose integer affine
forms on the 1,440 physical Boolean selectors. Each proposed form is then
checked by the existing dense integer-form consumer, independently of the
eigendecomposition and trigonometric approximation.

For integer `L=c+sum_e w_e I_e`, the exact identity is

`L^2 = binomial(L,2) + binomial(-L,2)`.

Thus one square uses two existing accepted binomial rows with the same
nonnegative rational multiplier. Their summed <= row has marginal coefficient
`-(2*c*w_e+w_e^2)`, distinct-pair coefficient `-2*w_e*w_f`, and RHS `c^2`.
There is no extra factor 32 in the averaged owner row. The paired rows remain
valid for arbitrary distinct physical events and arbitrary integer weights;
rounding the proposal cannot invalidate them. A malformed row or overflowing
int64 matrix is still rejected by the existing consumer.

## Physical lifting factors and orientation

Expectation below means averaging a literal selector over the 16 phase shifts
and sector swap. Write `v_i,t = X_i,t + sigma Z_i,t` and
`H_k^sigma = sum_h exp(+2*pi*i*k*h/16) (S_h+sigma T_h)`.
Then `V_i=sum_t exp(-2*pi*i*k*t/16) v_i,t` satisfies
`E[V V*]=32 H_k^sigma`. This fixes the sine orientation in the exported real
block `[[Re H,-Im H],[Im H,Re H]]`.

| Exported quadratic form | Raw physical form | Exact expectation factor |
| --- | --- | --- |
| Mean block `u^T G u`, `u=(c,a)` | `L=32c+sum_i,t a_i(X_i,t+Z_i,t)` | `E[L^2]=1024 u^T G u` |
| Difference block `a^T D0 a` | `L=sum_i,t a_i(X_i,t-Z_i,t)` | `E[L^2]=32 a^T D0 a` |
| Frequency 8, either sector sign | `L=sum_i,t a_i(-1)^t v_i,t` | `E[L^2]=32 a^T H_8 a` |
| Frequencies 1–7, vector `(a,b)` | `L_R=sum(a_i cos-b_i sin)v_i,t`; `L_I=sum(-a_i sin-b_i cos)v_i,t` | `E[L_R^2+L_I^2]=32 (a,b)^T block (a,b)` |
| Frequencies 1–7, one real form | the same `L_R` | `E[L_R^2]=16 (a,b)^T block (a,b)` |

The last identity uses rotation invariance and `2k != 0 mod 16`. It must not be
used at frequency 8. In the trimmed mean and difference blocks, the omitted
orbit44 coefficient is padded by zero. Mean features are
`q_i=sum_t(X_i,t+Z_i,t)/32`, so `E[q_i]=p_i` and
`E[q_i q_j]=(sum_h S_h+sum_h T_h)/32`.

The finite controls reconstruct all 18 exported PSD slack matrices on four
literal selector assignments, check all lifting orientations, and check the
mean/difference identities exactly with rational arithmetic. The Fourier
controls use floating trigonometry as diagnostics; exact validity of a rounded
square depends only on the integer-binomial identity and the already checked
complete physical monomial map.

## Numerical dual translation

SCS uses lower-triangular column order, with off-diagonal entries multiplied by
sqrt(2), preserving the trace inner product. Decode each saved dual PSD vector
accordingly; divide off-diagonal entries by sqrt(2). The exporter ordering is
`G45,D044,(k=1,+),(k=1,-),...,(k=8,+),(k=8,-)`.
These conventions are documented in the [primary SCS cone documentation](https://www.cvxgrp.org/scs/api/cones.html).

For explicit input scaling `A'=D A, b'=D b`, the original dual is `y=D y'`.
Each PSD block must have a common positive scale, as in the current probe;
arbitrary independent PSD-entry scaling is not cone preserving. Public solver
dual conventions and eigenvalues are proposal data, never a certificate.

Under `A x+s=b`, a positive PSD dual gives `A^T y*x <= b^T y`. A lifted square
uses the same <= orientation: negative nonconstant square coefficients on the
left, constant square term on the right. If a cone eigenpair has eigenvalue
`lambda>=0`, a physical lift with expectation factor `F`, and its physical
coefficients are rounded after multiplication by `H`, use a nonnegative
rational proposal near `lambda/(F H^2)` on both binomial rows. For frequencies
1–7, `F=16` permits the single real form; using the two forms requires `F=32`
on each, not 16 on each.

Conic22 and linear22 have the same variables, owner map, and every inequality
row. Four forced-zero equation rows are permuted because their producer uses a
set. The new exact conic-to-semantic map records this permutation. Reusing the
old numeric equation positions without this remap is incorrect.

## Bounded recovery gate

1. Freeze the conic packet, dual, row scales, current semantic construction,
   and independent conic row map. Diagnose `b^T y` and
   `sum(min((A^T y)_j,0))-b^T y`; these floats are only screening data.
2. If there is a plausible contradictory direction, propose at most 16
   physical squares from positive cone eigendirections. Test at most two
   dyadic coefficient scales, for example `H=2^12` and `2^20`. Small rank is a
   heuristic budget, not a theorem. Selection should consider the resulting
   combined residual, not just retained eigenvalue mass.
3. Validate the at most 32 paired binomial rows with
   `verify_dense_integer_forms.py`. Rebuild the semantic model with their bank
   and receipt, producing a fresh semantic digest. Quantize equation weights
   freely and inequality/square weights nonnegatively to a common rational
   denominator; translate all positive normalizations and the equality remap.
4. Run `verify_semantic_linear_case_dual.py` on the complete exact combination.
   It accepts only `sum(min(c_j,0))-d > 0` in Python integer arithmetic.
   This automatically pays for omitted eigendirections, rounded physical
   vectors, rounded multipliers, and all remaining residual coefficients.
5. Stop if neither scale and the capped square set gives a positive exact gap.
   Record failure of this finite recovery attempt only. No fresh SCS run,
   larger square bank, or source exclusion follows automatically.

A real source contradiction must use zero artificial margins and the true
selected-case floor. The square rows themselves are universal, but a dual
combination using the floor excludes only that selected source case. It does
not exclude the other 404 cover cases or solve the source question.

## Current endpoint and stopping decision

The saved binaryscale1 endpoint is not a candidate infeasibility certificate:
`b^T y=+0.006354810049281401`, and the numerical residual-corrected gap is
`-0.5617106940180304`. Projecting its scalar dual to nonnegative values and its
PSD duals to numerical PSD matrices changes neither conclusion. The first 16
positive eigenvalues contain about 86% of total positive eigenvalue mass, but
that statistic does not bound certificate loss.

Accordingly this review did not generate square-cut candidates, run a new
solver, or attempt exact infeasibility acceptance. A future promising dual can
use the existing exact consumers directly. The present negative screen applies
to these unmodified endpoint multipliers, not every possible recombination.
