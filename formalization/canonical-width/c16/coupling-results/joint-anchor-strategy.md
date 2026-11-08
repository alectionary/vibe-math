# Joint-anchor audit and the next structural gate

This is an advisory result within `c16-coupling-20261030T0514`, under the
root's source claim. No source answer, cover reduction, full-anchor exclusion,
physical-frame improvement, paper acquisition, or formalization is claimed.

## Accepted finite result and attribution

The saved orbit32 functional uses one X anchor, X208 (S13), and eleven Z
anchors. All eleven physical Z vectors have rank11. For each of the4,597
unconditionally unexcluded orbit32 masks, the new consumer enumerates all
4,096 subsets of these twelve anchors. It checks X-mask/S13 independence,
Z-subset independence, at most one selected Z partner per selected X, and at
most one selected X partner per selected Z. This is18,829,312 explicit subset
checks. The producer's faster partition formula is not imported by the
consumer.

`joint-anchor-matched-exact.json` and its independent receipt certify a
projected moment inequality under those joint restrictions. The exact optimum
over the ten unconditional feature coefficients is also certified by rational
primal and dual solutions. A matched optimization retaining the older
independent-anchor hinges shows that the additional ownership gain is only

    22992947555376601097 / 70265881962174857871360

approximately0.000327228, with the original anchor forms held fixed. Most of
the gain over the older saved inequality comes from improving its coarse
feature coefficients. Joint ownership nevertheless strictly lowers43 mask
maxima and43 rotation-class bounds. The optimized joint inequality fails the
older independent-hinge upper bound by13/296, so its own joint proof is needed.

The root's recovered `necessary0-rational.json.gz` candidate satisfies the
original projected row with value approximately-0.000018724. It is excluded by
the optimized independent-hinge row with normalized value0.9973381764, and
by the joint row with normalized value0.9976653921. These are exact evaluations,
not a claim that the candidate passed every other family.

`joint-anchor-conditional-exact.json` additionally uses the independently
checked S13 conditional-profile predicate. That predicate permits2,754 of the
4,597 unconditional masks. Its bank and physical-witness replay are hash-bound
dependencies; the joint consumer reconstructs the table literally without
importing its producer. The resulting optimized row excludes the recovered
candidate with normalized value1.002110278. For these fixed anchor forms,
the matched conditional-hinge and conditional-joint feature optima are exactly
equal. The43 local joint improvements therefore provide no further optimized
objective gain after this particular S13 refinement. This negative attribution
result is preserved.

All comparisons divide coefficients and violations by the common anchor-form
scale:11,840 for the unconditioned joint row,6,720 for its matched hinge row,
and6,400 for the conditional row. Raw integer coefficients cannot be compared
without this normalization.

Retaining class averages rationally is preferable to rounding them upward.
Here the original predicate's exact constant-only gain is zero: at least one
class is already tight under its saved feature vector. Merely scaling that
same vector by16 cannot improve its constant. The larger gain requires
changing its other feature coefficients. With the stronger S13 predicate the
exact constant-only gain is1/4. The feature optimizations preserve class
averages exactly and recover rational optima, rather than assuming this
quarter-unit effect explains the whole improvement.

## The finite theorem actually used

Let P be the exact selected phase mask in one orbit. Let A be the vector of
selected anchor indicators. Let F(P) be rotation invariant and let
L_a(P)=c_a0+sum_h c_ah 1[h in P]. Let D(P) be any finite family of anchor
subsets containing the restriction of every full source frame with mask P.
Define

    B(P) = max_{J in D(P)} sum_{a in J} L_a(P).

For every frame, sum_a A_a L_a(P)<=B(P). If

    sum_{h=0..15} (F(hP)+B(hP)) <= 0

for every unexcluded mask, cyclic averaging yields

    E[F(P)] + sum_a E[A_a L_a(P)] <= 0.

The left side contains only first and second moments. No fixed auxiliary
profile weights are needed. The sector/phase source bridge is the already
checked32-action symmetry bridge; unconditional forbidden-mask validity is
the already checked orbit-profile dependency. For the conditional extension,
the S13 predicate's physical-witness replay is an additional dependency.

The partition shortcut is exact for this twelve-anchor set. Branch on S13.
Each eligible Z anchor pairs with either zero or one currently selected X.
Since all eleven Z anchors are independent, choosing any subset introduces no
further Z rank issue. Zero-pairing anchors contribute all positive weights;
each nonzero-partner bin contributes its largest positive weight. A selected
S13 is another partner bin and removes Z anchors pairing with it and a phase
simultaneously. The independent consumer checks these same conditions without
using the shortcut.

A direct compact extension adds terms d_ab A_a A_b. Their expectations are
already degree-two moment coordinates, while the per-mask maximum becomes a
quadratic optimization on only twelve Boolean variables. Terms such as
A_a A_b 1[h in P] would require third moments and must not be silently added
to the projected degree-two model. The already enumerated conditional local
family contains299,808 admissible mask/subset instances, making an explicit
finite hull or dual separation model a plausible bounded follow-up. No such
additional optimization was run in this audit.

## A stronger bridge: a full opposite basis conditioned on a mask

