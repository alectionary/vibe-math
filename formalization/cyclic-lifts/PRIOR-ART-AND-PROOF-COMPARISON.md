# Girth-eight characterization: prior art and proof comparison

Checked October 22, 2026. The recorded theorem is fully proved in Lean, but **we should present it as a machine-checked specialization and combination of established coding-theory results, not a new mathematical discovery**. The bounded search did not locate the identical combined iff in our notation. That is a narrower finding than absence of prior art: the component criteria, the eight-cycle mechanism, and the relevant support argument all have earlier sources. First Lean formalization and proof-method priority remain unestablished. [Source records and check results](prior-art-review.json).

## Closest primary sources

| Component | Primary source and locator | Relationship to our code |
| --- | --- | --- |
| Short-cycle congruences | Marc P. C. Fossorier, *Quasi-Cyclic Low-Density Parity-Check Codes From Circulant Permutation Matrices*, IEEE TIT 50(8), 1788–1793 (August 2004), equations (3)–(5), Theorem 2.1, p.1789. [Paper](https://www.josephboutros.org/ldpc_vs_turbo/ldpc_Fossorier_ITaug04.pdf), [DOI](https://doi.org/10.1109/TIT.2004.831841). | Our four/six-edge sums are the two/three-step cases of this criterion, up to sign and reindexing. |
| Direct LP eight-cycle | Nithin Raveendran, David Declercq and Bane Vasić, *On the Minimum Distances of Finite-Length Lifted Product Quantum LDPC Codes*, arXiv:2503.07567v1, March 10, 2025, Section III-B, p.5, paragraph after (20). [Primary text](https://arxiv.org/html/2503.07567v1). | Same monomial LP matrix family and explicit eight-label cancellation; the closest direct predecessor for `mixedEight`. |
| Coordinate-support argument and explicit eight-cycle topology | Koki Okada and Kenta Kasai, *High-Girth Regular Quantum LDPC Codes from Square-Base Hypergraph Products via CPM Lifts*, arXiv:2604.27817v1, April 30, 2026, Lemma 3 and Theorem 5. [Primary text](https://arxiv.org/html/2604.27817v1). | Same coordinate-sharing triangle argument and the same projected eight-vertex pattern. Its binary square-base/CSS-constrained lift model differs from our rectangular exponent-matrix model. |
| Earlier product-cycle mechanism | Nithin Raveendran and Bane Vasić, *Trapping Sets of Quantum LDPC Codes*, Quantum 5, 562 (2021), Section 4.2, Lemma 3, p.11. [Published paper](https://quantum-journal.org/papers/q-2021-10-14-562/). | Exhibits the product eight-cycle in ordinary HGP graphs, under the local neighbor choices used in its proof. |
| Earlier LP cancellation analysis | Boqing Zhang, *On the Left-Right Lifted Product Quantum LDPC Code*, Duke MS thesis, defended March 27, 2024, Section 3.3, Theorem 5, printed pp.47–50. [University copy](https://dukespace.lib.duke.edu/server/api/core/bitstreams/8f596ec8-b362-43da-bf61-f8c26f0c5edc/content). | Product-cycle counting followed by cancellation of cyclic lift labels; not a different mechanism from ours. |
| Alternative proof organization | Roxana Smarandache and David G. M. Mitchell, *Necessary and Sufficient Girth Conditions for Tanner Graphs of Quasi-Cyclic LDPC Codes*, arXiv:2105.03462v1, May 7, 2021, Theorems 6 and 9. [Primary paper](https://arxiv.org/abs/2105.03462). | Matrix-product tests through `H Hᵀ` and derived matrices, followed by difference-set conditions. Our implementation uses walks rather than this matrix-power route. |

The question that led us here remains credited to Ragnar Freij-Hollanti, Kirsten D. Morris and Patricija Šapokaitė, *Graphical Analysis of Lifted Product Code Constructions*, arXiv:2606.11987v1, Section 5 after Theorem 5.1. Its reference [9] is already the 2025 minimum-distance paper above. A backward-reference audit therefore reaches the direct upper-bound predecessor without requiring a remote cross-field connection. [Original question](https://arxiv.org/html/2606.11987v1). Its arXiv record still lists only v1 in this check. [Version record](https://arxiv.org/abs/2606.11987).

## Exact mathematical comparison

Fossorier writes differences `Δ(a,b;c) = p[a,c] - p[b,c]` and tests their cyclic sums. For length four, the two-step sum equals our `baseRectangle`. For length six,

```
Δ(a,b;d) + Δ(b,c;e) + Δ(c,a;f) = baseHexagon B a c b d f e.
```

The last two row/column positions are reversed relative to our horizontal convention. Our row-image circulant convention has the opposite exponent sign from his column-position convention; negating all labels preserves zero/nonzero tests. His normalization does not supply a new restriction on cycle invariants.

There is an important scope step: apply the classical full-block criterion to the ordinary circulant expansion of `B`, not blindly to the sparse expanded `B_X`. Our `xGraph_hasFourCycle_iff` and `xGraph_hasSixCycle_iff` supply the reduction from the product graph. In the six-cycle proof, permutation fibers force distinct projected triples. The support equations then eliminate all six mixed left/right block patterns; the two pure patterns give the base hexagon criterion. This is substantive formalization work, but it is not evidence of a new mathematical invariant.

Okada–Kasai Lemma 3 uses the same coordinate-sharing argument to exclude mixed six-cycles. It is a sufficient binary square-base result, not our exact modular iff. Theorem 5 uses the same projected cycle under `i=i0`, `i′=i1`, `j=j0`, `j′=j1`, `u=k`, `v=l`. It obtains closure by adding CSS overlap constraints; our code assigns fibers satisfying each edge. These are model and formalization differences, not evidence of a new cycle mechanism.

The 2025 LP paper's cancellation is the same algebraic mechanism as our upper bound. Its presentation exhibits an exponent sum; `mixedEight` gives explicit fibers and `mixedEight_isCycle` verifies eight distinct vertices using Mathlib's native cycle definition. The fully quantified witness and simplicity check make the argument more explicit, not mathematically different.

Zhang's Theorem 5 includes monomial labels and base-factor girth greater than eight to obtain an exact girth/counting result. Our complete bipartite base generally has girth four, so that theorem cannot simply be invoked with its written hypotheses. Its cyclic cancellation argument is still a predecessor to the local upper-bound mechanism. We do not import its counting assertions, non-Abelian extension or relaxed-hypothesis claims into our theorem.

The final assembly uses bipartiteness, exclusion of lengths four/six, and an eight-cycle witness. Rewriting a hexagon as the sum of two rectangle voltages is an algebraic rearrangement, not a new proof principle. The Smarandache–Mitchell matrix-product route is a different organization of short-cycle analysis; our closest mechanistic comparisons remain direct voltage sums and product-cycle cancellation.

## What our Lean development contributes

- A checked identification with the actual binary expansion, including the inverse/transpose sign.
- Exact generic short-cycle equivalences, with projected distinctness and native simple-cycle semantics.
- A complete `B_X` reduction handling both pure block families and excluding mixed short cycles.
- An arbitrary-exponent eight-cycle with explicit fibers, plus ordinary and extended girth bounds.
- A single exact iff theorem, rectangle-only reformulation, independent consumers and auditable source hashes.

These are verified deliverables; they do not establish that no earlier formalization exists. The earlier inventory discovery was bounded, and this literature comparison is not a new exhaustive Lean-code search. Complete proof coverage remains 2/108: known mathematics can still be a new checked artifact in our inventory.

The appropriate description is: **a Lean-verified characterization for the specified cyclic lifted-product Tanner graph, obtained by specializing established QC cycle conditions and the known product eight-cycle mechanism**. The exact combined presentation may be useful exposition, but we have not established novelty for that presentation. This verification criterion also does not optimize lift size, give constructive families at every dimension, or settle the source's questions about other decoding-relevant graph properties.

## Reproducibility and limits

[Comparison checks](../dyadic-rank/CyclicPriorArtChecks.lean) prove three algebraic translations: the two-step rectangle identity, the three-step hexagon reindexing, and the published eight-label cancellation. Run from `formalization/dyadic-rank`:

```
lake -f lakefile-cyclic.toml env lean CyclicPriorArtChecks.lean
```

All three have only standard axioms. They are separate comparison lemmas, not additions to the 75-theorem library count. They check formula translation; they do not formalize the cited papers as documents or import their proofs. [Axiom output](prior-art-checks.log).

The search included scholarly web/arXiv queries, backward references from the source paper, and relevant later work already in the repository. Search hits were used for discovery; the comparison rests on inspected primary texts. PDF pages with the product-cycle proofs and matrix formulas were rendered and reviewed. Full copies stay under ignored local extraction paths. Fossorier's full text was readable through the web tool, but direct local PDF retrieval returned HTTP 403; no local file hash is claimed for that source. The machine-readable review records pinned versions, locators, retrieval limits, local source hashes where available, and the bounded negative result for the identical combined theorem. A later publication, unindexed paper or alternate wording may have been missed.
