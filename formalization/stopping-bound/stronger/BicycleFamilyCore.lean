import BicycleBaseCore
import IncidenceCover
set_option linter.unusedSimpArgs false
namespace Bicycle.Family
abbrev Check (n : ℕ) := ZMod n
abbrev Var (n : ℕ) := Bool × Check n

def col {n : ℕ} (v : Var n) : List (Check n) :=
  if v.1 then [v.2,v.2-1,v.2-4,v.2-6] else [v.2,v.2+1,v.2+4,v.2+6]
def E {n : ℕ} (v : Var n) (c : Check n) : Prop := c ∈ col v
instance {n : ℕ} : DecidableRel (@E n) := fun _ _ => inferInstanceAs (Decidable (_ ∈ _))
def row {n : ℕ} (c : Check n) : List (Var n) :=
  [(false,c),(false,c-1),(false,c-4),(false,c-6),
   (true,c),(true,c+1),(true,c+4),(true,c+6)]
def projC {n : ℕ} (h : 39 ∣ n) : Check n → Bicycle.Check := ZMod.castHom h (ZMod 39)
def projV {n : ℕ} (h : 39 ∣ n) (v : Var n) : Bicycle.Var := (v.1,projC h v.2)
lemma project_col {n : ℕ} (h : 39 ∣ n) (v : Var n) :
    (col v).map (projC h) = Bicycle.col (projV h v) := by
  rcases v with ⟨b,j⟩
  cases b <;> simp only [col,Bicycle.col,projC,projV,Bool.false_eq_true,↓reduceIte,List.map_cons,List.map_nil,map_add,map_sub,map_one,map_ofNat]
lemma project_row {n : ℕ} (h : 39 ∣ n) (c : Check n) :
    (row c).map (projV h) = Bicycle.row (projC h c) := by
  simp only [row,Bicycle.row,projV,projC,List.map_cons,List.map_nil,map_add,map_sub,map_one,map_ofNat]
lemma row_complete {n : ℕ} (v : Var n) (c : Check n) (h : E v c) : v ∈ row c := by
  rcases v with ⟨b,j⟩
  cases b <;> simp only [E,col,Bool.false_eq_true,↓reduceIte,List.mem_cons,
    List.not_mem_nil,or_false] at h
  all_goals rcases h with h | h | h | h
  all_goals subst c
  all_goals simp [row,sub_eq_add_neg,add_assoc,add_comm,add_left_comm]
lemma maps {n : ℕ} (h : 39 ∣ n) (v : Var n) (c : Check n) (he : E v c) :
    Bicycle.E (projV h v) (projC h c) := by
  have hm : projC h c ∈ (col v).map (projC h) := List.mem_map.mpr ⟨c,he,rfl⟩
  simpa only [project_col,Bicycle.E] using hm
lemma lifts {n : ℕ} (h : 39 ∣ n) (v : Var n) (d : Bicycle.Check)
    (he : Bicycle.E (projV h v) d) : ∃ c, E v c ∧ projC h c = d := by
  change d ∈ Bicycle.col (projV h v) at he
  rw [← project_col] at he
  exact List.mem_map.mp he
lemma base_row_nodup : ∀ c : Bicycle.Check, (Bicycle.row c).Nodup := by decide +kernel
lemma base_col_nodup : ∀ v : Bicycle.Var, (Bicycle.col v).Nodup := by decide +kernel
lemma local_inj {n : ℕ} (h : 39 ∣ n) (v w : Var n) (c : Check n)
    (hv : E v c) (hw : E w c) (he : projV h v = projV h w) : v = w := by
  have hn : ((row c).map (projV h)).Nodup := by
    rw [project_row]; exact base_row_nodup _
  exact List.inj_on_of_nodup_map hn (row_complete v c hv) (row_complete w c hw) he
lemma col_nodup {n : ℕ} (h : 39 ∣ n) (v : Var n) : (col v).Nodup := by
  apply List.Nodup.of_map (projC h)
  rw [project_col]
  exact base_col_nodup _

