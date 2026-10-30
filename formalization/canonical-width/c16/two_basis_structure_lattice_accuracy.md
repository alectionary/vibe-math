# Raw-allocation lattice certificates for conditional rank membership

For one positive pattern massλ, letF be the selected zero anchors and letM/F be the zero-pool matroid after their joint contraction. Writey for the raw joint selector masses on free zero elements. Their exact total isλ times the contracted rank. Ifx is the marginal of a nonnegative physical contracted-basis mixture of total massλ, then for every subsetS,

    y(S) − λ rank_(M/F)(S) ≤ Σ_j max(y_j−x_j,0) = ε.

LetD be a common denominator ofλ and the free-zero massesy_j, letg be the gcd of their integer numerators overD, and letδ=g/D. Every rank defect lies inδZ. Therefore **ε<δ certifies every subset-rank inequality at once**. In normalized conditional coordinatesq=y/λ, the required positive error is less thanδ/λ. Both units are equivalent. Individual denominators ofq are not the correct quantities to compare against an unnormalized error.

Whenx andy have equal total mass, the positive error is half their L1 distance. Owner bins need no lattice argument: their exact nonnegative masses summing toλ already define probability simplices. Fixed zero anchors are removed by contraction; they should not inflate the free-zero denominator. The strict inequality is essential. For the rank2 physical matroid[1,1,2], the target(3/5,3/5,4/5) has positive error1/5 from the valid half-and-half basis mixture(1/2,1/2,1), yet violates the rank1 first-pair inequality by1/5.

This is the earlier all-subset rank-lattice argument from `RESEARCH-LESSONS.md`, specialized to a single conditional allocation. It is not a projected-moment membership theorem unless every pattern/sector is separately certified and the common exactλ and target allocation equations are already accepted.

## Actual accuracy for the original direct Z allocation

The original count/box allocation has now been independently rejected by24 physical rank rows in eight patterns. Hence no near-mixture certificate can establish its membership, regardless of arithmetic precision. The denominator audit is retained as a design diagnostic, distinct from a surviving allocation.

The actual primitive raw lattice gaps on each free-zero pool are approximately:

| Pattern | Raw gap δ | Proposed raw threshold after dyadic-pair recovery | Proposed normalized threshold |
|---:|---:|---:|---:|
|0|3.27e−44|3.59e−32|8.59e−32|
|1|2.02e−28|8.88e−16|9.90e−15|
|2|3.16e−30|4.44e−16|2.24e−14|
|3|4.04e−28|8.88e−16|3.81e−13|
|4|1.57e−33|4.32e−22|1.29e−21|
|5|1.62e−27|8.88e−16|4.97e−14|
|6|2.02e−28|8.88e−16|5.59e−13|
|8|4.20e−39|4.62e−27|8.90e−26|
|9|1.29e−26|8.88e−16|4.07e−14|
|10|3.16e−30|8.88e−16|4.07e−11|
|12|3.23e−27|8.88e−16|2.06e−14|

Exact fractions, input hashes, zero-free coordinate counts, and known strict rank violations are saved in `two-basis-results/two-basis-direct-Z-lattice-accuracy-original.json`. The last two columns are sufficient accuracy targets conditional on a successful new dyadic-pair recovery. They do not assert that such a recovery has yet been exported, that it passes the accumulated rank rows, or that a near-basis mixture has been found.

## Where smaller denominators can come from

The original direct recovery retained arbitrary binaryfloat free parameters, causing denominators of87–145bits. All six pair-pattern bucket right sides, however, lie on the2^50 dyadic lattice. The four extra local face fixes are zero coordinates at vector347. Thus one can attempt to round the free pair allocations to multiples of2^−50 and restore every pair bucket total with a unit-column pivot. The empty and singleton allocations are then derived exactly. Pivot choices and every box/rank inequality must be rechecked; this is a new allocation, not a representation-only change.

The target blocks impose different unavoidable denominator bounds on those derived coordinates. The conditional cross-sector blocksP0U andP1U have denominators2^50 and2^51. The same-sector blockP2U has common denominator

    2317462296252309831680 = 2^54 · 5 · 11 · 2339,

with only three nondyadic coordinates. TheP3U block has common denominator

    216502565798574183570997248
    = 2^58 · 3^2 · 17 · 29 · 31 · 43 · 127,

with nine nondyadic coordinates. The complete target denominator is

    27851972577157575845490940968960
    = 2^58 · 3^2 · 5 · 11 · 17 · 29 · 31 · 43 · 127 · 2339.

The empty pattern generally inherits this last denominator. Moving the nondyadic constants into different multi-pattern variables might distribute the arithmetic burden differently, but cannot remove it from the exact target. No such redesign is claimed here.

The practical conclusion is mixed. A careful lattice recovery could make eight of eleven local rank certificates comparable to the earlier exact near-mixture gates, with required normalized positive errors between about1e−11 and1e−14. The remaining three require approximately1e−21,1e−26,1e−31; ordinary binary64 optimization cannot by itself certify those thresholds. Exact arithmetic refinement, an exact local mixture, a stronger subset-specific lattice argument, or another complete matroid certificate would still be needed. The current rank-cut loop takes priority over this denominator experiment, because an allocation with a verified rank violation cannot pass any complete membership certificate.
