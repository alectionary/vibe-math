# One exact LP after the 64-column exchange batch

The enlarged orbit-15 archive at point 22 remains exactly infeasible. Its one
authorized signed-greedy pricing query found another missing physical basis,
so this is neither a global rank cut nor a membership certificate.

The LP used 3,225 distinct physical columns: the 3,160 columns solved in the
previous final round, its previously unsolved minimizing basis, and 64 newly
verified exchange bases. The 64 directions are independent within that batch;
independence modulo the old archive was not asserted.

SoPlex solved in 1.90 seconds. The independent consumer checked the exact
archive-only Farkas proof. Exactly one subsequent physical signed-greedy query
and its separate consumer both passed, returning a strictly negative affine
minimum. The full gate took 9.29 seconds and stopped without another LP.
The final distinction is **3,225 solved columns versus 3,226 discovered
columns**; the newest minimizing basis has not been tested in an LP.

All coefficients, source bindings, LP tokens, exact certificates and logs are
preserved under `two-basis-results/singleton-o15-batch64-point22`. The final
pricing receipt SHA256 is
`3f414289603aac205788eff8880a7f2dd43eae7f1b149c12dde8ad85540edd19`.
Every process used verified nice19 and one thread, with the solver's 60/90-second
limits and 2GB memory cap. There was no automatic continuation.

The old and new Farkas directions have different coefficients and scaling.
Their minimum values alone are not a comparable distance or progress metric.
The finite archive remains the only object proved infeasible; the underlying
conditional matroid law is still unresolved.
