# Dyadic rank support theorem in Lean

The full converse proposed in Remark 3.4 of [Gomez-Fonseca, Matthews, Morris and Pllaha, arXiv:2605.01942v1](https://arxiv.org/html/2605.01942v1) is proved in Lean for the recorded dyadic-matrix statement. The proof uses ordinary rank over `ZMod 2` and works in every positive dimension.

**Start with the [direct inductive proof](INDUCTIVE-PROOF.md)** and [its Lean source](DyadicRank/Recursive.lean). `rankSupportConjecture_proved` proves the original proposition. `dyadic_rank_support_half` exposes the result for arbitrary dyadic matrices with rank `2^ell / 2`.

**Prior literature:** the conclusion also follows from Friedlander–Pevtsova's 2005 flatness criterion for elementary abelian group algebras, restated in Benson's book. [The prior-art review](PRIOR-ART.md) gives exact locators and the translation. We do not claim a new mathematical theorem or priority for the inductive proof or Lean formalization.

The [Lean search and proof comparison](FORMALIZATION-AND-PROOF-COMPARISON.md) found no earlier matching artifact in the searched sources. It identifies our key descent step as a block-matrix specialization of the published commuting-nilpotent perturbation principle.

An [academic manuscript](paper/README.md) includes the complete inductive Lean file, a self-contained source snapshot, explicit source-question attribution, and a comparison with the published arguments.

## Mathematical statement

Let `Point ell = Fin ell → ZMod 2`, so there are `N = 2^ell` index vectors. A signature is any function `s : Point ell → ZMod 2`, and its dyadic matrix has entries `D x y = s (x + y)`.

The support is the set of index vectors where `s x ≠ 0`. Its sum is a vector in `Point ell`, using coordinatewise addition modulo two. The theorem says that a dyadic matrix of rank `N/2` has nonzero support-vector sum.

```lean
def RankSupportAt (ell : ℕ) : Prop :=
  ∀ s : Signature ell,
    2 * (dyadicMatrix s).rank = 2 ^ ell → supportSum s ≠ 0

theorem rankSupportAt_all (ell : ℕ) : RankSupportAt ell

theorem rankSupportConjecture_proved : RankSupportConjecture
```

The doubled-rank form also covers dimension zero vacuously. The public division form explicitly assumes `0 < ell`. The signature representation covers exactly the source's arbitrary dyadic matrices: `IsDyadic D` means `D x y = D 0 (x+y)`, and `eq_dyadicMatrix_of_isDyadic` recovers the signature as the zero row. No support-subspace or weight-two hypothesis is inserted.

## Proof and dependencies

`Structural.lean` proves `D² = parity(s) I`, the rank bounds, first-moment identities, and half rank iff image equals kernel in the square-zero case. `Recursive.lean` splits off one binary coordinate and puts the operator in triangular form with diagonal block `C` and commuting square-zero off-diagonal block `B`. Two successive preimage arguments make exactness descend to `C`. Repeating this reaches the zero matrix in dimension zero, where exactness is impossible.

The general theorem uses direct symbolic induction. The axiom audit contains only Lean's standard `propext`, `Classical.choice`, and `Quot.sound`; no custom axiom or native-evaluation axiom is used. [Verification records](verification.json) and [command output](verification.log) include the source hashes, build result, consumer checks, and axiom reports.

The [earlier proposed argument using exact zero divisors](STRUCTURAL-PROOF.md) is retained as an alternative mathematical route. **Proposition 1.9 itself and that route's polynomial-model translation are not formalized here. They are not dependencies of the complete Lean proof.** `FrobeniusObstruction.lean` retains the checked elementary ideal-squaring lemmas from that investigation.

Only the rank/support converse is asserted. An unrestricted equivalence would be false: a singleton signature at a nonzero index has nonzero support sum but produces a full-rank permutation matrix.

## Earlier finite checks and computational search

`SmallCases.lean` retains the exhaustive Lean certificates for all 4 signatures in dimension 1 and all 16 in dimension 2. `Enumeration.lean` proves completeness of their enumeration. These remain regression examples, rather than the scope limit of the theorem.

The separate [Python search](search/README.md) found no counterexamples among 45,543 distinct conditioned signatures, including exhaustive conditioned spaces through dimension 4 and sampled/structured signatures through dimension 10 (1024 × 1024 matrices). These computations are not Lean proofs and are not used by the general theorem.

## Reproduce

Requires [elan/Lean](https://lean-lang.org/install/). The project pins Lean `4.36.0-rc1` and mathlib commit `5f7b4198d22a9c82e1c698a379334fe128095c82`; transitive dependencies are locked in `lake-manifest.json`. Keep that lockfile when reproducing the check.

```sh
cd formalization/dyadic-rank
lake exe cache get Mathlib.LinearAlgebra.Matrix.Rank Mathlib.FieldTheory.Finiteness Mathlib.LinearAlgebra.FiniteDimensional.Lemmas Mathlib.Algebra.Field.ZMod Mathlib.Tactic.FinCases Mathlib.Tactic.NormNum Mathlib.Algebra.CharP.Two Mathlib.RingTheory.Ideal.Operations Mathlib.Data.Fin.Tuple.Basic Mathlib.Tactic.Abel
lake build
lake env lean Checks.lean
```
