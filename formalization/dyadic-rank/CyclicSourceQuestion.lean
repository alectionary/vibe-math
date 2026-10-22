module

public import CyclicLift

@[expose] public section

open CyclicLift

namespace CyclicSourceQuestion

/- Source: Freij-Hollanti, Morris and Sapokaite, arXiv:2606.11987v1,
Section 5, final paragraph. The source asks for sufficient girth-eight
conditions obtained by analyzing 2-by-2 submatrices; it does not conjecture
that nonzero individual rectangle sums alone are sufficient.

These corollaries connect that question directly to the checked library.
They establish a mathematical answer, not a mathematical priority claim.
The finite circulant interpretation requires positive r and finite indices.
-/

variable {I J : Type*} {r : ℕ}

/-- Conditions on individual rectangles and pairs of rectangles suffice for
girth eight in the actual expanded binary matrix, in every dimension >= 2. -/
theorem sufficient_rectangle_conditions [Nontrivial I] [Nontrivial J]
    (B : I → J → ZMod r)
    (hRect : ∀ a b c d, a ≠ b → c ≠ d → baseRectangle B a b c d ≠ 0)
    (hPairs : ∀ a b c d e f, a ≠ b → b ≠ c → a ≠ c →
      d ≠ e → e ≠ f → d ≠ f →
      baseRectangle B a b d e + baseRectangle B b c d f ≠ 0) :
    (matrixTanner (hX B)).girth = 8 := by
  apply (matrixTanner_hX_girth_characterization B).mpr
  exact ⟨hRect, by simpa only [baseHexagon_eq_rectangle_add] using hPairs⟩

/-- The same rectangle conditions are necessary, so the answer is exact. -/
theorem necessary_rectangle_conditions [Nontrivial I] [Nontrivial J]
    (B : I → J → ZMod r) (h : (matrixTanner (hX B)).girth = 8) :
    (∀ a b c d, a ≠ b → c ≠ d → baseRectangle B a b c d ≠ 0) ∧
    (∀ a b c d e f, a ≠ b → b ≠ c → a ≠ c →
      d ≠ e → e ≠ f → d ≠ f →
      baseRectangle B a b d e + baseRectangle B b c d f ≠ 0) := by
  simpa only [baseHexagon_eq_rectangle_add] using
    (matrixTanner_hX_girth_characterization B).mp h

/-- Explicit counterexample to the stronger, unsupported rectangle-only
guess, stated for the actual expanded binary matrix rather than just a model. -/
theorem rectangle_only_counterexample :
    (∀ a b c d : Fin 3, a ≠ b → c ≠ d →
      baseRectangle ternaryBase a b c d ≠ 0) ∧
    (matrixTanner (hX ternaryBase)).girth ≠ 8 := by
  refine ⟨ternaryBase_rectangles, ?_⟩
  intro h
  rw [← xGraph_eq_matrixTanner] at h
  have hle : (xGraph ternaryBase).girth ≤ 6 := by
    simpa only [ternarySix_length] using ternarySix_isCycle.girth_le_length
  omega

#print axioms sufficient_rectangle_conditions
#print axioms necessary_rectangle_conditions
#print axioms rectangle_only_counterexample

end CyclicSourceQuestion
