# Cyclic-lift groundwork for the P34 girth-eight question

The **general girth-eight characterization is checked in Lean**, with **75 audited theorems** across the library. For any exponent matrix with at least two rows and columns, the lifted-product X Tanner graph has a simple eight-cycle. Its girth is exactly eight **if and only if** every distinct-row/column rectangle sum and every distinct-triple hexagon sum is nonzero. The theorem also applies directly to the expanded binary parity-check matrix. This completes the recorded P34 girth target for the source model; inventory proof coverage is now **2/108 (1.85%)**. Connectivity, absorbing sets and other decoding-property optimization are separate targets.

The source problem is Section 5, after Theorem 5.1, in Ragnar Freij-Hollanti, Kirsten D. Morris and Patricija Šapokaitė, *Graphical Analysis of Lifted Product Code Constructions*, arXiv:2606.11987v1 (June 10, 2026). Its Equation (2.1) fixes the orientation of lift labels, and Equation (2.3) specifies the particular construction. The paper cites Gross and Tucker's *Topological Graph Theory* for its general graph-lift results. We use the paper as our source; we have not independently audited that book. Walk-closure and alternating-sum criteria are established graph-lift groundwork, and no priority claim is made for this mathematics or the finite example. [Primary paper](https://arxiv.org/html/2606.11987v1).

## General theorem and scope

Let `B` be an `m`-by-`n` exponent matrix over Z/rZ, with `m,n ≥ 2` and positive `r`. Every entry represents a circulant **permutation** block: exponent zero denotes the identity block, not a missing or zero matrix block. Let `G_HX` be the Tanner graph of `[B tensor I_n | I_m tensor B*]`, in the indexing proved equivalent to the expanded binary matrix by `xGraph_eq_matrixTanner`.

Define

```
R(a,b;c,d) = B[a,c] - B[a,d] + B[b,d] - B[b,c]
H(a,b,c;d,e,f) = B[a,d] - B[a,e] + B[b,e] - B[b,f] + B[c,f] - B[c,d].
```

Then `girth(G_HX) = 8` **if and only if** both conditions hold:

1. `R(a,b;c,d) ≠ 0` for every pair of distinct rows and distinct columns.
2. `H(a,b,c;d,e,f) ≠ 0` for every triple of pairwise distinct rows and pairwise distinct columns.

All arithmetic is modulo `r`. `baseHexagon_eq_rectangle_add` also checks

```
H(a,b,c;d,e,f) = R(a,b;d,e) + R(b,c;d,f).
```

Thus the second condition can be expressed entirely as a compatibility condition on pairs of 2-by-2 rectangle voltages: the two indicated sums must not cancel. This is `xGraph_girth_eq_eight_iff_rectangles`; merely requiring every rectangle to be nonzero is insufficient, as the ternary example below demonstrates.

The main declarations are `xGraph_girth_characterization` and `matrixTanner_hX_girth_characterization`. They use `[Nontrivial I] [Nontrivial J]` to express at least two row and column indices; witness-based versions accept explicit unequal indices. No normalization, connectedness, coprimality or primality assumption is imposed. The graph proof even extends to infinite index types and `ZMod 0`, but those extensions are not the source's finite circulant model. Sparse matrices with missing permutation blocks and noncommuting permutation lifts are outside this general eight-cycle theorem.

## Why an eight-cycle always exists

Choose distinct rows `i0,i1`, distinct columns `j0,j1`, and any indices `k,l` for the variable labels. Write `A_i = B[i,k]` and `D_j = B[l,j]`. The native walk `mixedEight` has vertices and fibers

```
C_i0,j0(A_i0-D_j0) → L_k,j0(-D_j0) → C_i1,j0(A_i1-D_j0)
 → R_i1,l(A_i1) → C_i1,j1(A_i1-D_j1) → L_k,j1(-D_j1)
 → C_i0,j1(A_i0-D_j1) → R_i0,l(A_i0) → C_i0,j0(A_i0-D_j0).
```

Every edge satisfies the source's exponent equation. The four check projections are distinct rectangle corners, the two left-variable projections are distinct, and the two right-variable projections are distinct. The block tags distinguish left variables from right variables. Consequently all eight lifted vertices are distinct, regardless of their fiber values. `mixedEight_isCycle` checks simplicity, `mixedEight_length` checks length eight, and `xGraph_exists_eight_cycle` packages the witness in arbitrary dimensions. `xGraph_egirth_le_eight` proves the extended-girth bound as well, so the argument explicitly excludes acyclicity rather than relying on the ordinary girth convention of zero for acyclic graphs.

