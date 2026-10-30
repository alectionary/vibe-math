# Saved level sets give exact higher-rank obstructions

The frozen old point15 physical runs had exact basis-mixture endpoints at Z patterns 0,2,4,8 and capped valid intermediate mixtures at 1,3,5,6,9,10,12. The separate screen `two-basis-results/two-basis-level-upper-point15-independent.json` now proves a rank violation in every capped target. This rejects those particular conditional allocations. It does not reject the shared pattern law, point15, point22, or a source frame.

For any set S of free zero-pool indices and forced independent set F, a necessary raw-allocation inequality is

    sum(y_j : j in S) <= lambda * (rank(F union S) - |F|).

The screen forms every distinct saved level upper set, independently computes physical rank with low pivots, compares with high-pivot rank of the source-bound quotient vectors, and evaluates the exact rational gap. It does not trust the solver's label invariants. Closing S under its physical span inside the allowed zero pool preserves rank and increases or preserves the nonnegative left side. The three exact-mixture controls have no positive row. Three altered-row controls are rejected.

The seven strongest closed sets have (mask, size, contracted rank): (1,93,38), (3,10,8), (5,11,8), (6,6,4), (9,14,9), (10,7,5), (12,52,31). The screen records all 22 positive upper-set rows and seven closures, including exact gaps and source hashes. These higher ranks explain why the complete rank-at-most-three gate could pass while these allocations were infeasible.

The empty-level sufficient condition can be weakened when only one violation, rather than a maximum-defect set, is needed. Assume the maintained invariants: every surplus coordinate has level zero, and every fundamental circuit C(B,u) has minimum level at least level(u)-1. For an empty nonnegative level j, let S={u:level(u)>j}. Every coordinate of S has x_u<=g_u. For u in S outside a positive basis B, the circuit cannot meet a level below j and cannot meet level j, so it lies in S. Therefore B intersect S spans S, and x(S)=rank(S). Any deficient coordinate in S makes g(S)>rank(S), even if other deficient coordinates lie below j. A proposed early exit should still recompute and verify the literal rank gap.

Every capped saved state has deficient coordinates at level zero as well as above an empty level. The first empty level is 4 for mask1 and 3 for the other six. Thus the frozen solver's requirement that the empty level lie below *every* deficit prevented detection. Masks3,5,12 reached maximum level equal to their ground-set size. The immediate algorithmic improvement is early literal gap detection, before tuning warm starts or merely extending time caps. Original solver, endpoint, and receipt bytes remain unchanged.
