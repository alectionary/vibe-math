# Dyadic forbidden set completeness

This investigation implements a complete forbidden-label procedure for short cycles in partial arrays of dyadic permutation blocks. The general voltage/prefix criterion, binary-matrix bridge and finite checker are in [DyadicForbidden.lean](../dyadic-rank/DyadicForbidden.lean). The search compares the prefix procedure against an independently expanded Tanner graph. The [fully checked source-specific enumeration](APPENDIX-ENUMERATION.md) now proves the literal cumulative appendix-pattern procedure equivalent to the prefix checker. The paper supplies a contract, but no unique routine body whose software identity could be verified.

## Exact source target

Inventory target: **L-P11-forbidden**. The source is Anthony Gómez-Fonseca, Gretchen L. Matthews, Kirsten D. Morris and Tefjol Pllaha, *Combinatorial Analysis of Dyadic and Quasi-Dyadic Codes*, arXiv:2605.01942v1, submitted May 3, 2026. Section 7, PDF page 21, asks:

> whether forbidden sets are complete for lengths 6 and 8 pathologies

[Source question](https://arxiv.org/html/2605.01942v1#S7) · [PDF page 21](https://arxiv.org/pdf/2605.01942v1#page=21).

Definition 4.20, PDF page 15, specifies forbidden labels through the condition that the resulting Tanner graph has girth at most the threshold. Remark 4.21 treats unassigned blocks as absent. Algorithms 2–3 call `forbidden(H, var, g, N)` without a body. Their selection loop uses thresholds 4 and 6. Appendix A supplies cycle-pattern analysis. These distinguish the semantic set, a concrete procedure computing it, and additional decoding pathologies.

**Chosen precise target:** Given a partial array with at most one dyadic permutation per occupied cell, a candidate cell, and a threshold `g`, compute exactly the labels whose insertion yields a simple Tanner cycle of length at most `g`. We cover thresholds 6 and 8 and arbitrary fixed thresholds. A block may occur repeatedly in a projected cycle. Labels range over `F₂^ell`, including the boundary `ell = 0`. The Lean voltage theorem allows any additive commutative group.

## Prior art and attribution

- Gómez-Fonseca, Smarandache and Mitchell, *A Low Complexity PEG-like Algorithm to Construct Quasi-Cyclic LDPC Codes*, ISTC 2023, [DOI 10.1109/ISTC57237.2023.10273481](https://doi.org/10.1109/ISTC57237.2023.10273481), Definition 1 and Example 1, PDF page 2: the direct forbidden-set predecessor cited as P11 reference [5]. It explicitly constructs four-/six-cycle forbidden sets for a normalized QC array. Its cyclic labels require a justified translation to dyadic labels. [Author manuscript](https://par.nsf.gov/servlets/purl/10487343).
- The same authors, *An Efficient Strategy to Count Cycles in the Tanner Graph of Quasi-Cyclic LDPC Codes*, 2023, [DOI 10.1109/JSAIT.2023.3315585](https://doi.org/10.1109/JSAIT.2023.3315585), Lemma 11 and Remark 12, author manuscript page 9: explains the `k < 2*girth` restriction and explicitly identifies a doubled shorter cycle as a closed nonbacktracking walk that is not simple. This pitfall is established prior knowledge. [Author manuscript](https://par.nsf.gov/servlets/purl/10463749).
- Smarandache and Mitchell, *A Unifying Framework to Construct QC-LDPC Tanner Graphs of Desired Girth*, [arXiv:2108.01637v1](https://arxiv.org/abs/2108.01637v1), supplies broader QC girth-condition context; the abstract was checked, not every theorem.

The explicit trace construction implements standard voltage-lift reasoning. No mathematical novelty, first formalization, or refutation of the authors' unpublished routine is claimed. [Sources and bounded search record](prior-art.json) records retrieval gaps and which primary texts were actually read.

## Complete prefix procedure

For every supported closed base walk `p` with `3 ≤ length(p) ≤ g`:

1. Start its fiber at zero and accumulate oriented labels along every edge. In `F₂^ell`, addition and subtraction are both XOR.
2. Require total displacement zero.
3. Require the vertex/fiber pairs in the trace's tail to be pairwise distinct. The tail includes the final return to the origin, but excludes the initial occurrence.
4. Reject the candidate label if any word passes.

The procedure includes words using the new block twice or more, and cycles already present before insertion. It never equates zero total displacement alone with simplicity. An acyclic graph has no forbidden cycle: Mathlib's natural-valued `girth` uses zero for acyclic graphs, so the formal specification uses explicit bounded native cycles instead of the unsafe test `girth ≤ g`.

The Lean checker enumerates *all* bounded base walks using Mathlib's `finsetWalkLengthLT`; its graph input is the small protograph, not the expanded graph. The Python search prunes to cyclically nonbacktracking words and uses a separate BFS on the expanded graph as its oracle. That Python pruning/implementation is regression-tested, not itself extracted from Lean.

## Diagnostic counterexamples

Take the partial label array `[[0,0],[0,None]]` over `F₂`, inserting the lower-right label `a`. The pre-insertion graph is two copies of a four-vertex path.

| Candidate | Expanded Tanner graph | Girth |
| --- | --- | ---: |
| `a = 0` | Two disjoint four-cycles | 4 |
| `a = 1` | One simple eight-cycle | 8 |

Thus **both** labels are forbidden at threshold eight. A rule that solves only equations where the candidate occurs an odd number of times returns `{0}` and misses label `1`. The doubled rectangle uses the candidate twice, so its coefficient cancels. This is a counterexample to that explicitly defined diagnostic rule, not to a supplied P11 implementation.

Conversely, with all four labels zero, the doubled rectangle has zero total displacement but repeats a four-cycle. It is not a simple eight-cycle. This refutes an exact-length closure-only test; it does **not** refute the threshold-eight rejection, since the four-cycle already justifies rejection. The 2023 cycle-counting paper explicitly describes the repeated-cycle issue.

Lean checks the nonzero doubled rectangle as a native simple eight-cycle, and checks failure of prefix distinctness in the zero-label case.

## Search coverage

The deterministic search, seed `20261023`, checks:

- All 889 partial labeled `2×2` arrays with a designated missing cell, for fiber dimensions 0–3; every other cell is absent or has any permitted label.
- All 64 normalized `3×3` arrays with three arbitrary assigned interior labels over `F₂²` and a designated missing fourth interior cell.
- 90 sampled sparse/dense `3×3` and `4×4` arrays, with fiber dimensions 1–3.

Across 1,043 partial arrays, it performs **21,168 candidate-label/threshold checks** at thresholds 4, 6 and 8, with zero disagreements between the prefix checker and direct graph oracle. A separate DFS enumerates unoriented simple cycles of exact lengths 4, 6 and 8 in four diagnostic matrices and checks the rooted-word/orbit count conversion. The general Lean theorem, rather than this finite search, establishes completeness for the stated procedure.

[Search program](search/scan.py) · [Saved results](search/results.json) · [Lean axiom reports](lean-checks.log).

The source-specific row-pattern audit also checks the 21 representatives displayed before Theorem A.6 (PDF page 26). Lean proves that all 84 cyclically adjacent-distinct four-step row words over four row names are rotations or reversals of these representatives. Python independently obtains the same 21 classes. This certifies the row-pattern classification, not its multiplicity formulas or the complete forbidden-set routine. The Lean/Python lists use their own ordering.

## Checked declarations

The original 23 audited declarations include `goodWord_sound`, `goodWord_complete`,
`exact_cycle_complete`, `completeCheck_spec`, `lift_eq_binaryTanner`,
`forbidden_labels_matrix_complete`, `dyadic_threshold_complete`, and
`forbiddenCheck_spec`. The last theorem certifies the executable candidate
checker against native cycles in the actual expanded binary matrix.
`executable_counterexample` evaluates that checker on both labels in the
2×2 example at thresholds four, six and eight. All observed axioms are
`propext`, `Classical.choice`, and `Quot.sound`; there are no admitted proofs
or native evaluation axioms. The [verification manifest](verification.json)
records source hashes, exact audit coverage and finite-search scope.

## Fully checked source-specific enumeration

The [literal appendix enumeration](APPENDIX-ENUMERATION.md) is now completely matched in Lean. [DyadicForbiddenAppendix.lean](../dyadic-rank/DyadicForbiddenAppendix.lean) defines the printed-order 21 eight-step classes and all 42 half-path expressions, rectangle/hexagon equations, ordered used-row embeddings, occupied-block tests and column restrictions. It proves that its executable checker equals the prefix checker and detects exactly native bounded cycles in the expanded binary matrix at thresholds four, six and eight. The general TBC bridge remains in [DyadicForbiddenSource.lean](../dyadic-rank/DyadicForbiddenSource.lean).

There are **90 audited library declarations** (23 original, 18 TBC/source and 49 literal-appendix lemmas), plus **two kernel-evaluated execution checks**. The full Lake build succeeds. All observed axioms are `propext`, `Classical.choice` and `Quot.sound`. The [manifest](verification.json) records all source hashes and audit logs.

This completes inventory target `L-P11-forbidden` for its recorded cumulative cycle/girth meaning. Coverage is now **3/108 complete Lean targets (2.78%)**. The source's unpublished software identity, A.6's numerical multiplicity coefficients, PEG optimality, multi-permutation cells and all decoding pathologies remain outside this statement. No mathematical novelty or first-formalization claim is made.

The source-derived Python reconstruction agrees with the prefix checker and direct graph expansion on all 21,168 checks. [Program](search/source_compare.py) · [Results](search/source-results.json). These finite checks do not supply the general proof.

Reproduce from `formalization/dyadic-rank`:

```sh
lake -f lakefile-forbidden.toml build
lake -f lakefile-forbidden.toml env lean DyadicForbiddenAppendix.lean
lake -f lakefile-forbidden.toml env lean DyadicForbiddenAppendixChecks.lean
```

From the repository root:

```sh
python3 formalization/dyadic-forbidden/search/scan.py
python3 formalization/dyadic-forbidden/search/source_compare.py
python3 scripts/validate_dyadic_forbidden.py
```

The original dyadic and cyclic-lift paper snapshots remain unchanged.