The converse/forward assembly is short once this witness is available: girth eight forbids four- and six-cycles; conversely the complete short-cycle criteria exclude those lengths, bipartite coloring excludes odd lengths, and the eight-cycle attains the bound. The independent consumer rederives the modulo-seven example through the general criterion and checks the bound at a composite modulus with arbitrary, unnormalized exponents.

This is a verified characterization for the recorded graph model, not a claim to a new mathematical theorem or first Lean formalization. Comparison with published cyclic-lift criteria remains a separate literature task. The source's accompanying questions about other graph properties and decoding optimization are not answered by this girth theorem.

## Checked results

- **Walk lifting and closure:** an additive voltage graph has a graph homomorphism forgetting its fiber. Every base walk has a lift that projects back to that exact walk. Its endpoint fiber is the initial fiber plus the oriented label sum. A prescribed closed base walk has a closed lift at any chosen fiber **if and only if** its displacement is zero. This statement does not imply that the walk is a simple cycle.
- **Four-cycle criterion:** for any supported bipartite lift over an additive commutative group, a simple four-cycle exists exactly when a supported rectangle on distinct variables and distinct checks has alternating label sum zero. The four-vertex formulation is proved equivalent to Mathlib's `Walk.IsCycle` with length four.
- **Matrix/graph comparison:** `xGraph_eq_matrixTanner` proves equality with the Tanner graph of the explicit binary expansion of `B_X = [B tensor I_n | I_m tensor B*]`. Negating a circulant exponent transposes its permutation block. Both identity-factor supports and the conjugate-transpose sign are included. Finite row and column counts agree with `(mn)r` and `(n²+m²)r`.
- **Complete four-cycle test for P34:** `xGraph_native_fourCycle_iff` reduces *all* simple four-cycles of `G_HX`, including both variable-block families, to zero rectangles in the original exponent matrix. Mixed left/right rectangles cannot contribute a four-cycle.
- **Six-edge closure:** `hexagon_closes_iff` proves that a prescribed supported walk `v0-c0-v1-c1-v2-c2-v0` closes exactly when `s(v0,c0)-s(v1,c0)+s(v1,c1)-s(v2,c1)+s(v2,c2)-s(v0,c2)=0`. It allows repeated base vertices and does not equate closure with simplicity. With three pairwise distinct variables and three pairwise distinct checks, `hexagon_gives_six_cycle` produces a native simple cycle. The converse is now checked by `hasSixCycle_iff_hexagon`: every simple six-cycle has distinct projected triples and satisfies exactly this closure condition.
- **Complete six-cycle test for P34:** `xGraph_native_sixCycle_iff` reduces every native simple six-cycle to a zero alternating sum on three pairwise distinct rows and columns of the original exponent matrix. Every six-cycle uses only left-block variables or only right-block variables; mixed choices force two projected checks to coincide. The right-block sum becomes the same base hexagon test after reindexing and reversing its sign. This equivalence does not assume four-cycle exclusion.
- **Checked 3-by-3 example:** `sevenBase_girth` and `sevenBase_matrix_girth` prove exact girth eight for `[[0,0,0],[0,1,2],[0,3,6]]` modulo 7, in both the voltage graph and expanded binary matrix representations. Kernel reduction checks the finite rectangle/hexagon exclusions; a native simple eight-cycle provides the upper bound.
- **Structural six-cycle exclusion:** neighboring checks over one variable have injective projection. Consequently, a six-cycle would yield three distinct base checks joined pairwise through variables. `two_by_two_no_six` rules this out for **every** 2-by-2 exponent matrix: its check coordinates form a 2-by-2 grid, which has no coordinate-sharing triangle on three distinct points. No assumption on the labels is needed.
- **Symbolic girth-eight family:** `normalizedTwo_girth` proves exact girth eight for `[[0,0],[0,t]]` with `t ≠ 0`. This combines four-cycle exclusion, structural six-cycle exclusion, the explicit bipartite coloring, and a simple eight-cycle. `normalizedTwo_matrix_girth` transfers the result to the Tanner graph of the expanded binary `hX` matrix. These are symbolic theorems in the modulus and label, not certificates produced by the Python scan.
- **Ternary obstruction:** `rectangle_exclusion_not_sufficient_for_no_six` proves that the explicit 3-by-3 ternary base below has no four-cycles but does have a native simple six-cycle.

The general additive-group lemmas apply more broadly than cyclic lifts. To identify the source's finite circulant construction, take `A = ZMod r` with **positive modulus**. The formal algebraic definitions also make sense at `r=0`, where Lean's `ZMod 0` is infinite; that extension is not a finite circulant lift from the paper. The finite-dimension theorems explicitly require `NeZero r`. The P34 model uses a base with no zero permutation blocks; the generic bipartite lemmas separately allow sparse support.

