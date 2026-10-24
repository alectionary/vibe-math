import ComplexRootFormula

set_option maxHeartbeats 0
set_option maxRecDepth 100000
open scoped BigOperators
namespace AbsorbingComplexConsumer
open AbsorbingFourier

/-- A four-variable diamond with two private checks, using the boundary lift N=1. -/
def diamondSockets : Fin 4 → Finset (Fin 7 × ZMod 1)
  | 0 => {(0,0),(1,0),(2,0)}
  | 1 => {(0,0),(3,0),(4,0)}
  | 2 => {(1,0),(3,0),(5,0)}
  | 3 => {(2,0),(4,0),(6,0)}

theorem diamond_degree : ∀ v, (CyclicNormalization.incidence diamondSockets v).card = 3 := by
  decide

theorem diamond_no_four_cycle : ∀ u v, u ≠ v →
    (CyclicNormalization.incidence diamondSockets u ∩
      CyclicNormalization.incidence diamondSockets v).card ≤ 1 := by
  decide

theorem diamond_count : GlobalCounting.count42
    (CyclicNormalization.incidence diamondSockets) = 1 := by
  decide

theorem diamond_quadratic : CyclicNormalization.normalizedQuadratic diamondSockets = 40 := by
  decide

/-- This positive-count consumer uses the completed complex theorem. -/
theorem diamond_complex_formula :
    (1 : ℝ) = (1 / 4 : ℝ) * ∑ p : Fin 4, ∑ q : Fin 4, ∑ d : ZMod 1,
      complexRootSummand diamondSockets p q d := by
  have h := complex_root_count_formula diamondSockets diamond_degree diamond_no_four_cycle
  simpa only [diamond_count, Nat.cast_one] using h

theorem diamond_complex_energy : normalizedNormEnergy diamondSockets = 36 := by
  have h := complex_cyclic_count_identity diamondSockets diamond_degree diamond_no_four_cycle
  rw [diamond_count, diamond_quadratic] at h
  norm_num at h ⊢
  linarith

/-- The faithful-character and sign bridge has no oddness or primality premise. -/
theorem even_composite_faithful :
    Function.Injective (ZMod.stdAddChar : AddChar (ZMod 24) ℂ) :=
  ZMod.injective_stdAddChar

theorem even_composite_negative_exponent :
    ZMod.stdAddChar (-((5 : ZMod 24) * 7)) = standardRoot 24 ^ (-35 : ℤ) := by
  have h := standard_character_neg_product (5 : ZMod 24) 7
  norm_num [ZMod.val] at h
  exact h

theorem prime_negative_exponent :
    ZMod.stdAddChar (-((3 : ZMod 7) * 4)) = standardRoot 7 ^ (-12 : ℤ) := by
  have h := standard_character_neg_product (3 : ZMod 7) 4
  norm_num [ZMod.val] at h
  exact h

#print axioms diamond_count
#print axioms diamond_complex_formula
#print axioms diamond_complex_energy
#print axioms even_composite_faithful
#print axioms even_composite_negative_exponent
#print axioms prime_negative_exponent
end AbsorbingComplexConsumer
