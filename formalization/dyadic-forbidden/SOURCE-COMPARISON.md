# P11 forbidden sets: reconstruction and comparison

Checked October 23, 2026 against arXiv:2605.01942v1. Source authors: Anthony Gómez-Fonseca, Gretchen L. Matthews, Kirsten D. Morris and Tefjol Pllaha. [Primary paper](https://arxiv.org/html/2605.01942v1).

**Result:** the cumulative, full-pattern short-cycle construction reconstructed below is complete for thresholds six and eight in P11's single-permutation-block model. Its literal ordered pattern enumeration, tailless nonbacktracking (TBC) zero-sum criterion and our prefix checker now have kernel-checked correspondences. This closes the mathematical comparison for that reconstruction. The paper does not determine a unique implementation of its `forbidden` primitive, so identity with the authors' software, or with an unspecified smaller selection of symbolic formulas, is not established.

The source question is the Section 7 request concerning completeness at lengths six and eight. Its meaning here is fixed by Definition 4.20's girth threshold; this result makes no assertion about all absorbing sets or decoder failures. The [literal optimized appendix enumeration](APPENDIX-ENUMERATION.md) is now also fully proved in Lean. The source-specific target is recorded as complete for this cycle/girth interpretation.

## What is explicit, and what is reconstructed

| Source item | Explicit information | Consequence for reconstruction |
| --- | --- | --- |
| Equation (14), Section 4.3 | One dyadic permutation in each occupied array cell | Work with a binary support and one label in `F₂^ell` per cell; not sums of permutations in one cell. |
| Definition 4.20, PDF page 15 | A forbidden shift forces girth at most `g` | The test is cumulative over lengths at most `g`, not just exact length `g`. |
| Remark 4.21, PDF page 15 | Unassigned indices do not participate | Enumerate supported patterns after filling the candidate cell. |
| Algorithms 2–3 and the paragraph after Algorithm 2, PDF pages 16–17 | The primitive returns the forbidden set; no body is supplied | A correct realization must satisfy the stated contract. No unique implementation can be recovered from this alone. |
| Theorem A.4 and proof, PDF pages 24–25 | Six-edge hexagon, three distinct rows and columns, equality of two triple sums | Test every supported hexagon equation and retain the four-cycle forbidden set. |
| Theorem A.6's preceding list and proof, PDF pages 26–29 | Twenty-one four-step row-pattern classes, two half-walk sums, cyclic column inequalities, doubled rectangles included | Test every supported member of those classes, including repeated blocks and equations whose candidate coefficient vanishes. |
| Remark A.7, PDF page 29 | Restrict to patterns using the available rows when fewer than four rows exist | Include two-/three-row cases rather than requiring a literal four-row submatrix. |

The cumulative interpretation is also explicit in Example 1 of the cited predecessor, Gómez-Fonseca, Smarandache and Mitchell, *A Low Complexity PEG-like Algorithm to Construct Quasi-Cyclic LDPC Codes* (2023), PDF page 2: its six-cycle forbidden set is the union of its four-cycle set and additional six-cycle constraints. We use its union principle, not cyclic arithmetic modulo `N`. P11's labels compose by XOR. [Primary manuscript](https://par.nsf.gov/servlets/purl/10487343), [DOI](https://doi.org/10.1109/ISTC57237.2023.10273481).

No supplied pseudocode explicitly instructs the implementer to discard all even-occurrence equations. That alternative was our diagnostic shortcut in the first investigation, and must not be attributed to P11.

## A concrete source-derived procedure

Let `B` be a partial label array, `s` its candidate cell, and `B[a]` the array with that cell assigned `a`. Define `Zₖ(B[a])` to mean that a supported TBC base word of length `k` has XOR sum zero. Set

\[
F_6(B,s)=\{a:Z_4(B[a])\lor Z_6(B[a])\},\qquad
F_8(B,s)=\{a:Z_4(B[a])\lor Z_6(B[a])\lor Z_8(B[a])\}.
\]

The paper and Python index an array by `(check row, variable column)`. The Lean label function takes `(variable, check)`, so the correspondence is `B_Lean(v,c) = B_paper[c][v]`; `binaryExpansion` places check/fiber pairs on matrix rows and variable/fiber pairs on columns. Missing blocks are `None`/`Option.none`, and integer Python labels encode bit vectors with XOR, not addition modulo the lifting factor.

To compute `Z₂ₜ`, use row word `(r₀,…,rₜ₋₁)` and column word `(c₀,…,cₜ₋₁)`, with cyclically adjacent row names different and cyclically adjacent column names different. The edge list is

\[
(r_0,c_0),(r_1,c_0),(r_1,c_1),(r_2,c_1),\ldots,
(r_{t-1},c_{t-1}),(r_0,c_{t-1}).
\]

Every listed cell must be occupied. Split the label sum into two consecutive halves and test their equality. In characteristic two, that equality is equivalent to zero total XOR. Specifically:

- For four edges, these are the familiar rectangle conditions.
- For six edges, the row and column words each have three distinct names. The two triple sums are precisely the hexagon condition used in A.4, after rotation/reversal and variable renaming.
- For eight edges, use the 21 row classes before A.6. In the source's column notation the word is `(u,v,v′,u′)`. The within-half constraints `u≠v`, `u′≠v′` and joining constraints `u≠u′`, `v≠v′` are exactly its cyclic adjacent-column inequalities. A.6's two four-label expressions are the half sums of these words; reversing the second half does not change its XOR.

The executable [source_compare.py](search/source_compare.py) implements this reconstruction using the row classes and half-sum collisions. It does not call the prefix simplicity filter to define its answer. It enumerates candidate values, so a candidate occurring twice can cause either every candidate or no candidate to satisfy the equation. It never divides by a zero coefficient.

All supported patterns are included, even those avoiding the candidate cell. This implements Definition 4.20 on a graph that already has a short cycle: then every candidate is forbidden. A routine that considers only newly created cycles has the same output **only under the invariant that the pre-insertion graph has no cycle within the threshold**. That invariant cannot silently be assumed after a PEG fallback. No PEG output is claimed to achieve an impossible target girth.

## Why the source families exhaust the relevant words

A simple cycle in the expanded Tanner graph projects to a closed alternating base walk. It cannot immediately reverse a base edge: for a fixed dyadic permutation, a lifted vertex has exactly one neighbor over the other endpoint of that base edge. A base reversal would therefore repeat the lifted vertex. The same argument applies at the closing junction. Thus the projected word is TBC.

A projected word of length four, six or eight visits respectively at most two, three or four check-row positions and the same number of variable-column positions. Enumerate its positions in cyclic order. This gives exactly the row/column description above. At length six the adjacent-distinct triple uses three distinct row names. At length eight relabel the at most four distinct visited rows by ordered names in `{h,i,j,k}`. The finite classification in `source_row_patterns_complete` proves that every proper four-step row word is a rotation or reversal of a listed class. `arbitrary_row_patterns_complete` extends the certificate to arbitrary row types by relabeling. A simultaneous rotation/reversal of the column word preserves supported cells and total XOR. The low-row restrictions in Remark A.7 preserve every class that is actually usable. This establishes exhaustion, without using A.6's numerical cycle multiplicities.

Conversely, the cyclic row/column inequalities describe a TBC base word. A zero XOR lifts it to a closed TBC walk. The lifted walk need not itself be a simple cycle of that exact length. It does, however, contain a simple cycle no longer than the word. This is sufficient for cumulative forbidden membership.

## The missing logical bridge, now in Lean

[DyadicForbiddenSource.lean](../dyadic-rank/DyadicForbiddenSource.lean) proves:

1. `reduced_path_or_boundedCycle`: every nonbacktracking walk is a path or contains a simple cycle of no greater length. The proof inducts on the walk, stopping at a first repeated vertex and extracting a simple cycle.
2. `two_step_fiber_unique` and `reduced_project_iff`: the single-permutation voltage lift preserves and reflects nonbacktracking. This is the essential covering-model hypothesis; arbitrary graph homomorphisms do not suffice.
3. `cycle_tbc` and `tbc_project_iff`: native simple cycles supply TBC projected words, including the closing junction. `TBC p` is implemented as nonemptiness and reducedness of `p.append p`.
4. `source_tbc_complete`: zero-voltage TBC words of length at most `g` exist if and only if the actual lifted graph has a simple cycle of length at most `g`.
5. `sourceCheck_eq_completeCheck`: the terminating TBC zero-sum checker equals the previous terminating prefix checker for every bound.
6. `sourceForbiddenCheck_eq` and `sourceForbiddenCheck_spec`: the equality holds for candidate labels in partial permutation-block arrays, and the specification is the Tanner graph of the actual expanded binary matrix. `source_dyadic_six_eight` specializes the equality to `Fin ell → ZMod 2`, including bounds six and eight.

These are general proofs, not consequences of the finite scan. The original TBC layer has 18 audited declarations. A further 49 audited declarations in `DyadicForbiddenAppendix.lean` now prove the literal arithmetic transcription and ordered enumeration described above, with a separate pair of kernel-evaluated execution checks. Together with the original 23 prefix/matrix declarations this gives 90 library declarations plus two execution checks. All observed axioms are `propext`, `Classical.choice` and `Quot.sound`. The independent Python implementation is regression evidence; it is not an extracted Lean program.

## Counterchecks and interpretation

The source-derived reconstruction, prefix checker and independently expanded graph agree on **21,168 candidate-label/threshold checks across 1,043 partial arrays**, thresholds four, six and eight. [Saved comparison](search/source-results.json).

For the partial `2×2` array `[[0,0],[0,None]]` over `F₂`, the reconstruction returns `{0}` at thresholds four and six and `{0,1}` at threshold eight. It includes the nonzero-label doubled rectangle that the odd-occurrence-only shortcut misses.

With all four labels zero, the eight-step half-sum collision is true but there are no simple eight-cycles: the graph is two disjoint four-cycles. The cumulative threshold-eight membership remains correct. This is exactly why an unqualified exact-length interpretation of the collision test is unsafe. The 2023 cycle-counting predecessor's Lemma 11/Remark 12, PDF page 9, already distinguishes nonbacktracking closed walks from simple cycles outside its length/girth restriction. We do not claim that observation as new. [Primary manuscript](https://par.nsf.gov/servlets/purl/10463749).

**Supported conclusion:** P11's full short-cycle pattern families yield complete cumulative forbidden sets at six and eight, with a general Lean proof of the TBC-to-checker equivalence. This supplies an affirmative mathematical answer for the cycle/girth reading of its question. **Unsupported conclusions:** that an unpublished author program has been verified; that A.6's exact-count coefficients are certified; that every decoding pathology is eliminated; or that this standard voltage-walk completeness principle is a new mathematical discovery.
