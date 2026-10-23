# Weight-six logical operators in the unchanged cyclic benchmark

The baseline has **quantum distance exactly six**. Each of the three comparison codes has **quantum distance at least eight**. These are exact finite conclusions for both Pauli sectors, not a new general distance formula. They expose a material confound: the earlier benchmark controlled length and dimension but compared codes of different distances.

This bounded continuation addresses a concrete part of Freij-Hollanti, Morris and Sapokaite's [Section 5 / Conclusion](https://arxiv.org/html/2606.11987v1): decoding-related consequences of the girth conditions, particularly graph interpretations of low-weight logical constraints. The girth-condition part is already proved. Their broader performance program remains open. [Fixed protocol](LOW-WEIGHT-PROTOCOL.md).

## Exact finite census

All four existing codes have 252 qubits, dimension ten, girth eight and connected Tanner graphs. The following counts hold **in each Pauli sector separately**:

| Code | Interior exponents | Absorbing supports of size four | Weight-six stabilizers | Weight-six logical supports | Quantum distance |
| --- | --- | ---: | ---: | ---: | --- |
| Baseline | (1,2,3,6) | 3,150 | 126 | 14 | 6 |
| Previous best | (1,2,3,8) | 2,646 | 126 | 0 | at least 8 |
| Minimum 2 | (1,3,6,10) | 2,520 | 126 | 0 | at least 8 |
| Minimum 4 | (1,4,6,2) | 2,520 | 126 | 0 | at least 8 |

A lower bound of eight is not an exact distance-eight assertion. No weights above six were searched in this step.

Each binary check column has odd weight three, so every kernel word has even weight. Nonzero/distinct column syndromes exclude weights one and two. All 31,626 unordered-pair syndromes are distinct and nonzero, excluding weight four. Thus no nonzero kernel support has weight below six.

The main C++ census sorts all 2,635,500 unordered triples by their exact 126-bit syndrome. Distinct triples in the same bucket are disjoint because an overlap would produce a forbidden kernel word of weight two or four. Each weight-six support appears exactly ten times as an unordered 3+3 split. Every resulting word is tested against the full companion row span. This covers every weight-six kernel support, including stabilizers, and does not search only previously suspected motifs.

An independent C++ algorithm uses pair/triple matching with one anchored variable. Cyclic translation of a support can put a variable in its smallest occupied block at fiber zero. Anchoring each block's zero fiber and completing the other five variables therefore covers every translation orbit; shifting back restores all supports. The validator checks that translating by one preserves both check-row sets and stabilizer-row sets. This anchored 2+3+1 algorithm agrees exactly with the full 3+3 census in all eight code-sector instances. Independent lowest-pivot elimination checks the stabilizer classifications.

## A precise graph-property limitation, checked in Lean

In the baseline, consider zero-based expanded variable supports

- logical: `{28,56,84,126,184,244}`;
- stabilizer: `{0,14,28,126,168,210}`, the first companion check row.

Both induce six variables and nine checks of degree two. Contracting the checks gives exactly `K3,3`, with the first three support entries on one side and the last three on the other. All kernel supports found in the census have this same contracted topology. Nevertheless, the two displayed supports have different membership in the companion stabilizer row space.

The [Lean certificate](../dyadic-rank/CyclicLogicalSix.lean) proves this distinction for the actual baseline expansion. Its sparse dual witness is supported on `{196,198,200,202,204,206,208,238,240,242,244,246,248,250}`. The associated linear functional vanishes on every companion row but equals one on the logical support. It therefore vanishes on the entire stabilizer span, proving logical nonmembership. The stabilizer support is proved equal to an actual companion row. Finite certificates also check zero syndrome, the expansion/indexing bridge and both `K3,3` adjacencies, including the nine induced degree-two checks.

The main theorem is `CyclicLogicalSix.same_local_topology_different_logical_role`. There are ten audited theorem declarations, with standard foundational axioms only. This shows that a classifier using only this support's local unlabeled Tanner topology cannot distinguish its logical role. It does not say that global Tanner data, voltage labels or the companion matrix cannot distinguish it.

The complete census and distance bounds are computational results; this Lean file does not formalize the exhaustive enumeration. The coefficient field is `ZMod 2`, the stabilizer space is the full linear span, and the graph is linked to the explicit baseline circulant expansion. [Axiom/build log](logical-six-lean-check.txt).

## Consequences for the paper and source program

The original one-sector min-sum measurements remain unchanged: at p=4%, baseline failure was 4.385% and Minimum 2 failure was 2.523%. The code selection changed absorbing multiplicities **and** excluded the baseline's minimum-weight logical supports. Those measurements therefore cannot isolate absorbing-count reduction as the cause. We have identified a concrete algebraic confound, not quantified its causal share of the performance gain.

The baseline's column relation was already linked to the row/column partition program of Raveendran, Declercq and Vasic, [On the Minimum Distances of Finite-Length Lifted Product Quantum LDPC Codes](https://arxiv.org/html/2503.07567v1), Section IV-D and Section V. We credit that design mechanism. The contribution here is a complete weight-six census for these saved instances and a checked example showing the limitation of local topology alone; no priority for the general low-weight-logical mechanism is claimed.

For the source question, this adds a finite distance distinction and an explicit limitation on local graph predictors to the existing absorbing/stopping consequences and expansion counterexample. Still open are exact optimized distances above the new bound, a broad voltage-labelled characterization of logical supports, causal prediction of decoder outcomes, an optimal objective across code families and a validated asymptotic error-floor law. This step introduces no new codes, noise samples or decoder settings, and stops at weight six.

## Reproduce

```sh
# Repository root
python3 formalization/cyclic-lifts/search/logical_six.py
python3 scripts/validate_cyclic_logical_six.py
python3 formalization/cyclic-lifts/search/generate_logical_certificate.py
cd formalization/dyadic-rank
lake -f lakefile-cyclic.toml env lean CyclicLogicalSix.lean
```

The generator reads the saved explicit certificate and maintained proof body; it does not search for the dual witness. The witness is independently checked by both the validator and Lean. [All kernel supports](search/logical-six-results.json) · [Explicit witness data](search/logical-six-certificate.json) · [Validation log](logical-six-checks.log) · [Verification record](logical-six-verification.json).
