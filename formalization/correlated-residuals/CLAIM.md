# Claim and answer contract

Canonical inventory ID: `L-F102-correlated-residuals`

Bounded follow-up: `RQ-F102-residual-identification`

This is a **new problem** in this repository, and a labeled restriction of an author-stated method request. The parent request stays open.

## Ownership

- Session ID: `c8f1c203-0ab7-4fd5-baca-667178087308`
- UTC start: `2026-10-27T07:30:56Z`
- Issue: https://github.com/alectionary/vibe-math/issues/13
- Work branch: `cursor/l-f102-correlated-residuals-4c01`
- Claim ref (intended): `refs/heads/claims/L-F102-correlated-residuals`
- Isolated checkout: worktree `/tmp/vibe-math-l-f102`, base `96ac6c493a4326d0575b7f1cd65e91f02d14de5c`
- Project board: not requested
- Study: authorized. This commit is preparation, not ownership. Ownership begins only after GitHub's create-reference call succeeds and is read back.
- Next action after a confirmed claim: freeze the source equations from Mi et al. (2010), write the formal identification statement, and check the diagonal case and one-edge residual extensions.

## Source

Xiaojuan Mi, Kent Eskridge, Dong Wang, P. Stephen Baenziger, B. Todd Campbell, Kulvinder S. Gill, Ismail Dweikat, and James Bovaird, *Regression-Based Multi-Trait QTL Mapping Using a Structural Equation Model*, Statistical Applications in Genetics and Molecular Biology 9 (2010), DOI 10.2202/1544-6115.1552. Public copy: https://www.ars.usda.gov/ARSUserFiles/60820000/Manuscripts/2010/Man850.pdf. Inventory hash `27c4f3926c9b5af9b399c9b3ef36918c28e7967ef777444b620279dd91628a81`. Discussion, PDF viewer p20 (printed p18).

Author request: extend the multi-trait QTL SEM analysis to correlated residual errors.

## Restricted question

After the source equations are frozen, fix the observed-trait dimension, the recursive structural pattern, the latent QTL or other exogenous terms, and the scaling normalization the paper uses. For the published diagonal residual class, and for each one-edge residual-covariance extension, decide whether the map from those parameters to the observed covariance is injective.

## Answer contract

**Question and source.** The 2010 method request, restricted to covariance identification of the frozen linear model.

**Intended answer.** Injectivity for the diagonal residual class, and either injectivity or an explicit two-point collision for each single residual covariance that the source pattern can free.

**Decisive evidence.** A written proof for every injective case, and an exact rational witness, recomputed independently of the generator that produced it, for every collision. The Lean interface is the same quantifiers. A concrete Lean certificate is the intended witness check. A general Lean proof is required before an injectivity case is called formally proved.

## Stopping condition

Record that decision for the source trait pattern, or record that the source equations do not determine a covariance map. Do not build an estimator, a missing-data extension, a mixed-outcome likelihood, a nonlinear model, or a dynamic-fit simulation. Do not merge to `master`.

## Prior repository status

Inventoried 2026-10-26 (issue #5, PR #6) only. No earlier proposal of this research block, no finite search, no partial proof, and no completed result.
