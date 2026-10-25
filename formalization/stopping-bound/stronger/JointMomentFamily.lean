import JointPowers
import MomentBound
namespace JointPowers
open Matrix Finset StoppingSpectral
variable {γ n : ℕ} [NeZero n]
lemma real_matrix : StoppingMoment.H (JointSidon.E (leftMarks γ n) (rightMarks γ n)) =
    JointSidon.X ℝ (leftMarks γ n) (rightMarks γ n) := by
  ext c v
  exact (JointSidon.entry _ _ _ v c).symm
lemma column_degree (hn : 3^(2*γ) ≤ n) (v : Bool × ZMod n) :
    (PartitionStopping.neighbors (JointSidon.E (leftMarks γ n) (rightMarks γ n)) v).card = γ := by
  rw [JointSidon.degree,left_card γ n hn,right_card γ n hn]
  split <;> rfl
lemma row_degree (hn : 3^(2*γ) ≤ n) (c : ZMod n) :
    StoppingMoment.rowWeight (JointSidon.E (leftMarks γ n) (rightMarks γ n)) c = 2*γ := by
  have h := JointSidon.row_weight (leftMarks γ n) (rightMarks γ n) c
  simpa only [StoppingMoment.rowWeight,JointSidon.binary_incidence,left_card γ n hn,
    right_card γ n hn,← two_mul] using h

/-- An exact identity for the actual ordered real Gram eigenvalues. -/
theorem fourth_moment (hn : 3^(2*γ) ≤ n) :
    (∑ i,(eigs (JointSidon.X ℝ (leftMarks γ n) (rightMarks γ n)) i)^2) =
      2*(n:ℝ)*(γ:ℝ)*(3*(γ:ℝ)-1) := by
  have hm := StoppingMoment.moment_of_overlap_one
    (JointSidon.E (leftMarks γ n) (rightMarks γ n))
    (JointSidon.overlap_one _ _ (joint_sidon γ n hn) (disjoint_marks γ n hn))
  rw [real_matrix] at hm
  simp_rw [column_degree hn,row_degree hn] at hm
  simp only [sum_const,card_univ,Fintype.card_prod,Fintype.card_bool,ZMod.card,
    Nat.cast_mul,Nat.cast_ofNat,nsmul_eq_mul] at hm
  nlinarith

/-- The useful bound follows through the universal spectral criterion, rather
than assuming the stopping guarantee as an input. -/
theorem spectral_stopping_bound (hn : 3^(2*γ) ≤ n)
    (U : Finset (Bool × ZMod n)) (hU : Incidence.Stopping
      (JointSidon.E (leftMarks γ n) (rightMarks γ n)) U) : γ+1 ≤ U.card := by
  apply StoppingMoment.regular_spectral_bound
    (JointSidon.E (leftMarks γ n) (rightMarks γ n)) γ (2*γ)
    (column_degree hn) (row_degree hn) _ U hU
  rw [real_matrix,fourth_moment hn]
  simp only [Fintype.card_prod,Fintype.card_bool,ZMod.card,Nat.cast_mul,Nat.cast_ofNat]
  ring
end JointPowers
