# Shared owner-flow bridge and next gate

For the event A_m of one fixed anchor pattern, write lambda_m=Pr(A_m), a_mi=Pr(A_m∩X_i), b_mj=Pr(A_m∩Z_j), and t_mij=Pr(A_m∩X_i∩Z_j). Only physical pairs with GF2 pairing1 are owner edges. A source frame has exactly one selected owner for every selected vector. Taking expectations of that pointwise identity gives sum_{j∈N(i)}t_mij=a_mi and its Z analogue. Summing over patterns gives T(i,j). This is a physical-event moment, so the canonical32-action bridge uses factor1, not16 or32.

Two events inside A_m give 0<=t_mij<=a_mi,b_mj and t_mij>=a_mi+b_mj-lambda_m. A forced-absent endpoint makes t zero. A selected different anchor competing for either endpoint's owner also makes t zero; the actual anchor-owner endpoint is never removed by that rule. These are pointwise source identities followed by expectation, with no assumption of independence or a particular anchor law.

For one chosen center, subtract the Fréchet lower bounds from its16×degree table. The remaining problem is nonnegative capacitated transportation with prescribed row and column sums. Its full min-cut criterion is necessary and sufficient, including edge-bound consistency and nonnegative residual margins. Thus the explicit table enforces every star cut for that center at once. Opposite-sector chosen centers share their actual t_mij cells. This adds a joint consistency requirement to the individual-star projections.

Generic strictness has an exact small witness. Use two patterns of mass1/2 and two disjoint K3,3 components. Every vertex has marginal1/6 and every allowed edge total1/18. In pattern0, componentA has X masses2/15 and Z masses1/15; componentB has X masses1/30 and Z masses1/10. Pattern1 contains the complementary masses. Every individual star is feasible: inA, X-centered t0=2/45 and Z-centered t0=1/45; inB use1/90 and1/30 respectively. Yet two chosen X and two chosen Z centers inA force their shared2×2 sum to be both at least7/45 and at most4/45. The gap1/15 proves strictness for this abstract interface. It is not a physical C16 example and makes no claim about satisfying C16 PSD, rank or triple families. Exact tiny witnesses are preserved in `two-basis-results/owner-star-extension-tiny-controls.json`.

Every added variable is a probability. The model's explicit lower row proves t>=0. Its modeled rows give the exact nonnegative combination

(t-a_mi)+(a_mi-lambda_m)+sum_{q≠m}(-lambda_q)=t-1.

The guard checks each constituent row and sum lambda=1. Therefore the prior residual-correction rule remains valid after a new proof: from p(target)+r*x<=0 and0<=x<=1 derive p(target)+sum min(0,r_j)<=0. An exact positive target gap still requires independent semantic reconstruction. Optional zero-tau pins are extra law assumptions and cannot be used to claim unrestricted target exclusion.

## Shared capacity lemma

Let C_X be the chosen X centers. For an unchosen Z_j, pointwise source ownership implies

sum_{i∈C_X∩N(j)} 1_{A_m}1_{X_i}1_{Z_j} <= 1_{A_m}1_{Z_j}.

At most one summand can be1, since Z_j has only one selected owner. Hence sum_i t_mij<=b_mj. The symmetric inequality holds at unchosen X_i using chosen Z centers. These are collective capacities; separate t<=b bounds do not establish them. Chosen vertices already have full star equality, and vertices incident to at most one chosen opposite center need no new row.

For X614/X281/Z51/Z83, nine unchosen Z and74 unchosen X vertices have two chosen opposite neighbors. Adding all16×83=1,328 capacity rows gives98,730 rows with the same22,481 variables. No zero-tau assumption is used. The less convenient582-row variant discards rows implied by structural zeros; the authorized version retains all1,328 for direct replay. Frozen first-version sources and LP are preserved.

## Bounded decision after exact acceptance

If the pinned-law flow model is infeasible, verify an exact semantic Farkas certificate first, then permit one unrestricted-law attempt by removing only the five pins. A pinned contradiction excludes that law, not the target. An unrestricted contradiction can yield a source-valid moment row; it still excludes a relaxation point rather than answering C16.

If the flow model is feasible, independently replay all rational masses and flows, then test the capacity version once. If that remains feasible, the next distinct gate is a bounded conditional matroid split for a chosen center/pattern, using selected and residual opposite-basis domains. A useful new cut should involve physical ranks beyond the neighbor-count constraints already enforced completely. Do not restart long sequences of individual star cuts on the same four centers. None of these feasible relaxations constructs a source frame.
