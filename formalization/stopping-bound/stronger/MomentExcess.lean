import MomentBound
namespace StoppingMoment
open Matrix Finset
variable {C V : Type*} [Fintype C] [Fintype V] [DecidableEq C] [DecidableEq V]
noncomputable def excess (E : V → C → Prop) [DecidableRel E] : ℝ :=
  (∑ i,(StoppingSpectral.eigs (H E) i)^2) +
    (∑ v,((PartitionStopping.neighbors E v).card : ℝ)) -
    (∑ v,((PartitionStopping.neighbors E v).card : ℝ)^2) -
    ∑ c,(rowWeight E c : ℝ)^2

def pairExcess (E : V → C → Prop) [DecidableRel E] (v w : V) : ℝ :=
  if v=w then 0 else (PartitionStopping.overlap E v w : ℝ)^2-PartitionStopping.overlap E v w
lemma pair_nonneg (E : V → C → Prop) [DecidableRel E] (v w : V) : 0 ≤ pairExcess E v w := by
  unfold pairExcess
  split_ifs
  · rfl
  · have h : PartitionStopping.overlap E v w ≤ (PartitionStopping.overlap E v w)^2 := by
      simpa only [pow_two] using Nat.le_mul_self (PartitionStopping.overlap E v w)
    have hr : (PartitionStopping.overlap E v w : ℝ) ≤ (PartitionStopping.overlap E v w : ℝ)^2 := by exact_mod_cast h
    linarith
lemma excess_eq_sum (E : V → C → Prop) [DecidableRel E] :
    excess E = ∑ v,∑ w,pairExcess E v w := by
  have he (v : V) : (∑ w,pairExcess E v w) =
      (∑ w,(PartitionStopping.overlap E v w : ℝ)^2) -
      (PartitionStopping.overlap E v v : ℝ)^2 -
      (∑ w,if v=w then (0:ℝ) else PartitionStopping.overlap E v w) := by
    have hh (w : V) : pairExcess E v w =
        (PartitionStopping.overlap E v w : ℝ)^2 -
        (if v=w then (PartitionStopping.overlap E v v : ℝ)^2 else 0) -
        (if v=w then (0:ℝ) else PartitionStopping.overlap E v w) := by
      by_cases h : v=w <;> simp only [pairExcess,h,↓reduceIte,sub_zero,sub_self,zero_sub]
    simp_rw [hh,sum_sub_distrib]
    simp
  unfold excess
  rw [eigs_sq_trace,trace_gram_sq]
  simp_rw [gram_entry,he,sum_sub_distrib,overlap_diag]
  rw [off_sum]
  ring
lemma pair_symm (E : V → C → Prop) [DecidableRel E] (v w : V) :
    pairExcess E v w = pairExcess E w v := by
  by_cases h : v=w
  · subst w
    rfl
  · unfold pairExcess
    rw [if_neg h,if_neg (Ne.symm h)]
    have hs : PartitionStopping.overlap E v w = PartitionStopping.overlap E w v := by
      exact congrArg Finset.card (Finset.inter_comm _ _)
    rw [hs]

theorem pair_le_excess (E : V → C → Prop) [DecidableRel E] (v w : V) (hne : v ≠ w) :
    2*((PartitionStopping.overlap E v w : ℝ)^2-PartitionStopping.overlap E v w) ≤ excess E := by
  let f : V × V → ℝ := fun p => pairExcess E p.1 p.2
  have hp : (v,w) ≠ (w,v) := fun h => hne (congrArg Prod.fst h)
  have hh : ∑ p ∈ ({(v,w),(w,v)} : Finset (V×V)),f p ≤ ∑ p : V×V,f p := by
    apply sum_le_sum_of_subset_of_nonneg (subset_univ _)
    intro p _ _
    exact pair_nonneg E p.1 p.2
  rw [sum_pair hp] at hh
  simp only [f] at hh
  rw [← pair_symm E v w] at hh
  rw [excess_eq_sum]
  rw [Fintype.sum_prod_type] at hh
  simpa only [pairExcess,if_neg hne,two_mul] using hh

theorem spectral_overlap_bound (E : V → C → Prop) [DecidableRel E] (μ : ℕ)
    (hsmall : excess E < 2*(μ:ℝ)*(μ+1)) :
    ∀ v w, v ≠ w → PartitionStopping.overlap E v w ≤ μ := by
  intro v w hne
  have hh := pair_le_excess E v w hne
  by_contra h
  have hm : μ+1 ≤ PartitionStopping.overlap E v w := by omega
  have hmr : (μ:ℝ)+1 ≤ PartitionStopping.overlap E v w := by exact_mod_cast hm
  have hp : 0 ≤ ((PartitionStopping.overlap E v w : ℝ)+(μ:ℝ))*
      ((PartitionStopping.overlap E v w : ℝ)-(μ:ℝ)-1) := mul_nonneg (by positivity) (by linarith)
  nlinarith

theorem spectral_excess_stopping_bound (E : V → C → Prop) [DecidableRel E] (γ μ : ℕ)
    (hdegree : ∀ v, γ ≤ (PartitionStopping.neighbors E v).card)
    (hsmall : excess E < 2*(μ:ℝ)*(μ+1))
    (S : Finset V) (hS : Incidence.Stopping E S) : γ+μ ≤ μ*S.card :=
  PartitionStopping.uniform_overlap_bound E S hS γ μ (fun v _ => hdegree v)
    (fun v _ w _ hne => spectral_overlap_bound E μ hsmall v w hne)
end StoppingMoment
