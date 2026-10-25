import SidonBad
import KernelStopping
namespace SidonStopping
open Matrix Finset
variable {G : Type*} [Fintype G] [AddCommGroup G] [DecidableEq G]
def twinWord (v : Bool × G) : ZMod 2 := if v.2 = 0 then 1 else 0
lemma twinWord_support : BinaryStopping.support (twinWord (G := G)) = twin := by
  ext ⟨b,j⟩
  cases b <;> simp [BinaryStopping.support,twinWord,twin]
lemma twinWord_weight : (BinaryStopping.support (twinWord (G := G))).card = 2 := by
  rw [twinWord_support,twin_card]
lemma twinWord_kernel (S : Finset G) : (BadX (ZMod 2) S).mulVec twinWord = 0 := by
  funext c
  simp only [Matrix.mulVec,dotProduct,BadX,GramStopping.doubled,twinWord]
  rw [Fintype.sum_prod_type]
  simp only [Fintype.sum_bool]
  exact (show ∀ x : ZMod 2, x+x=0 by decide) _
lemma twinWord_parity : leftParity (twinWord (G := G)) = 1 := by
  simp [leftParity,twinWord]
lemma bad_left_row_sum (S : Finset G) (c : G) :
    (∑ j, BadZ S c (false,j)) = (S.card : ZMod 2) := by
  change (∑ j, coeff (ZMod 2) S (j-c)) = _
  rw [← coefficient_sum S]
  exact Fintype.sum_equiv (Equiv.subRight c) _ _ (fun _ => rfl)
lemma bad_stabilizer_parity (S : Finset G) (he : Even S.card) (a : G → ZMod 2) :
    leftParity ((BadZ S)ᵀ.mulVec a) = 0 := by
  have hz : (S.card : ZMod 2) = 0 := by
    rw [ZMod.natCast_eq_zero_iff]
    exact even_iff_two_dvd.mp he
  unfold leftParity
  simp only [Matrix.mulVec,dotProduct,transpose_apply]
  rw [sum_comm]
  simp_rw [← sum_mul,bad_left_row_sum,hz,zero_mul]
  simp

theorem twinWord_not_stabilizer (S : Finset G) (he : Even S.card) :
    ¬ ∃ a : G → ZMod 2, (BadZ S)ᵀ.mulVec a = twinWord := by
  rintro ⟨a,ha⟩
  have hp := bad_stabilizer_parity S he a
  rw [ha,twinWord_parity] at hp
  exact (by decide : (1:ZMod 2) ≠ 0) hp
end SidonStopping

namespace SidonStopping
open Matrix Finset
variable {G : Type*} [Fintype G] [AddCommGroup G] [DecidableEq G]
lemma bad_kernel_weight_two (S : Finset G) (hS : S.Nonempty)
    (x : Bool × G → ZMod 2) (hx : x ≠ 0) (hk : (BadX (ZMod 2) S).mulVec x = 0) :
    2 ≤ (BinaryStopping.support x).card := by
  have he : BinaryStopping.matrix (badE S) = BadX (ZMod 2) S := by
    ext c v
    exact (bad_entry _ S v c).symm
  have hs := BinaryStopping.kernel_stopping (badE S) x hx (by simpa only [he] using hk)
  exact bad_lower_two S hS _ hs

lemma bad_z_kernel_weight_two (S : Finset G) (hS : S.Nonempty)
    (x : Bool × G → ZMod 2) (hx : x ≠ 0) (hk : (BadZ S).mulVec x = 0) :
    2 ≤ (BinaryStopping.support x).card := by
  let E' : (Bool × G) → G → Prop := fun v c => BadZ S c v = 1
  have he : BinaryStopping.matrix E' = BadZ S := by
    ext c v
    exact (show ∀ z : ZMod 2, (if z=1 then 1 else 0)=z by decide) _
  have hs := BinaryStopping.kernel_stopping E' x hx (by simpa only [he] using hk)
  apply Bicycle.Family.positive_stopping_ge_two E' _ _ hs
  intro v
  obtain ⟨s,hs⟩ := hS
  refine ⟨v.2-s,?_⟩
  change (if v.2-(v.2-s) ∈ S then (1:ZMod 2) else 0) = 1
  simp [hs]

theorem bad_quantum_distance_two (S : Finset G) (hS : S.Nonempty) (he : Even S.card) :
    BadX (ZMod 2) S * (BadZ S)ᵀ = 0 ∧
    (∀ x : Bool × G → ZMod 2, x ≠ 0 → (BadX (ZMod 2) S).mulVec x = 0 →
      2 ≤ (BinaryStopping.support x).card) ∧
    (∀ x : Bool × G → ZMod 2, x ≠ 0 → (BadZ S).mulVec x = 0 →
      2 ≤ (BinaryStopping.support x).card) ∧
    (BadX (ZMod 2) S).mulVec twinWord = 0 ∧
    (¬ ∃ a : G → ZMod 2, (BadZ S)ᵀ.mulVec a = twinWord) ∧
    (BinaryStopping.support (twinWord (G := G))).card = 2 :=
  ⟨bad_css S,bad_kernel_weight_two S hS,bad_z_kernel_weight_two S hS,twinWord_kernel S,
    twinWord_not_stabilizer S he,twinWord_weight⟩
end SidonStopping
