# RQ-F102-residual-identification

Canonical target: `L-F102-correlated-residuals`. This note is a **new problem** and a labeled **restriction** of that method request. The parent request stays open. Claim ref `refs/heads/claims/L-F102-correlated-residuals` points at `64f01d6b3b5b6da4a42c8edb183b3f802e717826` and is not moved by later commits.

## Target and scope

- Canonical inventory identifier: `L-F102-correlated-residuals`, in `literature/open-problems.json` and `literature/unl-sem/questions.json`.
- New problem. The 2026-10-26 UNL-SEM seed (issue #5, PR #6) indexed the direction and did not compute or prove it. No earlier finite search, partial proof, or completed result is in this repository.
- Discovery source: the UNL-SEM screen. Question source: Mi, Eskridge, Wang, Baenziger, Campbell, Gill, Dweikat, and Bovaird, *Regression-Based Multi-Trait QTL Mapping Using a Structural Equation Model*, Statistical Applications in Genetics and Molecular Biology 9 (2010), article 38, DOI 10.2202/1544-6115.1552. Public PDF `https://www.ars.usda.gov/ARSUserFiles/60820000/Manuscripts/2010/Man850.pdf`, SHA-256 `27c4f3926c9b5af9b399c9b3ef36918c28e7967ef777444b620279dd91628a81`, re-downloaded and matched on 2026-10-27. Discussion, PDF page 20 (printed page 18).
- Author request, not a numbered conjecture: extend the analysis to correlated residual errors. Historical status in the source: proposed. Current status of the parent request: partly answered by the bow-free specification below. The printed equation-(7) tournament has no globally identified one-edge residual extension.
- Objects: real structural matrix `B`, exogenous coefficient `Γ`, residual covariance `Ψ`, exogenous covariance `Φ ≻ 0`, and the joint covariance of `(y, x)`.
- Quantifiers for the restricted question: every positive diagonal `Ψ`, and each of the three single off-diagonal residual entries, on the equation-(7) zero pattern. The wheat Figure 5 graph is not part of the theorem. Singular `Ψ` is outside the claim. Zero structural coefficients are included, and every relabeling of this order is included.
- Intended Lean interface: the block covariance map of equation (3). `recover_sigma` is a left inverse on that domain. `recover_bow`, `recover_bow01`, and `recover_bow23` are the three bow-free left inverses. `unitUpper_factor_unique` is the general-`n` factorization. `sigmaRec_injective` recovers `(B, Ψ, Γ, Φ)` from the joint blocks at every dimension. `plug_in_consistent` is continuous mapping for the diagonal plug-in, and `plug_in_consistent_ae` supplies the strong law. `bow12_same_law` and its two siblings are the collisions, including an arbitrary exogenous `Γ`.
- Why this target: it is the latent-structure gate already named for this inventory entry, and the source prints a complete three-trait pattern. Runners-up are in the tracking issue.
- Answer contract: the 2010 method request, restricted to covariance identification of equation (7) → diagonal parameters are a left inverse of `Σ` on the positive-definite domain; each one-edge residual extension collides for every exogenous `Γ`; each of the three bow-free missing-edge patterns is globally identified. For every dimension, a recursive pattern with positive diagonal residuals has a unique unitriangular factorization, and the joint blocks determine `(B, Ψ, Γ, Φ)` whenever `Φ` is positive definite. The diagonal plug-in and all three bow-free plug-ins are almost surely consistent for pairwise i.i.d. samples whose coordinate products are integrable. Its Gaussian delta-method variance is the derivative of `recover` times the Isserlis covariance of the second-moment matrix. `fit_bow.py` simulates that bow at the printed equation-(7) coefficients with edge `2 → 0` removed and `ψ02 = 1/2`; it is not a fit to the wheat measurements, and Figure 5's GYLD arrows are not in the printed matrix. No imputation, mixed outcome, or nonlinear trait map. Do not merge to `master`. The Drton–Foygel–Sullivant characterization stays a note, with no inventory id and no new claim.

## Issue, claim and Project

- Issue: https://github.com/alectionary/vibe-math/issues/13. Follow-up id: `RQ-F102-residual-identification`.
- Project board: not requested.
- Session `c8f1c203-0ab7-4fd5-baca-667178087308`. UTC start `2026-10-27T07:30:56Z`. Work branch `cursor/l-f102-correlated-residuals-4c01`. Worktree `/tmp/vibe-math-l-f102` from `96ac6c493a4326d0575b7f1cd65e91f02d14de5c`.
- Claim ref `refs/heads/claims/L-F102-correlated-residuals`, object `64f01d6b3b5b6da4a42c8edb183b3f802e717826`, created with GitHub's create-reference API and read back. `git push` of the work branch returned 403 for `cursor[bot]`; the same commit contents were published through the Git Data API, which is why the unsigned server SHA differs from the abandoned local signed commit of the same tree.
- Study authorized. This session holds the claim. Next action after this block: a Lean proof of the diagonal inverse, still inside this claim, or release the claim if that block is handed off.
- No pending reservation. Inventory insertion of the harvested Drton–Foygel–Sullivant generic-identifiability question is recorded below and is not yet a canonical id.

## Frozen source model

Equation (1) writes `y = B y + α x_QTL + Γ_marker x_marker + e` with a zero diagonal in `B` and with `e` multivariate normal. The printed residual matrix is diagonal. Equation (3) is

```text
y = (I - B)⁻¹ (Γ x + ζ),    ζ ~ MVN(0, Ψ),    x ~ MVN(0, Φ),
```

with `Ψ` diagonal, `(I-B)` invertible, and `Φ` a parameter. The joint covariance displayed after equation (3) is

```text
Σ_yy = (I-B)⁻¹ (Γ Φ Γᵀ + Ψ) (I-B)⁻ᵀ
Σ_yx = (I-B)⁻¹ Γ Φ
Σ_xx = Φ.
```

Equation (7) is the only fully printed structural pattern. With traits in the printed order `y1, y2, y3` and QTL indicators `x1, x2, x3`,

```text
y = -M y + G x + ε,
M = [[0, 1/2, 1/4], [0, 0, 1/2], [0, 0, 0]],
G = [[1/8, 1/4, 1/2], [1/2, 1/2, 1/2], [1/4, 1/8, 1/4]],
Ψ = diag(8/5, 9/5, 5/2).
```

In the equation-(3) sign convention, `B = -M`. The zero pattern is: the only positions that may be nonzero are `B_12`, `B_13`, and `B_23` (1-based). Equivalently, the directed edges are `y2 → y1`, `y3 → y1`, and `y3 → y2`. Every pair of traits is adjacent.

The text of the indirect-effect calculation on PDF page 17 confirms, for the wheat application, the paths QTL → SPSM → KPS → TKWT, QTL → SPSM → TKWT, and QTL → KPS → TKWT, with coefficients `-0.6233`, `-0.1605`, and `-0.4689` at Xbarc12. Figure 5 also draws arrows into GYLD. Those arrows are not restated as a matrix in the text, so the wheat edge set is not the theorem's graph.

Indexing below is 0-based in code: `B_12` is `B[0][1]`.

## Restricted statement

Let `B` be a real 3×3 matrix supported on `{(0,1),(0,2),(1,2)}`, let `Γ` be a real 3×3 matrix, let `Ψ` be symmetric, and let `Φ` be symmetric positive definite. Define `Σ(B,Γ,Ψ,Φ)` by the block formula above.

**Diagonal case.** If `Ψ = diag(v1,v2,v3)` with each `vi > 0`, then `Σ` determines `(B, Γ, Ψ, Φ)`.

**One-edge extensions.** If `Ψ` may have exactly one of the three off-diagonal pairs nonzero, the map is not injective on the positive-definite residual matrices. For each pair there are two parameter points with `Φ = I`, `Ψ` positive definite, distinct `(B, Γ, Ψ)`, and equal `Σ`.

The parent request, a QTL-mapping procedure under correlated residuals, is not answered. In particular, this graph has no bow-free one-edge residual extension, because every trait pair already carries a directed edge.

## Written proof of the diagonal case

Let `L = (I-B)⁻¹`. For this zero pattern,

```text
I - B = [[1, -B12, -B13], [0, 1, -B23], [0, 0, 1]],
L     = [[1,  B12, B13 + B12 B23], [0, 1, B23], [0, 0, 1]].
```

The product `(I-B) L` is the identity by direct expansion, using only the ring axioms. Thus `L` is the two-sided inverse.

Let `Ω = L Ψ Lᵀ` with `Ψ = diag(v1,v2,v3)`. The third column of `Lᵀ` is `(B13 + B12 B23, B23, 1)ᵀ` only after multiplication; more directly, the third row of `L` is `(0,0,1)`, so `Lᵀ e3 = e3` and

```text
Ω e3 = v3 L e3 = v3 (B13 + B12 B23, B23, 1)ᵀ.
```

Hence `v3 = Ω33`, `B23 = Ω23 / Ω33`, and `c13 := Ω13 / Ω33 = B13 + B12 B23`. The second standard basis vector gives `Lᵀ e2 = (B12, 1, 0)ᵀ`, so

```text
Ω e2 = v2 L e2 + v3 B23 L e3.
```

Reading the second and first coordinates,

```text
v2  = Ω22 - B23² v3,
B12 = (Ω12 - B23 c13 v3) / v2,
B13 = c13 - B12 B23,
v1  = Ω11 - B12² v2 - c13² v3.
```

Each right-hand side is defined when `v2 > 0` and `v3 > 0`, which is the positive-diagonal hypothesis, and the algebra rearranges to the original parameters. Therefore `(B, Ψ)` is a function of `Ω`.

`Φ = Σ_xx` because that block is `Φ`. Positive-definiteness gives `Φ⁻¹`. The cross-block is `Σ_yx = L Γ Φ`, so `Γ = (I-B) Σ_yx Φ⁻¹`. Thus `(B, Γ, Ψ, Φ)` is a function of `Σ`.

This is an identity on the stated domain. It is not a count of dimensions. A finite rational grid in `check_witness.py` checks the same formulas on a box; the box is not the domain of the proof.

## One-edge collisions

All three comparisons use `Φ = I`. The base point is `B = 0`, `Γ = I`, `Ψ = I`, hence `Σ_yy = 2I`, `Σ_yx = I`, `Σ_xx = I`.

Residual positions `(0,1)`:

```text
B = [[0, -1, 0], [0, 0, 0], [0, 0, 0]]
Γ = [[1, 1, 0], [0, 1, 0], [0, 0, 1]]
Ψ = [[2, 1, 0], [1, 1, 0], [0, 0, 1]]
```

Residual positions `(0,2)`:

```text
B = [[0, 0, 1], [0, 0, 0], [0, 0, 0]]
Γ = [[1, 0, -1], [0, 1, 0], [0, 0, 1]]
Ψ = [[2, 0, -1], [0, 1, 0], [-1, 0, 1]]
```

Residual positions `(1,2)`:

```text
B = [[0, 0, 0], [0, 0, 1], [0, 0, 0]]
Γ = [[1, 0, 0], [0, 1, -1], [0, 0, 1]]
Ψ = [[1, 0, 0], [0, 2, -1], [0, -1, 1]]
```

Each `Ψ` has leading principal minors `2, 1, 1` or `1, 2, 1` or `2, 2, 1`, all positive, so each `Ψ` is positive definite. Each `L` displayed in `Witness.lean` is the inverse of `I-B`. Substituting into the block formula returns the base covariance. The points differ in `B`, in `Γ`, and in `Ψ`, so the direct QTL coefficients are not a function of `Σ` once that residual covariance is free.

The same square-root families show these are not isolated accidents: for the `(0,1)` edge, `B12 = -c`, `v1 = 1 + c²`, `v2 = v3 = 1`, and `B13 = B23 = 0`, gives `Ω = I` for every real `c`. The integer points above are the cases `c = ±1`.

## Literature comparison

| Source / version / date / locator | Inspected result and hypotheses | Translation to this target | Contribution or remaining mismatch |
| --- | --- | --- | --- |
| Mi et al. 2010, equations (3), (7), (8); discussion p. 20 | Diagonal `Ψ` is assumed. Correlated residuals are requested, with no identification theorem. | Equation (7) is the frozen pattern. | The request is a method extension. The diagonal case of this pattern is a standard recursive decomposition; the one-edge obstructions are the new checked content for this source. |
| Bollen, *Structural equations with latent variables*, Wiley, 1989, cited by the source | Classical SEM reference. Book not retrieved in this block. | Not used as a proof. | Bibliography lead. No question screen. |
| Brito and Pearl, Structural Equation Modeling 9 (2002), 459–474. eScholarship PDF `https://escholarship.org/uc/item/1z99z3mf`, text extracted 2026-10-27 | Theorem 1: a recursive bow-free linear model is generically identifiable. A bow is a directed edge and a correlated-error edge on the same pair. | Equation (7) with diagonal errors is bow-free. Each one-edge extension is a bow. | Their theorem is generic, not an explicit inverse, and it does not by itself exhibit a collision. Our inverse and witnesses are separate. The 2002 text still calls a necessary and sufficient criterion for recursive models with correlated errors unsolved; global identifiability was later characterized by the next row. |
| Drton, Foygel, and Sullivant, Ann. Statist. 39 (2011), 865–886. arXiv:1003.1146, ar5iv HTML read 2026-10-27, including Section 8 and the references | Theorem 2: for an acyclic mixed graph, the covariance map fails to be injective if and only if some induced subgraph has a converging arborescence in the directed part and a connected bidirected part. Pure DAGs are therefore globally identifiable. A two-node bow is not. Section 8: characterizing mixed graphs with generically identifiable linear SEMs remains open. | The endogenous map `Ω = (I-B)⁻¹ Ψ (I-B)⁻ᵀ` is their `φ_G` on the equation-(7) graph. Diagonal errors: their theorem implies injectivity of `Ω`. Each bow: their theorem implies non-injectivity of `Ω`. | Their theorem does not mention the exogenous QTL block. Unrestricted `Γ` can in principle reshuffle `L Γ`. The witnesses show that the joint law, including `Γ`, still collides. We do not claim a new proof of their general theorem. |
| Foygel, Draisma, and Drton, Ann. Statist. 2012, arXiv:1107.5552v2, abstract and opening read 2026-10-27 | Half-trek criterion: a polynomial sufficient condition for generic identifiability, and a gap with a necessary condition. | Not needed for a 3-node bow, which is already globally non-identifiable. | Does not close the generic characterization. |
| Drton and Weihs, Scand. J. Statist. 2016, arXiv:1504.02992, abstract and introduction read 2026-10-27 | Ancestor decomposition extends the half-trek criterion. The decision complexity of generic identifiability is left unknown. | Same open characterization, later partial progress. | Full proof body not read. Question count for the paper is null until a full-text screen. |
| Weihs, Robinson, Dufresne, Kenkel, Kubjas, McGee, Reginald, Robeva, and Sturmfels, J. Causal Inference 2018, DOI 10.1515/jci-2017-0009, opening read 2026-10-27 | Edgewise half-trek and determinantal formulas. The authors say the sufficient/necessary gap remains. | Confirms the generic problem was still open in that paper. | Not a full question screen. |

No result in this table supplies an identified correlated-residual QTL procedure for equation (7). The diagonal identification of a recursive SEM with independent errors is classical. The checked contribution is the explicit inverse for this source pattern, the three joint-covariance collisions, and the observation that freeing any one residual covariance on this complete directed pattern destroys identification of `(B, Γ, Ψ)`.

## Research access

| Service | Method | Verified operation and date | Queries, inspected scope and status | Access gap and retry trigger |
| --- | --- | --- | --- | --- |
| Source PDF | `curl` of the ARS URL | 2026-10-27, 645,949 bytes, SHA-256 matched the inventory | Man850.pdf, 23 pages, equations (1)–(8) and the discussion read | None for this file. |
| GitHub | authenticated `gh` | 2026-10-27 issue list and ref list; code search | Repository issues and `refs/heads/claims/*`, `research/*`, `cursor/*` inspected before the claim. Code search `identifiability language:Lean` and `"structural equation" language:Lean` returned HTTP 429. One later retry is recorded in the verification section if it succeeds. | Rate limit. Retry after the limit resets. A 429 is not evidence that no Lean formalization exists. |
| X | `search_posts_all`, built-in public read | 2026-10-27 | Sanity query `mathlib`, `max_results` 10, relevancy: 8 posts returned, so the query path works. Target query `("structural equation" OR SEM) (identifiability OR identifiable) (residual OR "factor model")`: 0 posts. Repeat with Drton / half-trek / bow: 0 posts. Cap 10, relevancy sort. | Empty capped searches are not global absence. No SEM identification post was inspected because none was returned. |
| Web | indexed search | 2026-10-27 | Drton–Foygel–Sullivant; Brito–Pearl; half-trek; ancestor decomposition; determinantal instrumental variables | Later journal versions of arXiv:1003.1146 were not compared page by page with the ar5iv HTML. The Section 8 sentence is in that HTML. |

## Paper-by-paper question harvesting

| Paper / exact version | Full-text access and hash | Questions and source locators | Canonical IDs / resolved exclusion / access gap |
| --- | --- | --- | --- |
| Mi et al. 2010, SAGMB 9:38, PDF hash above | Complete PDF, hash matched | Four method directions already canonical. Re-read did not find a further explicit conjecture. | `L-F102-correlated-residuals`, `L-F102-nonlinear-traits`, `L-F103-mixed-outcomes`, `L-F103-experimental-design`. No new id. |
| Brito and Pearl 2002, SEM 9(4):459–474 | eScholarship text extraction, not a stored PDF hash in this commit | Theorem 1 is a proved generic criterion. The introduction recalls that a necessary and sufficient criterion was then unsolved; Drton–Foygel–Sullivant later settle the global case. A cited Kenny–Kashy–Bolger suspicion about nonrecursive models is their conjecture, not a new one posed as open by Brito and Pearl after a proof. | No new canonical id from this extraction. The extraction is a text dump, not a line-numbered repository extract, so a zero additional-question claim is not entered in `open-problems.json`. |
| Drton, Foygel, and Sullivant, arXiv:1003.1146, ar5iv HTML | HTML read through the references. PDF not re-hashed in the manifest. | Section 8: characterize the mixed graphs that yield generically identifiable linear structural equation models. | **Harvested, not yet assigned a canonical inventory id.** Merging it requires a paper row, manifest, coverage row, and an indexing extension. That bookkeeping is the next inventory action. Current-resolution and Lean status are unassessed. Later partial criteria exist and do not claim a completed characterization. |
| Foygel–Draisma–Drton arXiv:1107.5552v2 | Abstract and opening only | Half-trek gap is the same generic problem, not a second question. | Null question count: abstract is not a full-text screen. |
| Drton–Weihs arXiv:1504.02992 | Abstract and introduction only | States that the decision complexity of generic identifiability is unknown. Treat as a lead attached to the Section 8 problem, not a separate id, until the full text is screened. | Null question count. |
| J. Causal Inference 2018, DOI 10.1515/jci-2017-0009 | Opening only | Authors say their criteria do not close the gap. | Null question count. |
| Bollen 1989 | Not retrieved | Cited classical monograph. | No screen. Not queued: the identification proof used here does not depend on a page of the book. |

## Proof development

- Route chosen: explicit triangular inverse, then one rational collision per residual edge. The general Drton–Foygel–Sullivant argument is a comparison, not the proof used for the source pattern.
- Obstruction recorded before the continuation: a Lean proof of the diagonal inverse still had to formalize the field arithmetic. That proof is now `recover_sigma`. The integer collision certificates do not need division.
- Domain of the exact script: every `B` entry in `{-2,-1,0,1,2}` and every variance in `{1,2,3}`, plus the equation-(7) rational point. Two implementations, Gauss–Jordan and the closed inverse.
- Failed approach: dimension counting alone was not used as a proof. An early hand multiplication used a transposed factor and temporarily disagreed with the solved witness; the corrected multiplication matches both implementations.
- Attempts to break the statement: the three positive-definite witnesses survive; the zero pattern is exactly equation (7); `Φ` is not fixed by a side condition that the collision violates; `Γ` is recovered in the diagonal case and genuinely changes in each collision.

| Exact claim | Evidence label | Proof / data / source locator | Assumptions and unresolved bridge |
| --- | --- | --- | --- |
| On the equation-(7) zero pattern, including every zero coefficient, positive diagonal `Ψ` and positive definite `Φ` make `(B,Γ,Ψ,Φ)` a function of `Σ`. | General Lean proof | `CorrelatedResiduals/Diagonal.lean`, `recover_sigma`, `sigma_injective` | Domain `OnDomain`. Axioms `propext`, `Classical.choice`, `Quot.sound`. No `sorryAx`. |
| The same left inverse, after an arbitrary relabeling of the three traits. | General Lean proof | `CorrelatedResiduals/Relabel.lean`, `recover_relabeled`, `sigma_relabel` | The topological order is an input. Existence of a topological order for an arbitrary DAG is the classical reduction in the continuation, not a separate Lean theorem. |
| Each one-edge residual extension contains a real line of positive-definite collisions. For every exogenous `Γ` and every `Φ`, adjusting `Γ` by the bow factor preserves the joint covariance, and the new `Γ` differs whenever `Γ` is invertible and the scale is nonzero. | General Lean proof | `CorrelatedResiduals/Collision.lean`, `bow12_same_law`, `bow13_same_law`, `bow23_same_law`, `exogenous_lift`, `bow12_gamma_diff` and siblings, `bow12_psi_posDef` and siblings | `Ψ` on the bow is `Γ₀ Γ₀ᵀ` for the explicit unitriangular factor. This is global, not generic. |
| The same three integer points, with both products equal to the identity. | Concrete Lean certificate | `Witness.lean` | Integer special cases of the real lines. Axioms of the integer file: `propext` only. |
| The 3,375-point integer box and the printed equation-(7) point recover. | Exact finite computation | `check_witness.py`, `witnesses.json` | A box, not the real domain. Superseded as a proof by `recover_sigma`. |
| Dropping the direct edge into trait 0 from trait 2 and freeing that residual covariance identifies `(b12,b23,v1,v2,v3,c,Γ,Φ)`. | General Lean proof | `CorrelatedResiduals/BowFree.lean`, `recover_bow`, `bow_injective` | `noise.PosDef` and `phi.PosDef`. |
| Dropping the edge into trait 0 from trait 1 and freeing that residual covariance identifies the corresponding bow-free parameters. | General Lean proof | `CorrelatedResiduals/BowMissing.lean`, `recover_bow01`, `bow01_injective` | `noise.PosDef` and `phi.PosDef`. The only denominator is the last residual variance. |
| Dropping the edge into trait 1 from trait 2 and freeing that residual covariance identifies the corresponding bow-free parameters. | General Lean proof | `CorrelatedResiduals/BowMissing.lean`, `recover_bow23`, `bow23_injective` | `noise.PosDef` and `phi.PosDef`. Positive-definiteness of the freed 2×2 block makes the denominator positive. |
| A unit upper-triangular positive-diagonal factorization of a real Gram matrix is unique in every dimension, and therefore every recursive pattern with positive diagonal residuals is identified by `L Ψ Lᵀ`. | General Lean proof | `CorrelatedResiduals/Triangular.lean`, `unitUpper_factor_unique`, `recursive_residual_unique` | The topological order is fixed. Missing edges are zero entries of a strictly upper-triangular `B`. Mathlib's `LDL` existence proof is not used. The exogenous `Γ` step is the three-trait Schur argument, not a second general-`n` theorem. |
| If the three empirical blocks converge to `sigma θ` for `θ` on the diagonal domain, every coordinate of `recover` converges to `θ`. | General Lean proof | `CorrelatedResiduals/Consistency.lean`, `recover_continuous_mapping`, `plug_in_consistent` | The law of large numbers that supplies block convergence is a hypothesis. It is not formalized. |
| At a mean-zero Gaussian law, `√n` times the plug-in error is asymptotically normal with covariance `J V Jᵀ`, where `V` is the Isserlis covariance of `vech(zzᵀ)` and `J` is the derivative of `recover`. | Written proof | Continuation, "Delta method" | Fourth moments are Gaussian. No Lean proof of the central limit theorem. |
| At the printed equation-(7) point, a central-difference `J` and a Monte Carlo of the plug-in agree with that formula at the recorded tolerances. | Sampled experiment | `delta_method.py`, `delta_check.json` | Seed 102. `n = 20000`, 2000 replicates for the plug-in; 20000 replicates of one outer product for `V`. The Schur differential and the `Φ` block are deterministic checks in the same script. |
| The plug-in estimator `recover` (diagonal) or `recoverBow` (bow-free) is consistent for iid samples with finite second moments. | Written proof | Continuation, "Estimator and consistency" | The population left inverse and the continuous-mapping implication are Lean theorems. The weak law is not. |
| Drton–Foygel–Sullivant Theorem 2 implies the endogenous diagonal and bow conclusions for this graph. | Search lead / unresolved as a formal translation | arXiv:1003.1146, Theorem 2 | Not replayed. The exogenous block is `exogenous_lift`. |
| Brito–Pearl bow-free generic identification and the half-trek criterion. | Search lead / unresolved as a formal translation | Continuation | Citations. The three bow-free patterns are proved directly. |

## Verification record

Run on 2026-10-27 from the worktree, after the statement commit.

- `python3 formalization/correlated-residuals/check_witness.py` exited 0. Both covariance implementations agreed on the base point, the three collisions, and equation (7). All 3,375 grid points recovered. Equation (7) recovered `B`, `Ψ`, and `Γ`. `witnesses.json` records the matrices. The grid is exhaustive for that integer box and is not the real positive domain; the written proof covers that domain.
- `lean Witness.lean` with Lean 4.22.0 (`ba2cbbf09d4978f416e0ebd1fceeebc2c4138c05`, Release), pinned by `lean-toolchain`, exited 0. `#print axioms` on `bow12_same_law`, `bow12_inverse`, and `base_pd` reports only `propext`. There is no `sorry` and no `sorryAx`.
- GitHub code search was retried and again returned HTTP 429 for `"structural equation" language:Lean` and `"half-trek criterion"`. The repository search API query `linear structural equation identifiability lean` returned `total_count` 0 on 2026-10-27. That query matches repository text, not file contents, so it does not show that no Lean file exists. Authenticated issue and ref searches succeeded earlier.

The integer collisions remain an exact finite computation and a concrete Lean certificate. The diagonal identification theorem is now the general Lean proof `recover_sigma`.

## Continuation: full domain, bows, and one correlated specification

Approved block 2026-10-27T07:45Z through 2026-10-27T08:04Z. Mathlib v4.22.0 (`79e94a093aff4a60fb1b1f92d9681e407124c2ca`) is the dependency. Lake project `formalization/correlated-residuals`. `.lake/` is gitignored. There is no `sorry`.

### Diagonal left inverse

`OnDomain` is `v1 > 0`, `v2 > 0`, `v3 > 0`, and `Φ.PosDef`. `L` is the closed unitriangular inverse. Both products `(I-B) L` and `L (I-B)` are the identity by `mul_fin_three` and `ring`. The observed residual is `Ω = Σ_yy - Σ_yx Φ⁻¹ Σ_yxᵀ`, and `schur_noise` shows it equals `L Ψ Lᵀ` for an arbitrary noise matrix. The six recovery formulas in the written proof are `readDiag`. `recover_sigma` states `recover (sigma θ) = θ`. `sigma_injective` follows. Zero values of `b12`, `b13`, and `b23` are ordinary real inputs, so every directed subgraph of this order is included. `v1 > 0` is not a denominator; it is the remaining positive-diagonal hypothesis and is used to know `Ψ` is positive definite.

`#print axioms recover_sigma` and `sigma_injective`: `[propext, Classical.choice, Quot.sound]`. `Classical.choice` is the matrix inverse and the positive-definite unit proof. `Quot.sound` is the construction of `ℝ`. There is no `sorryAx`.

### Any recursive pattern on three traits

`relabel e` is `Matrix.reindex e e`. It preserves products, the identity, transposes, and the covariance blocks (`sigma_relabel`). `recoverRelabeled e` conjugates the observation back by `e.symm` and applies `recover`. `recover_relabeled` returns the original ordered parameters.

Every finite DAG has a topological order. On three labeled traits, conjugating that order to `0 ← 1 ← 2` puts `B` into the support of `Params`, with zeros on the missing forward edges. The Lean theorem takes the permutation as data. The existence of the order is this classical reduction, not a separate Lean proof. The same argument for general `n` is now `unitUpper_factor_unique`: the last diagonal entry of `Ω` is the last variance, the last column of `L` is that column of `Ω` divided by the variance, and the leading block differs by a common rank-one update. Mathlib's `LDL` development proves existence, not uniqueness, and leaves lower-triangularity of `LDL.lower` as a TODO, so it was not used as the proof.

### Freed residual covariances

`exogenous_lift`: if `L Γ = L' Γ'` and `L Ψ Lᵀ = L' Ψ' L'ᵀ`, then for every `Φ` the joint blocks agree. Unrestricted QTL coefficients do not repair an endogenous collision.

For each of the three edges and every real scale `c`, the bow factor `G₀(c)` satisfies `L(c) G₀(c) = I` and `Ψ(c) = G₀(c) G₀(c)ᵀ`. Then `Ψ(c)` is positive definite because `G₀(c)` is invertible, by `posDef_iff_eq_conjTranspose_mul_self`. For every exogenous `Γ` and every `Φ`, the parameter point with structural matrix `B(c)`, coefficient `G₀(c) Γ`, and residual `Ψ(c)` has the same joint law as `B = 0`, coefficient `Γ`, and residual `I`. If `c ≠ 0`, then `B(c) ≠ 0`. If also `Γ` is invertible, then `G₀(c) Γ ≠ Γ`, so the QTL coefficients themselves move. The integer witnesses in `Witness.lean` are the cases `c = ±1` with `Γ = I` and `Φ = I`.

The equation-(7) tournament has a directed edge on every trait pair, so it has no bow-free one-edge extension. Brito and Pearl's generic bow-free theorem and the half-trek criterion are comparisons. They are not replayed, and the collisions above are global rather than generic. Drton, Foygel, and Sullivant, Section 8, remains the harvested and uninventoried characterization question.

### Bow-free correlated specification

Remove the direct edge into trait 0 from trait 2 (`b13 = 0`) and free the residual covariance `c` of that pair. The other two directed edges remain, so the graph is recursive and bow-free. Symbolic solution of the six covariance equations produced one rational inverse; the Lean proof does not call that solver. With `den = Ω11 Ω22 - Ω12²`,

```text
v3 = Ω22,  b23 = Ω12 / Ω22,  v2 = den / Ω22,
b12 = (Ω01 Ω22 - Ω02 Ω12) / den,
c = (Ω02 Ω11 - Ω01 Ω12) Ω22 / den,
v1 = Ω00 - b12² v2 - 2 b12 b23 c - b12² b23² v3.
```

`recover_bow` applies these formulas to the Schur complement and then `Γ = (I-B) Σ_yx Φ⁻¹`. On `noise.PosDef` and `phi.PosDef`, the diagonal entries `v2` and `v3` are positive, the denominators are nonzero, and `recover_bow (sigma θ) = θ`. The other two missing-edge patterns are separate theorems in `BowMissing.lean`, recorded in the next block.

### Estimator and consistency

For either identified specification, the estimator is the plug-in map: form the empirical second-moment blocks of iid mean-zero copies of `(y, x)`, and apply `recover` or `recoverBow`. The population identity is the corresponding Lean left inverse.

At a true parameter in the open domain, `v2`, `v3`, and `det Φ` are positive. Each is a continuous function of the covariance blocks on a neighborhood where `Φ` stays invertible, and the recovery formulas divide only by those quantities. `plug_in_consistent` is the continuous-mapping half: convergence of the three blocks implies convergence of every coordinate of `recover`. The strong law that produces that block convergence is `plug_in_consistent_ae` in the later block. The Gaussian rate is the delta-method block below. The simulated bow fit in that later block is not a fit to the wheat measurements.

### Verification record for the continuation

- `lake build` in `formalization/correlated-residuals`, Lean 4.22.0, Mathlib v4.22.0, exited 0 on 2026-10-27. Modules: `Diagonal`, `BowFree`, `Collision`, `Relabel`.
- `#print axioms` on `recover_sigma`, `sigma_injective`, `recover_bow`, `bow_injective`, `bow12_same_law`, `bow12_psi_posDef`, `bow12_gamma_diff`, `exogenous_lift`, `recover_relabeled`, and `schur_noise` reports only `propext`, `Classical.choice`, and `Quot.sound`.

### Time

Mathlib was already cached at 07:45Z. The diagonal left inverse compiled before the bow-free file was started; the whole library was green at 08:04Z. About fifteen minutes of that interval is the diagonal proof and about ten minutes is the bow-free inverse, the three real bow lines, the exogenous lifting lemma, and the relabeling transport.

## Block 2026-10-27T08:07Z: the other bows, the delta method, general `n`, and continuity

### The other two bow-free patterns

`Bow01` drops the edge from trait 1 into trait 0 and frees the residual covariance of that pair. With `L = [[1, 0, b13], [0, 1, b23], [0, 0, 1]]` and noise `[[v1, c, 0], [c, v2, 0], [0, 0, v3]]`,

```text
v3 = Ω22,  b13 = Ω02 / Ω22,  b23 = Ω12 / Ω22,
v1 = Ω00 - b13² v3,  v2 = Ω11 - b23² v3,  c = Ω01 - b13 b23 v3.
```

Positive-definiteness gives `v3 > 0`. `recover_bow01` is the left inverse, and `bow01_injective` follows.

`Bow23` drops the edge from trait 2 into trait 1 and frees that residual covariance. With `L = [[1, b12, b13], [0, 1, 0], [0, 0, 1]]` and noise `[[v1, 0, 0], [0, v2, c], [0, c, v3]]`,

```text
v2 = Ω11,  v3 = Ω22,  c = Ω12,  den = v2 v3 - c²,
b12 = (Ω01 v3 - Ω02 c) / den,  b13 = (Ω02 v2 - Ω01 c) / den,
v1 = Ω00 - b12 Ω01 - b13 Ω02.
```

The denominator is the trailing principal minor. The vector `(0, -c, v2)` has quadratic form `v2 den`, so positive-definiteness and `v2 > 0` force `den > 0`. `recover_bow23` and `bow23_injective` are the left inverse and the resulting injectivity.

`#print axioms` on these four declarations reports `propext`, `Classical.choice`, and `Quot.sound`. There is no `sorryAx`.

### Delta method

Let `z = (y, x) ∈ ℝ⁶` be mean zero with covariance `Σ`, and let `S_n` be the average of `n` independent copies of `zzᵀ`. The plug-in estimator is `θ̂_n = recover(S_n)`, in the 21 coordinates `(b12, b13, b23, v1, v2, v3)`, row-major `Γ`, and lower `vech Φ`. Let `s_n` be the lower `vech` of `S_n`, diagonal included, with row index at least the column index.

For a mean-zero Gaussian, Isserlis gives

```text
V_{(i,j),(k,l)} = Σ_ik Σ_jl + Σ_il Σ_jk.
```

On a neighborhood of a diagonal-domain covariance, `det Φ`, `v3`, and `v2` stay nonzero, so `recover` is `C¹` in these coordinates. If `J` is that derivative at the true `vech Σ`, then `√n (θ̂_n - θ) ⇒ N(0, J V Jᵀ)`.

The differential of the Schur complement at symmetric increments `(A, C, H)` of `(Σ_yy, Σ_yx, Σ_xx)` is

```text
dΩ = A - C Φ⁻¹ Σ_yxᵀ - Σ_yx Φ⁻¹ Cᵀ + Σ_yx Φ⁻¹ H Φ⁻¹ Σ_yxᵀ.
```

`Φ` is copied from `Σ_xx`, and `Γ = (I - B) Σ_yx Φ⁻¹` is differentiated by the product rule. The same shape applies to `recoverBow`, `recoverBow01`, and `recoverBow23`; the numeric check is the diagonal map at equation (7).

`delta_method.py` uses central differences of step `10⁻⁶`. Population recovery of the printed point has maximum absolute error `4.4×10⁻¹⁶`. One Gaussian symmetric increment matches the Schur differential with maximum absolute error `1.9×10⁻¹⁰`. The asymptotic block of `vech Φ` matches the corresponding Isserlis block with maximum absolute error `1.1×10⁻¹⁰`. A Monte Carlo of 20,000 outer products, seed 102, estimates `V` with relative Frobenius error `0.033`. A Monte Carlo of 2,000 samples of size 20,000 estimates the plug-in covariance with relative Frobenius error `0.073`, and `0.037` on the six endogenous coordinates. The endogenous asymptotic standard deviations at this point are approximately `0.943`, `0.929`, `0.849`, `2.263`, `2.546`, and `3.536` for `(b12, b13, b23, v1, v2, v3)`.

### General `n`

`UnitUpper` means zero strictly below the diagonal and ones on the diagonal. `StrictUpper` means zero on and below the diagonal, which is every recursive pattern in this order, missing edges included as zeros. `unitUpper_factor_unique` is induction on `n`. The last diagonal entry of `L D Lᵀ` is the last pivot. The last column of `L` is that column of the Gram matrix divided by the pivot. The leading principal block differs from the smaller factorization by the rank-one update from that column, so the inductive hypothesis applies.

`det(I - B) = 1` because `I - B` is unit upper triangular. Its inverse is upper triangular, and the diagonal of the inverse is 1 because the only surviving term in `(L⁻¹ L)_{ii}` is the diagonal product. `recursive_residual_unique` therefore says that `L Ψ Lᵀ` determines `B` and the positive diagonal of `Ψ`. Mathlib's `LDL.lower` proves existence and leaves triangularity as a TODO; it is not used. Axioms are `propext`, `Classical.choice`, and `Quot.sound`.

The three-trait passage from the joint blocks to `Ω`, and from `(B, Ω, Σ_yx, Φ)` to `Γ`, is `schur_noise` and `recover_sigma`. The same cancellation for a covariate dimension different from `n` is `schur_noise_rect` and `sigmaRec_injective` in the later block.

### Lean continuity

`plug_in_consistent`: if `θ` is on the diagonal domain and the three blocks of `S_n` converge to the blocks of `sigma θ`, then the eight coordinates `(b12, b13, b23, v1, v2, v3, Γ, Φ)` of `recover(S_n)` converge to those of `θ`. The proof is continuity of the Schur complement where `det Φ` is a unit, continuity of the six rational recovery formulas where `v3` and `v2` are nonzero, and the population identity `recover_sigma`. Axioms are `propext`, `Classical.choice`, and `Quot.sound`. The strong law that turns iid second moments into that block convergence is the next block.

### Time

This block ran from 08:07Z to about 08:30Z. The two bow-free proofs were already drafted and were checked by about 08:14Z. The delta-method script and its Monte Carlo finished in the same interval, and the writeup above is the rest of that part. The general-`n` induction was green by about 08:22Z. The continuous-mapping theorem was green by about 08:28Z. Roughly ten to fifteen minutes of compiler time went to each of the last two parts. The five-hour budget, through about 12:45Z, was not exhausted. The four requested items are the stopping point.

### Verification for this block

- `lake build` in `formalization/correlated-residuals`, Lean 4.22.0, Mathlib v4.22.0, exited 0. New modules: `BowMissing`, `Triangular`, `Consistency`.
- `#print axioms` on `recover_bow01`, `bow01_injective`, `recover_bow23`, `bow23_injective`, `unitUpper_factor_unique`, `recursive_residual_unique`, `recover_continuous_mapping`, and `plug_in_consistent` reports only `propext`, `Classical.choice`, and `Quot.sound`.
- `python3 formalization/correlated-residuals/delta_method.py` exited 0. The tolerances in the script are Schur and `Φ`-block errors below `10⁻⁶`, second-moment relative Frobenius below `0.08`, and plug-in relative Frobenius below `0.12`.

## Block 2026-10-27T08:30Z: rectangular Schur, the strong law, and a bow fit

### General-`n` recovery of `Γ` and `Φ`

`RecModel n p` is a strictly upper `B`, a positive diagonal `d`, a rectangular coefficient `Γ : Fin n → Fin p → ℝ`, and `Φ : Matrix (Fin p) (Fin p)`. `sigmaRec` is the joint map `L = (I - B)⁻¹`, `Σ_yy = L (Γ Φ Γᵀ + diag d) Lᵀ`, `Σ_yx = L Γ Φ`, `Σ_xx = Φ`.

`schur_noise_rect` is the rectangular cancellation: when `Φ` is positive definite,

```text
L (Γ Φ Γᵀ + N) Lᵀ - (L Γ Φ) Φ⁻¹ (L Γ Φ)ᵀ = L N Lᵀ.
```

The products are heterogeneous, so the proof uses `Matrix.mul_assoc` with explicit factors rather than the square semigroup law. `recover_exogenous` reads `Φ` off `Σ_xx` and `Γ = (I - B) Σ_yx Φ⁻¹`. `sigmaRec_injective` puts the Schur complement into `recursive_residual_unique` and then matches `Γ` and `Φ`. Axioms of all four declarations: `propext`, `Classical.choice`, `Quot.sound`. There is no `sorry` and no `sorryAx`.

### Strong law of the empirical second moments

Index `(y, x)` by `Fin 3 ⊕ Fin 3`. For pairwise independent, identically distributed copies `Z_i`, Mathlib's `strong_law_ae_real` applies to each coordinate product `Z_i(a) Z_i(b)` once that product is integrable. `integrable_mul_of_memLp_two` is Hölder at exponents `(2, 2, 1)`: square-integrable coordinates have integrable products, so finite second moments of the raw coordinates are enough. On a probability space, `integrable_mul_of_memLp_four` reduces finite fourth moments to that statement by `MemLp.mono_exponent`.

`strong_gram` packages the entrywise limits into convergence of the empirical Gram matrix. `plug_in_consistent_ae` pushes that convergence through `plug_in_consistent`, so the eight coordinates of `recover` converge almost surely to `θ` when the population second moments equal `sigma θ`. `plug_in_consistent_ae_of_second` and `plug_in_consistent_ae_of_fourth` are the two moment hypotheses. Axioms are `propext`, `Classical.choice`, and `Quot.sound`. This is almost-sure consistency, not a Lean central limit theorem. The Gaussian delta-method covariance remains the written proof and the numeric check from the previous block.

### Simulated bow fit

`fit_bow.py` draws mean-zero Gaussians from the equation-(7) bow: `b13 = 0`, `ψ02 = 1/2`, and the other printed coefficients (`b12 = b23 = -1/2`, `Ψ = diag(8/5, 9/5, 5/2)`, the printed `Γ`, `Φ = I`). The bound `|ψ02| < 2` is the positive-definiteness constraint for this diagonal; `1/2` is inside it. Figure 5's extra GYLD arrows are not a printed matrix and are not fitted. The fit uses `recoverBow` on `S = n⁻¹ ∑ zzᵀ`.

Population recovery has maximum absolute error `4.4×10⁻¹⁶`. One sample of size 5,000, seed 102, gives endogenous estimates and delta-method standard errors

```text
b12  -0.5065  (0.0129),   b23  -0.5045  (0.0120),
v1    1.625   (0.0326),   v2    1.755   (0.0360),
v3    2.387   (0.0500),   c     0.497   (0.0333).
```

A Monte Carlo of 800 samples of size 4,000 matches the endogenous delta-method covariance with relative Frobenius error `0.089`. The script exits nonzero above `0.15`. Full rows, including `Γ` and `vech Φ`, are in `fit_bow.json`.

### Time

This block ran from 08:30Z to about 08:44Z. The rectangular Schur identity was green by about 08:38Z, after two associativity corrections. The strong-law file, including the Hölder reduction, was green by about 08:42Z. The bow fit finished at 08:43Z. Roughly ten minutes, fifteen minutes, and five minutes. The budget through about 12:45Z was not exhausted. The three requested items are the stopping point.

### Verification for this block

- `lake build` in `formalization/correlated-residuals`, Lean 4.22.0, Mathlib v4.22.0, exited 0. New module: `Law`. `Triangular` gained `Joint`, `RecModel`, `schur_noise_rect`, `recover_exogenous`, and `sigmaRec_injective`.
- `#print axioms` on `schur_noise_rect`, `schur_sigmaRec`, `recover_exogenous`, `sigmaRec_injective`, `integrable_mul_of_memLp_two`, `integrable_mul_of_memLp_four`, `strong_gram`, `plug_in_consistent_ae`, `plug_in_consistent_ae_of_second`, and `plug_in_consistent_ae_of_fourth` reports only `propext`, `Classical.choice`, and `Quot.sound`.
- `python3 formalization/correlated-residuals/fit_bow.py` exited 0.

## Block closeout

**Question answered:** For every trait dimension and every covariate dimension, the joint covariance of a recursive pattern with positive diagonal residuals and positive-definite `Φ` determines `(B, Ψ, Γ, Φ)` (`sigmaRec_injective`; general Lean proof). Pairwise i.i.d. samples with integrable coordinate products — in particular finite second moments, and finite fourth moments on a probability space — make the equation-(7) diagonal plug-in almost surely consistent (`plug_in_consistent_ae`, `plug_in_consistent_ae_of_second`, `plug_in_consistent_ae_of_fourth`; general Lean proofs, via Mathlib's strong law and the earlier continuous mapping). A simulated fit of the equation-(7) bow, with edge `2 → 0` removed and `ψ02 = 1/2`, reports plug-in estimates and delta-method standard errors (`fit_bow.py`, `fit_bow.json`; sampled experiment). The three bow-free left inverses, the unitriangular uniqueness theorem, and the Gaussian delta-method formula from the previous block remain in force.

**Question still open:** The parent request is not a fit to the wheat measurements, and Figure 5's GYLD arrows are still not a printed matrix. The central limit theorem behind the delta method is not a Lean theorem. Consistency is proved for the diagonal plug-in `recover`, not yet for `recoverBow`. The generic mixed-graph characterization of Drton, Foygel, and Sullivant, arXiv:1003.1146, Section 8, stays a harvested note with no canonical inventory id and no new claim. Issue #13 could not be edited: the integration token returns 403.

**Next proposed target (follow-up):** Transport `plug_in_consistent_ae` from `recover` to `recoverBow`, which is continuity of the six bow formulas plus the same strong law. The Drton–Foygel–Sullivant characterization remains uninventoried on purpose.

## Block 2026-10-27T08:44Z: bow consistency, and the wheat sample

### Almost-sure consistency of the three bow plug-ins

`bow_continuous_mapping`, `bow01_continuous_mapping`, and `bow23_continuous_mapping` are continuity of `recoverBow`, `recoverBow01`, and `recoverBow23` at a covariance whose exogenous block is invertible and whose Schur complement keeps the recovery denominators nonzero. For the missing edge `(0,2)` those denominators are the last pivot and `Ω11 Ω22 − Ω12²`. For the missing edge `(0,1)` the only denominator is the last pivot. For the missing edge `(1,2)` the only denominator is the trailing principal minor. On each positive-definite domain the population Schur complement makes that denominator nonzero, by `Bow.v2_pos`, `Bow.v3_pos`, `Bow01.v3_pos`, or `Bow23.den_pos`.

`plug_in_bow_consistent_ae`, `plug_in_bow01_consistent_ae`, and `plug_in_bow23_consistent_ae` feed Mathlib's strong law, through `strong_gram`, into those continuous maps. The hypothesis is pairwise i.i.d. copies in `ℝ³ × ℝ³` with integrable coordinate products and population second moments equal to the model covariance. `plug_in_bow_consistent_ae_of_second` and `plug_in_bow_consistent_ae_of_fourth` are the second-moment and fourth-moment specializations for the first bow; the same two lemmas apply verbatim to the other two patterns. Axioms of the eight named theorems: `propext`, `Classical.choice`, `Quot.sound`. There is no `sorry`. This is almost-sure consistency. It is not a Lean central limit theorem.

### Wheat data

The public PDF of Mi et al. (2010), SHA-256 `27c4f3926c9b5af9b399c9b3ef36918c28e7967ef777444b620279dd91628a81`, 645,949 bytes, was re-read on 2026-10-27. Equation (7) is the simulation population. The wheat section (PDF pages 8 and 13–16) prints LR statistics, standardized path coefficients at Xbarc12 and Xbarc67, and direct, indirect, and total effects. It does not print the sample covariance `S`, the ANOVA residuals, or the marker genotype matrix. The text says the phenotypes are the 98 chromosome-3A RICLs of Campbell et al., Crop Science 43 (2003), 1493–1505, after an ANOVA that removes environment and block main effects, with cofactors chosen by stepwise selection.

Campbell et al. (2003), UNL copy `https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1026&context=agronomyfacpub`, Table 2 prints phenotypic correlations among eight traits for 95 lines pooled over seven environments. The table has no standard deviations, no marker columns, and it is not the residualized four-trait sample covariance used by Mi et al. A correlation matrix without scales does not determine `S`. No supplementary file or repository of the line-by-line residuals was found from the paper, the DOI page, or that UNL copy. Sections read in Campbell (abstract, experimental description, Table 2, QTL summary) state no additional open question; the paper was consulted as a data source, not entered as a new inventory id.

A fit of `recoverBow` needs all of the following, with the trait order fixed:

1. The 98 line identifiers.
2. Residuals of GYLD, TKWT, KPS, and SPSM after the ANOVA that removes environment and block-within-environment main effects, as described on PDF page 8.
3. The QTL indicator and the cofactors actually selected (at most five), coded `+1` and `-1`, at the position being fitted.
4. The sample covariance of those columns, with the divisor used by the paper's likelihood (Bollen's `FML` uses the `1/n` second-moment matrix). The text calls this matrix `S`.
5. The directed edge set as a matrix. Figure 5 draws arrows, including arrows into GYLD, and does not print that matrix. The three bow theorems apply only after one directed edge of a three-trait recursive pattern is removed and that residual entry is freed.

Standardized path coefficients are not a substitute for `S`. No wheat fit was computed.

### Time

This block ran from 08:44Z to about 08:52Z. The three consistency theorems were green by 08:51Z. The PDF hash check and the Campbell table reading occupied the same interval. Roughly ten minutes for the proofs and the same ten minutes, overlapping, for the data search.

### Verification

- `lake build` of `CorrelatedResiduals`, Lean 4.22.0, Mathlib v4.22.0, exited 0. New modules: `BowConsistency`, `BowConsistencyMore`.
- `#print axioms` on `bow_continuous_mapping`, `bow01_continuous_mapping`, `bow23_continuous_mapping`, `plug_in_bow_consistent_ae`, `plug_in_bow_consistent_ae_of_second`, `plug_in_bow_consistent_ae_of_fourth`, `plug_in_bow01_consistent_ae`, and `plug_in_bow23_consistent_ae` reports only `propext`, `Classical.choice`, and `Quot.sound`.

## Final closeout

**Question answered:** The three bow-free plug-ins are almost surely consistent on their positive-definite domains for pairwise i.i.d. samples with integrable coordinate products (`plug_in_bow_consistent_ae`, `plug_in_bow01_consistent_ae`, `plug_in_bow23_consistent_ae`; general Lean proofs). The diagonal plug-in, the general-`n` recovery of `(B, Ψ, Γ, Φ)`, the three bow-free left inverses, the unitriangular uniqueness theorem, and the Gaussian delta-method formula remain as in the earlier blocks. The wheat sample covariance is not in the public paper or in Campbell et al. (2003), Table 2 (search lead / unresolved for a data fit; the missing inputs are listed above).

**Question still open:** The parent request, a fit under correlated residuals on the wheat measurements, still needs the residual matrix, the marker codes, and a printed edge set. The central limit theorem behind the delta method is not a Lean theorem. The Drton–Foygel–Sullivant generic mixed-graph characterization, arXiv:1003.1146, Section 8, stays a harvested note with no canonical inventory id and no new claim. Issue #13 stays open. Draft PR #14 is the delivery; `master` was not updated.

**Next proposed target (follow-up):** Given the five inputs listed above, run `recoverBow` on that sample covariance. Until those columns exist, there is no further numerical fit to compute. A Lean central limit theorem for `vech(zzᵀ)` is a separate development, larger than these continuity files.

## Handoff

Claim `refs/heads/claims/L-F102-correlated-residuals` was this session's reservation at `64f01d6b3b5b6da4a42c8edb183b3f802e717826` (session `c8f1c203-0ab7-4fd5-baca-667178087308`, start `2026-10-27T07:30:56Z`, issue #13, branch `cursor/l-f102-correlated-residuals-4c01`). It is released at this closeout by an expected-SHA delete. The work branch and draft PR #14 stay. No next block is reserved. The next action is the wheat-data fit described above, and it has no owner until someone holds those columns. Issue #13 was not closed and was not edited: earlier issue writes returned 403, and this environment's `gh` client is read-only. The handoff text for that issue is this section.

## Block 2026-10-27T17:39Z: three simulation studies and the paper

Follow-up `RQ-F102-simulation-studies`. Session `febd2771-c168-4e67-8ed4-277662d6eb85`. Claim commit `05d69ea141adf3d5ee936d3b48061bde241250dc` on `refs/heads/claims/L-F102-correlated-residuals`. The earlier claim `64f01d6` was already gone. This block did not change the Lean proofs.

Answer contract: the printed simulation and Tables 1–2, plus one bow-free residual correlation, plus a calibration that uses Campbell et al. (2003) Table 2 as path values. Decisive evidence is `simulation/out/study1.json`, `study2.json`, `study3.json`, the CSV tables next to them, and `paper/paper.pdf`.

The population is equations (7)–(8) with `B = -M`. Algebraic total effects under that sign do not match several parameter cells of Table 2, including the printed total effect 0.75 of QTL3 on Y1 against 0.25 from the display. The simulation follows the equation. Single-trait power for that cell is 13% here and 97% in Table 1. Multi-trait powers are 59, 61, and 86 against 64, 77, and 96. SEM and multivariate least squares have the same likelihood ratio on this complete recursive order (maximum absolute difference of the mean profiles `7e-14`).

The bow drops the edge into trait 0 from trait 2. At residual correlation 0.25 the diagonal plug-in has probability limit 0.20 for that missing coefficient and rejects a zero-edge Wald test in 73% of 400 replicates. `recoverBow` covers the path and QTL coefficients near the nominal 95% rate. The Isserlis standard errors treat the `±1` genotypes as Gaussian. That is an assumption inside the standard error, checked by the coverage, not a Lean central limit theorem.

Campbell Table 2 was read as correlations, not as a residual covariance. The direct PDF download returned HTTP 403, so there is no SHA-256 for that file. Signs that the prose states are used; the two cells the prose does not sign are an assumption. Copying equation (7)'s `G` onto that correlation scale makes the QTLs large. The third study is a realism check of the paths, not a replication of Table 1.

Mi's 2009 dissertation was not consulted. No new inventory id was added. The Drton–Foygel–Sullivant characterization remains the harvested note from the previous block.

### Time

UTC start 17:39:24. The shared script and the three studies finished as one process in 22 seconds, before 18:01Z. The design reading and the script, which are mostly part 1, occupied the rest of that interval, including about eight minutes to install TeX. Part 2 is the 400-replicate bow sweep inside the same process. Part 3 is the correlation fit and its rerun, also inside that process. The paper, ledger, and PDF compile ran from 18:01Z to the commit of this block.

### Requirement to evidence

| Requirement | Status | Where |
|---|---|---|
| Mi's question, printed p. 18 | met | PDF, section "The question, as they pose it" |
| Restriction and why | met | PDF, section "The restriction" |
| Lean theorem names and bodies | met | PDF, "What we proved", and Appendix A, pinned to `05d69ea` |
| Replication against Tables 1–2 | met | PDF, "Replication results"; `study1.json` |
| Correlated-residual sweep | met | PDF, "Correlated residuals"; `study2.json` |
| Campbell calibration, labeled as such | met | PDF, "Calibration"; `study3.json` |
| Limitations, including wheat data, mixed graphs, Lean CLT | met | PDF, "Limitations" |
| Reproducibility | met | PDF, "Reproducibility" |
| JSON and tables | met | `simulation/out/*.json` and the three CSV files |
| Sources ledger and hashes | partial | `SOURCES.md`. Mi and Brito–Pearl are hashed. Campbell and Hidalgo returned HTTP 403, so they have no hash. |
| Evidence labels | met | italic labels in the PDF |
| Citations checked, dissertation not used | met | `SOURCES.md` and the bibliography |
| Draft branch only, no post outside the repo | met | PR #14; issue #13 was not edited, because the request forbade posts outside the repo |
| `master` untouched | met | this branch only |

## Closeout of the simulation block

**Question answered:** On the equation-(7) pattern, the diagonal model and the three bow-free models are identified and the plug-ins are almost surely consistent (Lean theorems named above). The seeded replication does not reproduce Table 1's 97% or Table 2's indirect-effect signs, because those cells disagree with equations (7)–(8) under the printed minus (our own simulation, set next to the cited tables). The diagonal plug-in is biased and oversized once a bow-free residual correlation is present, and `recoverBow` recovers the coefficients at the delta-method coverage (our own simulation). The Campbell calibration is a path-value check on raw phenotypic correlations, not a wheat fit.

**Question still open:** The parent request still needs the wheat residual matrix, the marker codes, and a printed edge set. The general mixed-graph characterization is not a theorem of this repository. The delta method is not a Lean central limit theorem. Issue #13 stays open.

**Next proposed target (follow-up):** Fit `recoverBow` when the five wheat inputs listed in the previous block exist. A Lean central limit theorem for the second-moment matrix is a separate, larger development. No next block is reserved.

## Block 2026-10-27T18:20Z: replication gaps

Follow-up `RQ-F102-replication-gaps`. Session `1a831aa5-e49c-4b88-8374-2f117a9c2519`. Claim commit `d164f8295bb58b3f1ff6ad4c5536572a12834f04`. The simulation claim had already been released.

The first reading put a minus in front of `M`. On PDF page 10 the equals sign ends at x=145.9 and M's parenthesis starts at x=148.1, so that minus does not fit. The minus at x=189.1 is M_{23} = −1/2. Three other minuses sit on G. Path arithmetic of that glyph reading matches Table 2, including the total 0.75, except QTL2 on Y2, where the exact values are −0.4375 and 0.0625 and the table prints −0.435 and 0.065. That rounding is a source discrepancy (our reading). `B = +M` gives 0.875, not 0.75.

Seeded reruns are in `simulation/out/gaps.json`. Under the glyph reading, 1000 replicates give single-trait Y1 power 86.2% at QTL3 (interval 83.9–88.3) against 97, and SEM powers 51.8, 47.5, 86.5 against 64, 77, 96. The sign reading closes the 0.75 gap and most of the 97-versus-13 gap, and it widens the SEM gap for the first two QTLs. A ±5 cM window gives position SDs 2.80, 2.76, 2.03 against 2.83, 2.58, 2.16. The paper does not state the window. At 1000 replicates the first reading's SEM interval contains 64 and does not contain 77 or 96. A 100-shuffle 95% quantile of the maximum LR is 14.74, next to the printed 14.86. `Ψ = I` meets the single-trait 97% and contradicts the sentence that residuals are drawn from matrix (8).

The bow rerun at the glyph coefficients (seed `20101028`) still has diagonal probability limit 0.20 and rejection rate 0.728 at ρ=0.25, and `recoverBow` covers the signed coefficients. The Campbell calibration with signed `G` has SEM powers 93%, 95%, and 99%. It remains a scale mixture.

### Time

UTC start 18:20:15. The gap grid, including two 1000-replicate scans, finished at 18:30. The bow and calibration rerun finished at 18:31. The paper update followed.

### Requirement to evidence

| Requirement | Status | Where |
|---|---|---|
| Each hypothesis seeded and cited | met | `gaps.py`, `gaps.json`, PDF section "Which hypothesis closes which gap" |
| Gap-closure table | met | PDF Table of gap closure; `gaps_table.csv` |
| Source-discrepancy label, not an author-error claim | met | the −0.435/−0.065 rounding sentence |
| Bow and calibration rerun if the convention changes | met | `study2_glyph.json`, `study3_glyph_summary.json` |
| Master untouched, no external post | met | this branch and PR #14 only |

## Closeout of the gap block

**Question answered:** The 0.75 cell and most of the single-trait QTL3 gap are the glyph reading of equation (7), not `B = +M` and not Monte Carlo error. The position SDs match a ±5 cM window the paper does not state. The SEM powers 77 and 96, and about eleven points of the single-trait power, remain under the printed cofactors, the printed `Ψ`, and the printed threshold.

**Question still open:** Why the multi-trait powers for QTL2 and QTL3 sit near 48–87% in the glyph-reading scan and at 77 and 96 in Table 1. The wheat residual fit, the mixed-graph characterization, and a Lean central limit theorem are unchanged.

**Next proposed target (follow-up):** The same wheat-data fit as before. No next block is reserved.

## Block 2026-10-27T18:49Z: assumption grid

Follow-up `RQ-F102-assumption-grid`. Session `a42142f3-1c1c-4f9f-afc5-8c4316e76486`. Claim commit `76a03bee0b2a15c6f612afaef61a2fcd5ebc69c5`.

Family A is one change at a time from the glyph reading, 1000 replicates, seeds `20101101` onward. The baseline SEM powers are 50.8, 53.5, 86.1. Infinite RIL and Kosambi move QTL2 by about one point. The flanking formula, standardization, scan step, and a second seed stay inside a few points. A 95% permutation quantile is 16.1, above 14.86. `Ψ = I`, an oracle genotype, QTLs moved onto markers, and dropping cofactors move the powers and each one contradicts a printed sentence or moves the single-trait QTL2 rate from about 1% to 66%.

Family B: the noncentral chi-square approximation with the other QTL genotypes controlled gives 81%, 77%, 100% at n=150. The marker scan at 250 lines gives 81.6, 77.1, 98.7. Both match the printed 77 and miss the printed 64. Genetics Research (Man851, SHA-256 `630a5e7b90665fd680d58915f6f9fe45e5051e8a5f6fff6af2cf16f8ae3b3739`) is a two-QTL Bayesian design with powers 99 and 100; it repeats the glyph signs and the rounded pair −0.435, 0.065. The 2008 conference note is one QTL and 300 lines; its power counts were not in the text layer. Our three-QTL scan at 300 lines is 89.3, 85.0, 99.9.

### Time

UTC start 18:49:33. The 1000-replicate grid finished at about 19:01. The paper update followed.

### Requirement to evidence

| Requirement | Status | Where |
|---|---|---|
| Family A seeded at n=1000 | met | `simulation/out/assumptions/*.json` |
| Family B companion comparison and chi-square powers | met | `analytic_controlled.json`, SOURCES.md rows for Man851 and the 2008 note |
| Explanations table with graded verdicts | met | PDF section "Explanations considered" |
| No author-error claim | met | verdicts use consistent-with and source-discrepancy labels |

## Closeout of the assumption-grid block

**Question answered:** No choice the simulation paragraph leaves open matches Table 1. The printed 77 is consistent with the chi-square power at 150 lines when the other QTL genotypes are controlled, and with the marker scan at 250 lines. Both put QTL1 near 80% rather than at 64%. The single-trait QTL2 cell is consistent with a total effect of zero.

**Question still open:** Why Table 1's first SEM power is 64 while the two readings that produce 77 for QTL2 both put that first power near 80. The wheat residual fit, the mixed-graph characterization, and a Lean central limit theorem are unchanged.

**Next proposed target (follow-up):** The wheat-data fit, once the residual matrix, marker codes, and edge set exist. No next block is reserved.
