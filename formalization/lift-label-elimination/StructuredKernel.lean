import CyclicRecurrence
import Mathlib.Algebra.Module.LinearMap.Defs
import Mathlib.Data.Matrix.Mul

set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace StructuredKernel
open CyclicRecurrence
open scoped BigOperators

/-- Each phase of the seven-periodic recurrence is a binary linear functional. -/
def patternLinear (r : ZMod 7) : (Fin 3 → F) →ₗ[F] F where
  toFun a := pattern a r
  map_add' := by revert r; decide
  map_smul' := by revert r; decide

variable {m n : Type*} [Fintype m] [Fintype n] [DecidableEq m] [DecidableEq n]

def BaseCondition (B : Matrix m n F) (a : n → F) : Prop :=
  ∀ c, ∑ v, B c v*a v=0

def Condition (N : ℕ) (B : Matrix m n F) (f : n → ZMod N → F) : Prop :=
  (∀ v, ScalarCondition N (f v)) ∧
  ∀ t c, ∑ v, B c v*f v t=0

variable (N : ℕ) [NeZero N] (h7 : 7 ∣ N) (B : Matrix m n F)

def fromSeeds (a : Fin 3 → {x : n → F // BaseCondition B x}) : n → ZMod N → F :=
  fun v => candidate N h7 (fun i => (a i).val v)

theorem fromSeeds_condition (a : Fin 3 → {x : n → F // BaseCondition B x}) :
    Condition N B (fromSeeds N h7 B a) := by
  refine ⟨fun v => candidate_condition N h7 _, ?_⟩
  intro t c
  let r := ZMod.castHom h7 (ZMod 7) t
  have he : (∑ v, B c v * fromSeeds N h7 B a v t) =
      patternLinear r (∑ v, B c v • (fun i => (a i).val v)) := by
    simp only [map_sum, map_smul, patternLinear, LinearMap.coe_mk, AddHom.coe_mk,
      fromSeeds, candidate, smul_eq_mul, r]
  rw [he]
  have hz : (∑ v, B c v • (fun i => (a i).val v))=0 := by
    funext i
    simpa only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul, Pi.zero_apply]
      using (a i).prop c
  rw [hz, map_zero]

def equivalence :
    {f : n → ZMod N → F // Condition N B f} ≃
      (Fin 3 → {x : n → F // BaseCondition B x}) where
  toFun f i := ⟨fun v => f.val v (i.val : ZMod N), f.prop.2 _⟩
  invFun a := ⟨fromSeeds N h7 B a, fromSeeds_condition N h7 B a⟩
  left_inv f := Subtype.ext (by
    funext v
    exact (kernel_unique N h7 (f.val v) (f.prop.1 v)).symm)
  right_inv a := by
    funext i
    apply Subtype.ext
    funext v
    change candidate N h7 (fun j => (a j).val v) (i.val : ZMod N)=(a i).val v
    simp only [candidate, map_natCast]
    exact pattern_initial _ i

include h7 in
theorem kernel_card : Nat.card {f : n → ZMod N → F // Condition N B f} =
    (Nat.card {x : n → F // BaseCondition B x})^3 := by
  classical
  rw [Nat.card_congr (equivalence N h7 B), Nat.card_eq_fintype_card,
    Fintype.card_fun, Fintype.card_fin, Nat.card_eq_fintype_card]

#print axioms fromSeeds_condition
#print axioms equivalence
#print axioms kernel_card
end StructuredKernel
