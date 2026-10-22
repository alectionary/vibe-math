# Analysis of Graph-based Decoders for Quantum Low Density Parity Check Codes
Kirsten Morris · 2025 · Mathematics

[Source record](https://digitalcommons.unl.edu/dissunl/339/) · [Original PDF](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl)

Analyzes combinatorial causes of failure in graph-based quantum LDPC decoding and the effect of redundant checks in CSS-code constructions.

## Review scope

This is an AI-assisted map of principal mathematical results and their evidence, not an independent correctness audit or an exhaustive classification of every assertion. All page numbers below are 1-based PDF viewer pages, including repository cover sheets. “Proved” reports how the dissertation presents a result. Open status is historical to the dissertation; later literature was not checked.

## Proof-assistant formalization

No proof-assistant verification identified in the reviewed PDF. PDF-only evidence search and document review; no external formalization repositories audited. Mathematical formalism, computer algebra, and algorithmic proofs are not counted as kernel-checked proofs.

## Mathematical setup and definitions

- CSS/stabilizer codes, Tanner graphs, absorbing/trapping/failure-inducing sets and Gallager-style syndrome decoding are mathematical and algorithmic definitions. (PDF pp. [3](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=3), [33](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=33), [44](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=44), [45](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=45), [54](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=54), [73](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=73)).

## Results proved or derived in the dissertation

- Theorems 3.2.1–3.2.2, 3.2.6–3.2.7: Absorbing sets with odd-degree checks induce failure for the decoder being analyzed. All-even-check cases require an additional rowspace/stabilizer distinction; acyclic and cyclic structures give further trapping results. (PDF pp. [44](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=44), [45](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=45), [46](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=46), [48](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=48), [50](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=50)).

- Theorems 4.1.2, 4.1.6 and §4.2: Symmetric stabilizers are absorbing sets, and several partition/path/tree configurations yield failure-inducing sets under explicit neighborhood conditions. (PDF pp. [54](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=54), [56](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=56), [58](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=58), [60](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=60), [62](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=62), [64](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=64), [65](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=65)).

- Theorems 5.0.1 and 5.1.4: For the specified maximally redundant check construction, the decoder returns a syndrome-matching error pattern within two iterations. Syndrome agreement is not necessarily recovery of the actual error or logical state. (PDF pp. [73](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=73), [74](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=74), [79](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=79), [80](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=80)).

## Hypotheses and modeling assumptions

- Failure results depend on a particular update rule, initialization, graph structure, error pattern, and, in the quantum setting, rowspace/stabilizer equivalence. A statement about this decoder is not universal over quantum decoding algorithms. (PDF pp. [44](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=44), [45](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=45), [56](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=56), [58](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=58), [73](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=73), [79](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=79)).

## Prior results used

- Theorem 2.2.11: Classical LDPC and quantum stabilizer/CSS constructions are prior theory. The hypergraph-product theorem in the background chapter is explicitly cited. (PDF pp. [3](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=3), [33](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=33)).

## Computational and empirical evidence

- Hamming-derived CSS experiments support improved decoding in the tested constructions; performance plots do not prove improved error correction for every code/noise model. (PDF pp. [3](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=3), [79](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=79), [80](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=80), [81](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=81), [82](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=82), [83](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=83), [84](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=84)).

## Questions, conjectures and remaining work

- The conclusion identifies failure-inducing sets outside the absorbing-set class and relaxation of the strong graphical/two-iteration convergence condition as further work. (PDF pp. [85](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=85)).

## Scope and interpretation notes

- “Decodes within two iterations” must be read alongside the paper’s distinction between matched syndrome and correct estimated error. This distinction is explicit in Theorem 5.0.1. (PDF pp. [73](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=73), [79](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1405&context=dissunl#page=79)).

## Possible first formalization task

Reviewer suggestion: formalize a finite Tanner graph, the exact update rule, and one absorbing-set failure theorem.

This is a reviewer suggestion for new work, not an assertion that the dissertation result already has a formal proof.

## Numbered-statement navigation

The automated index detects 40 unique kind/number pairs for this PDF. It can include restatements and references or miss unnumbered mathematics. These are navigation candidates, not a count of new or proven results. See [statement-index.json](statement-index.json).

| Kind | Number | PDF viewer pages |
| --- | --- | --- |
| Definition | 2.1.1 | 18 |
| Definition | 2.1.2 | 19 |
| Definition | 2.1.3 | 19 |
| Definition | 2.1.5 | 20 |
| Definition | 2.1.6 | 21 |
| Definition | 2.1.7 | 21 |
| Definition | 2.2.1 | 24 |
| Definition | 2.2.2 | 25 |
| Definition | 2.2.3 | 26 |
| Definition | 2.2.4 | 26 |
| Definition | 2.2.5 | 26 |
| Definition | 2.2.6 | 27 |
| Definition | 2.2.10 | 32 |
| Theorem | 2.2.11 | 33 |
| Definition | 3.1.1 | 37 |
| Definition | 3.1.2 | 38 |
| Definition | 3.1.3 | 38 |
| Definition | 3.1.4 | 39 |
| Definition | 3.1.6 | 40 |
| Theorem | 3.2.1 | 44 |
| Theorem | 3.2.2 | 45 |
| Definition | 3.2.3 | 46 |
| Lemma | 3.2.5 | 47 |
| Theorem | 3.2.6 | 48 |
| Theorem | 3.2.7 | 50 |
| Definition | 4.1.1 | 53, 55 |
| Theorem | 4.1.2 | 54 |
| Lemma | 4.1.4 | 55 |
| Theorem | 4.1.6 | 56 |
| Theorem | 4.2.1 | 58 |
| Theorem | 4.2.3 | 60 |
| Theorem | 4.2.6 | 62 |
| Theorem | 4.2.7 | 62 |
| Theorem | 4.2.9 | 64 |
| Theorem | 4.2.11 | 65, 69 |
| Theorem | 5.0.1 | 73 |
| Lemma | 5.1.1 | 76 |
| Proposition | 5.1.3 | 78 |
| Lemma | 5.1 | 79 |
| Theorem | 5.1.4 | 79 |
