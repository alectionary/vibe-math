# Boolean Rank via Monomial Ideals and Neural Ideals
Juliann Marie Geraci · 2026 · Mathematics

[Source record](https://digitalcommons.unl.edu/dissunl/474/) · [Original PDF](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl)

Connects Boolean matrix factorization and biclique covers with monomial ideals, regularity, neural codes, and order-theoretic morphisms.

## Review scope

This is an AI-assisted map of principal mathematical results and their evidence, not an independent correctness audit or an exhaustive classification of every assertion. All page numbers below are 1-based PDF viewer pages, including repository cover sheets. “Proved” reports how the dissertation presents a result. Open status is historical to the dissertation; later literature was not checked.

## Proof-assistant formalization

No proof-assistant verification identified in the reviewed PDF. PDF-only evidence search and document review; no external formalization repositories audited. Mathematical formalism, computer algebra, and algorithmic proofs are not counted as kernel-checked proofs.

## Mathematical setup and definitions

- Boolean rank, isolated sets, isolation ideals, neural-code morphisms, intersection completion, and monomial rank supply the precise mathematical objects. (PDF pp. [13](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=13), [14](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=14), [24](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=24), [30](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=30), [65](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=65), [89](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=89)).

## Results proved or derived in the dissertation

- Theorem 2.21: For a bipartite graph, regularity of its edge-ideal quotient is bounded above by Boolean rank of its adjacency matrix. The argument translates biclique decompositions into bounds on regularity. (PDF pp. [21](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=21), [22](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=22)).

- Theorem 2.41: The isolation-ideal quotient has regularity equal to the isolation number, also equal to one plus the isolation-complex dimension; this gives another Boolean-rank lower bound. (PDF pp. [30](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=30), [31](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=31), [32](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=32)).

- Theorems 3.52, 4.19, 4.22: The code theory gives a canonical-form description of intersection completion, maximal-rank results for intersection-complete codes, and a monomial-rank lower bound on Boolean rank. (PDF pp. [65](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=65), [66](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=66), [88](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=88), [89](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=89), [90](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=90), [91](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=91)).

## Hypotheses and modeling assumptions

- The first results concern finite Boolean matrices and their associated bipartite graphs; regularity is taken in explicitly defined graded polynomial-ring quotients. Neural-ring constructions use binary codes and their specified morphisms. These hypotheses cannot be replaced with arbitrary real matrices or arbitrary functions between codes. (PDF pp. [13](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=13), [20](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=20), [21](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=21), [30](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=30), [31](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=31), [40](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=40), [41](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=41)).

## Prior results used

- §1.1; Proposition 2.42: The author explicitly distinguishes propositions recalled from literature from lemmas/theorems developed in collaboration. Stanley–Reisner theory and the Artinian top-degree characterization of regularity are essential dependencies. (PDF pp. [11](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=11), [12](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=12), [31](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=31)).

## Computational and empirical evidence

- Worked matrix/code examples illustrate exact algebraic constructions. They do not constitute a Lean, Coq, or Isabelle verification of the general results. (PDF pp. [30](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=30), [33](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=33), [36](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=36), [38](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=38)).

## Questions, conjectures and remaining work

- Chapter 5: Questions 5.1 and 5.2 ask about gaps between Ferrers and biclique covering invariants and the largest canonical form of an intersection-complete code. Chapter 5 also proposes studying invariants of matrix representations of code morphisms. (PDF pp. [92](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=92), [93](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=93), [94](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=94)).

- §5.4: The proposed equality relating Boolean rank before and after reduction to a count of nonsimple redundancies is explicitly conjectural. (PDF pp. [94](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=94)).

## Scope and interpretation notes

- Question 5.1 includes a fixed-number-of-vertices parenthetical. Literal unboundedness on a fixed finite vertex set is impossible, so the intended asymptotic quantifiers need clarification before formalization. (PDF pp. [93](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=93)).

- A neural code is a discrete mathematical model; these results do not by themselves validate a biological model. (PDF pp. [3](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=3), [4](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1541&context=dissunl#page=4)).

## Possible first formalization task

Reviewer suggestion: formalize the finite equivalence between a Boolean factorization and a biclique cover before tackling regularity or neural ideals.

This is a reviewer suggestion for new work, not an assertion that the dissertation result already has a formal proof.

## Numbered-statement navigation

The automated index detects 110 unique kind/number pairs for this PDF. It can include restatements and references or miss unnumbered mathematics. These are navigation candidates, not a count of new or proven results. See [statement-index.json](statement-index.json).

| Kind | Number | PDF viewer pages |
| --- | --- | --- |
| Definition | 2.1 | 14 |
| Problem | 2.2 | 14 |
| Definition | 2.3 | 15 |
| Definition | 2.4 | 15 |
| Definition | 2.5 | 16 |
| Definition | 2.6 | 16 |
| Definition | 2.7 | 17 |
| Proposition | 2.8 | 17 |
| Corollary | 2.9 | 17 |
| Definition | 2.10 | 17 |
| Proposition | 2.11 | 18 |
| Definition | 2.12 | 18 |
| Definition | 2.13 | 18 |
| Question | 2.17 | 20 |
| Definition | 2.19 | 21 |
| Proposition | 2.20 | 21 |
| Theorem | 2.21 | 21 |
| Lemma | 2.20 | 22 |
| Lemma | 2.11 | 22 |
| Corollary | 2.22 | 22 |
| Definition | 2.25 | 23 |
| Proposition | 2.27 | 24 |
| Definition | 2.30 | 25 |
| Theorem | 2.30 | 26 |
| Definition | 2.32 | 26 |
| Definition | 2.34 | 26 |
| Definition | 2.35 | 27 |
| Lemma | 2.36 | 27, 28, 30 |
| Theorem | 2.37 | 28 |
| Corollary | 2.39 | 30 |
| Definition | 2.40 | 30 |
| Theorem | 2.41 | 30 |
| Proposition | 2.42 | 31 |
| Lemma | 2.43 | 31 |
| Definition | 2.44 | 33 |
| Theorem | 2.45 | 33 |
| Definition | 2.47 | 35 |
| Definition | 2.48 | 35 |
| Theorem | 2.50 | 36 |
| Definition | 2.52 | 38 |
| Theorem | 2.53 | 38 |
| Theorem | 2.55 | 39 |
| Definition | 3.1 | 43 |
| Definition | 3.3 | 44 |
| Definition | 3.7 | 45 |
| Definition | 3.8 | 45 |
| Definition | 3.10 | 46 |
| Definition | 3.11 | 46 |
| Definition | 3.14 | 47, 67 |
| Proposition | 3.17 | 48, 68 |
| Definition | 3.18 | 49 |
| Definition | 3.19 | 49 |
| Definition | 3.20 | 49 |
| Definition | 3.21 | 50 |
| Definition | 3.25 | 51 |
| Proposition | 3.26 | 51, 88 |
| Definition | 3.27 | 52 |
| Definition | 3.28 | 52 |
| Definition | 3.29 | 52 |
| Definition | 3.30 | 53 |
| Definition | 3.31 | 53 |
| Proposition | 3.32 | 53 |
| Lemma | 3.33 | 57 |
| Lemma | 3.34 | 58 |
| Definition | 3.35 | 59 |
| Definition | 3.37 | 60 |
| Definition | 3.39 | 60 |
| Definition | 3.40 | 60 |
| Definition | 3.44 | 61 |
| Proposition | 3.45 | 62 |
| Definition | 3.46 | 62 |
| Definition | 3.47 | 62 |
| Proposition | 3.48 | 63 |
| Proposition | 3.49 | 63 |
| Lemma | 3.50 | 63 |
| Lemma | 3.51 | 64 |
| Theorem | 3.52 | 65 |
| Definition | 3.53 | 66 |
| Lemma | 3.54 | 68 |
| Lemma | 3.55 | 69 |
| Lemma | 3.56 | 71 |
| Lemma | 3.57 | 72 |
| Lemma | 3.58 | 73 |
| Definition | 3.59 | 74 |
| Lemma | 3.60 | 74 |
| Lemma | 3.61 | 74 |
| Definition | 4.1 | 78 |
| Lemma | 4.2 | 78 |
| Definition | 4.3 | 79 |
| Definition | 4.4 | 80 |
| Lemma | 4.5 | 80 |
| Definition | 3 | 80 |
| Definition | 4.6 | 81 |
| Lemma | 4.7 | 82 |
| Lemma | 4.8 | 83 |
| Definition | 4.9 | 84 |
| Theorem | 4.10 | 84 |
| Lemma | 4.11 | 84 |
| Lemma | 4.13 | 85 |
| Lemma | 4.14 | 86 |
| Definition | 4.15 | 87 |
| Lemma | 4.16 | 88 |
| Definition | 4.17 | 88 |
| Proposition | 4.18 | 88 |
| Theorem | 4.19 | 88 |
| Definition | 4.20 | 89 |
| Definition | 4.21 | 90 |
| Theorem | 4.22 | 90 |
| Question | 5.1 | 93 |
| Question | 5.2 | 94 |
