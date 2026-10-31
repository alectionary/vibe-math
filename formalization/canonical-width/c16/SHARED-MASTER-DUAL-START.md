# An exact dual-feasible starting basis for the shared phase-I master

The frozen master has 70,235 structural variables and 169,657 rows. All
structural variables are free in the LP bounds; nonnegativity is expressed by
explicit rows. The 46,080 artificial error variables occupy columns
24,155 through 70,234, with unit objective coefficients. Each has its own
row `sm_nonneg_<column>` containing only its negative, with upper bound zero.
These are rows 123,577 through 169,656 in the saved zero-based row order.

Write the LP in row-activity form `A x - r = 0`, with each activity `r[i]`
bounded by the corresponding original row bounds. Choose as basic variables
all 46,080 error columns and all 123,577 other row activities. Set every other
structural column nonbasic at zero, and every error-bound row activity
nonbasic at its upper bound zero.

Order the error-bound rows first, and the error columns first. The basis is

```text
B = [ -I   0 ]
    [  E  -I ],
```

where `E` consists of the error coefficients in the other rows. This matrix
is unimodular, so no numerical rank decision is needed to establish that it
is a basis. Its basic cost vector is `(1,0)`. The equation `B^T pi = c_B`
therefore gives exactly

```text
pi[error-bound row] = -1,
pi[every other row] = 0.
```

Every nonbasic free structural column has reduced cost zero, since it has
zero cost and no coefficient in an error-bound row. A nonbasic error-bound
activity has reduced cost `pi[i] = -1` and is at its upper bound zero.
For a minimization problem, these are the required reduced-cost signs.
Thus the basis is exactly dual feasible, with dual objective zero.

The basic primal is `x=0,r=0`; it generally violates the original nonzero
row bounds. This is a dual-simplex initialization, not a primal feasibility
or zero-error membership certificate. Degeneracy and floating perturbations
may still occur. No runtime improvement has been tested.

Two independent algebra reviews agreed on the block matrix, sign convention
and objective. The required structural row identities are already among the
full exact LP checks in `phase-one-v1-independent.json`. This note is an
ordinary linear-algebra proof; it adds no Lean completion or source exclusion.

The installed HiGHS 1.15.1 interface can express the basis using `HighsBasis`
and `setBasis`: error columns `kBasic`, other columns `kZero`, error-bound rows
`kUpper`, and other rows `kBasic`. Only the installed interface declarations
were inspected; no solver run using this basis occurred in this block.

The next bounded follow-up should check an exported basis against these exact
identities, then test dual simplex on the same immutable master. This directly
addresses the large sign/residual corrections in the saved primal-simplex
candidate. It does not justify enlarging the basis archive or predicting a
finishing time before that test.
