# On Kernels and Antiderivatives of Nonlocal Derivatives
Alex John Heitzman · 2025 · Mathematics

[Source record](https://digitalcommons.unl.edu/dissunl/365/) · [Original PDF](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl)

Analyzes integral nonlocal derivatives, constructs antiderivatives from discrete approximations, and proves maximum-principle/kernel results for specified weights.

## Review scope

This is an AI-assisted map of principal mathematical results and their evidence, not an independent correctness audit or an exhaustive classification of every assertion. All page numbers below are 1-based PDF viewer pages, including repository cover sheets. “Proved” reports how the dissertation presents a result. Open status is historical to the dissertation; later literature was not checked.

## Proof-assistant formalization

No proof-assistant verification identified in the reviewed PDF. PDF-only evidence search and document review; no external formalization repositories audited. Mathematical formalism, computer algebra, and algorithmic proofs are not counted as kernel-checked proofs.

## Mathematical setup and definitions

- D_k f(x) is the integral of [f(x) − f(z)]k(x,z). The weight function is distinguished from the operator’s nullspace. Piecewise-vanishing oscillation and weak nonlocal derivatives supply solution frameworks. (PDF pp. [6](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=6), [8](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=8), [9](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=9), [89](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=89), [90](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=90)).

## Results proved or derived in the dissertation

- Chapter 2; Theorem 15: The antiderivative results construct solutions to D_k f = g through compactness/convergence of approximations, with uniqueness and almost-uniform/Lp convergence in the stated settings. (PDF pp. [8](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=8), [49](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=49), [50](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=50), [51](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=51), [52](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=52)).

- Theorems 24–25: A singular-weight result gives a weak antiderivative for the one-sided 1/(t−s) weight when the forcing is Hölder continuous and vanishes at the initial point; weak derivatives are unique almost everywhere under their hypotheses. (PDF pp. [89](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=89), [90](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=90), [91](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=91)).

- Chapter 3; Theorem 35 and discussion: The maximum-principle arguments constrain subsolutions and nullspaces using positivity, propagation/fattening, and integrability conditions. (PDF pp. [110](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=110), [111](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=111)).

## Hypotheses and modeling assumptions

- Results have different hypotheses: nonnegative/one-sided weights, positive and finite weight integrals, regularity/PVO assumptions, bounds by an auxiliary function, and normalization at zero. Singular weights require a separate weak formulation. Maximum principles use further connectivity/propagation and measure assumptions. (PDF pp. [16](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=16), [17](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=17), [51](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=51), [89](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=89), [90](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=90), [110](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=110), [111](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=111)).

## Prior results used

- The work builds on compactness ideas related to Arzelà–Ascoli, maximum principles, and previous nonlocal Poincaré/analysis results; these inputs are not additional new theorems merely because they appear in exposition. (PDF pp. [8](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=8), [9](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=9)).

## Computational and empirical evidence

- The discrete approximations are part of an existence/convergence proof. An approximation algorithm is not, by itself, a machine-checked proof. (PDF pp. [8](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=8), [51](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=51), [65](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=65), [66](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=66)).

## Questions, conjectures and remaining work

- No dedicated unresolved-conjecture section was identified. The dissertation develops several solution regimes; conditions not covered by those theorems should be recorded as outside scope rather than declared open problems. (PDF pp. [5](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=5), [6](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=6), [9](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=9), [111](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=111)).

## Scope and interpretation notes

- “Kernel” can refer to an integral weight or an operator nullspace; the author deliberately calls the former a weight function. A uniqueness theorem cannot be detached from its initial normalization or solution class. (PDF pp. [6](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=6), [50](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=50), [51](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1431&context=dissunl#page=51)).

## Possible first formalization task

Reviewer suggestion: prove that constant functions lie in the nullspace when the defining integral exists, followed by a finite weighted-graph maximum principle.

This is a reviewer suggestion for new work, not an assertion that the dissertation result already has a formal proof.

## Numbered-statement navigation

The automated index detects 60 unique kind/number pairs for this PDF. It can include restatements and references or miss unnumbered mathematics. These are navigation candidates, not a count of new or proven results. See [statement-index.json](statement-index.json).

| Kind | Number | PDF viewer pages |
| --- | --- | --- |
| Lemma | 1 | 13 |
| Lemma | 2 | 14 |
| Theorem | 1 | 14, 47 |
| Theorem | 2 | 16 |
| Definition | 1 | 19 |
| Theorem | 3 | 20 |
| Lemma | 3 | 21 |
| Definition | 2 | 22 |
| Definition | 3 | 23 |
| Theorem | 4 | 23 |
| Theorem | 5 | 24, 27 |
| Theorem | 6 | 25 |
| Theorem | 7 | 27 |
| Theorem | 8 | 27 |
| Lemma | 4 | 29 |
| Lemma | 5 | 30 |
| Theorem | 9 | 31 |
| Theorem | 10 | 32 |
| Theorem | 11 | 34 |
| Theorem | 12 | 37 |
| Theorem | 13 | 38, 46 |
| Lemma | 6 | 40, 51 |
| Lemma | 7 | 42 |
| Theorem | 14 | 43 |
| Corollary | 1 | 45 |
| Corollary | 2 | 47 |
| Theorem | 15 | 51, 56 |
| Corollary | 3 | 55 |
| Lemma | 8 | 58 |
| Theorem | 16 | 59 |
| Theorem | 17 | 63 |
| Lemma | 9 | 69 |
| Lemma | 10 | 70 |
| Theorem | 18 | 71 |
| Theorem | 19 | 73 |
| Lemma | 11 | 74 |
| Theorem | 20 | 75 |
| Corollary | 4 | 78 |
| Definition | 4 | 81 |
| Lemma | 12 | 82 |
| Theorem | 21 | 83 |
| Theorem | 22 | 84 |
| Definition | 5 | 86 |
| Theorem | 23 | 86 |
| Theorem | 24 | 89 |
| Theorem | 25 | 90 |
| Theorem | 26 | 95 |
| Theorem | 27 | 97, 101 |
| Corollary | 5 | 97 |
| Theorem | 28 | 98, 107, 114 |
| Theorem | 29 | 98 |
| Theorem | 30 | 99 |
| Theorem | 31 | 100 |
| Theorem | 32 | 103 |
| Corollary | 6 | 104 |
| Theorem | 33 | 105 |
| Definition | 6 | 107 |
| Theorem | 34 | 108 |
| Theorem | 35 | 110 |
| Theorem | 36 | 112 |
