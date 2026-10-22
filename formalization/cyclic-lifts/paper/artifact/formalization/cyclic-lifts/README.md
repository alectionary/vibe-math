# Cyclic-lift groundwork for the P34 girth-eight question

The academic manuscript is available as a [19-page PDF](paper/output/pdf/cyclic-lift-girth-eight.pdf), [LaTeX source](paper/main.tex), and [standalone Lean/code/data source bundle](paper/cyclic-lift-girth-eight-source.zip). It presents the open-question answer, proof, structural consequences, optimization and decoding results, with 15 references and a signed chronology. [Manuscript verification](paper/paper-verification.json). The expanded Lean section includes principal declarations, a dependency diagram and substantive proofs; Appendix A and the [complete proof guide](paper/LEAN-PROOF-GUIDE.md) link every part of the full formalization at an immutable revision.

The **general girth-eight characterization is checked in Lean**, with **75 audited theorems** across the library. For any exponent matrix with at least two rows and columns, the lifted-product X Tanner graph has a simple eight-cycle. Its girth is exactly eight **if and only if** every distinct-row/column rectangle sum and every distinct-triple hexagon sum is nonzero. The theorem also applies directly to the expanded binary parity-check matrix. This completes the recorded P34 girth target for the source model; inventory proof coverage is now **2/108 (1.85%)**. Connectivity, absorbing sets and other decoding-property optimization are separate targets.

The source problem is Section 5, after Theorem 5.1, in Ragnar Freij-Hollanti, Kirsten D. Morris and Patricija Šapokaitė, *Graphical Analysis of Lifted Product Code Constructions*, arXiv:2606.11987v1 (June 10, 2026). Its Equation (2.1) fixes the orientation of lift labels, and Equation (2.3) specifies the particular construction. The paper cites Gross and Tucker's *Topological Graph Theory* for its general graph-lift results. We use the paper as our source; we have not independently audited that book. Walk-closure and alternating-sum criteria are established graph-lift groundwork, and no priority claim is made for this mathematics or the finite example. [Primary paper](https://arxiv.org/html/2606.11987v1).

## General theorem and scope

### Resolution of the source question

Section 5's final paragraph asks for sufficient girth-eight conditions from
analysis of 2-by-2 submatrices, together with their effects on other
decoding-related properties. It does not state a numbered conjecture that
individual nonzero rectangles suffice. The girth-condition part has an
affirmative answer for the source's all-permutation-block construction:
the two conditions below are sufficient, and in fact necessary. Questions
about their effects on other graph properties are not resolved by this proof.
Mathematical priority is a separate issue: the literature comparison identifies
established component results and does not establish novelty of this answer.

[CyclicSourceQuestion.lean](../dyadic-rank/CyclicSourceQuestion.lean) directly
packages the answer for the actual expanded binary matrix:

- `CyclicSourceQuestion.sufficient_rectangle_conditions`: nonzero individual
  rectangle sums and noncancelling indicated pairs imply girth eight.
- `CyclicSourceQuestion.necessary_rectangle_conditions`: girth eight implies
  those same conditions.
- `CyclicSourceQuestion.rectangle_only_counterexample`: the explicit ternary
  matrix below has every rectangle nonzero but its expanded matrix's Tanner
  graph does not have girth eight. This rejects an insufficient simplification,
  not an assertion made by the source authors.

These are three source-facing corollaries of the audited library, checked
separately; they do not increase the library's count of 75 theorems or the
inventory's count of completed targets. Their axiom output is recorded in
[source-question-checks.log](source-question-checks.log).

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

The [prior-art and proof comparison](PRIOR-ART-AND-PROOF-COMPARISON.md) identifies the short-cycle conditions as a specialization of Fossorier (2004), the direct LP eight-cycle cancellation in Raveendran–Declercq–Vasić (2025), and matching support/cycle mechanisms in other primary texts. The verified artifact combines established mathematics; neither a new mathematical discovery nor first Lean formalization is established. The source's accompanying questions about other graph properties and decoding optimization are not answered by this girth theorem.

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
lake -f lakefile-cyclic.toml env lean CyclicSourceQuestion.lean
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

