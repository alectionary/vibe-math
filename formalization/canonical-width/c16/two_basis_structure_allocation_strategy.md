# Exact allocation certificates and the six-pair reduction

The conditional-sector affine dimension3583 does not require recovering one dense rational mixture of global feature columns. A sufficient and complete alternative certificate has three levels:

1. An exact common pattern lawλ satisfying the11 retained anchor moments.
2. Exact joint selector allocationsy_s,m,j=Pr(pattern=m and sector selectorj chosen), satisfying every retained moment equation, all forced/absent statuses, and all conditional cardinalities.
3. For every positiveλ_m and eachsector, an exact certificate that the zero-pool conditional marginal lies in the contracted zero-matroid base polytope. Each unit-owner bin only needs nonnegative probabilities summing to1.

Zero-basis laws and owner-bin laws can be multiplied within a pattern: evaluation signatures prove every resulting selection is a full physical basis. TheX andZ conditional laws can then be multiplied. Thus local certificates imply the desired auxiliary joint law; no unanchored cross-pair compatibility or source frame follows.

A local certificate may be a rational basis mixture, verified directly. Deleting marginal0 elements and contracting marginal1 elements is exact. A directly checked violated rank inequality rejects that particular allocation. An incomplete rank search cannot certify membership. The earlier exchange algorithm also applies to each contracted zero matroid; its complete no-path graph gives a valid rank cut, while a terminal exact mixture proves membership. The previously established path updates do not supply a finite or polynomial runtime guarantee, and restricted exchange graphs cannot justify a no-path cut.

This decomposes certificate verification and exact weight recovery into many smaller local tasks. It does not make rank separation trivial. In the saved v3 phase-I states, most conditional marginals have hundreds of fractional coordinates, and the exact conditional denominator can have71bits. Literal replication on a rational lattice would be impractical. The separate diagnostic`two-basis-results/two-basis-allocation-fractional-core-point15.json` records those counts and binds both states. They are known physical mixtures with nonzero target errors; these statistics are not properties of a recovered target allocation.

## An exact five-pattern correction

For fixedλ with positive masses on the empty pattern and four singletons, writeb0 andb_i for the720-vector target blocksU andP_iU. Given a physical allocationy, letd0 andd_i be the target minus current block residuals. Change only five allocations:

    y'_{2^i} = y_{2^i} + d_i,
    y'_0 = y_0 + d0 − Σ_i d_i.

Every retained sector moment becomes exact. If target and initial allocation obey the17 previously verified identities, these changes preserve all five patterns' cardinalities, own-anchor coordinates, and opposite-anchor owner counts. This is an affine correction only; nonnegativity and rank remain to be checked.

The accepted best L2 endpoint mixtures, converted from exact normalized binaryfloat weights, give exact affine corrections with53 negative coordinates forX and33 forZ, all in singleton patterns. No coordinate exceedsλ. Empty-pattern boxes and positive-support rank128 pass. These results reject only this correction, not the fixedλ target. The saved exact allocations and all residuals are in`two-basis-results/two-basis-five-pattern-{X,Z}-l2-point15.json.gz`; independent replay is separate. No local matroid solver was run on a negative allocation.

## Six pair patterns determine all allocation variables

The accepted nearestλ seed has zero mass on all patterns with at least three selected anchors. Its only positive patterns are the empty pattern, four singletons, and six pairs. Consequently retain only pair-pattern variablesz_m,j, m∈{3,5,6,9,10,12}, and define

    y_{2^i,j} = b_i,j − Σ_{pair m containing i} z_m,j,
    y_{0,j} = b0,j − Σ_i b_i,j + Σ_pair m z_m,j.

All3600 sector moment equations hold identically. Pair-pattern zero-component and owner-bin equations, together with the accepted target count/owner identities, imply the derived empty/singleton equations. For example, a singleton's total is128[p_i−Σ_{pairs containing i}λ_m]=128λ_{2^i}; for an opposite anchor its owner-neighborhood total similarly equalsλ_{2^i}. Own-anchor coordinates follow the11 low pattern moments and pair forced/deleted statuses. Singleton and empty patterns have no multibit signatures.

Thus exact pair affine equations plus boxes on every original and derived allocation are equivalent to the full count/box allocation system for this frozenλ. Generalλ with positive triples or quadruples requires retaining those additional multi-anchor patterns and using coefficients|m|−1 in the empty-pattern formula; it is outside this first frozen producer.

The local per-vector boxes may have a forced face. For a complete zonotope facet normalv satisfying exact equalityv·b_j=Σλ_m h_m(v), a free pattern withv·(1,m)>0 must havey_m,j=λ_m; a negative coefficient forces0. The new producer records these exact normals and signs. It eliminates those local forced-coordinate equations independently in blocks of at most six variables, then applies a normalized margin only to nonconstant remaining allocation coordinates. A zero optimal margin is not automatically infeasibility.

ForZ at point15, this yields3901 free variables,10 global pair-bucket equations,14980 sparse box inequalities, and4 additional local-facet fixes. The proposed numerical LP has no basis-column generation and no rank inequalities. Exact recovery rounds the local free parameters, corrects at most a10×10 rational subsystem to enforce global bucket totals, derives all16 allocations, and then checks every literal moment, source status, bucket mass, and box bound. A failed recovery is inconclusive. A recovered allocation still needs the separate per-pattern matroid membership gate.

The implementation is`two_basis_structure_direct_allocation.py`; its preparation artifact is`two-basis-results/two-basis-direct-Z-point15-prepare.frozen.json`. This is a smaller linear equality system than the prior3583-dimensional feature master, though it retains thousands of allocation variables and box inequalities. Its benefit must be measured rather than inferred from row count alone.

## Frozen-note erratum

The previously frozen`two_basis_affine_review.md` has a cosmetic status-label typo: `PASS_EX ACT_COMPLETE_SECTOR_AFFINE_SPANS`. The actual receipt and schema are `PASS_EXACT_COMPLETE_SECTOR_AFFINE_SPANS`. No frozen file bytes are changed by this erratum.