## A uniform checked girth-eight family

For `B = [[0,0],[0,t]]`, with nonzero `t` in Z/rZ and positive `r`, the graph contains the cycle

```
C_00(0) → L_00(0) → C_10(0) → R_10(0) → C_11(0)
        → L_01(0) → C_01(0) → R_00(0) → C_00(0).
```

Here `R_il` denotes a right-block variable; the other symbols follow the convention below. All eight vertices are distinct, and all eight edges use zero exponents, independently of `t`. Lean checks the cycle, excludes every shorter simple cycle, and concludes Mathlib's native `girth = 8`. The construction works without a connectedness assumption and does not require `t` to generate the cyclic group. For positive modulus, the expanded binary matrix has `4r` rows and `8r` columns; the Tanner graph has `12r` vertices.

The no-six theorem is stronger than needed for this family: it applies to arbitrary 2-by-2 exponent matrices. The exact girth theorem currently uses the normalized family. We make no novelty claim for either result. The six-cycle criterion below now applies in arbitrary dimensions. The general exact-girth-eight characterization is now proved as stated above.

## Complete six-cycle characterization

For any exponent matrix `B : I → J → ZMod r`, a simple six-cycle in `G_HX` exists **if and only if** there are three pairwise distinct rows `i0,i1,i2` and three pairwise distinct columns `j0,j1,j2` such that

```
B[i0,j0] - B[i0,j1] + B[i1,j1] - B[i1,j2] + B[i2,j2] - B[i2,j0] = 0  (mod r).
```

This is `baseHexagon` in the code. The generic sparse-support theorem is `hasSixCycle_iff_hexagon`; the P34 specialization is `xGraph_hasSixCycle_iff`, with a native `Walk.IsCycle` version in `xGraph_native_sixCycle_iff`. These statements quantify over all cycles and all fiber choices, not only cycles discovered by enumeration.

Projection injectivity is essential to the converse. In a simple six-cycle, each pair of variables shares a check, and each pair of checks shares a variable. Repeating a projected vertex would therefore also repeat its fiber, contradicting simplicity. With exactly three vertices per side, this rules out every repeated projection. The argument does not assert this for longer cycles. After projection, P34's support equations exclude all six mixed left/right block patterns; the two pure patterns give the displayed test.

Together with the four-cycle equivalence and bipartite coloring, this provides a complete entrywise test for excluding simple cycles shorter than eight. The general `mixedEight` witness now supplies the exact upper bound uniformly whenever there are at least two rows and columns, completing the girth-eight equivalence.

## A checked 3-by-3 example

Over Z/7Z, use

```
0 0 0
0 1 2
0 3 6
```

`sevenBase_rectangles` excludes every distinct-row/distinct-column zero rectangle. `sevenBase_hexagons` excludes every zero hexagon on distinct triples. There are 36 eligible ordered rectangle choices and 36 eligible ordered hexagon choices; these are choices of indices, not counts of different cycles. Both universal finite assertions are proved with Lean's kernel-checked `decide`, with no native-evaluation axiom. The general cycle equivalences transfer them to absence of **all** four- and six-cycles in the full X graph.

`sevenEight` uses the same zero-fiber mixed-block eight-cycle displayed for the 2-by-2 family. `sevenEight_isCycle` checks all vertices are distinct and `sevenEight_length` checks length eight. Bipartite coloring excludes odd cycles, completing `sevenBase_girth : (xGraph sevenBase).girth = 8`. The consumer independently checks that `sevenBase` has exactly the displayed entries. It also checks that the expanded binary `hX` matrix has 63 rows and 126 columns, so the Tanner graph has 189 vertices. `sevenBase_matrix_girth` gives its native girth directly.

The candidate came from the earlier finite search recorded below. This step turns its Python girth observation into a Lean theorem. It makes no claim that the matrix or the underlying mathematics is new, and leaves the source's other graph-property and decoding-optimization questions separate.

## A checked six-cycle obstruction

Over Z/3Z, use the exponent matrix

```
0 0 0
0 1 2
0 2 1
```

Every rectangle using distinct rows and columns has nonzero alternating sum. Nevertheless, the full lifted-product X Tanner graph has the simple cycle

```
C_00(0) → L_00(0) → C_10(0) → L_10(2)
        → C_20(1) → L_20(0) → C_00(0).
```

`C` denotes a check, `L` a variable in the left block, and parentheses contain the fiber. Lean checks each edge, distinctness of the six vertices, length six, and absence of all four-cycles. This disproves the proposed simplification “nonzero rectangles alone suffice to exclude six-cycles.” The paper does not assert that simplification, so this is **not a counterexample to P34**. We make no originality claim for it.

