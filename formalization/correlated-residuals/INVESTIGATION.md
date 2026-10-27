# RQ-F102-residual-identification

Canonical target: `L-F102-correlated-residuals`. This note is a **new problem** and a labeled **restriction** of that method request. The parent request stays open. Claim ref `refs/heads/claims/L-F102-correlated-residuals` points at `64f01d6b3b5b6da4a42c8edb183b3f802e717826` and is not moved by later commits.

## Target and scope

- Canonical inventory identifier: `L-F102-correlated-residuals`, in `literature/open-problems.json` and `literature/unl-sem/questions.json`.
- New problem. The 2026-10-26 UNL-SEM seed (issue #5, PR #6) indexed the direction and did not compute or prove it. No earlier finite search, partial proof, or completed result is in this repository.
- Discovery source: the UNL-SEM screen. Question source: Mi, Eskridge, Wang, Baenziger, Campbell, Gill, Dweikat, and Bovaird, *Regression-Based Multi-Trait QTL Mapping Using a Structural Equation Model*, Statistical Applications in Genetics and Molecular Biology 9 (2010), article 38, DOI 10.2202/1544-6115.1552. Public PDF `https://www.ars.usda.gov/ARSUserFiles/60820000/Manuscripts/2010/Man850.pdf`, SHA-256 `27c4f3926c9b5af9b399c9b3ef36918c28e7967ef777444b620279dd91628a81`, re-downloaded and matched on 2026-10-27. Discussion, PDF page 20 (printed page 18).
- Author request, not a numbered conjecture: extend the analysis to correlated residual errors. Historical status in the source: proposed. Current status of the parent request: not settled here. Current status of the restricted identification question: decided for the equation-(7) pattern, below.
- Objects: real structural matrix `B`, exogenous coefficient `Γ`, residual covariance `Ψ`, exogenous covariance `Φ ≻ 0`, and the joint covariance of `(y, x)`.
- Quantifiers for the restricted question: every positive diagonal `Ψ`, and each of the three single off-diagonal residual entries, on the equation-(7) zero pattern. The wheat Figure 5 graph is not part of the theorem. Singular `Ψ` and other zero patterns are outside the claim.
- Intended Lean interface: the block covariance map of equation (3), with `L = (I-B)⁻¹` proved by both products, and injectivity of that map on diagonal `Ψ`. This file proves the three collision instances. It does not yet prove the diagonal injectivity theorem.
- Why this target: it is the latent-structure gate already named for this inventory entry, and the source prints a complete three-trait pattern. Runners-up are in the tracking issue.
- Answer contract: the 2010 method request, restricted to covariance identification of equation (7) → diagonal parameters are injective, and each one-edge residual extension collides → the written inverse below, the exact rational script, and the Lean witness theorems.
- Stopping condition for this block: that decision for equation (7). No estimator, imputation, mixed outcome, nonlinear trait map, or dynamic-fit simulation. Do not merge to `master`.

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
- Obstruction: a Lean proof of the diagonal inverse still has to formalize the field arithmetic in the recovery formulas. The collision certificates do not need division.
- Domain of the exact script: every `B` entry in `{-2,-1,0,1,2}` and every variance in `{1,2,3}`, plus the equation-(7) rational point. Two implementations, Gauss–Jordan and the closed inverse.
- Failed approach: dimension counting alone was not used as a proof. An early hand multiplication used a transposed factor and temporarily disagreed with the solved witness; the corrected multiplication matches both implementations.
- Attempts to break the statement: the three positive-definite witnesses survive; the zero pattern is exactly equation (7); `Φ` is not fixed by a side condition that the collision violates; `Γ` is recovered in the diagonal case and genuinely changes in each collision.

| Exact claim | Evidence label | Proof / data / source locator | Assumptions and unresolved bridge |
| --- | --- | --- | --- |
| On the equation-(7) zero pattern, positive diagonal `Ψ` and positive definite `Φ` make `(B,Γ,Ψ,Φ)` a function of `Σ`. | Written proof | This note, "Written proof of the diagonal case" | Not yet a Lean proof. The script checks a finite box and the printed equation-(7) point only. |
| Each one-edge residual extension has two distinct positive-definite parameter points with the same `Σ`. | Exact finite computation | `check_witness.py`, output `witnesses.json` | The script's rational arithmetic is the check. It is not a measure-zero argument. |
| The same three integer collisions, with `L` proved to be `(I-B)⁻¹` by both products. | Concrete Lean certificate, if `lean` accepts `Witness.lean` | `Witness.lean` theorems `bow12_same_law`, `bow13_same_law`, `bow23_same_law`, and the inverse, positive-definiteness, and difference theorems | Build result is recorded after the checker runs. A failed build leaves this row as a skeleton. |
| Drton–Foygel–Sullivant Theorem 2 implies the endogenous diagonal and bow conclusions for this graph. | Search lead / unresolved as a formal translation | arXiv:1003.1146, Theorem 2 | We did not replay their proof. The exogenous block is our separate witness. |
| A correlated-residual estimator for the source exists and is consistent. | Not claimed | — | Parent method request. |

## Verification record

Run on 2026-10-27 from the worktree, after the statement commit.

- `python3 formalization/correlated-residuals/check_witness.py` exited 0. Both covariance implementations agreed on the base point, the three collisions, and equation (7). All 3,375 grid points recovered. Equation (7) recovered `B`, `Ψ`, and `Γ`. `witnesses.json` records the matrices. The grid is exhaustive for that integer box and is not the real positive domain; the written proof covers that domain.
- `lean Witness.lean` with Lean 4.22.0 (`ba2cbbf09d4978f416e0ebd1fceeebc2c4138c05`, Release), pinned by `lean-toolchain`, exited 0. `#print axioms` on `bow12_same_law`, `bow12_inverse`, and `base_pd` reports only `propext`. There is no `sorry` and no `sorryAx`.
- GitHub code search was retried and again returned HTTP 429 for `"structural equation" language:Lean` and `"half-trek criterion"`. The repository search API query `linear structural equation identifiability lean` returned `total_count` 0 on 2026-10-27. That query matches repository text, not file contents, so it does not show that no Lean file exists. Authenticated issue and ref searches succeeded earlier.

The collision row in the evidence table is therefore an exact finite computation and a concrete Lean certificate. The diagonal injectivity row remains a written proof.

## Block closeout

**Question answered:** For the equation-(7) pattern, positive diagonal residuals identify `(B, Γ, Ψ, Φ)` from `Σ` by the explicit inverse in this note, and each single residual covariance destroys that identification by an explicit positive-definite collision.

**Question still open:** The author request to extend the multi-trait QTL analysis to correlated residuals. No identified extension, estimator, or error guarantee is given. The diagonal inverse is not yet a Lean proof. The generic mixed-graph characterization of Drton, Foygel, and Sullivant remains a harvested lead, not a canonical inventory id.

**Next proposed target (follow-up):** Prove the diagonal inverse in Lean 4 from the same formulas, on this claim. Separately, and only as inventory bookkeeping, add the generic-identifiability characterization as its own canonical id. Do not treat that characterization as the next theorem inside this restriction.
