# Exact girth-eight characterization: priority audit

Checked October 23, 2026. This is a literature addendum, not a new proof or experiment. It supplements [the existing comparison](PRIOR-ART-AND-PROOF-COMPARISON.md).

**Conclusion:** no earlier mathematically equivalent full characterization was located in the primary texts inspected. Our theorem answers the girth-condition part of an explicitly stated source question. This audit establishes neither that the exact result was already published nor that ours is its first solution.

## Exact target

For a fully populated monomial cyclic matrix B with at least two rows and two columns, form the symmetric single-input lifted product. The expanded X Tanner graph has girth exactly eight if and only if all eligible rectangle voltages and all distinct-triple hexagon voltages are nonzero. Equivalently, impose the rectangle tests and the specified noncancellation tests on pairs of rectangles. For a finite positive lift modulus this also says that the ordinary circulant expansion of the input has no four- or six-cycles.

The implementation is [GirthCharacterization.lean](../dyadic-rank/CyclicLift/GirthCharacterization.lean), particularly `matrixTanner_hX_girth_eq_eight_iff` and `xGraph_girth_eq_eight_iff_rectangles`. There is no connectedness, normalization, primality or coprimality hypothesis. This comparison checked those statements in the saved source; it did not rerun Lean.

The equivalence being sought includes an input-to-product reduction: all product four/six-cycles are accounted for by the input tests. A general cycle test on an already expanded product matrix is not, by itself, that reduction.

## Source question and closest full-result candidates

- **Freij-Hollanti, Morris and Šapokaitė (2026), Section 5 after Theorem 5.1:** explicitly asks for sufficient girth-eight conditions from the input's 2-by-2 submatrices, together with effects on decoding-relevant graph properties. The checked version is [arXiv:2606.11987v1](https://arxiv.org/html/2606.11987v1#S5). Our rectangle-pair formulation answers the girth-condition portion. It does not itself settle every decoding-related question in that sentence.
- **Fossorier (2004), Theorem 2.1:** supplies classical QC alternating-sum cycle criteria. These identify the input's short-cycle obstructions; the product reduction is an additional step. [Primary PDF](https://www.josephboutros.org/ldpc_vs_turbo/ldpc_Fossorier_ITaug04.pdf).
- **Smarandache and Mitchell (2021), Theorems 6 and 9:** provide classical matrix-product and exponent-difference girth equivalences. The inspected statements concern classical QC arrays, including a three-block-row case. They do not state the arbitrary rectangular symmetric LP reduction. [Primary text](https://arxiv.org/html/2105.03462v1).
- **Raveendran, Declercq and Vasić (2025), Section III-B after (20):** uses the same monomial LP family and exhibits the unavoidable eight-cycle cancellation. No full input-to-product four/six-cycle equivalence was located there. [Primary text](https://arxiv.org/html/2503.07567v1).
- **Okada and Kasai (2026), Lemma 3 and Corollary 6, v3:** gives short-cycle exclusion for an ordinary square binary HGP input, and forced eight-cycles in CSS-constrained CPM lifts. This is a close proof-method predecessor. Taking the binary expansion of our input before forming its HGP produces a larger graph, not our LP graph. Alternatively, using the fully populated binary support fails their no-four-cycle premise. Neither substitution proves the target as an immediate application. [Primary text](https://arxiv.org/html/2604.27817v3).
- **Zhang (2024), Theorem 5:** the previously inspected theorem assumes base-factor girth greater than eight. Our complete bipartite input support has girth four. Its written hypotheses therefore do not supply our arbitrary-exponent equivalence. [University text](https://dukespace.lib.duke.edu/server/api/core/bitstreams/8f596ec8-b362-43da-bf61-f8c26f0c5edc/content).

## Additional checks in this pass

The girth passages and construction definitions in [Degenerate Quantum LDPC Codes With Good Finite Length Performance](https://arxiv.org/html/1904.02703v3), [Bias-tailored quantum LDPC codes](https://arxiv.org/html/2202.01702v3), and [High-rate qLDPC processors](https://arxiv.org/html/2607.28795v1) were inspected. They discuss different generalized-product examples, LP construction and seed-girth design, or classical weight-matrix girth obstructions; no matching full theorem was located in those passages. In particular, the bias-tailored paper explicitly distinguishes expanding before the product from expanding after it (Section 3.4).

Search formulations included lifted product with “if and only if”, “necessary and sufficient”, “characterization”, “classical”, “no 4-cycles”, “no 6-cycles”, “equals”, and “inherited”; hypergraph-product girth; and exact titles of the closest papers. Search results were discovery aids, not proof-level evidence.

The access gap remains **Amirzade, Panario and Sadeghi (2024), Girth Analysis of Quantum Quasi-Cyclic LDPC Codes**, [DOI 10.1134/S0032946024020017](https://doi.org/10.1134/S0032946024020017). A fresh exact-title search did not yield an inspectable full English article. Its [author conference abstract](https://aca2025.github.io/assets/abstract/13_11.pdf) describes fully connected QC CSS arrays, not the target equivalence; an abstract cannot exclude an equivalent theorem elsewhere in the article. The related Russian article has a different DOI and cites the English article, so it is not treated as a substitute.

Appropriate claim: **We give a Lean-verified necessary-and-sufficient answer to the girth-eight conditions requested in the source paper, using established QC cycle criteria and product-cycle methods. No earlier equivalent full characterization was located in this audit.** Mathematical priority and first-formalization priority remain unestablished.
