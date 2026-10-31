# Shared-pattern conditional-basis formulation and exact gates

The 7211-feature two-basis relaxation has an exact structural decomposition: one common law λ on the 16 four-anchor patterns, and, conditional on each pattern, one sector basis law forX and one forZ. The two sector laws may be coupled by their product after conditioning. No compatibility between unanchoredX and Z vectors is asserted. Accordingly this is a necessary relaxation of a source frame, not a source-frame construction.

The retained features are1, the 4 anchor indicatorsP, their 6 pair products, all 1440 physical selectorsU, and the 4×1440 productsP_iU_j. All are literal physical features, with factor 1 in the owner-coordinate target. Each source frame supplies a deterministic pattern and a valid pair of conditional full bases; averaging gives this formulation.

## Exactly five outer variables

Let μ_T denote the anchor monomial moment for subsetT⊆{0,1,2,3}. The empty, singleton, and pair moments are fixed by the target: 11 values in order 0,1,2,4,8,3,5,9,6,10,12. The four triple moments and one quadruple moment τ have indices 7,11,13,14,15. Boolean Möbius inversion gives

λ_S = Σ_(T⊇S) (−1)^|T\S| μ_T = (Lμ_low)_S + (Cτ)_S.

The 16 pattern moment matrix is invertible and its 11 low rows have rank 11. Thus λ has exactly 5 free coordinates before additional feasibility conditions, with λ≥0 andΣλ=1. This does not imply the remaining sector allocation problem is five-dimensional.

At fixed λ, the two sector problems separate. LetK_s,m be the convex hull of legal full sector bases forpatternm, and letA_m lift a selector vector to(U,P0U,…,P3U). The exact fixedλ condition is

b_s ∈ Σ_m λ_m A_m K_s,m.

A common λ satisfying both sector conditions is equivalent to membership in the full auxiliary two-sided hull. Conditional products prove sufficiency. For λ_m=0, the corresponding conditional law is irrelevant.

For any rational sector potential a, define h_s,m(a)=max_(B∈K_s,m) a·A_m1_B by exact signed full-basis pricing. Then every feasible λ satisfies

a·b_s ≤ Σ_m λ_m h_s,m(a).

This is an exact necessary outer halfspace and is also part of a complete support characterization if all potentials are available. Failure at one λ excludes only that λ. A global point obstruction requires infeasibility of the common λ problem or direct global support pricing.

For exact nonnegative multipliers α on such sector halfspaces, put H_m=Σαh_m. If H C=0, then Hλ=(HL)μ_low, yielding the global inequalityΣαa·b_sector−(HL)μ_low≤0. More generally an exact Farkas combination with λ≥0 and the 11anchor equations gives the same valid lifting. Every finite infeasible five-variable outer system has a certificate using at most 6 rows, but this is a certificate-size statement, not a convergence or runtime guarantee. The helper`compose_outer_cut` rejects uncancelled high-moment coefficients.

## Complete local-box outer relaxation

For onephysical selector u, each pattern status is forced 1, forced 0, or free [0,1]. Its five target moments lie in the translated zonotope

Σ_forced λ_m a_m + Σ_free [0,λ_m] a_m,  a_m=(1,m0,m1,m2,m3).

For generator rank r, the complete affine equalities are the annihilator of the generator span. In coordinates on that span, every facet normal is orthogonal to r−1 independent generators. Enumerating those subsets, both signs, plus an annihilator basis therefore gives all facets, including rank 0/rank 1 cases. Zero segment lengths are covered by taking a positive-length limit; no assumption λ_m>0 is needed. Identical 16-status vectors may share normals and support coefficients, so a class can be compressed by taking the largest exact target left side. Grouping vectors merely by rank, sector, or orbit would not justify this compression.

This local-box model omits total cardinality, owner-bin joint masses, and rank inequalities. A free status can include an element that a fuller matroid analysis would force absent. It is deliberately an outer relaxation. The current producer explicitly rejects quads with excluded count patterns; broadening that domain requires a new implementation rather than silently reusing these rows.

ForX[80,512], Z[186,433] at point15,640 compressed rows exactly describe the chosen local boxes in the 5 higher moments. Independent replay reconstructed 1440 physical statuses,292 facet normals,20 annihilators and308,128 individual bounds. The exact maximum-margin candidate was feasible. Its margin is only on nonconstantτ rows; omitted constant tautologies and equalities preclude a claim of strict interiority of every box.

The exact nearest law to the old Wolfe pattern masses was then recovered by a 21-variable L1 LP (τ5 plus 16 absolute deviations) over 672 rows. Exact primal/dual verification gives optimum

821942168680404382544416007468624049 / 21101494433085539941844014613074542592.

All five higher moments are0; patterns 7,11,13,14,15 have zero mass. This law is only local-box feasible. A separately checked reweighting of 354 old physical basis-pair columns gives an exact phase-I feasible point with these masses and sector L1 errors 2.4256205439713474 (X),2.5332394762127604 (Z). The later normalized innerLP states reduce those exact errors to 0.8060971679222086 and 0.7456812646706585. Explicit signed errors make these feasible phase-I points, not target memberships or simplex-basis claims.

## Why the coupling is not generically implied by separate low-order tests

The exact tiny control uses rank 6 partition matroids on six parallel pairs in each sector. Four anchor bits A,B,C,D have means 1/2 and pair moments 1/4. AuxiliariesU,V have means 1/4. At t=3/4, AU=BU=AV=BV=7/32, CU=1/32, CV=7/32, DU=DV=1/8, UV=1/16. The full six-bit moment matrix is strictly PSD, all 20 Boolean triples have exact distributions, and all 36 positive physical singleton conditions admit full-basis product laws.

The X sector admits an even ABC-parity mixture with U=AB in its parity component; theZ sector admits an odd ABC-parity mixture with V=AB. The laws agree on the 11 low anchor moments. Nevertheless the universal binary inequality

CV−CU+AU+BU+AV+BV−AB−U−2V ≤ 0

has exact target gap 1/16, so no common-pattern joint law exists. Its truth table was checked on all 32 assignments of A,B,C,U,V. This proves a generic nonimplication by separate full-basis/singleton-rank/PSD/triple conditions. It does **not** prove nonimplication by every accepted C16-specific integer-form row; this five-event inequality could already be included in stronger families.

## Accepted artifacts and limits

`two_basis_structure.py` and`two_basis_structure_zonotope.py` are frozen reusable helpers. The independent receipts are:

* `two-basis-results/two-basis-structure-zonotope-32x27-point15-independent.json`, SHA256 `718d7f5fe1c55041a9adf88a530a5fb3f5bd97b2f09477ce896ecd0960c95d47`.
* `two-basis-results/two-basis-structure-nearest-32x27-point15-independent.json`, SHA256 `194f8493d3527eb36dbde35ef4a697a01de059bbcb3b875fbbce0442bd44c6a4`.
* `two-basis-results/two-basis-structure-controls-v2.json`, SHA256 `c123103305ed3f61cee6de8ef4a7d168a55486c9004e4108a9c108ee12132ac6`, includes 496 exact independent zonotope comparisons and 32 Möbius controls.

The complete physical affine analysis is in`two_basis_affine_review.md`: only 17 sector feature dependencies exist for this seed, leaving 3583 directions. Consequently the five-variable outer geometry is useful for certificate composition and shared-pattern consistency, but it does not collapse inner basis-allocation complexity. Current bounded inner searches have no accepted separating λ cut and no exact target membership. No source case is excluded, and cover405 remains unchanged.
