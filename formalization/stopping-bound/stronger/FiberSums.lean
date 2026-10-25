import SpectralPlane
namespace StoppingFiber
open Finset
variable {G K : Type*} [AddCommGroup G] [AddCommGroup K] [Fintype G] [Fintype K]
  [DecidableEq G] [DecidableEq K]
noncomputable def fiberEquiv (q : G →+ K) (hq : Function.Surjective q) (d : K) :
    {x : G // q x = 0} ≃ {x : G // q x = d} := by
  classical
  let a := Classical.choose (hq d)
  have ha : q a = d := Classical.choose_spec (hq d)
  exact {
    toFun := fun x => ⟨x.1+a,by simp [x.2,ha]⟩
    invFun := fun x => ⟨x.1-a,by simp [x.2,ha]⟩
    left_inv := fun x => by ext; simp
    right_inv := fun x => by ext; simp }

theorem pullback_sum (q : G →+ K) (hq : Function.Surjective q) (f : K → ℝ) :
    ∑ x, f (q x) = (Fintype.card {x : G // q x = 0} : ℝ) * ∑ d, f d := by
  classical
  rw [← Fintype.sum_fiberwise' q f,Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro d _
  simp only [Finset.sum_const,Finset.card_univ,nsmul_eq_mul]
  rw [Fintype.card_congr (fiberEquiv q hq d)]

theorem kernel_card_pos (q : G →+ K) : 0 < Fintype.card {x : G // q x = 0} := by
  have : Nonempty {x : G // q x = 0} := ⟨⟨0,map_zero q⟩⟩
  exact Fintype.card_pos
end StoppingFiber
