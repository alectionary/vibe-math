module

public import IncidenceFamilySource

@[expose] public section
set_option linter.unusedSimpArgs false
set_option linter.unusedSectionVars false
namespace Incidence.Family
variable {n : ℕ}

lemma row_sound (v : Var n) (c : Check n) (h : v ∈ row c) : E v c := by
  rcases c with ⟨i,g⟩
  simp only [row,List.mem_cons,List.not_mem_nil,or_false] at h
  rcases h with rfl | rfl | rfl | rfl | rfl | rfl <;> simp [E,col]

lemma row_nodup (h : 63 ∣ n) (c : Check n) : (row c).Nodup := by
  have hm : ((row c).map (projV h)).Nodup := by
    rw [project_row]; exact base_row_nodup _
  exact List.Nodup.of_map (projV h) hm

theorem column_weight [NeZero n] (h : 63 ∣ n) (v : Var n) :
    (Finset.univ.filter (fun c => HX c v = 1)).card = 3 := by
  have heq : Finset.univ.filter (fun c => HX c v = 1) = (col v).toFinset := by
    ext c
    simp only [Finset.mem_filter,Finset.mem_univ,true_and,List.mem_toFinset,HX_incidence h,E]
  rw [heq,List.toFinset_card_of_nodup (col_nodup h v)]
  rcases v with ⟨b,j,f⟩
  cases b <;> rfl

theorem row_weight [NeZero n] (h : 63 ∣ n) (c : Check n) :
    (Finset.univ.filter (fun v => HX c v = 1)).card = 6 := by
  have heq : Finset.univ.filter (fun v => HX c v = 1) = (row c).toFinset := by
    ext v
    simp only [Finset.mem_filter,Finset.mem_univ,true_and,List.mem_toFinset,HX_incidence h]
    exact ⟨row_complete v c,row_sound v c⟩
  rw [heq,List.toFinset_card_of_nodup (row_nodup h c)]
  rfl

theorem dimensions [NeZero n] :
    Fintype.card (Var n) = 14*n ∧ Fintype.card (Check n) = 7*n := by
  simp [Var,Check]
  omega
end Incidence.Family