The most useful next lemma generalizes the checked one-anchor zero-pool face.
Let P={x_1,...,x_k} be an independent selected X subset in binary dimension n.
Partition the complete opposite source pool by

    e_P(z) = (x_1 dot z,...,x_k dot z).

Write K0 for the zero bin and Kh for the bin with evaluation equal to the h-th
unit vector. Any full opposite basis compatible with P contains exactly one
member of each Kh and n-k members of K0; it contains no other evaluation
patterns. Its K0 members are independent, so rank(K0)=n-k is necessary.

Conversely, if rank(K0)=n-k, choose any basis B0 of K0 and any z_h in each Kh.
Their union is a basis: applying e_P to a dependence first forces every
coefficient of z_h to vanish, after which independence of B0 finishes the
proof. Thus this conditional opposite-basis family is exactly

    bases(K0) x K1 x ... x Kk.

It follows that, for arbitrary rational weights w_z, its exact support value is

    maximum_weight_basis(K0,w) + sum_h max_{z in Kh} w_z.

The first term is an ordinary greedy matroid-basis oracle. Negative weights
must be retained because the cardinalities are exact; replacing it by positive
hinges loses this strength. Empty Kh or rank(K0)<n-k gives a new forbidden P.
This is only a basis compatible with P: it need not extend P to a full X frame
whose entire cross-Gram matrix is the identity.

For orbit32, k<=5. A narrow diagnostic would check K0 ranks and unit-bin
nonemptiness for all291 rotation representatives, then compare this exact
basis support with the current functional's local subset support. A no-gain
outcome on the fixed forms ends that diagnostic. It does not justify another
indefinite rank-bank loop.

A more substantial separation model can use every opposite pool vector with
cyclic-equivariant weights

    w_(o,t)(P) = alpha_o + sum_{h in P} beta_(o,h-t).

Its expected selected-basis weight is

    16 sum_o alpha_o p_o + 16 sum_(o,d) beta_(o,d) T_d[o,32].

Thus only existing degree-two coordinates appear. The support function is
rotation invariant, so only291 class representatives need exact oracle
evaluation, using the checked physical phase symmetry. Together with the ten
unconditional features there are775 coefficient positions before redundant
coordinates are removed. An LP or cutting-plane method could propose those
coefficients; greedy exact support evaluation and rational class correction
would certify every accepted row. This couples an entire orbit to a complete
128-vector opposite basis, rather than twelve independent anchor marginals.
It also enforces the complete conditional rank family for each P through the
basis oracle. This proposed model has not been implemented or solved here.

## What complete matroid separation would and would not settle

The existing residual/Frank-Wolfe separator only proposes threshold subsets;
its final nonzero gaps and distances do not certify membership. A more
decisive candidate-specific gate is exact basis decomposition using LP column
generation. For a selected same-sector anchor, the basis oracle contracts the
anchor. For a selected opposite anchor, it uses the already proved zero-pool
basis plus one nonorthogonal vector. A missing family also deserves explicit
attention: absent-anchor conditioning. Its target is

    (p_j - E[A_a A_j]) / (1-p_a).

For the same sector this belongs to the basis polytope with a deleted; for the
opposite sector it belongs at least to the ordinary basis polytope. The current
global rank producer conditions on selection only. Separate one-orbit absence
decompositions do not certify this full-pool condition.

Greedy pricing can be justified directly. Sort weights w_1>=...>=w_N. Every
rank-r basis has weight

    r w_N + sum_(k<N) (w_k-w_(k+1)) |B intersect prefix_k|.

Replace each intersection by the prefix rank. Greedy simultaneously attains
all these prefix ranks, proving optimality. Rational weights can be scaled to
integers. Therefore an accepted separating weight vector has an exact oracle
bound, and any violated weighted inequality yields a violated rank prefix.

A successful decomposition should save exact nonnegative rational basis
weights reproducing every coordinate. A separating result should save an
exact dual weight vector and exact greedy optimum. A stopped numerical master
or small residual is neither certificate. This gives a complete acceptance
test for the tested conditional basis polytope without enumerating every flat.
It does not synchronize the decompositions for different anchors, different
orbits, or the two sectors.

## Remaining source gap and stopping criteria

Neither pairwise-consistent orbit distributions nor exact conditional basis
decompositions automatically glue into a distribution on full source frames.
A source-specific gluing theorem is missing; no generic such theorem is valid.
Treating class weights or one-anchor decompositions as one global sample would
silently add the desired conclusion as an assumption.

The shortest obstruction path remains: add only independently proved projected
rows to the necessary model, then recover an exact dual certificate of its
infeasibility. Any surviving exact point certifies only that relaxation's
limitation. A constructive route still needs one full X basis whose uniquely
determined dual basis lies entirely in the Z source pool, followed by the
existing physical128-pair consumer. Sampling bases from separate decompositions
does not itself satisfy that condition.

The recommended next structural gate, if another point survives the newly
optimized bounds, is the whole-mask/full-opposite-basis support oracle above.
Its source lemma is elementary, pricing is exact, its projected coordinates
are explicit, and its candidate-specific failure can be certified. There is
no demonstrated finishing-time bound for the source problem.
