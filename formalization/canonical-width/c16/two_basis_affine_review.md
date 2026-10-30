# Complete conditional-sector affine spans at point15

The complete fixed-pattern physical-basis analysis gives **rank 3583 in 3600 sector feature coordinates**, for both X and Z of anchors X[80,512], Z[186,433]. Exactly 17 affine dependencies remain. The same dimension holds for all 16 patterns and for the 11 positive patterns of the accepted nearest-lambda seed. Thus the seed's five zero masses create no further affine equalities. Point15 satisfies all17 exactly in each sector.

This is a complete affine-span result for the specified auxiliary conditional-basis relaxation. It proves neither target membership nor source feasibility. It also gives no lower bound on how many columns are needed to represent this particular target.

## Physical proof of the generators

Fix one pattern and one sector. Let W be the selected opposite anchors, and let F be the jointly independent forced zero-signature anchors. The zero pool has rank r=128−|W|. Pick a zero basis B=F∪C. In the quotient by span F, C is a basis of the contracted zero matroid. For each free zero element e, express its physical vector in B and discard the F coordinates. The resulting vector is its exact contracted representation.

A zero contracted representation is a loop. Otherwise, each nonbasis element e and each b∈C with nonzero representation coefficient give the literal basis exchange C−b+e. Join such pairs in a graph on the nonloop free elements. Its connected components are exactly the matroid components:

* Every represented vector uses basis coordinates from its graph component. The component spans therefore form a direct sum, and every contracted basis selects exactly the number ofC elements in eachcomponent.
* Every graph edge gives the real indicator differencee_e−e_b between two physical bases. A spanning tree generates the entire zero-sum subspace on a component.

Consequently the complete real affine hull is given by loops=0 and one fixed cardinality per component; forced F entries remain1. This includes coloops as singleton components. Each unforced owner bin is a rank-one uniform matroid and contributes the analogous sum=1 equation and a star of literal exchanges. A fixed owner bin contributes no differences. Combining a zero basis with one choice perowner gives a physical full basis because the owner evaluation signatures are distinct unit vectors.

For a pattern m, lift an exchange difference into the 3600 sector features by multiplying it by(1,m0,m1,m2,m3). At fixed nonnegative pattern masses λ, only positive-mass patterns contribute differences. The affine hull of their weighted Minkowski sum has direction span equal to the sum of these lifted spans. The support scaleλ_m>0 does not change a summand's direction span.

A potential v annihilates this sum precisely when its effective coefficient at each pattern is constant on every zero component and every free owner bin. Its value is then the exact weighted sum of the saved pattern-base values. This is a full characterization, independent of saved search columns.

## What the 17 equations are

For each sector, the saved17 independent null vectors have only coefficients 0/1; their supports are disjoint and partition all3600 coordinates. They consist of:

* Ten fixed coordinates: the two own anchors in each of the five blocksU,P0U,…,P3U.
* Five total counts on the remaining 718 coordinates, one perblock.
* Two further required-owner counts, one in each block conditioned on an opposite anchor. In those blocks the718 nonanchor coordinates partition by evaluation 0/1.

These are ordinary known anchor, cardinality, and owner identities. Every contracted zero matroid for these 32 sector/pattern domains is connected, with no loops. The sparse exact elimination has pivot width at most 4 and takes under 0.5 seconds per sector/pattern-set. There is no hidden decomposition into many small components here.

The source proof uses 10,504 X and 10,016 Z lifted forest/star exchanges for all patterns, or 7,617 X and 7,477 Z exchanges for positive λ patterns. Independent low-pivot physical reconstruction and GF(2) rank give lower bound 3583 over Q. The 17 independently checked annihilators give upper bound 3583 over R; together they establish equality exactly. Six tiny exhaustive matroid controls cover parallel elements, circuits, direct sums, loops created by contraction, and total contraction. Corrupted component ranks and corrupted annihilators are rejected for both sectors.

## Archive comparison and algorithmic consequence

The old 32x27 Wolfe archive has 356 positive columns. Its active sector GF(2) ranks are 356 for both sectors. All 7,600 saved columns have sector ranks 3473 (X) and 3445 (Z); adding 16 pattern rows gives 3480 and 3452. The other 27x32 archive has 366 positive columns and all 7,776-column sector ranks 3487 (X),3406 (Z). These are only sampled rational-rank lower bounds. Their missing directions are sampling effects, whereas the physical exchange construction proves the complete affine hull for the first quad.

For an inner master with 3600 feature equations and 16 fixed pattern-mass equations, one may remove 17 dependent feature equations after exact consistency checks. The retained 3616−17=3599 equality rows are still large. This analysis therefore rules out the hoped-for large affine reduction for the present seed. It does not rule out faster numerical conditioning, sparse pricing, inequality generation, or a small support certificate for a particular target. The parent five-variable outerλ formulation remains valid; it does not reduce the thousands of conditional allocation degrees of freedom by itself.

## Frozen evidence

* Candidate: `two-basis-results/two-basis-affine-components-32x27-point15.json`, SHA256 `94fe2f02225a2491e4bf0b2424893d9e91fbd95514c14ae5b0113122d1f1a6de`.
* Independent receipt: `two-basis-results/two-basis-affine-components-32x27-point15-independent.json`, SHA256 `25ea5d2ca321f5e1abc75e7d146e276f9886fc950e92eb694f85a7de168054b6`, status`PASS_EX ACT_COMPLETE_SECTOR_AFFINE_SPANS`.
* Producer: `two_basis_affine_components.py`, SHA256 `eb39f8c81df3f6baa1dd60603720e380493a917abd9f073b5b29939314d71d68`.
* Independent consumer: `two_basis_affine_verify.py`, SHA256 `957c2c580766d4cff4798113216ec80588e9c7d7752736e955a08d1ec4fb3d41`.
* Sample diagnostic: `two-basis-results/two-basis-affine-sampled-ranks-point15.json`, SHA256 `7d235a7a0ff199bdb3e142d8ba1c6a06d417cb8af6bb61372d9e30653bc44fd2`.

All earlier source and receipt bytes remain unchanged. No source case is excluded by this diagnostic.
