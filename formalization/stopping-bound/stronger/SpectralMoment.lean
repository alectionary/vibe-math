import SpectralPlane
import PartitionBound
open Matrix Finset
namespace StoppingMoment
variable {C V : Type*} [Fintype C] [Fintype V] [DecidableEq C] [DecidableEq V]
/-- Squared Gram eigenvalues are the fourth singular-value moment. -/
lemma eigs_sq_trace (H : Matrix C V ℝ) :
    ∑ i, (StoppingSpectral.eigs H i)^2 = ((H*Hᵀ)*(H*Hᵀ)).trace := by
  let hA := isHermitian_mul_conjTranspose_self H
  have htrace : ((H*Hᵀ)*(H*Hᵀ)).trace = ∑ c, (hA.eigenvalues c)^2 := by
    change ((H*Hᴴ)*(H*Hᴴ)).trace = _
    conv_lhs => rw [hA.spectral_theorem]
    rw [← map_mul]
    simp only [Unitary.conjStarAlgAut_apply]
    rw [Matrix.trace_mul_cycle,Unitary.coe_star_mul_self,one_mul]
    simp [Matrix.diagonal_mul_diagonal,Matrix.trace,pow_two]
  rw [htrace]
  exact Fintype.sum_equiv
    (Fintype.equivOfCardEq (Fintype.card_fin (Fintype.card C))) _ _
    (fun i => by simp [StoppingSpectral.eigs,Matrix.IsHermitian.eigenvalues,hA])

lemma trace_gram_sq (H : Matrix C V ℝ) :
    ((H*Hᵀ)*(H*Hᵀ)).trace = ∑ v, ∑ w, (Hᵀ*H) v w ^ 2 := by
  rw [show (H*Hᵀ)*(H*Hᵀ) = (H*(Hᵀ*H))*Hᵀ by simp only [Matrix.mul_assoc],
    Matrix.trace_mul_cycle]
  unfold Matrix.trace
  apply sum_congr rfl
  intro v _
  change ((Hᵀ*H)*(Hᵀ*H)) v v = _
  rw [Matrix.mul_apply]
  apply sum_congr rfl
  intro w _
  have hs : (Hᵀ*H) w v = (Hᵀ*H) v w := by
    simp only [Matrix.mul_apply,Matrix.transpose_apply]
    apply sum_congr rfl
    intro c _
    ring
  rw [hs,pow_two]

def H (E : V → C → Prop) [DecidableRel E] : Matrix C V ℝ :=
  fun c v => if E v c then 1 else 0
lemma gram_entry (E : V → C → Prop) [DecidableRel E] (v w : V) :
    ((H E)ᵀ*H E) v w = (PartitionStopping.overlap E v w : ℝ) := by
  simp only [Matrix.mul_apply,Matrix.transpose_apply,H]
  have he (c : C) : (if E v c then (1:ℝ) else 0)*(if E w c then 1 else 0) =
      if c ∈ PartitionStopping.neighbors E v ∩ PartitionStopping.neighbors E w then 1 else 0 := by
    by_cases hv : E v c <;> by_cases hw : E w c <;>
      simp [PartitionStopping.neighbors,hv,hw]
  simp_rw [he]
  simp only [Finset.sum_ite_mem_eq,Finset.sum_const,nsmul_eq_mul,mul_one,PartitionStopping.overlap]

lemma overlap_diag (E : V → C → Prop) [DecidableRel E] (v : V) :
    PartitionStopping.overlap E v v = (PartitionStopping.neighbors E v).card := by
  simp [PartitionStopping.overlap]

/-- A zero excess in the fourth-moment budget forces all off-diagonal column
intersections to be at most one. The nonnegative integer entries are essential. -/
theorem overlap_le_one (E : V → C → Prop) [DecidableRel E]
    (hbudget :
      (∑ v,∑ w,(PartitionStopping.overlap E v w : ℝ)^2) =
      (∑ v,(PartitionStopping.overlap E v v : ℝ)^2) +
      (∑ v,∑ w,if v=w then (0:ℝ) else PartitionStopping.overlap E v w)) :
    ∀ v w, v ≠ w → PartitionStopping.overlap E v w ≤ 1 := by
  let f (v w : V) : ℝ := if v=w then 0 else
    (PartitionStopping.overlap E v w : ℝ)^2-PartitionStopping.overlap E v w
  have hn (v w : V) : 0 ≤ f v w := by
    unfold f
    split_ifs
    · rfl
    · have h := Nat.le_mul_self (PartitionStopping.overlap E v w)
      have hr : (PartitionStopping.overlap E v w : ℝ) ≤
          (PartitionStopping.overlap E v w : ℝ)^2 := by exact_mod_cast (by simpa only [pow_two] using h : PartitionStopping.overlap E v w ≤ (PartitionStopping.overlap E v w)^2)
      linarith
  have hs : ∑ v,∑ w, f v w = 0 := by
    have he (v : V) : ∑ w, f v w =
        (∑ w,(PartitionStopping.overlap E v w : ℝ)^2) -
        (PartitionStopping.overlap E v v : ℝ)^2 -
        (∑ w,if v=w then (0:ℝ) else PartitionStopping.overlap E v w) := by
      have hh : ∀ w, f v w = (PartitionStopping.overlap E v w : ℝ)^2 -
          (if v=w then (PartitionStopping.overlap E v v : ℝ)^2 else 0) -
          (if v=w then (0:ℝ) else PartitionStopping.overlap E v w) := by
        intro w
        by_cases h : v=w <;> simp [f,h]
      simp_rw [hh,sum_sub_distrib]
      simp
    simp_rw [he,sum_sub_distrib]
    linarith
  intro v w hvw
  have hzv : ∑ w, f v w = 0 := (sum_eq_zero_iff_of_nonneg (fun v _ => sum_nonneg (fun w _ => hn v w))).mp hs v (mem_univ v)
  have hzw : f v w = 0 := (sum_eq_zero_iff_of_nonneg (fun w _ => hn v w)).mp hzv w (mem_univ w)
  simp only [f,if_neg hvw] at hzw
  by_contra h
  have hi : 2 ≤ PartitionStopping.overlap E v w := by omega
  have hr : (2:ℝ) ≤ PartitionStopping.overlap E v w := by exact_mod_cast hi
  nlinarith
end StoppingMoment
