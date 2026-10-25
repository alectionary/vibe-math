import FamilyWords
import CoverWeight
set_option maxHeartbeats 0
namespace FamilyTranspose
variable {L : Nat} [NeZero L]
def boundary (x : Fin 3 → ZMod L → ZMod 2) (j : Fin 4) (t : ZMod L) : ZMod 2 :=
  ∑ i : Fin 3, x i (t + (FamilyWords.exponent i j : ZMod L))
def Kernel (x : Fin 3 → ZMod L → ZMod 2) := ∀ j t, boundary x j t = 0
/-- A Laurent polynomial Bezout identity forces the third component to be constant. -/
theorem third_period (x : Fin 3 → ZMod L → ZMod 2) (hx : Kernel x) (t : ZMod L) :
    x 2 (t+1) + x 2 (t+2) = 0 := by
  have h0_1 := hx 0 (t+1)
  have h0_4 := hx 0 (t+4)
  have h0_6 := hx 0 (t+6)
  have h0_7 := hx 0 (t+7)
  have h0_8 := hx 0 (t+8)
  have h0_9 := hx 0 (t+9)
  have h1_0 := hx 1 (t+0)
  have h1_2 := hx 1 (t+2)
  have h1_4 := hx 1 (t+4)
  have h1_8 := hx 1 (t+8)
  have h1_9 := hx 1 (t+9)
  have h2_3 := hx 2 (t+3)
  have h2_4 := hx 2 (t+4)
  have h3_0 := hx 3 (t+0)
  have h3_1 := hx 3 (t+1)
  have h3_2 := hx 3 (t+2)
  have h3_3 := hx 3 (t+3)
  have h3_4 := hx 3 (t+4)
  have h3_6 := hx 3 (t+6)
  have h3_7 := hx 3 (t+7)
  norm_num [boundary,FamilyWords.exponent,Fin.sum_univ_succ,add_assoc] at h0_1 h0_4 h0_6 h0_7 h0_8 h0_9 h1_0 h1_2 h1_4 h1_8 h1_9 h2_3 h2_4 h3_0 h3_1 h3_2 h3_3 h3_4 h3_6 h3_7
  linear_combination (norm := ring_nf) h0_1 + h0_4 + h0_6 + h0_7 + h0_8 + h0_9 + h1_0 + h1_2 + h1_4 + h1_8 + h1_9 + h2_3 + h2_4 + h3_0 + h3_1 + h3_2 + h3_3 + h3_4 + h3_6 + h3_7
  have htwo : (2 : ZMod 2) = 0 := by decide
  have hfour : (4 : ZMod 2) = 0 := by decide
  simp only [htwo,hfour,mul_zero,sub_zero,zero_sub,neg_zero]

#print axioms third_period
end FamilyTranspose
