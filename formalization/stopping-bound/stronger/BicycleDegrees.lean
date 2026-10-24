import BicycleMatrices
namespace Bicycle.Family
variable {n : ℕ}
lemma row_sound (v : Var n) (c : Check n) (h : v ∈ row c) : E v c := by
  simp only [row,List.mem_cons,List.not_mem_nil,or_false] at h
  rcases h with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> simp [E,col]
lemma row_nodup (h : 39 ∣ n) (c : Check n) : (row c).Nodup := by
  apply List.Nodup.of_map (projV h)
  rw [project_row]
  exact base_row_nodup _

theorem degree_four [NeZero n] (h : 39 ∣ n) (v : Var n) :
    (PartitionStopping.neighbors E v).card = 4 := by
  have heq : PartitionStopping.neighbors E v = (col v).toFinset := by
    ext c
    simp [PartitionStopping.neighbors,E]
  rw [heq,List.toFinset_card_of_nodup (col_nodup h v)]
  rcases v with ⟨b,j⟩
  cases b <;> rfl

theorem row_weight_eight [NeZero n] (h : 39 ∣ n) (c : Check n) :
    (Finset.univ.filter (fun v => HX (ZMod 2) c v = 1)).card = 8 := by
  have heq : Finset.univ.filter (fun v => HX (ZMod 2) c v = 1) = (row c).toFinset := by
    ext v
    simp only [Finset.mem_filter,Finset.mem_univ,true_and,List.mem_toFinset,HX2_incidence]
    exact ⟨row_complete v c,row_sound v c⟩
  rw [heq,List.toFinset_card_of_nodup (row_nodup h c)]
  rfl

theorem dimensions [NeZero n] : Fintype.card (Var n) = 2*n ∧ Fintype.card (Check n) = n := by
  simp [Var,Check]

/-- Reduction modulo 39 is injective on the checks incident with one column. -/
theorem column_local_inj (h : 39 ∣ n) (v : Var n) (c d : Check n)
    (hc : E v c) (hd : E v d) (he : projC h c = projC h d) : c = d := by
  have hn : ((col v).map (projC h)).Nodup := by
    rw [project_col]; exact base_col_nodup _
  exact List.inj_on_of_nodup_map hn hc hd he

end Bicycle.Family
