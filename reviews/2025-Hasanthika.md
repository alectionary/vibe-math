# Multivariate Mixture Regression Models with Known Group Membership and Informative Priors
Pahalapathirage Dona Kalani Hasanthika · 2025 · Statistics

[Source record](https://digitalcommons.unl.edu/dissunl/360/) · [Original PDF](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl)

Builds hierarchical multivariate mixture-regression methods for Gaussian and count responses with known group labels and informative priors, using algebraic derivations and empirical validation.

## Review scope

This is an AI-assisted map of principal mathematical results and their evidence, not an independent correctness audit or an exhaustive classification of every assertion. All page numbers below are 1-based PDF viewer pages, including repository cover sheets. “Proved” reports how the dissertation presents a result. Open status is historical to the dissertation; later literature was not checked.

## Proof-assistant formalization

No proof-assistant verification identified in the reviewed PDF. PDF-only evidence search and document review; no external formalization repositories audited. Mathematical formalism, computer algebra, and algorithmic proofs are not counted as kernel-checked proofs.

## Mathematical setup and definitions

- Likelihoods, latent/indicator variables, known group membership, regression coefficients, hierarchical priors and Gaussian/Poisson-overdispersion response models are explicitly specified. (PDF pp. [22](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=22), [23](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=23), [24](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=24), [25](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=25), [26](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=26), [107](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=107), [108](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=108), [109](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=109), [188](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=188), [189](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=189), [263](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=263), [264](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=264)).

## Results proved or derived in the dissertation

- §2.5.2 and earlier model derivations: The text derives likelihood/conditional-expectation and parameter-update formulas for successive mixture models. These are conventional conditional algebraic derivations, not theorem-labeled distribution-free guarantees. (PDF pp. [24](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=24), [25](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=25), [26](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=26), [114](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=114), [115](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=115), [116](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=116), [117](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=117), [118](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=118)).

- Appendices A–E; Chapter 4: Method-of-moments and robust-regression derivations, plus expanded derivations for the proposed Gaussian and count models, are placed in Appendices A–E. The summary explains the hybrid Bayesian-EM and moment/Newton estimation steps. (PDF pp. [324](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=324), [325](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=325), [328](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=328), [340](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=340), [353](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=353), [356](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=356), [363](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=363), [405](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=405), [412](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=412)).

## Hypotheses and modeling assumptions

- Known group information, a finite mixture/model structure, the chosen conditional Gaussian or overdispersed-count laws, design matrices and hierarchical priors are modeling assumptions. Distributional and independence/factorization assumptions belong to each likelihood specification. (PDF pp. [22](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=22), [24](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=24), [107](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=107), [108](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=108), [109](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=109), [188](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=188), [189](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=189), [263](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=263), [264](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=264)).

- Moment-based approximation and numerical root-finding are estimation choices; convergence or calibration across all possible data distributions is not implied by writing down the update equations. (PDF pp. [324](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=324), [325](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=325)).

## Prior results used

- EM, Bayes’ rule, generalized mixed-model methods and empirical-Bayes variance moderation draw on prior literature; limma/edgeR/DESeq2 are benchmark comparators. (PDF pp. [23](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=23), [26](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=26), [324](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=324)).

## Computational and empirical evidence

- Simulations and an application evaluate sensitivity, ROC behavior and false-discovery rates. Apparent FDR control in selected settings is empirical, not a proven universal frequentist FDR guarantee. (PDF pp. [165](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=165), [166](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=166), [174](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=174), [175](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=175), [176](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=176), [184](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=184), [185](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=185), [186](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=186), [311](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=311), [312](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=312), [319](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=319), [320](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=320), [321](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=321), [322](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=322)).

## Questions, conjectures and remaining work

- The count-model discussion identifies anomalous n = 100 two-group results requiring diagnosis, further real-data validation, and extensions to time-course, single-cell and multi-omic applications. (PDF pp. [322](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=322), [323](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=323)).

## Scope and interpretation notes

- The known group-label variable and inferred discriminating-feature indicators have different roles; do not call all latent quantities observed. High sensitivity and low FDR are different goals, and the author explicitly reports trade-offs. (PDF pp. [188](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=188), [322](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=322)).

- No theorem/proof-assistant inventory can be inferred from the absence of numbered theorem headings: this dissertation contains extensive mathematical derivations and proof appendices. (PDF pp. [8](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=8), [9](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=9), [324](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1426&context=dissunl#page=324)).

## Possible first formalization task

Reviewer suggestion: formalize one conjugate posterior or one EM conditional-expectation identity under a fully specified finite model; keep numerical/empirical claims separate.

This is a reviewer suggestion for new work, not an assertion that the dissertation result already has a formal proof.

## Numbered-statement navigation

The automated index detects 0 unique kind/number pairs for this PDF. It can include restatements and references or miss unnumbered mathematics. These are navigation candidates, not a count of new or proven results. See [statement-index.json](statement-index.json).

| Kind | Number | PDF viewer pages |
| --- | --- | --- |