## Finite experiments

The reproducible Python scan contains **432 cases**:

- Every normalized 2-by-2 exponent matrix for lift sizes 1 through 12: 78 cases.
- Every normalized 3-by-3 exponent matrix for lift sizes 2 through 4: 353 cases.
- One explicit 3-by-3 candidate at lift size 7: `[[0,0,0],[0,1,2],[0,3,6]]`.

Two independently written constructions produce identical adjacency sets: a voltage lift and direct binary block expansion. Direct check-triple six-cycle counts agree with projected voltage-walk enumeration that checks distinct **lifted** vertices. The girth distribution is 351 cases of girth four, 14 of girth six and 67 of girth eight. These enumeration counts remain **Python evidence, not Lean certificates**. The normalized 2-by-2 girth-eight cases are independently covered by the symbolic Lean theorem, and the 3-by-3, lift-size-seven example now has a separate Lean proof.

For normalized 2-by-2 matrices in the tested range, zero `t` gives girth four and nonzero `t` gives girth eight. The entire nonzero normalized 2-by-2 family is now proved in Lean, beyond the tested range. The lift-size-seven 3-by-3 example is now proved separately in Lean, using the complete entrywise six-cycle characterization. [Search script](search/scan.py), [all results](search/results.json).

## Reproduce the checks

The new `CyclicLift` library shares the existing pinned Lean/Mathlib environment in `../dyadic-rank`. It uses **an alternate Lake configuration**, so the original dyadic proof's pinned build configuration and source hashes remain unchanged. The manuscript's archived source bundle is unchanged.

From `formalization/dyadic-rank`:

```
lake -f lakefile-cyclic.toml exe cache get Mathlib.Combinatorics.SimpleGraph.Girth Mathlib.Combinatorics.SimpleGraph.Coloring.Constructions Mathlib.Data.ZMod.Basic
lake -f lakefile-cyclic.toml build CyclicLift
lake -f lakefile-cyclic.toml env lean CyclicChecks.lean
```

The project pins Lean 4.36.0-rc1 and Mathlib revision `5f7b4198d22a9c82e1c698a379334fe128095c82`. The consumer file checks symbolic and concrete statements and prints the axioms of every theorem in the new library. All observed axioms are among `propext`, `Classical.choice` and `Quot.sound`. No `sorry`, custom axiom or native-evaluation axiom is used. [Source hashes and commands](verification.json), [axiom output](verification.log).

From the repository root, run `python3 formalization/cyclic-lifts/search/scan.py` for the experiments. It uses only the Python standard library. These experiments test finite cases; the mathematical lemmas are checked separately by Lean.

## Files and next milestone

The Lean sources are in the shared environment:

- [Basic.lean](../dyadic-rank/CyclicLift/Basic.lean): voltage graphs, projected/lifted walks and native four-cycle equivalence.
- [Bipartite.lean](../dyadic-rank/CyclicLift/Bipartite.lean): supported rectangle closure and the complete generic four-cycle criterion.
- [LiftedProduct.lean](../dyadic-rank/CyclicLift/LiftedProduct.lean): P34 indexing, binary expansion, matrix comparison, finite dimensions and four-cycle reduction.
- [ShortCycles.lean](../dyadic-rank/CyclicLift/ShortCycles.lean): native six-cycle equivalence, hexagon closure, projection injectivity, triangle obstruction, bipartite coloring and the girth-eight assembly theorem.
- [SixCharacterization.lean](../dyadic-rank/CyclicLift/SixCharacterization.lean): complete generic sparse-support and source-matrix six-cycle equivalences, including projected distinctness and mixed-block exclusion.
- [LargerCases.lean](../dyadic-rank/CyclicLift/LargerCases.lean): kernel-checked 3-by-3 modular exclusions, explicit eight-cycle and exact girth theorem for the voltage and expanded matrix graphs.
- [GirthCharacterization.lean](../dyadic-rank/CyclicLift/GirthCharacterization.lean): arbitrary-exponent simple eight-cycle, ordinary/extended girth bounds, full iff characterization, rectangle-only reformulation, and binary-matrix theorem.
- [SmallCases.lean](../dyadic-rank/CyclicLift/SmallCases.lean): no-six theorem for arbitrary 2-by-2 bases, uniform normalized girth-eight family and the ternary six-cycle obstruction.
- [CyclicChecks.lean](../dyadic-rank/CyclicChecks.lean): independent consumer statements and the axiom audit.

The recorded girth-eight target is complete for the stated X-graph model and dimension assumptions. The remaining research tasks are a careful published-proof comparison and independent questions about connected constructions, absorbing sets, expansion and decoding performance. No priority claim has been established.
