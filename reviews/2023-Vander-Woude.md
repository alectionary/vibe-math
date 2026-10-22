# Partitions of R^n with Maximal Seclusion and their Applications to Reproducible Computation
Jason Vander Woude · 2023 · Mathematics

[Source record](https://digitalcommons.unl.edu/mathstudent/117/) · [Original PDF](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent)

Constructs optimally secluded cube partitions and proves lower bounds and generalizations, then applies the geometry to reproducible/randomized computation and learning.

## Review scope

This is an AI-assisted map of principal mathematical results and their evidence, not an independent correctness audit or an exhaustive classification of every assertion. All page numbers below are 1-based PDF viewer pages, including repository cover sheets. “Proved” reports how the dissertation presents a result. Open status is historical to the dissertation; later literature was not checked.

## Proof-assistant formalization

No proof-assistant verification identified in the reviewed PDF. PDF-only evidence search and document review; no external formalization repositories audited. Mathematical formalism, computer algebra, and algorithmic proofs are not counted as kernel-checked proofs.

## Mathematical setup and definitions

- A (k, epsilon)-secluded partition limits how many cells any specified l-infinity ball can meet. Axis alignment, unit-cube versus diameter/volume restrictions, open/closed neighborhoods, and pseudodeterministic algorithms are separate definitions. (PDF pp. [3](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=3), [38](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=38), [39](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=39), [40](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=40), [101](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=101), [152](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=152), [153](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=153), [173](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=173), [361](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=361)).

## Results proved or derived in the dissertation

- Theorem 4.2.18; Theorem 5.1.1; Corollary 9.8.5: Explicit efficiently computable axis-aligned unit-cube partitions achieve k = d + 1 and epsilon = 1/(2d). The lower bound on k and the exact epsilon optimum for that cube class are proved separately. (PDF pp. [45](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=45), [46](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=46), [102](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=102), [123](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=123), [124](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=124), [125](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=125), [333](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=333), [334](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=334), [335](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=335), [336](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=336), [337](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=337), [338](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=338), [339](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=339), [340](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=340)).

- Theorems 6.2.1 and 7.1.9: For broader bounded-volume partitions, the work proves k ≥ d + 1 and a logarithmic-over-dimension epsilon bound. These are weaker than exact cube-class optimality, and have different hypotheses. (PDF pp. [152](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=152), [153](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=153), [158](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=158), [173](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=173), [184](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=184), [190](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=190)).

- Theorems 8.0.7–8.0.8, 9.7.4, 10.3.4, 10.3.10: Further proved results include neighborhood KKM/Sperner variants, equivalences for cube partitions, efficient rounding applications, and lower bounds for pseudodeterministic coin/threshold estimation. (PDF pp. [223](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=223), [224](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=224), [230](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=230), [239](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=239), [321](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=321), [361](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=361), [370](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=370)).

## Hypotheses and modeling assumptions

- Each optimum is relative to an object class and norm/normalization. General partitions require diameter/outer-measure or local-finiteness conditions as stated. Computational lower bounds depend on the algorithm and learning models, not every possible notion of reproducibility. (PDF pp. [40](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=40), [152](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=152), [153](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=153), [173](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=173), [190](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=190), [361](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=361), [365](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=365), [370](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=370)).

## Prior results used

- Classical Lebesgue covering/KKM/Sperner results, Brunn–Minkowski, and Zaks’s theorem are prior inputs; the thesis explicitly offers alternative proofs or new quantitative variants in several places. (PDF pp. [123](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=123), [124](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=124), [145](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=145), [146](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=146), [147](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=147), [180](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=180), [317](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=317)).

## Computational and empirical evidence

- Finite clique computations motivate conjectures about alternative partitions; examples and efficient algorithms do not settle their asymptotic conjectures. (PDF pp. [107](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=107), [110](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=110), [115](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=115), [118](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=118)).

## Questions, conjectures and remaining work

- Conjectures 4.3.1, 4.4.1, 7.3.1–7.3.3, 9.2.13, 9.6.7, 9.7.9, 10.2.17: Conjectures include stronger optimal epsilon bounds for arbitrary diameter-bounded cells, clique behavior/bifurcation for particular constructions, extension of cube enclosures, additional equivalences, and randomized-rounding limitations. (PDF pp. [107](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=107), [110](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=110), [216](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=216), [217](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=217), [218](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=218), [266](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=266), [320](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=320), [324](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=324), [360](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=360)).

- Question 8.3.2 asks about the range of the neighborhood-color functions; improving quantitative lower/upper bounds remains a direction. (PDF pp. [248](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=248), [252](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=252)).

## Scope and interpretation notes

- Exact epsilon optimality for axis-aligned cubes is proved, while the analogous broad diameter-bounded claim is conjectural. Theorem 10.3.4’s headline wording must be read with its precise k < d + 1 statement, not as excluding k = d + 1. (PDF pp. [102](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=102), [216](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=216), [333](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=333), [361](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1124&context=mathstudent#page=361)).

## Possible first formalization task

Reviewer suggestion: formalize a low-dimensional secluded partition and its finite intersection bound; preserve open versus closed ball conventions.

This is a reviewer suggestion for new work, not an assertion that the dissertation result already has a formal proof.

## Numbered-statement navigation

The automated index detects 179 unique kind/number pairs for this PDF. It can include restatements and references or miss unnumbered mathematics. These are navigation candidates, not a count of new or proven results. See [statement-index.json](statement-index.json).

| Kind | Number | PDF viewer pages |
| --- | --- | --- |
| Question | 1.1.1 | 38 |
| Proposition | 10.2 | 39 |
| Question | 1.2.1 | 40 |
| Theorem | 4.2.18 | 45, 102, 109, 139, 300 |
| Theorem | 5.1.1 | 45, 123, 288 |
| Corollary | 9.8.5 | 45, 137, 340 |
| Theorem | 4.4.10 | 46, 115, 118 |
| Theorem | 6.2.1 | 46, 152, 158 |
| Theorem | 7.2.9 | 46, 207 |
| Theorem | 7.1.9 | 47, 190 |
| Corollary | 7.1.11 | 47, 191 |
| Corollary | 7.1.7 | 47, 189 |
| Theorem | 8.0.7 | 48, 223, 230 |
| Theorem | 9.7.4 | 49, 321, 324 |
| Definition | 4.2.4 | 50, 87 |
| Proposition | 7.2.10 | 51, 210, 212 |
| Definition | 3.1.1 | 57 |
| Definition | 3.1.2 | 58, 253 |
| Definition | 3.2.1 | 58 |
| Definition | 3.3.1 | 58 |
| Definition | 3.3.2 | 59 |
| Definition | 3.3.3 | 59, 262 |
| Definition | 3.4.1 | 59 |
| Definition | 3.4.4 | 60 |
| Definition | 3.4.8 | 62 |
| Definition | 3.4.10 | 63, 262 |
| Lemma | 3.4.11 | 63, 262, 286 |
| Corollary | 3.4.15 | 67 |
| Theorem | 3.5.1 | 67 |
| Definition | 3.6.1 | 68 |
| Corollary | 3.6.6 | 71 |
| Corollary | 3.6.7 | 72 |
| Definition | 4.1.1 | 81 |
| Definition | 4.2.1 | 87 |
| Definition | 4.2.3 | 87 |
| Definition | 4.2.7 | 89 |
| Lemma | 4.2.9 | 89, 92, 93, 94 |
| Proposition | 4.2.10 | 91, 94, 100 |
| Definition | 4.2 | 94 |
| Definition | 4.2.11 | 95 |
| Lemma | 4.2.13 | 96 |
| Lemma | 4.2.14 | 97 |
| Theorem | 4.2.15 | 98 |
| Proposition | 4.2.16 | 100 |
| Theorem | 4.2.17 | 101 |
| Conjecture | 4.3.1 | 107 |
| Conjecture | 4.4.1 | 110 |
| Definition | 4.4.4 | 112, 347 |
| Proposition | 4.4.8 | 113 |
| Lemma | 4.4.9 | 114, 115, 249 |
| Lemma | 4.4.11 | 115 |
| Lemma | 4.4.13 | 117 |
| Theorem | 5.1.2 | 124, 145 |
| Theorem | 5.1.4 | 125 |
| Lemma | 5.1.5 | 128 |
| Theorem | 5.2.2 | 132 |
| Corollary | 5.2.4 | 135 |
| Theorem | 5.2.5 | 135 |
| Definition | 6.0.1 | 144 |
| Theorem | 6.1.1 | 146 |
| Theorem | 6.1.2 | 147, 151, 371 |
| Definition | 6.1.3 | 147 |
| Definition | 6.1.4 | 148 |
| Theorem | 6.1.5 | 149 |
| Lemma | 6.1.6 | 149 |
| Theorem | 6.2.2 | 153, 157 |
| Theorem | 6.2.3 | 153, 157 |
| Corollary | 6.2.6 | 155 |
| Proposition | 6.4.1 | 169 |
| Proposition | 6.4.2 | 170 |
| Theorem | 7.1.1 | 173, 184 |
| Corollary | 7.1.2 | 174, 176 |
| Theorem | A.2.1 | 175, 375 |
| Corollary | 7.1.3 | 176 |
| Proposition | A.3.1 | 179, 228, 377, 383 |
| Theorem | 7.1.4 | 180 |
| Lemma | 7.1.5 | 180 |
| Corollary | 7.1.8 | 189 |
| Corollary | 7.1.10 | 191 |
| Theorem | 7.1 | 191 |
| Definition | 7.2.1 | 195 |
| Definition | 7.2.2 | 196 |
| Definition | 7.2.3 | 198 |
| Definition | 7.2.4 | 200 |
| Lemma | 7.2.5 | 201 |
| Corollary | 7.2.6 | 202, 207 |
| Lemma | D.0.2 | 209, 210, 395 |
| Proposition | 7.2.11 | 210, 211, 213 |
| Theorem | 7.2.12 | 210 |
| Proposition | 7.2.14 | 211 |
| Conjecture | 7.3.1 | 216 |
| Conjecture | 7.3.2 | 216 |
| Conjecture | 7.3.3 | 217 |
| Conjecture | 7.3.4 | 217 |
| Conjecture | 7.3.5 | 218 |
| Conjecture | 7.3.6 | 219 |
| Theorem | 5.1 | 220 |
| Definition | 8.0.1 | 221 |
| Definition | 8.0.2 | 221 |
| Theorem | 8.0.3 | 221 |
| Theorem | 8.0.4 | 221 |
| Definition | 8.0.5 | 222 |
| Theorem | 8.0.6 | 222 |
| Theorem | 8.0.8 | 224, 239 |
| Corollary | 8.0.10 | 225 |
| Corollary | 8.0.11 | 226 |
| Corollary | 8.1.1 | 228 |
| Corollary | 8.1 | 234 |
| Proposition | A.3 | 235 |
| Definition | 8.2.1 | 236, 237 |
| Question | 8.3.2 | 248 |
| Lemma | 9.0.2 | 254, 319 |
| Definition | 9.2.1 | 259 |
| Definition | 9.2.3 | 259 |
| Definition | 9.2.4 | 260 |
| Corollary | 9.2.7 | 262 |
| Lemma | 9.2.10 | 264 |
| Corollary | 9.2.11 | 265 |
| Conjecture | 9.2.13 | 266 |
| Lemma | 9.3.1 | 268, 284, 285 |
| Definition | 9.4.1 | 280 |
| Lemma | 9.4.2 | 282 |
| Lemma | 9.4.3 | 284 |
| Theorem | 9.5.8 | 286, 309, 313, 339 |
| Definition | 9.5.1 | 287 |
| Lemma | 9.5.2 | 287 |
| Lemma | 9.5.3 | 289 |
| Theorem | 9.5.5 | 301 |
| Definition | 9.5.6 | 307, 319 |
| Lemma | 9.5.7 | 308 |
| Theorem | 9.5.9 | 313, 339 |
| Theorem | 9.6.2 | 317 |
| Theorem | 9.6.3 | 317 |
| Definition | 9.6.4 | 319 |
| Definition | 9.6.5 | 319 |
| Theorem | 9.6.6 | 319 |
| Conjecture | 9.6.7 | 320 |
| Corollary | 9.7.1 | 320, 323 |
| Definition | 9.7.2 | 320 |
| Corollary | 9.7.5 | 322 |
| Conjecture | 9.7.9 | 324 |
| Lemma | 9.8.1 | 325, 328 |
| Lemma | 9.8.2 | 328 |
| Theorem | 9.8.4 | 333 |
| Proposition | 10.2.3 | 345 |
| Proposition | 10.2.4 | 347, 348 |
| Definition | 10.2.6 | 349 |
| Definition | 10.2.7 | 349 |
| Definition | 10.2.10 | 350 |
| Proposition | 10.2.12 | 351, 353 |
| Corollary | 10.2.13 | 353 |
| Proposition | 10.2.14 | 354, 357, 360 |
| Proposition | 10.2.15 | 357 |
| Definition | 10.2.16 | 360 |
| Conjecture | 10.2.17 | 360 |
| Problem | 10.3.1 | 361 |
| Definition | 10.3.2 | 361 |
| Proposition | 10.3.3 | 361 |
| Theorem | 10.3.4 | 361, 366, 370 |
| Lemma | 10.3.5 | 362 |
| Definition | 10.3.6 | 364 |
| Problem | 10.3.7 | 365 |
| Lemma | 10.3.8 | 366, 369 |
| Lemma | 10.3.9 | 367 |
| Theorem | 10.3.10 | 370 |
| Lemma | A.3.2 | 377, 381 |
| Lemma | A.3.3 | 379 |
| Corollary | A.3.4 | 382 |
| Lemma | B.1.1 | 384 |
| Lemma | B.1.2 | 385 |
| Lemma | B.1.3 | 386 |
| Lemma | B.1.4 | 388 |
| Lemma | B.2.1 | 391 |
| Proposition | D.0.3 | 398 |
| Lemma | D.0.5 | 400 |
| Lemma | D.0.6 | 400 |
| Proposition | F.4.1 | 416 |
| Corollary | F.4.2 | 416 |
| Lemma | F.4.3 | 417 |
