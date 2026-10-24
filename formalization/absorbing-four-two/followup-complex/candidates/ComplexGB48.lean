import GB48RootData
import ComplexRootFormula
import GBReflection
import ClassicalDecomposability

set_option maxHeartbeats 0
set_option Elab.async false
open scoped BigOperators
namespace ComplexGB48
open GB48RootData AbsorbingFourier
attribute [local irreducible] GlobalCounting.count42

def rowColor (c : C) : Fin 3 := ⟨c.2.val % 3,Nat.mod_lt _ (by decide)⟩

theorem color_A_card : ∀ v, ((HA v).image rowColor).card=3 := by decide +kernel
theorem color_B_card : ∀ v, ((HB v).image rowColor).card=3 := by decide +kernel

theorem A_has_three_groups : ClassicalDecomposability.ThreeGroups HA := by
  refine ⟨rowColor,fun v => Finset.injOn_of_card_image_eq ?_⟩
  rw [color_A_card,cubic_A]

theorem B_has_three_groups : ClassicalDecomposability.ThreeGroups HB := by
  refine ⟨rowColor,fun v => Finset.injOn_of_card_image_eq ?_⟩
  rw [color_B_card,cubic_B]

noncomputable def fullM (s : Fin 2 → Finset C) (j : G) : ℂ :=
  ∑ p : Fin 2, evaluatedMatrix ZMod.stdAddChar s j 0 p *
    star (evaluatedMatrix ZMod.stdAddChar s j 0 p)

theorem evaluated_A (j : G) (p : Fin 2) :
    evaluatedMatrix ZMod.stdAddChar socketsA j 0 p =
      if p=0 then GBReflection.eval ZMod.stdAddChar {0,1,5} j
      else GBReflection.eval ZMod.stdAddChar GBReflection.rightA j := by
  fin_cases p <;>
    simp [evaluatedMatrix,socketsA,GBReflection.eval,GBReflection.rightA]

theorem evaluated_B (j : G) (p : Fin 2) :
    evaluatedMatrix ZMod.stdAddChar socketsB j 0 p =
      if p=0 then GBReflection.eval ZMod.stdAddChar {0,1,5} j
      else GBReflection.eval ZMod.stdAddChar GBReflection.rightB j := by
  fin_cases p <;>
    simp [evaluatedMatrix,socketsB,GBReflection.eval,GBReflection.rightB]

theorem fullM_A_eq_scalar : fullM socketsA =
    GBReflection.scalarM ZMod.stdAddChar GBReflection.rightA := by
  funext j
  simp [fullM,Fin.sum_univ_two,evaluated_A,GBReflection.scalarM]

theorem fullM_B_eq_scalar : fullM socketsB =
    GBReflection.scalarM ZMod.stdAddChar GBReflection.rightB := by
  funext j
  simp [fullM,Fin.sum_univ_two,evaluated_B,GBReflection.scalarM]

theorem identical_actual_complex_M : fullM socketsA = fullM socketsB := by
  rw [fullM_A_eq_scalar,fullM_B_eq_scalar]
  exact GBReflection.all_scalar_M_equal ZMod.stdAddChar standard_character_star

theorem actual_A_complex_formula :
    (192 : ℝ) = (24 / 4 : ℝ) * ∑ p : Fin 2, ∑ q : Fin 2, ∑ d : G,
      complexRootSummand socketsA p q d := by
  have h := complex_root_count_formula socketsA cubic_A linear_A
  simpa only [show CyclicNormalization.incidence socketsA = HA from rfl,
    count_A,Nat.cast_ofNat] using h

theorem actual_B_complex_formula :
    (72 : ℝ) = (24 / 4 : ℝ) * ∑ p : Fin 2, ∑ q : Fin 2, ∑ d : G,
      complexRootSummand socketsB p q d := by
  have h := complex_root_count_formula socketsB cubic_B linear_B
  simpa only [show CyclicNormalization.incidence socketsB = HB from rfl,
    count_B,Nat.cast_ofNat] using h

theorem no_actual_complex_M_only_count :
    ¬ ∃ f : (G → ℂ) → ℕ,
      f (fullM socketsA) = GlobalCounting.count42 HA ∧
      f (fullM socketsB) = GlobalCounting.count42 HB := by
  rintro ⟨f,ha,hb⟩
  rw [identical_actual_complex_M,count_A] at ha
  rw [count_B] at hb
  omega

#print axioms identical_actual_complex_M
#print axioms A_has_three_groups
#print axioms B_has_three_groups
#print axioms actual_A_complex_formula
#print axioms actual_B_complex_formula
#print axioms no_actual_complex_M_only_count
end ComplexGB48
