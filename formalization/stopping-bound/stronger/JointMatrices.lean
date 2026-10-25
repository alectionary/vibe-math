import JointSidon
namespace JointSidon
open Matrix Finset
variable {G : Type*} [Fintype G] [AddCommGroup G] [DecidableEq G]
lemma coeff_sum (R : Type*) [CommSemiring R] (S : Finset G) :
    ∑ j, SidonStopping.coeff R S j = (S.card : R) := by
  simp [SidonStopping.coeff,← sum_filter]
lemma left_sum (R : Type*) [CommSemiring R] (S T : Finset G) (c : G) :
    (∑ j, X R S T c (false,j)) = (S.card : R) := by
  change (∑ j, SidonStopping.coeff R S (c-j)) = _
  rw [← coeff_sum R S]
  exact Fintype.sum_equiv (Equiv.subLeft c) _ _ (fun _ => rfl)
lemma right_sum (R : Type*) [CommSemiring R] (S T : Finset G) (c : G) :
    (∑ j, X R S T c (true,j)) = (T.card : R) := by
  change (∑ j, SidonStopping.coeff R T (j-c)) = _
  rw [← coeff_sum R T]
  exact Fintype.sum_equiv (Equiv.subRight c) _ _ (fun _ => rfl)
lemma row_sum (R : Type*) [CommSemiring R] (S T : Finset G) (c : G) :
    (∑ v, X R S T c v) = ((S.card+T.card : ℕ) : R) := by
  rw [Fintype.sum_prod_type]
  simp only [Fintype.sum_bool,left_sum,right_sum,Nat.cast_add]
  ring
lemma column_weight (S T : Finset G) (v : Bool × G) :
    (univ.filter (fun c => X (ZMod 2) S T c v = 1)).card =
      if v.1 then T.card else S.card := by
  simpa only [binary_incidence,PartitionStopping.neighbors] using degree S T v
lemma row_weight (S T : Finset G) (c : G) :
    (univ.filter (fun v => X (ZMod 2) S T c v = 1)).card = S.card+T.card := by
  have hsum : (∑ v, X ℝ S T c v) =
      ((univ.filter (fun v => E S T v c)).card : ℝ) := by
    simp only [entry]
    rw [← Finset.sum_filter]
    simp
  have hh := row_sum ℝ S T c
  rw [hsum] at hh
  simp only [binary_incidence]
  exact_mod_cast hh

lemma left_kernel (S T : Finset G) (he : Even S.card) :
    (X (ZMod 2) S T).mulVec (SidonStopping.leftOnes (G := G)) = 0 := by
  have hz : (S.card : ZMod 2) = 0 := by
    rw [ZMod.natCast_eq_zero_iff]
    exact even_iff_two_dvd.mp he
  funext c
  simp only [Matrix.mulVec,dotProduct,SidonStopping.leftOnes]
  rw [Fintype.sum_prod_type]
  simp only [Fintype.sum_bool,Bool.false_eq_true,↓reduceIte,mul_zero,mul_one,sum_const_zero,add_zero,zero_add]
  exact (left_sum _ S T c).trans hz
lemma stabilizer_parity (S T : Finset G) (he : Even T.card) (a : G → ZMod 2) :
    SidonStopping.leftParity ((Z S T)ᵀ.mulVec a) = 0 := by
  have hz : (T.card : ZMod 2) = 0 := by
    rw [ZMod.natCast_eq_zero_iff]
    exact even_iff_two_dvd.mp he
  unfold SidonStopping.leftParity
  simp only [Matrix.mulVec,dotProduct,transpose_apply,Z]
  rw [sum_comm]
  simp_rw [← sum_mul,left_sum,hz,zero_mul]
  simp

theorem left_not_stabilizer (S T : Finset G) (he : Even T.card)
    (ho : Odd (Fintype.card G)) :
    ¬ ∃ a : G → ZMod 2, (Z S T)ᵀ.mulVec a = SidonStopping.leftOnes := by
  rintro ⟨a,ha⟩
  have hp := stabilizer_parity S T he a
  rw [ha] at hp
  have hsum : SidonStopping.leftParity (SidonStopping.leftOnes (G := G)) =
      (Fintype.card G : ZMod 2) := by
    simp [SidonStopping.leftParity,SidonStopping.leftOnes]
  rw [hsum,ZMod.natCast_eq_zero_iff] at hp
  exact (Nat.not_even_iff_odd.mpr ho) (even_iff_two_dvd.mpr hp)
end JointSidon
