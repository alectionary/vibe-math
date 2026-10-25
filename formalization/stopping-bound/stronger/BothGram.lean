import RealGramBound
namespace SidonStopping
open Matrix Finset
variable {G : Type*} [Fintype G] [AddCommGroup G] [DecidableEq G]
def badZReal (S : Finset G) : Matrix G (Bool × G) ℝ :=
  GramStopping.doubled (circulant (coeff ℝ S))ᵀ
lemma badZReal_entry (S : Finset G) (c : G) (v : Bool × G) :
    badZReal S c v = if v.2-c ∈ S then 1 else 0 := rfl
lemma badZBinary_entry (S : Finset G) (c : G) (v : Bool × G) :
    BadZ S c v = if v.2-c ∈ S then 1 else 0 := rfl
lemma bad_z_real_gram (S : Finset G) :
    badZReal S*(badZReal S)ᵀ = X ℝ S*(X ℝ S)ᵀ := by
  unfold badZReal X
  rw [GramStopping.doubled_gram,GramStopping.paired_gram,transpose_transpose]
  have hc : circulant (coeff ℝ S)*(circulant (coeff ℝ S))ᵀ =
      (circulant (coeff ℝ S))ᵀ*circulant (coeff ℝ S) := by
    rw [transpose_circulant,circulant_mul_comm]
  rw [hc]

theorem separate_grams_equal (S : Finset G) :
    (X ℝ S*(X ℝ S)ᵀ,X ℝ S*(X ℝ S)ᵀ) =
      (BadX ℝ S*(BadX ℝ S)ᵀ,badZReal S*(badZReal S)ᵀ) :=
  Prod.ext (gram_equal S) (bad_z_real_gram S).symm

/-- Both separate check Grams still omit cross-sector and binary-rank data. -/
theorem both_gram_only_bound (S : Finset G)
    (lower : (Matrix G G ℝ × Matrix G G ℝ) → ℝ)
    (valid_bad : ∀ U : Finset (Bool × G), Incidence.Stopping (badE S) U →
      lower (BadX ℝ S*(BadX ℝ S)ᵀ,badZReal S*(badZReal S)ᵀ) ≤ (U.card : ℝ)) :
    lower (X ℝ S*(X ℝ S)ᵀ,X ℝ S*(X ℝ S)ᵀ) ≤ 2 := by
  rw [separate_grams_equal]
  have h := valid_bad twin (twin_stopping S)
  simpa only [twin_card,Nat.cast_ofNat] using h
end SidonStopping
