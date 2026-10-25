import SpectralMoment
namespace StoppingMoment
open Matrix Finset
variable {C V : Type*} [Fintype C] [Fintype V] [DecidableEq C] [DecidableEq V]
def rowWeight (E : V → C → Prop) [DecidableRel E] (c : C) : ℕ :=
  (univ.filter (fun v => E v c)).card
lemma row_sum (E : V → C → Prop) [DecidableRel E] (c : C) :
    (∑ v, H E c v) = (rowWeight E c : ℝ) := by
  unfold H rowWeight
  rw [← Finset.sum_filter]
  simp
lemma overlap_sum (E : V → C → Prop) [DecidableRel E] :
    (∑ v,∑ w,(PartitionStopping.overlap E v w : ℝ)) =
      ∑ c, (rowWeight E c : ℝ)^2 := by
  simp_rw [← gram_entry]
  simp only [Matrix.mul_apply,Matrix.transpose_apply]
  have he (v : V) : (∑ w,∑ c,H E c v*H E c w) = ∑ c,∑ w,H E c v*H E c w := sum_comm
  simp_rw [he]
  rw [sum_comm]
  apply sum_congr rfl
  intro c _
  rw [← row_sum]
  simp only [pow_two,mul_sum,sum_mul]
  exact sum_comm
lemma off_sum (E : V → C → Prop) [DecidableRel E] :
    (∑ v,∑ w,if v=w then (0:ℝ) else PartitionStopping.overlap E v w) =
      (∑ c,(rowWeight E c : ℝ)^2) - ∑ v,((PartitionStopping.neighbors E v).card : ℝ) := by
  have he (v : V) : (∑ w,if v=w then (0:ℝ) else PartitionStopping.overlap E v w) =
      (∑ w,(PartitionStopping.overlap E v w : ℝ)) - PartitionStopping.overlap E v v := by
    have hh (w : V) : (if v=w then (0:ℝ) else PartitionStopping.overlap E v w) =
        (PartitionStopping.overlap E v w : ℝ) -
        (if v=w then (PartitionStopping.overlap E v v : ℝ) else 0) := by
      by_cases h : v=w <;> simp [h]
    simp_rw [hh,sum_sub_distrib]
    simp
  simp_rw [he,sum_sub_distrib,overlap_diag]
  rw [overlap_sum]

/-- A spectral equality, with a degree correction, forces intersection<=1.
This is the zero-four-cycle moment criterion behind source Lemma4.8. -/
theorem spectral_overlap_one (E : V → C → Prop) [DecidableRel E]
    (hmoment : (∑ i,(StoppingSpectral.eigs (H E) i)^2) +
        (∑ v,((PartitionStopping.neighbors E v).card : ℝ)) =
      (∑ v,((PartitionStopping.neighbors E v).card : ℝ)^2) +
        ∑ c,(rowWeight E c : ℝ)^2) :
    ∀ v w, v ≠ w → PartitionStopping.overlap E v w ≤ 1 := by
  apply overlap_le_one E
  rw [eigs_sq_trace,trace_gram_sq] at hmoment
  simp_rw [gram_entry] at hmoment
  simp_rw [overlap_diag]
  rw [off_sum]
  linarith

theorem spectral_stopping_bound (E : V → C → Prop) [DecidableRel E] (γ : ℕ)
    (hdegree : ∀ v, γ ≤ (PartitionStopping.neighbors E v).card)
    (hmoment : (∑ i,(StoppingSpectral.eigs (H E) i)^2) +
        (∑ v,((PartitionStopping.neighbors E v).card : ℝ)) =
      (∑ v,((PartitionStopping.neighbors E v).card : ℝ)^2) +
        ∑ c,(rowWeight E c : ℝ)^2)
    (S : Finset V) (hS : Incidence.Stopping E S) : γ+1 ≤ S.card := by
  have h := PartitionStopping.uniform_overlap_bound E S hS γ 1
    (fun v _ => hdegree v) (fun v _ w _ hne => spectral_overlap_one E hmoment v w hne)
  simpa using h

/-- The converse supplies the actual spectral certificate for explicit families. -/
theorem moment_of_overlap_one (E : V → C → Prop) [DecidableRel E]
    (hone : ∀ v w, v ≠ w → PartitionStopping.overlap E v w ≤ 1) :
    (∑ i,(StoppingSpectral.eigs (H E) i)^2) +
        (∑ v,((PartitionStopping.neighbors E v).card : ℝ)) =
      (∑ v,((PartitionStopping.neighbors E v).card : ℝ)^2) +
        ∑ c,(rowWeight E c : ℝ)^2 := by
  rw [eigs_sq_trace,trace_gram_sq]
  simp_rw [gram_entry]
  have he (v : V) : (∑ w,(PartitionStopping.overlap E v w : ℝ)^2) =
      (PartitionStopping.overlap E v v : ℝ)^2 +
      (∑ w,if v=w then (0:ℝ) else PartitionStopping.overlap E v w) := by
    have hh (w : V) : (PartitionStopping.overlap E v w : ℝ)^2 =
        (if v=w then (PartitionStopping.overlap E v v : ℝ)^2 else 0) +
        (if v=w then (0:ℝ) else PartitionStopping.overlap E v w) := by
      by_cases hvw : v=w
      · simp [hvw]
      · have hb := hone v w hvw
        have hc : PartitionStopping.overlap E v w = 0 ∨ PartitionStopping.overlap E v w = 1 := by omega
        rcases hc with hc | hc <;> simp [hvw,hc]
    calc
      _ = ∑ w, ((if v=w then (PartitionStopping.overlap E v v : ℝ)^2 else 0) +
          (if v=w then (0:ℝ) else PartitionStopping.overlap E v w)) :=
        sum_congr rfl (fun w _ => hh w)
      _ = _ := by rw [sum_add_distrib]; simp
  simp_rw [he,sum_add_distrib,overlap_diag]
  rw [off_sum]
  ring

/-- Regular form. It uses all ordered Gram eigenvalues, including multiplicity;
there is no second-eigenvalue small-gap or excluded-small-branch premise. -/
theorem regular_spectral_bound (E : V → C → Prop) [DecidableRel E] (γ k : ℕ)
    (hcol : ∀ v, (PartitionStopping.neighbors E v).card = γ)
    (hrow : ∀ c, rowWeight E c = k)
    (hmoment : (∑ i,(StoppingSpectral.eigs (H E) i)^2) + (Fintype.card V : ℝ)*γ =
      (Fintype.card V : ℝ)*(γ:ℝ)^2 + (Fintype.card C : ℝ)*(k:ℝ)^2)
    (S : Finset V) (hS : Incidence.Stopping E S) : γ+1 ≤ S.card := by
  apply spectral_stopping_bound E γ (fun v => by rw [hcol]) _ S hS
  simpa only [hcol,hrow,sum_const,card_univ,nsmul_eq_mul] using hmoment
end StoppingMoment
