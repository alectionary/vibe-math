module

public import IncidenceFamilySource

@[expose] public section
set_option linter.unusedSimpArgs false
set_option linter.unusedSectionVars false
open Matrix
namespace Incidence.Family
variable {n : ℕ}
def aCoef (g : Check n) : ZMod 2 :=
  (if g = (0,27) then 1 else 0) + (if g = (1,0) then 1 else 0) + (if g = (2,54) then 1 else 0)
def dCoef (g : Check n) : ZMod 2 :=
  (if g = (0,0) then 1 else 0) + (if g = (0,1) then 1 else 0) + (if g = (0,6) then 1 else 0)
lemma ite_and_zero {α : Type*} [Zero α] (a : α) (p q : Prop) [Decidable p] [Decidable q] :
    (if p then (if q then a else 0) else 0) = if p ∧ q then a else 0 := by
  by_cases hp : p <;> simp [hp]
lemma A_circulant : (fun c v : Check n => (A c v : ZMod 2)) = Matrix.circulant aCoef := by
  funext c v
  rcases c with ⟨i,g⟩
  rcases v with ⟨j,f⟩
  simp [A,P,Matrix.circulant,aCoef,Prod.mk.injEq,sub_eq_iff_eq_add,ite_and_zero,add_comm]
lemma D_circulant : (fun c v : Check n => if c.1 = v.1 then (B c.2 v.2 : ZMod 2) else 0) =
    Matrix.circulant dCoef := by
  funext c v
  rcases c with ⟨i,g⟩
  rcases v with ⟨j,f⟩
  by_cases h : i = j <;>
    simp [B,P,Matrix.circulant,dCoef,Prod.mk.injEq,sub_eq_iff_eq_add,h,add_comm]

def HX2 : Matrix (Check n) (Var n) (ZMod 2) := fun c v => (HX c v : ZMod 2)
def HZ2 : Matrix (Check n) (Var n) (ZMod 2) := fun c v => (HZ c v : ZMod 2)

lemma HX2_incidence (h : 63 ∣ n) (v : Var n) (c : Check n) :
    HX2 c v = 1 ↔ E v c := by
  rw [← HX_incidence h]
  rcases HX_binary h c v with hx | hx <;> simp [HX2,hx]

/-- Exact CSS commutation for the polynomial matrices, not an assumed CSS premise. -/
theorem css [NeZero n] :
    HX2 (n := n) * (HZ2 (n := n))ᵀ = 0 := by
  let M : Matrix (Check n) (Check n) (ZMod 2) := fun c v => (A c v : ZMod 2)
  let D : Matrix (Check n) (Check n) (ZMod 2) :=
    fun c v => if c.1 = v.1 then (B c.2 v.2 : ZMod 2) else 0
  have hcomm : M * Dᵀ = Dᵀ * M := by
    dsimp [M,D]
    rw [A_circulant,D_circulant,Matrix.transpose_circulant]
    exact Matrix.circulant_mul_comm _ _
  calc
    _ = M * Dᵀ + Dᵀ * M := by
      ext c d
      simp only [HX2,HZ2,Matrix.add_apply,Matrix.mul_apply,Matrix.transpose_apply]
      rw [Fintype.sum_prod_type]
      simp only [Fintype.sum_bool,HX,HZ,Bool.false_eq_true,↓reduceIte,Nat.cast_ite,Nat.cast_zero]
      dsimp only [M,D]
      simp only [eq_comm]
      ac_rfl
    _ = 0 := by
      rw [hcomm]
      ext c d
      exact (show ∀ x : ZMod 2, x+x=0 by decide) _

end Incidence.Family