/-- A partner at every selected incidence is equivalent to excluding degree one. -/
lemma stopping_of_partners {V C : Type*} [DecidableEq V] [DecidableEq C]
    (E : V → C → Prop) [DecidableRel E] (S : Finset V) (hne : S.Nonempty)
    (hp : ∀ v ∈ S, ∀ c, E v c → ∃ w ∈ S, w ≠ v ∧ E w c) : Incidence.Stopping E S := by
  classical
  refine ⟨hne,?_⟩
  intro c hc
  obtain ⟨v,hv⟩ := Finset.card_eq_one.mp hc
  have hvm : v ∈ S.filter (fun w => E w c) := by rw [hv]; simp
  obtain ⟨w,hw,hwv,hwc⟩ := hp v (Finset.mem_filter.mp hvm).1 c (Finset.mem_filter.mp hvm).2
  have hwm : w ∈ S.filter (fun u => E u c) := Finset.mem_filter.mpr ⟨hw,hwc⟩
  have : w = v := by simpa [hv] using hwm
  exact hwv this

def sixList {n : ℕ} : List (Var n) :=
  [(false,0),(false,-5),(false,-4),(true,1),(true,5),(true,6)]
def six {n : ℕ} : Finset (Var n) := sixList.toFinset
lemma project_sixList {n : ℕ} (h : 39 ∣ n) :
    (@sixList n).map (projV h) = @sixList 39 := by
  simp only [sixList,projV,projC,List.map_cons,List.map_nil,map_zero,map_one,map_ofNat,map_neg]
theorem six_card {n : ℕ} (h : 39 ∣ n) : (@six n).card = 6 := by
  have hm : ((@sixList n).map (projV h)).Nodup := by
    rw [project_sixList]; decide
  have hn := List.Nodup.of_map (projV h) hm
  simpa [six,sixList] using List.toFinset_card_of_nodup hn

theorem six_stopping {n : ℕ} (h : 39 ∣ n) : Incidence.Stopping E (@six n) := by
  apply stopping_of_partners E six
  · exact ⟨(false,0),by simp [six,sixList]⟩
  intro v hv c hc
  simp only [six,sixList,List.toFinset_cons,List.toFinset_nil,
    Finset.mem_insert,Finset.mem_singleton,Finset.notMem_empty,or_false] at hv
  rcases hv with hv | hv | hv | hv | hv | hv <;> subst v
  · simp only [E,col,Bool.false_eq_true,↓reduceIte,List.mem_cons,List.not_mem_nil,or_false] at hc
    rcases hc with hc | hc | hc | hc <;> subst c
    · refine ⟨(false,-4),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(false,-5),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(true,5),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(true,6),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
  · simp only [E,col,Bool.false_eq_true,↓reduceIte,List.mem_cons,List.not_mem_nil,or_false] at hc
    rcases hc with hc | hc | hc | hc <;> subst c
    · refine ⟨(true,1),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(false,-4),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(true,5),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(false,0),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
  · simp only [E,col,Bool.false_eq_true,↓reduceIte,List.mem_cons,List.not_mem_nil,or_false] at hc
    rcases hc with hc | hc | hc | hc <;> subst c
    · refine ⟨(false,-5),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(true,1),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(false,0),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(true,6),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
  · simp only [E,col,Bool.false_eq_true,↓reduceIte,List.mem_cons,List.not_mem_nil,or_false] at hc
    rcases hc with hc | hc | hc | hc <;> subst c
    · refine ⟨(false,0),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(false,0),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(false,-4),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(false,-5),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
  · simp only [E,col,Bool.false_eq_true,↓reduceIte,List.mem_cons,List.not_mem_nil,or_false] at hc
    rcases hc with hc | hc | hc | hc <;> subst c
    · refine ⟨(true,6),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(false,0),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(false,0),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(false,-5),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
  · simp only [E,col,Bool.false_eq_true,↓reduceIte,List.mem_cons,List.not_mem_nil,or_false] at hc
    rcases hc with hc | hc | hc | hc <;> subst c
    · refine ⟨(false,0),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(true,5),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(false,-4),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]
    · refine ⟨(false,0),by simp [six,sixList],?_,?_⟩
      · intro heq
        have hh := congrArg (projV h) heq
        simp only [projV,projC,map_zero,map_one,map_ofNat,map_neg,Prod.mk.injEq] at hh
        norm_num at hh <;> (revert hh; decide +kernel)
      · norm_num [E,col]

end Bicycle.Family
