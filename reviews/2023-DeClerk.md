# Prefix-rewriting: The Falsification by Fellow Traveler Property and Practical Computation
Ash DeClerk · 2023 · Mathematics

[Source record](https://digitalcommons.unl.edu/mathstudent/115/) · [Original PDF](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent)

Relates geometric word-problem properties to autostackable structures and proves correctness/computability results for prefix-constrained Knuth–Bendix completion.

## Review scope

This is an AI-assisted map of principal mathematical results and their evidence, not an independent correctness audit or an exhaustive classification of every assertion. All page numbers below are 1-based PDF viewer pages, including repository cover sheets. “Proved” reports how the dissertation presents a result. Open status is historical to the dissertation; later literature was not checked.

## Proof-assistant formalization

No proof-assistant verification identified in the reviewed PDF. PDF-only evidence search and document review; no external formalization repositories audited. Mathematical formalism, computer algebra, and algorithmic proofs are not counted as kernel-checked proofs.

## Mathematical setup and definitions

- Convergent prefix-rewriting systems, synchronously regular languages, autostackability/geodesic autostackability, compatible well-founded orderings, critical pairs and fair derivations are explicitly defined. (PDF pp. [17](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=17), [18](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=18), [48](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=48), [49](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=49), [50](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=50), [51](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=51), [52](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=52), [55](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=55)).

## Results proved or derived in the dissertation

- Theorems 2.3.1–2.3.3 and 2.4.2: A weight-nonincreasing synchronously regular convergent prefix-rewriting system yields an autostackable structure. A group/generating-set pair with the falsification-by-fellow-traveler property is geodesically autostackable. (PDF pp. [21](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=21), [22](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=22), [23](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=23), [24](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=24), [30](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=30), [32](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=32), [34](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=34), [35](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=35)).

- Theorems 3.3.5 and 3.3.7: The inference rules preserve the presented equivalence relation; a finite fair derivation yields a bounded convergent prefix-rewriting system. Termination of rewriting and local confluence are proved under the defined conditions. (PDF pp. [53](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=53), [54](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=54), [55](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=55), [56](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=56), [57](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=57)).

- Theorems 3.4.3, 3.4.8, 3.4.9: Specified bounded regular orderings ensure computability of inference steps and regularity of languages; regular-split shortlex constructions provide examples. (PDF pp. [60](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=60), [61](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=61), [62](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=62), [64](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=64), [65](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=65), [66](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=66), [67](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=67)).

## Hypotheses and modeling assumptions

- Finite alphabets/presentations and well-founded compatible orders matter. “Fair” includes no remaining equations at the end and a complete critical-pair treatment. Correctness of a completed derivation does not prove the completion search terminates on all inputs. (PDF pp. [48](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=48), [50](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=50), [52](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=52), [55](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=55), [60](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=60)).

## Prior results used

- Regular-language closure, rewriting/confluence theory and earlier relationships among automatic/geometric structures provide dependencies. (PDF pp. [21](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=21), [32](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=32), [50](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=50), [57](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=57)).

## Computational and empirical evidence

- A Python implementation finds an autostackable structure for a Coxeter-group example; Appendix A lists the rules. This is an implemented proof-search/completion procedure whose correctness is conventionally proved, not evidence of a Lean-style kernel certificate. (PDF pp. [71](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=71), [72](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=72), [73](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=73)).

## Questions, conjectures and remaining work

- The abstract notes that FFTP groups were not known to be automatic or to admit finite convergent rewriting systems. The thesis establishes autostackability, not those stronger properties. (PDF pp. [2](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=2)).

- No dedicated additional open-conjecture list was identified. Guaranteed termination/success on every group presentation is not established by the conditional completion theorem. (PDF pp. [55](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=55), [71](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=71)).

## Scope and interpretation notes

- “A computer can prove convergence” here refers to the completion procedure together with mathematical correctness arguments. It should not be conflated with proof-assistant formalization. (PDF pp. [10](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=10), [55](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=55), [71](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1122&context=mathstudent#page=71)).

## Possible first formalization task

Reviewer suggestion: mechanize one inference rule’s soundness, then the finite fair-derivation correctness theorem with termination hypotheses explicit.

This is a reviewer suggestion for new work, not an assertion that the dissertation result already has a formal proof.

## Numbered-statement navigation

The automated index detects 36 unique kind/number pairs for this PDF. It can include restatements and references or miss unnumbered mathematics. These are navigation candidates, not a count of new or proven results. See [statement-index.json](statement-index.json).

| Kind | Number | PDF viewer pages |
| --- | --- | --- |
| Definition | 1.1.1 | 8 |
| Definition | 1.1.2 | 9 |
| Proposition | 1.1.3 | 10 |
| Theorem | 2.3.1 | 10, 17, 21 |
| Theorem | 3.3.7 | 11, 55 |
| Corollary | 3.4.5 | 11 |
| Definition | 1.2.1 | 13 |
| Definition | 1.2.2 | 14 |
| Lemma | 1.2.3 | 14 |
| Definition | 2.1.1 | 16 |
| Definition | 2.1.2 | 17 |
| Proposition | 2.1.3 | 18 |
| Theorem | 2.3.3 | 18, 32 |
| Theorem | 2.3.2 | 18, 30 |
| Theorem | 2.4.2 | 18, 34 |
| Definition | 2.2.1 | 19 |
| Definition | 2.2.2 | 20 |
| Theorem | 4 | 32 |
| Lemma | 2.4.1 | 34 |
| Lemma | 3.2.1 | 45 |
| Definition | 3.3.1 | 48 |
| Definition | 3.3.2 | 48 |
| Lemma | 3.3.3 | 49 |
| Definition | 3.3.4 | 50 |
| Theorem | 3.3.5 | 53 |
| Definition | 3.3.6 | 55 |
| Lemma | 3.2 | 57 |
| Definition | 3.4.1 | 58 |
| Definition | 3.4.2 | 59 |
| Theorem | 3.4.3 | 60 |
| Corollary | 3.4.4 | 62 |
| Lemma | 3.4.5 | 62 |
| Definition | 3.4.7 | 63 |
| Theorem | 3.4.8 | 64 |
| Theorem | 3.4.9 | 67 |
| Definition | 3.4.10 | 70 |
