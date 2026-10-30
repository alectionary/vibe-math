# Complete selected owner-star flows

This is an unrun extended-formulation gate. It strengthens a finite shared-law relaxation, not the C16 source criterion. The five high moments remain free, all16 anchor patterns remain present, and voluntary zero-tau pins from an input solver wrapper are not copied.

Let A_m be the event for one of the16 assignments to the two fixed X and two fixed Z anchors. Write lambda_m=Pr(A_m), yX_mi=Pr(A_m and X_i selected), and yZ_mj analogously. For a chosen X probe i, its owner neighbors are N(i)={j: the physical GF2 pairing of X_i and Z_j is1}. The row total below applies only to this neighbor set. Over the entire opposite selected basis, the corresponding total would instead be128*yX_mi.

For every physical owner edge occurring in any chosen star, introduce one variable t_mij=Pr(A_m and X_i selected and Z_j selected). Deduplicate by the physical triple(m,i,j), not by an orbit-averaged target coordinate. Thus a chosen X_i star and chosen Z_j star share the same16 variables on their overlap, while distinct physical edges retain distinct variables even when symmetry gives them the same unconditional T coordinate.

The complete constraints are:

- 0<=t_mij<=yX_mi and t_mij<=yZ_mj;
- t_mij>=yX_mi+yZ_mj-lambda_m;
- t_mij=0 if an endpoint is a forced-absent anchor, or a selected **different** X anchor also pairs1 with Z_j, or a selected **different** Z anchor also pairs1 with X_i;
- sum_{j in N(i)} t_mij=yX_mi for every chosen X probe, and the analogous sum over X neighbors for every chosen Z probe;
- sum_m t_mij=T(i,j), once per physical edge.

The residual guard derives t_mij<=1 from an explicit nonnegative combination of existing modeled rows. It never suppresses the actual anchor-owner edge merely because an endpoint is an anchor.

## Source bridge and completeness

For a source frame, the selected X/Z pairing matrix is the identity after pairing owners. Each selected vector has exactly one selected opposite neighbor with pairing1. Multiplying that Boolean identity by1_{A_m} and taking expectations gives each row total. The column total is the unconditional physical pair moment. Existing32-action symmetry maps it to the canonical T coordinate with factor1. Fréchet bounds follow from two events inside A_m. The structural zeros follow from forced absence or the impossibility of two distinct owners for the same selected vector. These arguments hold for every anchor law; no target-specific high-moment pin is needed.

Fix lambda,y,T and one star. Set L_mj=max(0,yProbe_m+yOther_mj-lambda_m), and U_mj=min(yProbe_m,yOther_mj), with U_mj=0 on a structurally forbidden cell. Subtracting L reduces feasibility to an ordinary nonnegative capacitated transportation problem. Edge lower/upper consistency, nonnegative residual demands, total mass equality and all bipartite min-cut inequalities characterize it exactly. In original variables the cut condition for row subset M and neighbor subset J is

sum_{m in M} yProbe_m - sum_{j in J} T(i,j) - sum_{m in M,j notin J} U_mj + sum_{m notin M,j in J} L_mj <=0.

Therefore this polynomial formulation enforces the entire star-cut family for each selected center at once, including every active lower/upper branch. With shared cells across opposite-sector centers it additionally enforces edge consistency; it need not equal the mere intersection of the separate-star projections.

## Strictness: generic interface only

A rational two-pattern example proves that shared-edge consistency can strengthen separate stars. It is not a C16 physical instance or a point satisfying all C16 row families. Take two disjoint K3,3 owner components A and B on six X and six Z vertices. Each pattern has mass1/2. Every vertex has unconditional probability1/6; every allowed edge has T=1/18. In pattern0, X masses are2/15 on A and1/30 on B, while Z masses are1/15 on A and1/10 on B. Pattern1 supplies the complements to1/6. All conditional Fréchet lower bounds are0.

On A, eliminating the pattern1 cell gives t0 in[1/45,1/18]. Each X star separately has a feasible constant t0=2/45, while each Z star separately has t0=1/45. On B the interval is[0,1/30]; X stars use1/90 and Z stars use1/30. Hence every individual row and column star is feasible. But two chosen X and two chosen Z centers in A are incompatible: the shared2x2 sum must be at least2(2/15-1/18)=7/45 from the chosen rows, and at most2/15-2/45=4/45 from the chosen columns. The positive gap is1/15. The actual C16 centers are required to form a physical K2,2; whether the resulting extension rejects a current allocation or moment target is still untested.

## Exact target projection and residual guard

Every base variable is already proved to be a probability by the preserved base-prefix guard. Every new variable has an explicit modeled row -t<=0. Its upper bound is checked by the exact nonnegative combination (t-yX)+(yX-lambda_m)+sum_{q!=m}(-lambda_q)=t-1, using sum_q lambda_q=1. Each required row and variable index is checked. The old guard is called only on the original variable prefix; it is not applied unchanged to new metadata. Consequently all reduced coordinates x satisfy0<=x<=1.

Take any exact rational combination of equality rows with unrestricted multipliers and inequality rows with nonnegative multipliers. If it is p(owner)+r*x<=0, then p(owner)+sum_j min(0,r_j)<=0 is source-valid, since r*x is bounded below by that sum. This is a deliberately conservative projection. A target exclusion requires a strictly positive exact evaluation after correction and independent reconstruction of every multiplier and semantic row. An exact feasible extended point still certifies only this relaxation; it does not construct simultaneous full bases or their mutual identity pairing.

## Size and bounded next gate

For k chosen centers with degrees d_1,...,d_k and q edges joining chosen opposite-sector centers, there are E=sum d_i-q distinct physical edges and16E new variables. There are16k+E equality rows and64E plus at most16E structural-zero inequalities. The initial X614/X119/Z51/Z105 selection is preserved. The final selection from the newer refine1 exact cohort is X614/X281/Z51/Z83, with degrees80/164/162/166: E=568 and9,088 new variables. The prepared model has22,481 variables and is designed to stay below100,000 rows. The preparation summary is authoritative for exact cumulative row counts.

The next gate is independent review of the prepared rows, source bindings, literal mapping and tiny shared-flow controls. Only afterward should one bounded exact LP attempt be authorized. Stop on a verified feasible relaxation point, an independently verified exact target separator, or the stated time/memory cap. Repeated single-star cut rounds are unnecessary for these chosen probes. Unselected probes, full conditional matroid membership, and joint unanchored pairing remain outside this extension.
