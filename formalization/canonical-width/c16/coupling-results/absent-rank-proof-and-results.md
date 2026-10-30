# Absent-anchor full-pool rank diagnostic

This bounded follow-up found no separating cut. It adds no source exclusion,
cover reduction, physical frame, or complete matroid-membership certificate.

For a full frame, condition on physical anchor a being absent. The selected
same-sector vectors form a128-element basis in the pool with a deleted. The
selected opposite-sector vectors form a128-element basis in the whole opposite
pool. For any subset K of the appropriate available pool, independence gives

    (1-A_a) sum_(j in K) Y_j <= rank(K) (1-A_a).

After cyclic/sector averaging, the necessary moment inequality is

    sum_(j in K) (p_(j//16) - B_(j%16)[a,j//16])
        <= rank(K) (1-p_a).

For the same sector B=S, the canonical K excludes physical index16a. For the
opposite sector B=T, no vector is deleted: absence of X_a does not imply
absence of Z_a. The same-anchor diagonal p_a-S_0[a,a] is zero. Merely removing
that term while keeping a rank that was computed with the anchor can weaken
the inequality; the independent finite screen recomputes deletion ranks.

The conditional target is divided by1-p_a only for numerical separation.
The exact exported cut has integer coefficients and does not divide by a
marginal. Its compiler uses

    M @ owner_vector <= r,

where the row adds+1 to each p_(j//16),-1 to the corresponding B entry, and
+r to p_a, with r=rank(K). In particular the RHS is r, not zero. The helper
`absent_anchor_rank_probe.matrix(certificates,replays)` returns an integer CSR
matrix, integer RHS, and metadata using the same36,495 owner coordinates as
the existing projected-row compiler. It consumes matching independent PASS
receipts. No existing producer, compiler, model, or ledger was modified.

The producer reuses the bounded weighted greedy-basis projection. Its
same-sector pool genuinely deletes the anchor before projection; conditioning
on absence is not approximated by projecting into a larger pool that still
contains the forbidden anchor. Each source deletion pool has physical rank128.
The exact conditional coordinates are nonnegative, at most1 after
normalization, and sum to128. These facts are checked again independently.

Two frozen runs used all90 representative queries,600 projection iterations
per query, and a600-second outer limit. Both completed all queries with zero
cuts: necessary0 in432.96seconds; necessary1 in446.57seconds. The latter point
subsequently failed PSD recovery and is retained only as a rejected-candidate
diagnostic. Neither numerical nonseparation nor a small projection residual
proves complete rank-polytope membership.

After the root supplied the fully accepted `witness2-rational.json.gz`, this
route did not run another iterative projection. It tested only the fixed262
distinct subsets already present in the saved rank banks, over the90 absence
queries. The independent consumer checks all23,580 resulting row instances
with exact integers/rationals, recomputes2,329 deletion ranks, and detects four
actual rank drops. All rows, including those four stronger deletion bounds,
pass. The maximum lhs-minus-rhs at witness2 is

    -94585352751105631 / 71494644084506624,

approximately-1.323. The same finite screen passes at necessary0 and
necessary1. Thus this fixed subset family has substantial slack at the
accepted point; it supplies no row for the next model.

Each independent replay reconstructs all518,400 physical pairings, checks
sector exchange and the cyclic phase generator, and verifies the linear maps
through rank128 graph sets. The compiler is compared against384 literal
32-action averages on arbitrary Boolean selections, including32 synthetic
rows covering both sectors, nontrivial phases, and full-cardinality rows.
Exhaustive tiny full-frame controls check28,720 absence-conditioned
inequalities. These controls validate the derivation and translation even
though the source probes produced no positive cut.

The stopping gate is reached: the full finite seed screen is exactly negative,
and both bounded broader probes are negative. No additional generic absence
optimization is warranted in this block. The whole-mask/full-opposite-basis
route and its checked forbidden-pair refinements have more direct evidence of
strengthening. Full source width16 versus18 remains open.
