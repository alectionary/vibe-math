import RowCancellation
import SupportSingletons
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords
variable {L : ℕ} [NeZero L]

theorem rowU_indicator (e : Fin 3 → Fin 4 → ZMod L)
    (H : Fin 3) (K : Fin 4) (z : ZMod L) (j k : Fin 4) (s : ZMod L) :
    rowU e H K z j k s=if k=K ∧ s=z-e H j then 1 else 0 := by
  have ht : z=s+e H j ↔ s=z-e H j := by
    rw [eq_sub_iff_add_eq]
    exact eq_comm
  simp [rowU,GeneralLP.HX,GeneralLP.P,SourceModel.P,ht,ite_and,eq_comm]

theorem rowV_indicator (e : Fin 3 → Fin 4 → ZMod L)
    (H : Fin 3) (K : Fin 4) (z : ZMod L) (l i : Fin 3) (s : ZMod L) :
    rowV e H K z l i s=if l=H ∧ s=z+e i K then 1 else 0 := by
  have ht : z=s+ -e i K ↔ s=z+e i K := by
    constructor <;> intro h <;> linear_combination -h
  simp [rowV,GeneralLP.HX,GeneralLP.P,SourceModel.P,ht,ite_and,eq_comm]

/-- Constant labels on actual singleton supports identify the complete source
stabilizer row, including every right coordinate. -/
theorem constant_singleton_rows {J : Type*} [Nonempty J]
    (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (a : J → Fin 4) (K : Fin 4) (H : Fin 3)
    (s : J → ZMod L) (t : Fin 3 → ZMod L)
    (hu : ∀ j k' s',u (a j) k' s'=if k'=K ∧ s'=s j then 1 else 0)
    (hv : ∀ i l' t',v l' i t'=if l'=H ∧ t'=t i then 1 else 0) :
    ∃ z,(∀ j,u (a j)=rowU e H K z (a j)) ∧ v=rowV e H K z := by
  have hc (j : J) (i : Fin 3) : s j+e i K=t i-e H (a j) :=
    singleton_source_check_matches e u v hk (a j) K i H (s j) (t i) (hu j) (hv i)
  obtain ⟨z,hs,ht⟩ := constant_label_fibers e a (fun i : Fin 3 => i) K H s t hc
  refine ⟨z,?_,?_⟩
  · intro j
    funext k' s'
    rw [hu,rowU_indicator,hs j]
  · funext l' i t'
    rw [hv,rowV_indicator,ht i]

/-- The constant-label weight-seven profile is exactly one HX row. -/
theorem constant_all_singletons_stabilizer
    (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (K : Fin 4) (H : Fin 3) (s : Fin 4 → ZMod L) (t : Fin 3 → ZMod L)
    (hu : ∀ j k' s',u j k' s'=if k'=K ∧ s'=s j then 1 else 0)
    (hv : ∀ i l' t',v l' i t'=if l'=H ∧ t'=t i then 1 else 0) :
    GeneralLP.InSpanX e u v := by
  obtain ⟨z,hu',hv'⟩ := constant_singleton_rows e u v hk (fun j : Fin 4 => j) K H s t hu hv
  have he : u=rowU e H K z := funext hu'
  rw [he,hv']
  exact source_row_full_span e H K z

/-- The constant-label weight-eleven profile cancels against a complete HX row;
the remaining at-most-six pure U coordinates vanish below classical distance. -/
theorem constant_exception_singletons_stabilizer
    (e : Fin 3 → Fin 4 → ZMod L) (D : ℕ) (hD : 6<D) (hC : ClassicalAtLeast e D)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (j₀ : Fin 4) (hU : leftCount u j₀≤5)
    (K : Fin 4) (H : Fin 3) (s : {j : Fin 4 // j≠j₀} → ZMod L) (t : Fin 3 → ZMod L)
    (hu : ∀ j k' s',u j.val k' s'=if k'=K ∧ s'=s j then 1 else 0)
    (hv : ∀ i l' t',v l' i t'=if l'=H ∧ t'=t i then 1 else 0) :
    GeneralLP.InSpanX e u v := by
  have hnon : Nonempty {j : Fin 4 // j≠j₀} := by
    obtain ⟨j,hj⟩ := exists_ne j₀
    exact ⟨⟨j,hj⟩⟩
  letI := hnon
  obtain ⟨z,hu',hv'⟩ := constant_singleton_rows e u v hk Subtype.val K H s t hu hv
  exact single_exception_cancellation e D hD hC u (rowU e H K z) v (rowV e H K z) hk
    (source_row_full_span e H K z) j₀ hU (by rw [source_row_left_count])
    (fun j hj => hu' ⟨j,hj⟩) hv'

#print axioms constant_all_singletons_stabilizer
#print axioms constant_exception_singletons_stabilizer
end TruncatedDistance
