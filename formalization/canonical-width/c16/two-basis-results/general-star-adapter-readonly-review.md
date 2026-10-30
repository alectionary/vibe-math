# Read-only review of the unrun general-star adapter

Reviewed `two_basis_joint_general_star.py` by reading its source. No adapter,
model, solver, import, array construction or numerical control was executed.
This is a mathematical/code review, not an independent certificate replay.
The adapter and its source files were not modified by the reviewer.

## Owner target mapping

The extension to `[1, canonical owner_vector]` is appropriate because a star
may contain T coordinates outside the original 7211-feature subset. The old
constant maps to index0; canonical owner coordinate j maps to index j+1.
`owner_expression` adds coefficients when several retained features map to
the same canonical moment. It preserves reduced-variable indices. Star T
coefficients use the same j+1 convention. The lifted allocation and lambda
expressions therefore retain the original semantics. The existing literal
feature/owner bridge remains a dependency of this conclusion.

## Semantic combinations and signs

Each modeled inequality is `p(owner)+r*x<=0`; equality rows equal zero.
Arbitrary exact equality multipliers and nonnegative exact inequality
multipliers preserve that direction. The numeric matrix uses `A=r` and
`b=-p(owner)`, matching the semantic expressions. Both numerical dual-ray
orientations may be tried, but only exact nonnegative inequality multipliers
and an exact positive target-row evaluation can yield a candidate. Solver
status or the numerical ray itself is not accepted as proof.

The primitive integer conversion is also correctly oriented: a resulting
constant c plus owner coefficients is at most zero, so the compiled owner
right side is -c. Positive denominator clearing and division by a positive
gcd do not reverse the inequality. The reported pre-integer exact violation
must be understood with its original normalization; an independent consumer
can recompute the primitive-row scaling.

## Interval correction

`probability_bound_guard` supplies the required semantic bounds, rather than
using solver variable bounds. All sixteen lambda nonnegativity rows and their
symbolic sum1 imply `0<=lambda_m<=1`. Each retained allocation variable is
literally a y coordinate with both modeled box bounds. Each tau variable is
symbolically the sum of the pattern masses containing its anchor subset.
Consequently every reduced variable lies in `[0,1]`.

For an exact row `p(owner)+sum_j r_j*x_j<=0`, the residual has lower bound

    L = sum_j min(0,r_j).

Therefore `p(owner)+L<=0` is a valid projected inequality. The code adds L to
the constant with the correct sign and retains the original residual in the
candidate record. This may weaken the row substantially; it does not assert
exact stationarity or that the interval bound is attainable jointly. A
nonzero residual with L=0 is still a valid corrected row and must retain
`exact_cancellation:false`.

## Scope and remaining controls

No apparent mapping, inequality-sign or interval-correction error was found.
The shared-law base model still requires its independent accepted receipt
before the adapter's solve mode is admissible. Every accepted star bank and
its source bindings must remain frozen. Any exported row requires a separate
exact consumer that reconstructs semantic combinations and the probability
bound proof; an int64-fit flag is not by itself an integration authorization.

When local computation is authorized again, useful small controls are:
duplicate feature-map coefficient coalescence; signed residuals with positive,
negative and zero coefficients; a nonzero residual with zero correction;
rejection of a missing probability box; both numeric ray orientations; and
agreement of the primitive integer row with the rational row. These are
proposed controls, not tests claimed to have run.

The model's numeric time limit does not bound matrix preparation or every
exact-combination operation. A future bounded launch should retain an external
wall-clock cap. No runtime or complexity claim is made here.
