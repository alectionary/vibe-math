# Changepoint Detection as Model Selection: A General Framework
Michael A. Grantham · 2025 · Statistics

[Source record](https://digitalcommons.unl.edu/dissunl/398/) · [Original PDF](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl)

Presents Iteratively Reweighted Fused Lasso (IRFL) as a flexible changepoint method, with optimization formulations, classical dynamic-programming proofs, derivations, and empirical evidence.

## Review scope

This is an AI-assisted map of principal mathematical results and their evidence, not an independent correctness audit or an exhaustive classification of every assertion. All page numbers below are 1-based PDF viewer pages, including repository cover sheets. “Proved” reports how the dissertation presents a result. Open status is historical to the dissertation; later literature was not checked.

## Proof-assistant formalization

No proof-assistant verification identified in the reviewed PDF. PDF-only evidence search and document review; no external formalization repositories audited. Mathematical formalism, computer algebra, and algorithmic proofs are not counted as kernel-checked proofs.

## Mathematical setup and definitions

- Segment cost functions, penalized changepoint objectives, generalized/fused lasso, adaptive weights, BIC selection and a recovery-distance metric define the framework. (PDF pp. [43](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=43), [44](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=44), [75](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=75), [76](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=76), [77](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=77), [78](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=78), [79](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=79), [80](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=80), [81](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=81)).

## Results proved or derived in the dissertation

- Propositions 1–4: The background algorithm chapter proves the optimal-partition recursion, the PELT pruning implication under a cost inequality, and CPOP/segment-neighborhood recursions. These support the described classical algorithms. (PDF pp. [44](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=44), [45](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=45), [46](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=46), [47](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=47), [49](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=49), [50](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=50), [51](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=51), [52](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=52)).

- Algorithm 1; §4.3; Appendix A.6: The new method is specified by weighted generalized-lasso subproblems, BIC-based selection, and an update/stopping rule. Appendix A supplies further optimization/criterion derivations; a method definition is not itself a convergence theorem. (PDF pp. [77](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=77), [78](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=78), [79](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=79), [80](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=80), [81](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=81), [211](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=211), [212](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=212)).

## Hypotheses and modeling assumptions

- A design matrix, contrast matrix, stabilizing epsilon, tuning/selection criterion, and stopping tolerance are chosen. Segment models and simulation scenarios impose their own noise, trend, seasonality and autocorrelation structure; PELT correctness uses its stated cost inequality. (PDF pp. [44](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=44), [46](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=46), [76](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=76), [77](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=77), [79](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=79), [154](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=154)).

## Prior results used

- Optimal partitioning, PELT, CPOP, generalized lasso and adaptive/reweighted lasso are prior methods; the cited pruning/recursion results should not be credited as novel IRFL guarantees. (PDF pp. [43](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=43), [45](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=45), [46](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=46), [47](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=47), [49](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=49), [81](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=81)).

## Computational and empirical evidence

- IRFL’s recovery/performance claims are supported principally by simulation scenarios and applications to CO2 data and images. They are empirical findings under those designs. (PDF pp. [76](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=76), [150](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=150), [151](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=151), [152](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=152), [153](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=153), [154](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=154)).

## Questions, conjectures and remaining work

- No numbered new-method open-conjecture list was identified. A proof of general IRFL iterate convergence, exact global ℓ0 recovery, or universal support consistency was not identified; these are review-identified proof obligations, not claimed author-stated open problems. (PDF pp. [79](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=79), [80](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=80), [81](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=81), [151](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=151)).

## Scope and interpretation notes

- Equation (4.5) is presented as an approximation/heuristic after a stationarity argument. It is not a demonstrated global minimizer guarantee. Classical exact dynamic-programming guarantees should not be transferred to IRFL. (PDF pp. [43](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=43), [75](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=75), [76](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=76), [80](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=80), [81](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=81)).

- Alignment of estimated changepoints with historical events is an application-level interpretation, not a causal mathematical proof. (PDF pp. [3](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=3), [152](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=152), [153](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=153), [154](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1464&context=dissunl#page=154)).

## Possible first formalization task

Reviewer suggestion: formalize Proposition 1’s finite optimal-partition recurrence before attempting guarantees for the new iterative method.

This is a reviewer suggestion for new work, not an assertion that the dissertation result already has a formal proof.

## Numbered-statement navigation

The automated index detects 8 unique kind/number pairs for this PDF. It can include restatements and references or miss unnumbered mathematics. These are navigation candidates, not a count of new or proven results. See [statement-index.json](statement-index.json).

| Kind | Number | PDF viewer pages |
| --- | --- | --- |
| Proposition | 1 | 44 |
| Proposition | 2 | 46 |
| Proposition | 3 | 49 |
| Proposition | 4 | 51 |
| Proposition | 5 | 53, 54 |
| Proposition | 6 | 54 |
| Proposition | 7 | 60 |
| Proposition | 8 | 62 |