The recorded girth-eight target is complete for the stated X-graph model and dimension assumptions. The bounded published-proof comparison is now documented above. Independent questions about connected constructions, absorbing sets, expansion and decoding performance remain separate. No priority claim has been established.

## Consequences for other decoding-related properties

This analysis addresses the second part of P34's Section 5 question. Its scope is the fully populated circulant-block construction already defined above. In particular, a **3-by-3** base gives variable degree three and check degree six. Conclusions about absorbing or stopping sets below use that degree assumption; they do not extend unchanged to arbitrary matrix dimensions.

Evidence levels are kept separate: the general girth characterization remains Lean checked; eight additional declarations in [CyclicDecoding.lean](../dyadic-rank/CyclicDecoding.lean) check a general two-error bound and concrete absorbing/stopping witnesses. The general absorbing-support classification/bijection and stopping lower bound are now checked in [CyclicStructure.lean](../dyadic-rank/CyclicStructure.lean), with 29 separately audited declarations. The elementary `(4,4)` odd-check count and asymptotic cut argument retain written proofs. Cycle counts and component/cut measurements are independently cross-checked Python evidence. The later benchmark section reports decoder simulations; no new priority claim is made.

### Absorbing sets: a sharp size threshold, with an unavoidable obstruction

Use the absorbing-set definition in Freij-Hollanti, Morris and Šapokaitė, [P34, Definition 2.2](https://arxiv.org/html/2606.11987v1#S2): each selected variable must have strictly more neighbors of even induced degree than of odd induced degree. The second parameter in an `(a,b)` set counts odd checks, not edges or iterations. The relevant established background includes McMillon, Beemer and Kelley, [*Extremal absorbing sets in low-density parity-check codes*](https://www.aimsciences.org/article/doi/10.3934/amc.2021003), especially the girth-eight bound in Table 4, and Morris, Pllaha and Kelley, [*Absorbing sets in quantum LDPC codes*](https://www.aimsciences.org/article/doi/10.3934/amc.2026023). We claim an application to our construction, not discovery of the general absorbing-set bound.

In any variable-degree-three Tanner graph of girth eight:

- No absorbing set has one, two or three variables.
- Every simple eight-cycle gives an elementary `(4,4)` absorbing set on its four variables.
- Conversely, every four-variable absorbing set is the variable set of exactly one simple eight-cycle. Thus the minimum absorbing-set size is exactly four, and its multiplicity equals the number of eight-cycles.

**Argument.** An absorbing variable of degree three needs at least two even check neighbors. With at most three selected variables, an even neighboring check must have induced degree two. No pair of selected variables can share two checks, because that would give a four-cycle. Two selected variables therefore cannot suffice; three would require three pair checks forming a six-cycle. Both configurations are excluded.

On a simple eight-cycle, each variable already has two neighboring cycle checks. An extra incidence from a cycle check to another cycle variable creates a four-cycle. An outside check meeting two cycle variables creates a four-cycle if those variables are consecutive on the cycle, or a six-cycle if they are opposite. Consequently the four cycle checks have induced degree two and the four remaining neighbors are distinct checks of degree one. Each variable sees two even and one odd check, giving `(4,4)`.

For the converse, consider an absorbing set of size four. An induced check of degree four would prevent every other check from meeting any pair of its variables (otherwise there is a four-cycle), leaving at most one even neighbor per variable. A check of degree three would leave each of its variables with at most one possible even pair check, involving the fourth variable. Both contradict absorption. All induced check degrees are therefore at most two. Replace each degree-two check by an edge joining its variables. The resulting graph is simple, triangle-free, has four vertices, and has minimum degree two. It must be a four-cycle, with no diagonal. This proves both the converse and uniqueness. Since no smaller absorbing set exists, these sets are inclusion-minimal as well as minimum in size.

For the explicit sevenBase example, `fourSet_certificate` verifies the four-variable witness

```
L(0,0,0), L(0,1,0), R(0,0,0), R(1,0,0).
```

Lean checks four degree-one checks, four degree-two checks, no higher induced check degrees, and two even versus one odd neighbor at every selected variable. `incidence_iff_matrix_entry` connects the computable incidence used in these certificates to the actual expanded binary matrix, rather than an unrelated graph.

### Eight-cycle multiplicity remains a design variable

At lift size 14, compare the following three bases. The first two rows are always `(0,0,0)` and `(0,1,2)`; only the last entry changes.

| Third row | Components | Girth | Eight-cycles / minimum `(4,4)` absorbing sets |
|---|---:|---:|---:|
| `(0,3,6)` | 1 | 8 | 3,150 |
| `(0,3,7)` | 1 | 8 | 2,772 |
| `(0,3,8)` | 1 | 8 | 2,646 |

All have 252 variables, 126 checks and 756 edges. The last has 16% fewer eight-cycles than the first. Counts agree between two methods: check-graph four-cycle enumeration with four distinct variable labels, and an independent depth-eight traversal of the original Tanner graph. Each unoriented cycle is counted once. This establishes a real optimization objective after girth has been maximized; it does not establish a 16% decoding improvement.

At lift size seven, the original example has 2,079 eight-cycles: 189 with all four variables on the left, 189 with all four on the right, and 1,701 mixed. Counts are for cycles in the full lifted graph, not merely projected cycles in the base.

### Stopping sets and the classical kernel

A stopping set is a nonempty variable set with no neighboring check of induced degree one. In a girth-at-least-eight graph with minimum variable degree `d >= 2`, every stopping set has at least `2d` variables. Here is a direct tree argument. Select a variable `v` and `d` of its checks. Stopping requires a second selected variable at every check; those `d` variables are distinct by absence of four-cycles. Pick one, `a`. At least `d-1` other checks of `a` each need another selected variable. These witnesses are mutually distinct and cannot equal `v`, by absence of four-cycles. None can be another first-level variable, because that would make a six-cycle. This gives `1+d+(d-1)=2d` selected variables.

For our degree-three example, every stopping set therefore has size at least six. The following six variables attain the bound:

```
{ L(0,j,0) : j=0,1,2 } union { R(i,0,0) : i=0,1,2 }.
```

The first row and column of sevenBase vanish, so precisely the nine checks `C(i,j,0)` meet this set, each twice. `sixSet_certificate` checks these facts, including zero odd checks and three even neighbors per variable. Hence the example has stopping distance six. Its classical binary kernel also has minimum nonzero weight six: a nonzero kernel support is a stopping set, and this support has zero syndrome. The same explicit witness works for the normalized bases in the table.

**This is not a proof that the quantum logical distance is six.** The displayed support is a row of the companion `H_Z` matrix (row indices `(0,0)`, fiber zero), so it represents a stabilizer. Logical distance requires minimizing outside the stabilizer row space. The companion-matrix identification retains a written proof; the general stopping bound is now checked in `CyclicStructure.lean`. Lean verifies the concrete zero-syndrome incidence profile.

### Small error patterns have limited cancellation

Without four-cycles, distinct variables share at most one check. For errors at exactly `v,w`, the syndrome support is the symmetric difference of their neighborhoods; its weight is at least `degree(v)+degree(w)-2`. In the 3-by-3 construction that is at least four. This statement, including the graph-to-common-neighbor argument, is proved generally in Lean by `common_checks_card_le_one`, `two_error_syndrome_lower_bound` and `no_four_two_error_bound`.

More generally, for a set `S` of `a <= 3` variables, the induced incidence graph on `S` and its neighboring checks is a forest: any cycle would have length at most six. Writing `E` for the sum of degrees of those variables and `c >= 1` for the number of components gives `|N(S)| = E-a+c >= E-a+1`. If `t` neighboring checks have degree one, then `E >= t+2(|N(S)|-t)`, so `t >= E-2a+2`. In degree three this gives at least 3, 4 and 5 degree-one (hence unsatisfied) checks for one, two and three errors respectively. These local bounds do not guarantee success of a specified iterative decoder.

### Girth eight guarantees neither connectivity nor uniform expansion

Connectivity is an independent condition. At lift size 14, doubling every entry of sevenBase produces a girth-eight graph with two components of 189 vertices each: every edge preserves fiber parity. Its global edge conductance is zero. These component sizes and girth are checked by the finite script.

Even **connected** examples need not have a positive expansion constant uniform in lift size. Interpret the fixed integer matrix

```
0 0 0
0 1 2
0 3 6
```

modulo `r=7k`. Every eligible rectangle and hexagon sum is nonzero modulo seven, hence nonzero modulo `7k`; our characterization gives girth eight for every positive `k`. The upper-left rectangle has voltage one, so [P34, Theorem 3.6](https://arxiv.org/html/2606.11987v1#S3) gives connectedness for every `r`.

Let `S` contain every vertex type whose fiber is in `0,...,floor(r/2)-1`. Define edge conductance using `|boundary(S)| / min(vol(S),vol(complement(S)))`, where volume is the sum of graph degrees. For `k >= 2`, both arcs have length at least seven. A matching of displacement `epsilon`, with `|epsilon| <= 6`, crosses this cut in exactly `2|epsilon|` edges. The sum of the nine nonnegative base exponents is 12, and each entry occurs on three left and three right edge types. Thus the boundary has exactly `2*6*12=144` edges. There are 108 degree units per fiber, giving

```
conductance(G) <= 144 / (108 floor(r/2)) = 4 / (3 floor(r/2)) -> 0.
```

The exact finite cut computations are:

| Lift size | Connected | Boundary edges | Smaller volume | Conductance upper bound |
|---|---|---:|---:|---:|
| 14 | Yes | 144 | 756 | 0.190476 |
| 28 | Yes | 144 | 1,512 | 0.095238 |
| 56 | Yes | 144 | 3,024 | 0.047619 |

These are upper bounds from particular cuts, not computations of the optimal conductance. The asymptotic argument rules out deriving uniform expansion from our girth conditions alone; it does not rule out better expansion for other choices of exponents.

### Interpretation, limitations and reproducibility

The girth conditions exclude the smallest absorbing sets and expose small-error syndrome cancellation, but necessarily retain `(4,4)` sets in degree three. They leave eight-cycle multiplicity, connectivity and expansion as separate design objectives. Raveendran and Vasić, [*Trapping Sets of Quantum LDPC Codes*](https://quantum-journal.org/papers/q-2021-10-14-562/), classify quantum trapping sets using both topology and decoder choice; Morris, Pllaha and Kelley connect absorbing sets to syndrome-based iterative decoding. Accordingly, absorbing/stopping certificates here are structural evidence, not a decoder-independent error-floor prediction. No numerical decoding threshold, logical error rate, or optimal decoder performance has been established.

Run from the repository root:

```
python3 formalization/cyclic-lifts/search/decoding.py
```

Run from `formalization/dyadic-rank`:

```
lake -f lakefile-cyclic.toml env lean CyclicDecoding.lean
```

[Finite results](search/decoding-results.json), [experiment source](search/decoding.py), [Lean axiom output](decoding-checks.log), [verification manifest](decoding-verification.json). The eight new declarations are supplementary to the existing 75-theorem core audit; they do not silently change its coverage count. All eight use only `propext`, `Classical.choice` and `Quot.sound`.

## Minimizing four-variable absorbing sets and measuring decoding

### Exhaustive optimization at lift size 14

We searched **all 28,561 normalized 3-by-3 bases** whose four interior exponents lie in `1,...,13`. An interior zero would already make a zero rectangle with the normalized first row and column, so this loses no girth-eight candidate. Of these bases, **10,368** have girth eight and are connected. Connectivity is tested by `gcd(14,a,b,c,d)=1`: after normalization, the four interior entries generate the cycle-voltage subgroup. The 25 representative graphs are also checked directly by BFS.

The search partitions these candidates into **25 orbits under the explicit symmetries used**: row/column permutations followed by normalization, multiplication of every exponent by a unit, and transposition. These are graph isomorphisms. For clarity, there may be additional isomorphisms not generated by this group; 25 is not a claim about the total number of abstract isomorphism classes. For a gauge change `B'ij=Bij+ui+vj`, an explicit isomorphism shifts fibers of `C(i,j)` by `ui-vj`, of `L(k,j)` by `-vk-vj`, and of `R(i,l)` by `ui+ul`. Transposition exchanges left/right variables, swaps check indices and negates fibers. Unit multiplication rescales fibers.

The minimum is **2,520 eight-cycles**, hence 2,520 four-variable absorbing sets. Exactly **1,728 normalized bases** attain it, in four symmetry orbits. This is a finite exhaustive Python result at this fixed lift size, **not a Lean optimality theorem or an optimum over other lift sizes**. Every representative is counted by two independent cycle algorithms in the validation script.

The minimum is 20% below the baseline's 3,150 and about 4.76% below the previous best's 2,646. The four minimizing representative interiors `(B11,B12,B21,B22)` are `(1,2,4,11)`, `(1,3,6,10)`, `(1,3,7,4)` and `(1,4,6,2)`; indices here are zero-based.

Exact binary ranks expose a further design constraint: the first and third encode eight logical qubits, while the second and fourth preserve the baseline's **ten**. Primary decoding comparisons therefore use the two rate-preserving minima. All four primary codes have 252 physical qubits, ranks `rank(H_X)=rank(H_Z)=121`, girth eight and a connected Tanner graph. The two lower-rate minima are retained only in the exploratory results.

### Decoder, noise and success criterion

The implemented decoder is **syndrome normalized min-sum**, using the flooding schedule, normalization `alpha=0.8`, at most 100 iterations, and saturation at absolute LLR 50. The algorithm follows the syndrome message equations described by Nithin Raveendran, Javier Valls, Asit Kumar Pradhan, Narayanan Rengaswamy, Francisco Garcia-Herrero and Bane Vasić, [*Soft syndrome iterative decoding of quantum LDPC codes and hardware architectures*, Section 2.4](https://link.springer.com/article/10.1140/epjqt/s40507-023-00201-1). We use its perfect-syndrome min-sum formulation with scalar normalization, not its noisy-syndrome extension.

Messages use fixed-point arithmetic with 20 fractional bits so exact zero decisions do not depend on floating-point cancellation. The prior is the quantized value of `log((1-p)/p)`. Magnitudes are rounded to the nearest integer after normalization (ties up); a zero message has positive sign and a zero posterior yields hard bit zero. The engine stops at the first syndrome match, including the initial zero estimate. There is no OSD, restart, or per-design decoder tuning.

Noise is independent Bernoulli `p` on **one Pauli error sector**, with perfect syndrome measurements. This is a code-capacity comparison, not a circuit-level experiment or a full depolarizing-channel simulation. The true error is never supplied to the decoder: the engine forms its syndrome and decodes from that syndrome and the prior. Truth and the independently expanded companion `H_Z` are used to score the result afterward.

Success means `error XOR correction` belongs to the binary row space of `H_Z`. A residual stabilizer counts as success; a matched syndrome with a nonstabilizer residual counts as a logical failure. A nonmatching syndrome also counts as a failed recovery. Exact error recovery and stabilizer-equivalent recovery are reported separately. CSS orthogonality is checked for every row pair, and all ranks and membership tests use exact binary elimination.

The C++ engine is compared against an independently written, direct Python extrinsic-message implementation on 128 small cases, including the repetition-code minimum-weight oracle. Each selected real code is also checked on every single-qubit error, zero error, an injected stabilizer, and a constructed zero-syndrome logical operator. The last two checks distinguish degeneracy from logical failure. The primary run has 1,148 such decoder checks, in addition to matrix and GF(2) validation.

### Independent confirmation experiment

An exploratory run used 10,000 shared error patterns at each of `p=0.0025,0.005,0.01,0.02,0.04`, seed 20261022, across all six designs. Its results motivated a larger confirmation run; all four rate-preserving designs were retained. The confirmation used **100,000 new patterns at each of `p=0.01,0.02,0.04`**, seed 20261023. Every design receives exactly the same errors within a noise level. There are 300,000 independent patterns and **1.2 million decoder runs** in the primary confirmation. Selection of the four structural minima preceded decoding; no candidate or normalization coefficient was tuned on the confirmation data.

| Design | Interior exponents | `(4,4)` sets | Failure rate, `p=1%` | `p=2%` | `p=4%` |
|---|---|---:|---:|---:|---:|
| Baseline | `(1,2,3,6)` | 3,150 | 0.033% | 0.369% | 4.385% |
| Previous best | `(1,2,3,8)` | 2,646 | 0.031% | 0.278% | 2.750% |
| Minimum 2 | `(1,3,6,10)` | **2,520** | 0.036% | **0.251%** | **2.523%** |
| Minimum 4 | `(1,4,6,2)` | **2,520** | 0.035% | 0.278% | 2.607% |

At `p=4%`, Minimum 2's failure rate is about **42.46% lower** than the baseline's. Marginal Wilson 95% intervals are `[4.260%,4.514%]` for the baseline and `[2.428%,2.622%]` for Minimum 2. The paired design-minus-baseline difference is **-1.862 percentage points**, with a pointwise approximate 95% interval `[-2.011,-1.713]` percentage points. At `p=2%` the corresponding difference is -0.118 points, interval `[-0.166,-0.070]`.

At `p=1%`, Minimum 2 has 36 failures versus 33 for the baseline; the paired interval includes zero. **There is no demonstrated improvement at this noise level.** The two minima are also not clearly distinguished from one another at `p=4%`: their paired difference is -0.084 points with approximate interval `[-0.208,+0.040]`. Thus Minimum 2 is a reasonable current candidate, not an established universal winner. All intervals are pointwise, not adjusted for multiple comparisons; no asymptotic threshold or small-noise error-floor law is inferred.

At `p=4%`, failures split as follows:

| Design | Syndrome mismatch / nonconvergence | Matched syndrome, logical failure | Stabilizer-equivalent successes beyond exact recovery |
|---|---:|---:|---:|
| Baseline | 2,981 | 1,404 | 5,834 |
| Previous best | 2,714 | 36 | 5,849 |
| Minimum 2 | 2,503 | 20 | 6,005 |
| Minimum 4 | 2,565 | 42 | 6,031 |

The reduction includes many fewer logical miscorrections, not merely faster syndrome matching. Mean iterations, including failed runs at the iteration limit, fall from 9.689 to 8.857 for Minimum 2. Other graph and algebraic features change with the exponents, so these experiments **do not isolate absorbing-set count as the sole cause** of the improvement.

### Targeted check of the absorbing configurations

We additionally enumerate every four-variable absorbing support in each primary design, verify the `(4,4)` incidence profile directly, and decode the error on exactly those four variables, with no other errors. This is a finite, exhaustive experiment on that error subclass, not all weight-four errors.

For each of `p=0.01,0.02,0.04`, the baseline fails on **378 of its 3,150 supports (12%)**, always by a matched nonstabilizer residual. The previous best and both minima succeed on **every** enumerated support with this decoder. This emphasizes why a structural absorbing set is not automatically a failure-inducing error pattern. Lower counts are useful, but the decoder's behavior on the configurations also matters. These targeted results do not establish correction of arbitrary four-error patterns or all subsets of these supports.

All 378 failing baseline supports are mixed, with two variables from each block. Their nonstabilizer residuals have weight six in 294 cases and weight eight in 84 cases. Concrete error/correction/residual supports are saved and independently checked for zero syndrome and exclusion from the stabilizer row space. In particular, this supplies a weight-six logical witness for the baseline, giving an upper bound of six on its distance in the tested Pauli sector. No corresponding exact distance computation has been performed for the optimized codes, so equal block length and rate should not be read as equal distance.

For independent Bernoulli noise, the failing exact supports contribute `378*p^4*(1-p)^248` to the baseline's total failure probability. This is one disjoint subclass of errors, not an estimate of the full failure rate, and it cannot explain the full observed reduction by itself.

### Artifacts and reproduction

- [Exhaustive search](search/optimize_absorbing.py) and [all 25 orbit records](search/optimization-r14.json).
- [C++ decoder](search/minsum.cpp), [driver and independent reference](search/benchmark_decoding.py), [exploratory results](search/benchmark-results.json), and [confirmation results](search/benchmark-confirmation.json). Compressed per-trial failure flags allow reconstruction of paired comparisons.
- [Targeted experiment](search/targeted_absorbing.py) and [results](search/targeted-results.json).
- [Lean candidate certificates](../dyadic-rank/CyclicOptimized.lean), [axiom output](optimized-checks.log) and [verification manifest](optimization-verification.json). These three supplementary declarations prove girth eight for the two rate-preserving candidates. They do **not** prove search optimality, connectedness, ranks or decoding statistics, and do not change the existing 75-theorem core count.
- [Saved-result and symmetry validator](../../scripts/validate_cyclic_decoding_benchmark.py).

With Python 3.9 or newer and a C++17 compiler, run from the repository root:

```
python3 formalization/cyclic-lifts/search/optimize_absorbing.py --r 14
python3 formalization/cyclic-lifts/search/benchmark_decoding.py --trials 10000
python3 formalization/cyclic-lifts/search/benchmark_decoding.py --trials 100000 --seed 20261023 --probabilities 0.01 0.02 0.04 --primary-only --output benchmark-confirmation.json
python3 formalization/cyclic-lifts/search/targeted_absorbing.py
python3 scripts/validate_cyclic_decoding_benchmark.py
```

From `formalization/dyadic-rank`, run `lake -f lakefile-cyclic.toml env lean CyclicOptimized.lean`. The decoder engine is built in a temporary directory; no compiled executable is added to the repository. The experiment uses only the Python standard library and the system C++ compiler. No mathematical novelty or priority claim follows from this optimization or benchmark.

### Prior-art status of the optimized matrix

The [targeted literature follow-up](PRIOR-ART-AND-PROOF-COMPARISON.md#optimized-matrix-and-decoding-benchmark) located no exact prior report of this modulo-14 matrix, the 2,520-set minimum, or the specific decoder comparison. Priority remains undetermined. Both absorbing-set-aware design and decoding improvements from changing symmetric LP base matrices have earlier sources. In particular, Raveendran–Declercq–Vasić (2025), Section V-A, Eq. (92), already compares same-size, same-rate girth-eight LP codes with different base matrices and decoding performance. Our baseline also satisfies its column-partition relation `c0+c2=2*c1`, whereas both optimized candidates avoid it. This supplies prior context for our observation, not a proof of the optimized distances or of causation by absorbing-set count alone.


## General structural Lean proofs

[CyclicStructure.lean](../dyadic-rank/CyclicStructure.lean) works with arbitrary
Tanner incidence `E : V → C → Prop`, a finite check type, and finite selected
supports. Its nonempty absorbing and stopping definitions use induced check
degrees directly. No certificate assumes the result being proved.

- `absorbing_iff_cycle` characterizes absorbing supports of size at most four,
  assuming selected variables have degree three and there are no four-/six-cycles.
- `absorbing_minimum_four` excludes every nonempty absorbing support of size < 4.
- `absorbing_cycle_equiv` is a genuine bijection from unoriented simple eight-cycle
  support pairs to four-variable absorbing supports; `absorbing_cycle_count`
  gives equality of their counts. Rotation and reversal do not duplicate cycles.
- `cycle_native` constructs a native Mathlib simple closed walk of length eight.
  `cycle_checks_unique` proves uniqueness of check support from variable support.
- `stopping_card_ge_twice_degree` proves the general `2*d` lower bound for `d ≥ 2`;
  `stopping_minimum_six` specializes it to variable degree three.

These are 29 new audited declarations, separate from the 75-theorem girth core
and its previous consumers. Every axiom report is restricted to `propext`,
`Classical.choice`, and `Quot.sound`. The four odd checks in the elementary
`(4,4)` profile and the expansion/conductance argument retain written proofs.

From `formalization/dyadic-rank`, run:

```sh
lake -f lakefile-cyclic.toml env lean CyclicStructure.lean
```

From the repository root, run `python3 scripts/validate_cyclic_structure.py`
for the stored source/log audit, or append `--recheck-lean` to repeat the kernel
check. [Audit manifest](structure-verification.json), [kernel output](structure-checks.log).
