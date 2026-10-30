# Shared-master solver diagnosis

The model remains the single immutable master in `phase-one-v1.json`:
70,235 variables, 169,657 rows, 1,057,219 nonzeros and 1,642 physical columns.
The independent exact preparation gate accepts its source rows, all columns,
LP text and explicit feasible phase-I seed. The five higher-moment pins are
absent. This note supplements the frozen two-hour contract without changing
any scientific input or expanding to a column-generation loop.

The first SoPlex run, with internal presolve disabled, reached its external
660-second cap. It returned no rational primal or dual solution. Its saved
`.bas` file has no `ENDATA` terminator and is incomplete; it is not a usable
basis certificate. The file is retained unchanged as failure evidence.

After an independently checked small presolve control, the second run enabled
internal presolve on the identical LP. It stopped at its internal time limit
after 654.567 seconds of total wall time. Maximum sampled RSS was 633,700,352
bytes. All four requested vectors were unavailable, including both floating
diagnostics. Neither run supplies a checked restricted optimum or a pricing
certificate. Displayed intermediate objective values are not accepted results.

At 22:46Z, a final diagnosed candidate-extraction attempt was authorized using
the already installed HiGHS library. It is capped at 300 solver seconds,
360 external seconds and 4 GiB sampled RSS, at niceness 19 with one numeric
thread. It uses a floating view of the same exact model, preserving its rows,
variable order, free bounds and objective. No new columns or source constraints
are added. A small format/solver control and input provenance are required.
The main attempt must finish by 22:56Z, leaving over an hour for exact checking
and preservation. There is no automatic retry after this attempt.

The purpose is to obtain candidate source multipliers, not to substitute a
floating optimum for an exact proof. Any available named decimal dual values
will be converted to exact rational numbers. Parent inequality multipliers
are made nonnegative explicitly; all resulting finite-variable residuals are
retained and bounded by independently proved source-row combinations. Only
full pricing of all 32 physical domains and exact moment projection can accept
a resulting owner inequality. A nonpositive exact gap is preserved as a
nonseparating result. The original exact-optimality path remains unchanged.

The original source problem stays open, with cover 405, physical partial frame
88/128 and zero complete source anchors excluded. No new Lean result follows
from these solver diagnostics.
