import BicycleBaseCore
namespace Bicycle
set_option maxRecDepth 100000
set_option maxHeartbeats 0
/-- Closed kernel evaluation, no native_decide or numerical certificate premise. -/
lemma root_false : Incidence.survivesList pick row 4 [(false,0)] = false := by decide +kernel
lemma root_true : Incidence.survivesList pick row 4 [(true,0)] = false := by decide +kernel

theorem stopping_ge_six (T : Finset Var) (hT : Incidence.Stopping E T) : 6 ≤ T.card := by
  classical
  by_contra hn
  have hsmall : T.card ≤ 5 := by omega
  obtain ⟨⟨b,j⟩,hv⟩ := hT.1
  let U := T.image (shiftV (-j))
  have hU : Incidence.Stopping E U :=
    Incidence.stopping_image E (shiftV (-j)) (shiftC (-j)) (shift_incidence (-j)) T hT
  have hroot : (b,0) ∈ U := by
    apply Finset.mem_image.mpr
    exact ⟨(b,j),hv,by simp [shiftV]⟩
  have hcard : U.card ≤ 5 := (Finset.card_image_le).trans hsmall
  have hh := Incidence.survivesList_of_stopping E pick row pick_singleton row_complete
    4 [(b,0)] U hU (by simp) (by simpa using hroot) (by simpa using hcard)
  cases b
  · rw [root_false] at hh; contradiction
  · rw [root_true] at hh; contradiction

def six : Finset Var := {(false,0),(false,-5),(false,-4),(true,1),(true,5),(true,6)}
lemma six_card : six.card = 6 := by decide +kernel
lemma six_stopping : Incidence.Stopping E six := by unfold Incidence.Stopping; decide +kernel
lemma column_degree : ∀ v : Var, (PartitionStopping.neighbors E v).card = 4 := by decide +kernel
lemma overlap_bound : ∀ v w : Var, v ≠ w →
    PartitionStopping.overlap E v w ≤ if v.1 = w.1 then 1 else 2 := by decide +kernel

theorem incidence_bound (T : Finset Var) (hT : Incidence.Stopping E T) : 4 ≤ T.card :=
  PartitionStopping.weight_four_bound E Prod.fst T hT
    (fun v _ => by rw [column_degree]) (fun v _ w _ h => overlap_bound v w h)
end Bicycle
