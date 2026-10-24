import CyclicFourierCount
import Mathlib.Analysis.SpecialFunctions.Complex.CircleAddChar

set_option maxHeartbeats 0
open scoped BigOperators
namespace AbsorbingFourier
variable {N : ℕ} [NeZero N]

theorem standard_character_star (a : ZMod N) :
    star (ZMod.stdAddChar a) = ZMod.stdAddChar (-a) := by
  rw [ZMod.stdAddChar_apply, ZMod.stdAddChar_apply,
    AddChar.map_neg_eq_inv, Circle.coe_inv_eq_conj]
  rfl

theorem standard_character_exp (a : ZMod N) :
    ZMod.stdAddChar a =
      Complex.exp (2 * Real.pi * Complex.I * (a.val : ℂ) / (N : ℂ)) := by
  rw [ZMod.stdAddChar_apply, ZMod.toCircle_apply]

theorem standard_character_unit_norm (a : ZMod N) :
    ‖ZMod.stdAddChar a‖ = 1 := by
  rw [ZMod.stdAddChar_apply]
  exact Circle.norm_coe _

theorem star_mul_eq_norm_sq (z : ℂ) : star z * z = (‖z‖ ^ 2 : ℝ) := by
  simpa only [starRingEnd_apply, Complex.ofReal_pow] using Complex.conj_mul' z

#print axioms standard_character_star
#print axioms standard_character_exp
#print axioms standard_character_unit_norm
#print axioms star_mul_eq_norm_sq
end AbsorbingFourier
