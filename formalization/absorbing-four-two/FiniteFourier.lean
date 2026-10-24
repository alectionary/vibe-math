import Mathlib.Algebra.Group.AddChar
import Mathlib.Algebra.Star.BigOperators
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Data.Fintype.Prod
import Mathlib.Tactic.Ring

set_option maxHeartbeats 0
open scoped BigOperators

namespace AbsorbingFourier
variable {G K : Type*} [Fintype G] [DecidableEq G] [CommRing G]
    [CommRing K] [IsDomain K] [StarRing K]

/-- Unnormalized finite transform. For ZMod ell and the standard character this
is the negative-exponent DFT convention in the written formula. -/
def dft (ψ : AddChar G K) (f : G → K) (j : G) : K :=
  ∑ a : G, ψ (-(j*a)) * f a

theorem orthogonality (ψ : AddChar G K) (hinj : Function.Injective ψ) (t : G) :
    (∑ j : G, ψ (j*t)) = if t = 0 then (Fintype.card G : K) else 0 := by
  classical
  by_cases ht : t = 0
  · simp [ht]
  · have hχ : ψ.mulShift t ≠ 0 := by
      intro heq
      have he := congrArg (fun χ : AddChar G K => χ 1) heq
      have hψ : ψ t = ψ 0 := by simpa using he
      exact ht (hinj hψ)
    have h := AddChar.sum_eq_ite (ψ.mulShift t)
    simpa [AddChar.mulShift_apply,hχ,ht,mul_comm] using h

theorem parseval (ψ : AddChar G K) (hinj : Function.Injective ψ)
    (hstar : ∀ a, star (ψ a) = ψ (-a)) (f g : G → K) :
    (∑ j : G, star (dft ψ f j) * dft ψ g j) =
      (Fintype.card G : K) * ∑ a : G, star (f a) * g a := by
  classical
  simp only [dft,star_sum,star_mul',hstar,neg_neg,Finset.sum_mul,Finset.mul_sum]
  conv_lhs =>
    arg 2
    ext j
    rw [Finset.sum_comm]
  rw [Finset.sum_comm]
  have hinner (a : G) :
      (∑ j : G, ∑ b : G, (ψ (j*a) * star (f a)) * (ψ (-(j*b)) * g b)) =
        (Fintype.card G : K) * (star (f a) * g a) := by
    rw [Finset.sum_comm]
    have hp (b j : G) :
        (ψ (j*a) * star (f a)) * (ψ (-(j*b)) * g b) =
          ψ (j*(a-b)) * (star (f a) * g b) := by
      calc
        _ = (ψ (j*a) * ψ (-(j*b))) * (star (f a) * g b) := by ring
        _ = ψ (j*a + -(j*b)) * (star (f a) * g b) := by rw [AddChar.map_add_eq_mul]
        _ = _ := by congr 2; ring
    simp_rw [hp, ← Finset.sum_mul, orthogonality ψ hinj]
    simp [sub_eq_zero,mul_ite,ite_mul]
  exact Finset.sum_congr rfl (fun a _ => hinner a)

#print axioms parseval
end AbsorbingFourier
