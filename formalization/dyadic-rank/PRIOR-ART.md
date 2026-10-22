# Prior literature for the dyadic rank support theorem

Checked October 21, 2026. **The rank/support converse follows from established representation theory. It should not be presented as a newly discovered mathematical theorem.** The repository supplies a checked Lean proof by direct matrix induction; priority for that proof method or its formalization has not been established.

The [follow-up Lean search and proof comparison](FORMALIZATION-AND-PROOF-COMPARISON.md) identifies no earlier matching Lean artifact in the searched sources and shows explicitly that our central descent step specializes Friedlander–Pevtsova's Proposition 2.2. The benefit of our presentation is its elementary matrix formulation and smaller prerequisite set; a new underlying proof principle is not established.

## An explicit earlier criterion

Eric M. Friedlander and Julia Pevtsova, *Representation-theoretic support spaces for finite group schemes*, American Journal of Mathematics 127 (2005), 379–420, DOI [10.1353/ajm.2005.0010](https://doi.org/10.1353/ajm.2005.0010).

In **Example 2.6, page 11 of the [author-hosted manuscript](https://sites.math.washington.edu/~julia/Preprints/ppt/ppt.pdf#page=11)**, the authors explicitly state that an algebra map from `k[u]/(u^p)` into the group algebra of an elementary abelian p-group is flat exactly when the image of `u` has a nonzero linear term in augmentation generators. They derive this from Proposition 2.2, a result about projectivity under commuting nilpotent perturbations, proved on manuscript pages 8–9. This gives the relevant conclusion after the translation below; the paper does not phrase it as a theorem about dyadic matrices.

The [erratum](https://sites.math.washington.edu/~julia/Preprints/ppt/erratum.pdf) requires the abelian subgroup scheme in the definition of a p-point to be unipotent. Our elementary abelian group algebra is local, so it meets this requirement. To accommodate an algebraically closed ground field in the source, extend scalars from F₂ to its algebraic closure. Matrix rank and whether a specified coefficient vector is zero are preserved.

David J. Benson's *Representations of Elementary Abelian p-Groups and Vector Bundles* restates the criterion in **Section 1.4, page 6**, in the [publisher's freely accessible excerpt](https://assets.cambridge.org/97811071/74177/excerpt/9781107174177_excerpt.pdf#page=6): flatness is equivalent to the image of `t` belonging to the augmentation ideal but not its square. The [publisher's record](https://www.cambridge.org/core/books/representations-of-elementary-abelian-p-groups-and-vector-bundles/B3B421580531B8565528B0A08381BDDC) lists print publication in 2016 and online publication in 2017. Thus this is established background predating the 2026 conjecture.

## Translation to the recorded conjecture

The following is our mathematical derivation from the earlier criterion, separate from the direct Lean proof.

Let `E = (C₂)^ell`, let `g_x` denote its element indexed by `x ∈ F₂^ell`, and put

$$f=\sum_x s(x)g_x\in kE.$$

Multiplication by `f` has entry `s(x+y)` in row `x`, column `y`, so its matrix in the group basis is exactly the dyadic matrix `D`.

Write `X_i = g_{e_i}+1`. Then

$$kE\cong k[X_1,\ldots,X_\ell]/(X_1^2,\ldots,X_\ell^2),
\qquad g_x=\prod_i(1+X_i)^{x_i}.$$

The constant coefficient of `f` is `p = Σ_x s(x)`. The vector of its linear coefficients is `m = Σ_x s(x)x`, exactly the sum of the support index vectors because the signature is binary. This is not the scalar sum of the signature entries.

In characteristic two `f²=p`. If `ell>0` and `rank(D)=2^ell/2`, then `p` cannot be one: that would make `D²=I` and give full rank. Hence `f²=0`, and `u ↦ f` defines a map `k[u]/(u²) → kE`.

For a square-zero linear operator on an N-dimensional space, rank N/2 means that every Jordan block has size two. Equivalently, the resulting module over `k[u]/(u²)` is free, hence flat. The earlier criterion therefore forces `f` to have a nonzero linear term. This says `m≠0`, which is precisely the recorded rank/support converse.

For even-weight signatures the criterion also gives the reverse implication. Do not drop that parity condition: a singleton signature at a nonzero index gives a full-rank permutation matrix despite having nonzero support sum.

## A second established route

[Kustin–Şega–Vraciu, Proposition 1.9](https://arxiv.org/pdf/1309.1186v2#page=6), in the 2015 arXiv version of *Minimal quasi-complete intersection ideals*, provides another route. An exact pair in a regular local quotient must have a lift product outside the maximal ideal times the defining ideal. With defining ideal `(X_i²)`, a putative half-rank element with zero linear term would be an exact self-pair whose lift square violates that condition. The detailed derivation remains in [STRUCTURAL-PROOF.md](STRUCTURAL-PROOF.md). This theorem is not a dependency of our Lean proof.

## What the search establishes

Targeted searches covered the paper title and arXiv identifier, dyadic rank/support converse terminology, exact zero divisors in quadratic complete intersections, and flat maps into elementary abelian group algebras. Exact dyadic terminology did not identify a separate published resolution. The equivalent group-algebra search did identify the explicit earlier criterion above, which suffices to rule out treating the mathematical conclusion as new.

This is a bounded prior-art investigation, not an earliest-priority determination. Earlier references cited by these sources may go further back. We have not established that the direct inductive matrix argument or a Lean formalization appeared previously, and do not claim either is the first. The group-algebra bridge in this note has been checked mathematically but is not an additional Lean formalization; the repository's general theorem remains independently checked through [Recursive.lean](DyadicRank/Recursive.lean).
