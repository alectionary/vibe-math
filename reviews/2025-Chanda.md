# Online Prediction of Streaming Data
Aleena Chanda · 2025 · Statistics

[Source record](https://digitalcommons.unl.edu/dissunl/325/) · [Original PDF](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl)

Develops hash/sketch-based and Gaussian-process streaming predictors. It combines Bayesian derivations, conditional asymptotic results, and empirical comparisons for difficult prediction settings.

## Review scope

This is an AI-assisted map of principal mathematical results and their evidence, not an independent correctness audit or an exhaustive classification of every assertion. All page numbers below are 1-based PDF viewer pages, including repository cover sheets. “Proved” reports how the dissertation presents a result. Open status is historical to the dissertation; later literature was not checked.

## Proof-assistant formalization

No proof-assistant verification identified in the reviewed PDF. PDF-only evidence search and document review; no external formalization repositories audited. Mathematical formalism, computer algebra, and algorithmic proofs are not counted as kernel-checked proofs.

## Mathematical setup and definitions

- Hash-based predictors, estimated empirical distribution functions, Gaussian-process priors with random bias, Shtarkov predictors and cumulative absolute loss are precisely formulated methods/criteria. (PDF pp. [3](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=3), [28](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=28), [46](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=46), [68](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=68), [70](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=70), [73](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=73), [82](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=82)).

## Results proved or derived in the dissertation

- Theorems 1–2: Posterior predictive Student-t distributions are derived for two specified Gaussian-process/random-bias setups. (PDF pp. [28](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=28), [29](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=29), [30](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=30), [31](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=31), [46](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=46)).

- Theorems 3–6: The sketch chapter presents collision/count bounds and empirical-distribution approximation/convergence results. Theorem 6 explicitly assumes IID observations and an appropriate growth regime for sketch parameters. (PDF pp. [68](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=68), [69](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=69), [70](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=70), [71](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=71), [72](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=72), [73](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=73), [74](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=74)).

- Theorems 7–8: The Shtarkov comparison includes asymptotic statements under regularity hypotheses such as Fisher-information control and uniform limit assumptions; those hypotheses are stated rather than established for every data stream. (PDF pp. [85](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=85), [86](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=86), [87](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=87)).

## Hypotheses and modeling assumptions

- Bayesian posterior formulas are conditional on the adopted likelihood/prior and covariance choices. Consistency uses IID sampling and specified sketch growth. M-open motivation does not eliminate those assumptions from the theorems. (PDF pp. [3](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=3), [28](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=28), [46](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=46), [73](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=73), [85](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=85), [86](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=86)).

## Prior results used

- Count-Min sketch bounds, Glivenko–Cantelli and prior Shtarkov/Bayesian theory are inputs or adapted results. (PDF pp. [68](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=68), [69](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=69), [73](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=73), [85](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=85)).

## Computational and empirical evidence

- Reported predictive rankings are comparisons on chosen data under cumulative absolute error and sensitivity experiments. They are not a universal optimality theorem for model-free or nonstationary streams. (PDF pp. [3](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=3), [146](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=146), [147](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=147), [148](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=148)).

## Questions, conjectures and remaining work

- The thesis proposes turnstile-stream extensions, multidimensional prediction, broader empirical data classes, and possible recommender-system connections. It also identifies conceptual uncertainty about typical M-open data and bias–variance reasoning in that setting. (PDF pp. [16](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=16), [69](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=69), [138](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=138), [149](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=149), [150](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=150)).

## Scope and interpretation notes

- The M-open discussion and IID consistency theorem have different scopes; do not advertise the latter as a theorem about arbitrary M-open streams. “Formalized” in the regret discussion means mathematically defined, not machine checked. (PDF pp. [3](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=3), [73](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=73), [82](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=82)).

- The displayed probability inequalities in Theorems 3–4 warrant checking against their proofs before direct transcription into a formal system; this review does not certify their exact typography. (PDF pp. [68](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=68), [69](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1391&context=dissunl#page=69)).

## Possible first formalization task

Reviewer suggestion: a finite Count-Min collision-probability bound, then a separately scoped IID convergence statement.

This is a reviewer suggestion for new work, not an assertion that the dissertation result already has a formal proof.

## Numbered-statement navigation

The automated index detects 11 unique kind/number pairs for this PDF. It can include restatements and references or miss unnumbered mathematics. These are navigation candidates, not a count of new or proven results. See [statement-index.json](statement-index.json).

| Kind | Number | PDF viewer pages |
| --- | --- | --- |
| Theorem | 1 | 28 |
| Theorem | 2 | 46 |
| Theorem | 3 | 68 |
| Theorem | 4 | 69 |
| Theorem | 5 | 70 |
| Corollary | 1 | 72 |
| Theorem | 6 | 73 |
| Lemma | 1 | 74 |
| Lemma | 2 | 75 |
| Theorem | 7 | 85 |
| Theorem | 8 | 86 |
