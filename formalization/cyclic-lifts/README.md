# Cyclic-lift groundwork for the P34 girth-eight question

The first bounded stage is checked in Lean: **36 theorems**, a faithful entrywise model of the paper's expanded binary matrix, a complete four-cycle criterion, and a six-cycle obstruction to a tempting insufficient condition. **The general P34 girth-eight question remains open in this project.** This is supporting formalization, not another completed inventory target; complete target proof coverage remains 1/108.

The source problem is Section 5, after Theorem 5.1, in Ragnar Freij-Hollanti, Kirsten D. Morris and Patricija Šapokaitė, *Graphical Analysis of Lifted Product Code Constructions*, arXiv:2606.11987v1 (June 10, 2026). Its Equation (2.1) fixes the orientation of lift labels, and Equation (2.3) specifies the particular construction. The paper cites Gross and Tucker's *Topological Graph Theory* for its general graph-lift results. We use the paper as our source; we have not independently audited that book. Walk-closure and alternating-sum criteria are established graph-lift groundwork, and no priority claim is made for this mathematics or the finite example. [Primary paper](https://arxiv.org/html/2606.11987v1).

## Checked results

- **Walk lifting and closure:** an additive voltage graph has a graph homomorphism forgetting its fiber. Every base walk has a lift that projects back to that exact walk. Its endpoint fiber is the initial fiber plus the oriented label sum. A prescribed closed base walk has a closed lift at any chosen fiber **if and only if** its displacement is zero. This statement does not imply that the walk is a simple cycle.
- **Four-cycle criterion:** for any supported bipartite lift over an additive commutative group, a simple four-cycle exists exactly when a supported rectangle on distinct variables and distinct checks has alternating label sum zero. The four-vertex formulation is proved equivalent to Mathlib's `Walk.IsCycle` with length four.
- **Matrix/graph comparison:** `xGraph_eq_matrixTanner` proves equality with the Tanner graph of the explicit binary expansion of `B_X = [B tensor I_n | I_m tensor B*]`. Negating a circulant exponent transposes its permutation block. Both identity-factor supports and the conjugate-transpose sign are included. Finite row and column counts agree with `(mn)r` and `(n²+m²)r`.
- **Complete four-cycle test for P34:** `xGraph_native_fourCycle_iff` reduces *all* simple four-cycles of `G_HX`, including both variable-block families, to zero rectangles in the original exponent matrix. Mixed left/right rectangles cannot contribute a four-cycle.
- **Symbolic small family:** for the normalized 2-by-2 exponent matrix `[[0,0],[0,t]]`, every nonzero `t` gives a full `G_HX` with no four-cycles. The theorem is symbolic in the modulus and label. It does not prove girth eight.
- **Ternary obstruction:** `rectangle_exclusion_not_sufficient_for_no_six` proves that the explicit 3-by-3 ternary base below has no four-cycles but does have a native simple six-cycle.

The general additive-group lemmas apply more broadly than cyclic lifts. To identify the source's finite circulant construction, take `A = ZMod r` with **positive modulus**. The formal algebraic definitions also make sense at `r=0`, where Lean's `ZMod 0` is infinite; that extension is not a finite circulant lift from the paper. The finite-dimension theorems explicitly require `NeZero r`. The P34 model uses a base with no zero permutation blocks; the generic bipartite lemmas separately allow sparse support.

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

Two independently written constructions produce identical adjacency sets: a voltage lift and direct binary block expansion. Direct check-triple six-cycle counts agree with projected voltage-walk enumeration that checks distinct **lifted** vertices. The girth distribution is 351 cases of girth four, 14 of girth six and 67 of girth eight. These counts and the girth-eight cases are **Python evidence, not Lean certificates**.

For normalized 2-by-2 matrices in the tested range, zero `t` gives girth four and nonzero `t` gives girth eight. No general Lean girth-eight theorem is claimed. The lift-size-seven 3-by-3 example is a concrete candidate for a next checked girth-eight certificate. [Search script](search/scan.py), [all results](search/results.json).

## Reproduce the checks

The new `CyclicLift` library shares the existing pinned Lean/Mathlib environment in `../dyadic-rank`. It uses **an alternate Lake configuration**, so the original dyadic proof's pinned build configuration and source hashes remain unchanged. The manuscript's archived source bundle is unchanged.

From `formalization/dyadic-rank`:

```
lake -f lakefile-cyclic.toml exe cache get Mathlib.Combinatorics.SimpleGraph.Paths Mathlib.Data.ZMod.Basic
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
- [SmallCases.lean](../dyadic-rank/CyclicLift/SmallCases.lean): symbolic 2-by-2 exclusion and the ternary six-cycle obstruction.
- [CyclicChecks.lean](../dyadic-rank/CyclicChecks.lean): independent consumer statements and the axiom audit.

The next step is a complete characterization of six-cycles, accounting for repeated projected vertices and partial fiber returns, followed by a useful entrywise sufficient condition and an eight-cycle witness. Absence of four- and six-cycles gives a lower bound in the bipartite setting; an **exact** girth-eight claim still needs an eight-cycle or an audited upper-bound argument. None of the current results supplies the full source-requested design criterion.
