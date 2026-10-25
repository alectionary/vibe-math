import GeneralLP
import CyclicCover
set_option maxHeartbeats 0
namespace GeneralLP
variable {L : Nat} [NeZero L]
open FamilyWords

def C (e : Fin 3 → Fin 4 → ZMod L) (c : Fin 3 × ZMod L) (v : Fin 4 × ZMod L) : ZMod 2 :=
  P (e c.1 v.1) c.2 v.2

theorem classical_action (e : Fin 3 → Fin 4 → ZMod L) (x : CyclicCover.Word (ZMod L))
    (c : Fin 3 × ZMod L) : (∑ v, C e c v*x v)=CyclicCover.boundary e x c := by
  simp only [Fintype.sum_prod_type,C]
  simp_rw [SourceModel.P_action]
  rfl

def twoFibers (v : Fin 4 × ZMod L) : ZMod 2 := if v.1=0 ∨ v.1=1 then 1 else 0

theorem twoFibers_kernel (e : Fin 3 → Fin 4 → ZMod L) : CyclicCover.Kernel e twoFibers := by
  intro c
  simp only [CyclicCover.boundary,twoFibers,Fin.sum_univ_succ,Fin.sum_univ_zero]
  have ht : (1+1 : ZMod 2)=0 := by decide +kernel
  simpa using ht

theorem twoFibers_nonzero : twoFibers (L := L)≠0 := by
  intro h
  have hh := congrFun h ((0 : Fin 4),(0 : ZMod L))
  norm_num [twoFibers] at hh

theorem nonzero_classical_exists (e : Fin 3 → Fin 4 → ZMod L) :
    ∃ x : CyclicCover.Word (ZMod L), (∀ c, ∑ v, C e c v*x v=0) ∧ x≠0 := by
  refine ⟨twoFibers,?_,twoFibers_nonzero⟩
  intro c
  exact (classical_action e twoFibers c).trans (twoFibers_kernel e c)

/-- Actual binary coefficient-matrix commutation for every monomial3x4 base. -/
theorem css_commutation (e : Fin 3 → Fin 4 → ZMod L) (a : XCheck L) (b : ZCheck L) :
    (∑ q, HZ e b q * HX e a q)=0 := by
  let w : Fin 3 → Fin 4 → ZMod L → ZMod 2 := fun i j s => if ((i,j),s)=a then 1 else 0
  have he : ∀ q, join (stabilizerLeft e w) (stabilizerRight e w) q=HX e a q := by
    intro q
    cases q with
    | inl p =>
      rcases p with ⟨⟨i,j⟩,s⟩
      change stabilizerLeft e w i j s = _
      rw [← x_span_left e w i j s]
      simp [w]
    | inr p =>
      rcases p with ⟨⟨i,j⟩,s⟩
      change stabilizerRight e w i j s = _
      rw [← x_span_right e w i j s]
      simp [w]
  calc
    (∑ q, HZ e b q * HX e a q) =
      ∑ q, HZ e b q * join (stabilizerLeft e w) (stabilizerRight e w) q := by simp only [he]
    _ = Syndrome e (stabilizerLeft e w) (stabilizerRight e w) b.1.1 b.1.2 b.2 := z_action _ _ _ _ _ _
    _ = 0 := coefficient_commutation e w _ _ _

#print axioms css_commutation
end GeneralLP

#print axioms GeneralLP.classical_action
#print axioms GeneralLP.nonzero_classical_exists
