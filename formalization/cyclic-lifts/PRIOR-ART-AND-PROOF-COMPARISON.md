# Girth-eight characterization: prior art and proof comparison

The optimized-matrix and decoding follow-up is recorded in the final section,
[Optimized matrix and decoding benchmark](#optimized-matrix-and-decoding-benchmark).

Checked October 22, 2026. The recorded theorem is fully proved in Lean. **We have not located an earlier equivalent full characterization, and we have not established mathematical priority.** Its component criteria, eight-cycle mechanism, and relevant support argument have earlier sources. The existence of these predecessors does not by itself establish that the exact characterization was already stated or proved. We should present the result as a machine-checked specialization and combination of established coding-theory methods, without claiming an established new mathematical discovery. First Lean formalization and proof-method priority remain unestablished. [Source records and check results](prior-art-review.json).

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

## Follow-up: was the full characterization already proved?

This follow-up explicitly searches for mathematical equivalence, allowing
reindexing, exponent-sign conventions, row/column normalization, and a graph-level
formulation in place of the rectangle/hexagon formulas. The target is the
arbitrary-dimensional all-monomial cyclic construction, with at least two rows
and columns. An equivalent formulation would be: its X graph has girth eight
exactly when the ordinary circulant expansion of the input matrix has no four-
or six-cycles. Merely stating a voltage-sum test for the expanded product matrix
does not establish the reduction to tests on the original input matrix.

| Candidate | Does it supply the full target under matching hypotheses? |
| --- | --- |
| Fossorier (2004), Theorem 2.1 | No direct LP characterization. It supplies the input matrix's short-cycle test; the product-graph reduction and upper bound still have to be supplied. |
| Raveendran–Declercq–Vasić (2025), Section III-B after (20) | No full iff located. This is the same monomial LP family and gives its unavoidable eight-cycle, but that paragraph does not establish the input-to-product four/six-cycle equivalence. |
| Zhang (2024), Theorem 5 | Not the target with its written hypotheses: it assumes base-factor girth greater than eight, whereas the fully populated input protograph here is complete bipartite and has girth four. The comment that hypotheses can be relaxed is not a proof of our full relaxation. |
| Okada–Kasai, arXiv:2604.27817v3, Lemma 3 and Corollary 6 | Not the same iff. Lemma 3 gives sufficient short-cycle exclusion for a square binary HGP input. Corollary 6 combines absence of short cycles in the unlifted HGP graphs with forced eight-cycles in constrained CPM lifts. Our monomial input may have four/six-cycles in its unlifted support and remove them through exponents; those hypotheses cannot simply be substituted. [Pinned primary text](https://arxiv.org/html/2604.27817v3). |
| Raveendran et al., *Finite Rate QLDPC-GKP Coding Scheme that Surpasses the CSS Hamming Bound*, Quantum 6, 767 (2022), Section 4.1, (17), Tables 1–2 | Same symmetric LP construction and examples of girth eight predate the source question. The inspected construction section gives examples, not the arbitrary-matrix equivalence. [Primary text](https://arxiv.org/html/2111.07029v2), [publication](https://quantum-journal.org/papers/q-2022-07-20-767/). |
| Abiad–Castriota, arXiv:2607.13666v1, Corollary 4.11 and Remark 4.13 | Not the target. The iff is a joint Sidon criterion for girth at least six of generalized bicycle codes. The following remark discusses six-cycle counts through additive three-energies; it does not state our arbitrary rectangular monomial LP equivalence. [Primary text](https://arxiv.org/html/2607.13666v1). |

The source's arXiv record still lists only v1, submitted June 10, 2026. The
source therefore still explicitly asks the sufficient-condition question in
the version checked. [Version record](https://arxiv.org/abs/2606.11987).
This supports saying our theorem answers the girth-condition part of its
question. It is not independent evidence that no earlier answer exists.

The follow-up used full-equivalence, classical-input-girth, necessary/sufficient,
rectangle/hexagon, QC-GHP and hypergraph-product search terms, plus source-author
and exact-title searches. No equivalent prior full characterization was located
in the inspected primary texts. Search hits outside those texts are discovery
leads, not sources for this negative assessment. Google Scholar and Semantic
Scholar citation links from the source's arXiv page returned tool errors; no
complete forward-citation census is claimed.

An additional access gap is Farzane Amirzade, Daniel Panario and Mohammad-Reza
Sadeghi, *Girth Analysis of Quantum Quasi-Cyclic LDPC Codes*, Problems of
Information Transmission 60, 71–89 (2024), DOI
[10.1134/S0032946024020017](https://link.springer.com/article/10.1134/S0032946024020017).
The publisher abstract and
[author's conference abstract](https://aca2025.github.io/assets/abstract/13_11.pdf)
describe fully connected QC CSS codes, including a girth-six upper bound at
column weight at least three and constructions at column weight two. That is
different from the sparse product-matrix support in our theorem, but the full
journal proof was not accessible here. We do not count this paper as a
full-text exclusion of an equivalent theorem. A conference manuscript link
also returned HTTP 403.

The defensible status is therefore **a proved answer to the source's girth
question, with no equivalent prior characterization located in this bounded
audit; priority remains undetermined**. Neither "already proved in the
literature" nor "first solution to a previously unsolved problem" has been
established for the exact characterization. A simple consequence of earlier
methods can answer a published open question without representing a major new
proof technique. The decoding-property portion is outside our proved result.

### Browser follow-up on missing texts

A subsequent Google and Google Scholar search in Edge succeeded where the
earlier citation-service tool links had failed. Scholar listed three versions
of the 2024 English journal article: Springer, ProQuest and ACM. The
[ProQuest result](https://www.proquest.com/openview/44290fb4d27495e5e4007dbcb5a13289/1.pdf?pq-origsite=gscholar&cbl=2043532)
displayed a one-page preview and explicitly described full access as dependent
on a library or institution. The
[ACM record](https://dl.acm.org/doi/abs/10.1134/S0032946024020017)
showed the abstract and subscription controls, not the full proof. No accessible
full English journal text was obtained from those versions. The CIRM program
and conference PDF both ended with browser network errors.

Scholar's six citing results for the English article included three distinct
accessible research titles, two records of the related Russian article, and an
unrelated citation-only journal record. Thus six results are not six distinct
substantive downstream papers. The related Russian article has a separate DOI,
10.31857/S0555292324020013, and its journal page lists the English girth-analysis
article as reference 11; it must not be silently substituted for the missing
English text. Its RCSI journal page labels the PDF restricted. No complete
proof from that Russian article was read in this browser pass.

Two additional citing leads were inspected in their accessible arXiv HTML:

- Daiki Komoto and Kenta Kasai, *Explicit Construction of Quantum Quasi-Cyclic
  Low-Density Parity-Check Codes with Column Weight 2 and Girth 12*,
  arXiv:2501.13444v2, May 3, 2025. Its definition of a QC array in Section II
  uses a fully populated array of CPMs, and its construction targets
  column-weight-two orthogonal pairs of girth twelve. These are different
  hypotheses and conclusions from the rectangular lifted-product iff.
  [Primary text](https://arxiv.org/html/2501.13444v2).
- Kenta Kasai, *Breaking the Orthogonality Barrier in Quantum LDPC Codes*,
  arXiv:2601.08824v4, August 10, 2026. Sections 3.1 and 3.3 concern active
  submatrices of generalized Hagiwara–Imai parent matrices, with affine
  permutation blocks and commutation constraints. Theorem 3.4 is an
  eight-cycle upper-bound statement in that setting, not our input-matrix
  rectangle/hexagon equivalence.
  [Primary text](https://arxiv.org/html/2601.08824v4).

The third substantive citing title was Abiad–Castriota, already compared above.
A separate exact-title Scholar search for the original Freij-Hollanti–Morris–
Šapokaitė source displayed its record and no "Cited by" link in the observed
result. That is a dated observation about Scholar's index, not proof of zero
citations everywhere. Browser access improved discovery and citation checking,
but the missing English full-text gap and the priority uncertainty remain.

### X sanity check

A bounded X Latest search in Edge found no displayed results for
`2606.11987`, `"lifted product" girth`, or `"Graphical Analysis" "Lifted"`.
The broader query `girth LDPC` returned related work. The strongest apparent
match was [Kenta Kasai's June 25, 2026 announcement](https://x.com/kasai_lab/status/2070320002532782483)
of the rate-two-thirds girth-eight two-branch finite-field construction. Its
[linked primary paper](https://arxiv.org/html/2606.27130v2), particularly the
Introduction and Sections 2 and 3.3, specifies an explicit finite instance and
its lift constraints. It does not state our arbitrary rectangular monomial
LP characterization. Other returned announcements concerned pair-partition
girth-six instances and the already compared square-base HGP paper.

No announcement of an equivalent proof was identified in this sanity check.
This adds bounded social-discovery evidence, not a priority certificate or
proof that no relevant post exists. No messages, replies or posts were sent.

## Reproducibility and limits

[Comparison checks](../dyadic-rank/CyclicPriorArtChecks.lean) prove three algebraic translations: the two-step rectangle identity, the three-step hexagon reindexing, and the published eight-label cancellation. Run from `formalization/dyadic-rank`:

```
lake -f lakefile-cyclic.toml env lean CyclicPriorArtChecks.lean
```

All three have only standard axioms. They are separate comparison lemmas, not additions to the 75-theorem library count. They check formula translation; they do not formalize the cited papers as documents or import their proofs. [Axiom output](prior-art-checks.log).

The search included scholarly web/arXiv queries, backward references from the source paper, and relevant later work already in the repository. Search hits were used for discovery; the comparison rests on inspected primary texts. PDF pages with the product-cycle proofs and matrix formulas were rendered and reviewed. Full copies stay under ignored local extraction paths. Fossorier's full text was readable through the web tool, but direct local PDF retrieval returned HTTP 403; no local file hash is claimed for that source. The machine-readable review records pinned versions, locators, retrieval limits, local source hashes where available, and the bounded negative result for the identical combined theorem. A later publication, unindexed paper or alternate wording may have been missed.

## Optimized matrix and decoding benchmark

Checked October 22, 2026. **No exact earlier occurrence of the optimized matrix, fixed-size absorbing-set minimum, or numerical comparison was located in this bounded search. Priority remains undetermined.** The general code-design strategy and the existence of decoding gains from changing a lifted-product base matrix have clear predecessors. Our experiment is not evidence of a new decoder or a general new coding principle.

The exact target is the fully populated exponent matrix `[[0,0,0],[0,1,3],[0,6,10]]` over `Z/14Z`, used in the symmetric LP construction, with 252 physical and 10 logical qubits. Its observed 2,520 four-variable absorbing sets are the exhaustive minimum within the normalized connected girth-eight search. The comparison target is the baseline `[[0,0,0],[0,1,2],[0,3,6]]`, at the same modulus, length and dimension, with fixed-point normalized min-sum, normalization 0.8, 100 iterations, one Bernoulli Pauli sector and perfect syndrome. The reported 4.385% versus 2.523% failure rates at physical error probability 4% are conditional on precisely that experiment.

| Prior work | What it establishes for this assessment |
|---|---|
| Wang, Dolecek, Zhang and Wesel, [*Absorbing Set Spectrum Approach for Practical Code Design*](https://arxiv.org/abs/1106.0057), submitted May 31, 2011; primary abstract | Controlling absorbing-set spectra to improve iterative decoding is established in classical circulant-based LDPC codes. Different column weight, channel and code family; no exact matrix claim. |
| Wang, Dolecek and Wesel, [*The Cycle Consistency Matrix Approach to Absorbing Sets in Separable Circulant-Based LDPC Codes*](https://arxiv.org/abs/1208.6094v2), December 5, 2012 version; primary abstract | Characterizing multiplicities and avoiding harmful absorbing sets, with limited-precision decoding gains, predates this work. Only the abstract was needed/inspected for this broad-method comparison. |
| Raveendran, Declercq and Vasić, [*On the Minimum Distances of Finite-Length Lifted Product Quantum LDPC Codes*](https://arxiv.org/html/2503.07567v1#S5.SS1), March 10, 2025, Section V-A, Eq. (92), Fig. 1 | Closest direct experimental predecessor: changes a base matrix while preserving length/rate and girth eight; compares `[[600,36,7]]` and `[[600,36,20]]` using BP+OSD-10. It reports substantially different decoding performance. Its 3-by-4, modulus-24 examples differ from our code and decoder. |
| Raveendran et al., [*Finite Rate QLDPC-GKP Coding Scheme that Surpasses the CSS Hamming Bound*](https://arxiv.org/html/2111.07029v2#S4.SS1), 2022, Section 4.1, Tables 1–2 | Earlier symmetric LP families and girth-eight numerical examples, with 3-by-4 and 3-by-5 input families. Different sizes and noise/decoder study. |
| Raveendran et al., [*Soft syndrome iterative decoding of quantum LDPC codes and hardware architectures*](https://link.springer.com/article/10.1140/epjqt/s40507-023-00201-1), October 19, 2023, Sections 2.4 and 4.1 | Prior syndrome min-sum equations and LP simulation methodology. Its simulation uses normalization 0.75 and different codes/noise scenarios; our decoder is an implementation of an established method. |
| Freij-Hollanti, Morris and Šapokaitė, [P34](https://arxiv.org/html/2606.11987v1#S5), June 10, 2026, Section 5 | Already specifies connectivity, girth, short-cycle multiplicity and minimal absorbing-set multiplicity as design objectives. Our search implements a finite instance of that agenda. |

There is a further algebraic link to the 2025 preprint's Section IV-D, Definitions 3/5 and Theorem 2: its row/column partitioning constraint (RCPC). With zero-based columns, our baseline has `c0+c2=2*c1 (mod 14)`. An exhaustive three-choice check finds no such row or column relation in the previous best or either rate-preserving minimum. This is a direct finite calculation, consistent with an existing explanation for low-weight logical operators. It does **not** determine the optimized quantum distances or isolate the cause of the measured gain. The preprint supplies a proof sketch and says further proof details will follow; our checked residual witnesses remain independent evidence for the baseline.

### Exact-match search and equivalence limits

Searches used matrix entries in spaced, comma-separated and polynomial/exponent contexts, the parameters `252,10`, lift size 14, count 2,520, and optimization/absorbing-set/short-cycle/min-sum terms. Inspected primary material included the papers above, Panteleev–Kalachev's [2021 code constructions](https://arxiv.org/html/1904.02703v3), Abiad–Castriota's [July 2026 spectral analysis](https://arxiv.org/html/2607.13666v1), the [Boutillon QC-LDPC construction tables](https://labsticc.univ-ubs.fr/~boutillon/ldpc/ldpc.htm), and the HTML of [OmniQEC](https://arxiv.org/html/2607.25865v1). The latter is a further precedent for automated code search and decoder evaluation; no exhaustive audit of its supplementary code collection is claimed. The spectral paper's inspected examples concern a different QC-GHP/GB setting, not this exact optimization.

The equivalence standard includes row/column permutation, row/column gauge shifts, unit scaling, sign reversal and transposition. Matching a few exponent strings or the same code parameters would not establish code identity. Conversely, absence of those strings does not exclude an equivalent representation, a submatrix of a larger table, a noncyclic presentation, or a code appearing only in supplementary files. No same-modulus, same-shape published candidate was retrieved that could be certified as the selected orbit. We have not performed a universal graph/CSS-code isomorphism census. Google Scholar citation coverage and all repositories were not exhaustively audited in this follow-up.

**Defensible claim:** a reproducible exhaustive optimization at this fixed size, plus a controlled decoder-specific benchmark, for which no exact earlier report was located in the inspected sources. The exact artifact may be independently useful; first publication of the matrix, the 2,520 minimum, or the benchmark has not been established. The 42.46% reduction is relative to our chosen baseline, not a claim to outperform the best published code or decoder.
